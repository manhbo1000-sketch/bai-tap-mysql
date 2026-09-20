-- ============================================================
-- File: autoride_db.sql
-- Dự án: AutoRide - Hệ thống cho thuê xe tự lái
-- Nhiệm vụ: Nâng cấp CSDL Legacy → CSDL tối ưu
--           (khắc phục 3 Data Gaps của quy trình Thuê & Trả xe)
-- Sinh viên: .....................
-- Lớp: .....................
-- ============================================================

DROP DATABASE IF EXISTS autoride_db;
CREATE DATABASE autoride_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE autoride_db;

-- ============================================================
-- PHẦN 1: TÁI TẠO BẢNG CARS (giữ nguyên từ Legacy)
-- ============================================================
CREATE TABLE Cars (
    car_id        INT AUTO_INCREMENT PRIMARY KEY,
    model_name    VARCHAR(100) NOT NULL,
    license_plate VARCHAR(20)  UNIQUE NOT NULL
) ENGINE=InnoDB;

-- ============================================================
-- PHẦN 2: NÂNG CẤP BẢNG RENTALS
-- Khắc phục:
--   LỖI 1: status VARCHAR → ENUM để khóa vòng đời hợp đồng
--   LỖI 2: Bổ sung 3 cột tài chính (security_deposit, late_fee, damage_fee)
--          dùng DECIMAL(12,2) để tránh sai số tiền tệ (không dùng FLOAT)
-- ============================================================
CREATE TABLE Rentals (
    rental_id        INT AUTO_INCREMENT PRIMARY KEY,
    car_id           INT NOT NULL,
    customer_name    VARCHAR(100) NOT NULL,
    rent_date        DATETIME     NOT NULL,
    return_date      DATETIME     NULL,

    -- [FIX 1] Trạng thái dùng ENUM để chặn giá trị rác
    status           ENUM('BOOKED','ACTIVE','COMPLETED','CANCELLED')
                     NOT NULL DEFAULT 'BOOKED',

    -- [FIX 2] Bổ sung các cột tài chính
    security_deposit DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    late_fee         DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    damage_fee       DECIMAL(12,2) NOT NULL DEFAULT 0.00,

    -- Ràng buộc logic nghiệp vụ
    CONSTRAINT chk_deposit_non_negative
        CHECK (security_deposit >= 0),
    CONSTRAINT chk_fees_non_negative
        CHECK (late_fee >= 0 AND damage_fee >= 0),
    CONSTRAINT chk_return_after_rent
        CHECK (return_date IS NULL OR return_date >= rent_date),

    -- Khóa ngoại tới Cars: không cho xóa xe nếu còn hợp đồng
    CONSTRAINT fk_rentals_car
        FOREIGN KEY (car_id) REFERENCES Cars(car_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ============================================================
-- PHẦN 3: TẠO BẢNG INSPECTIONS (Biên bản kiểm tra xe)
-- Khắc phục LỖI 3: Trước đây không có chỗ để ghi nhận chi tiết
--                  xe bị hư hỏng ở vị trí nào.
-- Quan hệ: 1 Rental — N Inspections (một hợp đồng có thể có
--          nhiều biên bản: kiểm tra lúc giao xe + lúc nhận xe)
-- ============================================================
CREATE TABLE Inspections (
    inspection_id      INT AUTO_INCREMENT PRIMARY KEY,
    rental_id          INT NOT NULL,
    inspection_date    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    damage_description TEXT     NULL,
    inspector_name     VARCHAR(100) NOT NULL,

    -- Khóa ngoại: RESTRICT để bảo toàn lịch sử biên bản
    CONSTRAINT fk_inspections_rental
        FOREIGN KEY (rental_id) REFERENCES Rentals(rental_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Index hỗ trợ truy vấn theo hợp đồng
CREATE INDEX idx_inspections_rental ON Inspections(rental_id);

-- ============================================================
-- PHẦN 4: DML — MÔ PHỎNG KỊCH BẢN THỰC TẾ
-- Kịch bản: "Nguyen Van A" trả xe trễ 2 ngày + vỡ đèn pha trái
-- ============================================================

-- 4.1. Nhập xe vào hệ thống
INSERT INTO Cars (model_name, license_plate) VALUES
('Toyota Vios 2023', '51A-12345'),
('Honda City 2022',  '51A-67890');

-- 4.2. Khách "Nguyen Van A" đặt xe, đóng cọc 10.000.000 VNĐ
--      Trạng thái BOOKED → sau đó chuyển ACTIVE khi nhận xe
INSERT INTO Rentals
    (car_id, customer_name, rent_date, return_date,
     status, security_deposit, late_fee, damage_fee)
VALUES
    (1, 'Nguyen Van A',
     '2024-06-01 08:00:00',
     '2024-06-05 08:00:00',
     'ACTIVE',
     10000000.00, 0.00, 0.00);

-- 4.3. Nhân viên ghi biên bản kiểm tra khi khách TRẢ XE
--      Phát hiện: Vỡ đèn pha trái
INSERT INTO Inspections (rental_id, inspection_date, damage_description, inspector_name)
VALUES
    (1, '2024-06-07 10:30:00',
     N'Vỡ đèn pha trái, xước cản trước bên phải',
     N'Trần Văn B (Nhân viên kỹ thuật)');

-- 4.4. Cập nhật hợp đồng sau khi trả xe:
--      Trễ 2 ngày → late_fee = 400.000
--      Vỡ đèn pha → damage_fee = 2.000.000
--      Trạng thái → COMPLETED
UPDATE Rentals
SET status      = 'COMPLETED',
    return_date = '2024-06-07 10:30:00',
    late_fee    = 400000.00,
    damage_fee  = 2000000.00
WHERE rental_id = 1;

-- ============================================================
-- PHẦN 5: TRUY VẤN NGHIỆP VỤ
-- Tính số tiền thực tế cần HOÀN TRẢ cho khách
-- Công thức: refund = security_deposit - late_fee - damage_fee
-- ============================================================
SELECT
    r.rental_id,
    r.customer_name,
    c.model_name              AS car_model,
    r.security_deposit,
    r.late_fee,
    r.damage_fee,
    (r.security_deposit - r.late_fee - r.damage_fee) AS refund_amount,
    r.status,
    (SELECT GROUP_CONCAT(i.damage_description SEPARATOR '; ')
     FROM Inspections i
     WHERE i.rental_id = r.rental_id) AS damage_notes
FROM Rentals r
JOIN Cars c ON c.car_id = r.car_id
WHERE r.rental_id = 1;

-- Kết quả kỳ vọng:
-- security_deposit = 10.000.000
-- late_fee         =    400.000
-- damage_fee       =  2.000.000
-- refund_amount    =  7.600.000 VNĐ
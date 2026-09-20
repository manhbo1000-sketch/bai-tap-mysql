-- ============================================================
-- File: QuanLySinhVien_GroupBy_2.sql
-- Bài tập: Luyện tập hàm thông dụng và GROUP BY trong MySQL
-- CSDL: QuanLySinhVien
-- Sinh viên: .....................
-- Lớp: .....................
-- ============================================================

USE QuanLySinhVien;

-- ============================================================
-- YÊU CẦU 1:
-- Hiển thị tất cả các thông tin môn học (bảng Subject)
-- có credit LỚN NHẤT.
-- ------------------------------------------------------------
-- Ý tưởng: Tìm Max(Credit) bằng subquery, rồi lọc ra các môn
--          có Credit = Max đó (dùng ALL để xử lý nhiều môn đồng hạng).
-- ============================================================
SELECT *
FROM Subject
WHERE Credit >= ALL (
    SELECT Credit FROM Subject
);

-- Cách viết tương đương với MAX (dễ đọc hơn):
-- SELECT * FROM Subject
-- WHERE Credit = (SELECT MAX(Credit) FROM Subject);

-- ============================================================
-- YÊU CẦU 2:
-- Hiển thị các thông tin môn học có ĐIỂM THI lớn nhất.
-- (Tức là những môn có điểm thi cao nhất trong bảng Mark)
-- ------------------------------------------------------------
-- Lưu ý: 1 môn có thể có nhiều bản ghi Mark (nhiều SV cùng thi)
--        → dùng ALL để lấy TẤT CẢ các môn có Mark = Max.
-- ============================================================
SELECT Sub.*
FROM Subject Sub
JOIN Mark M ON Sub.SubId = M.SubId
WHERE M.Mark >= ALL (
    SELECT Mark FROM Mark
);

-- ============================================================
-- YÊU CẦU 3:
-- Hiển thị thông tin sinh viên và ĐIỂM TRUNG BÌNH của mỗi
-- sinh viên, sắp xếp theo điểm trung bình GIẢM DẦN.
-- ============================================================
SELECT S.StudentId,
       S.StudentName,
       S.Address,
       AVG(M.Mark) AS 'DiemTrungBinh'
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName, S.Address
ORDER BY DiemTrungBinh DESC;
-- ============================================================
-- File: QuanLySinhVien_GroupBy.sql
-- Bài tập: Luyện tập hàm thông dụng và GROUP BY trong MySQL
-- CSDL: QuanLySinhVien
-- Sinh viên: .....................
-- Lớp: .....................
-- ============================================================

USE QuanLySinhVien;

-- ============================================================
-- YÊU CẦU 1: Hiển thị số lượng sinh viên ở từng nơi
-- ============================================================
SELECT Address,
       COUNT(StudentId) AS 'Số lượng học viên'
FROM Student
GROUP BY Address;

-- ============================================================
-- YÊU CẦU 2: Tính điểm trung bình các môn học của mỗi học viên
-- ============================================================
SELECT S.StudentId,
       S.StudentName,
       AVG(M.Mark) AS 'Điểm trung bình'
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName;

-- ============================================================
-- YÊU CẦU 3: Hiển thị học viên có điểm trung bình > 15
-- (Dùng HAVING để lọc sau khi GROUP BY)
-- ============================================================
SELECT S.StudentId,
       S.StudentName,
       AVG(M.Mark) AS 'Điểm trung bình'
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(M.Mark) > 15;

-- ============================================================
-- YÊU CẦU 4: Hiển thị thông tin học viên có điểm trung bình LỚN NHẤT
-- (Dùng HAVING + ALL với subquery)
-- ============================================================
SELECT S.StudentId,
       S.StudentName,
       AVG(M.Mark) AS 'Điểm trung bình'
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName
HAVING AVG(M.Mark) >= ALL (
    SELECT AVG(Mark)
    FROM Mark
    GROUP BY Mark.StudentId
);
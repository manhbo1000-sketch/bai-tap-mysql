-- ============================================================
-- File: QuanLySinhVien_GroupBy_2.sql
-- Bài tập: GROUP BY trong MySQL
-- Sinh viên: .....................
-- Lớp: .....................
-- ============================================================

USE QuanLySinhVien;

-- ============================================================
-- YÊU CẦU 1: Môn học có credit lớn nhất
-- ============================================================
SELECT *
FROM Subject
WHERE Credit >= ALL (SELECT Credit FROM Subject);


-- ============================================================
-- YÊU CẦU 2: Môn học có điểm thi lớn nhất
-- ============================================================
SELECT Sub.*
FROM Subject Sub
JOIN Mark M ON Sub.SubId = M.SubId
WHERE M.Mark >= ALL (SELECT Mark FROM Mark);


-- ============================================================
-- YÊU CẦU 3: Sinh viên + Điểm trung bình, xếp giảm dần
-- ============================================================
SELECT S.StudentId,
       S.StudentName,
       S.Address,
       AVG(M.Mark) AS DiemTrungBinh
FROM Student S
JOIN Mark M ON S.StudentId = M.StudentId
GROUP BY S.StudentId, S.StudentName, S.Address
ORDER BY DiemTrungBinh DESC;
-- ***** DATABASE
-- COURSE(CourseNo,Description,Cost,Prerequisite,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
-- STUDENT(StudentID,Salutation,FirstName,LastName,Address,Phone,Employer,RegistrationDate,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
-- CLASS(ClassID,CourseNo,ClassNo,StartDateTime,Location,InstructorID,Capacity,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate )
-- ENROLLMENT(StudentID,ClassID,EnrollDate,FinalGrade,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)
-- INSTRUCTOR(InstructorID,Salutation, FirstName,LastName,Address,Phone,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate )
-- GRADE(StudentID,ClassID,Grade,Comments,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate)

-- ***** HOMEWORK
-- 1) Viết các lệnh thực hiện những công việc sau:
--     a. Tạo một bảng Cau1 với 2 cột ID (number) và NAME (varchar2(20)).
CREATE TABLE Cau1(
    ID NUMBER,
    NAME VARCHAR2(20),
)
--     b. Tạo một sequence Cau1Seq với bước tăng là 5.
CREATE SEQUENCE Cau1Seq INCREMENT BY 5
--     c. Khai báo 2 biến v_name và v_id. Biến v_name, v_id. dùng để chứa giá trị họ, mã của sinh viên được thêm vào.
DECLARE v_id Cau1.ID%TYPE;
DECLARE v_name Cau1."Name"%TYPE;
--     d. Thêm vào bảng Cau1 tên của sinh viên đã đăng kí trong các môn học (bảng enrollment) nhiều nhất. 
--          Mã sinh viên sẽ được lấy từ sequence Cau1Seq. Sau thao tác này tạo Savepoint A.
INSERT INTO Cau1 VALUE (Cau1Seq.NEXTVAL,SELECT STUDENT.LASTNAME 
                                        FROM STUDENT,ENROLLMENT 
                                        WHERE STUDENT.StudentID=ENROLLMENT.StudentID
                                        GROUP BY STUDENT.STUDENTID
                                        HAVING COUNT(*)>=(SELECT COUNT(*)
                                                        FROM ENROLLMENT
                                                        GROUP BY FROM ENROLLMENT.STUDENTID
                                                        )
                        )
SAVEPOINT A;
--     e. Thêm vào bảng Cau1 tên của sinh viên đã đăng kí trong các môn học (bảng enrollment) ít nhất.
--          Mã sinh viên sẽ được lấy từ sequence Cau1Seq. Sau thao tác này tạo Savepoint B.
INSERT INTO Cau1 VALUE (Cau1Seq.NEXTVAL,SELECT STUDENT.LASTNAME 
                                        FROM STUDENT,ENROLLMENT 
                                        WHERE STUDENT.StudentID=ENROLLMENT.StudentID
                                        GROUP BY STUDENT.STUDENTID
                                        HAVING COUNT(*)<=(SELECT COUNT(*)
                                                        FROM ENROLLMENT
                                                        GROUP BY FROM ENROLLMENT.STUDENTID
                                                        )
                        )
SAVEPOINT B;
--     f. Làm tương tự đối với các giáo viên có số lượng môn học dạy nhiều nhất. Sau thao tác này tạo Savepoint C.
INSERT INTO Cau1 VALUE (Cau1Seq.NEXTVAL,SELECT INSTRUCTOR.LASTNAME 
                                        FROM INSTRUCTOR,CLASS 
                                        WHERE INSTRUCTOR.InstructorID=CLASS.InstructorID
                                        GROUP BY INSTRUCTOR.InstructorID
                                        HAVING COUNT(*)>=(SELECT COUNT(*)
                                                        FROM CLASS
                                                        GROUP BY FROM CLASS.InstructorID
                                                        )
                        )
SAVEPOINT C;
--     g. Sử dụng câu lệnh SELECT INTO, chứa giá trị của giáo viên có tên tương ứng v_name vào biến v_id.
SELECT "name" into v_name from Cau1 Where Cau1.id=15
SELECT id INTO v_id from Cau1 where Cau1."name"=v_name
--     h. Undo giáo viên được thêm vào sử dụng rollback.
ROLLBACK TO SAVEPOINT B;
--     i. Thêm vào bảng Cau1 giáo viên dạy ít môn học nhất nhưng mã thêm vào không lấy từ sequence mà lấy mã của giáo viên bị rollback truớc đó.
INSERT INTO Cau1 VALUE (v_id,SELECT INSTRUCTOR.LASTNAME 
                                        FROM INSTRUCTOR,CLASS 
                                        WHERE INSTRUCTOR.InstructorID=CLASS.InstructorID
                                        GROUP BY INSTRUCTOR.InstructorID
                                        HAVING COUNT(*)>=(SELECT COUNT(*)
                                                        FROM CLASS
                                                        GROUP BY FROM CLASS.InstructorID
                                                        )
                        )
--     j. Làm lại câu f với ID là lấy từ sequence.
INSERT INTO Cau1 VALUE (Cau1Seq.NEXTVAL,SELECT INSTRUCTOR.LASTNAME 
                                        FROM INSTRUCTOR,CLASS 
                                        WHERE INSTRUCTOR.InstructorID=CLASS.InstructorID
                                        GROUP BY INSTRUCTOR.InstructorID
                                        HAVING COUNT(*)>=(SELECT COUNT(*)
                                                        FROM CLASS
                                                        GROUP BY FROM CLASS.InstructorID
                                                        )
                        )
-- 2) Viết một đoạn chương trình: người dùng nhập vào mã sinh viên.
--      Nếu sinh viên đó tồn tại thì hiển thị ra họ tên sinh viên và số lớp sinh viên đó đang học.
--      Ngươc lại, yêu cầu người dùng thêm vào sinh viên mới với mã số vừa nhập,
--      các thông tin khác (họ, tên sinh viên, địa chỉ nguời dùng sẽ nhập vào).


-- 3) Viết một đoạn mã lệnh: Người dùng nhập vào mã của một giáo viên, xác định số lượng lớp mà giáo viên này đang dạy.
--      Nếu số lớp lớn hơn hoặc bằng 5 thì đưa ra một thông báo: “Giáo viên này nên nghỉ ngơi!”,
--      ngược lại in ra số lớp giáo viên này đang dạy.

-- 4) Viết một đoạn mã lệnh (dùng cấu trúc case): Người dùng nhập vào mã của một sinh viên, mã lớp mà sinh viên này đang học.
--      In ra điểm chữ của sinh viên này: A(90-100), B(80-90), C(70-80), D(50-70) F(0-50).
--      Đồng thời in thông báo lỗi tương ứng khi người dùng nhập mã sinh viên hay mã lớp không tồn tại.


-- 5) Viết một đoạn chương trình in ra thông tin các môn học và các lớp học thuộc môn học, số lượng sinh viên đăng kí lớp học như sau:
--      Trong đó: “20 Intro to Computers” : 20 là mã môn học (courseno),
--      Intro to Computers: là tên môn học (description);
--      “Lop: 2 co so luong sinh vien dang ki: 3”
--           2 là mã lớp học của môn tương ứng (classid), 3 là số lương sinh viên đăng kí lớp học này (count(*)).
-- Gợi ý: Tạo hai con trỏ (con trỏ sau có đối số là mã môn học), duyệt lần lượt 2 con trỏ này lồng nhau.

-- 6) Viết 2 thủ tục
--     a. Thủ tục find_sname có 1 thông số truyền vào (i_student_id),
--      và 2 thông số trả về (o_first_name ,o_last_name) là họ và tên tương ứng của sinh viên với mã số truyền vào.

--     b. Thủ tục print_student_name in ra tên của sinh viên với mã số là đối số truyền vào của thủ tục.

-- 7) Viết thủ tục Discount giảm giá 5% cho tất cả các môn học có số sinh viên đăng kí nhiều hơn 15 sinh viên.
--      Ứng với mỗi môn học được giảm giá in ra tên môn học đó.

-- 8) Viết hàm Total_cost_for_student nhận vào mã số của sinh viên tra về tổng chi phí mà sinh viên đó phải trả.
--      Trả về NULL nếu không tồn tại sinh viên tương ứng.

-- 9) Viết trigger cho các tác vụ thêm vào (insert), hay cập nhật (update) cho tất cả các bảng trong
--      lược đồ quan hệ với các trường created_by, created_date, modified_by, modified_date,
--      sẽ do trigger này thêm vào tương ứng với user hiện tại, ngày hệ thống hiện tại.
-- Gợi ý: Dùng các hàm USER, SYSDATE để lấy được người dùng hiện tại, và ngày giờ của hệ thống.

-- 10) Viết trigger hiện thực yêu cầu sau: mỗi sinh viên không được đăng kí quá 4 môn họ
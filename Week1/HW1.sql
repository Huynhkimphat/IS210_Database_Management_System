-- ***** DATABASE
-- s_region(id,name) 
-- s_warehouse(id,region_id,address,city,state,country,zip_code,phone,manager_id) 
-- s_title(title)
-- s_dept(id,name,region_id)
-- s_emp(id,last_name,first_name,userid,start_date,comments,manager_id,title,dept_id,salary,commission_pct)
-- s_customer(id,name,phone,address,city,state,country,zip_code,credit_rating,sales_rep_id,region_id,comments)
-- s_image(id,format,use_filename,filename,image) 
-- s_longtext(id,use_filename,filename,text) 
-- s_product(id,name,short_desc,longtext_id,image_id,suggested_whlsl_price,whlsl_units)
-- s_ord(id,customer_id,date_ordered,date_shipped,sales_rep_id,total,payment_type,order_filled)
-- s_item(ord_id,item_id,product_id,price,quantity,quantity_shipped) 
-- s_inventory(product_id,warehouse_id,amount_in_stock,reorder_point,max_in_stock,out_of_stock_explanation,restock_date)

-- ***** HOMEWORK
-- ! 1) Tạo câu truy vấn thể hiện tên, mã khách hàng. Tên các cột là Tên khách hàng, Mã khách hàng.
--   Sắp xếp kết quả theo thứ tự giảm dần của mã khách hàng.
SELECT S_CUSTOMER."NAME",S_CUSTOMER.ID 
FROM S_CUSTOMER
ORDER BY S_CUSTOMER.ID DESC
-- ! 2) Chạy câu truy vấn. Xem câu truy vấn vừa chạy trong vùng đệm SQL (bằng lệnh edit). 
--      Sau đó lưu kết quả SQL vào file tên KH.sql.
SELECT S_CUSTOMER."NAME",S_CUSTOMER.ID 
FROM S_CUSTOMER
ORDER BY S_CUSTOMER.ID DESC

EDIT KH.sql
-- ! 3) Mở xem file KH.sql (bằng lệnh edit tên-file), đóng file và thực hiện câu truy vấn trong KH.sql 
--      (chính là thao tác đưa KH.sql vào vùng đệm SQL bằng lệnh Start hoặc @tên-file).
--      Tiếp theo mở file KH.sql sửa lại câu truy vấn thành truy vấn bảng khác, ví dụ s_region. Lưu và chạy file này.
--      Mở vùng đệm xem lại câu truy vấn.
EDIT KH.sql
...
-- ! 4) Hiển thị tên truy cập của nhân viên 23.
SELECT USERID 
FROM S_CUSTOMER 
WHERE S_CUSTOMER.ID=23
-- ! 5) Hiển thị họ, tên và mã phòng của nhân viên trong phòng 10, 50 và sắp theo thứ tự của tên.
--      Nối 2 cột họ  tên và đặt tên cột mới là Employees.
SELECT S_EMP.last_name || ' ' || S_EMP.first_name EMPLOYEE ,S_EMP.DEPT_ID  
FROM S_EMP
WHERE S_EMP.DEPT_ID IN (10,50)
ORDER BY S_EMP.first_name ASC
-- ! 6) Hiển thị tất cả những nhân viên có tên chứa chữ “S”.
SELECT S_EMP.last_name, S_EMP.first_name 
FROM  S_EMP
WHERE S_EMP.last_name LIKE '%S%'
OR S_EMP.first_name LIKE '%S%'
-- ! 7) Hiển thị tên truy nhập và ngày bắt đầu làm việc của nhân viên trong khoảng thời gian từ 14/5/1990 đến 26/5/1991.
SELECT S_EMP.ID,S_EMP.START_DATE
FROM S_EMP
WHERE S_EMP.START_DATE 
BETWEEN TO_DATE('14/05/1990', 'DD/MM/YYYY')
AND TO_DATE('26/05/1991', 'DD/MM/YY') 
-- ! 8) Viết câu truy vấn hiển thị tên và mức lương của tất cả các nhân viên nhận lương từ 1000 đến 2000/tháng.
SELECT S_EMP.last_name || ' ' || S_EMP.first_name EMPLOYEE ,S_EMP.SALARY
FROM S_EMP
WHERE S_EMP.SALARY BETWEEN 1000 AND 2000  

-- ! 9) Lập danh sách tên và mức lương của những nhân viên ở phòng 31, 42, 50 nhận mức lương trên 1350. 
--      Đặt tên cho cột tên là Emloyee Name và đặt tên cho cột lương là Monthly Salary.
SELECT S_EMP.first_name "EMPLOYEE NAME" , S_EMP.SALARY "MONTHLY SALARY"
FROM S_EMP
WHERE S_EMP.DEPT_ID IN (31,42,50)
AND S_EMP.SALARY>1350
-- ! 10) Hiển thị tên và ngày bắt đầu làm việc của mỗi nhân viên được thuê trong năm 1991.
SELECT S_EMP.last_name || ' ' || S_EMP.first_name EMPLOYEE, S_EMP.START_DATE
FROM S_EMP
WHERE EXTRACT(YEAR FROM S_EMP.START_DATE)=1991
    -- • Các loại hàm trong SQL
-- ! 11) Hiển thị mã nhân viên, tên và mức lương được tăng thêm 15%.
SELECT ID,S_EMP.last_name || ' ' || S_EMP.first_name EMPLOYEE,SALARY
FROM S_EMP 
WHERE S_EMP.COMMISSION_PCT =0.15
-- ! 12) Hiển thị tên của mỗi nhân viên, ngày tuyển dụng và ngày xem xét tăng lương.
-- Ngày xét tăng lương theo qui định là vào ngày thứ hai sau 6 tháng làm việc. Định dạng ngày xem xét theo kiểu “Eighth of May 1992”.

-- ! 13) Hiển thị tên sản phẩm của tất cả các sản phẩm có chữ “ski”.
SELECT S_PRODUCT."NAME" 
FROM S_PRODUCT
WHERE S_PRODUCT."NAME" LIKE '%Ski%'
-- ! 14) Với mỗi nhân viên, hãy tính số tháng thâm niên của nhân viên.  Sắp xếp kết quả tăng dần theo tháng thâm niên và số tháng được làm tròn.
SELECT ID, MONTHS_BETWEEN(CURRENT_DATE,S_EMP.START_DATE)
FROM S_EMP
-- ! 15) Cho biết có bao nhiêu người quản lý.
SELECT COUNT(S_EMP.ID) 
FROM S_EMP 
WHERE S_EMP.ID in (
    SELECT DISTINCT 
    S_EMP.MANAGER_ID 
    FROM S_EMP 
)
-- ! 16) Hiển thị mức cao nhất và mức thấp nhất của đơn hàng trong bảng S_ORD. Đặt tên các cột tương ứng là Highest và Lowest.
SELECT MAX(S_ORD.TOTAL) "Highest" , MIN(S_ORD.TOTAL) "Lowest"
FROM S_ORD
    -- • Phép kết
-- ! 17) Hiển thị tên sản phẩm, mã sản phẩm và số lượng từng sản phẩm trong  đơn đặt hàng có mã số 101. Cột số lượng được đặt tên là ORDERED.
SELECT S_PRODUCT."NAME" ,S_PRODUCT.ID, S_ITEM.QUANTITY "ORDERED"
FROM S_PRODUCT, S_ITEM
WHERE S_PRODUCT.id=S_ITEM.PRODUCT_ID
AND S_ITEM.ORD_ID=101
-- ! 18) Hiển thị mã khách hàng và mã đơn đặt hàng của tất cả khách hàng, kể cả những khách hàng chưa đặt hàng. Sắp xếp danh sách theo mã khách hàng.
SELECT S_CUSTOMER.ID,S_ORD.ID
FROM S_CUSTOMER LEFT JOIN S_ORD ON S_CUSTOMER.ID = S_ORD.CUSTOMER_ID
ORDER BY S_CUSTOMER.ID
-- ! 19) Hiển thị mã khách hàng, mã sản phẩm và số lượng đặt hàng của các đơn đặt hàng có trị giá trên 100.000.
SELECT S_CUSTOMER.ID,S_ITEM.ID,S_ITEM.QUANTITY
FROM S_CUSTOMER,S_ITEM,S_ORD
WHERE S_CUSTOMER.ID=S_ORD.CUSTOMER_ID
AND S_ORD.ID=S_ITEM.ORD_ID
WHERE S_ORD.TOTAL>100.000
-- ! 20) Hiển thị họ tên của tất cả các nhân viên không phải là người quản lý.
SELECT S_EMP.last_name || ' ' || S_EMP.first_name EMPLOYEE
FROM S_EMP 
WHERE S_EMP.ID not in (
    SELECT DISTINCT 
    S_EMP.MANAGER_ID 
    FROM S_EMP 
)
-- ! 21) Hiện thị theo thứ tự abc tất cả những sản phẩm có tên bắt đầu với từ Pro.
SELECT S_PRODUCT."NAME" 
FROM S_PRODUCT
WHERE S_PRODUCT."NAME" LIKE 'Pro%'
ORDER BY S_PRODUCT."NAME"
-- ! 22) Hiển thị tên sản phẩm và mô tả ngắn gọn (SHORT_DESC) của sản phẩm với những sản phẩm có mô tả ngắn gọn chứa từ “bicycle”.
SELECT S_PRODUCT."NAME", S_PRODUCT.short_desc
FROM S_PRODUCT
WHERE S_PRODUCT.short_desc LIKE '%bicycle%'
-- ! 23) Hiển thị tất cả những SHORT_DESC.
SELECT S_PRODUCT.short_desc
FROM S_PRODUCT
-- ! 24) Hiển thị tên nhân viên và chức vụ trong ngoặc đơn “( )” của tất cả các nhân viên. Ví dụ: Nguyễn Văn Tâm (Giám đốc).
SELECT S_EMP.last_name || ' ' || S_EMP.first_name EMPLOYEE || '(' || S_EMP.title || ')'
FROM S_EMP
    -- • Các hàm gom nhóm
-- ! 25) Với từng người quản lý, cho biết mã người quản lý và số nhân  viên  mà họ quản lý.
SELECT S_EMP.MANAGER_ID,COUNT(*) EMPLOYEE
FROM S_EMP
GROUP BY (S_EMP.MANAGER_ID)
ORDER BY S_EMP.MANAGER_ID
-- ! 26) Hiển thị những người quản lý 20 nhân viên trở lên.
SELECT S_EMP.MANAGER_ID,COUNT(*) EMPLOYEE
FROM S_EMP
GROUP BY S_EMP.MANAGER_ID
ORDER BY S_EMP.MANAGER_ID
HAVING COUNT(*) >= 20
-- ! 27) Cho biết mã vùng, tên vùng và số phòng ban trực thuộc trong mỗi vùng.
SELECT S_REGION.ID, S_REGION."NAME", COUNT(*) "WAREHOUSE"
FROM S_REGION, S_WAREHOUSE
WHERE S_WAREHOUSE.REGION_ID=S_REGION.ID
GROUP BY S_REGION.ID
ORDER BY S_REGION.ID
-- ! 28) Hiển thị tên khách hàng và số lượng đơn đặt hàng của mỗi khách hàng.
SELECT S_CUSTOMER."NAME",COUNT(*) "ORDER"
FROM S_CUSTOMER, S_ORD
WHERE S_CUSTOMER.ID=S_ORD.CUSTOMER_ID
GROUP BY S_CUSTOMER.ID
ORDER BY S_CUSTOMER.ID
-- ! 29) Cho biết khách hàng có số đơn đặt hàng nhiều nhất.
SELECT S_CUSTOMER.ID, S_CUSTOMER."NAME"
FROM S_CUSTOMER
WHERE S_CUSTOMER.ID IN (
    SELECT S_ORD.CUSTOMER_ID
    FROM S_ORD
    GROUP BY S_ORD.CUSTOMER_ID
    HAVING COUNT(*)>=ALL(
        SELECT COUNT(*)
        FROM S_ORD 
        GROUP BY S_ORD.CUSTOMER_ID
        )
    )
-- ! 30) Cho biết khách hàng có tổng tiền mua hàng lớn nhất.
SELECT S_CUSTOMER."NAME",COUNT(S_ORD.TOTAL) "TOTAL"
FROM S_CUSTOMER, S_ORD
WHERE S_CUSTOMER.ID=S_ORD.CUSTOMER_ID
GROUP BY S_CUSTOMER.ID
ORDER BY S_CUSTOMER.ID
    -- • Truy vấn con và các dạng khác
-- ! 31) Hiển thị họ, tên và ngày tuyển dụng của tất cả các nhân viên cùng phòng với Lan.
SELECT S_EMP.last_name, S_EMP.first_name,S_EMP.START_DATE
FROM S_EMP
WHERE S_EMP.dept_id in (
    SELECT S_EMP.dept_id 
    FROM S_EMP 
    WHERE S_EMP.first_name='Lan'
    )
-- ! 32) Hiển thị mã nhân viên, họ, tên và mã truy cập của tất cả các nhân viên có mức lương trên mức lương trung bình.
SELECT S_EMP.ID,S_EMP.last_name,S_EMP.last_name,S_EMP.USERID
FROM S_EMP 
WHERE S_EMP.SALARY>(
    SELECT AVG(S_EMP.SALARY)
    FROM S_EMP
    )
-- ! 33) Hiển thị mã nhân viên, họ và tên của tất cả các nhân viên có mức lương trên mức trung bình và có tên chứa ký tự “L”.
SELECT S_EMP.ID,S_EMP.last_name,S_EMP.last_name,S_EMP.USERID
FROM S_EMP 
WHERE (S_EMP.last_name LIKE "%L%" OR S_EMP.first_name LIKE "%L%")
AND S_EMP.SALARY>(
    SELECT AVG(S_EMP.SALARY)
    FROM S_EMP
    )
-- ! 34) Hiển thị những khách hàng chưa bao giờ đặt hàng.    
SELECT S_CUSTOMER.ID, S_CUSTOMER."NAME"
FROM S_CUSTOMER
WHERE S_CUSTOMER.ID NOT IN (
    SELECT S_ORD.CUSTOMER_ID
    FROM S_ORD
    GROUP BY S_ORD.CUSTOMER_ID
    )

/*---FUNCTION-ROLES---*/
drop function IsExist_NameRole_func
DELIMITER $$
CREATE FUNCTION IsExist_NameRole_func(name varchar(50)) returns int
DETERMINISTIC
BEGIN
  DECLARE rowNumber int;
select count(*) into rowNumber  from roles where nameRole like concat("%",name,"%");
  RETURN rowNumber;
END;
DELEMITER;
SELECT IsExist_NameRole_func('admin');
---------------------------------------------
drop function print_MessageForRoles_func
DELIMITER $$
CREATE FUNCTION  print_MessageForRoles_func(rowNumber int,name varchar(50)) returns varchar(50)
DETERMINISTIC
BEGIN

declare message varchar(50);
   if(rowNumber >0) then
    set message = concat("Đã tồn tại role " ,name, " trong cơ sở dữ liêu"); 
    else
	 set message = concat("Thành công"); 
	end if;
  RETURN message;
END;
select print_MessageForRoles_func(1,'doctor')
DELEMITER;
/* --- END FUNCTION-ROLES ---*/

drop function IsExist_UserName_func
DELIMITER $$
CREATE FUNCTION IsExist_UserName_func(name varchar(50)) returns int
DETERMINISTIC
BEGIN
  DECLARE rowNumber int;
select count(*) into rowNumber  from admins where username like concat("%",name,"%");

  RETURN rowNumber;
END;
DELEMITER;
SELECT IsExist_UserName_func('nguyentrien');
DELIMITER $$
CREATE FUNCTION  print_MessageForAdmin_func(rowNumber int,name varchar(50)) returns varchar(50)
DETERMINISTIC
BEGIN

declare message varchar(50);
   if(rowNumber >0) then
    set message = concat("Đã tồn tại tên người dùng " ,name, " trong cơ sở dữ liêu"); 
    else
	 set message = concat("Thành công"); 
	end if;
  RETURN message;
END;
select print_MessageForAdmin_func(1,'nguyentrien')
DELEMITER;


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

select * from roles
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


/* -------------------------------- Specialities_Function --------------------------------*/
DELIMITER $$
create function isExist_Specialities_func(id int) returns int
DETERMINISTIC
BEGIN
  DECLARE rowNumber int;
select count(*) into rowNumber from specialities where specialityId = id;
  RETURN rowNumber;
END;    
DELEMITER;

DELIMITER $$
create function isExist_SpecialitiesFromDoctor_func(id int) returns int
DETERMINISTIC
BEGIN
  DECLARE rowNumber int;
select count(*) into rowNumber from doctors where specialityId = id;
  RETURN rowNumber;
END;    
DELEMITER;


drop function isExist_NameSpec_Func
DELIMITER $$
create function isExist_NameSpec_Func(nameSpec varchar(50)) returns int
DETERMINISTIC
begin
 declare rowNumber int;
 select count(*) into rowNumber from specialities where speciallityName = nameSpec;
 return	 rowNumber;
end;
DELIMITER;
select isExist_NameSpec_Func("căc");
/* ----------------------------------End_Specialities_Fuunction----------------------------------- */

/* ------------------------------------Admins_Function-------------------------------------------- */
DELIMITER $$
create function isExist_Specialities_func(id int) returns int
DETERMINISTIC
BEGIN
  DECLARE rowNumber int;
select count(*) into rowNumber from specialities where specialityId = id;
  RETURN rowNumber;
END;    
DELEMITER;

DELIMITER $$
create function isExist_SpecialitiesFromDoctor_func(id int) returns int
DETERMINISTIC
BEGIN
  DECLARE rowNumber int;
select count(*) into rowNumber from doctors where specialityId = id;
  RETURN rowNumber;
END;    
DELEMITER;

/* -----------------------Admin_Function ---------------------------*/
DELIMITER $$
create function isExist_RoleFromAdmin_Func(idrole int) returns int
begin 
declare rowNumber int;
select count(*) into rowNumber from roles where roleId = idrole;
return rowNumber;
end;
DELIMITER;
select isExist_RoleFromAdmin_Func(3);


drop function isExist_UsernameFromAdmin_Func
DELIMITER $$;
create function isExist_UsernameFromAdmin_Func(nameUser varchar(50)) returns int
DETERMINISTIC
begin
declare	rowNumber int;
select count(*) into rowNumber from admins where userName = nameUser;
return rowNumber;
end;
DELIMITER;
select isExist_UsernameFromAdmin_Func("Nguyen Dinh Phat")
select * from admins

DELIMITER $$;
create function isExist_Admin_Func(id int) returns int
DETERMINISTIC
begin
declare	rowNumber int;
select count(*) into rowNumber from admins where adminId = id;
return rowNumber;
end;
DELIMITER;
select isExist_Admin_Func(2)




/* ------------------------- Doctor-Function ---------------------*/
drop function isExistPassOfDoctor_Func
DELIMITER $$ 
create function `isExistPassOfDoctor_Func`(id int,pass varchar(50)) returns int
begin
declare rowNumber int;
select count(*) into rowNumber from doctors where doctorId = id and password = pass;
return rowNumber;
end;
DELIMITER;
select isExistPassOfDoctor_Func(48,'$2b$10$pMH.4CzSV3MtDktw6Lonm.1p3oxBKme4WkOJYa.T7iy');
select * From doctors

DELIMITER $$
create function `VerifyPassWord`(newPass varchar(50), verifyPass varchar(50)) returns int
begin 
declare result int;
	if(newPass = verifyPass) then
		set result = 1;
	else
		set result =0;
end if;
end;
DELIMITER;

drop function isExist_UsernameFromDoctor_Func
DELIMITER $$
create function isExist_UsernameFromDoctor_Func(mail varchar(50)) returns int
DETERMINISTIC
begin
declare	rowNumber int;
select count(*) into rowNumber from doctors where email = mail;
return rowNumber;
end;
DELIMITER;


select isExist_UsernameFromDoctor_Func('tuan13@gmail.com');

DELIMITER $$
	create function `getPassWord_Func`(id int) returns varchar(50)
    begin
		declare result varchar(50);
		select password into result from doctors where doctorId = id;
        return result;
    end;
DELIMITER;
select getPassWord_Func(48)
select * from doctors



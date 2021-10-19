
/*-- STORE PROCEDURES --*/
/* ROLES*/
drop procedure Add_Role_Proc
DELIMITER %%
 create procedure Add_Role_Proc(IN name varchar(50))
begin
declare isExist int ;
 set isExist = (select IsExist_NameRole_func(name));
if (isExist <=0) then
        insert into roles(nameRole) values(name);
        select CONCAT("Thêm role ",name," thành công");
else 
     select concat("Đã tồn tại role " ,name, " trong cơ sở dữ liêu");
end if;
end;
DELEMITER;
call Add_Role_Proc('doctor');
------------------------------------------
DELIMITER %%
create procedure Show_Role_Proc()
  begin
    select * from roles;
  end;
call show_Role_Proc;
DELEMITER;

DELIMITER %%
create procedure Show_Role_ByName_Proc(in name varchar(50))
  begin
    select * from roles where nameRole like concat('%',name,'%') ;
  end;
DELEMITER;
call Show_Role_ByName_Proc('doctor');
-------------------------------------------------
drop procedure Get_RoleId_ByName_Proc
DELIMITER %%
create procedure Get_RoleId_ByName_Proc(in name varchar(50),out roleIds int)
begin
declare isExist int;
declare message varchar(50);
  set isExist = (select IsExist_NameRole_func(name));
  if (isExist >=0) then
   set roleIds = (select roleId from roles where nameRole like concat('%',name,'%'));
  select 'Thanh cong';
  else
  select concat("Khong tồn tại role " ,name, " trong cơ sở dữ liêu");
  end if;
  select message;
  end;
DELEMITER;
call Get_RoleId_ByName_Proc('doctor',@out_id);
select @out_id;

/*END ROLES*/
/*--------------------------------------------------------------*/
 /* DOCTOR*/
DELIMITER %%
CREATE  PROCEDURE Add_Doctor_Proc(
firstName varchar(50),
lastName varchar(50),
phone varchar(10),
DOB date,
gender bit,
address varchar(50),
password varchar(50),
specialityId int,
roleId int
)
BEGIN
declare result varchar(50);
insert into doctors(firstName,lastName, phone,DOB,gender,address,password,specialityId,roleId) 
values(firstName,lastName,phone,DOB,gender,address, password, specialityId,roleId);
set result = "Thêm dữ liệu thành công";
select result;
END;
DELEMITER ;
call Add_Doctor_Proc('B','Nguyễn Đình Phát','0915261627','1999-09-03',1,'29 Ngô Gia Tự','123',4,2);
call Add_Doctor_Proc('Tý','Nguyễn Văn', '0909190011','2000-09-23',1,'Trân phú','233',1,1);
--------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Doctor_Proc`(
in id int,
fName varchar(50),
lName varchar(50),
phoneNumber varchar(10),
dob date,
genderParam bit,
addr varchar(50),
pass varchar(50),
specId int,
rolId int
)
BEGIN
declare result varchar(50);
if exists (select * from doctors where doctorId = id) and
	 exists(select * 
    from doctors
    where doctorId = id and (firstName <> fName or lastName <> lName or DOB <> dob or phone <> phoneNumber or
    gender <> genderParam or address <> addr or password <> pass or specialityId <> specId or roleId <> rolId)) then
    update doctors set firstName = fName , lastName =lName ,DOB = dob ,phone = phoneNumber ,
    gender = genderParam , address =addr , password = pass , specialityId = specId , roleId = rolId
    where doctorId = id;
    set result = "Cập nhật dữ liệu thành công";
    select result;
else 
    set result ="Cập nhât dữ liệu thất bại";
    select result;
end if;
END
----------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `Del_Doctor_Proc`(in id int)
BEGIN
declare result varchar(50);
if exists(select *from doctors where doctorId = id) and 
not exists(select * from scheduleTimings where doctorId = id) then
	delete from doctors where doctorId = id;
    set result = "Xoá dữ liệu thành công";
    select result;
else 
	set result = "Xoá dữ liệu thất bại";
    select result;
end if;
END
call Del_Doctor_Proc(9);

 
 /* END DOCTOR*/
----------------------------------------------------- 
  /*SPECIALITIES*/
     DELIMITER %%
CREATE  PROCEDURE `Add_Specialities_Proc`(IN speciallityNameParam varchar(50))
BEGIN
declare result varchar(50);
if not exists(select *  from specialities where  speciallityName = speciallityNameParam) then
		insert into specialities(`speciallityName`) values(speciallityNameParam);
        set result ="Thêm Chuyên ngành thành công";
        select result;
else 
      set result="Đã tồn tại tên chuyên ngành trong cơ sở dữ liêu";
      select result;
end if;
END;
DELEMITER ;   
call Add_Specialities_Proc('Răng');

----------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Specialities_Proc`(in idParem int, in specialitiesParam varchar(50))
BEGIN
declare result varchar(50);
if exists (select * from specialities where specialityId =  idParem) and  exists(select * from specialities where specialityId =  idParem and speciallityName <>specialitiesParam) 
	then
    update specialities set specialities.speciallityName = specialitiesParam where specialities.specialityId =idParem;
    set result = "Cập nhật thành công";
    select result;
else
	set result = "Kiểm tra lại thông tin cập nhât";
    select result;
end if;
END
call Update_Specialities_Proc(4,'Răng');
------------------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `Del_Specialities_Proc`(idParam int)
BEGIN
declare result nvarchar(50);
if not exists(select * from doctors where specialityId = idParam) 
	and exists (select * from specialities where specialityId = idParam ) then
    delete from specialities where specialityId = idParam;
    set result = "Xoá dữ liệu thành công";
    select result;
else 
	set result = "Xoá dữ liệu thất bại";
     select result;
end if;

END
call Del_Specialities_Proc(8);

 /* END SPECIALITIES*/
 
/* -- END STORE PROCEDURES--*/





















use `appointmentbookingdoctor`
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
DELIMITER $$
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
DELIMITER $$
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
 drop procedure Add_Doctor_Proc	
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Doctor_Proc`(
firstName varchar(50),
lastName varchar(50),
phone varchar(10),
DOB date,
gender bit,
address varchar(50),
pass varchar(100),
specialityId int,
roleId int,
mail varchar(50)
)
BEGIN
insert into doctors(firstName,lastName, phone,DOB,gender,address,password,specialityId,roleId,Email) 
values(firstName,lastName,phone,DOB,gender,address, pass, specialityId,roleId,mail);
call getDoctorAdded_Proc(mail);
END;
DELEMITER;
select * from admins;
call Add_Doctor_Proc('Echo','Nguyễn Văn', '0909190011','2000-09-23',1,'Trân phú','codelade',4,2,'nguyentrienmahoa@gmail.com');
DELIMITER $$
select * from doctors
create procedure getDoctorAdded_Proc(mail varchar(50))
begin
	SELECT 
        `dt`.`doctorId` AS `doctorId`,
        `dt`.`firstName` AS `firstName`,
        `dt`.`lastName` AS `lastName`,
        `dt`.`phone` AS `phone`,
        `dt`.`DOB` AS `DOB`,
        `dt`.`address` AS `address`,
        `sp`.`speciallityName` AS `speciallityName`,
        `rl`.`nameRole` AS `nameRole`,
        `dt`.`Email` AS `email`
    FROM
        ((`appointmentbookingdoctor`.`doctors` `dt`
        LEFT JOIN `appointmentbookingdoctor`.`specialities` `sp` ON (`dt`.`specialityId` = `sp`.`specialityId`))
        JOIN `appointmentbookingdoctor`.`roles` `rl` ON (`dt`.`roleId` = `rl`.`roleId`))
	where email = mail;
end;
DELIMITER;
-----------------
drop procedure Update_Password_Doctor_Proc
DELIMITER $$
create procedure `Update_Password_Doctor_Proc`(pass varchar(100), id int)
begin 
	update doctors set password = pass where doctorId = id;
end;
DELIMITER;
select * from doctors where doctorId = 32
call Update_Password_Doctor_Proc('hi',32)
select * from specialities

--------------------------------
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Doctor_Proc`(
in id int,
fName varchar(50),
lName varchar(50),
phoneNumber varchar(10),
dob date,
genderParam bit,
addr varchar(50),
specId int,
rolId int
)
BEGIN
    update doctors set firstName = fName , lastName =lName ,DOB = dob ,phone = phoneNumber,
    gender = genderParam , address =addr , specialityId = specId , roleId = rolId
    where doctorId = id;
END;
DELIMITER;
call Update_Doctor_Proc(16,'Tý','Nguyễn Văn', '0909190011','2000-09-23',1,'Trân phú B',4,2)

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

----------------------------------------
 DELIMITER %%
create procedure `show_All_Doctor` ()
begin
	select * from doctors;
end;
DELIMITER;
call show_All_Doctor()

 /* END DOCTOR*/
----------------------------------------------------- 
  /*SPECIALITIES*/
  DELIMITER $$
  create procedure `Show_All_Specialities_Proc`
  DELIMITER;
  drop procedure Add_Specialities_Proc
DELIMITER $$ 
CREATE  PROCEDURE `Add_Specialities_Proc`(IN speciallityNameParam varchar(50))
BEGIN
		insert into specialities(`speciallityName`) values(speciallityNameParam);
        select "Thêm Chuyên ngành thành công" as message;
END;
DELEMITER ;   
call Add_Specialities_Proc('Tim');

----------------------------------------
drop PROCEDURE `Update_Specialities_Proc`
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Specialities_Proc`(in idParem int, in specialitiesParam varchar(50))
BEGIN
    update specialities set specialities.speciallityName = specialitiesParam where specialities.specialityId =idParem;
    select "Cập nhật chuyên ngành thành công" AS message;
END;
DELIMITER;
call Update_Specialities_Proc(4,'Họng');
------------------------------------------------
DELIMITER $$
CREATE PROCEDURE Del_Specialities_Proc(idParam int)
BEGIN
declare message varchar(50);
    delete from specialities where specialityId = idParam;
    set message = "Xoá dữ liệu thành công";
    select message;
END $$
DELIMITER ;
call Del_Specialities_Proc(8);
call Del_Specialities_Proc(3);

 /* END SPECIALITIES*/
/* -- END STORE PROCEDURES--*/
drop procedure show_All_Doctor;

/* patients */
select * from patients;

drop procedure Add_Patient_Proc;
DELIMITER %%
create procedure `Add_Patient_Proc`(
fName varchar(50),
lName varchar(50),
mail varchar(50),
phoneNumber varchar(10),
gender bit,
password varchar(50),
roleId int
)
begin 
	declare result varchar(50);
	insert into patients(`firstName`,`lastName`,`email`,`phone`,`gender`,`password`,`roleId`)
	values(fName,lName,mail,phoneNumber,gender,password,roleId);
	set result ="Thêm dữ liệu thành công";
	select result;
end;
DELIMITER;
call Add_Patient_Proc('Tí','Nguyễn Văn','@dlu','0909190011',1,'123',1)
select * from patients

--------------------------------------------
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Patient_Proc`(
paId int,
fName varchar(50),
lName varchar(50),
mail varchar(50),
phoneNumber varchar(10),
gt bit,
pass varchar(50),
rolId int
)
BEGIN
declare result varchar(50);
if exists (select * from patients where  
patientId = paId and (firstName <> fName  or lastName <> lName or email <> mail or phone <> phoneNumber
or gender <> gt or password <> pass or roleId <> rolId )) then
	 update patients set firstName = fName, lastName = lName, email = mail, phone = phoneNumber,
    gender = gt, password = pass , roleId = rolId where patientId = paId; 
    set result ="Cập nhật dữ liệu thành công";
    select result;
else
	set result = "Kiểm tra lại dữ liệu cần cập nhật";
    select result;
end if;
END
call Update_Patient_Proc(1,'Triển','Nguyễn Văn dinh','@dkưe3','1111111111',1,'123',1)


---------------------------------
DELIMITER %%
CREATE DEFINER=`root`@`localhost` PROCEDURE `Del_Patient_Proc`(in id int)
BEGIN
declare result varchar(50);
if exists (select * from patients where patientId = id) and
	not exists (select * from appointments where patientId = id) then
    Delete from patients where patientId = id;
    set result = "Xoá dữ liệu thành công";
    select result;
else
 set result = "Không thể xoá dữ liệu";
 select result;
end if;
END;
DELIMITER;

DELIMITER %%
create procedure `SHOW_ALL_PATIENT`()
begin
select * from patients;
end;
DELIMITER;
call SHOW_ALL_PATIENT();
/* -------- End_Patients_Proc ----------- */

/* -------- Scheduletiming_Proc ----------- */
DELIMITER %%
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Scheduletiming_Proc`(
bookDate date,
atBegin Time,
atEnd Time,
docId int,
status bit
)
BEGIN
if exists (select * from doctors where `doctorId` = docId) then
	insert into scheduletimings(`bookDate`,`atBegin`,`atEnd`,`doctorId`,`status`) values (bookDate,atBegin, atEnd, docId, status);
	select "Thêm dữ liệu thành công";
else
	select "Kiểm tra lại thông tin";
end if;
END;
DELIMITER;
select * from doctors
drop procedure Add_Scheduletiming_Proc
call Add_Scheduletiming_Proc('2021-09-03','9:30','10:00',1,1);
select * from scheduletimings

CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Scheduletimings_Proc`(
id int,
bDate date,
atbegin Time,
atend Time,
docId int,
stat bit
)
BEGIN
declare result varchar(50);
if exists(select * from Scheduletimings where scheduleTimingId = id and
(bookDate <> bDate or atBegin<> atbegin or atEnd <> atEnd or  doctorId <> docId or status <> stat)) then
	update Scheduletimings set bookDate = bDate , atBegin= atbegin, atEnd =atEnd, doctorId = docId ,status = stat
    where scheduleTimingId = id;
    set result = "Cập nhật dữ liệu thành công";
	select result;
else 
	set result = "Kiểm tra lại thông tin cập nhật";
    select result;
end if;
END
call Update_Scheduletimings_Proc(1,'2021-09-04','9:30','10:00',1,1);

call Del_Scheduletimings_Proc(24);

/* ------End_Scheduletimings_Proc ------ */

/* ------Amind_Proc ------ */
DELIMITER $$
CREATE  PROCEDURE `Update_Password_Admin_Proc`(pass varchar(100), id int)
begin 
	update admins set password = pass where adminId = id;
end;
DELIMITER;
call Update_Password_Admin_Proc('3432',10)
select *from admins

drop procedure Update_Amind_Proc
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Amind_Proc`(
id int,
username varchar(50),
pass varchar(50),
rolId int
)
BEGIN
	update admins set adminId = id, userName = username, password = pass , roleId = rolId 
    where adminId = id;
END;
DELIMITER;
call Update_Amind_Proc(3,'tèo em','123',1);

drop procedure Add_Admin_Proc
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Admin_Proc`(
username varchar(50),
password varchar(50),
roleId int
)
BEGIN
declare isExistUser int;
	insert into admins(userName,password,roleId) values(username,password,roleId);
    call get_Admin_Added(username);
END;
DELIMITER;

DELIMITER $$
create procedure `get_Admin_Added`(mail varchar(50))
begin
	select adminId,userName, nameRole 
    from adminsView 
    where userName = mail;
end;
DELIMITER;


drop procedure Del_Admins_Proc
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Del_Admins_Proc`(in id int)
BEGIN
delete from admins where adminId =id;
END;
DELIMITER;
call Del_Admins_Proc(4);
select * from admins
 
 drop procedure SHOW_ALL_ADMINS_PROC
 DELIMITER %%
 create procedure `SHOW_ALL_ADMINS_PROC`()
 begin
	select * from admins;
 end;
 DELIMITER;
 
call SHOW_ALL_ADMINS_PROC();
/* ----- admins_proc ------------- */

/* ---------- Appointmens_Procedere --------- */
DELIMITER %%
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Appointments_Proc`(
scheId int,
paId int
)
BEGIN
	if  exists(select * from scheduleTimings where `scheduleTimingId` = scheId) and
		 exists(select * from patients where `patientId` =paId) then
         insert into Appointments(`scheduleTimingId`,`patientId`) values(scheId, paId);
         select "Thêm dữ liệu thành công";
	else 
		select "Kiểm tra lại thông tin" as message;
	end if;
END;
DELIMITER;
select * from patients;
select * from scheduleTimings
call  Add_Appointments_Proc(7,3);
select * from appointments;

DELIMITER %%
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Appointments_Proc`(
appoinId int,
scheId int,
paId int)
BEGIN
if  exists(select * from scheduleTimings where `scheduleTimingId` = scheId) and
		 exists(select * from patients where `patientId` =paId) and 
         exists (select * from appointments where appointmentId =appoinId and (`scheduleTimingId` <> scheId or `patientId` <>paId))
         then 
         update appointments set `scheduleTimingId` = scheId , `patientId` =paId 
         where appointmentId = appoinId;
         select "Cập nhật thành công";
else
	select "Kiểm tra lại thông tin cập nhất";
end if;
END;
DELIMITER
call Update_Appointments_Proc(4,7,2);

DELIMITER %%
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Appointments_Proc`(
scheId int,
paId int
)
BEGIN
	if  exists(select * from scheduleTimings where `scheduleTimingId` = scheId) and
		 exists(select * from patients where `patientId` =paId) then
         insert into Appointments(`scheduleTimingId`,`patientId`) values(scheId, paId);
         select "Thêm dữ liệu thành công";
	else 
		select "Kiểm tra lại thông tin" as message;
	end if;
END;
DELIMITER;
call Del_Appointment_Proc(5);

/* ----- end appointment_proc ------------- */


DELIMITER $$
  create procedure getDetailDoctotByEmail_proc(email varchar(50))
  begin
        select
	dt.doctorId,dt.firstName,dt.lastName,dt.phone,dt.DOB,dt.address,dt.password,
    dt.email,sp.speciallityName,rl.nameRole
	from doctors dt
	left join specialities sp on dt.specialityId =sp.specialityId
	inner join roles rl on dt.roleId = rl.roleId
    where dt.email = email;
  end $$
DELIMITER  

select * from admins
select * from roles
drop procedure getDetailAdminByUsername_proc
DELIMITER $$
  create procedure getDetailAdminByUsername_proc(userN varchar(50))
  begin
        select
		ad.adminId, ad.userName, rl.nameRole, ad.password
	from admins ad
	inner join roles rl on ad.roleId = rl.roleId
    where ad.userName = userN;
  end $$
DELIMITER  


DELIMITER $$
	create function getPassWord_Admin_Func (id int) returns varchar(100)
    DETERMINISTIC
    begin
		declare result varchar(100);
		select password into result from admins where adminId = id;
        return result;
    end;
DELIMITER;
select * from doctors
select * from scheduleTimings
Modify COLUMN status tinyInt DEFAULT 0
call getScheduleUpdated(51)
select curtime()

/* --------------------------------- Schedule Procedure ------------------------------*/
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Scheduletiming_Proc`(
bDate date,
timeB Time,
timeE Time,
docId int
)
BEGIN
	insert into scheduletimings(`bookDate`,`atBegin`,`atEnd`,`doctorId`) values (bDate,timeB, timeE, docId);
	call getScheduleAdded(timeB,timeE,docId);
END;
DELIMITER;

DELIMITER$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getScheduleAdded`(startTime time,endTime time, docId int)
BEGIN
	select bookDate, atBegin, atEnd from scheduleTimings where (atBegin = startTime or atEnd = endTime) and doctorId = docId;
END;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Scheduletimings_Proc`(
id int,
bDate date,
startTime Time,
endTime Time
)
BEGIN
	update Scheduletimings set bookDate = bDate , atBegin= startTime, atEnd =endTime
    where scheduleTimingId = id;
     call getScheduleUpdated(id);
END;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getScheduleUpdated`(id int)
BEGIN
select bookDate, atBegin, atEnd from scheduleTimings where scheduleTimingId = id;
END;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Del_Scheduletimings_Proc`(in id int)
BEGIN
declare result varchar(50);
if exists(select * from scheduletimings where scheduleTimingId = id and status =0) then
    set result ="Xoá dữ liệu thành công";
    delete from scheduletimings where scheduleTimingId = id;
    select result;
else
	set result = "Khách hàng đã đặt lich. Không thể xoá lịch này";
    select result;
end if;
END;
DELIMITER;
select * from roles
select * from ViewDoctor



/* ----------------------------Patient Procedure ---------------------------*/
alter table patients 
change email username varchar(50)
modify gender tinyint(4)


select * from scheduleTimings

select * from patients  


create view patientView as
select patientId,firstName, lastName, username,phone,gender,nameRole
from patients p
join roles r on (r.roleId = p.roleId);
select * from patientView
call Add_Patient_Proc ('tuan','nguyen','trien12','0909190011',1,'123',1);
alter table patients
modify password varchar(100)
select *from patients
select * from patientView where patientId = 7;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDetailPatientByUsername_proc`(userN varchar(50))
begin
        select
		p.patientId, p.userName, p.firstname,p.lastname,rl.nameRole, p.password
	from patients p
	inner join roles rl on p.roleId = rl.roleId
    where p.username = userN;
  end;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Patient_Proc`(
fName varchar(50),
lName varchar(50),
nameuser varchar(50),
phoneNumber varchar(10),
gender tinyInt(4),
password varchar(100),
roleId int
)
begin 
	insert into patients(`firstName`,`lastName`,`username`,`phone`,`gender`,`password`,`roleId`)
	values(fName,lName,nameuser,phoneNumber,gender,password,roleId);
	select * from patientView where username = nameuser;
end;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Patient_Proc`(
paId int,
fName varchar(50),
lName varchar(50),
phoneNumber varchar(10),
gt tinyint
)
BEGIN
	 update patients set firstName = fName, lastName = lName, phone = phoneNumber,
    gender = gt where patientId = paId; 
    select * from patientView where patientId = paId;
END;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Del_Patient_Proc`(in id int)
BEGIN
    Delete from patients where patientId = id;
END;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Password_Patient_Proc`(pass varchar(100), id int)
begin 
	update patients set password = pass where patientId = id;
end;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `getPassWord_Patient_Func`(id int) RETURNS varchar(100) CHARSET utf8mb4
begin
		declare result varchar(100);
		select password into result from patients where patientId = id;
        return result;
    end;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `isExist_UsernameFromPatient_Func`(nameuser varchar(50)) RETURNS int(11)
    DETERMINISTIC
begin
declare	rowNumber int;
select count(*) into rowNumber from patients where username = nameuser;
return rowNumber;
end;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `isExist_AppointmentFromPatient_Func`(id int) RETURNS int(11)
begin 
declare rowNumber int;
select count(*) into rowNumber from appointments  where appointmentId = id;
return rowNumber;
end;
DELIMITER;
select * from scheduletimings
select * from doctors
select * from appointments

/* - ---------------------Appointment ---------------*/
create view appointmentDoctorView as
select appointmentId,ap.patientId , CONCAT(p.lastName,' ',p.firstName) as fullName
 ,sc.bookDate, sc.atBegin, sc.atEnd, sc.status 
from appointments ap
inner join  scheduleTimings sc on (ap.scheduleTimingId = sc.scheduleTimingId )
inner join  patients p on (p.patientId = ap.patientId);

drop view appointmentPatientView
create view appointmentPatientView as
select appointmentId,d.doctorId , CONCAT(d.lastName,' ',d.firstName) as fullName
 ,sc.bookDate, sc.atBegin, sc.atEnd, sc.status 
from appointments ap
inner join  scheduleTimings sc on (ap.scheduleTimingId = sc.scheduleTimingId )
inner join  doctors d on (d.doctorId = sc.doctorId);

select * from appointmentPatientView
select * from appointmentDoctorView
select * from appointments

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Add_Appointments_Proc`(
scheId int,
paId int
)
BEGIN	
         insert into Appointments(`scheduleTimingId`,`patientId`) values(scheId, paId);
END;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Del_Appointments_Proc`(in id int)
BEGIN
 delete from appointments where appointmentId = id;
END;
DELIMITER;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Update_Appointments_Proc`(
appoinId int,
scheId int,
paId int)
BEGIN
         update appointments set `scheduleTimingId` = scheId , `patientId` =paId 
         where appointmentId = appoinId;
END; 
DELIMITER;



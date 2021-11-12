create database `appointmentbookingdoctor`;
 use appointmentbookingdoctor;

create table `roles`(
roleId INT AUTO_INCREMENT,
nameRole varchar(50),
primary key(roleId)
);

create table `patients`(
patientId int not null  key AUTO_INCREMENT,
firstName varchar(50),
lastName varchar(50),
email varchar(50),
phone varchar(10),
gender bit,
password varchar(50),
roleId int,
FOREIGN KEY (roleId) REFERENCES roles (roleId) ON DELETE CASCADE on update cascade
);

create table `specialities`(
specialityId int not null  key AUTO_INCREMENT,
speciallityName varchar(50)
);

create table `doctors`(
doctorId int not null  key AUTO_INCREMENT,
firstName varchar(50),
lastName varchar(50),
phone varchar(10),
DOB date,
gender bit,
address varchar(50),
password varchar(50),
specialityId int,
foreign key (specialityId) references specialities (specialityId)
ON DELETE CASCADE on update cascade,
roleId int,
FOREIGN KEY (roleId) REFERENCES roles(roleId) ON DELETE CASCADE on update cascade
);


create table `scheduleTimings`(
scheduleTimingId int key not null AUTO_INCREMENT,
bookDate date,
atBegin Time,
atEnd Time,
doctorId int,
status bit ,
foreign key (doctorId) references doctors(doctorId)  ON DELETE CASCADE on update cascade
);

create table appointments(
appointmentId int key not null AUTO_INCREMENT,
scheduleTimingId int,
patientId int,
foreign key (scheduleTimingId) references scheduleTimings(scheduleTimingId)
ON DELETE CASCADE on update cascade,
foreign key (patientId) references patients(patientId)
ON DELETE CASCADE on update cascade
);

create table `admins`(
adminId int not null  key AUTO_INCREMENT,
userName varchar(50),
password varchar(50),
roleId int,
FOREIGN KEY (roleId) REFERENCES roles(roleId) ON DELETE CASCADE on update cascade
);
alter table admins
modify password varchar(100);

SHOW TABLEs;
select * from patients;
call SHOW_ALL_BY_TABLE_NAME('doctors');
SHOW FULL TABLES IN appointmentbookingdoctor WHERE TABLE_TYPE LIKE 'VIEW';


create view adminsView
as
select adminId,userName, password, nameRole from admins a
inner join roles r on r.roleId = a.roleId;
select * from admins



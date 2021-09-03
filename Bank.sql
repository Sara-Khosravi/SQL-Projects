/************************************************************************************/
/*...................................SARA KHOSRAVI..................................*/
/*.....................................PHASE ONE....................................*/

CREATE DATABASE Bank;

Go

use Bank;
GO
--create a table that includes information about UserLogins.....ParentKey 1.....

CREATE TABLE UserLogins
(UserLoginID SMALLINT NOT NULL IDENTITY(1,1),
	UserLogin VARCHAR(50) NOT NULL,
	UserPassword VARCHAR(20) NOT NULL,
	CONSTRAINT PKUL_UserLoginID PRIMARY KEY(UserLoginID));
Go

 --create a table that includes information about UserSecurityQuestions.....ParentKey 2.....
 CREATE TABLE UserSecurityQuestions
(   UserSecurityQuestionID TINYINT NOT NULL IDENTITY(1,1),
	UserSecurityQuestion VARCHAR(50) NOT NULL,
	CONSTRAINT PKUSQ_UserSecurityQuestionID PRIMARY KEY(UserSecurityQuestionID));
GO
 --create a table that includes information about AccountTypes.....ParentKey 3.....
CREATE TABLE AccountType
(   AccountTypeID TINYINT NOT NULL IDENTITY(1,1),
	AccountTypeDescription VARCHAR(30) NOT NULL,
	CONSTRAINT PKAT_AccountTypeID PRIMARY KEY(AccountTypeID));
GO
 --create a table that includes information about SavingInterestRates.....ParentKey 4.....
 CREATE TABLE SavingsInterestRates
(   InterestSavingRatesID TINYINT NOT NULL IDENTITY(1,1),
	InterestRatesValue NUMERIC(9,9) NOT NULL, 
	InterestRatesDescription VARCHAR(20) NOT NULL,
	CONSTRAINT PKSIR_InterestSavingRatesID PRIMARY KEY(InterestSavingRatesID));
GO


  --create a table that includes information about AccountStatuseType.....ParentKey 5.....
CREATE TABLE AccountStatusType
(   AccountStatusTypeID TINYINT NOT NULL IDENTITY(1,1),
	AccountStatusTypeDescription VARCHAR(30) NOT NULL,
	CONSTRAINT PKAST_AccountStatusTypeID PRIMARY KEY(AccountStatusTypeID));
GO

 
 --create a table that includes information about FailedTransactionErrorType.....ParentKey 6.....
 CREATE TABLE FailedTransactionErrorType
 (FailedTransactionErrorTypeID TINYINT NOT NULL IDENTITY(1,1),
	FailedTransactionErrorTypeDescription VARCHAR(50) NOT NULL,
	CONSTRAINT PKFTET_FailedTransactionErrorTypeID PRIMARY KEY(FailedTransactionErrorTypeID));
GO 

    --create a table that includes information about LoginErrorLog.....ParentKey 7.....
 CREATE TABLE LoginErrorLog
 (ErrorLogID INT NOT NULL IDENTITY(1,1),
	ErrorTime DATETIME NOT NULL,
	FailedTransactionXML XML,
	CONSTRAINT PKLEL_ErrorLogID PRIMARY KEY(ErrorLogID));
Go

 --create a table that includes information about Employee.....ParentKey 8.....
 CREATE TABLE Employee
 (EmployeeID INT NOT NULL IDENTITY(1,1),
	EmployeeFirstName VARCHAR(25) NOT NULL,
	EmployeeMiddleInitial CHAR(1),
	EmployeeLastName VARCHAR(25),
	EmployeeisManager BIT,
	CONSTRAINT pk_E_EmployeeID PRIMARY KEY(EmployeeID))
 GO

   --create a table that includes information about TransactionType.....ParentKey 9.....
 CREATE TABLE TransactionType
 (TransactionTypeID TINYINT NOT NULL IDENTITY(1,1),
	TransactionTypeName CHAR(10) NOT NULL,
	TransactionTypeDescription VARCHAR(50),
	TransactionFeeAmount SMALLMONEY,
	CONSTRAINT pk_TT_TransactionTypeID PRIMARY KEY(TransactionTypeID))
 GO

 
 --create a tables that makes a relation between FailedTransactionLog and FailedTransactionErrorType.......ChildKey2 and PrimaryKey9
 
CREATE TABLE FailedTransactionLog
(   FailedTransactionID INT NOT NULL IDENTITY(1,1),
	FailedTransactionErrorTypeID TINYINT NOT NULL,
	FailedTransactionErrorTime DATETIME,
	FailedTransactionErrorXML XML,
	CONSTRAINT pkFTL_FailedTransactionID PRIMARY KEY(FailedTransactionID),
	CONSTRAINT fkFTET_FailedTransactionErrorTypeID FOREIGN KEY(FailedTransactionErrorTypeID) REFERENCES FailedTransactionErrorType(FailedTransactionErrorTypeID));
GO

--create a tables that makes a relation between Account, AccountType, AccountStatuseType and SavingInterestRates .......ChildKey7, PrimaryKey3, PrimaryKey5 and PrimaryKey4
 
CREATE TABLE Account
(   AccountID INT NOT NULL IDENTITY(1,1),
	CurrentBalance INT NOT NULL,
	AccountTypeID TINYINT NOT NULL REFERENCES AccountType (AccountTypeID),
	AccountStatusTypeID TINYINT NOT NULL,
	InterestSavingRatesID TINYINT NOT NULL,
	CONSTRAINT pk_A_AccounID PRIMARY KEY(AccountID),
	CONSTRAINT fk_AST_AccountStatusTypeID FOREIGN KEY(AccountStatusTypeID) REFERENCES AccountStatusType(AccountStatusTypeID),
	CONSTRAINT fk_SIR_InterestSavingRatesID FOREIGN KEY(InterestSavingRatesID) REFERENCES SavingsInterestRates(InterestSavingRatesID));
GO
--create a tables that makes a relation between OverDraftLog and Account.......ChildKey 1 and ChildKey7
 
CREATE TABLE OverDraftLog
(   AccountID INT NOT NULL IDENTITY(1,1),
	OverDraftDate DATETIME NOT NULL,
	OverDraftAmount Money NOT NULL,
	OverDraftTransactionXML XML NOT NULL,
	CONSTRAINT PK_ODL_AccountID PRIMARY KEY(AccountID),
	CONSTRAINT FK_A_ODL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID));
GO


--create a tables that makes a relation between Login_Account, UserLogins and Account.......ChildKey3, PrimaryKey1, ChildKey7
CREATE TABLE Login_Account
(UserLoginID SMALLINT NOT NULL,
	AccountID INT NOT NULL,
	CONSTRAINT fk_UL_UserLogins FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID),
	CONSTRAINT fk_A_Account FOREIGN KEY(AccountID) REFERENCES Account(AccountID));
GO

--create a tables that makes a relation between UserSecurityAnswers, UserLogins and UserSecurityQuestions.......ChildKey4, PrimaryKey1 and PrimaryKey2
 
CREATE TABLE UserSecurityAnswer
(UserLoginID SMALLINT NOT NULL IDENTITY(1,1),
	UserSecurityAnswers VARCHAR(25) NOT NULL,
	UserSecurityQuestionID TINYINT NOT NULL,
	CONSTRAINT PKUSA_UserLoginID PRIMARY KEY(UserLoginID), 
	CONSTRAINT FKUL_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID),
	CONSTRAINT FKUSQ_UserSecurityQuestionID FOREIGN KEY(UserSecurityQuestionID) REFERENCES UserSecurityQuestions(UserSecurityQuestionID));
GO

--create a tables that makes a relation between Customer, TransactionLog.......ChildKey6, childKey8
 
CREATE TABLE Customer
(CustomerID INT NOT NULL IDENTITY(1,1),
	AccountID INT NOT NULL,
	CustomerAddress1 VARCHAR(30) NOT NULL,
	CustomerAddress2  VARCHAR(30),
	CustomerFirstName  VARCHAR(30) NOT NULL,
	CustomerMiddleInitial CHAR(1),
	CustomerLastName  VARCHAR(30) NOT NULL,
	City  VARCHAR(20) NOT NULL,
	State CHAR(2) NOT NULL,
	ZipCode CHAR(10) NOT NULL,
	EmailAddress CHAR(40) NOT NULL,
	HomePhone VARCHAR(10) NOT NULL,
	CellPhone VARCHAR(10) NOT NULL,
	WorkPhone VARCHAR(10) NOT NULL,
	SSN VARCHAR(9),
	UserLoginID SMALLINT NOT NULL,
	CONSTRAINT PKC_CustomerID PRIMARY KEY(CustomerID),
	--CONSTRAINT FKA_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT FKUL_C_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID));
GO


--create a tables that makes a relation between Customer_Account, Customer and Account.......ChildKey5, ChildKey6 and ChildKey7
CREATE TABLE Customer_Account
(   AccountID INT NOT NULL ,
	CustomerID INT NOT NULL,
	CONSTRAINT PKACA_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT PKCCA_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID));
GO

--create a tables that makes a relation between TransactionLog, TransactionType, Account, Customer,Employee and Userlogins
--.......ChildKey8, PrimaryKey6, ChildKey7, ChildKey6, PrimaryKey8 and PrimaryKey1
 
CREATE TABLE TransactionLog
(TransactionID INT NOT NULL IDENTITY(1,1),
	TransactionDate DATETIME NOT NULL,
	TransactionTypeID TINYINT NOT NULL,
	TransactionAmount Money NOT NULL,
	NewBalance Money NOT NULL,
	AccountID INT NOT NULL,
	CustomerID INT NOT NULL,
	EmployeeID INT NOT NULL,
	UserLoginID SMALLINT NOT NULL,
	CONSTRAINT PKTL_TransactionID PRIMARY KEY(TransactionID),
	CONSTRAINT FKTT_TL_TransactionTypeID FOREIGN KEY(TransactionTypeID) REFERENCES TransactionType(TransactionTypeID),
	CONSTRAINT FKA_TL_AccountID FOREIGN KEY(AccountID) REFERENCES Account(AccountID),
	CONSTRAINT FKC_TL_CustomerID FOREIGN KEY(CustomerID) REFERENCES Customer(CustomerID),
	CONSTRAINT FKE_TL_EmployeeID FOREIGN KEY(EmployeeID) REFERENCES Employee(EmployeeID),
	CONSTRAINT FKUL_TL_UserLoginID FOREIGN KEY(UserLoginID) REFERENCES UserLogins(UserLoginID)); 
GO

--...Insert at least 5 rows in each table....

--Inserting 5 records into table UserLogins

insert into UserLogins values('UserLogin1', 'Password1');
insert into UserLogins values('UserLogin2', 'Password2');
insert into UserLogins values('UserLogin3', 'Password3');
insert into UserLogins values('UserLogin4', 'Password4');
insert into UserLogins values('UserLogin5', 'Password5');
select * from UserLogins;
GO

--Inserting 5 records into table UserSecurityQuestions
insert into UserSecurityQuestions values('What is your favourite food?');
insert into UserSecurityQuestions values('What is your favourite book?');
insert into UserSecurityQuestions values('What is your name of first friend?');
insert into UserSecurityQuestions values('What is your Granmother name?');
insert into UserSecurityQuestions values('What is your Grandfather name?');
select * from UserSecurityQuestions;
GO

--Inserting 5 records into table AccountType
Insert into AccountType values('SavingAccount1');
Insert into AccountType values('CheckingAccount1');
Insert into AccountType values('SavingAccount2');
Insert into AccountType values('CheckingAccount2');
Insert into AccountType values('SavingAccount3');
select * from AccountType;
GO

--Inserting 5 records into table SavingsInterestRates
insert into SavingsInterestRates values(0.05, 'Low');
insert into SavingsInterestRates values(0.2, 'Medium');
insert into SavingsInterestRates values(0.3, 'High');
insert into SavingsInterestRates values(0.4, 'Very high');
insert into SavingsInterestRates values(0.6, 'Super high');
select * from SavingsInterestRates;
GO

--Inserting 5 records into table AccountStatusType
insert into AccountStatusType values('Closed');
insert into AccountStatusType values('Active');
insert into AccountStatusType values('Dormant');
insert into AccountStatusType values('Passive');
insert into AccountStatusType values('Active');
select * from AccountStatusType;
GO

--Inserting 5 records into table FailedTransactionErrorType
insert into FailedTransactionErrorType values('Withdraw limit');
insert into FailedTransactionErrorType values('Invalid Password');
insert into FailedTransactionErrorType values('Time-out');
insert into FailedTransactionErrorType values('OVERFLOW');
insert into FailedTransactionErrorType values('Double detect error');
select * from FailedTransactionErrorType;
GO

--Inserting 5 records into table LoginErrorLog
insert into LoginErrorLog values(TRY_CAST('2020/12/4 07:30:56' AS DATETIME), 'Bad Connection');
insert into LoginErrorLog values(TRY_CAST('2020/12/9 12:34:57' AS DATETIME), 'Invalid User');
insert into LoginErrorLog values(TRY_CAST('2020/12/15 02:14:00' AS DATETIME), 'Wrong Password');
insert into LoginErrorLog values(TRY_CAST('2020/12/20 05:56:59' AS DATETIME), 'Server issue');
insert into LoginErrorLog values(TRY_CAST('2020/12/21 08:34:15' AS DATETIME), 'Datacenter down');
select * from LoginErrorLog;
GO

--Inserting 5 records into table Employee
insert into Employee values('Employee1', 'A', 'LN1', '0');
insert into Employee values('Employee2', 'B', 'LN2', '1');
insert into Employee values('Employee3', 'C', 'LN3', '0');
insert into Employee values('Employee4', 'D', 'LN4', '1');
insert into Employee values('Employee5', 'E', 'LN5', '1');
select * from Employee;
GO

--Inserting 5 records into table TransactionType
insert into TransactionType values('Balance', 'See money', '0');
insert into TransactionType values('Transfer', 'Send money', '450');
insert into TransactionType values('Receive', 'Get money', '300');
insert into TransactionType values('Paid', 'Paid to powerstream', '200');
insert into TransactionType values('Statement', 'Checked monthly transaction', '0');
select * from TransactionType;
GO

--Inserting 5 records into table FailedTransactionLog
insert into FailedTransactionLog values(1, TRY_CAST('2020/12/4 07:30:56' AS DATETIME), 'First');
insert into FailedTransactionLog values(2, TRY_CAST('2020/12/9 12:34:57' AS DATETIME), 'Second');
insert into FailedTransactionLog values(3, TRY_CAST('2020/12/15 02:14:00' AS DATETIME), 'Third');
insert into FailedTransactionLog values(4, TRY_CAST('2020/12/20 05:56:59' AS DATETIME), 'Fourth');
insert into FailedTransactionLog values(5, TRY_CAST('2020/12/21 08:34:15' AS DATETIME), 'Fifth');
select * from FailedTransactionLog;
GO

--Inserting 5 records into table UserSecurityAnswers
insert into UserSecurityAnswer values('kabab', 1);
insert into UserSecurityAnswer values('Masnavi', 2);
insert into UserSecurityAnswer values('Mahboobe', 3);
insert into UserSecurityAnswer values('Maryam', 4);
insert into UserSecurityAnswer values('AmirAli', 5);
select * from UserSecurityAnswer;
GO

--Inserting 5 records into table Account
insert into Account values(22000, 1, 1, 1);
insert into Account values(25000, 2, 2, 2);
insert into Account values(17000, 1, 1, 1);
insert into Account values(50000, 2, 2, 2);
insert into Account values(35000, 2, 2, 2);
select * from Account;
GO

--Inserting 5 records into table LoginAccount
insert into Login_Account values(1, 1);
insert into Login_Account values(2, 2);
insert into Login_Account values(3, 3);
insert into Login_Account values(4, 4);
insert into Login_Account values(5, 5);
select * from Login_Account;
GO

--Inserting 5 records into table Customer
insert into Customer values(1, 'Address1', 'Address2', 'Customer1', 'A', 'CLastname1', 'Ottawa', 'ON', '3A5z9z', 'user1@user.com', '1416555111', '453554464', '3462325', 'A12345', 1);
insert into Customer values(2, 'Address1', 'Address2', 'Customer2', 'B', 'CLastname2', 'Toronto', 'ON', 'fe3453', 'user2@user.com', '1647892000', '567435345', '6332423', 'D34353', 2);
insert into Customer values(3, 'Address1', 'Address2', 'Customer3', 'C', 'CLastname3', 'Montreal', 'QC', 'fdf45', 'user3@user.com', '1438222652', '681316226', '9202521', 'J56361', 3);
insert into Customer values(4, 'Address1', 'Address2', 'Customer4', 'D', 'CLastname4', 'Burlington', 'ON', '23ffbfs', 'user4@user.com', '1647893300', '795197107', '8674252', 'I78369', 4);
insert into Customer values(5, 'Address1', 'Address2', 'Customer5', 'E', 'CLastname5', 'Waterloo', 'ON', 'hg4536', 'user5@user.com', '1416893666', '909077988', '9209371', 'K10377', 5);
select * from Customer;
GO

--Inserting 5 records into table CustomerAccount
insert into Customer_Account values(1, 1);
insert into Customer_Account values(2, 2);
insert into Customer_Account values(3, 3);
insert into Customer_Account values(4, 4);
insert into Customer_Account values(5, 5);
select * from  Customer_Account;
GO

--Inserting 5 records into table TransactionLog
insert into TransactionLog values('2020/11/4 07:30:56', 1,1000, 8000, 1, 1, 1, 1);
insert into TransactionLog values('2020/11/9 12:34:57', 2,1000, 7900, 2, 2, 2, 2);
insert into TransactionLog values('2020/12/5 02:14:00', 3,2000, 7700, 3, 3, 3, 3);
insert into TransactionLog values('2020/12/5 05:56:59', 4,500, 7650, 4, 4, 4, 4);
insert into TransactionLog values('2020/12/12 08:34:15',5,1000, 10500, 5, 5, 5, 5);
select * from TransactionLog;
GO

--Inserting 5 records into table OverDraftLog
insert into OverDraftLog values('2020/11/4 07:30:56', 0, 'Clear');
insert into OverDraftLog values('2020/11/9 12:34:57', 5, 'Pending');
insert into OverDraftLog values('2020/12/5 02:14:00', 10, 'Clear');
insert into OverDraftLog values('2020/12/5 05:56:59', 15, 'Pending');
insert into OverDraftLog values('2020/12/12 08:34:15', 20, 'Clear');
select * from OverDraftLog;
Go

/*********************************************************************************************************/
/******************...........................PHASE2 .......SARA..........................****************/

/*********************************************************************************************************/
/*.......................................................................................................*/
USE BANK



--Question1: Create a view to getting all customers with checking accounts from ON province. [Moderate]
Drop view ON_ChekingA

GO

CREATE VIEW ON_ChekingA
as
select c.CustomerID, c.CustomerFirstName+' '+c.CustomerLastName [Custome Name], c.State , at.AccountTypeDescription
from Customer c
  join Customer_Account ca 
   on C.CustomerID=ca.CustomerID
   join Account a
   on ca.AccountID=a.AccountID
   join AccountType at
   on a.AccountTypeID=at.AccountTypeID
where at.AccountTypeDescription='Checkings' and c.State='ON';
Select * from ON_ChekingA

 --DROP VIEW VW_Customer_ON;
--GO

CREATE VIEW VWCustomerON AS
SELECT DISTINCT c.* FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN AccountType at
ON a.AccountTypeID = at.AccountTypeID
WHERE at.AccountTypeDescription = 'Checking' and c.State = 'ON';
SELECT * FROM VWCustomerON
GO

/**********************************************************************************************************/
/*........................................................................................................*/
--Question2. Create a view to get all customers with total account balance (including interest rate) greater than 5000. [Advanced]

DROP VIEW VW_Customer_ACBIR;
GO

CREATE VIEW VW_Customer_ACBIR AS
SELECT c.CustomerFirstName, SUM(a.CurrentBalance) AS Ac_Balance, SUM(a.CurrentBalance + (a.CurrentBalance * s.InterestSavingRatesID)/100) AS Total_Ac_Balance 
FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN SavingsInterestRates s
ON a.InterestSavingRatesID = s.InterestSavingRatesID 
GROUP BY c.CustomerFirstName
HAVING SUM(a.CurrentBalance + (a.CurrentBalance * s.InterestRatesValue)/100) > 5000;
SELECT * FROM VW_Customer_ACBIR
GO


/**********************************************************************************************************/
/*........................................................................................................*/

--Question3. Create a view to get counts of checking and savings accounts by customer. 
USE BANK
GO

DROP VIEW VW_Customer_ACC;
GO

CREATE VIEW VW_Customer_ACC
AS
SELECT c.CustomerFirstName, at.AccountTypeDescription, COUNT(*) AS Total_AC_Types
FROM Customer c
JOIN Account a
ON c.AccountID = a.AccountId
JOIN AccountType at
ON a.AccountTypeID = at.AccountTypeID
GROUP BY c.CustomerFirstName, at.AccountTypeDescription;
Select * from VW_Customer_ACC;
GO

/*********************************************************************************************************/
/*.......................................................................................................*/
--Question4.Create a view to get any particular user’s login and password using AccountId. [Moderate]
USE BANK
GO

DROP VIEW Account_UL;
GO

CREATE VIEW Account_UL
AS
SELECT distinct ul.UserLogin, ul.UserPassword
FROM UserLogins ul
JOIN Login_Account la
ON ul.UserLoginID = la.UserLoginID
--JOIN Account a
--ON la.AccountID = a.AccountID;
WHERE la.AccountID = '2'
select * From   Account_UL
GO;

/*********************************************************************************************************/
/*.......................................................................................................*/
/*Question5: Create a view to get all customers’ overdraft amount. [Moderate]*/

DROP VIEW VW_Customer_OD;
GO

CREATE VIEW VW_Customer_OD 
AS
SELECT DISTINCT c.CustomerFirstName, o.OverDraftAmount
FROM OverDraftLog o
JOIN Customer c
ON o.AccountID = c.AccountID;
SELECT * FROM VW_Customer_OD
GO


/***********************************************************************************************************/
--Question6. Create a stored procedure to add “User_” as a prefix to everyone’s login (username).[Moderate]
USE BANK;
GO

DROP PROCEDURE StP_Update_Login;
GO

CREATE PROCEDURE StP_Update_Login
AS
UPDATE UserLogins
SET UserLogin = Concat('User_', UserLogin);
GO
EXECUTE StP_Update_Login;
GO

select * from UserLogins;
GO

/*************************************************************************************************************/
/*...........................................................................................................*/
--Question7. Create a stored procedure that accepts AccountId as a parameter and returns customer’s full name. 
      
Drop proc spFullNameFromAccountId
GO

create proc spFullNameFromAccountId        --assigning a name for procedure
            @AccountID int,                --Defining input parameter and it's data type 
			                               -- Don't Forget to put "," between them
			@Fullname nvarchar(100) output --Defining output parameter and it's data type 
as
begin
  if (@AccountID in (select AccountID from Customer_Account))
    begin
	   select @Fullname=c.customerFirstName+' '+c.customerMiddleInitial+' '+c.customerLastName
	   from customer C

   end
  else
   begin
    print 'This Account Id does not exists!'
   end
end

--Executing for valid account id
Declare @FullName nvarchar(100)
exec spFullNameFromAccountId 1009, @FullName out
Print ' Full name is '+ replace (@FullName,'   ',' ')
--Executing for invalid account id
Declare @FullName nvarchar(100)
exec spFullNameFromAccountId 2999, @FullName out
Print ' Full name is '+replace (@FullName,'   ',' ')

go



/***********************************************************************************************************/
/*.........................................................................................................*/
--Question8: Create a stored procedure that returns error logs inserted in the last 24 hours. [Advanced]
DROP PROCEDURE StoreP_Errors_24;
GO

CREATE PROCEDURE StoreP_Errors_24
AS
BEGIN
SELECT * FROM LoginErrorLog
WHERE  ErrorTime BETWEEN DATEADD(hh, -24, GETDATE()) AND GETDATE();
END
GO

EXEC StoreP_Errors_24
GO


/*************************************************************************************************************************************************/
/*...............................................................................................................................................*/
--Question9: Create a stored procedure that takes a deposit as a parameter and updates CurrentBalance value for that particular account. [Advanced]
DROP PROCEDURE SP_Update_cBalance_After_Deposit;
GO

CREATE PROCEDURE SP_Update_cBalance_After_Deposit @AccountID INT, @Deposit INT
AS
UPDATE Account
SET CurrentBalance = CurrentBalance + @Deposit
where AccountID = @AccountID;
GO

EXEC SP_Update_cBalance_After_Deposit 3, 300;
GO

SELECT * FROM Account
GO

/***************************************************************************************************************************************************/
/*.................................................................................................................................................*/
--Question10.Create a stored procedure that takes a withdrawal amount as a parameter and updates

DROP PROCEDURE UpdateCBalanceWithdraw;
GO

CREATE PROCEDURE UpdateCBalanceWithdraw @AccountID INT, @Withdraw INT
AS
UPDATE Account
SET CurrentBalance = CurrentBalance - @Withdraw
WHERE AccountID = @AccountID;
GO

EXEC UpdateCBalanceWithdraw 4, 1000;
GO

SELECT * FROM Account;

/***********************************************************************************************************/
/*.........................................................................................................*/
---***************....PHASE ONE...SARA....******************************************
create database dbBank_SARA


go
use dbBank_SARA
go

--create a table that includes information about UserLogins.....ParentKey 1.........

create table UserLogins
(UserLoginID smallint not null primary key,
UserLogin char(15),
UserPassword varchar(20))
go
 
 --create a table that includes information about UserSecurityQuestions.....ParentKey 2....
 create table UserSecurityQuestions
 (UserSecurityQuestionID tinyint not null primary key,
 UserSecurityQuestion varchar(50))
 go

 --create a table that includes information about AccountTypes.....ParentKey 3.....
 create table AccountTypes
 (AccountTypeID tinyint not null primary key,
 AccountTypeDescription varchar(30))
 go

 --create a table that includes information about SavingInterestRates.....ParentKey 4.....
 create table SavingInterestRates
 (InterestSavingRateID tinyint not null primary key,
 InterestRateValue Numeric(9,9),
 InterestRateDescription varchar (20))
 go

  --create a table that includes information about AccountStatuseType.....ParentKey 5.....
 create table AccountStatuseType
 (AccountStatuseTypeID tinyint not null primary key,
  AccountStatuseDescription varchar (30))
 go

 --create a table that includes information about TransactionType.....ParentKey 6.....
 create table TransactionType
 (TransactionTypeID tinyint not null primary key,
  TransactionTypeName varchar (10),
  TransactionTypeDescription varchar (50),
  TransactionFeeAmount smallmoney)
  go

    --create a table that includes information about LoginErrorLog.....ParentKey 7.....
 create table LoginErrorLog
 (LoginErrorID int not null primary key,
  ErrorTime datetime,
  FailedTransactionXML xml)
 go

 --create a table that includes information about Employee.....ParentKey 8.....
 create table Employee
 (EmployeeID int not null primary key,
  EmployeeFirstName varchar (25),
  EmployeeMiddleInitial char (1),
  EmployeeLastName varchar (25),
  EmployeelsManager bit)
  go

    --create a table that includes information about FailedTransactionErrorType.....ParentKey 9.....
 create table FailedTransactionErrorType
 (FailedTransactionErrorTypeID tinyint not null primary key,
  FailedTransactionDescription varchar(50))
 go

 --create a tables that makes a relation between FailedTransactionLog and FailedTransactionErrorType.......ChildKey2 and PrimaryKey9
 
Create table FailedTransactionLog
(FailedTransactionID int primary key,
FailedTransactionErrorTypeID tinyint foreign key references FailedTransactionErrorType(FailedTransactionErrorTypeID),
FailedTransactionErrorTime datetime,
FailedTransactionXML xml)
go

--create a tables that makes a relation between Account, AccountType, AccountStatuseType and SavingInterestRates .......ChildKey7, PrimaryKey3, PrimaryKey5 and PrimaryKey4
 
Create table Account
(AccountID int not null primary key ,
CurrentBalance int,
AccountTypeID tinyint foreign key references AccountTypes(AccountTypeID),
AccountStatuseTypeID tinyint foreign key references AccountStatuseType(AccountStatuseTypeID),
InterestSavingRateID tinyint foreign key references SavingInterestRates(InterestSavingRateID))
go


--create a tables that makes a relation between OverDraftLog and Account.......ChildKey 1 and ChildKey7
 
Create table OverDraftLog
(AccountID int  primary key foreign key references Account(AccountID),
OverDraftDate datetime,
OverDraftAmount money,
OverDraftTransactionXML xml)
go

--create a tables that makes a relation between Login_Account, UserLogins and Account.......ChildKey3, PrimaryKey1, ChildKey7
Create table Login_Account
(UserLoginID smallint foreign key references UserLogins(UserLoginID),
AccountID int foreign key references Account(AccountID))
go

--create a tables that makes a relation between UserSecurityAnswers, UserLogins and UserSecurityQuestions.......ChildKey4, PrimaryKey1 and PrimaryKey2
 
Create table UserSecurityAnswer
(UserLoginID smallint  primary key foreign key references UserLogins(UserLoginID),
UserSecurityAnswer varchar(25),
UserSecurityQuestionID tinyint foreign key references UserSecurityQuestions(UserSecurityQuestionID))
go

--create a tables that makes a relation between Customer, Account and UserLogins.......ChildKey6, childKey7 and PrimaryKey9 ..childKey8
 
Create table Customer
(CustomerID int not null primary key,
--AccountID int foreign key references Account(AccountID),
CustomerAddress1 varchar (30),
CustomerAddress2 varchar (30),
CustomerFirstName varchar (30),
CustomerMiddleInitial varchar (1),
CustomerLastName varchar (30),
City varchar (20),
State char(2),
Zipcode char (10),
EmailAddress varchar (40),
HomePhone char (10),
CellPhone char(10),
WorkPhone char (10),
SSN char (1),
UserLoginID smallint foreign key references UserLogins(UserLoginID))
go


--create a tables that makes a relation between Customer_Account, Customer and Account.......ChildKey5, ChildKey6 and ChildKey7
Create table Customer_Account
(CustomerID int foreign key references Customer(CustomerID),
AccountID int foreign key references Account(AccountID))
go

--create a tables that makes a relation between TransactionLog, TransactionType, Account, Customer,Employee and Userlogins
--.......ChildKey8, PrimaryKey6, ChildKey7, ChildKey6, PrimaryKey8 and PrimaryKey1
Create table TransactionLog
(TransactionID int not null primary key ,
TransactionDate datetime,
TransactionTypeID tinyint foreign key references TransactionType(TransactionTypeID),
TransactionAmount money,
NewBalance money,
AccountID int foreign key references Account(AccountID),
CustomerID int foreign key references Customer(CustomerID),
EmployeeID int foreign key references Employee(EmployeeID),
UserloginID smallint foreign key references Userlogins(UserloginID))
go

/********************************************************************/

--...Insert at least 5 rows in each table....

--Inserting 5 records into table UserLogins

insert into UserLogins values(1,'UserLogin1', 'Password1');
insert into UserLogins values(2,'UserLogin2', 'Password2');
insert into UserLogins values(3,'UserLogin3', 'Password3');
insert into UserLogins values(4,'UserLogin4', 'Password4');
insert into UserLogins values(5,'UserLogin5', 'Password5');
select * from UserLogins;
GO

--Inserting 5 records into table UserSecurityQuestions

insert into UserSecurityQuestions values(1,'What is your favourite food?');
insert into UserSecurityQuestions values(2,'What is your favourite book?');
insert into UserSecurityQuestions values(3,'What is your name of first friend?');
insert into UserSecurityQuestions values(4,'What is your Granmother name?');
insert into UserSecurityQuestions values(5,'What is your Grandfather name?');
select * from UserSecurityQuestions;
GO

--Inserting 5 records into table AccountType

Insert into AccountTypes(AccountTypeID,AccountTypeDescription) values(1,'SavingAccount1');
Insert into AccountTypes(AccountTypeID,AccountTypeDescription) values(2,'CheckingAccount1');
Insert into AccountTypes(AccountTypeID,AccountTypeDescription) values(3,'SavingAccount2');
Insert into AccountTypes(AccountTypeID,AccountTypeDescription) values(4,'CheckingAccount2');
Insert into AccountTypes(AccountTypeID,AccountTypeDescription) values(5,'SavingAccount3');
select * from AccountTypes;
GO

--Inserting 5 records into table SavingsInterestRates

insert into SavingInterestRates(InterestSavingRateID,InterestRateValue,InterestRateDescription) values(1,0.05, 'Low');
insert into SavingInterestRates(InterestSavingRateID,InterestRateValue,InterestRateDescription) values(2,0.2, 'Medium');
insert into SavingInterestRates(InterestSavingRateID,InterestRateValue,InterestRateDescription) values(3,0.3, 'High');
insert into SavingInterestRates(InterestSavingRateID,InterestRateValue,InterestRateDescription) values(4,0.4, 'Very high');
insert into SavingInterestRates(InterestSavingRateID,InterestRateValue,InterestRateDescription) values(5,0.6, 'Super high');
select * from SavingInterestRates;
GO

--Inserting 5 records into table AccountStatusType

insert into AccountStatuseType values(1,'Closed');
insert into AccountStatuseType values(2,'Active');
insert into AccountStatuseType values(3,'Dormant');
insert into AccountStatuseType values(4,'Passive');
insert into AccountStatuseType values(5,'Active');
select * from AccountStatuseType;
GO

--Inserting 5 records into table FailedTransactionErrorType

insert into FailedTransactionErrorType values(1,'Withdraw limit');
insert into FailedTransactionErrorType values(2,'Invalid Password');
insert into FailedTransactionErrorType values(3,'Time-out');
insert into FailedTransactionErrorType values(4,'OVERFLOW');
insert into FailedTransactionErrorType values(5,'Double detect error');
select * from FailedTransactionErrorType;
GO

--Inserting 5 records into table LoginErrorLog

insert into LoginErrorLog values(1,TRY_CAST('2020/12/4 07:30:56' AS DATETIME), 'Bad Connection');
insert into LoginErrorLog values(2,TRY_CAST('2020/12/9 12:34:57' AS DATETIME), 'Invalid User');
insert into LoginErrorLog values(3,TRY_CAST('2020/12/15 02:14:00' AS DATETIME), 'Wrong Password');
insert into LoginErrorLog values(4,TRY_CAST('2020/12/20 05:56:59' AS DATETIME), 'Server issue');
insert into LoginErrorLog values(5,TRY_CAST('2020/12/21 08:34:15' AS DATETIME), 'Datacenter down');
select * from LoginErrorLog;
GO

--Inserting 5 records into table Employee

insert into Employee values(1,'Employee1', 'A', 'LN1', '0');
insert into Employee values(2,'Employee2', 'B', 'LN2', '1');
insert into Employee values(3,'Employee3', 'C', 'LN3', '0');
insert into Employee values(4,'Employee4', 'D', 'LN4', '1');
insert into Employee values(5,'Employee5', 'E', 'LN5', '1');
select * from Employee;
GO

--Inserting 5 records into table TransactionType

insert into TransactionType values(1,'Balance', 'See money', '0');
insert into TransactionType values(2,'Transfer', 'Send money', '450');
insert into TransactionType values(3,'Receive', 'Get money', '300');
insert into TransactionType values(4,'Paid', 'Paid to powerstream', '200');
insert into TransactionType values(5,'Statement', 'Checked monthly transaction', '0');
select * from TransactionType;
GO

--Inserting 5 records into table FailedTransactionLog

insert into FailedTransactionLog values(1,1, TRY_CAST('2020/12/4 07:30:56' AS DATETIME), 'First');
insert into FailedTransactionLog values(2,2, TRY_CAST('2020/12/9 12:34:57' AS DATETIME), 'Second');
insert into FailedTransactionLog values(3,3, TRY_CAST('2020/12/15 02:14:00' AS DATETIME), 'Third');
insert into FailedTransactionLog values(4,4, TRY_CAST('2020/12/20 05:56:59' AS DATETIME), 'Fourth');
insert into FailedTransactionLog values(5,5, TRY_CAST('2020/12/21 08:34:15' AS DATETIME), 'Fifth');
select * from FailedTransactionLog;
GO

--Inserting 5 records into table UserSecurityAnswers

insert into UserSecurityAnswer values(1,'kabab', 1);
insert into UserSecurityAnswer values(2,'Masnavi', 2);
insert into UserSecurityAnswer values(3,'Mahboobe', 3);
insert into UserSecurityAnswer values(4,'Maryam', 4);
insert into UserSecurityAnswer values(5,'AmirAli', 5);
select * from UserSecurityAnswer
GO

--Inserting 5 records into table Account

insert into Account values(1,22000, 1, 1, 1);
insert into Account values(2,25000, 2, 2, 2);
insert into Account values(3,17000, 1, 1, 1);
insert into Account values(4,50000, 2, 2, 2);
insert into Account values(5,35000, 2, 2, 2);
select * from Account;
GO

--Inserting 5 records into table LoginAccount

insert into Login_Account values(1, 1);
insert into Login_Account values(2, 2);
insert into Login_Account values(3, 3);
insert into Login_Account values(4, 4);
insert into Login_Account values(5, 5);
select * from Login_Account;
GO

--Inserting 5 records into table Customer

insert into Customer values(1, 'Address1', 'Address2', 'Customer1', 'A', 'CLastname1', 'Ottawa', 'ON', '3A5z9z', 'user1@user.com', '1416555111', '453554464', '3462325', '1', 1);
insert into Customer values(2, 'Address1', 'Address2', 'Customer2', 'B', 'CLastname2', 'Toronto', 'ON', 'fe3453', 'user2@user.com', '1647892000', '567435345', '6332423', '2', 2);
insert into Customer values(3, 'Address1', 'Address2', 'Customer3', 'C', 'CLastname3', 'Montreal', 'QC', 'fdf45', 'user3@user.com', '1438222652', '681316226', '9202521', '3', 3);
insert into Customer values(4, 'Address1', 'Address2', 'Customer4', 'D', 'CLastname4', 'Burlington', 'ON', '23ffbfs', 'user4@user.com', '1647893300', '795197107', '8674252', '4', 4);
insert into Customer values(5, 'Address1', 'Address2', 'Customer5', 'E', 'CLastname5', 'Waterloo', 'ON', 'hg4536', 'user5@user.com', '1416893666', '909077988', '9209371', '5', 5);
select * from Customer;
GO

--Inserting 5 records into table CustomerAccount

insert into Customer_Account values(1, 1);
insert into Customer_Account values(2, 2);
insert into Customer_Account values(3, 3);
insert into Customer_Account values(4, 4);
insert into Customer_Account values(5, 5);
select * from  Customer_Account;
GO

--Inserting 5 records into table TransactionLog

insert into TransactionLog values(1,'2020/11/4 07:30:56', 1,1000, 8000, 1, 1, 1, 1);
insert into TransactionLog values(2,'2020/11/9 12:34:57', 2,1000, 7900, 2, 2, 2, 2);
insert into TransactionLog values(3,'2020/12/5 02:14:00', 3,2000, 7700, 3, 3, 3, 3);
insert into TransactionLog values(4,'2020/12/5 05:56:59', 4,500, 7650, 4, 4, 4, 4);
insert into TransactionLog values(5,'2020/12/12 08:34:15',5,1000, 10500, 5, 5, 5, 5);
select * from TransactionLog;
GO

--Inserting 5 records into table OverDraftLog
--select * from OverDraftLog;
insert into OverDraftLog values(1,'2020/11/4 07:30:56', 0, 'Clear');
insert into OverDraftLog values(2,'2020/11/9 12:34:57', 5, 'Pending');
insert into OverDraftLog values(3,'2020/12/5 02:14:00', 10, 'Clear');
insert into OverDraftLog values(4,'2020/12/5 05:56:59', 15, 'Pending');
insert into OverDraftLog values(5,'2020/12/12 08:34:15', 20, 'Clear');
select * from OverDraftLog;
Go
/*************************************************************************/
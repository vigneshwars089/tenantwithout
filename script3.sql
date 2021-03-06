USE [master]
GO
/****** Object:  Database [EMT_SV_RT]    Script Date: 11/8/2017 10:07:33 PM ******/
CREATE DATABASE [EMT_SV_RT]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'EMTNewUIRegression', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\EMT_SV_RT.mdf' , SIZE = 107520KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'EMTNewUIRegression_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\EMT_SV_RT_log.ldf' , SIZE = 112384KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [EMT_SV_RT] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [EMT_SV_RT].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [EMT_SV_RT] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET ARITHABORT OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [EMT_SV_RT] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [EMT_SV_RT] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [EMT_SV_RT] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET  DISABLE_BROKER 
GO
ALTER DATABASE [EMT_SV_RT] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [EMT_SV_RT] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET RECOVERY FULL 
GO
ALTER DATABASE [EMT_SV_RT] SET  MULTI_USER 
GO
ALTER DATABASE [EMT_SV_RT] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [EMT_SV_RT] SET DB_CHAINING OFF 
GO
ALTER DATABASE [EMT_SV_RT] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [EMT_SV_RT] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [EMT_SV_RT]
GO
/****** Object:  UserDefinedTableType [dbo].[ClassificationDetails]    Script Date: 11/8/2017 10:07:33 PM ******/
CREATE TYPE [dbo].[ClassificationDetails] AS TABLE(
	[CaseId] [bigint] NULL,
	[ClassificationDescription] [varchar](500) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[ClassificationDetails_NLP]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE TYPE [dbo].[ClassificationDetails_NLP] AS TABLE(
	[ClassificationDescription] [varchar](100) NULL,
	[CaseId] [int] NULL
)
GO
/****** Object:  StoredProcedure [dbo].[AD_USP_USERLOGIN]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[AD_USP_USERLOGIN]    

@UserID varchar(20)   



--@success int out     

AS            

Begin    

 if exists (Select UserId from USERMASTER Where Userid=@UserID)    

 BEGIN  

  if exists (select roleid from userrolemapping where userid=@userid and roleid !=1)    

  Select 1    

  ELSE SELECT 2    

 END       

--Select 0    

END
GO
/****** Object:  StoredProcedure [dbo].[AD_USP_USERLOGIN1]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[AD_USP_USERLOGIN1]    

@UserID varchar(20)   



--@success int out     

AS            

Begin    
Declare @Localvar INT
Declare @TimeExpiration INT
 if exists (Select UserId from USERMASTER Where Userid=@UserID)    

 BEGIN  

  if exists (select roleid from userrolemapping where userid=@userid and roleid !=1)    
 SET @Localvar=1
  --Select 1 
  if(@Localvar=1)
  begin
  if ((select DATEDIFF(DD,PasswordCreatedDate,GETUTCDATE())from UserMaster where userid=@userid)>=15)
  Select 3
  ELSE SELECT 4  
 END

 -- Select 1    

  ELSE SELECT 2    

 END       

--Select 0    

END
GO
/****** Object:  StoredProcedure [dbo].[EncodeDecode]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EncodeDecode ‘decode’,’xxxxxxxxx’
--exec EncodeDecode 'dad','Y2hhbmdlQDIwMTU='

CREATE procedure [dbo].[EncodeDecode](
@type nvarchar(10),
@string nvarchar(50)
) as 
begin 
    if @type='Encode'
		begin 
		-- Encode the string "TestData" in Base64 to get "VGVzdERhdGE="
			SELECT CAST(N'' AS XML).value('xs:base64Binary(sql:column("bin"))', 'VARCHAR(MAX)')   Base64Encoding
			FROM (SELECT CAST(@string AS VARBINARY(MAX)) AS bin) AS bin_sql_server_temp;
		end 
	else 
	   begin
			-- Decode the Base64-encoded string "VGVzdERhdGE=" to get back "TestData"
			SELECT CAST(CAST(N'' AS XML).value('xs:base64Binary(sql:variable("@string"))', 'VARBINARY(MAX)') 
																	AS VARCHAR(MAX))ASCIIEncoding;
	   end 
end





GO
/****** Object:  StoredProcedure [dbo].[GetSubscriberContact]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[GetSubscriberContact]



as 

begin



--select distinct Userid, SubscriptionStatus,subject  from MailerSubscription group by Userid,subject order by 1 desc 



--select ms.* from MailerSubscription ms inner join 

--(select max(id) maxid, UserID from MailerSubscription group by userid) t1 

--on ms.id=t1.maxid order by ms.SubscriptionStatus

select ms.* from MailerSubscription ms inner join 

(select max(id) maxid, UserID, subject from MailerSubscription group by userid, subject ) t1 

on ms.id=t1.maxid order by ms.SubscriptionStatus

end 



GO
/****** Object:  StoredProcedure [dbo].[GetUserRoleList]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetUserRoleList]
@UserId varchar(max)
AS    
BEGIN    
 SELECT     
  RoleId,RoleDescription
 FROM     
 UserRoleMapping URM
 left join UserRole UR on URM.RoleId=UR.UserRoleId
where UserId=@UserId order by URM.RoleId
END


--Exec GetUserRoleList 195174



GO
/****** Object:  StoredProcedure [dbo].[InsertReportSubscriberContact]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[InsertReportSubscriberContact]



@UserID varchar(50),

@Subject nvarchar(max),

@SubscriptionStatus nvarchar(50),

@Interval nvarchar(50)

as 

begin



insert into ReportSubscriptionUsers (UserID,Subject,SubscriptionStatus,UpdatedDate,Interval) 

values(@UserID,@Subject,@SubscriptionStatus,GETDATE(),@Interval)

 

end 
GO
/****** Object:  StoredProcedure [dbo].[InsertSubscriberContact]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[InsertSubscriberContact]

@UserID varchar(50),
@Subject nvarchar(max),
@SubscriptionStatus nvarchar(50)

as 
begin

insert into MailerSubscription (UserID,Subject,SubscriptionStatus,UpdatedDate) 
values(@UserID,@Subject,@SubscriptionStatus,GETDATE())
 
end 
GO
/****** Object:  StoredProcedure [dbo].[SP_GetDonutChartDtls]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetDonutChartDtls] -- exec [SP_GetDonutChartDtls] 'Siemens','L2 Support','Test Mail1','354126',4
(
	@Country nvarchar(30),
	@SubprocessName nvarchar(30),
	@MailBoxName nvarchar(30),
	@UserID  nvarchar(30),
	@RoleID  nvarchar(30)
)
As  
Begin  
	
	--declare @strUserQuery nvarchar(max);
	declare @strSubprocessName nvarchar(max);

	if(@RoleID=4)
		Begin 
			--SET @strUserQuery = 'and EM.AssignedToId=''' +@UserID+''''


			DECLARE @Txt1 VARCHAR(MAX)
			SET @Txt1=''
 
			SELECT  @Txt1 = @Txt1 + ''''+SubprocessName +''','
			FROM    (select SG.SubprocessName from UserMailboxmapping UMM 
											join Emailbox EB on UMM.MailBoxID = EB.EMailBoxId 
											join SubProcessGroups SG on SG.SubProcessGroupId = EB.SubProcessGroupId
											where UMM.userID=@UserID)  t

			Select @strSubprocessName = LEFT(@Txt1,LEN(@Txt1)-1) 


		END
	else
		Begin
			--SET @strUserQuery=''
			SET @strSubprocessName=''
		End

	If(@MailBoxName <> null OR @MailBoxName <>'')
		Begin
			IF(@RoleID=4)
				Begin
					EXEC ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
						FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and EM.AssignedToId=''' +@UserID+'''
						AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''') and EM.StatusID<>6 
						Group By SM.StatusDescription,SM.STATUSID 
						Union
						SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
						FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and SM.STATUSID=1
						AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''') and EM.StatusID<>6 
						Group By SM.StatusDescription,SM.STATUSID;')

					  return;
				END
			ELSE
				Begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
						FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID
						AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName=@SubprocessName and EB.EMailBoxName=@MailBoxName and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country=@Country) and EM.StatusID<>6 
						Group By SM.StatusDescription,SM.STATUSID;

					  return;
				END

		END
	IF(@SubprocessName <> null OR @SubprocessName <>'')
		Begin
			IF(@RoleID=4)
				Begin
					 EXEC ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID  and EM.AssignedToId=''' +@UserID+'''
							AND EM.EMailBoxId in (select EMailBoxId from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
							and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''') and EM.StatusID<>6 
						    Group By SM.StatusDescription,SM.STATUSID

						  UNION

						  SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID  and SM.STATUSID=1
							AND EM.EMailBoxId in (select EMailBoxId from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
							and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''') and EM.StatusID<>6 
						    Group By SM.StatusDescription,SM.STATUSID')
						  return;
				END
			Else
				Begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID
							AND EM.EMailBoxId in (select EMailBoxId from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
							and SP.SubprocessName=@SubprocessName and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country=@Country) and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID
					  return;
				End
		End
	IF(@Country <> null OR @Country <>'')
		Begin
			IF(@RoleID=4)
				Begin
					Exec ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and EM.AssignedToId=''' +@UserID+'''
							join EmailBox EB ON EM.EmailBoxID = EB.EMailBoxId
							join Country C ON EB.CountryId=C.CountryId
							JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							where C.Country='''+@Country+''' and EM.StatusID<>6 and  EB.ISACTIVE=1 and SP.SubprocessName in ('+@strSubprocessName+')
							Group By SM.StatusDescription,SM.STATUSID
					  
							Union
							SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and SM.STATUSID=1
							join EmailBox EB ON EM.EmailBoxID = EB.EMailBoxId
							join Country C ON EB.CountryId=C.CountryId
							JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							where C.Country='''+@Country+''' and EM.StatusID<>6 and  EB.ISACTIVE=1 and SP.SubprocessName in ('+@strSubprocessName+')
							Group By SM.StatusDescription,SM.STATUSID')
					  return;
				End
			ELSE
				Begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
						FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID 
						join EmailBox EB ON EM.EmailBoxID = EB.EMailBoxId
						join Country C ON EB.CountryId=C.CountryId
						JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
						where C.Country=@Country and EM.StatusID<>6 and  EB.ISACTIVE=1
					    Group By SM.StatusDescription,SM.STATUSID;
					  return;
				End

		END								
 End
 




GO
/****** Object:  StoredProcedure [dbo].[SP_GetDonutChartDtls_1]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetDonutChartDtls_1] -- exec [SP_GetDonutChartDtls] 'Siemens','L2 Support','Test Mail1','354126',4
(
	@Country nvarchar(30),
	@SubprocessName nvarchar(30),
	@MailBoxName nvarchar(30),
	@UserID  nvarchar(30),
	@RoleID  nvarchar(30)
)
As  
Begin  
	
	--declare @strUserQuery nvarchar(max);

	--if(@RoleID=4)
	--	Begin 
	--		SET @strUserQuery = 'and EM.AssignedToId=''' +@UserID+''''
	--	END
	--else
	--	Begin
	--		SET @strUserQuery=''
	--	End

	If(@MailBoxName <> null OR @MailBoxName <>'')
		Begin
			IF(@RoleID=4)
				Begin
					EXEC ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
						FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and EM.AssignedToId=''' +@UserID+'''
						AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''') and EM.StatusID<>6 
						Group By SM.StatusDescription,SM.STATUSID 
						Union
						SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
						FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and SM.STATUSID=1
						AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''') and EM.StatusID<>6 
						Group By SM.StatusDescription,SM.STATUSID;')

					  return;
				END
			ELSE
				Begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
						FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID
						AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName=@SubprocessName and EB.EMailBoxName=@MailBoxName and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country=@Country) and EM.StatusID<>6 
						Group By SM.StatusDescription,SM.STATUSID;

					  return;
				END

		END
	IF(@SubprocessName <> null OR @SubprocessName <>'')
		Begin
			IF(@RoleID=4)
				Begin
					 EXEC ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID  and EM.AssignedToId=''' +@UserID+'''
							AND EM.EMailBoxId in (select EMailBoxId from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
							and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''') and EM.StatusID<>6 
						    Group By SM.StatusDescription,SM.STATUSID

						  UNION

						  SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID  and SM.STATUSID=1
							AND EM.EMailBoxId in (select EMailBoxId from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
							and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''') and EM.StatusID<>6 
						    Group By SM.StatusDescription,SM.STATUSID')
						  return;
				END
			Else
				Begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID
							AND EM.EMailBoxId in (select EMailBoxId from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
							and SP.SubprocessName=@SubprocessName and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country=@Country) and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID
					  return;
				End
		End
	IF(@Country <> null OR @Country <>'')
		Begin
			IF(@RoleID=4)
				Begin
					Exec ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and EM.AssignedToId=''' +@UserID+'''
							join EmailBox EB ON EM.EmailBoxID = EB.EMailBoxId
							join Country C ON EB.CountryId=C.CountryId
							where C.Country='''+@Country+''' and EM.StatusID<>6 and  EB.ISACTIVE=1
							Group By SM.StatusDescription,SM.STATUSID
					  
							Union
							SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and SM.STATUSID=1
							join EmailBox EB ON EM.EmailBoxID = EB.EMailBoxId
							join Country C ON EB.CountryId=C.CountryId
							where C.Country='''+@Country+''' and EM.StatusID<>6 and  EB.ISACTIVE=1
							Group By SM.StatusDescription,SM.STATUSID')
					  return;
				End
			ELSE
				Begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
						FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID 
						join EmailBox EB ON EM.EmailBoxID = EB.EMailBoxId
						join Country C ON EB.CountryId=C.CountryId
						where C.Country=@Country and EM.StatusID<>6 and  EB.ISACTIVE=1
					    Group By SM.StatusDescription,SM.STATUSID;
					  return;
				End

		END								
 End
 




GO
/****** Object:  StoredProcedure [dbo].[SP_GetDonutChartDtls_new]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetDonutChartDtls_new] -- exec [SP_GetDonutChartDtls] 'Siemens','L2 Support','Test Mail1','354126',4
(
	@Country nvarchar(30),
	@SubprocessName nvarchar(30),
	@MailBoxName nvarchar(30),
	@UserID  nvarchar(30),
	@RoleID  nvarchar(30)
)
As  
Begin  
		
	declare @strSubprocessName nvarchar(max),
	@SubProcessId nvarchar(max);

	set @SubProcessId=(select SubProcessGroupId from SubProcessGroups where SubprocessName=@SubProcessName)

	if(@RoleID=4)
		Begin 
			--SET @strUserQuery = 'and EM.AssignedToId=''' +@UserID+''''


			DECLARE @Txt1 VARCHAR(MAX)
			SET @Txt1=''
 
			SELECT  @Txt1 = @Txt1 + ''''+SubprocessName +''','
			FROM    (select SG.SubprocessName from UserMailboxmapping UMM 
											join Emailbox EB on UMM.MailBoxID = EB.EMailBoxId 
											join SubProcessGroups SG on SG.SubProcessGroupId = EB.SubProcessGroupId
											where UMM.userID='195174')  t

			Select @strSubprocessName = LEFT(@Txt1,LEN(@Txt1)-1) 


		END
	else
		Begin
			--SET @strUserQuery=''
			SET @strSubprocessName=''
		End

	If(@MailBoxName <> null OR @MailBoxName <>'')
		Begin
			IF(@RoleID=4)
				Begin
					if exists(select * from Status where SubProcessID=@SubProcessId)
					begin
						EXEC ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''') and EM.AssignedToId=''' +@UserID+'''						
						where SM.IsShowninDonut=1
						Group By SM.StatusDescription,SM.STATUSID
						Union
						SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''') and SM.STATUSID in (1)
						where SM.IsShowninDonut=1
						Group By SM.StatusDescription,SM.STATUSID;')
						return;
					end
					else
					begin
						EXEC ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID is null	and EM.AssignedToId=''' +@UserID+'''						
						where SM.IsShowninDonut=1
						Group By SM.StatusDescription,SM.STATUSID
						Union
						SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID is null	and SM.STATUSID in (1)
						where SM.IsShowninDonut=1
						Group By SM.StatusDescription,SM.STATUSID;')
					  return;
					end
					
				END
			ELSE
				Begin
				if exists(select * from Status where SubProcessID=@SubProcessId)
				begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
					FROM EMAILMASTER EM
					inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
					and SP.SubprocessName=@SubprocessName and EB.EMailBoxName=@MailBoxName and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country=@Country)
					join [Status] SM ON  EM.STATUSID = SM.STATUSID
					inner join SubProcessGroups SP on SP.SubProcessGroupId=SM.SubProcessID						
					inner join Country CN on CN.CountryId=SP.CountryIdMapping				
					and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName=@SubprocessName)								
					where SM.IsShowninDonut=1
					Group By SM.StatusDescription,SM.STATUSID;
					return;
				end
				else
				begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
					FROM EMAILMASTER EM
					inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
					and SP.SubprocessName=@SubprocessName and EB.EMailBoxName=@MailBoxName and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country=@Country)
					join [Status] SM ON  EM.STATUSID = SM.STATUSID
					inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
					inner join Country CN on CN.CountryId=SP.CountryIdMapping				
					and EM.StatusID<>6 	and SM.SubProcessID is null							
					where SM.IsShowninDonut=1
					Group By SM.StatusDescription,SM.STATUSID;
					return;
				end
						
				END

		END
	IF(@SubprocessName <> null OR @SubprocessName <>'')
		Begin
			IF(@RoleID=4)
				Begin
				if exists(select * from Status where SubProcessID=@SubProcessId)
				begin
					EXEC ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''') and EM.AssignedToId=''' +@UserID+'''						
						where SM.IsShowninDonut=1
						Group By SM.StatusDescription,SM.STATUSID
						Union
						SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''') and SM.STATUSID in (1)
						where SM.IsShowninDonut=1
						Group By SM.StatusDescription,SM.STATUSID;')
						return;
				end
				else
				begin
					EXEC ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID is null	and EM.AssignedToId=''' +@UserID+'''						
						where SM.IsShowninDonut=1
						Group By SM.StatusDescription,SM.STATUSID
						Union
						SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID is null	and SM.STATUSID in (1)
						where SM.IsShowninDonut=1
						Group By SM.StatusDescription,SM.STATUSID;')
						return;
				end					 
				END
			Else
				Begin
				if exists(select * from Status where SubprocessID=@SubProcessId)
				begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName=@SubprocessName and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country=@Country)
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=SM.SubProcessID						
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName=@SubprocessName)								
						where SM.IsShowninDonut=1
						Group By SM.StatusDescription,SM.STATUSID;
						return;
				end
				else
				begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid 
					FROM EMAILMASTER EM
					inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
					and SP.SubprocessName=@SubprocessName and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country=@Country)
					join [Status] SM ON  EM.STATUSID = SM.STATUSID
					inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
					inner join Country CN on CN.CountryId=SP.CountryIdMapping				
					and EM.StatusID<>6 	and SM.SubProcessID is null							
					where SM.IsShowninDonut=1
					Group By SM.StatusDescription,SM.STATUSID;
					return;
				end					
				End
		End
	IF(@Country <> null OR @Country <>'')
		Begin
			IF(@RoleID=4)
				Begin
					Exec ('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and EM.AssignedToId=''' +@UserID+'''
							join EmailBox EB ON EM.EmailBoxID = EB.EMailBoxId
							join Country C ON EB.CountryId=C.CountryId
							JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							where C.Country='''+@Country+''' and EM.StatusID<>6 and  EB.ISACTIVE=1 and SP.SubprocessName in ('+@strSubprocessName+')
							and SM.IsShowninDonut=1
							Group By SM.StatusDescription,SM.STATUSID					  
							Union
							SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
							FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID and SM.STATUSID=1
							join EmailBox EB ON EM.EmailBoxID = EB.EMailBoxId
							join Country C ON EB.CountryId=C.CountryId
							JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							where C.Country='''+@Country+''' and EM.StatusID<>6 and  EB.ISACTIVE=1 and SP.SubprocessName in ('+@strSubprocessName+')
							and SM.IsShowninDonut=1
							Group By SM.StatusDescription,SM.STATUSID')
					  return;
				End
			ELSE
				Begin
					SELECT Count(EM.STATUSID) As StatusCount,SM.StatusDescription AS STATUSDESCRIPTION, SM.Statusid  
						FROM EMAILMASTER EM join [Status] SM   ON  EM.STATUSID = SM.STATUSID 
						join EmailBox EB ON EM.EmailBoxID = EB.EMailBoxId
						join Country C ON EB.CountryId=C.CountryId
						JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
						where C.Country='India' and EM.StatusID<>6 and  EB.ISACTIVE=1
						and SM.IsShowninDonut=1
					    Group By SM.StatusDescription,SM.STATUSID;
					  return;
				End

		END								
 End
 




GO
/****** Object:  StoredProcedure [dbo].[SP_GetStackBarChartDefaultDynamicStatus]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetStackBarChartDefaultDynamicStatus] -- exec [SP_GetStackBarChartDefaultDynamicStatus] 'Siemens','L2 Support','Test Mail1','354126',4
(
	@Country nvarchar(30),
	@SubprocessName nvarchar(30),
	@MailBoxName nvarchar(30),
	@UserID  nvarchar(30),
	@RoleID  nvarchar(30)
)
As  
Begin  

declare @subprocessid nvarchar(100);

set @subprocessid=(select SubProcessGroupId from SubProcessGroups where SubprocessName=@SubprocessName)

if exists(select * from Status where SubProcessID=@subprocessid)
begin
	SELECT ST.StatusId as StatusID,ST.StatusDescription as StatusName,SG.SubProcessGroupId,SG.SubprocessName
	from Status ST 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=ST.SubProcessID
	inner join EMailBox EB on EB.SubProcessGroupId=SG.SubProcessGroupId
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	left join emailmaster EM on EM.StatusId=St.StatusId and EM.emailboxid=EB.EMailBoxId
	where
	ST.ShownInUI=1 and 	
	ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubprocessName)) and 
	ltrim(rtrim(Country))=ltrim(rtrim(@Country)) and ST.IsActive=1
	group by ST.StatusDescription,ST.StatusId,SG.SubprocessName,SG.SubProcessGroupId
end
else
begin
	SELECT ST.StatusId as StatusID,ST.StatusDescription as StatusName,SG.SubProcessGroupId,SG.SubprocessName
	from Status ST 
	cross join EMailBox EB 
	left outer join emailmaster EM on EM.StatusId=St.StatusId and EB.EMailBoxId=EM.emailboxid 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=EB.SubProcessGroupId 
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	where
	ST.ShownInUI=1 and ST.SubProcessID is null and	
	ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubprocessName)) and ltrim(rtrim(Country))=ltrim(rtrim(@Country)) and ST.IsActive=1
	group by ST.StatusDescription,ST.StatusId,SG.SubprocessName,SG.SubProcessGroupId
end

End
GO
/****** Object:  StoredProcedure [dbo].[SP_GetStakedBarChartData]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetStakedBarChartData]  -- exec [SP_GetStakedBarChartData] 'Siemens','','','354126',4
(
	@Country nvarchar(30),
	@SubprocessName nvarchar(30),
	@MailBoxName nvarchar(30),
	@UserID  nvarchar(30),
	@RoleID  nvarchar(30)
)
As  
Begin  


	declare @strUserQuery nvarchar(max);
	declare @strSubprocessName nvarchar(max);

	if(@RoleID=4)
		Begin 
			SET @strUserQuery = 'and EM.AssignedToId=''' +@UserID+''''


			DECLARE @Txt1 VARCHAR(MAX)
			SET @Txt1=''
 
			SELECT  @Txt1 = @Txt1 + ''''+SubprocessName +''','
			FROM    (select SG.SubprocessName from UserMailboxmapping UMM 
											join Emailbox EB on UMM.MailBoxID = EB.EMailBoxId 
											join SubProcessGroups SG on SG.SubProcessGroupId = EB.SubProcessGroupId
											where UMM.userID=@UserID)  t

			Select @strSubprocessName = LEFT(@Txt1,LEN(@Txt1)-1) 


		END
	else
		Begin
			SET @strUserQuery=''
			SET @strSubprocessName=''
		End

	If(@MailBoxName <> null OR @MailBoxName <>'')
		Begin
			if(@RoleID=4)
				Begin 
					EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 '+ @strUserQuery+'
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1  
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where EB.EMailBoxName='''+@MailBoxName+''' and SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
							
						Union
							Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1  
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid and SM.Statusid=1
							Where EB.EMailBoxName='''+@MailBoxName+''' and SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+'''and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')

							 return;
				End
			Else
				Begin
					EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
						INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 
						INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1  
						INNER JOIN Country C ON EB.CountryId=C.CountryId  
						INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
						Where EB.EMailBoxName='''+@MailBoxName+''' and SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							 Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

							 return;
				End

		END

	IF(@SubprocessName <> null OR @SubprocessName <>'')
		Begin
			IF(@RoleID=4)
				Begin
					EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 '+ @strUserQuery+'
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
							
							Union
							
							Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid   and SM.Statusid=1
							Where SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')
							return;
				End
			Else
				Begin
					EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

							return;
				End
		END

	IF(@Country <> null OR @Country <>'')
		Begin
			IF(@RoleID=4)
					Begin
						EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
								INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  '+ @strUserQuery+' 
								INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
								INNER JOIN Country C ON EB.CountryId=C.CountryId 
								INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid
								Where C.Country='''+@Country+''' and EM.StatusID<>6 and SP.SubprocessName in ('+@strSubprocessName+')
								Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
								
								Union
								
								Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
								INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
								INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
								INNER JOIN Country C ON EB.CountryId=C.CountryId 
								INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid and SM.Statusid=1
								Where C.Country='''+@Country+''' and EM.StatusID<>6 and SP.SubprocessName in ('+@strSubprocessName+')
								Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')

								 return;
					End
			Else
				Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
								INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
								INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
								INNER JOIN Country C ON EB.CountryId=C.CountryId 
								INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
								Where C.Country='''+@Country+''' and EM.StatusID<>6
								Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

								 return;
					End
		End

	IF(@Country = null OR @Country = '')
		Begin
			IF(@RoleID=4)
					Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  '+ @strUserQuery+'
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId and C.IsActive=1
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where  EM.StatusID<>6  and SP.SubprocessName in ('+@strSubprocessName+')
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
							
							Union
							
							Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId and C.IsActive=1
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid and SM.Statusid=1  
							Where  EM.StatusID<>6  and SP.SubprocessName in ('+@strSubprocessName+')
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')

							return;
					End

			Else
				Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId and C.IsActive=1
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where  EM.StatusID<>6
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

							return;
					End

		End
		  
End






GO
/****** Object:  StoredProcedure [dbo].[SP_GetStakedBarChartData_1]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetStakedBarChartData_1]  -- exec [SP_GetStakedBarChartData_1] 'Siemens','L2 Support','Test Mail1','354126',4
(
	@Country nvarchar(30),
	@SubprocessName nvarchar(30),
	@MailBoxName nvarchar(30),
	@UserID  nvarchar(30),
	@RoleID  nvarchar(30)
)
As  
Begin  


	declare @strUserQuery nvarchar(max);

	if(@RoleID=4)
		Begin 
			SET @strUserQuery = 'and EM.AssignedToId=''' +@UserID+''''

		END
	else
		Begin
			SET @strUserQuery=''
		End

	If(@MailBoxName <> null OR @MailBoxName <>'')
		Begin
			if(@RoleID=4)
				Begin 
					EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 '+ @strUserQuery+'
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1  
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where EB.EMailBoxName='''+@MailBoxName+''' and SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
							
						Union
							Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1  
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid and SM.Statusid=1
							Where EB.EMailBoxName='''+@MailBoxName+''' and SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')

							 return;
				End
			Else
				Begin
					EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
						INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 
						INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1  
						INNER JOIN Country C ON EB.CountryId=C.CountryId  
						INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
						Where EB.EMailBoxName='''+@MailBoxName+''' and SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							 Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

							 return;
				End

		END

	IF(@SubprocessName <> null OR @SubprocessName <>'')
		Begin
			IF(@RoleID=4)
				Begin
					EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 '+ @strUserQuery+'
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
							
							Union
							
							Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid   and SM.Statusid=1
							Where SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')
							return;
				End
			Else
				Begin
					EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId  
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where SP.SubprocessName='''+@SubprocessName+''' and C.Country='''+@Country+''' and EM.StatusID<>6 
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

							return;
				End
		END

	IF(@Country <> null OR @Country <>'')
		Begin
			IF(@RoleID=4)
					Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
								INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  '+ @strUserQuery+'
								INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
								INNER JOIN Country C ON EB.CountryId=C.CountryId 
								INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid
								Where C.Country='''+@Country+''' and EM.StatusID<>6 
								Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
								
								Union
								
								Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
								INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
								INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
								INNER JOIN Country C ON EB.CountryId=C.CountryId 
								INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid and SM.Statusid=1
								Where C.Country='''+@Country+''' and EM.StatusID<>6
								Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')

								 return;
					End
			Else
				Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
								INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
								INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
								INNER JOIN Country C ON EB.CountryId=C.CountryId 
								INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
								Where C.Country='''+@Country+''' and EM.StatusID<>6
								Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

								 return;
					End
		End

	IF(@Country = null OR @Country = '')
		Begin
			IF(@RoleID=4)
					Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  '+ @strUserQuery+'
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId and C.IsActive=1
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where  EM.StatusID<>6
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
							
							Union
							
							Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId and C.IsActive=1
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid and SM.Statusid=1  
							Where  EM.StatusID<>6
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')

							return;
					End

			Else
				Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId and C.IsActive=1
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where  EM.StatusID<>6
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

							return;
					End

		End
		  
End






GO
/****** Object:  StoredProcedure [dbo].[SP_GetStakedBarChartData_new]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[SP_GetStakedBarChartData_new]  -- exec [SP_GetStakedBarChartData] 'Siemens','','','354126',4
(
	@Country nvarchar(30),
	@SubprocessName nvarchar(30),
	@MailBoxName nvarchar(30),
	@UserID  nvarchar(30),
	@RoleID  nvarchar(30)
)
As  
Begin  


	declare @strUserQuery nvarchar(max);
	declare @strSubprocessName nvarchar(max);
	declare @strSubprocessid nvarchar(max);
	set @strSubprocessid=(select SubProcessGroupId from SubProcessGroups where SubprocessName=@SubprocessName)

	if(@RoleID=4)
		Begin 
			SET @strUserQuery = 'and EM.AssignedToId=''' +@UserID+''''


			DECLARE @Txt1 VARCHAR(MAX)
			SET @Txt1=''
 
			SELECT  @Txt1 = @Txt1 + ''''+SubprocessName +''','
			FROM    (select SG.SubprocessName from UserMailboxmapping UMM 
											join Emailbox EB on UMM.MailBoxID = EB.EMailBoxId 
											join SubProcessGroups SG on SG.SubProcessGroupId = EB.SubProcessGroupId
											where UMM.userID=@UserID)  t

			Select @strSubprocessName = LEFT(@Txt1,LEN(@Txt1)-1) 


		END
	else
		Begin
			SET @strUserQuery=''
			SET @strSubprocessName=''
		End

	If(@MailBoxName <> null OR @MailBoxName <>'')
		Begin
			if(@RoleID=4)
				Begin 
				if exists(select * from Status where SubProcessID=@strSubprocessid)
				begin
					EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''') '+ @strUserQuery+'						
						where SM.ShownInUI=1
						Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId
						Union
						Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''') and SM.STATUSID in (1)
						where SM.ShownInUI=1
						Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId;')
						return;
				end
				else
				begin
					EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID is null	'+ @strUserQuery+'						
						where SM.ShownInUI=1
						Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId
						Union
						Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID is null	and SM.STATUSID in (1)
						where SM.ShownInUI=1
						Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId;')
						return;
				end					
				End
			Else
				Begin
					if exists(select * from Status where SubProcessID=@strSubprocessid)
					begin
						EXEC('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId 
							FROM EMAILMASTER EM
							inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
							and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
							join [Status] SM ON  EM.STATUSID = SM.STATUSID
							inner join SubProcessGroups SP on SP.SubProcessGroupId=SM.SubProcessID						
							inner join Country CN on CN.CountryId=SP.CountryIdMapping				
							and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''')								
							where SM.ShownInUI=1
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')
							return;
					end
					else
					begin
						EXEC('SELECT Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId 
							FROM EMAILMASTER EM
							inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
							and SP.SubprocessName='''+@SubprocessName+''' and EB.EMailBoxName='''+@MailBoxName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
							join [Status] SM ON  EM.STATUSID = SM.STATUSID
							inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
							inner join Country CN on CN.CountryId=SP.CountryIdMapping				
							and EM.StatusID<>6 	and SM.SubProcessID is null							
							where SM.ShownInUI=1
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')
							return;
					end					
				End

		END

	IF(@SubprocessName <> null OR @SubprocessName <>'')
		Begin
			IF(@RoleID=4)
				Begin
				if exists(select * from Status where SubProcessID=@strSubprocessid)
				begin
					EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''')'+ @strUserQuery+'						
						where SM.ShownInUI=1
						Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId
						Union						
						Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''') and SM.STATUSID in (1)
						where SM.ShownInUI=1
						Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId;')
						return;
				end
				else
				begin
					EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId 
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID is null	'+ @strUserQuery+'							
						where SM.ShownInUI=1
						Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId
						Union
						Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID is null	and SM.STATUSID in (1)
						where SM.ShownInUI=1
						Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId;')
						return;
				end					
				End
			Else
				Begin
				if exists(select * from Status where SubProcessID=@strSubprocessid)
				begin
					EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId
						FROM EMAILMASTER EM
						inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
						and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
						join [Status] SM ON  EM.STATUSID = SM.STATUSID
						inner join SubProcessGroups SP on SP.SubProcessGroupId=SM.SubProcessID						
						inner join Country CN on CN.CountryId=SP.CountryIdMapping				
						and EM.StatusID<>6 	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubprocessName+''')								
						where SM.ShownInUI=1
						Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId;')
						return;
				end
				else
				begin
					EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId
					FROM EMAILMASTER EM
					inner join EMailBox EB on EB.EMailBoxId=EM.EMailBoxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox EB Join SubProcessGroups SP ON EB.SubProcessGroupId=SP.SubprocessGroupID and EB.CountryId=SP.CountryIdMapping 
					and SP.SubprocessName='''+@SubprocessName+''' and EB.ISACTIVE=1 join Country C ON EB.CountryId=C.CountryId and  C.Country='''+@Country+''')
					join [Status] SM ON  EM.STATUSID = SM.STATUSID
					inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId
					inner join Country CN on CN.CountryId=SP.CountryIdMapping				
					and EM.StatusID<>6 	and SM.SubProcessID is null							
					where SM.ShownInUI=1
					Group By SM.StatusDescription,SM.STATUSID,SP.SubprocessName, SP.SubProcessGroupId;')
					return;
				end
				End
		END

	IF(@Country <> null OR @Country <>'')
		Begin
			IF(@RoleID=4)
					Begin
						EXEC ('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
								INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  '+ @strUserQuery+' 
								INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
								INNER JOIN Country C ON EB.CountryId=C.CountryId 
								INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid
								Where C.Country='''+@Country+''' and EM.StatusID<>6 and SP.SubprocessName in ('+@strSubprocessName+')
								Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
								
								Union
								
								Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
								INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
								INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
								INNER JOIN Country C ON EB.CountryId=C.CountryId 
								INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid and SM.Statusid=1
								Where C.Country='''+@Country+''' and EM.StatusID<>6 and SP.SubprocessName in ('+@strSubprocessName+')
								Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')

								 return;
					End
			Else
				Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
								INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
								INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
								INNER JOIN Country C ON EB.CountryId=C.CountryId 
								INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
								Where C.Country='''+@Country+''' and EM.StatusID<>6
								Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

								 return;
					End
		End

	IF(@Country = null OR @Country = '')
		Begin
			IF(@RoleID=4)
					Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  '+ @strUserQuery+'
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId and C.IsActive=1
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where  EM.StatusID<>6  and SP.SubprocessName in ('+@strSubprocessName+')
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId
							
							Union
							
							Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1 
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId and C.IsActive=1
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid and SM.Statusid=1  
							Where  EM.StatusID<>6  and SP.SubprocessName in ('+@strSubprocessName+')
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId')

							return;
					End

			Else
				Begin
						EXEC('Select Count(EM.STATUSID) As StatusCount,SM.StatusID,SM.StatusDescription AS StatusName,SP.SubprocessName, SP.SubProcessGroupId From EmailMaster EM   
							INNER JOIN Emailbox EB ON EB.EmailBoxId = EM.EMailBoxId and EB.IsActive = 1  
							INNER JOIN SubProcessGroups SP ON SP.SubProcessGroupId = EB.SubProcessGroupId and SP.IsActive = 1 
							INNER JOIN Country C ON EB.CountryId=C.CountryId and C.IsActive=1
							INNER JOIN [Status] SM ON SM.Statusid = EM.Statusid  
							Where  EM.StatusID<>6
							Group By SM.StatusDescription,SM.STATUSID, SP.SubprocessName, SP.SubProcessGroupId;')

							return;
					End

		End
		  
End






GO
/****** Object:  StoredProcedure [dbo].[SP_INSERTDATETIME]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_INSERTDATETIME]     

AS        

BEGIN



SET NOCOUNT ON;



	DECLARE @CutOffDate DATETIME  

	SET @CutOffDate = DATEADD(mm, -6, CURRENT_TIMESTAMP)

	--SET @CutOffDate = getutcdate()-180  

	SELECT @CutOffDate  

	INSERT INTO TempTable values(getutcdate())

END







GO
/****** Object:  StoredProcedure [dbo].[USP_Acknowledge_MAILBOXADD]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Pranay Ahuja>
-- Create date: <8/16/2016>
-- Description:	<To configure Acknowledgement for Mailbox>
-- =============================================
CREATE PROCEDURE [dbo].[USP_Acknowledge_MAILBOXADD]
	(
	@CountryId int,
    @MailBoxId INT,
    @isActive bit,
    @createdby varchar(20),
    @TemplateType int,
    @Template nvarchar(max)
	)
AS
BEGIN    
 IF NOT EXISTS (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId and TemplateType=@TemplateType)       

		 BEGIN

			INSERT INTO [dbo].[EmailboxRemainderConfig](CountryId,EmailboxId,CreatedbyId,CreatedDate,ModifiedbyId,ModifiedDate,IsActive,TemplateType,Template) values (@CountryId,@MailBoxId,@createdby,getutcdate(),NULL,NULL,@isActive,@TemplateType,@Template)
			select 1
		 END 

		 ELSE   

		 BEGIN
 Select 0 
		 END 
   

END





GO
/****** Object:  StoredProcedure [dbo].[USP_AD_GetDistinctEmailIDsSent]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by Nagababu to get auto pop list of AD user email IDs used in a Mailbox 

--exec USP_GetDistinctEmailIDsSent 'b',1

CREATE procedure [dbo].[USP_AD_GetDistinctEmailIDsSent]
(
	@prefixtext varchar(max)

)
as 
begin 
declare @emaiIDArray varchar(max)
declare @emailCcIDArray varchar(max)
set  @emaiIDArray= (Select distinct
(
Select LOWER(es.emailTo) + ';' AS [text()]
	From emailsent es 

	inner join emailmaster em on es.CaseId=em.CaseId 
	
	Where em.CaseId = es.CaseId and es.EMailTo like '%'+@prefixtext+'%'
	ORDER BY 1
	For XML PATH ('')
)
FROM emailsent)

set  @emailCcIDArray= (Select distinct
(
       Select Lower(es.EMailTo) + ';' AS [text()]

       From emailsent es 

       inner join emailmaster em on es.CaseId=em.CaseId       

     Where em.CaseId = es.CaseId and es.EMailTo like '%'+@prefixtext+'%'

      ORDER BY 1

       For XML PATH ('')
)

FROM emailsent)

--print @emaiIDArray
Select DISTINCT * from [dbo].[Split](@emaiIDArray,';') where items like '%'+@prefixtext+'%'
Select DISTINCT * from [dbo].[Split](@emailCcIDArray,';') where items like '%'+@prefixtext+'%'

end


GO
/****** Object:  StoredProcedure [dbo].[USP_AGING_REPORT]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================      
-- Author:  Kalaichelvan KB            
-- Create date: 07/22/2014            
-- Description: Version(1)                      To Get the Ageing Details of the Cases
--              Version(1.1)  Pranay(423736)    Replacing function dbo.fn_TAT_ExcludeCutOffTime with dbo.fn_TAT_ExcludeCutOffTimeSatSun
-- ================================================================================================================     
  
-- Exec USP_AGING_REPORT 1,2,2,1,2,3,4    
CREATE PROCEDURE [dbo].[USP_AGING_REPORT] --1,2,2,1,2,3,4           
(     
@CountryId VARCHAR(10),    
@SubProcessGroupId VARCHAR(10),    
@EmailBoxId VARCHAR(10),    
@RangeBoundary1 INT,     
@RangeBoundary2 INT,     
@RangeBoundary3 INT,     
@RangeBoundary4 INT,
@OFFSET varchar(30)    
)      
AS    
BEGIN    
DECLARE @CONVERTSECTODAYS INT                
SELECT  @CONVERTSECTODAYS = 86400.00 -- 24 (hrs) multiplied by 60 (min)              
       
 SELECT C.CountryID, C.Country as Program, SPG.SubProcessGroupId, SPG.SubProcessName as ProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription,     
   --SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS) <= @RangeBoundary1 THEN 1 ELSE 0 END) as Range1,      
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS) <= @RangeBoundary1 THEN 1 ELSE 0 END) as Range1,      
   --SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS > @RangeBoundary1 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary2) THEN 1 ELSE 0 END) as [Range1 & Range2],                  
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary1 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary2) THEN 1 ELSE 0 END) as [Range1 & Range2],                  
   --SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS > @RangeBoundary2 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS <= @RangeBoundary3) THEN 1 ELSE 0 END) as [Range2 & Range3],                  
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary2 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS <= @RangeBoundary3) THEN 1 ELSE 0 END) as [Range2 & Range3],                  
   
   --SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS > @RangeBoundary3 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary4) THEN 1 ELSE 0 END) as [Range3 & Range4],                  
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary3 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary4) THEN 1 ELSE 0 END) as [Range3 & Range4],                  
   
   --SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS > @RangeBoundary4) THEN 1 ELSE 0 END) as [Range > 4]      
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary4) THEN 1 ELSE 0 END) as [Range > 4]      
 FROM  Status ST JOIN EmailMaster EM (NOLOCK) ON (EM.StatusID = ST.StatusID)         
  join emailbox eb on eb.emailboxid=em.emailboxid    
  left join Country C on C.CountryID=eb.CountryID    
  left join Subprocessgroups SPG on SPG.SubProcessGroupId=eb.SubProcessGroupId    
  LEFT JOIN EMailAudit A (NOLOCK) ON (EM.CaseId = A.CaseId AND EM.StatusID = A.ToStatusID AND     
  A.EmailAuditID = (SELECT MAX(EmailAuditID) FROM EMailAudit AA (NOLOCK) WHERE AA.CaseID = EM.CaseID))     
 WHERE EM.StatusID IN (      
  2, -- Assigned      
  3, -- Clarification Needed      
  4, -- Clarification Provided      
  5, -- Pending for QC     
  7, -- QC Accepted      
  8 --, -- QC Rejected    
  )    
  and C.CountryID=@CountryID    
  AND (@SubProcessGroupId  IS NULL OR @SubProcessGroupId=0 or SPG.SubProcessGroupId  = @SubProcessGroupId)        
  AND (@EmailBoxId  IS NULL OR @EmailBoxId = 0 or EB.EmailBoxId  = @EmailBoxId)     
 GROUP BY  C.CountryID, C.Country, SPG.SubProcessGroupId, SPG.SubProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription    
     
   UNION -- To get  the open Status          
   SELECT C.CountryID, C.Country as Program, SPG.SubProcessGroupId, SPG.SubProcessName as ProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription,      
	--SUM(CASE WHEN dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS <= @RangeBoundary1 THEN 1 ELSE 0 END) as Range1,      
	SUM(CASE WHEN dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS <= @RangeBoundary1 THEN 1 ELSE 0 END) as Range1,      
   
   --SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS > @RangeBoundary1 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary2) THEN 1 ELSE 0 END) as [Range1 & Range2],                  
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary1 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary2) THEN 1 ELSE 0 END) as [Range1 & Range2],                  
   
   --SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS > @RangeBoundary2 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS <= @RangeBoundary3) THEN 1 ELSE 0 END) as [Range2 & Range3],                  
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary2 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS <= @RangeBoundary3) THEN 1 ELSE 0 END) as [Range2 & Range3],                  
   
   --SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS > @RangeBoundary3 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary4) THEN 1 ELSE 0 END) as [Range3 & Range4],                  
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary3 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary4) THEN 1 ELSE 0 END) as [Range3 & Range4],                  
   
   --SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS > @RangeBoundary4) THEN 1 ELSE 0 END) as [Range > 4]      
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary4) THEN 1 ELSE 0 END) as [Range > 4]      
          
 FROM  Status ST JOIN EmailMaster EEM (NOLOCK) ON (EEM.StatusID = ST.StatusID)         
  join emailbox eb on eb.emailboxid=EEM.emailboxid    
  left join Country C on C.CountryID=eb.CountryID    
  left join Subprocessgroups SPG on SPG.SubProcessGroupId=eb.SubProcessGroupId    
      
WHERE EEM.StatusID = 1  -- Open      
and C.CountryID=@CountryID    
  AND (SPG.SubProcessGroupId  = @SubProcessGroupId)        
  AND (EB.EmailBoxId  = @EmailBoxId)      
GROUP BY  C.CountryID, C.Country, SPG.SubProcessGroupId, SPG.SubProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription     
ORDER BY  C.Country, SPG.SubProcessName, eb.EmailBoxName asc      
END


GO
/****** Object:  StoredProcedure [dbo].[USP_AGING_REPORT_dynamicchanges]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ================================================================================================================      
-- Author:  Kalaichelvan KB            
-- Create date: 07/22/2014            
-- Description: Version(1)                      To Get the Ageing Details of the Cases
--              Version(1.1)  Pranay(423736)    Replacing function dbo.fn_TAT_ExcludeCutOffTime with dbo.fn_TAT_ExcludeCutOffTimeSatSun
-- ================================================================================================================     
  
-- Exec [USP_AGING_REPORT_dynamicchanges] 1,2,2,1,2,3,4    
CREATE PROCEDURE [dbo].[USP_AGING_REPORT_dynamicchanges] --1,2,2,1,2,3,4           
(     
@CountryId VARCHAR(10),    
@SubProcessGroupId VARCHAR(10),    
@EmailBoxId VARCHAR(10),    
@RangeBoundary1 INT,     
@RangeBoundary2 INT,     
@RangeBoundary3 INT,     
@RangeBoundary4 INT,
@OFFSET varchar(30)    
)      
AS    
BEGIN    
DECLARE @CONVERTSECTODAYS INT                
SELECT  @CONVERTSECTODAYS = 86400.00 -- 24 (hrs) multiplied by 60 (min)              

if exists(select * from Status where SubProcessID=@SubProcessGroupId)
begin
	SELECT C.CountryID, C.Country as Program, SPG.SubProcessGroupId, SPG.SubProcessName as ProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription,        
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS) <= @RangeBoundary1 THEN 1 ELSE 0 END) as Range1,         
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary1 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary2) THEN 1 ELSE 0 END) as [Range1 & Range2],                     
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary2 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS <= @RangeBoundary3) THEN 1 ELSE 0 END) as [Range2 & Range3],                       
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary3 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary4) THEN 1 ELSE 0 END) as [Range3 & Range4],                       
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary4) THEN 1 ELSE 0 END) as [Range > 4]      
   FROM  Status ST JOIN EmailMaster EM (NOLOCK) ON (EM.StatusID = ST.StatusID)         
   join emailbox eb on eb.emailboxid=em.emailboxid    
   left join Country C on C.CountryID=eb.CountryID    
   left join Subprocessgroups SPG on SPG.SubProcessGroupId=eb.SubProcessGroupId and ST.SubProcessID=SPG.SubProcessGroupId  
   LEFT JOIN EMailAudit A (NOLOCK) ON (EM.CaseId = A.CaseId AND EM.StatusID = A.ToStatusID AND     
   A.EmailAuditID = (SELECT MAX(EmailAuditID) FROM EMailAudit AA (NOLOCK) WHERE AA.CaseID = EM.CaseID))           
   WHERE EM.StatusID IN (      
   select StatusId from Status where (IsAssigned=1 or IsReminderStatus=1 or IsFollowupStatus=1 or IsQCPending=1 or IsQCApprovedorRejected=1) and SubProcessID=@SubProcessGroupId
   )    
   and C.CountryID=@CountryID    
   AND (@SubProcessGroupId  IS NULL OR @SubProcessGroupId=0 or SPG.SubProcessGroupId  = @SubProcessGroupId)        
   AND (@EmailBoxId  IS NULL OR @EmailBoxId = 0 or EB.EmailBoxId  = @EmailBoxId)     
   GROUP BY  C.CountryID, C.Country, SPG.SubProcessGroupId, SPG.SubProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription         
   UNION -- To get  the open Status          
   SELECT C.CountryID, C.Country as Program, SPG.SubProcessGroupId, SPG.SubProcessName as ProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription,      
   SUM(CASE WHEN dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS <= @RangeBoundary1 THEN 1 ELSE 0 END) as Range1,           
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary1 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary2) THEN 1 ELSE 0 END) as [Range1 & Range2],                        
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary2 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS <= @RangeBoundary3) THEN 1 ELSE 0 END) as [Range2 & Range3],                        
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary3 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary4) THEN 1 ELSE 0 END) as [Range3 & Range4],                        
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary4) THEN 1 ELSE 0 END) as [Range > 4]                
   FROM  Status ST JOIN EmailMaster EEM (NOLOCK) ON (EEM.StatusID = ST.StatusID)         
   join emailbox eb on eb.emailboxid=EEM.emailboxid    
   left join Country C on C.CountryID=eb.CountryID    
   left join Subprocessgroups SPG on SPG.SubProcessGroupId=eb.SubProcessGroupId and ST.SubProcessID=SPG.SubProcessGroupId              
   WHERE EEM.StatusID in (select StatusId from Status where IsInitalStatus=1 and StatusDescription!='Duplicate' and SubProcessID=@SubProcessGroupId)  -- Open      
   and C.CountryID=@CountryID    
   AND (SPG.SubProcessGroupId  = @SubProcessGroupId)        
   AND (EB.EmailBoxId  = @EmailBoxId)      
   GROUP BY  C.CountryID, C.Country, SPG.SubProcessGroupId, SPG.SubProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription     
   ORDER BY  C.Country, SPG.SubProcessName, eb.EmailBoxName asc      
end
else
begin
   SELECT C.CountryID, C.Country as Program, SPG.SubProcessGroupId, SPG.SubProcessName as ProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription,        
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS) <= @RangeBoundary1 THEN 1 ELSE 0 END) as Range1,         
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary1 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary2) THEN 1 ELSE 0 END) as [Range1 & Range2],                     
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary2 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS <= @RangeBoundary3) THEN 1 ELSE 0 END) as [Range2 & Range3],                       
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary3 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.EndTime, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary4) THEN 1 ELSE 0 END) as [Range3 & Range4],                       
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary4) THEN 1 ELSE 0 END) as [Range > 4]      
   FROM  Status ST JOIN EmailMaster EM (NOLOCK) ON (EM.StatusID = ST.StatusID)         
   join emailbox eb on eb.emailboxid=em.emailboxid    
   left join Country C on C.CountryID=eb.CountryID    
   left join Subprocessgroups SPG on SPG.SubProcessGroupId=eb.SubProcessGroupId  
   LEFT JOIN EMailAudit A (NOLOCK) ON (EM.CaseId = A.CaseId AND EM.StatusID = A.ToStatusID AND     
   A.EmailAuditID = (SELECT MAX(EmailAuditID) FROM EMailAudit AA (NOLOCK) WHERE AA.CaseID = EM.CaseID))           
   WHERE EM.StatusID IN (      
   select StatusId from Status where (IsAssigned=1 or IsReminderStatus=1 or IsFollowupStatus=1 or IsQCPending=1 or IsQCApprovedorRejected=1) and SubProcessID is null
   )    
   and C.CountryID=@CountryID    
   AND (@SubProcessGroupId  IS NULL OR @SubProcessGroupId=0 or SPG.SubProcessGroupId  = @SubProcessGroupId)        
   AND (@EmailBoxId  IS NULL OR @EmailBoxId = 0 or EB.EmailBoxId  = @EmailBoxId)     
   GROUP BY  C.CountryID, C.Country, SPG.SubProcessGroupId, SPG.SubProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription         
   UNION -- To get  the open Status          
   SELECT C.CountryID, C.Country as Program, SPG.SubProcessGroupId, SPG.SubProcessName as ProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription,      
   SUM(CASE WHEN dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS <= @RangeBoundary1 THEN 1 ELSE 0 END) as Range1,           
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary1 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary2) THEN 1 ELSE 0 END) as [Range1 & Range2],                        
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary2 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS <= @RangeBoundary3) THEN 1 ELSE 0 END) as [Range2 & Range3],                        
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary3 AND dbo.fn_TAT_ExcludeCutOffTimeSatSun(EEM.CreatedDate, GetDate())/@CONVERTSECTODAYS  <= @RangeBoundary4) THEN 1 ELSE 0 END) as [Range3 & Range4],                        
   SUM(CASE WHEN (dbo.fn_TAT_ExcludeCutOffTimeSatSun(Convert(Datetime,[dbo].[ChangeDatesAsPerUserTimeZone](EEM.CreatedDate,@OFFSET),120), GetDate())/@CONVERTSECTODAYS > @RangeBoundary4) THEN 1 ELSE 0 END) as [Range > 4]                
   FROM  Status ST JOIN EmailMaster EEM (NOLOCK) ON (EEM.StatusID = ST.StatusID)         
   join emailbox eb on eb.emailboxid=EEM.emailboxid    
   left join Country C on C.CountryID=eb.CountryID    
   left join Subprocessgroups SPG on SPG.SubProcessGroupId=eb.SubProcessGroupId             
   WHERE EEM.StatusID in (select StatusId from Status where IsInitalStatus=1 and StatusDescription!='Duplicate' and SubProcessID is null)  -- Open      
   and C.CountryID=@CountryID    
   AND (SPG.SubProcessGroupId  = @SubProcessGroupId)        
   AND (EB.EmailBoxId  = @EmailBoxId)      
   GROUP BY  C.CountryID, C.Country, SPG.SubProcessGroupId, SPG.SubProcessName, eb.EmailBoxId, eb.EmailBoxName, ST.StatusId, ST.StatusDescription     
   ORDER BY  C.Country, SPG.SubProcessName, eb.EmailBoxName asc      
end   
END


GO
/****** Object:  StoredProcedure [dbo].[USP_BIND_ACTIVE_MAILBOX]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Kalaichelvan.K.B.    
-- Create date: 06/04/2014      
-- Description: To bind the ACTIVE MAILBOX  
-- =============================================   
  
CREATE PROCEDURE [dbo].[USP_BIND_ACTIVE_MAILBOX]    
 AS            
BEGIN     
     
 SELECT EMAILBOXID, EMAILBOXNAME FROM [dbo].EMAILBOX where ISACTIVE=1  
   order by EMAILBOXNAME  
END  
  
--select * from UserRole  
--select * from usermaster    
    
--select * from country    
--select * from EMAILBOX 






GO
/****** Object:  StoredProcedure [dbo].[USP_BIND_ACTIVE_USERS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--SP_HELPTEXT USP_BIND_ACTIVE_USERS

-- =============================================      
-- Author:  Kalaichelvan.K.B.    
-- Create date: 05/30/2014      
-- Description: To bind the ACTIVE USERS  
-- =============================================   
  
CREATE PROCEDURE [dbo].[USP_BIND_ACTIVE_USERS]    
 AS            
BEGIN     
     
 SELECT UM.UserID, UM.FirstName+' ' + UM.LastName +' (' + UM.UserID +') ' as UserName FROM [dbo].UserMaster UM  where UM.ISACTIVE=1  
   order by Username  
END  
  
--select * from UserRole  
--select * from usermaster






GO
/****** Object:  StoredProcedure [dbo].[USP_BIND_country_based_Emailbox]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Author:  Kalaichelvan.K.B.          
-- Create date: 06/10/2014            
-- Description: To bind the ACTIVE MAILBOX based on the country selection       
-- =================================================================================         
CREATE PROCEDURE [dbo].[USP_BIND_country_based_Emailbox]      
(      
@COUNTRYID INT,      
@LoggedInUserId varchar(20),    
@LoggedInUserRoleId varchar(20)    
)      
AS      
BEGIN    
    
  if(@LoggedInUserRoleId<>3)    
				 begin    
				  SELECT  EMAILBOXID, EMAILBOXNAME FROM EMAILBOX WHERE COUNTRYID=@COUNTRYID and isactive=1      
				 end    
  else    
			   begin    
			  select eb.EMailBoxId, eb.EMailBoxName    
			  from EMailBox eb inner join    
			  UserMailBoxMapping uebm on eb.EMailBoxId = uebm.MailBoxId where eb.IsActive=1 and eb.CountryId=@COUNTRYID and uebm.UserId=@LoggedInUserId    
			 end    
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_BIND_EMAILBOX_LOGINMAILID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_UPDATE_COUNTRY
-- ==============================================================  
-- Author:  Kalaichelvan KB        
-- Create date: 06/06/2014        
-- Description: To ind the EmailBox Login MailIds to the dropdown
-- ==============================================================  
CREATE PROCEDURE [dbo].[USP_BIND_EMAILBOX_LOGINMAILID]             
AS            
BEGIN             
 Select  emailboxlogindetailid, emailid from emailboxlogindetail where Islocked=0 and IsActive=1 order by emailid asc
End






GO
/****** Object:  StoredProcedure [dbo].[USP_BIND_ROLES]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================    
-- Author:  Kalaichelvan KB          
-- Create date: 05/26/2014          
-- Description: To Bind Roles to the dropdown
-- ====================================================   
CREATE PROC [dbo].[USP_BIND_ROLES]      
      
AS              
BEGIN       
       
 SELECT UR.UserRoleID, UR.RoleDescription FROM [dbo].UserRole UR where userroleid!=1 order by UR.UserRoleID    
       
END






GO
/****** Object:  StoredProcedure [dbo].[USP_BIND_SUBPROCESSNAMES]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================================          
-- AUTHOR:  KALAICHELVAN KB                
-- CREATE DATE: 06/23/2014                
-- DESCRIPTION: BINDING SUBPROCESS NAMES TO THE DROPDOWN
-- =======================================================     

CREATE PROCEDURE [dbo].[USP_BIND_SUBPROCESSNAMES]
AS
BEGIN
SELECT SUBPROCESSGROUPID, SUBPROCESSNAME FROM SUBPROCESSGROUPS WHERE ISACTIVE=1 order by SUBPROCESSNAME asc
END







GO
/****** Object:  StoredProcedure [dbo].[USP_BindFieldName]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[USP_BindFieldName]   
@intFieldMasterID int      

As        

Begin        
BEGIN TRAN TXN_INSERT        

BEGIN TRY        

select FieldName,FieldTypeId from [dbo].[Tbl_FieldConfiguration] WHERE FieldMasterId=@intFieldMasterID

--select * from Tbl_Master_FieldType

END TRY        
           BEGIN CATCH        


                  GOTO HandleError1        

            END CATCH        
            IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT        

            RETURN 1        
      HandleError1:        

            IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT        
            RAISERROR('Error Insert table Tbl_FieldConfiguration', 16, 1)        
            RETURN -1        
ENd
 







GO
/****** Object:  StoredProcedure [dbo].[USP_CATEGORY_MAILBOXADD]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================================================    







-- Author:  Ranjith        







-- Create date: 05/19/2015         







-- Description: To configure the CATEGORY for mailbox







-- ====================================================  







CREATE PROCEDURE [dbo].[USP_CATEGORY_MAILBOXADD]    



(    



@CountryId int,



@MailBoxId INT,  



@Category varchar(200),



@isActive bit,



@createdby varchar(20)



)    



AS    



BEGIN    



 IF NOT EXISTS (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxCategoryConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId and Category =@Category)       







		 BEGIN







			INSERT INTO [dbo].[EmailboxCategoryConfig] values (@CountryId,@MailBoxId,@Category,@createdby,getutcdate(),NULL,NULL,@isActive)



			select 1



		 END 







		 ELSE   







		 BEGIN



 Select 0 



		 END 



   







END 








GO
/****** Object:  StoredProcedure [dbo].[USP_CHANGEPASSWORD]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================    
-- Author:  Kalaichelvan.K.B.  
-- Create date: 05/23/2014    
-- Description: To change the Password
-- =============================================    
CREATE PROCEDURE [dbo].[USP_CHANGEPASSWORD]     
(                  
 @UserId varchar(25),          
 @OldPassword varchar(200),          
 @NewPassword varchar(200)           
)         
AS      
BEGIN      
  IF  EXISTS (select [UserId] from UserMaster where [UserId] = @UserId and password=@OldPassword)
     BEGIN     
     UPDATE UserMaster SET [password] = @NewPassword  WHERE [userId] = @UserId
     END
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_CHANGEPASSWORD1]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  Kalaichelvan.K.B.  
-- Create date: 05/23/2014    
-- Description: To change the Password
-- =============================================    
CREATE PROCEDURE [dbo].[USP_CHANGEPASSWORD1]     
(                  
 @UserId varchar(25),          
 @OldPassword varchar(200),          
 @NewPassword varchar(200)           
)         
AS      
BEGIN      
  IF  EXISTS (select [UserId] from UserMaster where [UserId] = @UserId and password=@OldPassword)
     BEGIN     
     UPDATE UserMaster SET [password] = @NewPassword ,PasswordCreatedDate=convert(varchar(10),getutcdate(),101)  WHERE [userId] = @UserId
     END
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Check_ConcurrentSessions]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_Check_ConcurrentSessions]      
 @SessionId varchar(max),     
 @UserId varchar(max)
AS              
BEGIN   
declare @sessiontimediff int
declare @existingsessiontime date
declare @existingsessionid date
set @existingsessionid=(select SessionId from UserMaster where UserId=@UserId)
set @existingsessiontime=(select SessionTime from UserMaster where UserId=@UserId)
 if(@existingsessionid<>NULL)
 begin      
	if exists(select SessionId from UserMaster where SessionId=@SessionId and UserId=@UserId)
	begin
		select 1--success		
	end
	else
	begin
		set @sessiontimediff=DATEDIFF(MINUTE, @existingsessiontime , GETDATE())
		if(@sessiontimediff<=20)
		begin
			select 0--deny access
		end
		else
		begin			
			Update UserMaster set SessionId=@SessionId ,SessionTime=getdate() where UserId=@UserId
			select 1--success
		end		
	end
 end   
 else
 begin
	Update UserMaster set SessionId=@SessionId,SessionTime=getdate() where UserId=@UserId
	select 1--success
 end  
END




--select * from UserMaster where UserId='195174'
GO
/****** Object:  StoredProcedure [dbo].[USP_CHK_USER_EXIST]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Kalaichelvan     
-- Create date: 23/05/2014      
-- Description: To check the user exists or not
-- =============================================  

CREATE PROCEDURE [dbo].[USP_CHK_USER_EXIST]
 (            
 @UserId nvarchar(25),     
 @Success int out  
 )  
 AS    
  BEGIN  
  IF  EXISTS (select UserId from UserMaster where UserId = @UserId)
  BEGIN            
  set @Success = 1   
 END   
 ELse  
 set @Success =0  
 END 






GO
/****** Object:  StoredProcedure [dbo].[USP_CONFIGUREOPTIONTOFIELD]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

















CREATE proc [dbo].[USP_CONFIGUREOPTIONTOFIELD]   

@OptionText nvarchar(200),  

@OptionValue int  ,   

@Active int,        

@CreatedBy varchar(100),

@FieldmasterID int      

As        

Begin        

Declare @Retval int         

BEGIN TRAN TXN_INSERT        









BEGIN TRY        

   

if not exists (select OptionText from [dbo].[Tbl_DefaultListValues] where  FieldMasterId=@FieldmasterID and OptionText=  @OptionText  )

	begin

	Insert into [dbo].[Tbl_DefaultListValues] (FieldMasterId,OptionValue,OptionText,Active,CreatedBy,CreatedDate) values

	(@FieldmasterID,@OptionValue,@OptionText,@Active,@CreatedBy,getutcdate())

	set @Retval =1

	select @Retval

	end



else



	begin

	set @Retval =2

	select @Retval

	end







END TRY        















            BEGIN CATCH        















                  GOTO HandleError1        















            END CATCH        















            IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT        















            RETURN 1        















      HandleError1:        















            IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT        















            RAISERROR('Error Insert table Tbl_FieldConfiguration', 16, 1)        















            RETURN -1        















        















        















        















End








GO
/****** Object:  StoredProcedure [dbo].[USP_COUNTRY_CONFIGURATION]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_COUNTRY_CONFIGURATION]    
(    
@COUNTRYNAME VARCHAR(200),    
@ISACTIVE INT,    
@CREATEDBY VARCHAR(25)    
--@SUCCESS INT OUT    
)    
AS    
BEGIN    
 IF not exists (select COUNTRY from Country where Country=@CountryName)    
  BEGIN    
   INSERT INTO Country (COUNTRY, ISACTIVE, CreatedByID, CreatedDate, ModifiedByID, ModifiedDate)                    
   VALUES (@COUNTRYNAME, @ISACTIVE, @CREATEDBY, Convert(Varchar(10),getutcdate(),101), @CREATEDBY, Convert(Varchar(10),getutcdate(),101))    
   SELECT 1    
  END    
 ELSE    
  SELECT 0    
END    







GO
/****** Object:  StoredProcedure [dbo].[USP_CREATE_USERS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--sp_helptext USP_CREATE_USERS

--EXEC [USP_CREATE_USERS] '254649','Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, '254649', getutcdate()  
-- =======================================================  
-- Author:  Kalaichelvan KB        
-- Create date: 05/23/2014        
-- Description: To insert the users into the master table  
-- =======================================================  
  
CREATE PROCEDURE [dbo].[USP_CREATE_USERS]  
(  
@USERID VARCHAR(25),  
@FIRSTNAME VARCHAR(100),  
@LASTNAME VARCHAR(100),  
@EMAIL VARCHAR(300),  
@PASSWORD VARCHAR(50),  
@ISACTIVE INT,  
@LoggedinUserId VARCHAR(25),
@TIMEZONE VARCHAR(100),
@OFFSET VARCHAR(100),
@SkillId varchar(100),
@SkillDescription VARCHAR(250)  
)  
AS  
BEGIN  
IF @USERID is not NULL or @USERID !=''  
 BEGIN  
  IF not exists (SELECT USERID,eMAIL FROM USERMASTER WHERE USERID=@USERID)  
   BEGIN  
    INSERT INTO USERMASTER (USERID, FirstName, LastName, EMAIL, [Password], Isactive, CreatedBy, CreatedDate, ModifiedById, ModifiedDate,TimeZone,Offset,SkillId,SkillDescription,PasswordCreatedDate)                  
    VALUES (@USERID, @FIRSTNAME, @LASTNAME, @EMAIL, @PASSWORD, @ISACTIVE, @LoggedinUserId, convert(varchar(10),getutcdate(),101), @LoggedinUserId, convert(varchar(10),getutcdate(),101),@TIMEZONE,@OFFSET,@skillid,@SkillDescription,getutcdate())  
    Select   1  
   END  
  Select   0  
 END  
  RETURN  
END  
  
--select * from UserMaster  
  
--insert into UserMaster values (254649,'Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, 254649, getutcdate())  
  
  
  --IF not exists (SELECT USERID,eMAIL FROM USERMASTER WHERE USERID=254649 AND EMAIL='Kalaichelvan.KB@Cognizant.com')  
  --select 1    
  --else select 0  
  --return
GO
/****** Object:  StoredProcedure [dbo].[USP_CREATEMANUALCASE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
* CREATED BY : RAGUVARAN E

* CREATED DATE : 05/26/2014

* PURPOSE : TO CREATE A MANUAL CASE

*/

CREATE PROCEDURE [dbo].[USP_CREATEMANUALCASE]
(
	@FROMEMAILID AS VARCHAR(250),
	@TOEMAILID AS VARCHAR(MAX),
	@CCEMAILID AS VARCHAR(MAX),
	@SUBJECT AS VARCHAR(MAX),
	@EMAILBODY AS VARCHAR(MAX),
	@EMAILBOXID AS INT,
	@USERID AS VARCHAR(50),
	@ISREPLYNOTREQUIRED AS bit,
	@ISNOTIFICATION AS BIT,
	@COMPOSEGMB AS BIT,
	@CASEID AS BIGINT OUT	
)

AS

BEGIN

DECLARE @TOCASESTATUS INT

DECLARE @ClassificationID INT

IF @ISREPLYNOTREQUIRED = 1

BEGIN

	SET @TOCASESTATUS=10	
		
	INSERT INTO EMAILMASTER (EMAILRECEIVEDDATE,EMAILFROM,EMAILTO,EMAILCC,[SUBJECT],EMAILBODY,EMAILBOXID,STATUSID,CREATEDDATE,ASSIGNEDTOID,

	ASSIGNEDDATE,MODIFIEDBYID,MODIFIEDDATE,ISURGENT,ISMANUAL,CREATEDBYID,COMPLETEDBYID,COMPLETEDDATE,Isnotification,CategoryId)

	VALUES (getutcdate(),@FROMEMAILID,@TOEMAILID,@CCEMAILID,@SUBJECT,@EMAILBODY,@EMAILBOXID,@TOCASESTATUS,getutcdate(),@USERID,
	
	getutcdate(),@USERID,getutcdate(),0,1,@USERID,@USERID,getutcdate(),@ISNOTIFICATION,6)	
	
END

ELSE

BEGIN

	IF @ISNOTIFICATION = 1
	
	BEGIN

	SET @TOCASESTATUS=10	
	
	INSERT INTO EMAILMASTER (EMAILRECEIVEDDATE,EMAILFROM,EMAILTO,EMAILCC,[SUBJECT],EMAILBODY,EMAILBOXID,STATUSID,CREATEDDATE,ASSIGNEDTOID,
	
	ASSIGNEDDATE,MODIFIEDBYID,MODIFIEDDATE,ISURGENT,ISMANUAL,CREATEDBYID,COMPLETEDBYID,COMPLETEDDATE,Isnotification,CategoryId)

	VALUES (getutcdate(),@FROMEMAILID,@TOEMAILID,@CCEMAILID,@SUBJECT,@EMAILBODY,@EMAILBOXID,@TOCASESTATUS,getutcdate(),@USERID,
	
	getutcdate(),@USERID,getutcdate(),0,1,@USERID,@USERID,getutcdate(),@ISNOTIFICATION,6)		
	
	END	

	----COMPOSE_GMB_CASES AUTO ASSIGN
	ELSE IF @COMPOSEGMB = 1
	
	BEGIN

	SET @TOCASESTATUS=2

	INSERT INTO EMAILMASTER (EMAILRECEIVEDDATE,EMAILFROM,EMAILTO,EMAILCC,SUBJECT,EMAILBODY,EMAILBOXID,STATUSID,CREATEDDATE,ASSIGNEDTOID,
	
	ASSIGNEDDATE,MODIFIEDBYID,MODIFIEDDATE,ISURGENT,ISMANUAL,CREATEDBYID,COMPLETEDBYID,COMPLETEDDATE,Isnotification,CategoryId,ForwardedToGMB)

	VALUES (GETDATE(),@FROMEMAILID,@TOEMAILID,@CCEMAILID,@SUBJECT,@EMAILBODY,@EMAILBOXID,@TOCASESTATUS,GETDATE(),@USERID,
	
	GETDATE(),@USERID,GETDATE(),0,1,@USERID,null,null,@ISNOTIFICATION,6,1)
	
	END
------
	ELSE

	BEGIN
	
	SET @TOCASESTATUS=3	

	INSERT INTO EMAILMASTER (EMAILRECEIVEDDATE,EMAILFROM,EMAILTO,EMAILCC,[SUBJECT],EMAILBODY,EMAILBOXID,STATUSID,CREATEDDATE,ASSIGNEDTOID,
	
	ASSIGNEDDATE,MODIFIEDBYID,MODIFIEDDATE,ISURGENT,ISMANUAL,CREATEDBYID,Isnotification,CategoryId)

	VALUES (getutcdate(),@FROMEMAILID,@TOEMAILID,@CCEMAILID,@SUBJECT,@EMAILBODY,@EMAILBOXID,@TOCASESTATUS,getutcdate(),@USERID,

	getutcdate(),@USERID,getutcdate(),0,1,@USERID,@ISNOTIFICATION,6)	

	END

END

SELECT @CASEID=@@IDENTITY 

INSERT INTO EMAILAUDIT (CASEID,FROMSTATUSID,TOSTATUSID,USERID,STARTTIME,ENDTIME)

VALUES (@CASEID,1,@TOCASESTATUS,@USERID,getutcdate(),getutcdate())


Declare @AuditID bigint

Select @AuditID=@@IDENTITY 

INSERT INTO [CategoryTransaction] (Caseid,AuditID,CateroryID,CreatedDate)

VALUES (@CASEID,@AuditID,6,getutcdate())

-- select * from EmailboxCategoryConfig where emailboxcategoryid=6  -- for manual case category

END
GO
/****** Object:  StoredProcedure [dbo].[USP_CREATEMANUALCASE_test]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
* CREATED BY : RAGUVARAN E

* CREATED DATE : 05/26/2014

* PURPOSE : TO CREATE A MANUAL CASE

*/

CREATE PROCEDURE [dbo].[USP_CREATEMANUALCASE_test]
(
	@FROMEMAILID AS VARCHAR(250),
	@TOEMAILID AS VARCHAR(MAX),
	@CCEMAILID AS VARCHAR(MAX),
	@SUBJECT AS VARCHAR(MAX),
	@EMAILBODY AS VARCHAR(MAX),
	@EMAILBOXID AS INT,
	@USERID AS VARCHAR(50),
	@ISREPLYNOTREQUIRED AS bit,
	@StatusId AS INT,
	@CASEID AS BIGINT OUT,
	@COMPOSEGMB AS BIT,
	@Classification AS VARCHAR(MAX)
)

AS

BEGIN

DECLARE @ClassificationID INT

IF @ISREPLYNOTREQUIRED = 1

BEGIN

	
	
	if exists(select * from InboundClassification where IsActive=1)
	
	begin
	
	select @ClassificationID=classificationID from InboundClassification where ClassifiactionDescription=@Classification

	INSERT INTO EMAILMASTER (EMAILRECEIVEDDATE,EMAILFROM,EMAILTO,EMAILCC,[SUBJECT],EMAILBODY,EMAILBOXID,STATUSID,CREATEDDATE,ASSIGNEDTOID,

	ASSIGNEDDATE,MODIFIEDBYID,MODIFIEDDATE,ISURGENT,ISMANUAL,CREATEDBYID,COMPLETEDBYID,COMPLETEDDATE,CategoryId,Bodycontent,ClassificationID)

	VALUES (getutcdate(),@FROMEMAILID,@TOEMAILID,@CCEMAILID,@SUBJECT,@EMAILBODY,@EMAILBOXID,@StatusId,getutcdate(),@USERID,
	
	getutcdate(),@USERID,getutcdate(),0,1,@USERID,@USERID,getutcdate(),6,@EMAILBODY,@ClassificationID)
	
	end
	
	else
	
	begin	
	
	INSERT INTO EMAILMASTER (EMAILRECEIVEDDATE,EMAILFROM,EMAILTO,EMAILCC,[SUBJECT],EMAILBODY,EMAILBOXID,STATUSID,CREATEDDATE,ASSIGNEDTOID,

	ASSIGNEDDATE,MODIFIEDBYID,MODIFIEDDATE,ISURGENT,ISMANUAL,CREATEDBYID,COMPLETEDBYID,COMPLETEDDATE,CategoryId)

	VALUES (getutcdate(),@FROMEMAILID,@TOEMAILID,@CCEMAILID,@SUBJECT,@EMAILBODY,@EMAILBOXID,@StatusId,getutcdate(),@USERID,
	
	getutcdate(),@USERID,getutcdate(),0,1,@USERID,@USERID,getutcdate(),6)
	
	end
	
END

ELSE

BEGIN

	if exists(select * from InboundClassification where IsActive=1)

	begin

	select @ClassificationID=classificationID from InboundClassification where ClassifiactionDescription=@Classification	
	
	INSERT INTO EMAILMASTER (EMAILRECEIVEDDATE,EMAILFROM,EMAILTO,EMAILCC,[SUBJECT],EMAILBODY,EMAILBOXID,STATUSID,CREATEDDATE,ASSIGNEDTOID,
	
	ASSIGNEDDATE,MODIFIEDBYID,MODIFIEDDATE,ISURGENT,ISMANUAL,CREATEDBYID,CategoryId,Bodycontent,ClassificationID)

	VALUES (getutcdate(),@FROMEMAILID,@TOEMAILID,@CCEMAILID,@SUBJECT,@EMAILBODY,@EMAILBOXID,@StatusId,getutcdate(),@USERID,

	getutcdate(),@USERID,getutcdate(),0,1,@USERID,6,@EMAILBODY,@ClassificationID)	

	end

	else

	begin

	INSERT INTO EMAILMASTER (EMAILRECEIVEDDATE,EMAILFROM,EMAILTO,EMAILCC,[SUBJECT],EMAILBODY,EMAILBOXID,STATUSID,CREATEDDATE,ASSIGNEDTOID,
	
	ASSIGNEDDATE,MODIFIEDBYID,MODIFIEDDATE,ISURGENT,ISMANUAL,CREATEDBYID,CategoryId)

	VALUES (getutcdate(),@FROMEMAILID,@TOEMAILID,@CCEMAILID,@SUBJECT,@EMAILBODY,@EMAILBOXID,@StatusId,getutcdate(),@USERID,

	getutcdate(),@USERID,getutcdate(),0,1,@USERID,6)

	end
	
	
END

SELECT @CASEID=@@IDENTITY 

if exists(select * from InboundClassification where IsActive=1)

begin

	INSERT INTO ClassificationAudit (CASEID,FromClassificationId,ToClassificationId,ModifiedbyId,IsRemapped,CreatedDate)

	VALUES (@CASEID,@ClassificationID,null,@USERID,0,getutcdate())

end

INSERT INTO EMAILAUDIT (CASEID,FROMSTATUSID,TOSTATUSID,USERID,STARTTIME,ENDTIME)

VALUES (@CASEID,1,@StatusId,@USERID,getutcdate(),getutcdate())


Declare @AuditID bigint

Select @AuditID=@@IDENTITY 

INSERT INTO [CategoryTransaction] (Caseid,AuditID,CateroryID,CreatedDate)

VALUES (@CASEID,@AuditID,6,getutcdate())

-- select * from EmailboxCategoryConfig where emailboxcategoryid=6  -- for manual case category

END
GO
/****** Object:  StoredProcedure [dbo].[USP_DELETE_Country]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC USP_UPDATE_USERS '254649','Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, '254649', getdate(),1
-- =======================================================
-- Author:  Kalaichelvan KB      
-- Create date: 05/26/2014      
-- Description: To DELETE the COUNTRY Details FROM the master table
-- =======================================================

CREATE PROCEDURE [dbo].[USP_DELETE_Country]
(
@CountryId int
)
AS
BEGIN
 IF exists (select @CountryId from Country WHERE CountryId=@CountryId)
  BEGIN
   DELETE FROM Country WHERE @CountryId=@CountryId
  END
END






GO
/****** Object:  StoredProcedure [dbo].[USP_DELETE_MAILBOX]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--EXEC USP_UPDATE_USERS '254649','Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, '254649', getdate(),1
-- =======================================================
-- Author:  Kalaichelvan KB      
-- Create date: 05/26/2014      
-- Description: To DELETE the MAilBox Details FROM the master table
-- =======================================================

CREATE PROCEDURE [dbo].[USP_DELETE_MAILBOX]
(
@EMailBoxId int
)
AS
BEGIN
 IF exists (select EMailBoxId from EMailBox WHERE EMailBoxId=@EMailBoxId)
  BEGIN
   DELETE FROM EMailBox WHERE EMailBoxId=@EMailBoxId
  END
END






GO
/****** Object:  StoredProcedure [dbo].[USP_DELETE_MAILBOXMAPPED_USERS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_DELETE_MAILBOXMAPPED_USERS

--sp_helptext USP_DELETE_MAILBOXMAPPED_USERS  
-- ====================================================    
-- Author:  Kalaichelvan KB          
-- Create date: 05/26/2014          
-- Description: To DELETE the mapped users to the MAILBOX    
-- ====================================================    
CREATE PROCEDURE [dbo].[USP_DELETE_MAILBOXMAPPED_USERS]    
(    
@UsermailBoxMappingId int,
@USERID VARCHAR(50)
)    
AS    
BEGIN    
 IF @UsermailBoxMappingId is not null    
  BEGIN
   If not exists (select Caseid from emailmaster where AssignedtoId=@USERID)
    BEGIN     
     DELETE FROM UserMailBoxMapping where UsermailBoxMappingId=@UsermailBoxMappingId    
      SELECT 1  
    END  
   ELSE  
    SELECT 2
  END   
 ELSE
  SELECT 0    
END 

--select * from EmailMaster






GO
/****** Object:  StoredProcedure [dbo].[USP_DELETE_ROLEMAPPED_USERS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================
-- Author:  Kalaichelvan KB      
-- Create date: 05/26/2014      
-- Description: To DELETE the mapped users to the roles
-- ====================================================
CREATE PROCEDURE [dbo].[USP_DELETE_ROLEMAPPED_USERS]
(
@UserRoleMappingId int
)
AS
BEGIN
 IF @UserRoleMappingID is not null
  BEGIN 
   DELETE FROM UserRoleMapping where UserRoleMappingID=@UserRoleMappingID
   SELECT 1
  END
 ELSE
  SELECT 0
END  






GO
/****** Object:  StoredProcedure [dbo].[USP_DELETE_USER]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================
-- Author:  Kalaichelvan KB      
-- Create date: 05/26/2014      
-- Description: To DELETE the user details into the master table
-- ==============================================================
CREATE PROCEDURE [dbo].[USP_DELETE_USER]          
(   
@USERID VARCHAR(25)
)             
AS          
BEGIN           
 IF  EXISTS (select [UserId] from UserMaster where [UserId] = @UserId)             
  BEGIN     
   DELETE FROM UserMaster where userid=@UserId     
  END                 
End 






GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteLastDraft]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[USP_DeleteLastDraft]
(  
 
  @Caseid as bigint
  
)
AS  
BEGIN  
 if EXISTS(SELECT CASEID FROM Draftsave_att where CaseId=@Caseid)
 BEGIN
  delete from Draftsave_att where CaseId=@Caseid
  END
 
END


GO
/****** Object:  StoredProcedure [dbo].[USP_DeleteTotalDraft]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
creATE PROCEDURE [dbo].[USP_DeleteTotalDraft]
(  
 
  @Caseid as bigint
  
)
AS    
BEGIN    
 if EXISTS(SELECT CASEID FROM Draftsave_att where CaseId=@Caseid)  
 BEGIN  
  delete from Draftsave_att where CaseId=@Caseid  
  END  
  IF EXISTS (SELECT CASEID FROM Draftsave WHERE CASEID=@Caseid)
  BEGIN
  delete from Draftsave where CASEID=@Caseid
  END
END


GO
/****** Object:  StoredProcedure [dbo].[USP_DetectDuplicate]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_DetectDuplicate]  
(
@MailBoxId int,
@xml XML 
) 
as
BEGIN      
      
SET NOCOUNT ON
DECLARE
   
	@queryInput as NVArchar(max),
	@joinQuery as NVARCHAR(max)
	
	if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'IndexInput'
			   )
	begin
			drop table IndexInput
	end 

	if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'IndexResults'
			   )
	begin
			drop table IndexResults
	end 
	  
declare @queryDBResultset as NVARCHAR(Max)
declare @queryInputResultset as NVARCHAR(Max)
 --set @xml= N'<root><row  FieldMasterID = ''113''  FieldValue =''dfsdf''    IsListValue = ''0'' /><row  FieldMasterID = ''115''  FieldValue =''sdfsdf''    IsListValue = ''0'' /><row  FieldMasterID = ''117''  FieldValue =''dsfsdf''    IsListValue = ''0'' /><row  FieldMasterID = ''114''  FieldValue =''dsfsdf''    IsListValue = ''0'' /><row  FieldMasterID = ''116''  FieldValue =''sdfsdf''    IsListValue = ''0'' /><row  FieldMasterID = ''118''  FieldValue =''sdfsdf''    IsListValue = ''0'' /></root>'
 
 IF OBJECT_ID('#temp') IS NOT NULL
  /*Then it exists*/
  DROP TABLE #temp
 create table #temp(FieldMasterID bigint,fieldvalue nvarchar(max),fieldtext nvarchar(max),islistvalue bigint)

insert into #temp 
select FieldMasterID,FieldValue,fieldtext,IsListValue from
		 (SELECT      

		  (XMLFILELIST.Item.value('@FieldMasterID', 'bigint')) as FieldMasterID ,     

		  (XMLFILELIST.Item.value('@FieldValue', 'nvarchar(max)'))  as FieldValue,

		  (XMLFILELIST.Item.value('@FieldText', 'nvarchar(max)'))  as FieldText,    

		  (XMLFILELIST.Item.value('@IsListValue', 'int'))  as IsListValue 

		  FROM @xml.nodes('/root/row') AS XMLFILELIST(Item)) as D
--select * from #temp;

declare @cols AS NVARCHAR(MAX)		
select @cols = STUFF((SELECT  ',' + QUOTENAME(CT.FieldMasterID) 
                    from dbo.Tbl_ClientTransaction CT 
					inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 
					inner join dbo.AutoIndexingConfiguration AC on FC.FieldMasterId=AC.FieldMasterId			 
				and FC.Active='1' and FC.MailBoxID=@MailBoxId and AC.DetectDuplicate='1'
                    group by CT.FieldMasterID
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @cols

declare @colsJoin as NVARCHAR(MAX)
select @colsJoin=STUFF((SELECT  ' and LTRIM(RTRIM(' + 'IR.'+QUOTENAME(CT.FieldMasterID) +'))='+'LTRIM(RTRIM('+'II.'+QUOTENAME(CT.FieldMasterID)+'))'
                    from dbo.Tbl_ClientTransaction CT 
					inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 
					inner join dbo.AutoIndexingConfiguration AC on FC.FieldMasterId=AC.FieldMasterId					 
				and FC.Active='1' and FC.MailBoxID=@MailBoxId and AC.DetectDuplicate='1'
                    group by CT.FieldMasterID
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,4,'')

		--print @colsJoin

declare @colsCreateTable as NVARCHAR(Max)
select @colsCreateTable=STUFF((SELECT  ',' + QUOTENAME(CT.FieldMasterID) +' NVARCHAR(max)'
                    from dbo.Tbl_ClientTransaction CT 
					inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 	
					inner join dbo.AutoIndexingConfiguration AC on FC.FieldMasterId=AC.FieldMasterId				 
				and FC.Active=1 and FC.MailBoxID= @MailBoxId and AC.DetectDuplicate='1'
                    group by CT.FieldMasterID
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		 --print @colsCreateTable

set @queryDBResultset='Create table IndexResults(CaseId bigint,CreatedDate datetime,'+@colsCreateTable+')'
set @queryInputResultset='Create table IndexInput('+@colsCreateTable+')'
 print @queryDBResultset
 print @queryInputResultset
exec sp_executesql @queryDBResultset
exec sp_executesql @queryInputResultset

 declare @queryDB  AS NVARCHAR(MAX)
set @queryDB = N'insert into IndexResults SELECT CaseID,CreatedDate,' + @cols + N' from 
             (
                
				select CaseID,CT.CreatedDate,FieldValue, FC.FieldMasterID
                from dbo.Tbl_ClientTransaction CT 
				inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 				 
				where FC.MailBoxID='+CONVERT(VARCHAR(50),@MailBoxId)+' and FC.Active=''1''				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldMasterID in (' + @cols + N')
            ) p '
print @queryDB 
exec sp_executesql @queryDB ;



set @queryInput = N'insert into IndexInput SELECT ' + @cols + N' from 
             (
                select FieldValue,FieldMasterID
                from  #temp 				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldMasterID in (' + @cols + N')
            ) p '

PRINT @queryInput
exec sp_executesql @queryInput;

--select * from IndexInput
--set @joinQuery=N'if exists( select * from IndexResults IR join IndexInput II on'+@colsJoin+') select 1 else select 0'

set @joinQuery=N'if exists (( select '+@cols+' from IndexResults where DateDiff(d,CreatedDate,getdate())<365 ) intersect (select '+@cols+' from IndexInput)) select 1 else select 0'  

PRINT @joinQuery
exec sp_executesql @joinQuery


drop table IndexInput
drop table IndexResults
END




GO
/****** Object:  StoredProcedure [dbo].[USP_DRAFT_GetDraft]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_DRAFT_GetDraft]        

(        

@Caseid varchar(25)        

)        

AS            

        

 BEGIN 

 IF  exists (select CASEID from Draftsave where CASEID=@Caseid)   

 BEGIN       

	select Content,ToAddress,CcAddress,RadioButtonClicked,isHighImportance,IsShowQuotedText,SelectedAttachments From Draftsave where CASEID=@Caseid

	  

  END 

  ELSE



  BEGIN

   select 0 as 'Content',0 as 'ToAddress',0 as 'CcAddress',0 as 'RadioButtonClicked',0 as 'isHighImportance',0 as 'IsShowQuotedText',0 as 'SelectedAttachments'
 

  END

 END


GO
/****** Object:  StoredProcedure [dbo].[USP_DraftUpdate]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_DraftUpdate]  
(    
  @AssignedId as varchar(500),  
  @CASEID as bigint,  
  @Content as varchar(MAX),  
  @currentdate as datetime, 
  @ToAddress as varchar(200),
  @CcAddress as varchar(200),
  @RadioButtonSelected as varchar(50),
  @IsHighImportance as bit ,
  @ShowQuotedText as bit,
  @SelectedAttachments as varchar(50)
)  
AS    
BEGIN    
 if EXISTS(SELECT CASEID FROM Draftsave where CASEID=@CASEID)  
 BEGIN  
  UPDATE Draftsave SET CASEID=@CASEID,date=@currentdate,Content=@Content,AssignedId=@AssignedId,ToAddress=@ToAddress,CcAddress=@CcAddress,RadioButtonClicked=@RadioButtonSelected,IsHighImportance=@IsHighImportance,IsShowQuotedText=@ShowQuotedText,SelectedAttachments=@SelectedAttachments where CASEID=@CASEID  
  END  
  ELSE  
  BEGIN  
  INSERT INTO Draftsave  
  (CASEID,date,Content,AssignedId,ToAddress,CcAddress,RadioButtonClicked,IsHighImportance,IsShowQuotedText,SelectedAttachments)values(@CASEID,getutcdate(),@Content,@AssignedId,@ToAddress,@CcAddress,@RadioButtonSelected,@IsHighImportance,@ShowQuotedText,@SelectedAttachments)  
  End  
END



GO
/****** Object:  StoredProcedure [dbo].[USP_EMAILBOXLOGINDETAILS_CONFIGURATION]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================================================================================
-- Author:  Kalaichelvan KB      
-- Create date: 06/05/2014
-- Description: To insert the EmailBox Login Details into the EmailBoxLoginDetail table
-- ====================================================================================
CREATE PROCEDURE [dbo].[USP_EMAILBOXLOGINDETAILS_CONFIGURATION]
(
@EMAILID VARCHAR(200),
@PASSWORD VARCHAR(100),
@ISLOCKED INT,
@ISACTIVE INT
)
AS
BEGIN
 IF not exists (select EMAILID from EmailBoxLoginDetail where EMAILID=@EMAILID)
  BEGIN
   INSERT INTO EmailBoxLoginDetail (EMAILID, PASSWORD, ISLOCKED, ISACTIVE)                
   VALUES (@EMAILID, @PASSWORD, @ISLOCKED, @ISACTIVE)
   SELECT 1
  END
 ELSE
  SELECT 0
END

--select * from EmailBoxLoginDetail







GO
/****** Object:  StoredProcedure [dbo].[USP_EscalationMatrix_ADD]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================================================    
-- Author:  Varma        
-- Create date: 10/30/2015         
-- Description: To configure the Escaltion Matrix
-- ====================================================  

CREATE PROCEDURE [dbo].[USP_EscalationMatrix_ADD]    
(    
@MailBoxId INT, 
@ToMailId varchar(max),
@EscalationMailId varchar(max),
@freq int,
@isActive int,
@Createdby varchar(50)
)    
AS    
BEGIN    
 IF NOT EXISTS (SELECT EmailboxId,@ToMailId FROM [dbo].EscalationMaster WHERE EmailBoxID=@MailBoxId and ToMailID=@ToMailId)       
		 BEGIN
			INSERT INTO [dbo].EscalationMaster values (@MailBoxId,@ToMailId,@EscalationMailId,@isActive,@freq,@Createdby,getutcdate(),@Createdby,getutcdate())
			select 1
		 END 
		 ELSE   
		 BEGIN
			 Select 0 
		 END 
END 







GO
/****** Object:  StoredProcedure [dbo].[USP_EscalationMatrix_DELETE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================    

-- Author:  Varma	          

-- Create date: 30/10/2015	          

-- Description: To DELETE the Escaltion Matrix

-- ====================================================    

create PROCEDURE [dbo].[USP_EscalationMatrix_DELETE]    
(    
@EscalationMasterId int
)    

AS    

BEGIN    

 IF @EscalationMasterId is not null    

  BEGIN
     DELETE FROM EscalationMaster where EscalationMasterID=@EscalationMasterId    
      SELECT 1  
  END   

 ELSE
  SELECT 0    

END 







GO
/****** Object:  StoredProcedure [dbo].[USP_EscalationMatrix_UPDATE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ====================================================    
-- Author:  Varma     
-- Create date: 30/10/2015  
-- Description: To UPDATE the Escaltion Matrix    
-- ==================================================== 

CREATE PROCEDURE [dbo].[USP_EscalationMatrix_UPDATE]  
( 
@EscalationID bigint,   
@MailBoxId INT,
@ToMailId varchar(max),
@EscalationMailId varchar(max), 
@freq int,
@isActive int,
@Createdby Varchar(50)
)    

AS    

BEGIN    

 IF Exists (SELECT ToMailId,EmailboxId FROM [dbo].EscalationMaster WHERE EscalationMasterID=@EscalationID)

  BEGIN

     UPDATE EscalationMaster SET EmailBoxID=@MailBoxId , ToMailID=@ToMailId,EscalationMailID=@EscalationMailId,TimeFrequency=@freq,isActive=@isActive,ModifiedBy=@Createdby,ModifiedDate=getutcdate() WHERE EscalationMasterID=@EscalationID  

     SELECT 1   
   
  END

 ELSE

  SELECT 0   

END    







GO
/****** Object:  StoredProcedure [dbo].[USP_EscaltionMatrix_SELECT]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================          
-- Author:  Ranjith           
-- Create date: 04/27/2015      
-- Description: To select the mapped MAILBOx to Remainder
-- ======================================================  
create PROCEDURE [dbo].[USP_EscaltionMatrix_SELECT]   
@Country int,  
@Mailboxid int
AS   

BEGIN   

SET NOCOUNT ON;  

IF @Country = 0 and @Mailboxid =0
	BEGIN

		SELECT  EM.EscalationMasterID, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress, 
		EM.TimeFrequency,EM.ToMailID,EM.EscalationMailID,	
		case when EM.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById, Convert(Varchar(10),EM.ModifiedDate,101) as ModifiedDate              
		from [dbo].EscalationMaster EM 
		left outer join [EMailBox] EB on EB.EMailBoxId = EM.EmailboxId
		left outer join country Cy on Cy.CountryId=EB.CountryId           
		left outer join Usermaster UM on UM.UserId=EM.ModifiedBy  
		where Cy.IsActive=1  order by Em.EscalationMasterID asc  

	END

ELSE IF @Country <> 0 and @Mailboxid = 0

	BEGIN

		SELECT  EM.EscalationMasterID, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress,
		EM.TimeFrequency,EM.ToMailID,EM.EscalationMailID,	
		case when EM.IsActive=0 then 'No' else 'Yes' end IsActive,  
		UM.FirstName +' '+ UM.LastName as ModifiedById, Convert(Varchar(10),EM.ModifiedDate,101) as ModifiedDate 
		from [dbo].[EscalationMaster] EM
		left outer join [EMailBox] EB on EB.EMailBoxId = EM.EmailboxId
		left outer join country Cy on Cy.CountryId=EB.CountryId    
		left outer join Usermaster UM on UM.UserId=EM.ModifiedBy  
		where Cy.IsActive=1  and cy.CountryId=@Country  order by EM.EscalationMasterID asc  

	END

ELSE IF @Country = 0 and @Mailboxid <> 0

	BEGIN

		SELECT  EM.EscalationMasterID, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress,
		EM.TimeFrequency,EM.ToMailID,EM.EscalationMailID,	
		case when EM.IsActive=0 then 'No' else 'Yes' end IsActive,  
		UM.FirstName +' '+ UM.LastName as ModifiedById, Convert(Varchar(10),EM.ModifiedDate,101) as ModifiedDate 
		from [dbo].[EscalationMaster] EM
		left outer join [EMailBox] EB on EB.EMailBoxId = EM.EmailboxId
		left outer join country Cy on Cy.CountryId=EB.CountryId    
		left outer join Usermaster UM on UM.UserId=EM.ModifiedBy  
		where Cy.IsActive=1  and eb.EMailBoxId=@Mailboxid  order by EM.EscalationMasterID asc  

	END

END 





GO
/****** Object:  StoredProcedure [dbo].[USP_ForgotPassword]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- [dbo].[USP_ForgotPassword] '226961'

CREATE Procedure [dbo].[USP_ForgotPassword]    

(    

 @USERID AS VARCHAR(25)    

)    

AS    

BEGIN    

      

  IF EXISTS(SELECT userid FROM UserMaster WHERE ISActive=1 AND UserId=@USERID and Email is NOT NULL)    

  BEGIN

	select top 1 eb.EMailBoxId, eb.EMailBoxName, eb.EMailBoxAddress, um.Password,um.FirstName,um.LastName,um.Email  from EMailBox eb inner join

	UserMailBoxMapping umbm on eb.EMailBoxId = umbm.MailBoxId inner join

	UserMaster um on umbm.UserId = um.UserID

	where eb.IsActive=1 and um.UserId=@USERID
	 
	
	-- chnaged by ranjith for issue raised on 05/28/2015
	--select EMailId, Password from EmailBoxLoginDetail where IsActive=1
	select top 1 emld.EMailId, emld.Password  from EMailBox eb inner join
	UserMailBoxMapping umbm on eb.EMailBoxId = umbm.MailBoxId inner join
	UserMaster um on umbm.UserId = um.UserID inner join 
	EmailBoxLoginDetail emld  on emld.EmailBoxLoginDetailId=eb.EmailBoxLoginDetailId
	where eb.IsActive=1 and um.UserId=@USERID

  END

      --SELECT Password,FirstName,LastName,Email FROM UserMaster WHERE UserID=@USERID  

END 
-- select * From EmailBoxLoginDetail where Userid = '280298'
-- select * from EMailBox where emailboxid = 98






GO
/****** Object:  StoredProcedure [dbo].[USP_Get_AcknowledgeTemplate_Details]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Pranay Ahuja>
-- Create date: <8/19/2016>
-- Description:	<For getting Acknowledgement Template>
-- =============================================
CREATE PROCEDURE [dbo].[USP_Get_AcknowledgeTemplate_Details]
(
@EMAILBOXID int
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  select * from dbo.EmailboxRemainderConfig where EmailboxId = @EmailBoxID and IsActive=1 and TemplateType=2
  
END




GO
/****** Object:  StoredProcedure [dbo].[USP_GET_AGEING_BASE_DATA]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================  
-- AUTHOR:  KALAICHELVAN KB        
-- CREATE DATE: 07/22/2014        
-- DESCRIPTION: TO BIND THE HOLIDAY DETAILS TO THE GRID
-- =======================================================  
CREATE PROCEDURE [dbo].[USP_GET_AGEING_BASE_DATA] --0,0,4,2  
(    
@RANGEBOUNDARY1 INT,    
@RANGEBOUNDARY2 INT,    
@STATUSID SMALLINT,  
@COUNTRY VARCHAR(20),  
@SUBPROCESS VARCHAR(20),  
@MAILBOXID VARCHAR(20)  
)        
AS        
BEGIN        
 
 --Saranya to display dynamic fields in reports
--start dynamic fields
		if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'ReportResults'
			   )
	begin
			drop table ReportResults
	end 

		declare @cols AS NVARCHAR(MAX)		
select @cols = STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) 
                    from dbo.Tbl_FieldConfiguration FC 					 							 
				where FC.Active='1' and FC.MailBoxID=@MAILBOXID                 
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @cols

		declare @colsCreateTable as NVARCHAR(Max)
		declare @queryDBReportsResult as NVArchar(max)
select @colsCreateTable=STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) +' NVARCHAR(max)'
                    from dbo.Tbl_FieldConfiguration FC 
					left join  dbo.Tbl_ClientTransaction CT  on CT.FieldMasterId=FC.FieldMasterId
								 
				where FC.Active=1 and FC.MailBoxID= @MAILBOXID 
                    group by FC.FieldName
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		set @queryDBReportsResult='Create table ReportResults(CaseId bigint,'+@colsCreateTable+')'
		 print @queryDBReportsResult
		 exec sp_executesql @queryDBReportsResult

		declare @queryDB  AS NVARCHAR(MAX)
set @queryDB = N'insert into ReportResults(CaseId,'+@cols+') SELECT CaseID,' + @cols + N' from 
             (
                
				select CaseID, FieldValue, FC.FieldName
                from dbo.Tbl_ClientTransaction CT 
				inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 				 
				where FC.MailBoxID='+CONVERT(VARCHAR(50),@MAILBOXID)+' and FC.Active=''1''				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldName in (' + @cols + N')
            ) p '
print @queryDB 
 exec sp_executesql @queryDB
 --end of Dynamic fields
 --end of dynamic fields 
  
    
DECLARE @CONVERTSECTODAYS DECIMAL        
SELECT @CONVERTSECTODAYS = 86400.00 -- 24 HOURS MULTIPLIED BY 60 MIN    
IF @STATUSID <> 1    
 BEGIN    
  IF (@RANGEBOUNDARY2 IS NULL   AND @RANGEBOUNDARY1 IS NOT NULL)        
   
        BEGIN       
         PRINT'1'  
           
        EXEC('SELECT       
         EM.CASEID AS CASEID,    
         EM.EMAILRECEIVEDDATE AS EMAILRECEIVEDDATE,    
         EM.EMAILFROM,    
         EM.[SUBJECT],    
         SPG.SUBPROCESSNAME,  
         EB.EMAILBOXNAME,    
         ISNULL(UM.FIRSTNAME + '' ''+ UM.LASTNAME, ''-'') AS ASSIGNEDTO,  
         ST.STATUSDESCRIPTION,'
		 +@cols+
		' FROM EMAILMASTER EM (NOLOCK)  
         LEFT JOIN EMAILAUDIT A (NOLOCK) ON (EM.CASEID = A.CASEID AND EM.STATUSID = A.TOSTATUSID AND   
         A.EMAILAUDITID = (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT AA (NOLOCK) WHERE AA.CASEID = EM.CASEID))      
         LEFT JOIN STATUS ST ON (EM.STATUSID = ST.STATUSID)          
         JOIN EMAILBOX EB ON EB.EMAILBOXID=EM.EMAILBOXID  
         LEFT JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID  
         LEFT JOIN SUBPROCESSGROUPS SPG ON SPG.SUBPROCESSGROUPID=EB.SUBPROCESSGROUPID  
         LEFT JOIN USERMASTER UM (NOLOCK) ON EM.ASSIGNEDTOID = UM.USERID   
           LEFT JOIN ReportResults RR on EM.CaseId=RR.CaseId
         WHERE        
         DBO.FN_TAT_EXCLUDECUTOFFTIME(A.ENDTIME, GETDATE())/'''+@CONVERTSECTODAYS+''' <='''+ @RANGEBOUNDARY1 +'''        
         AND  EM.STATUSID ='''+@STATUSID+'''  AND  C.COUNTRYID='''+@COUNTRY+''' AND  EB.EMAILBOXID='''+@MAILBOXID+''' ORDER BY EMAILRECEIVEDDATE ASC  ')
          
        END        
  ELSE IF (@RANGEBOUNDARY1 IS NULL AND @RANGEBOUNDARY2 IS NOT NULL)        
        BEGIN        
        EXEC('SELECT       
         EM.CASEID AS CASEID,    
         EM.EMAILRECEIVEDDATE AS EMAILRECEIVEDDATE,    
         EM.EMAILFROM,    
         EM.[SUBJECT],    
         SPG.SUBPROCESSNAME,  
         EB.EMAILBOXNAME,    
          ISNULL(UM.FIRSTNAME + '' ''+ UM.LASTNAME, ''-'') AS ASSIGNEDTO,  
         ST.STATUSDESCRIPTION ,'
		 +@cols+
		      
         'FROM EMAILMASTER EM (NOLOCK)  
         LEFT JOIN EMAILAUDIT A (NOLOCK) ON (EM.CASEID = A.CASEID AND EM.STATUSID = A.TOSTATUSID AND   
         A.EMAILAUDITID = (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT AA (NOLOCK) WHERE AA.CASEID = EM.CASEID))      
         LEFT JOIN STATUS ST ON (EM.STATUSID = ST.STATUSID)          
         JOIN EMAILBOX EB ON EB.EMAILBOXID=EM.EMAILBOXID  
         LEFT JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID  
         LEFT JOIN SUBPROCESSGROUPS SPG ON SPG.SUBPROCESSGROUPID=EB.SUBPROCESSGROUPID  
         LEFT JOIN USERMASTER UM (NOLOCK) ON EM.ASSIGNEDTOID = UM.USERID     
             LEFT JOIN ReportResults RR on EM.CaseId=RR.CaseId
         WHERE        
         DBO.FN_TAT_EXCLUDECUTOFFTIME(A.ENDTIME, GETDATE())/'''+@CONVERTSECTODAYS+''' >= '''+@RANGEBOUNDARY2+'''         
        AND  EM.STATUSID ='''+@STATUSID +'''AND  C.COUNTRYID='''+@COUNTRY+''' AND  EB.EMAILBOXID='''+@MAILBOXID+''' ORDER BY EMAILRECEIVEDDATE ASC  ')
        END        
  ELSE        
        BEGIN        
         EXEC('SELECT       
          EM.CASEID AS CASEID,    
         EM.EMAILRECEIVEDDATE AS EMAILRECEIVEDDATE,    
         EM.EMAILFROM,    
         EM.[SUBJECT],    
         SPG.SUBPROCESSNAME,  
         EB.EMAILBOXNAME,    
         ISNULL(UM.FIRSTNAME + '' ''+ UM.LASTNAME, ''-'') AS ASSIGNEDTO,  
         ST.STATUSDESCRIPTION,'
		 +@cols+  
         'FROM EMAILMASTER EM (NOLOCK)  
         LEFT JOIN EMAILAUDIT A (NOLOCK) ON (EM.CASEID = A.CASEID AND EM.STATUSID = A.TOSTATUSID AND   
         A.EMAILAUDITID = (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT AA (NOLOCK) WHERE AA.CASEID = EM.CASEID))      
         LEFT JOIN STATUS ST ON (EM.STATUSID = ST.STATUSID)          
         JOIN EMAILBOX EB ON EB.EMAILBOXID=EM.EMAILBOXID  
         LEFT JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID  
         LEFT JOIN SUBPROCESSGROUPS SPG ON SPG.SUBPROCESSGROUPID=EB.SUBPROCESSGROUPID  
         LEFT JOIN USERMASTER UM (NOLOCK) ON EM.ASSIGNEDTOID = UM.USERID     
          LEFT JOIN ReportResults RR on EM.CaseId=RR.CaseId   
         WHERE        
         DBO.FN_TAT_EXCLUDECUTOFFTIME(A.ENDTIME, GETDATE())/'''+@CONVERTSECTODAYS+''' >'''+ @RANGEBOUNDARY1+'''     
         AND DBO.FN_TAT_EXCLUDECUTOFFTIME(A.ENDTIME, GETDATE())/'''+@CONVERTSECTODAYS +'''<='''+ @RANGEBOUNDARY2   +'''     
          AND  EM.STATUSID ='''+@STATUSID +''' AND  C.COUNTRYID='''+@COUNTRY+''' AND  EB.EMAILBOXID='''+@MAILBOXID+''' ORDER BY EMAILRECEIVEDDATE ASC ') 
        END        
  END    
ELSE    
 BEGIN    
  IF (@RANGEBOUNDARY2 IS NULL  AND @RANGEBOUNDARY1 IS NOT NULL)        
        BEGIN        
         EXEC('SELECT       
          EM.CASEID AS CASEID,    
         EM.EMAILRECEIVEDDATE AS EMAILRECEIVEDDATE,    
         EM.EMAILFROM,    
         EM.[SUBJECT],    
         SPG.SUBPROCESSNAME,  
         EB.EMAILBOXNAME,    
          ISNULL(UM.FIRSTNAME + '' ''+ UM.LASTNAME, ''-'') AS ASSIGNEDTO,  
         ST.STATUSDESCRIPTION,'
		 +@cols+  
         'FROM EMAILMASTER EM (NOLOCK)  
         LEFT JOIN STATUS ST ON (EM.STATUSID = ST.STATUSID)          
         JOIN EMAILBOX EB ON EB.EMAILBOXID=EM.EMAILBOXID  
         LEFT JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID  
         LEFT JOIN SUBPROCESSGROUPS SPG ON SPG.SUBPROCESSGROUPID=EB.SUBPROCESSGROUPID  
         LEFT JOIN USERMASTER UM (NOLOCK) ON EM.ASSIGNEDTOID = UM.USERID     
		  LEFT JOIN ReportResults RR on EM.CaseId=RR.CaseId
         WHERE        
         DBO.FN_TAT_EXCLUDECUTOFFTIME(EM.CREATEDDATE, GETDATE())/'''+@CONVERTSECTODAYS +'''<= '''+@RANGEBOUNDARY1 +'''       
          AND  EM.STATUSID ='''+@STATUSID+'''  AND  C.COUNTRYID='''+@COUNTRY +'''AND  EB.EMAILBOXID='''+@MAILBOXID+''' ORDER BY EMAILRECEIVEDDATE ASC')
          
        END        
  ELSE IF (@RANGEBOUNDARY1 IS NULL AND @RANGEBOUNDARY2 IS NOT NULL)        
        BEGIN        
         EXEC('SELECT       
         EM.CASEID AS CASEID,    
         EM.EMAILRECEIVEDDATE AS EMAILRECEIVEDDATE,    
         EM.EMAILFROM,    
         EM.[SUBJECT],    
         SPG.SUBPROCESSNAME,  
         EB.EMAILBOXNAME,    
          ISNULL(UM.FIRSTNAME + '' ''+ UM.LASTNAME, ''-'') AS ASSIGNEDTO,  
         ST.STATUSDESCRIPTION ,'
		 +@cols+ 
         'FROM EMAILMASTER EM (NOLOCK)  
         LEFT JOIN STATUS ST ON (EM.STATUSID = ST.STATUSID)          
         JOIN EMAILBOX EB ON EB.EMAILBOXID=EM.EMAILBOXID  
         LEFT JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID  
         LEFT JOIN SUBPROCESSGROUPS SPG ON SPG.SUBPROCESSGROUPID=EB.SUBPROCESSGROUPID  
         LEFT JOIN USERMASTER UM (NOLOCK) ON EM.ASSIGNEDTOID = UM.USERID     
		  LEFT JOIN ReportResults RR on EM.CaseId=RR.CaseId
         WHERE        
         DBO.FN_TAT_EXCLUDECUTOFFTIME(EM.CREATEDDATE, GETDATE())/'''+@CONVERTSECTODAYS+''' >= '''+@RANGEBOUNDARY2 +'''        
          AND  EM.STATUSID ='''+@STATUSID+'''  AND  C.COUNTRYID='''+@COUNTRY+''' AND  EB.EMAILBOXID='''+@MAILBOXID+''' ORDER BY EMAILRECEIVEDDATE ASC') 
        END        
  ELSE        
   BEGIN        
       EXEC(' SELECT       
          EM.CASEID AS CASEID,    
         EM.EMAILRECEIVEDDATE AS EMAILRECEIVEDDATE,    
         EM.EMAILFROM,    
         EM.[SUBJECT],    
         SPG.SUBPROCESSNAME,  
         EB.EMAILBOXNAME,    
         ISNULL(UM.FIRSTNAME + '' ''+ UM.LASTNAME, ''-'') AS ASSIGNEDTO,  
         ST.STATUSDESCRIPTION,'  
		 +@cols+
         'FROM EMAILMASTER EM (NOLOCK)  
         LEFT JOIN STATUS ST ON (EM.STATUSID = ST.STATUSID)          
         JOIN EMAILBOX EB ON EB.EMAILBOXID=EM.EMAILBOXID  
         LEFT JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID  
         LEFT JOIN SUBPROCESSGROUPS SPG ON SPG.SUBPROCESSGROUPID=EB.SUBPROCESSGROUPID  
         LEFT JOIN USERMASTER UM (NOLOCK) ON EM.ASSIGNEDTOID = UM.USERID     
            LEFT JOIN ReportResults RR on EM.CaseId=RR.CaseId
         WHERE        
         DBO.FN_TAT_EXCLUDECUTOFFTIME(EM.CREATEDDATE, GETDATE())/'''+@CONVERTSECTODAYS +'''>'''+ @RANGEBOUNDARY1     +'''
         AND DBO.FN_TAT_EXCLUDECUTOFFTIME(EM.CREATEDDATE, GETDATE())/'''+@CONVERTSECTODAYS+''' <='''+ @RANGEBOUNDARY2 +'''       
          AND  EM.STATUSID ='''+@STATUSID+'''  AND  C.COUNTRYID='''+@COUNTRY +'''AND  EB.EMAILBOXID='''+@MAILBOXID+''' ORDER BY EMAILRECEIVEDDATE ASC')  
        END    
  END    
END       
    







GO
/****** Object:  StoredProcedure [dbo].[USP_Get_CaseDetails_NLP]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[USP_Get_CaseDetails_NLP] 
CREATE PROCEDURE [dbo].[USP_Get_CaseDetails_NLP]               
AS  
 BEGIN    
	--select EM.CaseId,EA.Content from EmailMaster EM
	--left join EMailAttachment EA on EM.CaseId=EA.CaseId    
	--where EM.ClassificationID Is Null and EA.FileName='BODY.html'
	--order by EM.CaseId
	if exists(select * from InboundClassification where IsActive=1)
	begin
	select EM.CaseId,EM.Bodycontent from EmailMaster EM	
	where EM.ClassificationID Is Null and (StatusId=1 and IsManual=0) 
	order by EM.CaseId	
	end

 END
GO
/****** Object:  StoredProcedure [dbo].[USP_GET_COUNTRY_DETAILS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GET_COUNTRY_DETAILS]        

--(        

--@COUNTRYID varchar(25)        

--)        

AS            

        

 BEGIN        

  SELECT C.CountryID, C.Country, case when C.IsActive=0 then 'No' else 'Yes' end IsActive, UM.FirstName +' '+ Um.LastName as CreatedById,  

   CONVERT(VARCHAR(10), C.CreatedDate, 103)as    CreatedDate, UM1.FirstName +' '+ Um1.LastName as ModifiedById, CONVERT(VARCHAR(10), C.ModifiedDate, 103)as ModifiedDate   

  FROM [dbo].[COUNTRY] C  

  inner join UserMaster UM on UM.UserID = C.CreatedById 

  inner join UserMaster UM1 on UM1.UserID = C.ModifiedById 

  where countryId!=0 order by Country  asc      

 END





GO
/****** Object:  StoredProcedure [dbo].[USP_GET_COUNTRY_NAMES]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================  
-- Author:  Kalaichelvan KB        
-- Create date: 06/02/2014        
-- Description: To get Country Names  
-- =======================================================  
CREATE PROCEDURE [dbo].[USP_GET_COUNTRY_NAMES]  
AS  
BEGIN  
SELECT CountryId, Country from country where IsActive =1 
END






GO
/****** Object:  StoredProcedure [dbo].[USP_GET_COUNTRY_SUBPROCESS_NAMES]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================  
-- Author:  Kalaichelvan KB        
-- Create date: 06/02/2014        
-- Description: To get Country Names  
-- =======================================================  
CREATE PROCEDURE [dbo].[USP_GET_COUNTRY_SUBPROCESS_NAMES]  
AS  
BEGIN  
	SELECT CountryId, Country from country -- where IsActive =1 
END






GO
/****** Object:  StoredProcedure [dbo].[USP_GET_Draft_Att]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[USP_GET_SIGNATURE] '226961'
Create PROCEDURE [dbo].[USP_GET_Draft_Att]        
(        
@Caseid varchar(25)        
)        
AS            
        
 BEGIN 
 IF  exists (select CaseId from Draftsave_att where CaseId=@Caseid)   
 BEGIN       
	select Content From Draftsave_att
	  where CaseId=@Caseid 
  END 
  ELSE

  BEGIN
  select 0 as 'Content'
  END
 END


GO
/****** Object:  StoredProcedure [dbo].[USP_GET_EMAILBOXLOGINDETAILS_DETAILS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_GET_EMAILBOXLOGINDETAILS_DETAILS
----------------------
--created by Kathir
--Created on 19thJune2014
--Purpose  to bind the EMAILBOXLOGINDETAILS to the grid
---------------------
CREATE PROCEDURE [dbo].[USP_GET_EMAILBOXLOGINDETAILS_DETAILS]        
AS            
 BEGIN        
  SELECT EmailBoxLoginDetailID, EMAILID, PASSWORD, case when ISLOCKED=0 then 'No' else 'Yes' end ISLOCKED, case when ISACTIVE=0 then 'No' else 'Yes' end  ISACTIVE FROM [dbo].[EmailBoxLoginDetail] order by EMAILID  asc      
 END   






GO
/****** Object:  StoredProcedure [dbo].[USP_GET_EMAILBOXNAME]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================    
-- Author:  Kalaichelvan KB                        
-- Create date: 07/15/2014                        
-- Description: To get the emailbox name for binding into the dropdown    
-- ======================================================================    
CREATE PROCEDURE [dbo].[USP_GET_EMAILBOXNAME]    
(    
@COUNTRYID INT,    
@SUBPROCESSGROUPID INT    
)    
AS    
BEGIN    
 SELECT EMAILBOXID, EMAILBOXNAME FROM EMAILBOX WHERE COUNTRYID=@COUNTRYID AND SUBPROCESSGROUPID=@SUBPROCESSGROUPID  and IsActive=1  
END  






GO
/****** Object:  StoredProcedure [dbo].[USP_GET_FIELDTYPE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================  

-- Author:  Ranjith     

-- Create date: 07/15/2015     

-- Description: To get Field type

-- =======================================================  

CREATE PROCEDURE [dbo].[USP_GET_FIELDTYPE]  

AS  

BEGIN  

SELECT FieldTypeId, FieldType from [dbo].[Tbl_Master_FieldType] where Active =1 

END







GO
/****** Object:  StoredProcedure [dbo].[USP_GET_HOLIDAY_DETAILS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================  
-- Author:  Kalaichelvan KB        
-- Create date: 07/12/2014        
-- Description: To Bind the Holiday details to the Grid
-- =======================================================  
CREATE PROCEDURE [dbo].[USP_GET_HOLIDAY_DETAILS]
AS  
BEGIN  
 SELECT H.HOLIDAYID, H.HOLIDAYDESCRIPTION as [Holiday Description], CONVERT(VARCHAR(10), H.HolidayDate, 101) as HolidayDate, 
 case when H.IsActive=0 then 'No' else 'Yes' end IsActive, UM.FirstName +' '+ Um.LastName as CreatedById,    
 CONVERT(VARCHAR(10), H.CreatedDate, 101) as CreatedDate, TotalMinutes
 FROM [dbo].[HOLIDAY] H    
  inner join UserMaster UM on UM.UserID = H.CreatedById   
  inner join UserMaster UM1 on UM1.UserID = H.CreatedById
 order by H.HolidayDate  asc  
 END






GO
/****** Object:  StoredProcedure [dbo].[USP_GET_MailBox_Details]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

       
--sp_helptext USP_GET_MailBox_Details          
CREATE PROCEDURE [dbo].[USP_GET_MailBox_Details]                      
AS                      
BEGIN                      
SELECT EB.EMAILBOXID, EB.EMAILBOXNAME, convert(varchar(100), EB.EMAILBOXADDRESS) as EMAILBOXADDRESS,EB.EMailBoxAddressOptional, EB.EMAILFOLDERPATH, EB.DOMAIN, EB.USERID,EB.TimeZone, Cy.COUNTRY as CountryName,           
SPG.SubProcessName as SubProcessName, convert(int,EB.TATInHours) as TATInHours,           
case when EB.ISACTIVE=0 then 'No' else 'Yes' end ISACTIVE, case when EB.ISQCREQUIRED=0 then 'No' else 'Yes' end ISQCREQUIRED,             
case when EB.ISMAILTRIGGERREQUIRED=0 then 'No' else 'Yes' end ISMAILTRIGGERREQUIRED,           
case when EB.ISREPLYNOTREQUIRED=0 then 'No' else 'Yes' end ISREPLYNOTREQUIRED,  
case when EB.IsApprovalRequired=0 or EB.IsApprovalRequired is null then 'No' else 'Yes' end IsApprovalRequired,       
case when EB.ISLOCKED=0 then 'No' else 'Yes' end IsLocked,   
case when EB.IsVOCSurvey=0 then 'No' else 'Yes' end IsVOCSurveyRequired,
case when EB.IsSkillBasedAllocation=0 or EB.IsSkillBasedAllocation is null  then 'No' else 'Yes' end IsSkillBasedAllocation ,         
       
ELogdet.EmailID              
from EMAILBOX EB                 
left outer join EMAILBOXLOGINDETAIL ELogdet on ELogdet.EMAILBOXLOGINDETAILID = EB.EMAILBOXLOGINDETAILID                 
left outer join country Cy on Cy.CountryId=EB.CountryId           
left outer join SubProcessGroups SPG on SPG.SUBPROCESSGROUPID=EB.SUBPROCESSGROUPID          
where ELogdet.IsActive =1 AND Cy.IsActive=1 order by EB.EMAILBOXADDRESS asc  
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Get_MailBoxDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Get_MailBoxDetails]      
AS      
BEGIN      
      
SET NOCOUNT ON;      
      
SELECT     
 EB.EMAILBOXID    
 ,EB.EMAILBOXNAME    
 ,EB.EMAILFOLDERPATH    
 ,EB.COUNTRYID    
 ,EB.EMAILBOXADDRESS
 ,EB.TimeZone  
 ,EBLD.EMAILID AS LOGINEMAILID    
 ,EBLD.PASSWORD, EB.isActive    
FROM EMAILBOX EB WITH (NOLOCK)
LEFT JOIN EMAILBOXLOGINDETAIL EBLD WITH (NOLOCK) ON EB.EMAILBOXLOGINDETAILID = EBLD.EMAILBOXLOGINDETAILID    
WHERE  EB.ISACTIVE=1 AND EB.ISLOCKED=0 AND EBLD.ISACTIVE=1 AND EBLD.ISLOCKED=0 AND IsReplyNotRequired=0   
       
END 








GO
/****** Object:  StoredProcedure [dbo].[USP_Get_MailBoxDetails_by_CountryNames]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [USP_Get_MailBoxDetails_by_CountryNames] 'Sweden~~Norway'

CREATE PROCEDURE [dbo].[USP_Get_MailBoxDetails_by_CountryNames]
(
	@CountryNames varchar(max)
)
AS      

BEGIN      
SET NOCOUNT ON;   

SELECT     
 EB.EMAILBOXID    
 ,EB.EMAILBOXNAME    
 ,EB.EMAILFOLDERPATH    
 ,EB.COUNTRYID    
 ,EB.EMAILBOXADDRESS    
 ,EBLD.EMAILID AS LOGINEMAILID    
 ,EBLD.PASSWORD, EB.isActive    

FROM EMAILBOX EB    
LEFT JOIN EMAILBOXLOGINDETAIL EBLD ON EB.EMAILBOXLOGINDETAILID = EBLD.EMAILBOXLOGINDETAILID 
LEFT JOIN Country C on EB.CountryId=C.CountryId

WHERE  EB.ISACTIVE=1 AND EB.ISLOCKED=0 AND EBLD.ISACTIVE=1 AND EBLD.ISLOCKED=0 AND IsReplyNotRequired=0   
and Country in (select * from dbo.[Split] (@CountryNames, '~~'))

END 


GO
/****** Object:  StoredProcedure [dbo].[USP_Get_MailBoxes]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Get_MailBoxes]          
AS          
BEGIN          
          
SET NOCOUNT ON;          
          
SELECT         
Id, EMailbox, LoginEmailId, password, Path from EMailboxTest where IsActive=1  and LoginEmailId like '%@be.world.com%' 
and id in( 1010, 1011, 1012, 1013)
--and id in(1013)


           
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_Get_MaxCaseId_EmailMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Get_MaxCaseId_EmailMaster]  
   
AS  
BEGIN  
SET NOCOUNT ON;  
  select max(caseid) as workid from EMAILMASTER 
END







GO
/****** Object:  StoredProcedure [dbo].[USP_GET_RoleID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE PROCEDURE [dbo].[USP_GET_RoleID]    
(    
@RoleName nvarchar(25)
)    
AS    
BEGIN    
 SELECT UserRoleId,RoleDescription from UserRole where RoleDescription=@RoleName
END  

GO
/****** Object:  StoredProcedure [dbo].[USP_GET_SIGNATURE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[USP_GET_SIGNATURE] '226961'
CREATE PROCEDURE [dbo].[USP_GET_SIGNATURE]        
(        
@Userid varchar(25)        
)        
AS            
        
 BEGIN 
 IF  exists (select Signature from Signature where Userid=@Userid)   
 BEGIN       
	select SignID,Signature,LastModifiedOn From [dbo].[Signature] WITH (NOLOCK)
	  where Userid= @Userid  
  END 
  ELSE

  BEGIN
  select 0 as 'SignID'
  END
 END






GO
/****** Object:  StoredProcedure [dbo].[USP_GET_SUBPROCESSGROUPS_DETAILS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_GET_SUBPROCESSGROUPS_DETAILS  
--sp_helptext USP_GET_COUNTRY_DETAILS    
-- ==============================================================        
-- Author:  Kalaichelvan KB              
-- Create date: 06/23/2014              
-- Description: To Bind the SubProcess details into the grid        
-- ==============================================================       
CREATE PROCEDURE [dbo].[USP_GET_SUBPROCESSGROUPS_DETAILS]        
AS          
 BEGIN          
  SELECT c.countryid as CountryId ,c.Country as CountryName, SPG.SubProcessGroupID, SPG.SubProcessName, SPG.ProcessOwnerId, case when SPG.IsActive=0 then 'No' else 'Yes' end IsActive, UM.FirstName +' '+ Um.LastName as CreatedById,    
  CONVERT(VARCHAR(10), SPG.CreatedDate, 103) as CreatedDate     
  FROM [dbo].[SUBPROCESSGROUPS] SPG    
  inner join UserMaster UM on UM.UserID = SPG.CreatedById
  join country c on c.countryid = spg.countryidmapping -- where c.IsActive=1 and SPG.ISActive=1
   order by SubProcessName  asc        
 END     
--dbo.EMailBox





GO
/****** Object:  StoredProcedure [dbo].[USP_GET_SUBPROCESSGROUPS_DETAILS_Active]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[USP_GET_SUBPROCESSGROUPS_DETAILS_Active]         
@CountryId int
--,  @MailBox int
--@LoggedinUserRoleId int      
AS                
 BEGIN                
    
    
  --SELECT SPG.SubProcessGroupID, SPG.SubProcessName, SPG.ProcessOwnerId, case when SPG.IsActive=0 then 'No' else 'Yes' end IsActive, UM.FirstName +' '+ Um.LastName as CreatedById,          
  --CONVERT(VARCHAR(10), SPG.CreatedDate, 101) as CreatedDate           
  --FROM [dbo].[SUBPROCESSGROUPS] SPG          
  --inner join UserMaster UM on UM.UserID = SPG.CreatedById  and SPG.IsActive!=0 order by SubProcessName  asc     
   
 SELECT SubProcessGroupID, SubProcessName from SUBPROCESSGROUPS where IsActive=1 and CountryIdMapping=@CountryId  order by SubProcessName asc 
 END           
 
 







GO
/****** Object:  StoredProcedure [dbo].[USP_GET_USER_DETAILS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_GET_USER_DETAILS]        
        
AS            
BEGIN            
       
 BEGIN        
  SELECT UM.UserId, UM.FirstName, UM.LastName, UM.EMAIL,case when UM.IsActive=0 then 'No' else 'Yes' end IsActive, UM1.FirstName +' '+ Um1.LastName as ModifiedBy,UM.TimeZone,UM.Offset,     
   UM.ModifiedDate as ModifiedDate,UM.SkillId as SkillId,UM.SkillDescription as SkillDescription FROM [dbo].[UserMaster] as UM 
left outer join UserMaster UM1 on UM1.UserId=UM.ModifiedById
   order by UserId asc        
 END         
END 

--select * from usermaster








GO
/****** Object:  StoredProcedure [dbo].[USP_GetACL]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Karthikeyan A>
-- Create date: <20-July-2017>
-- Description:	<Get status transitions based on subprocess and role >
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetACL]
	-- Add the parameters for the stored procedure here
	@SubProcessID as INT,
	@RoleID as INT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	if (@SubProcessID is NULL OR @SubProcessID = '')
		Begin
		
			Select * from AccessControlMaster ACM inner join PageMaster PM on ACM.PageId=PM.PageId
				  where ACM.RoleID=@RoleID and PM.IsActive=1
		END
	else
		Begin

			Select * from AccessControlMaster ACM inner join PageMaster PM on ACM.PageId=PM.PageId
			  where ACM.SubProcessID=@SubProcessID and ACM.RoleID=@RoleID and PM.IsActive=1
		End
END


--exec [USP_GetACL] Null, 1


GO
/****** Object:  StoredProcedure [dbo].[USP_GetACL_Menu]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Karthikeyan A>
-- Create date: <20-July-2017>
-- Description:	<Get status transitions based on subprocess and role >
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetACL_Menu]
	-- Add the parameters for the stored procedure here
	--@SubProcessID as INT,
	@RoleID as INT,
	@UserID as INT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--declare @RoleID as int;

	If(@RoleID=null or @RoleID='')
	Begin
		set @RoleID = (select  Top 1 RoleId from UserRoleMapping where UserId=@UserID order by RoleId desc) 
		--set @RoleID=1;
	End

	Select ACM.PageID,PM.PageName,ACM.AccessMode,ACM.RoleID,PM.URL,PM.Module,PM.ChildMenuGroupID from AccessControlMaster ACM inner join PageMaster PM on ACM.PageId=PM.PageId
		where ACM.RoleID=@RoleID and ACM.RoleID in (Select RoleId from UserRoleMapping where UserId=@UserID) and PM.Module <> '' and AccessMode <>'H' and PM.IsActive=1 order by PM.MenuOrder

			--select * from PageMaster
	
END


--exec [USP_GetACL_Menu]  1,'195174'




GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllChildCaseDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_GetAllChildCaseDetails](@ParentCaseId bigint)

AS
BEGIN

SELECT	EM.CaseId,EM.StatusId,EB.EMailBoxName,EB.EMailBoxId from dbo.EmailMaster EM inner join EMailBox EB on EM.EMailBoxId=EB.EMailBoxId
where ParentCaseId=@ParentCaseId  and StatusId!=10;
		
end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllEmailBoxDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : RAGUVARAN E
* CREATED DATE : 05/26/2014
* PURPOSE : TO GET THE EMAILBOX DETAILS FOR SENDING EMAIL
*/

CREATE PROCEDURE [dbo].[USP_GetAllEmailBoxDetails]

AS
BEGIN

SELECT	EB.EMAILBOXADDRESS
		,EBLD.EMAILID AS LOGINEMAILID
		,EBLD.PASSWORD
		,EB.EMAILFOLDERPATH
		,EB.ISREPLYNOTREQUIRED
		,CASE WHEN EB.ISLOCKED=1 THEN EB.ISLOCKED ELSE EBLD.ISLOCKED END AS ISLOCKED
FROM 
EMAILBOX EB LEFT JOIN EMAILBOXLOGINDETAIL EBLD ON EB.EMAILBOXLOGINDETAILID=EBLD.EMAILBOXLOGINDETAILID
WHERE EBLD.ISACTIVE=1 AND EB.ISACTIVE=1 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAllStatus]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec USP_GetAllStatus 5
CREATE PROCEDURE [dbo].[USP_GetAllStatus]   
(
@MailBoxId bigint
) 
AS    
BEGIN 
Declare @SubProcessId int
Set @SubProcessId=(Select SubProcessGroupId from dbo.EMailBox where EMailBoxId=@MailBoxId)
if exists(select * from dbo.Status where SubProcessID=@SubProcessId and IsActive='1')
	Begin
	select * from dbo.Status where SubProcessID=@SubProcessId and IsActive='1'
	end
	else
	begin
	select * from dbo.Status where SubProcessID is null and IsActive='1'
	end
END






GO
/****** Object:  StoredProcedure [dbo].[USP_GetApprovalWorkQueue]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_GetApprovalWorkQueue]          
 (              
 @APPROVERUSERID AS VARCHAR(20)    
 )              
AS              
BEGIN 
            
    
----------------------------------------------- QC USERID IS NOT  NULL ----------------------------------------------------------------               
SELECT EM.CASEID, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,   
EM.Subject, CASE WHEN em.IsUrgent=1 THEN 'High' ELSE 'Low' END IsUrgent,  UM.USERID, UM.FIRSTNAME + ' ' + UM.LASTNAME + ' (' + UM.USERID + ')'  AS USERNAME,   
SM.StatusDescription AS STATUSDESCRIPTION, SM.STATUSID, EMailboxId    
    
FROM EMAILMASTER EM    
JOIN USERMASTER UM ON UM.USERID= EM.AssignedToId    
JOIN STATUS SM ON EM.STATUSID = SM.STATUSID    
WHERE EM.ApproverUserId =@APPROVERUSERID AND SM.STATUSID in (select StatusId from dbo.Status where IsApprovalStatus='1') 
   
    
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_GetApproverList]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SaranyaDevi C
-- Create date: 26-Jul-2017
-- Description:	Return Status Transitions based on SubProcessId and UserRoleId
-- =============================================

--exec USP_GetApproverList
CREATE PROCEDURE [dbo].[USP_GetApproverList]
	
AS
BEGIN
	
	SET NOCOUNT ON;

	
	
	SELECT DISTINCT UM.USERID as ApproverId, UM.FIRSTNAME +' '+  UM.LASTNAME + ' ( ' + UM.USERID + ' ) ' AS ApproverName 
		FROM USERMASTER UM 
		left join UserRoleMapping URM on UM.UserId=URM.UserId
		where URM.RoleId='3'
	
    
    
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetApproverWorkQueue]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_GetApproverWorkQueue]          
 (              
 @APPROVERUSERID AS VARCHAR(20)    
 )              
AS              
BEGIN 
            
    
----------------------------------------------- QC USERID IS NOT  NULL ----------------------------------------------------------------               
SELECT EM.CASEID, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,   
EM.Subject, CASE WHEN em.IsUrgent=1 THEN 'High' ELSE 'Low' END IsUrgent,  UM.USERID, UM.FIRSTNAME + ' ' + UM.LASTNAME + ' (' + UM.USERID + ')'  AS USERNAME,   
SM.StatusDescription AS STATUSDESCRIPTION, SM.STATUSID, EMailboxId    
    
FROM EMAILMASTER EM    
JOIN USERMASTER UM ON UM.USERID= EM.AssignedToId    
JOIN STATUS SM ON EM.STATUSID = SM.STATUSID    
WHERE EM.ApproverUserId =@APPROVERUSERID AND SM.STATUSID in (select StatusId from dbo.Status where IsApprovalStatus='1') 
   
    
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_GetAttachemnts_ForACase]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ====================================================    



-- Author:  Varma	          



-- Create date: 03/11/2015	          



-- Description: To Get all attachments for a Case except Html content



-- ====================================================    



CREATE PROCEDURE [dbo].[USP_GetAttachemnts_ForACase]    

(    

@CaseId bigint

)    



AS    



BEGIN    



 IF @CaseId is not null    



	BEGIN

		select Filename,ContentType,Content,AttachmentTypeID from EMailAttachment where caseid=@CaseId  and FileName not in ('Body.html','Followup.html') and IsDeleted=0

	END   



END 











GO
/****** Object:  StoredProcedure [dbo].[USP_GetAttachmentDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : RAGUVARAN E
* CREATED DATE : 05/26/2014
* PURPOSE : TO GET THE ATTACHMENT DETAILS TO DISPLAY IN PROCESSING PAGE
*/

CREATE PROCEDURE [dbo].[USP_GetAttachmentDetails]
(
	@CASEID AS BIGINT,
	@ATTACHMENTID AS BIGINT
)
AS
BEGIN

SELECT 
	EA.ATTACHMENTID
	,EA.FILENAME
	,AT.ATTACHMENTTYPE 
	,EA.CREATEDDATE
	,EA.CONTENT
FROM 
EMAILATTACHMENT EA
LEFT JOIN ATTACHMENTTYPE AT ON EA.ATTACHMENTTYPEID=AT.ATTACHMENTTYPEID
WHERE EA.CASEID=@CASEID AND ATTACHMENTID=@ATTACHMENTID

END






GO
/****** Object:  StoredProcedure [dbo].[USP_GetAttachmentList]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : RAGUVARAN E
* CREATED DATE : 05/26/2014
* PURPOSE : TO GET THE LIST OF ATTACHMENTS TO DISPLAY IN PROCESSING PAGE
*/

CREATE PROCEDURE [dbo].[USP_GetAttachmentList]
(
	@CONVERSATIONID AS BIGINT
)
AS
BEGIN

SELECT 
	EA.ATTACHMENTID
	,EA.FileName
	,EA.CONTENT
	,AT.ATTACHMENTTYPE 
	,EA.CREATEDDATE
FROM 
EMAILATTACHMENT EA
LEFT JOIN ATTACHMENTTYPE AT ON EA.ATTACHMENTTYPEID=AT.ATTACHMENTTYPEID
WHERE EA.ConversationID=@CONVERSATIONID and EA.AttachmentTypeID <>3 and EA.AttachmentTypeID<>4

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAutoIndexingConfiguration]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SaranyaDevi C
-- Create date: 21-Aug-2017
-- Description:	Return AutoIndexing configuration
-- =============================================

--exec USP_GetAutoIndexingConfiguration
CREATE PROCEDURE [dbo].[USP_GetAutoIndexingConfiguration]
	(
	@MAILBOXID bigint
	)
AS
BEGIN
	
	SET NOCOUNT ON;
	Select IndexedField,StartText,EndText,FieldMasterId,RetrieveFrom,ContainsText,IndexedText  from dbo.AutoIndexingConfiguration where IsActive='1' AND MailboxId=@MailBoxId;
    
END


GO
/****** Object:  StoredProcedure [dbo].[USP_GetAutoReplyMails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetAutoReplyMails]   
(
  @CASEID AS BIGINT
)
AS  
BEGIN
SELECT AutoReplyText,AutoReplyReceivedTime from EMAILMASTER where CASEID=@CASEID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCaseAuditLog]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================              
-- Author:  <SAKTHI>              
-- Create date: <28/05/2014>              
-- Description: <TO GET CASE AUDIT LOG >              
-- =============================================   
CREATE PROC [dbo].[USP_GetCaseAuditLog]
(
  @CASEID BIGINT
)
AS
BEGIN

 SELECT CSF.StatusDescription 'FromStatus', CST.StatusDescription 'ToStatus',                 
 UM.FirstName + ' ' + UM.LastName 'UserName',
 (CASE WHEN CSF.StatusDescription='Open' THEN '-'
              Else 

 CONVERT(VARCHAR(10), A.StartTime, 103)+ ' ' +CONVERT(VARCHAR(10), A.StartTime, 108)
 End) As StartTime,
 CONVERT(VARCHAR(10),A.EndTime, 103) + ' ' +CONVERT(VARCHAR(10),A.EndTime, 108) As EndTime  --,A.EmailAuditId                 
 FROM EMAILAUDIT A WITH (NOLOCK)                
 JOIN EMAILMASTER T  WITH (NOLOCK)  ON T.CaseID=A.CaseID                
 JOIN STATUS CSF  WITH (NOLOCK)  ON CSF.Statusid=A.FromStatusId
 JOIN STATUS CST  WITH (NOLOCK)  ON CST.Statusid=A.ToStatusId                
 JOIN USERMASTER UM  WITH (NOLOCK) ON UM.UserId=A.UserID    
 WHERE T.CaseID = @CASEID
 
END












GO
/****** Object:  StoredProcedure [dbo].[USP_GetCaseCreationConfiguration]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SaranyaDevi C
-- Create date: 18-Aug-2017
-- Description:	Return Case Creation configuration
-- =============================================

--exec USP_GetCaseCreationConfiguration
CREATE PROCEDURE [dbo].[USP_GetCaseCreationConfiguration]
(
@MailBoxId bigint
)	
AS
BEGIN
	
	SET NOCOUNT ON;
	Select KeywordInSubject,[Include] from dbo.casecreationconfiguration where IsActive='1' and MailBoxId=@MailBoxId;
    
END


GO
/****** Object:  StoredProcedure [dbo].[USP_GetCaseCurrentStatus]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
EXEC USP_GetCaseCurrentStatus 102  
  
*/  
CREATE PROCEDURE [dbo].[USP_GetCaseCurrentStatus]  
(  
 @CaseID VARCHAR(50)  
)  
AS      
BEGIN      
   
SELECT StatusID AS CurrentStatus FROM EmailMaster WHERE CaseID = @CaseID  
    
END  
  






GO
/****** Object:  StoredProcedure [dbo].[USP_GetCaseDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : 
* CREATED DATE : 
* PURPOSE : TO GET THE CASE DETAILS TO DISPLAY IN PROCESSING PAGE in EMT COMPONENT
*/
CREATE PROCEDURE [dbo].[USP_GetCaseDetails]
(
	@CASEID AS BIGINT
)
AS
BEGIN


	SELECT EM.CASEID
			 
			, EM.EMAILRECEIVEDDATE As EMAILRECEIVEDDATE
			,CASE WHEN EM.ISMANUAL=1 THEN EM.EMAILTO ELSE EM.EMAILFROM END AS EMAILFROM
			,EM.EmailCc
			,IC.ClassifiactionDescription
			,IC.IsActive
			,EM.SUBJECT
			,EB.EMAILBOXNAME
			,EB.EMAILBOXADDRESS
            ,Em.IsUrgent      
            ,EM.EMailBody
			,CO.COUNTRY
			,CO.CountryId
			,ST.STATUSID
			,ST.STATUSDESCRIPTION
			,EM.ASSIGNEDTOID
			,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO
			,EM.QCUSERID
			,UMQC.FIRSTNAME+', '+UMQC.LASTNAME AS QCASSIGNEDTO
			,EM.ISMANUAL
			,EM.ATTACHMENTLOCATION
			,CASE WHEN EM.ISMANUAL = 1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS EMAILTYPE
			,EB.ISQCREQUIRED
			,EB.ISMAILTRIGGERREQUIRED
			,EB.EMAILBOXID
			,EM.ISMANUAL, CategoryId
			,EM.ForwardedToGMB
			,EM.ParentCaseId
			,SPG.SubProcessGroupId
			,SPG.SubprocessName
		FROM 
		EMAILMASTER EM
		LEFT JOIN InboundClassification IC ON EM.ClassificationID=IC.ClassificationID
		LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
		LEFT JOIN SUBPROCESSGROUPS SPG ON EB.SubProcessGroupId=SPG.SubProcessGroupId
		LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID
		LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID
		LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID
		LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID
		LEFT JOIN EMAILBOXCATEGORYCONFIG EBCC ON EM.CATEGORYID=EBCC.EMAILBOXCATEGORYID
		WHERE CASEID=@CASEID

	


END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCaseDetailsForLoadingNextCase]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetCaseDetailsForLoadingNextCase]

(

	@CASEID AS BIGINT,

	@EMAILBOXID AS INT,

	@USERID VARCHAR(50),

	@STATUSID INT,

	@ROLEID INT,

	@CASEFLAG INT

)

AS

BEGIN
	
	DECLARE @NEXTCASEID bigint

	IF @CASEFLAG=1

			BEGIN

	IF @STATUSID = 1

		BEGIN			

			SELECT TOP 1

				@NEXTCASEID=EM.CASEID

			FROM 

			EMAILMASTER EM

			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.CASEID>@CASEID

			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC

		END

		ELSE IF @STATUSID IN (5,6)

		BEGIN

			SELECT TOP 1

				@NEXTCASEID=EM.CASEID

			FROM 

			EMAILMASTER EM

			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID IN (5,6) AND EM.EMAILBOXID=@EMAILBOXID AND QCUSERID=@USERID AND EM.CASEID>@CASEID

			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC

		END

		ELSE

		BEGIN
		
		if(@ROLEID!=4)
		begin

			SELECT TOP 1

				@NEXTCASEID=EM.CASEID

			FROM 

			EMAILMASTER EM

			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.CASEID>@CASEID

			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC		
		
		end
		else		
		begin
		SELECT TOP 1

				@NEXTCASEID=EM.CASEID

			FROM 

			EMAILMASTER EM

			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND ASSIGNEDTOID=@USERID AND EM.CASEID>@CASEID

			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC		
		end
		END		
		
		END
	
	ELSE

		BEGIN

		IF @STATUSID = 1

		BEGIN			

			SELECT TOP 1

				@NEXTCASEID=EM.CASEID

			FROM 

			EMAILMASTER EM

			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.CASEID<@CASEID

			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC

		END

		ELSE IF @STATUSID IN (5,6)

		BEGIN

			SELECT TOP 1

				@NEXTCASEID=EM.CASEID

			FROM 

			EMAILMASTER EM

			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID IN (5,6) AND EM.EMAILBOXID=@EMAILBOXID AND QCUSERID=@USERID AND EM.CASEID<@CASEID

			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC

		END		

		ELSE

		BEGIN
		if(@ROLEID!=4)
		begin

			SELECT TOP 1

				@NEXTCASEID=EM.CASEID

			FROM 

			EMAILMASTER EM

			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.CASEID<@CASEID

			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC		
		end
		else
		begin
			SELECT TOP 1

				@NEXTCASEID=EM.CASEID

			FROM 

			EMAILMASTER EM

			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND ASSIGNEDTOID=@USERID AND EM.CASEID<@CASEID

			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC		
		end

		END		
		
		END

		
		SELECT 

			EM.CASEID

			---,CONVERT(VARCHAR(10), EM.EMAILRECEIVEDDATE, 103) As EMAILRECEIVEDDATE
			
			, EM.EMAILRECEIVEDDATE As EMAILRECEIVEDDATE

			,CASE WHEN EM.ISMANUAL=1 THEN EM.EMAILTO ELSE EM.EMAILFROM END AS EMAILFROM

			,EM.EmailCc

			,EM.SUBJECT

			,EB.EMAILBOXNAME

			,EB.EMAILBOXADDRESS
			
            ,Em.IsUrgent
            
            ,EM.EMailBody

			,CO.COUNTRY

			,CO.CountryId

			,ST.STATUSID

			,ST.STATUSDESCRIPTION

			,EM.ASSIGNEDTOID

			,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO

			,EM.QCUSERID

			,UMQC.FIRSTNAME+', '+UMQC.LASTNAME AS QCASSIGNEDTO

			,EM.ISMANUAL

			,EM.ATTACHMENTLOCATION

			,CASE WHEN EM.ISMANUAL = 1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS EMAILTYPE

			,EB.ISQCREQUIRED

			,EB.ISMAILTRIGGERREQUIRED

			,EB.EMAILBOXID

			,EM.ISMANUAL, CategoryId
			
			,SPG.SubprocessName

		FROM 

		EMAILMASTER EM

		LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
		
		LEFT JOIN SUBPROCESSGROUPS SPG ON EB.SubProcessGroupId=SPG.SubProcessGroupId

		LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

		LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

		LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

		LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID
		
		LEFT JOIN EMAILBOXCATEGORYCONFIG EBCC ON EM.CATEGORYID=EBCC.EMAILBOXCATEGORYID

		WHERE CASEID=@NEXTCASEID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCaseDetailsForLoadingNextCase_NEW]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--_helptext USP_GetCaseDetailsForLoadingNextCase
--SP_GetCaseDetailsForLoadingNextCase

--ec USP_GetCaseDetailsForLoadingNextCase_NEW 31754,2,195174,2

CREATE  PROCEDURE [dbo].[USP_GetCaseDetailsForLoadingNextCase_NEW]



(

	@CASEID AS BIGINT,
		
	@EMAILBOXID AS INT,
	
	@USERID VARCHAR(50),
	
	@STATUSID INT,
	
	@ROLEID INT,
	@CASEFLAG INT,
	@ClassificationName varchar(100)

)

AS
BEGIN

	DECLARE @NEXTCASEID bigint
	DECLARE @classificationId bigint

	 select @classificationId=ClassificationID from InboundClassification where ClassifiactionDescription=@ClassificationName
	
	IF @CASEFLAG=1
	
		BEGIN

		
	IF @STATUSID = 1
	

		BEGIN			
				
			SELECT TOP 1

				@NEXTCASEID=EM.CASEID


			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId


			AND EM.CASEID>@CASEID 

			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC



		END



		ELSE IF @STATUSID IN (5,6)



		BEGIN



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID IN (5,6) AND EM.EMAILBOXID=@EMAILBOXID AND QCUSERID=@USERID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID>@CASEID



			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC



		END



		ELSE



		BEGIN

		

		if(@ROLEID!=4)

		begin



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID>@CASEID



			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC		

		

		end

		else		

		begin

		SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND ASSIGNEDTOID=@USERID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID>@CASEID



			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC		

		end

		END		

		

		END

	

	ELSE



		BEGIN



		IF @STATUSID = 1



		BEGIN			



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID<@CASEID



			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC



		END



		ELSE IF @STATUSID IN (5,6)



		BEGIN



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID IN (5,6) AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND QCUSERID=@USERID AND EM.CASEID<@CASEID



			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC



		END		



		ELSE



		BEGIN

		if(@ROLEID!=4)

		begin



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID<@CASEID



			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC		

		end

		else

		begin

			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND ASSIGNEDTOID=@USERID AND EM.CASEID<@CASEID



			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC		

		end



		END		

		

		END



		

		SELECT 



			EM.CASEID



			---,CONVERT(VARCHAR(10), EM.EMAILRECEIVEDDATE, 103) As EMAILRECEIVEDDATE

			

			, EM.EMAILRECEIVEDDATE As EMAILRECEIVEDDATE



			,CASE WHEN EM.ISMANUAL=1 THEN EM.EMAILTO ELSE EM.EMAILFROM END AS EMAILFROM



			,EM.EmailCc



			,EM.SUBJECT



			,EB.EMAILBOXNAME



			,EB.EMAILBOXADDRESS

			

            ,Em.IsUrgent

            

            ,EM.EMailBody



			,CO.COUNTRY



			,CO.CountryId



			,ST.STATUSID



			,ST.STATUSDESCRIPTION



			,EM.ASSIGNEDTOID



			,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO



			,EM.QCUSERID



			,UMQC.FIRSTNAME+', '+UMQC.LASTNAME AS QCASSIGNEDTO



			,EM.ISMANUAL



			,EM.ATTACHMENTLOCATION



			,CASE WHEN EM.ISMANUAL = 1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS EMAILTYPE



			,EB.ISQCREQUIRED



			,EB.ISMAILTRIGGERREQUIRED



			,EB.EMAILBOXID



			,EM.ISMANUAL, CategoryId

			

			,SPG.SubprocessName

			FROM 


		EMAILMASTER EM

		
		LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

		
		LEFT JOIN SUBPROCESSGROUPS SPG ON EB.SubProcessGroupId=SPG.SubProcessGroupId

		
		LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID
		

		LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID
		

		LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

		
		LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

		
		LEFT JOIN EMAILBOXCATEGORYCONFIG EBCC ON EM.CATEGORYID=EBCC.EMAILBOXCATEGORYID

		WHERE CASEID=@NEXTCASEID

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCaseDetailsForLoadingNextCase_NEW)]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--_helptext USP_GetCaseDetailsForLoadingNextCase
--SP_GetCaseDetailsForLoadingNextCase

CREATE PROCEDURE [dbo].[USP_GetCaseDetailsForLoadingNextCase_NEW)]



(

	@CASEID AS BIGINT,
		
	@EMAILBOXID AS INT,
	
	@USERID VARCHAR(50),
	
	@STATUSID INT,
	
	@ROLEID INT,
	@CASEFLAG INT,
	@ClassificationName INT

)

AS
BEGIN

	DECLARE @NEXTCASEID bigint
	DECLARE @classificationId bigint

	 select @classificationId=ClassificationID from InboundClassification where ClassifiactionDescription=@ClassificationName
	
	IF @CASEFLAG=1
	
		BEGIN

		
	IF @STATUSID = 1
	

		BEGIN			
				
			SELECT TOP 1

				@NEXTCASEID=EM.CASEID


			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId


			AND EM.CASEID>@CASEID 

			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC



		END



		ELSE IF @STATUSID IN (5,6)



		BEGIN



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID IN (5,6) AND EM.EMAILBOXID=@EMAILBOXID AND QCUSERID=@USERID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID>@CASEID



			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC



		END



		ELSE



		BEGIN

		

		if(@ROLEID!=4)

		begin



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID>@CASEID



			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC		

		

		end

		else		

		begin

		SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND ASSIGNEDTOID=@USERID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID>@CASEID



			ORDER BY EM.CREATEDDATE ASC,EM.CASEID ASC		

		end

		END		

		

		END

	

	ELSE



		BEGIN



		IF @STATUSID = 1



		BEGIN			



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID<@CASEID



			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC



		END



		ELSE IF @STATUSID IN (5,6)



		BEGIN



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID IN (5,6) AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND QCUSERID=@USERID AND EM.CASEID<@CASEID



			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC



		END		



		ELSE



		BEGIN

		if(@ROLEID!=4)

		begin



			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND EM.CASEID<@CASEID



			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC		

		end

		else

		begin

			SELECT TOP 1



				@NEXTCASEID=EM.CASEID



			FROM 



			EMAILMASTER EM



			LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID



			LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID



			LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID



			LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID



			LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID



			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND EM.ClassificationID=@classificationId
			 AND ASSIGNEDTOID=@USERID AND EM.CASEID<@CASEID



			ORDER BY EM.CREATEDDATE DESC,EM.CASEID DESC		

		end



		END		

		

		END



		

		SELECT 



			EM.CASEID



			---,CONVERT(VARCHAR(10), EM.EMAILRECEIVEDDATE, 103) As EMAILRECEIVEDDATE

			

			, EM.EMAILRECEIVEDDATE As EMAILRECEIVEDDATE



			,CASE WHEN EM.ISMANUAL=1 THEN EM.EMAILTO ELSE EM.EMAILFROM END AS EMAILFROM



			,EM.EmailCc



			,EM.SUBJECT



			,EB.EMAILBOXNAME



			,EB.EMAILBOXADDRESS

			

            ,Em.IsUrgent

            

            ,EM.EMailBody



			,CO.COUNTRY



			,CO.CountryId



			,ST.STATUSID



			,ST.STATUSDESCRIPTION



			,EM.ASSIGNEDTOID



			,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO



			,EM.QCUSERID



			,UMQC.FIRSTNAME+', '+UMQC.LASTNAME AS QCASSIGNEDTO



			,EM.ISMANUAL



			,EM.ATTACHMENTLOCATION



			,CASE WHEN EM.ISMANUAL = 1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS EMAILTYPE



			,EB.ISQCREQUIRED



			,EB.ISMAILTRIGGERREQUIRED



			,EB.EMAILBOXID



			,EM.ISMANUAL, CategoryId

			

			,SPG.SubprocessName

			FROM 


		EMAILMASTER EM

		
		LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

		
		LEFT JOIN SUBPROCESSGROUPS SPG ON EB.SubProcessGroupId=SPG.SubProcessGroupId

		
		LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID
		

		LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID
		

		LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

		
		LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

		
		LEFT JOIN EMAILBOXCATEGORYCONFIG EBCC ON EM.CATEGORYID=EBCC.EMAILBOXCATEGORYID

		WHERE CASEID=@NEXTCASEID

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCaseDetailsForProcessing]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*

* CREATED BY : RAGUVARAN E

* CREATED DATE : 05/26/2014

* PURPOSE : TO GET THE CASE DETAILS TO DISPLAY IN PROCESSING PAGE

*/



CREATE PROCEDURE [dbo].[USP_GetCaseDetailsForProcessing]

(

	@CASEID AS BIGINT,

	@EMAILBOXID AS INT,

	@USERID VARCHAR(50),

	@STATUSID INT,

	@ROLEID INT

)

AS

BEGIN

declare @InitialStatus int
declare @QCPendingStatus int

	IF @CASEID IS NULL --search page

	BEGIN

	if exists(Select StatusId from dbo.Status where SubProcessID in (Select SubProcessGroupId from dbo.EMailBox where EMailBoxId=@EMAILBOXID)) 
	set @InitialStatus =(Select StatusId from dbo.Status where IsInitalStatus='1' and SubProcessID in (Select SubProcessGroupId from dbo.EMailBox where EMailBoxId=@EMAILBOXID) )
	else
	set @InitialStatus = (Select StatusId from dbo.Status where IsInitalStatus='1' and SubProcessID is null) 

	if exists(Select StatusId from dbo.Status where SubProcessID in (Select SubProcessGroupId from dbo.EMailBox where EMailBoxId=@EMAILBOXID)) 
	set @QCPendingStatus =(Select StatusId from dbo.Status where IsQCPending='1' and SubProcessID in (Select SubProcessGroupId from dbo.EMailBox where EMailBoxId=@EMAILBOXID) )
	else
	set @QCPendingStatus = (Select StatusId from dbo.Status where IsQCPending='1' and SubProcessID is null) 

	

		IF @STATUSID =(@InitialStatus)

		BEGIN

			SELECT TOP 1

				@CASEID=EM.CASEID

			FROM 

			EMAILMASTER EM WITH (NOLOCK)

			LEFT JOIN EMAILBOX EB WITH (NOLOCK) ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO WITH (NOLOCK) ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST WITH (NOLOCK) ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM WITH (NOLOCK) ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC WITH (NOLOCK) ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID

			ORDER BY EM.CREATEDDATE,EM.CASEID

		END

		ELSE IF @STATUSID =@QCPendingStatus

		BEGIN

			SELECT TOP 1

				@CASEID=EM.CASEID

			FROM 

			EMAILMASTER EM WITH (NOLOCK)

			LEFT JOIN EMAILBOX EB WITH (NOLOCK) ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO WITH (NOLOCK) ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST WITH (NOLOCK) ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM WITH (NOLOCK) ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC WITH (NOLOCK) ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID = @QCPendingStatus AND EM.EMAILBOXID=@EMAILBOXID AND QCUSERID=@USERID

			ORDER BY EM.CREATEDDATE,EM.CASEID

		END

		ELSE

		BEGIN

			SELECT TOP 1

				@CASEID=EM.CASEID

			FROM 

			EMAILMASTER EM WITH (NOLOCK)

			LEFT JOIN EMAILBOX EB WITH (NOLOCK) ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO WITH (NOLOCK) ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST WITH (NOLOCK) ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM WITH (NOLOCK)  ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC WITH (NOLOCK) ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND ASSIGNEDTOID=@USERID

			ORDER BY EM.CREATEDDATE,EM.CASEID

		END

	END

	

	IF @ROLEID = 4

	BEGIN

		DECLARE @PREVSTATUSID INT

		SELECT @PREVSTATUSID=STATUSID FROM EMAILMASTER WITH (NOLOCK) WHERE CASEID=@CASEID



		
		IF @PREVSTATUSID in(Select StatusId from dbo.Status where IsInitalStatus=1 )


		BEGIN
		declare @AssignedStatus int
		if exists(Select StatusId from dbo.Status where SubProcessID in (Select SubProcessGroupId from dbo.EMailBox where EMailBoxId=@EMAILBOXID)) 
	set @AssignedStatus =(Select StatusId from dbo.Status where IsAssigned='1' and SubProcessID in (Select SubProcessGroupId from dbo.EMailBox where EMailBoxId=@EMAILBOXID) )
	else
	set @AssignedStatus = (Select StatusId from dbo.Status where IsAssigned='1' and SubProcessID is null) 
	print @AssignedStatus
			UPDATE EMAILMASTER SET STATUSID=@AssignedStatus,ASSIGNEDTOID=@USERID,ASSIGNEDDATE=getutcdate()

			,MODIFIEDBYID=@USERID,MODIFIEDDATE=getutcdate()

			WHERE CASEID=@CASEID



			INSERT INTO EMAILAUDIT (CASEID,FROMSTATUSID,TOSTATUSID,USERID,STARTTIME,ENDTIME) 

			VALUES (@CASEID,@PREVSTATUSID,@AssignedStatus,@USERID,getutcdate(),getutcdate())

		END

	END --TL logic

		

	SELECT 

			EM.CASEID

			--,CONVERT(VARCHAR(10), EM.EMAILRECEIVEDDATE, 103) As EMAILRECEIVEDDATE

            , EM.EMAILRECEIVEDDATE As EMAILRECEIVEDDATE
            ,EB.EMailBoxAddressOptional as EMailBoxAddressOptional
			,CASE WHEN EM.ISMANUAL=1 THEN EM.EMAILTO ELSE EM.EMAILFROM END AS EMAILFROM

			,EM.EmailCc
			
			,IC.ClassifiactionDescription
			
			,IC.IsActive

			,EM.SUBJECT

			,EB.EMAILBOXNAME

			,EB.EMAILBOXADDRESS
			
            ,Em.IsUrgent
            
            ,EM.EMailBody

			,CO.COUNTRY

			,CO.CountryId

			,ST.STATUSID

			,ST.STATUSDESCRIPTION

			,EM.ASSIGNEDTOID

			,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO

			,EM.QCUSERID

			,UMQC.FIRSTNAME+', '+UMQC.LASTNAME AS QCASSIGNEDTO

			,EM.ApproverUserId

			,UMApp.FIRSTNAME+', '+UMApp.LASTNAME AS APPROVERASSIGNEDTO

			,EM.ISMANUAL

			,EM.ATTACHMENTLOCATION

			,CASE WHEN EM.ISMANUAL = 1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS EMAILTYPE

			,EB.ISQCREQUIRED

			,EB.ISMAILTRIGGERREQUIRED

			,EB.EMAILBOXID

			,EM.ISMANUAL

			,CategoryId

			,EM.ParentCaseId

			,EM.ForwardedToGMB

			,SPG.SubProcessGroupId
			
			,SPG.SubprocessName

		FROM 

		EMAILMASTER EM
		
		LEFT JOIN InboundClassification IC ON EM.ClassificationID=IC.ClassificationID

		LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
		
		LEFT JOIN SUBPROCESSGROUPS SPG ON EB.SubProcessGroupId=SPG.SubProcessGroupId

		LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

		LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

		LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

		LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID

		LEFT JOIN USERMASTER UMApp ON UMApp.UserId=EM.ApproverUserId
		
		LEFT JOIN EMAILBOXCATEGORYCONFIG EBCC ON EM.CATEGORYID=EBCC.EMAILBOXCATEGORYID

		WHERE CASEID=@CASEID

		

		

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCaseDetailsForProcessing_dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*

* CREATED BY : RAGUVARAN E

* CREATED DATE : 05/26/2014

* PURPOSE : TO GET THE CASE DETAILS TO DISPLAY IN PROCESSING PAGE

*/



CREATE PROCEDURE [dbo].[USP_GetCaseDetailsForProcessing_dynamic]

(

	@CASEID AS BIGINT,

	@EMAILBOXID AS INT,

	@USERID VARCHAR(50),

	@STATUSID INT,

	@ROLEID INT

)

AS

BEGIN



	IF @CASEID IS NULL --search page

	BEGIN

	

		IF @STATUSID in(Select StatusId from dbo.Status where IsInitalStatus=1 and SubProcessID in (Select SubProcessID from dbo.EMailBox where EMailBoxId=@EMAILBOXID))

		BEGIN

			SELECT TOP 1

				@CASEID=EM.CASEID

			FROM 

			EMAILMASTER EM WITH (NOLOCK)

			LEFT JOIN EMAILBOX EB WITH (NOLOCK) ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO WITH (NOLOCK) ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST WITH (NOLOCK) ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM WITH (NOLOCK) ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC WITH (NOLOCK) ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID

			ORDER BY EM.CREATEDDATE,EM.CASEID

		END

		ELSE IF @STATUSID IN (Select StatusId from dbo.Status where IsQCPending=1 and SubProcessID in (Select SubProcessID from dbo.EMailBox where EMailBoxId=@EMAILBOXID))

		BEGIN

			SELECT TOP 1

				@CASEID=EM.CASEID

			FROM 

			EMAILMASTER EM WITH (NOLOCK)

			LEFT JOIN EMAILBOX EB WITH (NOLOCK) ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO WITH (NOLOCK) ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST WITH (NOLOCK) ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM WITH (NOLOCK) ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC WITH (NOLOCK) ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID IN (5,6) AND EM.EMAILBOXID=@EMAILBOXID AND QCUSERID=@USERID

			ORDER BY EM.CREATEDDATE,EM.CASEID

		END

		ELSE

		BEGIN

			SELECT TOP 1

				@CASEID=EM.CASEID

			FROM 

			EMAILMASTER EM WITH (NOLOCK)

			LEFT JOIN EMAILBOX EB WITH (NOLOCK) ON EM.EMAILBOXID=EB.EMAILBOXID

			LEFT JOIN COUNTRY CO WITH (NOLOCK) ON EB.COUNTRYID=CO.COUNTRYID

			LEFT JOIN STATUS ST WITH (NOLOCK) ON EM.STATUSID=ST.STATUSID

			LEFT JOIN USERMASTER UM WITH (NOLOCK)  ON UM.USERID=EM.ASSIGNEDTOID

			LEFT JOIN USERMASTER UMQC WITH (NOLOCK) ON UMQC.USERID=EM.QCUSERID

			WHERE EM.STATUSID=@STATUSID AND EM.EMAILBOXID=@EMAILBOXID AND ASSIGNEDTOID=@USERID

			ORDER BY EM.CREATEDDATE,EM.CASEID

		END

	END

	

	IF @ROLEID = 4

	BEGIN

		DECLARE @PREVSTATUSID INT

		SELECT @PREVSTATUSID=STATUSID FROM EMAILMASTER WITH (NOLOCK) WHERE CASEID=@CASEID



		IF(@PREVSTATUSID=1)

		BEGIN
		declare @AssignedStatus int
		Select @AssignedStatus=StatusId from dbo.Status where IsAssigned='1' and SubProcessID in (Select SubProcessID from Emailbox where EmailBoxid=@EMAILBOXID)

			UPDATE EMAILMASTER SET STATUSID=@AssignedStatus,ASSIGNEDTOID=@USERID,ASSIGNEDDATE=getutcdate()

			,MODIFIEDBYID=@USERID,MODIFIEDDATE=getutcdate()

			WHERE CASEID=@CASEID



			INSERT INTO EMAILAUDIT (CASEID,FROMSTATUSID,TOSTATUSID,USERID,STARTTIME,ENDTIME) 

			VALUES (@CASEID,@PREVSTATUSID,@AssignedStatus,@USERID,getutcdate(),getutcdate())

		END

	END --TL logic

		

	SELECT 

			EM.CASEID

			--,CONVERT(VARCHAR(10), EM.EMAILRECEIVEDDATE, 103) As EMAILRECEIVEDDATE

            , EM.EMAILRECEIVEDDATE As EMAILRECEIVEDDATE
            ,EB.EMailBoxAddressOptional as EMailBoxAddressOptional
			,CASE WHEN EM.ISMANUAL=1 THEN EM.EMAILTO ELSE EM.EMAILFROM END AS EMAILFROM

			,EM.EmailCc
			
			,IC.ClassifiactionDescription
			
			,IC.IsActive

			,EM.SUBJECT

			,EB.EMAILBOXNAME

			,EB.EMAILBOXADDRESS
			
            ,Em.IsUrgent
            
            ,EM.EMailBody

			,CO.COUNTRY

			,CO.CountryId

			,ST.STATUSID

			,ST.STATUSDESCRIPTION

			,EM.ASSIGNEDTOID

			,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO

			,EM.QCUSERID

			,UMQC.FIRSTNAME+', '+UMQC.LASTNAME AS QCASSIGNEDTO

			,EM.ISMANUAL

			,EM.ATTACHMENTLOCATION

			,CASE WHEN EM.ISMANUAL = 1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS EMAILTYPE

			,EB.ISQCREQUIRED

			,EB.ISMAILTRIGGERREQUIRED

			,EB.EMAILBOXID

			,EM.ISMANUAL

			,CategoryId

			,EM.ParentCaseId

			,EM.ForwardedToGMB

			,SPG.SubProcessGroupId
			
			,SPG.SubprocessName

		FROM 

		EMAILMASTER EM
		
		LEFT JOIN InboundClassification IC ON EM.ClassificationID=IC.ClassificationID

		LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
		
		LEFT JOIN SUBPROCESSGROUPS SPG ON EB.SubProcessGroupId=SPG.SubProcessGroupId

		LEFT JOIN COUNTRY CO ON EB.COUNTRYID=CO.COUNTRYID

		LEFT JOIN STATUS ST ON EM.STATUSID=ST.STATUSID

		LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

		LEFT JOIN USERMASTER UMQC ON UMQC.USERID=EM.QCUSERID
		
		LEFT JOIN EMAILBOXCATEGORYCONFIG EBCC ON EM.CATEGORYID=EBCC.EMAILBOXCATEGORYID

		WHERE CASEID=@CASEID

		

		

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCasesForEscalationMail]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================

-- Author:		Varma

-- Create date: 19th Oct 2015

-- Description:	Escation Trigger Mail Master

-- =============================================

CREATE PROCEDURE [dbo].[USP_GetCasesForEscalationMail]

AS

BEGIN

SELECT  em.CaseId, em.StatusId, em.RemainderMailCount,ISNULL(CEILING((DATEDIFF(minute, em.ModifiedDate, getutcdate()) / 60.0) / 24.0), 0) [DAYS],   ISNULL((DATEDIFF(HH, em.ModifiedDate, getutcdate())), 0)  [Hours], eb.EMailBoxId, eb.EMailboxName [EMailbox], ebl


.EMailId [EMailboxLoginId],ebl.Password [EMailboxLoginPassword],eb.EMailFolderPath  [ServiceURL],   em.IsManual,

esc.ToMailID [TO], 

 case when em.ismanual=0 then em.EMailTo when em.ismanual=1 then em.EMailFrom end [FROM],  spg.ProcessOwnerId [CC],    

   ISNULL((select FileName from EMailAttachment ea where ea.CaseId = em.CaseId and FileName='Followup.html'),  

   (select FileName from EMailAttachment ea where ea.CaseId = em.CaseId and FileName='Body.html')) as [FileName],  

  ISNULL((select Content from EMailAttachment ea where ea.CaseId = em.CaseId and FileName='Followup.html'),       

  (select Content from EMailAttachment ea where ea.CaseId = em.CaseId and FileName='Body.html')) as [BODY]  ,  

convert(varchar(20),em.EMailReceivedDate,101)    as EMailReceivedDate,em.Subject, esc.EscalationMailID, em.EscalationCount 

 FROM EmailMaster em inner join              

  EMailbox eb on  em.EMailBoxId = eb.EMailBoxId AND eb.IsActive=1 and eb.IsLocked=0 inner join              

  EmailBoxLoginDetail ebl on eb.EMailboxLoginDetailId = ebl.EMailboxLoginDetailId and ebl.IsActive=1 inner join              

  SubProcessGroups spg on eb.SubProcessGroupId = spg.SubProcessGroupId  

inner join EscalationMaster esc on esc.ToMailID=

(select EMailTo from emailsent where EMailSentId=(select max(EMailSentId) from emailsent where CaseId=em.CaseId))

 where em.StatusId=3  and em.EmailBoxID=1 and esc.isactive=1

 and ISNULL((DATEDIFF(HH, em.ModifiedDate, getutcdate())), 0) >= esc.TimeFrequency and em.EscalationCount<3



	end







GO
/****** Object:  StoredProcedure [dbo].[USP_GetCasesForEscalationMail_New]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- exec USP_GetCasesForEscalationMail_New
CREATE PROCEDURE [dbo].[USP_GetCasesForEscalationMail_New]
AS
BEGIN 
--Select * from SLABreachNotificationsTransaction where 
--drop table #TableVar
Create table #TableVar (Id int identity(1,1),CaseID int NOT NULL )

--declare @DtToCompare datetime
--if ()
--select @DtToCompare


Insert Into #TableVar (CaseID)
select Distinct SBNT.caseID from EmailMaster EM inner join 
SLABreachNotificationsMaster SBN on EM.EMailBoxId=SBN.EMailBoxId
inner join SLABreachNotificationsTransaction SBNT on EM.caseid= SBNT.caseid
Where EM.StatusId =1 and ISNULL((DATEDIFF(Second, SBNT.MailSentDate, getdate())), 0) >= SBN.FrequencyInSeconds 
and SBN.IsActive=1 and EM.EMailBoxId=3
and sbnt.BreachID in (select top 1 breachid from SLABreachNotificationsTransaction where caseid=SBNT.caseid order by 1 desc)

Insert Into #TableVar (CaseID)
select Distinct EM.caseID from EmailMaster EM inner join 
SLABreachNotificationsMaster SBN on EM.EMailBoxId=SBN.EMailBoxId 
Where EM.StatusId =1 and ISNULL((DATEDIFF(Second, EM.EMailReceivedDate, getutcdate())), 0) >= SBN.FrequencyInSeconds 
and SBN.IsActive=1 and EM.EMailBoxId=3 and Em.caseid not in (select caseid from #TableVar)

Create table  #FinalResult
(
       id int, CaseId bigint, StatusId int, EMailBoxId varchar(50) , EMailbox varchar(250),EMailboxLoginId varchar(50),EMailboxLoginPassword varchar(250),ServiceURL varchar(1000),   
       IsManual bit,[TO] varchar(max),   [FROM]varchar(250),[FileName]varchar(500),  [BODY] Image ,  EMailReceivedDate DateTime,[Subject] varchar(500)
)


Declare @Id int
Select @Id=Count(*) From #TableVar
declare @RowCount int;
declare @caseIDtemp int;

While (@Id) > 0
Begin

       
       Select @RowCount = count(ST.CaseID) from SLABreachNotificationsTransaction ST inner join #TableVar t on ST.CaseID = t.CaseID and t.Id=@Id
       Select @caseIDtemp=t.CaseID from  #TableVar t where t.Id=@Id


       if(@RowCount<3)

       Begin

       insert into #FinalResult

       SELECT  esc.id, em.CaseId, em.StatusId, eb.EMailBoxId, eb.EMailboxName [EMailbox], ebl.EMailId [EMailboxLoginId],
       ebl.[Password] [EMailboxLoginPassword],eb.EMailFolderPath  [ServiceURL],   em.IsManual,

       esc.EscalationEmailID [TO],  case when em.ismanual=0 then em.EMailTo when em.ismanual=1 then em.EMailFrom end [FROM],      

   ISNULL((select FileName from EMailAttachment ea where ea.CaseId = em.CaseId and FileName='Followup.html'),  

   (select FileName from EMailAttachment ea where ea.CaseId = em.CaseId and FileName='Body.html')) as [FileName],  

  ISNULL((select Content from EMailAttachment ea where ea.CaseId = em.CaseId and FileName='Followup.html'),       

  (select Content from EMailAttachment ea where ea.CaseId = em.CaseId and FileName='Body.html')) as [BODY]  ,  

convert(varchar(20),em.EMailReceivedDate,101)    as EMailReceivedDate,em.Subject

FROM EmailMaster em inner join              

  EMailbox eb on  em.EMailBoxId = eb.EMailBoxId AND eb.IsActive=1 and eb.IsLocked=0 inner join              

  EmailBoxLoginDetail ebl on eb.EMailboxLoginDetailId = ebl.EMailboxLoginDetailId and ebl.IsActive=1 inner join              

  SubProcessGroups spg on eb.SubProcessGroupId = spg.SubProcessGroupId  

       inner join SLABreachNotificationsMaster esc on esc.EMailBoxId=em.EMailBoxId 
       inner join #TableVar t on t.CaseID=em.CaseID

       where em.EMailBoxId=3 and esc.IsActive=1 and  SeqNo=@RowCount+1 and em.CaseId=@caseIDtemp
	   --and em.CaseId=1022

       End

       SET @Id = @Id -1;

End

select * from #FinalResult
drop table #FinalResult

drop table #TableVar


end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCasesForRemainderMail]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec USP_GetCasesForRemainderMail
CREATE PROCEDURE  [dbo].[USP_GetCasesForRemainderMail]             
AS           
BEGIN            
 SET NOCOUNT ON;
 
 DECLARE @EmailCon TABLE(
    CaseId int NOT NULL,
    ConversationId int NOT NULL
	
);

INSERT INTO @EmailCon
 Select CaseId,max(ConversationId) as ConversationId from dbo.EmailConversations group by CaseId;
   
SELECT  em.CaseId,econ.ConversationId,EC.content as [Body],em.StatusId, convert(varchar(20),em.modifieddate,103)as modifieddate, em.RemainderMailCount,
ISNULL(CEILING((DATEDIFF(minute, em.ModifiedDate, getutcdate()) / 60.0) / 24.0), 0) [DAYS],
 ISNULL((DATEDIFF(HH, em.ModifiedDate, getutcdate())), 0)  [Hours],em.IsManual,
  ERC.tostatus,ERC.Frequency,ERC.Count ,ERC.IsEscalation,      
  ebl.EMailId [EMailboxLoginId],ebl.Password [EMailboxLoginPassword],
 eb.EMailBoxId, eb.EMailboxName [EMailbox],  eb.EMailFolderPath [ServiceURL],
 case when em.ismanual=0 then em.EMailFrom when em.ismanual=1 then em.EMailTo end [TO],
 case when em.ismanual=0 then eb.EMailBoxAddress when em.ismanual=1 then em.EMailFrom end [FROM],
ERC.EscalationMailId [EscalationMailId],  
convert(varchar(20),em.EMailReceivedDate,103)    as EMailReceivedDate,em.Subject ,	 
CASE WHEN CHARINDEX('DD/MM/YYYY',ERC.Template) > 0  
THEN REPLACE(ERC.Template,'DD/MM/YYYY',convert(varchar(20),em.EMailReceivedDate,103)) 
ELSE ERC.Template  END AS 'Template'

FROM EmailMaster em 
inner join EMailbox eb on  em.EMailBoxId = eb.EMailBoxId AND eb.IsActive=1 and eb.IsLocked=0
inner join EmailBoxLoginDetail ebl on eb.EMailboxLoginDetailId = ebl.EMailboxLoginDetailId and ebl.IsActive=1 
inner join SubProcessGroups spg on eb.SubProcessGroupId = spg.SubProcessGroupId 
inner join EmailboxRemainderConfig ERC on ERC.EmailboxId = eb.EMailBoxId  and ERC.IsActive=1
inner join @EmailCon ECon on em.CaseId=ECon.CaseId
inner join dbo.EmailConversations EC on Econ.ConversationId=EC.ConversationID
where em.StatusId=ERC.FromStatus  and  ISNULL((DATEDIFF(mi, em.ModifiedDate, getutcdate())), 0)/60  >= ERC.Frequency
and RemainderMailCount<ERC.Count and ERC.TemplateType=1

END 













GO
/****** Object:  StoredProcedure [dbo].[USP_GetCategorybyEmailboxid]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetCategorybyEmailboxid]    
(@Emailboxid int)
AS    
BEGIN    
 SELECT   
   
  EmailboxCategoryId,Category  FROM [dbo].[EmailboxCategoryConfig] WITH (NOLOCK)  where EmailboxId = @Emailboxid and IsActive=1 

END







GO
/****** Object:  StoredProcedure [dbo].[USP_GetChildCaseDetailsByMailBox]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_GetChildCaseDetailsByMailBox](@ParentCaseId bigint,@EMailBoxId int)

AS
BEGIN

SELECT	CaseId from dbo.EmailMaster where ParentCaseId=@ParentCaseId and EMailBoxId=@EMailBoxId and StatusId!=10;
		
end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetChildCaseDetailsByMailBox_dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_GetChildCaseDetailsByMailBox_dynamic](@ParentCaseId bigint,@EMailBoxId int)

AS
BEGIN

declare @SubProcessId nvarchar(250)
set @SubProcessId=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMailBoxId)

if exists(select * from Status where SubProcessID=@SubProcessId)
SELECT	CaseId from dbo.EmailMaster where ParentCaseId=@ParentCaseId and EMailBoxId=@EMailBoxId and StatusId not in (select StatusId from Status where SubProcessID=@SubProcessId and IsFinalStatus=1);
else
SELECT	CaseId from dbo.EmailMaster where ParentCaseId=@ParentCaseId and EMailBoxId=@EMailBoxId and StatusId not in(select StatusId from Status where SubProcessID is null and IsFinalStatus=1);
		
end
GO
/****** Object:  StoredProcedure [dbo].[USP_GETCLARIFICATIONRESETREASON]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : RAGUVARAN E
* CREATED DATE : 07/14/2014
* PURPOSE : TO GET THE LIST OF CLARIFICATION RESET REASON
*/

CREATE PROCEDURE [dbo].[USP_GETCLARIFICATIONRESETREASON]
AS
BEGIN
	SELECT 
		ResetReasonID,
		ResetReason
	FROM 
	CLARIFICATIONRESETREASON
END






GO
/****** Object:  StoredProcedure [dbo].[USP_GetClassificationCount_Details]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetClassificationCount_Details]  -- exec [[USP_GetClassificationCount_Details] 

AS                

BEGIN                 

SET NOCOUNT ON;               

if exists(select ClassificationID from InboundClassification where ISActive=1)
begin
	select 1
end         
else
begin
	select 0
end

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetClassificationNamesList]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [dbo].[[USP_GetClassificationNamesList]] 
CREATE PROCEDURE [dbo].[USP_GetClassificationNamesList]               
AS  
 BEGIN    	
	select ClassifiactionDescription from InboundClassification where IsActive=1 order by ClassifiactionDescription	
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetComments]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================              
-- Author:  <SAKTHI>              
-- Create date: <28/05/2014>              
-- Description: <TO GET COMMENTS HISTORY >              
-- =============================================   
CREATE PROC [dbo].[USP_GetComments]
(
  @CASEID BIGINT
)
AS
BEGIN
	SELECT   EQ.QueryText as COMMENTS,
            (UM.FirstName +' '+ UM.LastName) as USERNAME,
            CONVERT(VARCHAR(10), EQ.CreatedDate, 103) + ' '+CONVERT(VARCHAR(10), EQ.CreatedDate, 108) AS CREATEDDATE, 
            EQ.CASEID AS CASEID
     FROM   EMAILQUERY EQ WITH (NOLOCK)
    INNER JOIN USERMASTER UM WITH (NOLOCK) ON EQ.CreatedById=UM.UserID
     WHERE EQ.CASEID = @CASEID
	ORDER BY EQ.QueryId DESC
END












GO
/****** Object:  StoredProcedure [dbo].[USP_GetCompletedStatus]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
EXEC USP_GetCaseCurrentStatus 102  
  
*/  
CREATE PROCEDURE [dbo].[USP_GetCompletedStatus]  
(  
 @CaseID VARCHAR(50)  
)  
AS      
BEGIN      
declare @EMailboxId int
declare @SubProcessId int 
set @EMailboxId=(SELECT EMailboxId FROM EmailMaster WHERE CaseID = @CaseID)  
set @SubProcessId=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMailboxId)

if exists(select * from Status where SubProcessID=@SubProcessId)
select StatusId as CompletedStatus from Status where SubProcessID=@SubProcessId and IsFinalStatus=1
else
select StatusId as CompletedStatus from Status where SubProcessID is null and IsFinalStatus=1
    
END  
  






GO
/****** Object:  StoredProcedure [dbo].[USP_GETCONFIGUREFIELDSVALIDATIONTYPE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Select * from Tbl_Master_ValidationType    

    

--  Select * from dbo.Tbl_Master_FieldDataType    

    --exec USP_GETCONFIGUREFIELDSVALIDATIONTYPE 1

CREATE Proc [dbo].[USP_GETCONFIGUREFIELDSVALIDATIONTYPE]      

@FieldDataTypeID BigInt      

As      

Begin      

       

SET NOCOUNT ON           

    

DECLARE @ValGeneral_Query nvarchar(max)      

DECLARE @ValqueryString nvarchar(4000)      

DECLARE @ValFinal varchar(max)     

      

      

 BEGIN TRAN TXN_SELECT    

   BEGIN TRY       

 set @ValGeneral_Query = 'Select distinct VT.ValidationTypeId,VT.ValidationType From Tbl_Master_ValidationType VT   where VT.ValidationTypeId in  '    

      

 if @FieldDataTypeID = 1 or @FieldDataTypeID = 2 -- BigInt  & Int    

  Begin     

   Set @ValqueryString = '(1,9 ) '      

  End      

      

 Else if @FieldDataTypeID = 3 or @FieldDataTypeID = 4-- or @FieldDataTypeID = 5  -- DropDownList       

  Begin     

   Set @ValqueryString = ' (3,4,5,6) '     

  End     

      

 Else if @FieldDataTypeID = 5  -- DateTime      

  Begin     

   Set @ValqueryString = ' (7) '      

  End     

      

Else    

  Begin      

   Set @ValqueryString = ' (6) '      

  End      

      

Set @ValFinal = @ValGeneral_Query + @ValqueryString     

Print @ValFinal      

Exec(@ValFinal)      

  END TRY    

            BEGIN CATCH    

                  GOTO HandleError1    

            END CATCH    

            IF @@TRANCOUNT > 0 COMMIT TRAN TXN_SELECT    

            RETURN 1    

      HandleError1:    

            IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_SELECT    

            RAISERROR('Error Updating table Tbl_Master_ValidationType', 16, 1)    

            RETURN -1    

    

End







GO
/****** Object:  StoredProcedure [dbo].[USP_GetConversationByConversationId]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : Saranya Devi C
* CREATED DATE : 05/26/2014
* PURPOSE : TO GET THE LIST OF ATTACHMENTS TO DISPLAY IN PROCESSING PAGE
*/

create PROCEDURE [dbo].[USP_GetConversationByConversationId]
(
	@CONVERSATIONID AS BIGINT
)
AS
BEGIN

SELECT 
	EC.ConversationID	
	,EC.CONTENT
	,AT.ATTACHMENTTYPE 
	,EC.ConversationDate
	,EC.CreatedDate
	,EC.Subject
	
	,EC.EmailFrom
	,EC.EmailTo
	,EC.EmailCc
	,EC.EmailBcc
FROM 
EmailConversations EC
LEFT JOIN ATTACHMENTTYPE AT ON EC.ATTACHMENTTYPEID=AT.ATTACHMENTTYPEID
WHERE EC.ConversationID=@CONVERSATIONID ;

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetConversationList]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : Saranya Devi C
* CREATED DATE : 05/26/2014
* PURPOSE : TO GET THE LIST OF ATTACHMENTS TO DISPLAY IN PROCESSING PAGE
*/

CREATE PROCEDURE [dbo].[USP_GetConversationList]
(
	@CASEID AS BIGINT
)
AS
BEGIN

SELECT 
	EC.ConversationID	
	,EC.CONTENT
	,AT.ATTACHMENTTYPE 
	,EC.ConversationDate
	,EC.CreatedDate
	,EC.Subject
	
	,EC.EmailFrom
	,EC.EmailTo
	,EC.EmailCc
	,EC.EmailBcc
FROM 
EmailConversations EC
LEFT JOIN ATTACHMENTTYPE AT ON EC.ATTACHMENTTYPEID=AT.ATTACHMENTTYPEID
WHERE EC.CaseId=@CASEID and EC.AttachmentTypeID <>3 and EC.AttachmentTypeID<>4 order by EC.CreatedDate desc;

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetCountryByUserId]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetCountryByUserId]    
              
@AssociateId varchar(50)    
              
AS              
BEGIN               
SET NOCOUNT ON;              
    
    
    
SELECT DISTINCT C.COUNTRYID, C.COUNTRY FROM COUNTRY C INNER JOIN     
EMAILBOX EB ON C.COUNTRYID= EB.COUNTRYID INNER JOIN     
USERMAILBOXMAPPING UMBP ON EB.EMAILBOXID= UMBP.MAILBOXID INNER JOIN    
USERMASTER UM ON UMBP.USERID =UM.USERID    
    
WHERE UMBP.USERID = @AssociateId AND UM.ISACTIVE=1 AND C.ISACTIVE=1 AND EB.ISACTIVE=1    
    
               
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_GetCountryByUserId_For_Dashboard]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ==============================================================          
-- AUTHOR:  KALAICHELVAN KB                
-- CREATE DATE: 07/10/2014                
-- DESCRIPTION: TO BIND THE COUNTRY BASED ON THE ROLES FOR DASHBORAD    
-- ==============================================================      
CREATE PROCEDURE [dbo].[USP_GetCountryByUserId_For_Dashboard]                     
@AssociateId varchar(50) ,    
@roleid varchar(10 )                    
AS                  
BEGIN                   
SET NOCOUNT ON;       
BEGIN               
IF(@Roleid=3 or @Roleid=4)   --Team Lead/Processor  
BEGIN    
SELECT DISTINCT C.COUNTRYID, C.COUNTRY FROM COUNTRY C WITH (NOLOCK) INNER JOIN         
EMAILBOX EB WITH (NOLOCK) ON C.COUNTRYID= EB.COUNTRYID     
INNER JOIN         
USERMAILBOXMAPPING UMBP WITH (NOLOCK) ON EB.EMAILBOXID= UMBP.MAILBOXID     
inner join userrolemapping ur WITH (NOLOCK) on UMBP.userid=ur.userid    
inner join usermaster um WITH (NOLOCK) on um.userid=ur.userid    
WHERE UMBp.USERID = @AssociateId AND C.ISACTIVE=1 AND EB.ISACTIVE=1     
and ur.Roleid = @Roleid and UM.IsActive=1    
END    
ELSE IF(@Roleid=1 or @Roleid=2)  --Super Admin/Admin  
BEGIN    
   select COUNTRYID, COUNTRY FROM COUNTRY WITH (NOLOCK) where ISACTIVE=1  
END 
ELSE --IIS Users 
BEGIN    
   select COUNTRYID, COUNTRY FROM COUNTRY WITH (NOLOCK) where ISACTIVE=1 
   and COUNTRYID in(select * from SplitcaseID((select CountriesMapped from UserRoleMapping where userid=@AssociateId and roleid=@roleid), ','))
END   
END    
END  






GO
/****** Object:  StoredProcedure [dbo].[USP_GetDashboardCount]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetDashboardCount]  -- exec USP_GetDashboardCount 2,'test',3,'test',0    

@CountryId int,                

@LoggedInUserId varchar(50),                

@RoleId int,                

@SelectedAssociateId varchar(50)=null,            

@SelectedSubProcessId varchar(50)= null               

AS                

BEGIN                 

SET NOCOUNT ON;                

                 

 IF(@RoleId=4) --Processor                

  BEGIN         

   select EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    from emailbox emb WITH (NOLOCK) 

    left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em WITH (NOLOCK) on emb.EmailBoxId=em.EmailBoxId    

    inner join UserMailBoxMapping umbm WITH (NOLOCK) on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId    

    where emb.IsActive=1 and emb.CountryId=@CountryId and em.AssignedToId=@LoggedInUserId    

    and (@SelectedSubProcessId  IS NULL OR @SelectedSubProcessId=0 or emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    union    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId--,emb.SubProcessGroupId    

    from emailbox emb   WITH (NOLOCK) 

    left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em WITH (NOLOCK) on emb.EmailBoxId=em.EmailBoxId  

    inner join UserMailBoxMapping umbm WITH (NOLOCK) on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId    

    where emb.IsActive =1 and emb.CountryId=@CountryId and em.statusid=1     

    and (@SelectedSubProcessId  IS NULL OR @SelectedSubProcessId=0 or emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId--,emb.SubProcessGroupId    

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)      

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      

    

   update #Final set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

   from emailbox where      

   emailbox.emailboxid=#Final.EMailBoxID and       

   emailbox.IsQCRequired=0      

         

   --select * from #Final      

    SELECT EB.EmailBoxName as EmailBox,EB.EmailBoxID,EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB WITH (NOLOCK) 

 LEFT JOIN #Final F ON EB.EMAILBOXID = F.EmailBoxID  

 LEFT JOIN UserMailBoxMapping UMBM WITH (NOLOCK) ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  AND UMBM.UserId=@LoggedInUserId  

     

   drop table #Final      

    END    

ELSE IF(@RoleId=3) --Team Lead               

    BEGIN    

        

   declare @tempUserId varchar(20)    

   if(@SelectedAssociateId IS NULL OR @SelectedAssociateId='0')    

    begin    

     set @tempUserId = @LoggedInUserId    

     select EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final10      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    from emailbox emb WITH (NOLOCK)   

    left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em WITH (NOLOCK) on emb.EmailBoxId=em.EmailBoxId       

    inner join UserMailBoxMapping umbm WITH (NOLOCK) on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId   

    where emb.IsActive=1 and emb.CountryId=@CountryId --and     

    and (@SelectedSubProcessId IS NULL OR @SelectedSubProcessId=0 OR emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    union    

 select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    from emailbox emb  WITH (NOLOCK)  

    left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em WITH (NOLOCK) on emb.EmailBoxId=em.EmailBoxId    

    inner join UserMailBoxMapping umbm WITH (NOLOCK) on umbm.MailBoxId = em.EmailBoxId AND umbm.UserId=@LoggedInUserId  

    where emb.IsActive =1 and emb.CountryId=@CountryId and em.statusid=1     

    and (@SelectedSubProcessId  IS NULL OR @SelectedSubProcessId=0 OR emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)      

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      

    

   update #Final10 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

   from emailbox where      

   emailbox.emailboxid=#Final10.EMailBoxID and       

   emailbox.IsQCRequired=0      

         

   --select * from #Final10      

    SELECT EB.EmailBoxName as EmailBox,EB.EmailBoxID,EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  WITH (NOLOCK)

 LEFT JOIN #Final10 F ON EB.EMAILBOXID = F.EmailBoxID  

 LEFT JOIN UserMailBoxMapping UMBM WITH (NOLOCK) ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  AND UMBM.UserId=@LoggedInUserId  

        

    drop table #Final10     

    end    

   else    

    begin    

     set @tempUserId = @SelectedAssociateId    

    

     select EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final1      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    from emailbox emb WITH (NOLOCK)   

    left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em WITH (NOLOCK) on em.EmailBoxId=emb.EmailBoxId    

    inner join UserMailBoxMapping umbm WITH (NOLOCK) on em.EmailBoxId = umbm.MailBoxId    

        

    where emb.IsActive=1 and emb.CountryId=@CountryId and     

    em.AssignedToId = @tempUserId --case when @SelectedAssociateId IS NULL OR @SelectedAssociateId=0 then @LoggedInUserId    

    --else @SelectedAssociateId end    

        

    and (@SelectedSubProcessId IS NULL OR @SelectedSubProcessId=0 OR emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

       union    

       select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    from emailbox emb  WITH (NOLOCK)  

    left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em WITH (NOLOCK) on em.EmailBoxId=emb.EmailBoxId    

    inner join UserMailBoxMapping umbm WITH (NOLOCK) on em.EmailBoxId = umbm.MailBoxId    

    where emb.IsActive =1 and emb.CountryId=@CountryId and em.statusid=1     

    and (@SelectedSubProcessId  IS NULL OR @SelectedSubProcessId=0 OR emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)    

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      

    

   update #Final1 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

   from emailbox where      

   emailbox.emailboxid=#Final1.EMailBoxID and       

   emailbox.IsQCRequired=0      

         

   --select * from #Final1      

    SELECT EB.EmailBoxName as EmailBox,EB.EmailBoxID,EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  WITH (NOLOCK)

 LEFT JOIN #Final1 F ON EB.EMAILBOXID = F.EmailBoxID  

 LEFT JOIN UserMailBoxMapping UMBM WITH (NOLOCK) ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  

   

   drop table #Final1     

    end    

      

        

    END    

 ELSE IF(@RoleId in(1, 2, 5))--Super Admin/Admin/ISS User              

  BEGIN                

   IF(@SelectedAssociateId = '0' and @SelectedSubProcessId = 0)                

    BEGIN             

  select EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

  [1] as 'Open', [2] as 'Assigned',[3] as 'Clarification Needed', [4] as 'Clarification Provided', [5]as 'Pending for QC',      

  [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

  into  #Final4      

  from      

  (    

  --select EM.StatusId ,EMBox.EmailBoxID,caseid,EMBox.EmailBoxName,EMBox.CountryId  from dbo.EmailMaster EM      

  --left outer join dbo.EMailBox EMBox  on EMBox.Emailboxid  =EM.Emailboxid       

  --where  EMBox.countryId=@CountryId and EMBox.IsActive =1       

  --group by EM.statusid,EMBox.EmailBoxID,caseid,EMBox.EmailBoxName,EMBox.CountryId    

  select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

  from emailbox emb  WITH (NOLOCK)  

  left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

  left join emailmaster em WITH (NOLOCK) on em.EmailBoxId=emb.EmailBoxId    

  where emb.IsActive =1 and emb.CountryId=@CountryId     

  group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId     

  )as SourceTable      

  PIVOT      

  (      

  count(caseid)      

  FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

  ) AS PivotTable      

      

  update #Final4 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

  from emailbox where      

  emailbox.emailboxid=#Final4.EMailBoxID and       

  emailbox.IsQCRequired=0      

        

  --select * from #Final4      

    SELECT EB.EmailBoxName as EmailBox,EB.EmailBoxID,EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB WITH (NOLOCK)

 LEFT JOIN #Final4 F ON EB.EMAILBOXID = F.EmailBoxID  

 LEFT JOIN UserMailBoxMapping UMBM WITH (NOLOCK) ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  

   

  drop table #Final4     

      

    END                

   ELSE IF(@SelectedAssociateId <> '0' and  @SelectedSubProcessId <> 0)                

    BEGIN             

      

  select EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

  [1] as 'Open', [2] as 'Assigned',[3] as 'Clarification Needed' ,[4] as 'Clarification Provided', [5]as 'Pending for QC',      

  [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

  into  #Final5      

  from      

  (    

  --select EM.StatusId ,EMBox.EmailBoxID,caseid,EMBox.EmailBoxName,EMBox.CountryId  from dbo.EmailMaster EM      

  --left outer join dbo.EMailBox EMBox on EMBox.Emailboxid  =EM.Emailboxid       

  --inner join UserMailBoxMapping umbm on EM.EmailBoxId = umbm.MailBoxId      

  --where  EMBox.countryId=@CountryId and EMBox.IsActive =1 and  EM.ASSIGNEDTOID=@SelectedAssociateId and EMBox.SubProcessGroupId=@SelectedSubProcessId      

  --group by EM.statusid,EMBox.EmailBoxID,caseid,EMBox.EmailBoxName,EMBox.CountryId    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

       from emailbox emb    WITH (NOLOCK)

    left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em WITH (NOLOCK) on em.EmailBoxId=emb.EmailBoxId    

    inner join UserMailBoxMapping umbm WITH (NOLOCK) on em.EmailBoxId = umbm.MailBoxId    

    where emb.IsActive =1 and emb.CountryId=@CountryId and em.ASSIGNEDTOID=@SelectedAssociateId and emb.SubProcessGroupId=@SelectedSubProcessId    

    group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

  )as SourceTable      

  PIVOT      

  (      

  count(caseid)      

  FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

  ) AS PivotTable      

      

  update #Final5 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

  from emailbox where      

  emailbox.emailboxid=#Final5.EMailBoxID and       

  emailbox.IsQCRequired=0      

        

  --select * from #Final5      

    SELECT EB.EmailBoxName as EmailBox,EB.EmailBoxID,EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  WITH (NOLOCK)

 LEFT JOIN #Final5 F ON EB.EMAILBOXID = F.EmailBoxID  

 LEFT JOIN UserMailBoxMapping UMBM  ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  

   

  drop table #Final5      

              

    END               

                

    -- TO GET DASHBOARD COUNT BASED ON SUBPROCESS             

                 

 ELSE IF(@SelectedAssociateId <> '0')                

    BEGIN              

    select EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed',[4] as 'Clarification Provided',[5]as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

    into  #Final6      

    from      

    (    

    --select EM.StatusId ,EMBox.EmailBoxID,caseid,EMBox.EmailBoxName,EMBox.CountryId  from dbo.EmailMaster EM      

    --left outer join dbo.EMailBox EMBox on EMBox.Emailboxid  =EM.Emailboxid       

    --inner join UserMailBoxMapping umbm on EM.EmailBoxId = umbm.MailBoxId      

    --where  EMBox.countryId=@CountryId and EMBox.IsActive =1 and  EM.ASSIGNEDTOID=@SelectedAssociateId       

    --group by EM.statusid,EMBox.EmailBoxID,caseid,EMBox.EmailBoxName,EMBox.CountryId     

     select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

     from emailbox emb  WITH (NOLOCK)  

     left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

     left join emailmaster em WITH (NOLOCK) on em.EmailBoxId=emb.EmailBoxId    

     inner join UserMailBoxMapping umbm WITH (NOLOCK) on em.EmailBoxId = umbm.MailBoxId    

     where emb.IsActive =1 and emb.CountryId=@CountryId and em.ASSIGNEDTOID=@SelectedAssociateId    

     group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    )as SourceTable      

    PIVOT      

    (      

    count(caseid)      

    FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

    ) AS PivotTable      

       

   update #Final6 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

   from emailbox where      

   emailbox.emailboxid=#Final6.EMailBoxID and emailbox.IsQCRequired=0      

       

   --select * from #Final6      

    SELECT EB.EmailBoxName as EmailBox,EB.EmailBoxID,EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  WITH (NOLOCK)

 LEFT JOIN #Final6 F ON EB.EMAILBOXID = F.EmailBoxID  

 LEFT JOIN UserMailBoxMapping UMBM WITH (NOLOCK) ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  

   

    drop table #Final6      

              

    END             

                

    ELSE IF(@SelectedSubProcessId <> 0)                

    BEGIN              

            

  select EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

  [1] as 'Open', [2] as 'Assigned',[3] as 'Clarification Needed' ,[4] as 'Clarification Provided',[5]as 'Pending for QC',      

  [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

  into  #Final7      

  from      

  (    

  --select EM.StatusId ,EMBox.EmailBoxID,caseid,EMBox.EmailBoxName,EMBox.CountryId  from dbo.EmailMaster EM      

  --left outer join dbo.EMailBox EMBox on EMBox.Emailboxid  =EM.Emailboxid       

  --where EMBox.countryId=@CountryId and EMBox.IsActive =1 and  EMBox.SubProcessGroupId=@SelectedSubProcessId      

  --group by EM.statusid,EMBox.EmailBoxID,caseid,EMBox.EmailBoxName,EMBox.CountryId      

     select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

     from emailbox emb  WITH (NOLOCK)  

     left join country c WITH (NOLOCK) on emb.CountryId=c.CountryId and c.IsActive=1     

     left join emailmaster em WITH (NOLOCK) on em.EmailBoxId=emb.EmailBoxId    

     inner join UserMailBoxMapping umbm WITH (NOLOCK) on em.EmailBoxId = umbm.MailBoxId    

     where emb.IsActive =1 and emb.CountryId=@CountryId and emb.SubProcessGroupId=@SelectedSubProcessId      

     group by em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

  )as SourceTable      

  PIVOT      

  (      

  count(caseid)      

  FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

  ) AS PivotTable      

      

  update #Final7 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

  from emailbox where      

  emailbox.emailboxid=#Final7.EMailBoxID and emailbox.IsQCRequired=0      

      

  --select * from #Final7      

 SELECT EB.EmailBoxName as EmailBox,EB.EmailBoxID,EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  WITH (NOLOCK)

 LEFT JOIN #Final7 F ON EB.EMAILBOXID = F.EmailBoxID  

 LEFT JOIN UserMailBoxMapping UMBM WITH (NOLOCK) ON EB.EMAILBOXID = UMBM.MailBoxId   AND UMBM.UserId=@LoggedInUserId 

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  

    

    drop table #Final7      

                 

    END             

   END                

END   









GO
/****** Object:  StoredProcedure [dbo].[USP_GetDashboardCount_Details]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetDashboardCount_Details]  -- exec USP_GetDashboardCount 2,'test',3,'test',0    

@CountryId int,                

@LoggedInUserId varchar(50),                

@RoleId int,                

@SelectedAssociateId varchar(50)=null

--@SelectedSubProcessId varchar(50)= null               

AS                

BEGIN                 

SET NOCOUNT ON;                

                 

 IF(@RoleId=4) --Processor                

  BEGIN         

   select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,emb.SubProcessGroupId,  spg.SubprocessName 

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId  
	
	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId 

    inner join UserMailBoxMapping umbm on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId    

    where emb.IsActive=1 and emb.CountryId=@CountryId and em.AssignedToId=@LoggedInUserId and spg.IsActive=1 

   -- and (@SelectedSubProcessId  IS NULL OR @SelectedSubProcessId=0 or emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId, emb.SubProcessGroupId,spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    union    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,emb.SubProcessGroupId,  spg.SubprocessName --,emb.SubProcessGroupId    

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId  

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId 

    inner join UserMailBoxMapping umbm on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId    

    where emb.IsActive =1 and emb.CountryId=@CountryId and em.statusid=1 and spg.IsActive=1 

    --and (@SelectedSubProcessId  IS NULL OR @SelectedSubProcessId=0 or emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId,emb.SubProcessGroupId,spg.SubprocessName  , emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)      

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      

    

   update #Final set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

   from emailbox where      

   emailbox.emailboxid=#Final.EMailBoxID and       

   emailbox.IsQCRequired=0      

         

   --select * from #Final      

    SELECT F.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,EB.EmailBoxName as EmailBox,EB.EmailBoxID,EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId

 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  AND UMBM.UserId=@LoggedInUserId  

     

   drop table #Final      

    END    

ELSE IF(@RoleId=3) --Team Lead               

    BEGIN    

        

   declare @tempUserId varchar(20)    

   if(@SelectedAssociateId IS NULL OR @SelectedAssociateId='0')    

    begin    

     set @tempUserId = @LoggedInUserId    

     select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final10      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,emb.SubProcessGroupId,  spg.SubprocessName    

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId     
	
	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId   

    inner join UserMailBoxMapping umbm on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId   

    where emb.IsActive=1 and emb.CountryId=@CountryId --and   
	
	  

    --and (@SelectedSubProcessId IS NULL OR @SelectedSubProcessId=0 OR emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId, emb.SubProcessGroupId, spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    union    

 select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId, emb.EMailBoxName, emb.CountryId

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId    

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId 

    inner join UserMailBoxMapping umbm on umbm.MailBoxId = em.EmailBoxId AND umbm.UserId=@LoggedInUserId  

    where emb.IsActive =1 and emb.CountryId=@CountryId and em.statusid=1     

    --and (@SelectedSubProcessId  IS NULL OR @SelectedSubProcessId=0 OR emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId, emb.SubProcessGroupId  , spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)      

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      

    

   update #Final10 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

   from emailbox where      

   emailbox.emailboxid=#Final10.EMailBoxID and       

   emailbox.IsQCRequired=0      

         

   --select * from #Final10      

    SELECT F.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
			EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final10 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId

 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  AND UMBM.UserId=@LoggedInUserId  

        

    drop table #Final10     

    end    

   else    

    begin    

     set @tempUserId = @SelectedAssociateId    

    

     select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final1      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,emb.SubProcessGroupId,  spg.SubprocessName     

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId   

    inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

        

    where emb.IsActive=1 and emb.CountryId=@CountryId and     

    em.AssignedToId = @tempUserId --case when @SelectedAssociateId IS NULL OR @SelectedAssociateId=0 then @LoggedInUserId    

    --else @SelectedAssociateId end    

        

   -- and (@SelectedSubProcessId IS NULL OR @SelectedSubProcessId=0 OR emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId,emb.SubProcessGroupId,  spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

       union    

       select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,emb.SubProcessGroupId,  spg.SubprocessName   

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId  

    inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

    where emb.IsActive =1 and emb.CountryId=@CountryId and em.statusid=1     

    --and (@SelectedSubProcessId  IS NULL OR @SelectedSubProcessId=0 OR emb.SubProcessGroupId=@SelectedSubProcessId)    

    group by em.StatusId,emb.SubProcessGroupId, spg.SubprocessName , emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)    

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      

    

   update #Final1 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

   from emailbox where      

   emailbox.emailboxid=#Final1.EMailBoxID and       

   emailbox.IsQCRequired=0      

         

   --select * from #Final1      

    SELECT F.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final1 F ON EB.EMAILBOXID = F.EmailBoxID and EB.SubProcessGroupId=F.SubProcessGroupId 

 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  

   

   drop table #Final1     

    end    

      

        

    END    

 ELSE IF(@RoleId in(1, 2, 5))--Super Admin/Admin/ISS User              

  BEGIN                

   IF(@SelectedAssociateId = '0')                

    BEGIN             

  select  SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' , EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

  [1] as 'Open', [2] as 'Assigned',[3] as 'Clarification Needed', [4] as 'Clarification Provided', [5]as 'Pending for QC',      

  [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

  into  #Final4      

  from      

  (    

  select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,emb.SubProcessGroupId,  spg.SubprocessName   

  from emailbox emb    

  left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

  left join emailmaster em on em.EmailBoxId=emb.EmailBoxId  
  
  left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId  

  where emb.IsActive =1 and emb.CountryId=@CountryId     

  group by em.StatusId, emb.SubProcessGroupId , spg.SubprocessName , emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId     

  )as SourceTable      

  PIVOT      

  (      

  count(caseid)      

  FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

  ) AS PivotTable      

      

  update #Final4 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

  from emailbox where      

  emailbox.emailboxid=#Final4.EMailBoxID and       

  emailbox.IsQCRequired=0      

        

  --select * from #Final4      

    SELECT F.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final4 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId 

 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  

   

  drop table #Final4     

      

    END                

   ELSE IF(@SelectedAssociateId <> '0')                

    BEGIN             

      

  select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId', EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

  [1] as 'Open', [2] as 'Assigned',[3] as 'Clarification Needed' ,[4] as 'Clarification Provided', [5]as 'Pending for QC',      

  [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

  into  #Final5      

  from      

  (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,emb.SubProcessGroupId,  spg.SubprocessName     

       from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId   

    inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

    where emb.IsActive =1 and emb.CountryId=@CountryId and em.ASSIGNEDTOID=@SelectedAssociateId --and emb.SubProcessGroupId=@SelectedSubProcessId    

    group by em.StatusId,emb.SubProcessGroupId, spg.SubprocessName , emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

  )as SourceTable      

  PIVOT      

  (      

  count(caseid)      

  FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

  ) AS PivotTable      

      

  update #Final5 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

  from emailbox where      

  emailbox.emailboxid=#Final5.EMailBoxID and       

  emailbox.IsQCRequired=0      

        

  --select * from #Final5      

    SELECT F.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final5 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId 

 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  

   

  drop table #Final5      

              

    END               

                

    -- TO GET DASHBOARD COUNT BASED ON SUBPROCESS             

                 

 ELSE IF(@SelectedAssociateId <> '0')                

    BEGIN              

    select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId,      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed',[4] as 'Clarification Provided',[5]as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

    into  #Final6      

    from      

    (    

     select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,emb.SubProcessGroupId,  spg.SubprocessName   

     from emailbox emb    

     left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

     left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    

	 	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId  

     inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

     where emb.IsActive =1 and emb.CountryId=@CountryId and em.ASSIGNEDTOID=@SelectedAssociateId    

     group by em.StatusId, emb.SubProcessGroupId, spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId    

    )as SourceTable      

    PIVOT      

    (      

    count(caseid)      

    FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

    ) AS PivotTable      

       

   update #Final6 set [Pending for QC]=-1,[QC Accepted]=-1,[QC Rejected]=-1       

   from emailbox where      

   emailbox.emailboxid=#Final6.EMailBoxID and emailbox.IsQCRequired=0      

       

   --select * from #Final6      

    SELECT F.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	EB.CountryID,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final6 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId 

 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND EB.COUNTRYID=@CountryId  

   

    drop table #Final6      

              

    END                      

   END                

END   









GO
/****** Object:  StoredProcedure [dbo].[USP_GetDashboardCount_Details_With_Process]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetDashboardCount_Details_With_Process]  --exec [USP_GetDashboardCount_Details_With_Process] 1,'254700',4,'0'   

@CountryId int,                

@LoggedInUserId varchar(50),                

@RoleId int,                

@SelectedAssociateId varchar(50)=null

--@SelectedSubProcessId varchar(50)= null               
AS                

BEGIN                 

SET NOCOUNT ON;                

                 

 IF(@RoleId=4) --Processor                

  BEGIN         

   select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',     

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,emb.SubProcessGroupId,  spg.SubprocessName ,c.Country

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId  
	
	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId and spg.IsActive=1 

    inner join UserMailBoxMapping umbm on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId    

    where emb.IsActive=1 
	-- emb.CountryId=@CountryId and 
	and em.StatusId<>6
	and em.AssignedToId=@LoggedInUserId
	  

    group by em.StatusId, emb.SubProcessGroupId,spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,c.Country   

    union    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,emb.SubProcessGroupId,  spg.SubprocessName,c.Country --,emb.SubProcessGroupId    

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId  

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId and spg.IsActive=1

    inner join UserMailBoxMapping umbm on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId    

    where emb.IsActive =1 and 
	--emb.CountryId=@CountryId and 
	em.statusid in (Select StatusId from dbo.Status where IsActive='1' and IsInitalStatus='1')

    group by em.StatusId,emb.SubProcessGroupId,spg.SubprocessName  , emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,c.Country  

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)      

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      

    

   update #Final set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

   from emailbox where      

   emailbox.emailboxid=#Final.EMailBoxID and  emailbox.IsActive=1 and      

   emailbox.IsQCRequired=0      

         
    

    SELECT F.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,EB.CountryID,F.Country,isnull([open],0) as 'Open',isnull(Assigned,0) as 'Assigned',  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 inner JOIN #Final F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId

 inner JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId  

 WHERE EB.IsActive=1 AND 
 --EB.COUNTRYID=@CountryId  AND 
 UMBM.UserId=@LoggedInUserId  

     --select * from #Final

   drop table #Final      

    END    

ELSE IF(@RoleId=3) --Team Lead               

    BEGIN    

        

   declare @tempUserId varchar(20)    

   if(@SelectedAssociateId IS NULL OR @SelectedAssociateId='0')    

    begin    

     set @tempUserId = @LoggedInUserId    

     select [SubprocessName] as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId',EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final10      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,  spg.SubprocessName ,emb.SubProcessGroupId ,c.Country   

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId     
	
	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId   

    inner join UserMailBoxMapping umbm on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId   

    where emb.IsActive=1 --and emb.CountryId=@CountryId     

    group by em.StatusId, emb.SubProcessGroupId, spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,c.Country    

    union    

 select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId, spg.SubprocessName,emb.SubProcessGroupId,c.Country

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId    

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId 

    inner join UserMailBoxMapping umbm on umbm.MailBoxId = em.EmailBoxId AND umbm.UserId=@LoggedInUserId 

    where emb.IsActive =1 
	--and emb.CountryId=@CountryId 
	and em.statusid in (Select StatusId from dbo.Status where IsActive='1' and IsInitalStatus='1')

    group by em.StatusId, emb.SubProcessGroupId  , spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,c.Country   

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)      

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      


--    drop table #Final10

   update #Final10 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

   from emailbox where      

   emailbox.emailboxid=#Final10.EMailBoxID and       

   emailbox.IsQCRequired=0      

         

    

    SELECT F.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,
			EB.CountryID,F.Country ,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final10 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId

 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 AND 
 --EB.COUNTRYID=@CountryId  AND 
 UMBM.UserId=@LoggedInUserId  

        

    drop table #Final10     

    end    

   else    

    begin    

     set @tempUserId = @SelectedAssociateId    

    

     select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final1      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,emb.SubProcessGroupId,  spg.SubprocessName ,c.Country    

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId   

    inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

        

    where emb.IsActive=1 and 
	--emb.CountryId=@CountryId and     

    em.AssignedToId = @tempUserId  

    group by em.StatusId,emb.SubProcessGroupId,  spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,c.Country    

       union    

       select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,emb.SubProcessGroupId,  spg.SubprocessName   ,c.Country

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId  

    inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

    where emb.IsActive =1 and 
	--emb.CountryId=@CountryId and 
	em.statusid in (Select StatusId from dbo.Status where IsActive='1' and IsInitalStatus='1')

    group by em.StatusId,emb.SubProcessGroupId, spg.SubprocessName , emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,c.Country  

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)    

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      



   update #Final1 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

   from emailbox where      

   emailbox.emailboxid=#Final1.EMailBoxID and       

   emailbox.IsQCRequired=0      

            

    SELECT SG.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,
	EB.CountryID,C.Country,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final1 F ON EB.EMAILBOXID = F.EmailBoxID and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId
 LEFT join SubProcessGroups SG ON SG.SubProcessGroupId=EB.SubProcessGroupId
 LEFT join Country C ON C.CountryID= EB.CountryID
 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 --AND EB.COUNTRYID=@CountryId  

   

   drop table #Final1     

    end    

      

        

    END    

 ELSE IF(@RoleId in(1, 2, 5))--Super Admin/Admin/ISS User              

  BEGIN                

   IF(@SelectedAssociateId = '0')                

    BEGIN             

  select  SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' , EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',     

  [1] as 'Open', [2] as 'Assigned',[3] as 'Clarification Needed', [4] as 'Clarification Provided', [5]as 'Pending for QC',      

  [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

  into  #Final4      

  from      

  (    

  select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,emb.SubProcessGroupId,  spg.SubprocessName  ,c.Country 

  from emailbox emb    

  left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

  left join emailmaster em on em.EmailBoxId=emb.EmailBoxId  
  
  left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId  

  where emb.IsActive =1 --and emb.CountryId=@CountryId     

  group by em.StatusId, emb.SubProcessGroupId , spg.SubprocessName , emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,c.Country   

  )as SourceTable      

  PIVOT      

  (      

  count(caseid)      

  FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

  ) AS PivotTable      

      

  update #Final4 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

  from emailbox where      

  emailbox.emailboxid=#Final4.EMailBoxID and       

  emailbox.IsQCRequired=0      

        

  --select * from #Final4      

    SELECT F.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	EB.CountryID,F.Country,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final4 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId

 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 --AND EB.COUNTRYID=@CountryId  

   

  drop table #Final4     

      

    END                

   ELSE IF(@SelectedAssociateId <> '0')                

    BEGIN             

      

  select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId', EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',         

  [1] as 'Open', [2] as 'Assigned',[3] as 'Clarification Needed' ,[4] as 'Clarification Provided', [5]as 'Pending for QC',      

  [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

  into  #Final5      

  from      

  (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,emb.SubProcessGroupId,  spg.SubprocessName,c.Country    

       from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId   

    inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

    where emb.IsActive =1 and --emb.CountryId=@CountryId and 
	em.ASSIGNEDTOID=@SelectedAssociateId    

    group by em.StatusId,emb.SubProcessGroupId, spg.SubprocessName , emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,c.Country  

  )as SourceTable      

  PIVOT      

  (      

  count(caseid)      

  FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

  ) AS PivotTable      

      

  update #Final5 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

  from emailbox where      

  emailbox.emailboxid=#Final5.EMailBoxID and       

  emailbox.IsQCRequired=0      

        

  --select * from #Final5      

    SELECT SG.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	EB.CountryID,C.Country,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final5 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId
  LEFT join SubProcessGroups SG ON SG.SubProcessGroupId=EB.SubProcessGroupId
 LEFT join Country C ON C.CountryID= EB.CountryID
 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 --AND EB.COUNTRYID=@CountryId  

   

  drop table #Final5      

              

    END               

                

    -- TO GET DASHBOARD COUNT BASED ON SUBPROCESS             

                 

 ELSE IF(@SelectedAssociateId <> '0')                

    BEGIN              

    select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',         

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed',[4] as 'Clarification Provided',[5]as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

    into  #Final6      

    from      

    (    

     select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,emb.SubProcessGroupId,  spg.SubprocessName   ,c.Country

     from emailbox emb    

     left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

     left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    

	 	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId  

     inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

     where emb.IsActive =1 and --emb.CountryId=@CountryId and 
	 em.ASSIGNEDTOID=@SelectedAssociateId    

     group by em.StatusId, emb.SubProcessGroupId, spg.SubprocessName ,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,c.Country   

    )as SourceTable      

    PIVOT      

    (      

    count(caseid)      

    FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

    ) AS PivotTable      

       

   update #Final6 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

   from emailbox where      

   emailbox.emailboxid=#Final6.EMailBoxID and emailbox.IsQCRequired=0      

       

   --select * from #Final6      

    SELECT SG.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	EB.CountryID,C.Country,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 FROM EMAILBOX EB  

 LEFT JOIN #Final6 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId
  LEFT join SubProcessGroups SG ON SG.SubProcessGroupId=EB.SubProcessGroupId
 LEFT join Country C ON C.CountryID= EB.CountryID
 LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 WHERE EB.IsActive=1 --AND EB.COUNTRYID=@CountryId  

   

    drop table #Final6      

              

    END                      

   END                

END   









GO
/****** Object:  StoredProcedure [dbo].[USP_GetDashboardCount_Details_With_Process_Classification]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetDashboardCount_Details_With_Process_Classification]  -- exec [USP_GetDashboardCount_Details_With_Process_Classification] 1,'195174',3,'0'   

@CountryId int,                

@LoggedInUserId varchar(50),                

@RoleId int,                

@SelectedAssociateId varchar(50)=null

--@SelectedSubProcessId varchar(50)= null               
AS                

BEGIN                 

SET NOCOUNT ON;                    
 
 IF(@RoleId=4) --Processor                

  BEGIN         

   select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',classificationID as 'classificationID',ClassifiactionDescription as 'ClassificationName',     

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,emb.SubProcessGroupId,  spg.SubprocessName ,c.Country,IC.classificationID,IC.ClassifiactionDescription

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId  
    
    full outer join InboundClassification IC on  em.ClassificationID=IC.ClassificationID and IC.IsActive=1
	
	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId and spg.IsActive=1 

    inner join UserMailBoxMapping umbm on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId    

    where emb.IsActive=1 
	-- emb.CountryId=@CountryId and 
	and em.StatusId<>6
	and em.AssignedToId=@LoggedInUserId
	  

    group by em.StatusId, emb.SubProcessGroupId,spg.SubprocessName ,IC.ClassificationID,IC.ClassifiactionDescription,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,c.Country,IC.ClassifiactionDescription,umbm.UserId

    union    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,emb.SubProcessGroupId,  spg.SubprocessName,c.Country,IC.classificationID,IC.ClassifiactionDescription --,emb.SubProcessGroupId    

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId  
    
    left join InboundClassification IC on  em.ClassificationID=IC.ClassificationID and IC.IsActive=1

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId and spg.IsActive=1

    inner join UserMailBoxMapping umbm on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId    

    where emb.IsActive =1 and 
	--emb.CountryId=@CountryId and 
	em.statusid=1   

    group by em.StatusId,emb.SubProcessGroupId,spg.SubprocessName ,IC.ClassificationID,IC.ClassifiactionDescription , emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,c.Country,umbm.UserId 

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)      

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      

    

   update #Final set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

   from emailbox where      

   emailbox.emailboxid=#Final.EMailBoxID and  emailbox.IsActive=1 and      

   emailbox.IsQCRequired=0      

   
  ---classification changes  
   select c.Country,spg.SubProcessName,EB.EmailBoxId,EB.EmailBoxName,EB.IsActive,EB.SubProcessGroupId,EB.CountryID,IC.ClassificationId,IC.ClassifiactionDescription into TempclassificationTable from EmailBox EB cross join InboundClassification IC 
   left join country c on EB.CountryId=c.CountryId and c.IsActive=1     
   left join SubProcessGroups  spg on spg.SubProcessGroupId=EB.SubProcessGroupId and spg.IsActive=1
   where EmailBoxId in(Select EmailBoxId from #Final) and IC.IsActive=1;
   
--select * from TempclassificationTable 
 
    SELECT EB.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',
    EB.classificationID as 'classificationID',EB.ClassifiactionDescription as 'ClassificationName',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,EB.CountryID,EB.Country,isnull([open],0) as 'Open',isnull(Assigned,0) as 'Assigned',  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 from #Final F
 
 right outer join TempclassificationTable EB on EB.EmailBoxId=F.EmailBoxId and EB.ClassificationId=F.classificationID and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId 

 inner JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId  

 WHERE EB.IsActive=1 AND 
 --EB.COUNTRYID=@CountryId  AND 
 UMBM.UserId=@LoggedInUserId  

-- select * from #Final
 
  
   drop table #Final      
   
   drop table TempclassificationTable
   
    END    

ELSE IF(@RoleId=3) --Team Lead               

    BEGIN            

   declare @tempUserId varchar(20)    

   if(@SelectedAssociateId IS NULL OR @SelectedAssociateId='0')    

    begin    

     set @tempUserId = @LoggedInUserId    

     select [SubprocessName] as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId',EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',classificationID as 'classificationID',ClassifiactionDescription as 'ClassificationName',

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final10      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,  spg.SubprocessName ,emb.SubProcessGroupId ,c.Country,IC.classificationID,IC.ClassifiactionDescription

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId     
    
    left join InboundClassification IC on  em.ClassificationID=IC.ClassificationID and IC.IsActive=1
	
	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId   

    inner join UserMailBoxMapping umbm on emb.EmailBoxId = umbm.MailBoxId AND umbm.UserId=@LoggedInUserId   

    where emb.IsActive=1 --and emb.CountryId=@CountryId     

    group by em.StatusId, emb.SubProcessGroupId, spg.SubprocessName ,IC.ClassificationID,IC.ClassifiactionDescription,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,c.Country    

    union    

 select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId, spg.SubprocessName,emb.SubProcessGroupId,c.Country,IC.classificationID,IC.ClassifiactionDescription

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on emb.EmailBoxId=em.EmailBoxId    
    
    left join InboundClassification IC on  em.ClassificationID=IC.ClassificationID and IC.IsActive=1

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId 

    inner join UserMailBoxMapping umbm on umbm.MailBoxId = em.EmailBoxId AND umbm.UserId=@LoggedInUserId 

    where emb.IsActive =1 
	--and emb.CountryId=@CountryId 
	and em.statusid=1      

    group by em.StatusId, emb.SubProcessGroupId  , spg.SubprocessName ,IC.ClassificationID,IC.ClassifiactionDescription,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,c.Country   

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)      

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      


--    drop table #Final10

   update #Final10 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

   from emailbox where      

   emailbox.emailboxid=#Final10.EMailBoxID and       

   emailbox.IsQCRequired=0      

 
 ---classification changes  
   select c.Country,spg.SubProcessName,EB.EmailBoxId,EB.EmailBoxName,EB.IsActive,EB.SubProcessGroupId,EB.CountryID,IC.ClassificationId,IC.ClassifiactionDescription into TempclassificationTable from EmailBox EB cross join InboundClassification IC 
   left join country c on EB.CountryId=c.CountryId and c.IsActive=1     
   left join SubProcessGroups  spg on spg.SubProcessGroupId=EB.SubProcessGroupId and spg.IsActive=1
   where EmailBoxId in(Select EmailBoxId from #Final10) and IC.IsActive=1;
   
--select * from TempclassificationTable 
 
    SELECT EB.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',
    EB.ClassificationId as 'classificationID',EB.ClassifiactionDescription as 'ClassificationName',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,EB.CountryID,EB.Country,isnull([open],0) as 'Open',isnull(Assigned,0) as 'Assigned',  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 from #Final10 F
 
 right outer join TempclassificationTable EB on EB.EmailBoxId=F.EmailBoxId and EB.ClassificationId=F.classificationID and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId 

 inner JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId  

 WHERE EB.IsActive=1 AND 
 --EB.COUNTRYID=@CountryId  AND 
 UMBM.UserId=@LoggedInUserId  

-- select * from #Final10
 
  
   drop table #Final10      
   
   drop table TempclassificationTable

    

 --   SELECT F.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',F.ClassificationName as 'ClassificationName',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,
	--		EB.CountryID,F.Country ,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 --isnull([Clarification Needed],0) as [Clarification Needed],  

 --isnull([Clarification Provided],0) as [Clarification Provided],  

 --isnull([Pending for QC],0) as [Pending for QC],  

 --isnull([QC Accepted],0) as [QC Accepted],  

 --isnull([QC Rejected],0) as [QC Rejected],  

 --isnull([Completed],0) as [Completed]  

 --FROM EMAILBOX EB  

 --LEFT JOIN #Final10 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId

 --LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 --WHERE EB.IsActive=1 AND 
 ----EB.COUNTRYID=@CountryId  AND 
 --UMBM.UserId=@LoggedInUserId  

        

 --   drop table #Final10     

    end    

   else    

    begin    

     set @tempUserId = @SelectedAssociateId    

    

     select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',classificationID as 'classificationID',ClassifiactionDescription as 'ClassificationName',      

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed', [4] as 'Clarification Provided', [5] as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'    

   into  #Final1      

   from      

    (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,emb.SubProcessGroupId,  spg.SubprocessName ,c.Country,IC.classificationID,IC.ClassifiactionDescription    

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    
    
    left join InboundClassification IC on  em.ClassificationID=IC.ClassificationID and IC.IsActive=1

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId   

    inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId            

    where emb.IsActive=1 and 
	--emb.CountryId=@CountryId and     

    em.AssignedToId = @tempUserId  

    group by em.StatusId,emb.SubProcessGroupId,  spg.SubprocessName ,IC.ClassificationID,IC.ClassifiactionDescription,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,c.Country    

       union    

       select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,emb.SubProcessGroupId,  spg.SubprocessName   ,c.Country,IC.classificationID,IC.ClassifiactionDescription

    from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    
    
    left join InboundClassification IC on  em.ClassificationID=IC.ClassificationID and IC.IsActive=1

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId  

    inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

    where emb.IsActive =1 and 
	--emb.CountryId=@CountryId and 
	em.statusid=1  

    group by em.StatusId,emb.SubProcessGroupId, spg.SubprocessName ,IC.ClassificationID,IC.ClassifiactionDescription, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,c.Country  

     )as SourceTable      

    PIVOT      

   (      

   count(caseid)    

   FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

   ) AS PivotTable      



   update #Final1 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

   from emailbox where      

   emailbox.emailboxid=#Final1.EMailBoxID and       

   emailbox.IsQCRequired=0      

     
      ---classification changes  
   select c.Country,spg.SubProcessName,EB.EmailBoxId,EB.EmailBoxName,EB.IsActive,EB.SubProcessGroupId,EB.CountryID,IC.ClassificationId,IC.ClassifiactionDescription into TempclassificationTable from EmailBox EB cross join InboundClassification IC 
   left join country c on EB.CountryId=c.CountryId and c.IsActive=1     
   left join SubProcessGroups  spg on spg.SubProcessGroupId=EB.SubProcessGroupId and spg.IsActive=1
   where EmailBoxId in(Select EmailBoxId from #Final1) and IC.IsActive=1;
   
--select * from TempclassificationTable 
 
    SELECT EB.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',
    EB.classificationID as 'classificationID',EB.ClassifiactionDescription as 'ClassificationName',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,EB.CountryID,EB.Country,isnull([open],0) as 'Open',isnull(Assigned,0) as 'Assigned',  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 from #Final1 F
 
 right outer join TempclassificationTable EB on EB.EmailBoxId=F.EmailBoxId and EB.ClassificationId=F.classificationID and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId 

 inner JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId  

 WHERE EB.IsActive=1 AND 
 --EB.COUNTRYID=@CountryId  AND 
 UMBM.UserId=@LoggedInUserId  

-- select * from ##Final1
 
  
   drop table #Final1      
   
   drop table TempclassificationTable

     
     
            

 --   SELECT SG.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',F.ClassificationName as 'ClassificationName',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,
	--EB.CountryID,C.Country,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 --isnull([Clarification Needed],0) as [Clarification Needed],  

 --isnull([Clarification Provided],0) as [Clarification Provided],  

 --isnull([Pending for QC],0) as [Pending for QC],  

 --isnull([QC Accepted],0) as [QC Accepted],  

 --isnull([QC Rejected],0) as [QC Rejected],  

 --isnull([Completed],0) as [Completed]  

 --FROM EMAILBOX EB  

 --LEFT JOIN #Final1 F ON EB.EMAILBOXID = F.EmailBoxID and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId
 --LEFT join SubProcessGroups SG ON SG.SubProcessGroupId=EB.SubProcessGroupId
 --LEFT join Country C ON C.CountryID= EB.CountryID
 --LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 --WHERE EB.IsActive=1 --AND EB.COUNTRYID=@CountryId  

   

 --  drop table #Final1     

    end    

      

        

    END    

 ELSE IF(@RoleId in(1, 2, 5))--Super Admin/Admin/ISS User              

  BEGIN                

   IF(@SelectedAssociateId = '0')                

    BEGIN             

  select  SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' , EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',ClassifiactionDescription as 'ClassificationName',ClassificationID As 'ClassificationID',

  [1] as 'Open', [2] as 'Assigned',[3] as 'Clarification Needed', [4] as 'Clarification Provided', [5]as 'Pending for QC',      

  [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

  into  #Final4      

  from      

  (    

  select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId,emb.SubProcessGroupId,  spg.SubprocessName  ,c.Country ,IC.ClassifiactionDescription,em.ClassificationID

  from emailbox emb    

  left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

  left join emailmaster em on em.EmailBoxId=emb.EmailBoxId  
  
  left join InboundClassification IC on  em.ClassificationID=IC.ClassificationID and IC.IsActive=1
  
  left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId  

  where emb.IsActive =1 --and emb.CountryId=@CountryId     

  group by em.StatusId, emb.SubProcessGroupId , spg.SubprocessName ,em.ClassificationID,IC.ClassifiactionDescription, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,c.Country   

  )as SourceTable      

  PIVOT      

  (      

  count(caseid)      

  FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

  ) AS PivotTable      

      

  update #Final4 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

  from emailbox where      

  emailbox.emailboxid=#Final4.EMailBoxID and       

  emailbox.IsQCRequired=0      

 ---classification changes  
   select c.Country,spg.SubProcessName,EB.EmailBoxId,EB.EmailBoxName,EB.IsActive,EB.SubProcessGroupId,EB.CountryID,IC.ClassificationId,IC.ClassifiactionDescription into TempclassificationTable from EmailBox EB cross join InboundClassification IC 
   left join country c on EB.CountryId=c.CountryId and c.IsActive=1     
   left join SubProcessGroups  spg on spg.SubProcessGroupId=EB.SubProcessGroupId and spg.IsActive=1
   where EmailBoxId in(Select EmailBoxId from #Final4) and IC.IsActive=1;
   
--select * from TempclassificationTable 
 
    SELECT EB.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',
    EB.classificationID as 'classificationID',EB.ClassifiactionDescription as 'ClassificationName',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,EB.CountryID,EB.Country,isnull([open],0) as 'Open',isnull(Assigned,0) as 'Assigned',  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 from #Final4 F
 
 right outer join TempclassificationTable EB on EB.EmailBoxId=F.EmailBoxId and EB.ClassificationId=F.classificationID and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId 

 inner JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId  

 WHERE EB.IsActive=1 AND 
 --EB.COUNTRYID=@CountryId  AND 
 UMBM.UserId=@LoggedInUserId  

-- select * from #Final4
 
  
   drop table #Final4      
   
   drop table TempclassificationTable
   
         



 --   SELECT F.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,F.ClassificationName as ClassificationName,F.ClassificationID,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	--EB.CountryID,F.Country,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 --isnull([Clarification Needed],0) as [Clarification Needed],  

 --isnull([Clarification Provided],0) as [Clarification Provided],  

 --isnull([Pending for QC],0) as [Pending for QC],  

 --isnull([QC Accepted],0) as [QC Accepted],  

 --isnull([QC Rejected],0) as [QC Rejected],  

 --isnull([Completed],0) as [Completed]  

 --FROM EMAILBOX EB  

 --LEFT JOIN #Final4 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId

 --LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 --WHERE EB.IsActive=1 --AND EB.COUNTRYID=@CountryId  

   

 -- drop table #Final4     

      

    END                

   ELSE IF(@SelectedAssociateId <> '0')                

    BEGIN             

      

  select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId', EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',classificationID as 'classificationID',ClassifiactionDescription as 'ClassificationName',         

  [1] as 'Open', [2] as 'Assigned',[3] as 'Clarification Needed' ,[4] as 'Clarification Provided', [5]as 'Pending for QC',      

  [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

  into  #Final5      

  from      

  (    

    select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,emb.SubProcessGroupId,  spg.SubprocessName,c.Country,IC.classificationID,IC.ClassifiactionDescription

       from emailbox emb    

    left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

    left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    
    
    left join InboundClassification IC on  em.ClassificationID=IC.ClassificationID and IC.IsActive=1

	left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId   

    inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

    where emb.IsActive =1 and --emb.CountryId=@CountryId and 
	em.ASSIGNEDTOID=@SelectedAssociateId    

    group by em.StatusId,emb.SubProcessGroupId, spg.SubprocessName ,IC.ClassificationID,IC.ClassifiactionDescription, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,c.Country  

  )as SourceTable      

  PIVOT      

  (      

  count(caseid)      

  FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

  ) AS PivotTable      

      

  update #Final5 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

  from emailbox where      

  emailbox.emailboxid=#Final5.EMailBoxID and       

  emailbox.IsQCRequired=0      

---classification changes  
   select c.Country,spg.SubProcessName,EB.EmailBoxId,EB.EmailBoxName,EB.IsActive,EB.SubProcessGroupId,EB.CountryID,IC.ClassificationId,IC.ClassifiactionDescription into TempclassificationTable from EmailBox EB cross join InboundClassification IC 
   left join country c on EB.CountryId=c.CountryId and c.IsActive=1     
   left join SubProcessGroups  spg on spg.SubProcessGroupId=EB.SubProcessGroupId and spg.IsActive=1
   where EmailBoxId in(Select EmailBoxId from #Final5) and IC.IsActive=1;
   
--select * from TempclassificationTable 
 
    SELECT EB.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',
    EB.classificationID as 'classificationID',EB.ClassifiactionDescription as 'ClassificationName',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,EB.CountryID,EB.Country,isnull([open],0) as 'Open',isnull(Assigned,0) as 'Assigned',  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 from #Final5 F
 
 right outer join TempclassificationTable EB on EB.EmailBoxId=F.EmailBoxId and EB.ClassificationId=F.classificationID and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId 

 inner JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId  

 WHERE EB.IsActive=1 AND 
 --EB.COUNTRYID=@CountryId  AND 
 UMBM.UserId=@LoggedInUserId  

-- select * from #Final5
 
  
   drop table #Final5      
   
   drop table TempclassificationTable


 --   SELECT SG.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,F.ClassificationName as ClassificationName,EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	--EB.CountryID,C.Country,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 --isnull([Clarification Needed],0) as [Clarification Needed],  

 --isnull([Clarification Provided],0) as [Clarification Provided],  

 --isnull([Pending for QC],0) as [Pending for QC],  

 --isnull([QC Accepted],0) as [QC Accepted],  

 --isnull([QC Rejected],0) as [QC Rejected],  

 --isnull([Completed],0) as [Completed]  

 --FROM EMAILBOX EB  

 --LEFT JOIN #Final5 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId
 -- LEFT join SubProcessGroups SG ON SG.SubProcessGroupId=EB.SubProcessGroupId
 --LEFT join Country C ON C.CountryID= EB.CountryID
 --LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 --WHERE EB.IsActive=1 --AND EB.COUNTRYID=@CountryId  

   

 -- drop table #Final5      

              

    END               

                

    -- TO GET DASHBOARD COUNT BASED ON SUBPROCESS             

                 

 ELSE IF(@SelectedAssociateId <> '0')                

    BEGIN              

    select SubprocessName as 'SubProcessName',SubProcessGroupId as 'SubProcessGroupId' ,EmailBoxName as 'EmailBox', EmailBoxID as 'EMailBoxID', CountryId as 'CountryId', Country   as 'Country',classificationID as 'classificationID',ClassifiactionDescription as 'ClassificationName',

    [1] as 'Open', [2] as 'Assigned', [3] as 'Clarification Needed',[4] as 'Clarification Provided',[5]as 'Pending for QC',      

    [7] as 'QC Accepted',[8] as 'QC Rejected',[10] as 'Completed'      

    into  #Final6      

    from      

    (    

     select em.StatusId, emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId  ,emb.SubProcessGroupId,  spg.SubprocessName   ,c.Country,IC.classificationID,IC.ClassifiactionDescription

     from emailbox emb    

     left join country c on emb.CountryId=c.CountryId and c.IsActive=1     

     left join emailmaster em on em.EmailBoxId=emb.EmailBoxId    
     
     left join InboundClassification IC on  em.ClassificationID=IC.ClassificationID and IC.IsActive=1

	 left join SubProcessGroups  spg on spg.SubProcessGroupId=emb.SubProcessGroupId  

     inner join UserMailBoxMapping umbm on em.EmailBoxId = umbm.MailBoxId    

     where emb.IsActive =1 and --emb.CountryId=@CountryId and 
	 em.ASSIGNEDTOID=@SelectedAssociateId    

     group by em.StatusId, emb.SubProcessGroupId, spg.SubprocessName ,IC.ClassificationID,IC.ClassifiactionDescription,emb.EmailBoxId, em.caseid, emb.EMailBoxName, emb.CountryId ,c.Country   

    )as SourceTable      

    PIVOT      

    (      

    count(caseid)      

    FOR statusid IN ([1],[2],[3],[4],[5],[7],[8],[10])      

    ) AS PivotTable      

       

   update #Final6 set [Pending for QC]=0,[QC Accepted]=0,[QC Rejected]=0       

   from emailbox where      

   emailbox.emailboxid=#Final6.EMailBoxID and emailbox.IsQCRequired=0      

       

   ---classification changes  
   select c.Country,spg.SubProcessName,EB.EmailBoxId,EB.EmailBoxName,EB.IsActive,EB.SubProcessGroupId,EB.CountryID,IC.ClassificationId,IC.ClassifiactionDescription into TempclassificationTable from EmailBox EB cross join InboundClassification IC 
   left join country c on EB.CountryId=c.CountryId and c.IsActive=1     
   left join SubProcessGroups  spg on spg.SubProcessGroupId=EB.SubProcessGroupId and spg.IsActive=1
   where EmailBoxId in(Select EmailBoxId from #Final6) and IC.IsActive=1;
   
--select * from TempclassificationTable 
 
    SELECT EB.SubprocessName as 'SubprocessName',EB.SubProcessGroupId as 'SubProcessGroupId',
    EB.classificationID as 'classificationID',EB.ClassifiactionDescription as 'ClassificationName',EB.EmailBoxName as 'EmailBox',EB.EmailBoxID,EB.CountryID,EB.Country,isnull([open],0) as 'Open',isnull(Assigned,0) as 'Assigned',  

 isnull([Clarification Needed],0) as [Clarification Needed],  

 isnull([Clarification Provided],0) as [Clarification Provided],  

 isnull([Pending for QC],0) as [Pending for QC],  

 isnull([QC Accepted],0) as [QC Accepted],  

 isnull([QC Rejected],0) as [QC Rejected],  

 isnull([Completed],0) as [Completed]  

 from #Final6 F
 
 right outer join TempclassificationTable EB on EB.EmailBoxId=F.EmailBoxId and EB.ClassificationId=F.classificationID and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId 

 inner JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId  

 WHERE EB.IsActive=1 AND 
 --EB.COUNTRYID=@CountryId  AND 
 UMBM.UserId=@LoggedInUserId  

-- select * from #Final6
 
  
   drop table #Final6      
   
   drop table TempclassificationTable
   
 

 --   SELECT SG.SubprocessName as SubprocessName,EB.SubProcessGroupId as SubProcessGroupId,F.ClassificationName as 'ClassificationName',EB.EmailBoxName as EmailBox,EB.EmailBoxID,
	--EB.CountryID,C.Country,isnull([open],0) as [Open],isnull(Assigned,0) as Assigned,  

 --isnull([Clarification Needed],0) as [Clarification Needed],  

 --isnull([Clarification Provided],0) as [Clarification Provided],  

 --isnull([Pending for QC],0) as [Pending for QC],  

 --isnull([QC Accepted],0) as [QC Accepted],  

 --isnull([QC Rejected],0) as [QC Rejected],  

 --isnull([Completed],0) as [Completed]  

 --FROM EMAILBOX EB  

 --LEFT JOIN #Final6 F ON EB.EMAILBOXID = F.EmailBoxID  and EB.SubProcessGroupId=F.SubProcessGroupId and EB.CountryID=F.CountryId
 -- LEFT join SubProcessGroups SG ON SG.SubProcessGroupId=EB.SubProcessGroupId
 --LEFT join Country C ON C.CountryID= EB.CountryID
 --LEFT JOIN UserMailBoxMapping UMBM ON EB.EMAILBOXID = UMBM.MailBoxId AND UMBM.UserId=@LoggedInUserId   

 --WHERE EB.IsActive=1 --AND EB.COUNTRYID=@CountryId  

   

 --   drop table #Final6      

              

    END                      

   END   
           
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetDefaultListValues]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [USP_GetDefaultListValues] 107,0   
CREATE proc [dbo].[USP_GetDefaultListValues]            
@FieldMasterID BigInt,            
@DynamicDropdownId BigInt            
As            
Begin       
 BEGIN TRAN TXN_SELECT      
    BEGIN TRY      
if @DynamicDropdownId = 0            
Begin            
  
  Select      CF.FieldMasterId as FieldMasterId,            
              CF.FieldName as FieldName,            
               DDV.DefaultListValueId as DynamicDropdownId,                           
			   DDV.OptionValue as OptionValue,            
              DDV.OptionText as OptionText,            
			   case when  DDV.Active=0 then 'No' else 'Yes' end Active,
               DDV.ModifiedDate as ModifiedDate,          
             UM.FirstName +' '+ UM.LastName as ModifiedBy 
               from  Tbl_FieldConfiguration CF             
               inner join Tbl_DefaultListValues DDV on CF.FieldMasterId = CF.FieldMasterId
			left outer join  Usermaster UM on UM.UserId=DDV.modifiedby    
              where  DDV.FieldMasterId = @FieldMasterID            
               and CF.FieldMasterId = @FieldMasterID            
  End            







              







 Else if @DynamicDropdownId <> 0            







Begin            







            







  Select      CF.FieldMasterId as FieldMasterId,            







              CF.FieldName as FieldName,            







               DDV.DefaultListValueId as DynamicDropdownId,                           







               DDV.OptionValue as OptionValue,            







               DDV.OptionText as OptionText,            





			   case when  DDV.Active=0 then 'No' else 'Yes' end Active,

                   







               DDV.ModifiedDate as ModifiedDate,          







             UM.FirstName +' '+ UM.LastName as ModifiedBy        







               from  Tbl_FieldConfiguration CF             







               inner join Tbl_DefaultListValues DDV on CF.FieldMasterId = CF.FieldMasterId



			   



			left outer join  Usermaster UM on UM.UserId=DDV.modifiedby                      







               where DDV.FieldMasterId = @FieldMasterID            







               and CF.FieldMasterId = @FieldMasterID and DDV.DefaultListValueId = @DynamicDropdownId            







  End             







  END TRY      







                        BEGIN CATCH      







                              GOTO HandleError1      







                        END CATCH      







                        IF @@TRANCOUNT > 0 COMMIT TRAN TXN_SELECT      







                        RETURN 1      







                  HandleError1:      







                        IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_SELECT      







                        RAISERROR('Error Selecting table Tbl_FieldConfiguration', 16, 1)      







                        RETURN -1            







              







End








GO
/****** Object:  StoredProcedure [dbo].[USP_GetDistinctEmailIDsSent]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
---Created by Varma to get auto pop list of user email IDs used in a Mailbox 

--exec USP_GetDistinctEmailIDsSent 'b',1

CREATE procedure [dbo].[USP_GetDistinctEmailIDsSent]
(
	@prefixtext varchar(max),

	@emailboxId bigint
)

as 

begin 

declare @emaiIDArray varchar(max)
declare @emailCcIDArray varchar(max)

set  @emaiIDArray= (Select distinct
(

	Select LOWER(es.emailTo) + ';' AS [text()]

	From emailsent es 

	inner join emailmaster em on es.CaseId=em.CaseId 

	inner join EMailBox eb on em.EMailBoxId=eb.EMailBoxId 

	Where em.CaseId = es.CaseId and em.EMailBoxId=@emailboxId and es.EMailTo like '%'+@prefixtext+'%'

	ORDER BY 1

	For XML PATH ('')

)

FROM emailsent)

set  @emailCcIDArray= (Select distinct

(



       Select Lower(es.EMailTo) + ';' AS [text()]



       From emailsent es 



       inner join emailmaster em on es.CaseId=em.CaseId 



       inner join EMailBox eb on em.EMailBoxId=eb.EMailBoxId 



       Where em.CaseId = es.CaseId and em.EMailBoxId=@emailboxId and es.EMailTo like '%'+@prefixtext+'%'



       ORDER BY 1



       For XML PATH ('')



)

FROM emailsent)

--print @emaiIDArray



Select DISTINCT * from [dbo].[Split](@emaiIDArray,';') where items like '%'+@prefixtext+'%'

Select DISTINCT * from [dbo].[Split](@emailCcIDArray,';') where items like '%'+@prefixtext+'%'

--Create FUNCTION [dbo].[Split](@String varchar(8000), @Delimiter char(1))        

--returns @temptable TABLE (items varchar(8000))        

--as        

--begin        

--    declare @idx int        

--    declare @slice varchar(8000)        

--    select @idx = 1        

--        if len(@String)<1 or @String is null  return        

--    while @idx!= 0        

--    begin        

--        set @idx = charindex(@Delimiter,@String)        

--        if @idx!=0        

--            set @slice = left(@String,@idx - 1)        

--        else        

--            set @slice = @String        

--        if(len(@slice)>0)   

--            insert into @temptable(Items) values(@slice)        

--        set @String = right(@String,len(@String) - @idx)        

--        if len(@String) = 0 break        

--    end    

--return        

--end



end


GO
/****** Object:  StoredProcedure [dbo].[USP_GetDynamicControlstoDataEntry]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*                              
Author Name                                 

Date written                                                 

Description                                 

Revision History:                              

Change #          Modified By       Reason                                     Date                              

*/                              
-- select * from Tbl_CaseTransaction                          
-- EXEC [USP_GetDynamicControlstoDataEntry] 11251                         
CREATE PROCEDURE [dbo].[USP_GetDynamicControlstoDataEntry]                              

(
@CaseID BigInt

)

AS
BEGIN                              

SET NOCOUNT ON;                              

	Declare @MailboxID int 

	Declare @CountryID int
	
	select @CountryID=c.CountryId,@MailboxID=eb.EMailBoxId from EmailMaster em 
	
	join EMailBox eb on em.EMailBoxId = eb.EMailBoxId 
	join Country C on C.CountryId = eb.CountryId

	where CaseId=@CaseID
	
	if  exists (select * from [Tbl_ClientTransaction] where CaseID=@CaseID)

		begin
	
		select FieldMasterID, value, FieldType, DynamicFieldMaster_ID, 
		FieldName,  TextLength,  FieldDataType,  ValidationTypeID,ValidationType,FieldAliasName,FieldPrivilegeID,FieldPrivilegeName
		from (

		---Dynamic Controls 	
			---A.Controls with Values
			---Unoin 
			---B.Controls without Values
		
			---A.Controls with Values 
			(select FC.FieldMasterId as FieldMasterID,  CT.FieldValue as value, FT.FieldType, FT.FieldAbbrv + 'DF_'+ REPLACE(FC.FieldName, ' ', '__') as DynamicFieldMaster_ID, 
			 FC.FieldName,  FC.TextLength,  FDT.FieldDataType as FieldDataType,  FC.ValidationTypeId as ValidationTypeID,VT.ValidationType,FC.FieldAliasName, FC.FieldPrivilegeID,FP.FieldPrivilegeName

			 from Tbl_FieldConfiguration FC 
			 join Tbl_Master_FieldType FT on FC.FieldTypeId = FT.FieldTypeId
			 join Tbl_Master_FieldDataType FDT on FDT.FieldDataTypeId = FC.FieldDataTypeID
			 join Tbl_Master_ValidationType VT on VT.ValidationTypeId = FC.ValidationTypeID
			 			  join Tbl_Master_FieldPrivilege FP on FP.FieldPrivilegeID=FC.FieldPrivilegeID
			 left outer join [dbo].[Tbl_ClientTransaction] CT on CT.FieldMasterID = FC.FieldMasterId
			 where MailBoxID=@MailboxID and CountryID=@CountryID and FC.Active=1  and ct.caseid=@CaseID)

			 union all

			 ( 

			 --B.Controls Without Values 
				--B.1. Other than Listcontrols
				--Union 
				--B.2. List Controls having Values in Default list Values table

			 -- B.1. Other than Listcontrols
			 select FC.FieldMasterId as FieldMasterID, '' as value, FT.FieldType, FT.FieldAbbrv + 'DF_'+ REPLACE(FC.FieldName, ' ', '__') as DynamicFieldMaster_ID, FC.FieldName,  FC.TextLength,  FDT.FieldDataType as FieldDataType,  FC.ValidationTypeId as ValidationTypeID,VT.ValidationType,FC.FieldAliasName, FC.FieldPrivilegeID,FP.FieldPrivilegeName
			 
			 from Tbl_FieldConfiguration FC 

			 join Tbl_Master_FieldType FT on FC.FieldTypeId = FT.FieldTypeId

			 join Tbl_Master_FieldDataType FDT on FDT.FieldDataTypeId = FC.FieldDataTypeID

			 join Tbl_Master_ValidationType VT on VT.ValidationTypeId = FC.ValidationTypeID
			  join Tbl_Master_FieldPrivilege FP on FP.FieldPrivilegeID=FC.FieldPrivilegeID

			 where MailBoxID=@MailboxID and CountryID=@CountryID and  FC.Active=1 and FC.FieldMasterId 

			 not in (select distinct FieldMasterId from [dbo].[Tbl_ClientTransaction]  where caseid=@CaseID )

			 and FT.FieldTypeId not in (2,3,5) 
			 
			 union all 

			 -- B.2. List Controls having Values in Default list Values table
			 select FC.FieldMasterId as FieldMasterID, '' as value, FT.FieldType, FT.FieldAbbrv + 'DF_'+ REPLACE(FC.FieldName, ' ', '__') as DynamicFieldMaster_ID, FC.FieldName,  FC.TextLength,  FDT.FieldDataType as FieldDataType,  FC.ValidationTypeId as ValidationTypeID,VT.ValidationType,FC.FieldAliasName, FC.FieldPrivilegeID,FP.FieldPrivilegeName
			 
			 from Tbl_FieldConfiguration FC 

			 join Tbl_Master_FieldType FT on FC.FieldTypeId = FT.FieldTypeId

			 join Tbl_Master_FieldDataType FDT on FDT.FieldDataTypeId = FC.FieldDataTypeID

			 join Tbl_Master_ValidationType VT on VT.ValidationTypeId = FC.ValidationTypeID
			 join Tbl_Master_FieldPrivilege FP on FP.FieldPrivilegeID=FC.FieldPrivilegeID

			 where MailBoxID=@MailboxID and CountryID=@CountryID  and  FC.Active=1 and FC.FieldMasterId 

			 not in (select distinct FieldMasterId from [dbo].[Tbl_ClientTransaction]  where caseid=@CaseID )

			 and fc.FieldMasterId in (select distinct FieldMasterId from Tbl_DefaultListValues where Active=1) and FT.FieldTypeId in (2,3,5) 
			 )

		 ) temp order by FieldMasterID
		 
	 end

	 else

	 begin
		select  FC.FieldMasterId as FieldMasterID,  '' as value, FT.FieldType, FT.FieldAbbrv + 'DF_'+ REPLACE(FC.FieldName, ' ', '__') as DynamicFieldMaster_ID, FC.FieldName,  FC.TextLength,  FDT.FieldDataType as FieldDataType,  FC.ValidationTypeId as ValidationTypeID,VT.ValidationType,FC.FieldAliasName, FC.FieldPrivilegeID,FP.FieldPrivilegeName

		 from Tbl_FieldConfiguration FC 

		 join Tbl_Master_FieldType FT on FC.FieldTypeId = FT.FieldTypeId
		 join Tbl_Master_FieldDataType FDT on FDT.FieldDataTypeId = FC.FieldDataTypeID
		 join Tbl_Master_ValidationType VT on VT.ValidationTypeId = FC.ValidationTypeID
		  join Tbl_Master_FieldPrivilege FP on FP.FieldPrivilegeID=FC.FieldPrivilegeID
		 where MailBoxID=@MailboxID and CountryID=@CountryID and  FC.Active=1 and FT.FieldTypeId not in (2,3,5)
	
	 union all 

		select distinct FC.FieldMasterId as FieldMasterID,  '' as value, FT.FieldType, FT.FieldAbbrv + 'DF_'+ REPLACE(FC.FieldName, ' ', '__') as         DynamicFieldMaster_ID, FC.FieldName,  FC.TextLength,  FDT.FieldDataType as FieldDataType,  FC.ValidationTypeId as              ValidationTypeID,VT.ValidationType,FC.FieldAliasName, FC.FieldPrivilegeID,FP.FieldPrivilegeName

		from Tbl_FieldConfiguration FC 

		join Tbl_Master_FieldType FT on FC.FieldTypeId = FT.FieldTypeId
		join Tbl_Master_FieldDataType FDT on FDT.FieldDataTypeId = FC.FieldDataTypeID
		join Tbl_Master_ValidationType VT on VT.ValidationTypeId = FC.ValidationTypeID
		 join Tbl_Master_FieldPrivilege FP on FP.FieldPrivilegeID=FC.FieldPrivilegeID
		where MailBoxID=@MailboxID and CountryID=@CountryID  and  FC.Active=1 and FT.FieldTypeId in (2,3,5) and fc.FieldMasterId in (select distinct FieldMasterId from Tbl_DefaultListValues where Active=1)
		order by FC.FieldMasterId



		 --select FC.FieldMasterId as FieldMasterID,  '' as value, FT.FieldType, FT.FieldAbbrv + 'DF_'+ REPLACE(FC.FieldName, ' ', '__') as DynamicFieldMaster_ID, 
		 --FC.FieldName,  FC.TextLength,  FDT.FieldDataType as FieldDataType,  FC.ValidationTypeId as ValidationTypeID,FC.FieldAliasName, FC.FieldPrivilegeID
		 --from Tbl_FieldConfiguration FC 
		 
		 --join Tbl_Master_FieldType FT on FC.FieldTypeId = FT.FieldTypeId
		 
		 --join Tbl_Master_FieldDataType FDT on FDT.FieldDataTypeId = FC.FieldDataTypeID
		 
		 --join Tbl_Master_ValidationType VT on VT.ValidationTypeId = FC.ValidationTypeID
		 
		 --where MailBoxID=@MailboxID and CountryID=@CountryID and  FC.Active=1 
		 
		 --order by FC.FieldMasterId
		 
	 end
	 
END              


select * from Tbl_FieldConfiguration
select * from Tbl_FieldConfiguration


GO
/****** Object:  StoredProcedure [dbo].[USP_GetDynamicControlstoDataEntryforManualCase]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*                              







Author Name                                 



Date written                                                 







Description                                 



Revision History:                              







Change #          Modified By       Reason                                     Date                              







*/                              



                        



-- EXEC [USP_GetDynamicControlstoDataEntryforManualCase] 233                          







CREATE PROCEDURE [dbo].[USP_GetDynamicControlstoDataEntryforManualCase]                              
(

@MailboxID BigInt,

@CountryID int

)

AS

BEGIN                              

SET NOCOUNT ON;                              

	 begin
		select  FC.FieldMasterId as FieldMasterID,  '' as value, FT.FieldType, FT.FieldAbbrv + 'DF_'+ REPLACE(FC.FieldName, ' ', '__') as DynamicFieldMaster_ID, FC.FieldName,  FC.TextLength,  FDT.FieldDataType as FieldDataType,  FC.ValidationTypeId as ValidationTypeID,FC.FieldAliasName, FC.FieldPrivilegeID

		 from Tbl_FieldConfiguration FC 

		 join Tbl_Master_FieldType FT on FC.FieldTypeId = FT.FieldTypeId
		 join Tbl_Master_FieldDataType FDT on FDT.FieldDataTypeId = FC.FieldDataTypeID
		 join Tbl_Master_ValidationType VT on VT.ValidationTypeId = FC.ValidationTypeID

		 where MailBoxID=@MailboxID and CountryID=@CountryID and  FC.Active=1 and FT.FieldTypeId not in (2,3,5)
	
	 union all 

		select distinct FC.FieldMasterId as FieldMasterID,  '' as value, FT.FieldType, FT.FieldAbbrv + 'DF_'+ REPLACE(FC.FieldName, ' ', '__') as         DynamicFieldMaster_ID, FC.FieldName,  FC.TextLength,  FDT.FieldDataType as FieldDataType,  FC.ValidationTypeId as              ValidationTypeID,FC.FieldAliasName, FC.FieldPrivilegeID

		from Tbl_FieldConfiguration FC 

		join Tbl_Master_FieldType FT on FC.FieldTypeId = FT.FieldTypeId
		join Tbl_Master_FieldDataType FDT on FDT.FieldDataTypeId = FC.FieldDataTypeID
		join Tbl_Master_ValidationType VT on VT.ValidationTypeId = FC.ValidationTypeID

		where MailBoxID=@MailboxID and CountryID=@CountryID  and  FC.Active=1 and FT.FieldTypeId in (2,3,5) and fc.FieldMasterId in (select distinct FieldMasterId from Tbl_DefaultListValues where Active=1)
		order by FC.FieldMasterId

	 end

END              















GO
/****** Object:  StoredProcedure [dbo].[USP_GETDynamicDropDownValues]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- EXEC USP_GETDynamicDropDownValues 7  

CREATE PROCEDURE [dbo].[USP_GETDynamicDropDownValues]  

(  

 @FieldMasterId BIGINT 
 
)  

AS  

BEGIN  

SET NOCOUNT ON;  
  

  SELECT   

   DefaultListValueId AS OptionValue,OptionText  

  FROM   

   Tbl_DefaultListValues  

  WHERE  

   FieldMasterId = @FieldMasterId AND  

   Active = 1  


END






GO
/****** Object:  StoredProcedure [dbo].[USP_GetDynamicStatusDashboardCount_Details]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetDynamicStatusDashboardCount_Details]  -- exec [USP_GetDynamicStatusDashboardCount_Details] 'India','Test','TestMailBox','195174',1,'195174'

@CountryName varchar(100),                

@SubProcessName varchar(100),

@Emailbox varchar(100)
--@LoggedInUserId varchar(50),                
--@RoleId int,                
--@SelectedAssociateId varchar(50)=null       
          
AS                

BEGIN                 

SET NOCOUNT ON;  


DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX),
	@SubProcessId AS NVARCHAR(MAX)

set @SubProcessId=(select SubProcessGroupId from SubProcessGroups where SubprocessName=@SubProcessName)



if exists(select * from Status where SubProcessID=@SubProcessId)
begin 

	--IF(@RoleId=4) --Processor  
			select @cols = STUFF((SELECT ',' + QUOTENAME(ST.StatusDescription) 
							from Status ST 	
			left outer join SubProcessGroups SG on SG.SubProcessGroupId=ST.SubProcessID
			inner join EMailBox EB on EB.SubProcessGroupId=SG.SubProcessGroupId
			left outer join Country CN on CN.CountryId=SG.CountryIdMapping
			left join emailmaster EM on EM.StatusId=St.StatusId and EM.emailboxid=EB.EMailBoxId 
			where ST.ShownInUI=1 and
			ltrim(rtrim(EMailBoxName)) =ltrim(rtrim(@Emailbox)) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubProcessName)) and ltrim(rtrim(Country))=ltrim(rtrim(@CountryName)) and ST.IsActive=1
			group by ST.StatusDescription,ST.StatusId	
			 FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

			set @query = N'SELECT ' + @cols + N' from 
					 (
					   select count(Em.CaseId) as CaseCount,
			ST.StatusDescription from Status ST 
			left outer join SubProcessGroups SG on SG.SubProcessGroupId=ST.SubProcessID
			inner join EMailBox EB on EB.SubProcessGroupId=SG.SubProcessGroupId
			left outer join Country CN on CN.CountryId=SG.CountryIdMapping
			left join emailmaster EM on EM.StatusId=St.StatusId and EM.emailboxid=EB.EMailBoxId
			where ST.ShownInUI=1 and  
			ltrim(rtrim(EMailBoxName)) =ltrim(rtrim('''+@Emailbox+''')) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim('''+@SubProcessName+''')) and ltrim(rtrim(Country))=ltrim(rtrim('''+@CountryName+''')) 	
			group by ST.StatusId, ST.StatusDescription
					) x
					pivot 
					(
						max(CaseCount)
						for StatusDescription in (' + @cols + N')
					) p '
end	
else
begin 
	select @cols = STUFF((SELECT ',' + QUOTENAME(ST.StatusDescription) 
                    from Status ST 		
	cross join EMailBox EB
	left outer join emailmaster EM on EM.StatusId=St.StatusId and EB.EMailBoxId=EM.emailboxid 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=EB.SubProcessGroupId 
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	--inner join UserMailBoxMapping umbm on EM.EmailBoxId = umbm.MailBoxId --AND Convert(varchar,umbm.UserId)=Convert(varchar,@LoggedInUserId) 
	where ST.ShownInUI=1 and ST.SubProcessID is null and --Convert(varchar,EM.AssignedToId)=Convert(varchar,@LoggedInUserId) and
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim(@Emailbox)) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubProcessName)) and ltrim(rtrim(Country))=ltrim(rtrim(@CountryName)) and ST.IsActive=1	
	group by ST.StatusDescription,ST.StatusId
	FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')


		--AND Convert(varchar,umbm.UserId)='+Convert(varchar,@LoggedInUserId)+'
		--and Convert(varchar,EM.AssignedToId)='+Convert(varchar,@LoggedInUserId)+'
	set @query = N'SELECT ' + @cols + N' from 
             (
               select count(Em.CaseId) as CaseCount,
	ST.StatusDescription from Status ST 
	cross join EMailBox EB
	left outer join emailmaster EM on EM.StatusId=St.StatusId and EB.EMailBoxId=EM.emailboxid 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=EB.SubProcessGroupId 
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	where ST.ShownInUI=1 and ST.SubProcessID is null and 
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim('''+@Emailbox+''')) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim('''+@SubProcessName+''')) and ltrim(rtrim(Country))=ltrim(rtrim('''+@CountryName+''')) 	
	group by ST.StatusId, ST.StatusDescription
            ) x
            pivot 
            (
                max(CaseCount)
                for StatusDescription in (' + @cols + N')
            ) p '
end

exec sp_executesql @query;

        
END   










GO
/****** Object:  StoredProcedure [dbo].[USP_GetDynamicStatusDashboardCount_Details_Dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetDynamicStatusDashboardCount_Details_Dynamic]  -- exec USP_GetDynamicStatusDashboardCount_Details_Dynamic 'India','EMTDev1','MailTrac','195174'   

@CountryName varchar(100),                

@SubProcessName varchar(100),

@Emailbox varchar(100),

@LoggedInUserId varchar(100) 
          
AS                

BEGIN                 

SET NOCOUNT ON;  



DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX),
	@SubProcessId AS NVARCHAR(MAX),
	@assignedtoQuery as NVARCHAR(MAX)


set @SubProcessId=(select SubProcessGroupId from SubProcessGroups where SubprocessName=@SubProcessName)

if exists(select * from Status where SubProcessID=@SubProcessId)
begin 
	select @cols = STUFF((SELECT ',' + QUOTENAME(ST.StatusDescription) 
                    from Status ST 	
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=ST.SubProcessID
	inner join EMailBox EB on EB.SubProcessGroupId=SG.SubProcessGroupId
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	left join emailmaster EM on EM.StatusId=St.StatusId and EM.emailboxid=EB.EMailBoxId
	where ST.ShownInUI=1 and 
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim(@Emailbox)) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubProcessName)) and ltrim(rtrim(Country))=ltrim(rtrim(@CountryName)) and ST.IsActive=1
	group by ST.StatusDescription,ST.StatusId	
	 FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')


	set @query = N'SELECT ' + @cols + N' from 
             (
               select ISNULL(count(Em.CaseId),0) as CaseCount,
	ST.StatusDescription from Status ST 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=ST.SubProcessID
	inner join EMailBox EB on EB.SubProcessGroupId=SG.SubProcessGroupId
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	left join emailmaster EM on EM.StatusId=St.StatusId and EM.emailboxid=EB.EMailBoxId
	where
	 (
       ISNULL('''+@LoggedInUserId+''',0)!=0 AND ((ST.IsInitalStatus=1)  OR (ISNULL(EM.AssignedToId, 0) = '''+@LoggedInUserId+'''))
	   OR
	   ISNULL('''+@LoggedInUserId+''',0)=0 
    )
	and
	ST.ShownInUI=1 and 
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim('''+@Emailbox+''')) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim('''+@SubProcessName+''')) and ltrim(rtrim(Country))=ltrim(rtrim('''+@CountryName+''')) 	
	group by ST.StatusId, ST.StatusDescription
            ) x
            pivot 
            (
                max(CaseCount)
                for StatusDescription in (' + @cols + N')
            ) p '
			PRINT @cols
PRINT @query
end	
else
begin 
	select @cols = STUFF((SELECT ',' + QUOTENAME(ST.StatusDescription) 
                    from Status ST 		
	cross join EMailBox EB
	left outer join emailmaster EM on EM.StatusId=St.StatusId and EB.EMailBoxId=EM.emailboxid 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=EB.SubProcessGroupId 
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	where ST.ShownInUI=1 and ST.SubProcessID is null and
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim(@Emailbox)) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubProcessName)) and ltrim(rtrim(Country))=ltrim(rtrim(@CountryName)) and ST.IsActive=1	
	group by ST.StatusDescription,ST.StatusId
	FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

	set @query = N'SELECT ' + @cols + N' from 
             (
               select IsNULL(count(Em.CaseId),0) as CaseCount,
	ST.StatusDescription from Status ST 
	cross join EMailBox EB
	left outer join emailmaster EM on EM.StatusId=St.StatusId and EB.EMailBoxId=EM.emailboxid 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=EB.SubProcessGroupId 
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	where
	 (
       ISNULL('''+@LoggedInUserId+''',0)!=0 AND ((ST.IsInitalStatus=1)  OR (ISNULL(EM.AssignedToId, 0) = '''+@LoggedInUserId+'''))
	   OR
	   ISNULL('''+@LoggedInUserId+''',0)=0 
    )
	and 
	ST.ShownInUI=1 and ST.SubProcessID is null and
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim('''+@Emailbox+''')) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim('''+@SubProcessName+''')) and ltrim(rtrim(Country))=ltrim(rtrim('''+@CountryName+''')) 	
	group by ST.StatusId, ST.StatusDescription
            ) x
            pivot 
            (
                max(CaseCount)
                for StatusDescription in (' + @cols + N')
            ) p '
PRINT @cols
PRINT @query
end


exec sp_executesql @query 
			
  
	    
END   










GO
/****** Object:  StoredProcedure [dbo].[USP_GetDynamicStatusDashboardCount_Details_test]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[USP_GetDynamicStatusDashboardCount_Details_test]  -- exec [USP_GetDynamicStatusDashboardCount_Details] 'India','GMBDev2','AP'   

@CountryName varchar(100),                

@SubProcessName varchar(100),

@Emailbox varchar(100)    
          
AS                

BEGIN                 

SET NOCOUNT ON;  


DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX),
	@SubProcessId AS NVARCHAR(MAX)

set @SubProcessId=(select SubProcessGroupId from SubProcessGroups where SubprocessName=@SubProcessName)

if exists(select * from Status where SubProcessID=@SubProcessId)
begin 
	select @cols = STUFF((SELECT ',' + QUOTENAME(ST.StatusDescription) 
                    from Status ST 	
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=ST.SubProcessID
	inner join EMailBox EB on EB.SubProcessGroupId=SG.SubProcessGroupId
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	left join emailmaster EM on EM.StatusId=St.StatusId and EM.emailboxid=EB.EMailBoxId
	where ST.ShownInUI=1 and 
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim(@Emailbox)) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubProcessName)) and ltrim(rtrim(Country))=ltrim(rtrim(@CountryName)) and ST.IsActive=1
	group by ST.StatusDescription,ST.StatusId	
	 FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

	set @query = N'SELECT ' + @cols + N' from 
             (
               select count(Em.CaseId) as CaseCount,
	ST.StatusDescription from Status ST 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=ST.SubProcessID
	inner join EMailBox EB on EB.SubProcessGroupId=SG.SubProcessGroupId
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	left join emailmaster EM on EM.StatusId=St.StatusId and EM.emailboxid=EB.EMailBoxId
	where ST.ShownInUI=1 and 
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim('''+@Emailbox+''')) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim('''+@SubProcessName+''')) and ltrim(rtrim(Country))=ltrim(rtrim('''+@CountryName+''')) 	
	group by ST.StatusId, ST.StatusDescription
            ) x
            pivot 
            (
                max(CaseCount)
                for StatusDescription in (' + @cols + N')
            ) p '
end	
else
begin 
	select @cols = STUFF((SELECT ',' + QUOTENAME(ST.StatusDescription) 
                    from Status ST 		
	cross join EMailBox EB
	left outer join emailmaster EM on EM.StatusId=St.StatusId and EB.EMailBoxId=EM.emailboxid 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=EB.SubProcessGroupId 
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	where ST.ShownInUI=1 and ST.SubProcessID is null and
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim(@Emailbox)) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubProcessName)) and ltrim(rtrim(Country))=ltrim(rtrim(@CountryName)) and ST.IsActive=1	
	group by ST.StatusDescription,ST.StatusId
	FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

	set @query = N'SELECT ' + @cols + N' from 
             (
               select count(Em.CaseId) as CaseCount,
	ST.StatusDescription from Status ST 
	cross join EMailBox EB
	left outer join emailmaster EM on EM.StatusId=St.StatusId and EB.EMailBoxId=EM.emailboxid 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=EB.SubProcessGroupId 
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	where ST.ShownInUI=1 and ST.SubProcessID is null and
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim('''+@Emailbox+''')) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim('''+@SubProcessName+''')) and ltrim(rtrim(Country))=ltrim(rtrim('''+@CountryName+''')) 	
	group by ST.StatusId, ST.StatusDescription
            ) x
            pivot 
            (
                max(CaseCount)
                for StatusDescription in (' + @cols + N')
            ) p '
end

exec sp_executesql @query;

        
END   










GO
/****** Object:  StoredProcedure [dbo].[USP_GetDynamicStatusDashboardCount_Details_WF]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[USP_GetDynamicStatusDashboardCount_Details_WF]  -- exec [USP_GetDynamicStatusDashboardCount_Details] 'India','Test','TestMailBox','195174',1,'195174'

@CountryName varchar(100),                

@SubProcessName varchar(100),

@Emailbox varchar(100)
--@LoggedInUserId varchar(50),                
--@RoleId int,                
--@SelectedAssociateId varchar(50)=null       
          
AS                

BEGIN                 

SET NOCOUNT ON;  


DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX),
	@SubProcessId AS NVARCHAR(MAX)

set @SubProcessId=(select SubProcessGroupId from SubProcessGroups where SubprocessName=@SubProcessName)



if exists(select * from Status where SubProcessID=@SubProcessId)
begin 

	--IF(@RoleId=4) --Processor  
			select @cols = STUFF((SELECT ',' + QUOTENAME(ST.StatusDescription) 
							from Status ST 	
			left outer join SubProcessGroups SG on SG.SubProcessGroupId=ST.SubProcessID
			inner join EMailBox EB on EB.SubProcessGroupId=SG.SubProcessGroupId
			left outer join Country CN on CN.CountryId=SG.CountryIdMapping
			left join emailmaster EM on EM.StatusId=St.StatusId and EM.emailboxid=EB.EMailBoxId
			inner join UserMailBoxMapping umbm on EM.EmailBoxId = umbm.MailBoxId    
			where ST.ShownInUI=1 and
			ltrim(rtrim(EMailBoxName)) =ltrim(rtrim(@Emailbox)) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubProcessName)) and ltrim(rtrim(Country))=ltrim(rtrim(@CountryName)) and ST.IsActive=1
			group by ST.StatusDescription,ST.StatusId	
			 FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)') 
				,1,1,'')

			set @query = N'SELECT ' + @cols + N' from 
					 (
					   select count(Em.CaseId) as CaseCount,
			ST.StatusDescription from Status ST 
			left outer join SubProcessGroups SG on SG.SubProcessGroupId=ST.SubProcessID
			inner join EMailBox EB on EB.SubProcessGroupId=SG.SubProcessGroupId
			left outer join Country CN on CN.CountryId=SG.CountryIdMapping
			left join emailmaster EM on EM.StatusId=St.StatusId and EM.emailboxid=EB.EMailBoxId
			inner join UserMailBoxMapping umbm on EM.EmailBoxId = umbm.MailBoxId 
			where ST.ShownInUI=1 and  
			ltrim(rtrim(EMailBoxName)) =ltrim(rtrim('''+@Emailbox+''')) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim('''+@SubProcessName+''')) and ltrim(rtrim(Country))=ltrim(rtrim('''+@CountryName+''')) 	
			group by ST.StatusId, ST.StatusDescription
					) x
					pivot 
					(
						max(CaseCount)
						for StatusDescription in (' + @cols + N')
					) p '
end	
else
begin 
	select @cols = STUFF((SELECT ',' + QUOTENAME(ST.StatusDescription) 
                    from Status ST 		
	cross join EMailBox EB
	left outer join emailmaster EM on EM.StatusId=St.StatusId and EB.EMailBoxId=EM.emailboxid 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=EB.SubProcessGroupId 
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	inner join UserMailBoxMapping umbm on EM.EmailBoxId = umbm.MailBoxId --AND Convert(varchar,umbm.UserId)=Convert(varchar,@LoggedInUserId) 
	where ST.ShownInUI=1 and ST.SubProcessID is null and --Convert(varchar,EM.AssignedToId)=Convert(varchar,@LoggedInUserId) and
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim(@Emailbox)) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim(@SubProcessName)) and ltrim(rtrim(Country))=ltrim(rtrim(@CountryName)) and ST.IsActive=1	
	group by ST.StatusDescription,ST.StatusId
	FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')


		--AND Convert(varchar,umbm.UserId)='+Convert(varchar,@LoggedInUserId)+'
		--and Convert(varchar,EM.AssignedToId)='+Convert(varchar,@LoggedInUserId)+'
	set @query = N'SELECT ' + @cols + N' from 
             (
               select count(Em.CaseId) as CaseCount,
	ST.StatusDescription from Status ST 
	cross join EMailBox EB
	left outer join emailmaster EM on EM.StatusId=St.StatusId and EB.EMailBoxId=EM.emailboxid 
	left outer join SubProcessGroups SG on SG.SubProcessGroupId=EB.SubProcessGroupId 
	left outer join Country CN on CN.CountryId=SG.CountryIdMapping
	inner join UserMailBoxMapping umbm on EM.EmailBoxId = umbm.MailBoxId 
	where ST.ShownInUI=1 and ST.SubProcessID is null and 
	ltrim(rtrim(EMailBoxName)) =ltrim(rtrim('''+@Emailbox+''')) and ltrim(rtrim(SubprocessName)) =ltrim(rtrim('''+@SubProcessName+''')) and ltrim(rtrim(Country))=ltrim(rtrim('''+@CountryName+''')) 	
	group by ST.StatusId, ST.StatusDescription
            ) x
            pivot 
            (
                max(CaseCount)
                for StatusDescription in (' + @cols + N')
            ) p '
end

exec sp_executesql @query;

        
END   










GO
/****** Object:  StoredProcedure [dbo].[USP_GetEmailBox_SubProcessByCountryId_And_UserID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_BIND_EMAILBOX_LOGINMAILID      
----Created by Kalaichelvan for getiing mailbox mapped to the userid      
Create PROCEDURE [dbo].[USP_GetEmailBox_SubProcessByCountryId_And_UserID]                    
@CountryId varchar(50),      
@Userid  VARCHAR(50),
@Roleid INT                 
AS                  
BEGIN                   
SET NOCOUNT ON;   
	IF(@Roleid=3 or @Roleid=4)   --Team Lead/Processor  
		BEGIN	               
		  select EB.EMAILBOXID, EB.EMAILBOXNAME  from UserMailBoxMapping UMB      
		  Join EMAILBOX EB  on EB.emailboxid=UMB.Mailboxid      
		  JOIN COUNTRY C  ON EB.COUNTRYID = C.COUNTRYID        
		  WHERE EB.COUNTRYID =@CountryId AND EB.ISACTIVE =1 AND C.ISACTIVE =1        
		  and UMB.userid=@Userid   
		   
		  SELECT SPG.SubProcessGroupID, SPG.SubProcessName from SUBPROCESSGROUPS SPG where IsActive=1 and CountryIdMapping=@CountryId       
		END
	 ELSE
		  BEGIN	               
			  select EB.EMAILBOXID, EB.EMAILBOXNAME 
			  from EMAILBOX EB  
			  JOIN COUNTRY C ON EB.COUNTRYID = C.COUNTRYID        
			  WHERE EB.COUNTRYID =@CountryId AND EB.ISACTIVE =1 AND C.ISACTIVE =1        
			  SELECT SPG.SubProcessGroupID, SPG.SubProcessName from SUBPROCESSGROUPS SPG where IsActive=1 and CountryIdMapping=@CountryId       
		END
	  
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_GetEmailBoxByCountryId]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetEmailBoxByCountryId]
          
@CountryId varchar(50)
          
AS          
BEGIN           
SET NOCOUNT ON;          


SELECT EB.EMAILBOXID, EB.EMAILBOXNAME  FROM EMAILBOX EB
JOIN COUNTRY C  ON EB.COUNTRYID = C.COUNTRYID 
WHERE EB.COUNTRYID =@COUNTRYID AND EB.ISACTIVE =1 AND C.ISACTIVE =1

          
END 











GO
/****** Object:  StoredProcedure [dbo].[USP_GetEmailBoxByCountryId_And_UserID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_BIND_EMAILBOX_LOGINMAILID      
----Created by Kalaichelvan for getiing mailbox mapped to the userid      
CREATE PROCEDURE [dbo].[USP_GetEmailBoxByCountryId_And_UserID]                    
@CountryId varchar(50),      
@Userid  VARCHAR(50),
@Roleid INT                 
AS                  
BEGIN                   
SET NOCOUNT ON;   
	IF(@Roleid=3 or @Roleid=4)   --Team Lead/Processor  
		BEGIN	               
		  select EB.EMAILBOXID, EB.EMAILBOXNAME  from UserMailBoxMapping UMB      
		  Join EMAILBOX EB  on EB.emailboxid=UMB.Mailboxid      
		  JOIN COUNTRY C  ON EB.COUNTRYID = C.COUNTRYID        
		  WHERE EB.COUNTRYID =@CountryId AND EB.ISACTIVE =1 AND C.ISACTIVE =1        
		  and UMB.userid=@Userid    
		  SELECT SPG.SubProcessGroupID, SPG.SubProcessName from SUBPROCESSGROUPS SPG where IsActive=1 and CountryIdMapping=@CountryId       
		END
	 ELSE
		  BEGIN	               
			  select EB.EMAILBOXID, EB.EMAILBOXNAME 
			  from EMAILBOX EB  
			  JOIN COUNTRY C ON EB.COUNTRYID = C.COUNTRYID        
			  WHERE EB.COUNTRYID =@CountryId AND EB.ISACTIVE =1 AND C.ISACTIVE =1        
			  SELECT SPG.SubProcessGroupID, SPG.SubProcessName from SUBPROCESSGROUPS SPG where IsActive=1 and CountryIdMapping=@CountryId       
		END
	  
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_GetEmailBoxByCountryIdForQC]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetEmailBoxByCountryIdForQC]
          
@CountryId varchar(50)
          
AS          
BEGIN           
SET NOCOUNT ON;          


SELECT EB.EMAILBOXID, EB.EMAILBOXNAME  FROM EMAILBOX EB
JOIN COUNTRY C  ON EB.COUNTRYID = C.COUNTRYID 
WHERE EB.COUNTRYID =@COUNTRYID AND EB.ISACTIVE =1 AND C.ISACTIVE =1
AND ISQCREQUIRED=1

          
END 











GO
/****** Object:  StoredProcedure [dbo].[USP_GetEmailBoxDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : RAGUVARAN E
* CREATED DATE : 05/26/2014
* PURPOSE : TO GET THE EMAILBOX DETAILS FOR SENDING EMAIL
*/

CREATE PROCEDURE [dbo].[USP_GetEmailBoxDetails]
(
	@EMAILBOXID AS BIGINT
)
AS
BEGIN

SELECT	EB.EMAILBOXADDRESS,
        EB.EMailBoxAddressOptional
		,EBLD.EMAILID AS LOGINEMAILID
		,EBLD.PASSWORD
		,EB.EMAILFOLDERPATH
		,EB.ISREPLYNOTREQUIRED
		,CASE WHEN EB.ISLOCKED=1 THEN EB.ISLOCKED ELSE EBLD.ISLOCKED END AS ISLOCKED
		,EB.IsVOCSurvey 
FROM 
EMAILBOX EB WITH (NOLOCK)LEFT JOIN EMAILBOXLOGINDETAIL EBLD WITH (NOLOCK) ON EB.EMAILBOXLOGINDETAILID=EBLD.EMAILBOXLOGINDETAILID
WHERE EBLD.ISACTIVE=1 AND EB.ISACTIVE=1 AND EB.EMAILBOXID=@EMAILBOXID
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetEmailBoxDetailsByUserID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*  
* CREATED BY : RAGUVARAN E  
* CREATED DATE : 05/26/2014  
* PURPOSE : TO GET THE EMAILBOX DETAILS BASED ON USER AND ROLE ID  
*/  
  
CREATE PROCEDURE [dbo].[USP_GetEmailBoxDetailsByUserID]  
(  
 @USERID AS VARCHAR(50),  
 @ROLEID AS INT ,
 @COUNTRYID AS INT 
)  
AS  
BEGIN  
  
--SELECT EB.EMailBoxId,EB.EMailBoxName  
--FROM   
--EMAILBOX EB   
--LEFT JOIN UserMailBoxMapping UMM ON EB.EMailBoxId = UMM.MailBoxId  
--LEFT JOIN UserRoleMapping URM ON UMM.UserId=URM.UserId  
--WHERE URM.UserId=@USERID AND URM.RoleId=@ROLEID  AND EB.COUNTRYID=@COUNTRYID
--AND EB.ISACTIVE=1  

select EB.EMAILBOXID, EB.EMAILBOXNAME  from UserMailBoxMapping UMB      
		  Join EMAILBOX EB  on EB.emailboxid=UMB.Mailboxid      
		  JOIN COUNTRY C  ON EB.COUNTRYID = C.COUNTRYID        
		  WHERE EB.COUNTRYID =@COUNTRYID AND EB.ISACTIVE =1 AND C.ISACTIVE =1        
		  and UMB.userid=@USERID   
		   
		  SELECT SPG.SubProcessGroupID, SPG.SubProcessName from SUBPROCESSGROUPS SPG where IsActive=1 and CountryIdMapping=@COUNTRYID

END






GO
/****** Object:  StoredProcedure [dbo].[USP_GETFIELDDATAANDVALIDATIONTYPE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Exec USP_Get_FieldDataandValidationType 1  

      

CREATE Proc [dbo].[USP_GETFIELDDATAANDVALIDATIONTYPE]      

@FieldTypeID BigInt      

As      

Begin      

       

SET NOCOUNT ON          

DECLARE @General_Query nvarchar(max)      

DECLARE @queryString nvarchar(4000)      

DECLARE @Final varchar(max)      

    

DECLARE @ValGeneral_Query nvarchar(max)      

DECLARE @ValqueryString nvarchar(4000)      

DECLARE @ValFinal varchar(max)      

    

    

  BEGIN TRAN TXN_SELECT  

   BEGIN TRY    

      

set @General_Query = 'Select distinct FT.FieldDataTypeID,FT.FieldDataType,FT.FieldDataTypeAlias From Tbl_Master_FieldDataType FT      

  where FT.FieldDataTypeID in  '        

        

  set @ValGeneral_Query = 'Select distinct VT.ValidationTypeId,VT.ValidationType From Tbl_Master_ValidationType VT   where VT.ValidationTypeId in  '    

      

 if @FieldTypeID = 1 or @FieldTypeID = 4 -- TextBox  & TextArea    

  Begin      

   Set @queryString = '(2,4 ) '      

   Set @ValqueryString = '(3,4,5,6 ) '      

  End      

 Else if @FieldTypeID = 2 or @FieldTypeID = 3 or @FieldTypeID = 5  -- DropDownList       

  Begin      

   Set @queryString = '( 4 ) '      

   Set @ValqueryString = ' ( 6 ) '     

  End          

 --Else if  -- CheckBoxList & RadioButtonList      

 -- Begin      

 --  Set @queryString = '( 4 ) '      

 --  Set @ValqueryString = ' (6) '     

 -- End      

        

 Else if @FieldTypeID = 6  -- DateTime      

  Begin      

   Set @queryString = '( 5 ) '     

   Set @ValqueryString = ' ( 7 ) '      

  End      

      

Set @Final = @General_Query + @queryString      

    

Set @ValFinal = @ValGeneral_Query + @ValqueryString      

    

-- Field Data Type    

Print @Final      

Exec(@Final)      

    

-- Validation Type    

Print @ValFinal      

Exec(@ValFinal)      

   END TRY  

                        BEGIN CATCH  

                              GOTO HandleError1  

                        END CATCH  

                        IF @@TRANCOUNT > 0 COMMIT TRAN TXN_SELECT  

                        RETURN 1  

                  HandleError1:  

                        IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_SELECT  

                        RAISERROR('Error Updating table Tbl_Master_FieldDataType', 16, 1)  

                        RETURN -1     

End        

    

/*    

    

Select * from dbo.Tbl_Master_FieldType    

    

Select * from dbo.Tbl_Master_FieldDataType    

    

select * from dbo.Tbl_Master_ValidationType    

    

*/







GO
/****** Object:  StoredProcedure [dbo].[USP_GETFIELDNAME]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--  Exec [USP_GETFIELDNAME] 1  

CREATE Proc [dbo].[USP_GETFIELDNAME]      
@intFieldMasterID BigInt      
As      
Begin      
SET NOCOUNT ON          
DECLARE @General_Query nvarchar(max)      
DECLARE @queryString nvarchar(4000)      
DECLARE @Final varchar(max)       
DECLARE @ValGeneral_Query nvarchar(max)      
DECLARE @ValqueryString nvarchar(4000)      
DECLARE @ValFinal varchar(max)      
BEGIN TRAN TXN_SELECT  
      BEGIN TRY    
			set @General_Query = 'Select distinct FT.FieldDataTypeID,FT.FieldDataType,FT.FieldDataTypeAlias From Tbl_Master_FieldDataType FT      
			where FT.FieldDataTypeID in  '        

			set @ValGeneral_Query = 'Select distinct VT.ValidationTypeId,VT.ValidationType From Tbl_Master_ValidationType VT   where Active=1 AND VT.ValidationTypeId in  '    

		 if @intFieldMasterID = 1 or @intFieldMasterID = 4 -- TextBox  & TextArea    
			   Begin      
				  Set @queryString = '(2,4 ) '      
				 Set @ValqueryString = '(3,4,5,6 ) '      
			   End      
		 Else if @intFieldMasterID = 2 or @intFieldMasterID = 3 or @intFieldMasterID = 5  -- DropDownList       
			  Begin      
			   Set @queryString = '( 4 ) '      
			   Set @ValqueryString = ' ( 6 ) '     
			  End          
		 --Else if  -- CheckBoxList & RadioButtonList      

		 -- Begin      

		 --  Set @queryString = '( 4 ) '      

		 --  Set @ValqueryString = ' (6) '     

		 -- End      
		 Else if @intFieldMasterID = 6  -- DateTime      
			  Begin      
			   Set @queryString = '( 5 ) '     
			   Set @ValqueryString = ' ( 7 ) '      
			  End


		Set @Final = @General_Query + @queryString      
		Set @ValFinal = @ValGeneral_Query + @ValqueryString      
		-- Field Data Type    
		Print @Final      
		Exec(@Final)      
		-- Validation Type    
		Print @ValFinal      
		Exec(@ValFinal)      
	END TRY  
    BEGIN CATCH 
            GOTO HandleError1  
    END CATCH  
		IF @@TRANCOUNT > 0 COMMIT TRAN TXN_SELECT  
		RETURN 1  

	HandleError1:  

		IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_SELECT  
		RAISERROR('Error Updating table Tbl_Master_FieldDataType', 16, 1)  
		RETURN -1     
End        







    







/*    







    







Select * from dbo.Tbl_Master_FieldType    







    







Select * from dbo.Tbl_Master_FieldDataType    







    







select * from dbo.Tbl_Master_ValidationType    







    







*/







GO
/****** Object:  StoredProcedure [dbo].[USP_GetFlagCriteriaByEmailBoxSelected]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetFlagCriteriaByEmailBoxSelected]
          
@EMailboxId varchar(50)
          
AS          
BEGIN           
SET NOCOUNT ON;


SELECT EBR.EmailboxReferenceId, EBR.Reference  FROM dbo.EmailboxReferenceConfig EBR
JOIN EmailBox EB  ON EBR.EmailboxId = EB.EMailBoxId
WHERE EBR.EmailboxId =@EMailboxId AND EB.ISACTIVE =1 AND EB.ISACTIVE =1


END


GO
/****** Object:  StoredProcedure [dbo].[USP_GetGMBChildCaseDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetGMBChildCaseDetails]
(
@CASEID BIGINT
)
AS
BEGIN
Create table #TEMP
 (
 CaseId  int,
 StatusId int, 
 )
if exists (select * from EmailMaster where ParentCaseId=@CASEID)
begin	
	SELECT (cast(em.CaseId as varchar(max))+'-'+'('+s.StatusDescription+')') as cid,em.CaseId,em.EMailBoxId,em.StatusId,em.ParentCaseId  FROM EmailMaster em left join status s on em.Statusid=s.StatusId WHERE em.ParentCaseId=@CASEID
end
else if exists(	select * from Emailmaster where CaseId=@CASEID)
begin	
	SELECT (cast(em.CaseId as varchar(max))+'-'+'('+s.StatusDescription+')') as cid,em.CaseId,em.EMailBoxId,em.StatusId,em.ParentCaseId 
	FROM EmailMaster em left join status s on em.statusid=s.StatusId 
	WHERE ParentCaseId=(select ParentCaseId from EmailMaster where CaseId=@CASEID)
end
END


---SELECT *FROM EmailMaster where ParentCaseId is not null
--select * from emailmaster where CaseId=1478
--select * from Status
GO
/****** Object:  StoredProcedure [dbo].[USP_GetGMBChildCaseDetails1]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec [USP_GetGMBChildCaseDetails1] 1477
CREATE PROCEDURE [dbo].[USP_GetGMBChildCaseDetails1]
(
@CASEID BIGINT
)
AS
BEGIN
DECLARE @REFER AS BIGINT
DECLARE @TBLCOUNT AS BIGINT
DECLARE @ITERATIONCOUNT AS BIGINT
DECLARE @SUBREFER AS BIGINT
--set @REFER=@CASEID

Create table #TEMP
 (RNO int,
 CaseId  int,
 ParentCaseId  int,
 StatusId int,
 LevelID int
 )
 
 Create table #FnlTemp
 (
 CaseId  int,
 ParentCaseId  int,
 StatusId int,
 LevelID int
 )
 --,
 --EMailBoxId  int,
 --StatusId  int,
 --ParentCaseId  bigint )
 

if exists(select CaseID from EMailMaster where CaseId=@CASEID and ParentCaseId is null)
begin
declare @levelID as int = 1 
	insert into #TEMP--RNO,CaseID,ParentCaseId,[StatusID])
	select Row_Number() over(order by CaseID)as RNO,CaseID,ParentCaseId,[StatusID],@levelID  from EMailMaster where ParentCaseId=@CASEID
		declare @tempcnt int
		declare  @iCNT as int
		
		
	RUNAGAIN:
	set @levelID =@levelID+1

	select @tempcnt = count(caseID) from #TEMP
	If(@tempcnt > 1)
	Begin
	set @iCNT=1
	while @iCNT<=@tempcnt
			begin
				create table #CNT
				(  
				  caseId  int,
				  ParentCaseId  int,
				  StatusID int,
				  LevelID int
				) 
				
				insert into #FnlTemp
				select CaseId,ParentCaseId,StatusId,@levelID from #TEMP
				insert into #CNT
				select CaseId,ParentCaseId,StatusID,@levelID FROM EmailMaster WHERE ParentCaseId = (select CaseID from #TEMP where RNO=@iCNT)
				
				delete #TEMP
				
				insert into #TEMP(CaseID,ParentCaseId,[StatusID],LevelID)
				select CaseId,ParentCaseId,StatusId,LevelID from #CNT
				
				drop table #CNT
				
				set @iCNT=@iCNT+1

				--drop table @CNT
		END
	GOTO RUNAGAIN
	END
	
	Else 
	Begin
		select * from #FNLTEMP
	End
	
	
END


END 
--else if exists(select CaseID from EMailMaster where CaseId=@REFER and ParentCaseId is not null)
--begin
	
--End
GO
/****** Object:  StoredProcedure [dbo].[USP_GetGMBParentCaseDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetGMBParentCaseDetails]
(
@CASEID BIGINT
)
AS
BEGIN
declare @refer as bigint
set @refer =@CASEID
ab:
if exists(select * from EMailMaster where CaseId=@refer and ParentCaseId is null)
begin	
	select (cast(em.CaseId as varchar(max))+'-'+'('+s.StatusDescription+')') as cid,em.CaseId,em.EMailBoxId,em.StatusId,s.StatusDescription from EMailMaster em left join status s on em.statusid=s.StatusId
	WHERE CaseId=@refer
end
else if exists(select * from EMailMaster where CaseId=@refer and ParentCaseId is not null)
begin
	set @refer=(select ParentCaseId from EmailMaster WHERE CaseId=@refer)	
	goto ab	
end
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetInlineAttachmentList]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : Varma
* CREATED DATE : 07/20/2016
* PURPOSE : TO GET THE LIST OF Inline ATTACHMENTS TO DISPLAY IN PROCESSING PAGE
-- exec [USP_GetInlineAttachmentList] 835
*/

CREATE PROCEDURE [dbo].[USP_GetInlineAttachmentList]
(
	@CONVERSATIONID AS BIGINT
)
AS

BEGIN

SELECT 	EA.ATTACHMENTID	,EA.FILENAME ,EA.CONTENT ,AT.ATTACHMENTTYPE ,EA.CREATEDDATE
FROM 
EMAILATTACHMENT EA
LEFT JOIN ATTACHMENTTYPE AT ON EA.ATTACHMENTTYPEID=AT.ATTACHMENTTYPEID
WHERE EA.ConversationID=@CONVERSATIONID and (EA.AttachmentTypeID =3 or EA.AttachmentTypeID=4) 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetLocked]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : Varma
* CREATED DATE : 07/20/2016
* PURPOSE : TO GET THE LIST OF Locked mailboxes
-- exec [USP_GetLocked]
*/
CREATE PROCEDURE  [dbo].[USP_GetLocked]             

AS            

BEGIN            

 SET NOCOUNT ON;  

select emld.EMailId,em.EMailBoxAddress , CASE WHEN  emld.islocked=1 THEN 'Yes' ELSE  'No' END AS ISLOCKED 

from [dbo].[EmailBoxLoginDetail] emld join [EMailBox] em on emld.EmailBoxLoginDetailId=em.EmailBoxLoginDetailId

where emld.islocked=1

END




GO
/****** Object:  StoredProcedure [dbo].[USP_GetMailSentDataForRemainderMailTrigger]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROC [dbo].[USP_GetMailSentDataForRemainderMailTrigger]
(
  @CASEID BIGINT
)
AS
BEGIN

select CaseId, EmailTo, EMailCC  from EMailSent where caseid=@CASEID   

END






GO
/****** Object:  StoredProcedure [dbo].[USP_GetManualCaseStatus]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SaranyaDevi C
-- Create date: 26-Jul-2017
-- Description:	Return Status Transitions based on SubProcessId and UserRoleId
-- =============================================

--exec USP_GetStatusTransitionBySubProcessIdAndRoleId 1,4 
CREATE PROCEDURE [dbo].[USP_GetManualCaseStatus]
	(
	@EmailBoxId int
	)
AS
BEGIN
	
	SET NOCOUNT ON;
	declare @SubProcessId int
	set @SubProcessId = (Select SubProcessGroupId from emailbox where emailboxid =@EmailBoxId);
	if exists(Select StatusId from dbo.Status where SubProcessID=@SubProcessId)
	Select StatusId,StatusDescription from dbo.Status where IsActive=1 and isshowninmanual='1' and SubProcessId =@SubProcessId
	else
	Select StatusId,StatusDescription from dbo.Status where IsActive=1 and isshowninmanual='1' and SubProcessId is null
    
    
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetManualCaseTemplate]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SaranyaDevi C
-- Create date: 26-Jul-2017
-- Description:	Return Status Transitions based on SubProcessId and UserRoleId
-- =============================================

--exec USP_GetStatusTransitionBySubProcessIdAndRoleId 1,4 
CREATE PROCEDURE [dbo].[USP_GetManualCaseTemplate]
	(
	@EmailBoxid int
	)
AS
BEGIN
	
	SET NOCOUNT ON;

	
	select TemplateId,TemplateCategory from dbo.[dbo.ManualCaseTemplateConfiguration] where IsActive=1 and Emailboxid=@EmailBoxid and TemplateType='1';
    
    
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetNextScreenshotNumber]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------
--	Author	: Varma
--	Date	: 20 Jul 2016
--	Description	: Get maxnumber for next inline attachment
--	exec USP_GetNextScreenshotNumber 392538
-----------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetNextScreenshotNumber]
	@CaseId bigint,
	@AttachmentType int
AS
BEGIN

declare @lastFilename varchar(max)
	if exists(SELECT * from EMailAttachment where caseid=@CaseId and AttachmentTypeID=@AttachmentType  and IsDeleted=0)
		begin 
			select top 1 @lastFilename=replace(replace(replace(replace(replace(replace(Filename,'cid:',''),'image',''),'.png',''),'.gif',''),'.jpg',''),'.jpeg','') from EMailAttachment 
			where caseid=@CaseId and AttachmentTypeID=@AttachmentType and IsDeleted=0 order by AttachmentID desc
					
			--select @lastFilename=replace(replace(replace(replace(replace(replace(Filename,'cid:',''),'image',''),'.png',''),'.gif',''),'.jpg',''),'.jpeg','') from EMailAttachment 
			--where AttachmentID =(select max(AttachmentID) from EMailAttachment where caseid=@CaseId and AttachmentTypeID=@AttachmentType and IsDeleted=0)
			----	set @lastFilename=replace(replace(replace(replace(replace(@lastFilename,'cid:image', ''),'.png',''),'.gif',''),'.jpg',''),'.jpeg','')
		end
	--else if exists(SELECT * from EMailAttachment where caseid=@CaseId and AttachmentTypeID in (3,4) and IsDeleted=0)
	--	begin 
	--		select top 1 @lastFilename=replace(replace(replace(replace(replace(replace(Filename,'cid:',''),'image',''),'.png',''),'.gif',''),'.jpg',''),'.jpeg','') from EMailAttachment 
	--		where caseid=@CaseId and AttachmentTypeID in (3,4) and IsDeleted=0 order by AttachmentID desc
	--	end
	if(cast(@lastFilename as int) is not null)
		begin 
			select cast(@lastFilename as int)+1 AS 'MaxNo'
		end
	else
		begin 
			select 1
		end
END
--select * from EMailAttachment where caseid=835 and AttachmentTypeID=3
GO
/****** Object:  StoredProcedure [dbo].[USP_GetOptionvalue]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE proc [dbo].[USP_GetOptionvalue]   
@FieldmasterID int
      
As        
Begin        
Declare @Retval int         
BEGIN TRAN TXN_INSERT        




BEGIN TRY        
   
select @Retval = max(OptionValue) from [dbo].[Tbl_DefaultListValues] where FieldMasterId=@FieldmasterID

if	@Retval is null
begin
set @Retval=0
select @Retval as result
end	
select @Retval as result
END TRY        







            BEGIN CATCH        







                  GOTO HandleError1        







            END CATCH        







            IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT        







            RETURN 1        







      HandleError1:        







            IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT        







            RAISERROR('Error Insert table Tbl_FieldConfiguration', 16, 1)        







            RETURN -1        







        







        







        







End







GO
/****** Object:  StoredProcedure [dbo].[USP_GETOVERALLREPORT]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*



* CREATED BY : RAGUVARAN E



* CREATED DATE : 07/16/2014



* PURPOSE : TO GET THE OVERALL CASE DETAILS



*/

--exec [USP_GETOVERALLREPORT_test] '04-01-2015','04-25-2017',2,4,2,'+05:30','5'





CREATE PROCEDURE [dbo].[USP_GETOVERALLREPORT]
(
	@FROMDATE DATETIME,

	@TODATE DATETIME,

	@SUBPROCESSGROUPID INT,


	@COUNTRYID INT,



	@EMAILBOXID INT,
	
	@OFFSET VARCHAR(15),

	@CategoryID varchar(200)
)
AS
BEGIN
if (@CategoryID is not null) 
begin
	SELECT EM.CASEID

		,C.COUNTRY

		,SG.SUBPROCESSNAME

		,EB.EMAILBOXNAME

		,ISNULL(ECC.CATEGORY,'NA') as Category /*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/

		,CASE WHEN EM.ISMANUAL =1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS CASETYPE,
		
		EM.EMailFrom AS FROMMAILID

		--,CONVERT(VARCHAR, EM.CREATEDDATE, 103)+' '+CONVERT(VARCHAR, EM.CREATEDDATE, 108) AS CREATEDDATE

        ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET) as 'CreatedDate'

		,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS

		,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO

		--,CONVERT(VARCHAR, EM.COMPLETEDDATE, 103)+' '+CONVERT(VARCHAR, EM.COMPLETEDDATE, 108) AS COMPLETEDDATE
        ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) as 'COMPLETEDDATE'

		,EM.LASTCOMMENT
		--Pranay 18 January 2017 for adding Survey Response and Comments
		--,Em.SurveyResponse
		--,EM.SurveyComments
		--,Case when SVD.VOC_Quality='Y' then 'Yes' else 'No' END AS VOC_Quality
		,SVD.VOC_Quality
		,SVD.VOC_Reason
		--,Case when SVD.VOC_TurnaroundTime='Y' then 'Yes' else 'No' END as VOC_TurnaroundTime
		,SVD.VOC_TurnaroundTime
		,SVD.VOC_TAT_Reason
		,SVD.Comments
	FROM EMAILMASTER EM WITH (NOLOCK) 
		LEFT JOIN  SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID

	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID

	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID

	JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId/*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/

	join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 

	WHERE EM.STATUSID NOT IN (6)

	--AND EM.CREATEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.CREATEDDATE <= (@TODATE + 1))

AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) >= @FROMDATE AND (@TODATE IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) <= (@TODATE + 1))

	AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))

	AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))

	AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))

end
else
begin
	SELECT EM.CASEID

		,C.COUNTRY

		,SG.SUBPROCESSNAME

		,EB.EMAILBOXNAME

		,ISNULL(ECC.CATEGORY,'NA') as Category /*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/

		,CASE WHEN EM.ISMANUAL =1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS CASETYPE,
		
		EM.EMailFrom AS FROMMAILID

		--,CONVERT(VARCHAR, EM.CREATEDDATE, 103)+' '+CONVERT(VARCHAR, EM.CREATEDDATE, 108) AS CREATEDDATE

        ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET) as 'CreatedDate'

		,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS

		,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO

		--,CONVERT(VARCHAR, EM.COMPLETEDDATE, 103)+' '+CONVERT(VARCHAR, EM.COMPLETEDDATE, 108) AS COMPLETEDDATE
        ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) as 'COMPLETEDDATE'

		,EM.LASTCOMMENT

	FROM EMAILMASTER EM WITH (NOLOCK) 

	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID

	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID

	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID

	left JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId/*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/
	
	WHERE EM.STATUSID NOT IN (6)

	--AND EM.CREATEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.CREATEDDATE <= (@TODATE + 1))

AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) >= @FROMDATE AND (@TODATE IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) <= (@TODATE + 1))

	AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))

	AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))

	AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))

end

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GETOVERALLREPORT_dynamicchanges]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*



* CREATED BY : RAGUVARAN E



* CREATED DATE : 07/16/2014



* PURPOSE : TO GET THE OVERALL CASE DETAILS



*/

--exec [USP_GETOVERALLREPORT_test] '04-01-2015','04-25-2017',2,4,2,'+05:30','5'





CREATE PROCEDURE [dbo].[USP_GETOVERALLREPORT_dynamicchanges]
(
	@FROMDATE DATETIME,

	@TODATE DATETIME,

	@SUBPROCESSGROUPID INT,

	@COUNTRYID INT,

	@EMAILBOXID INT,
	
	@OFFSET VARCHAR(15),

	@CategoryID varchar(200)
)
AS
BEGIN

declare @SubProcessID nvarchar(max)
set @SubProcessID=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMAILBOXID)

if (@CategoryID is not null) 
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	SELECT EM.CASEID

	,C.COUNTRY

	,SG.SUBPROCESSNAME

	,EB.EMAILBOXNAME

	,ISNULL(ECC.CATEGORY,'NA') as Category /*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/

	,CASE WHEN EM.ISMANUAL =1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS CASETYPE,
		
	EM.EMailFrom AS FROMMAILID		

    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET) as 'CreatedDate'

	,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS

	,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO
		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) as 'COMPLETEDDATE'

	,EM.LASTCOMMENT
		--Pranay 18 January 2017 for adding Survey Response and Comments
		--,Em.SurveyResponse
		--,EM.SurveyComments
		--,Case when SVD.VOC_Quality='Y' then 'Yes' else 'No' END AS VOC_Quality
	,SVD.VOC_Quality
	,SVD.VOC_Reason
		--,Case when SVD.VOC_TurnaroundTime='Y' then 'Yes' else 'No' END as VOC_TurnaroundTime
	,SVD.VOC_TurnaroundTime
	,SVD.VOC_TAT_Reason
	,SVD.Comments
	FROM EMAILMASTER EM WITH (NOLOCK) 
	LEFT JOIN  SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID
	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID
	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID and STATUS.SubProcessID=SG.SubProcessGroupId
	JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId/*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/
	join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 

	WHERE EM.STATUSID NOT IN (select StatusId from Status where IsIgnored=1 and SubProcessID =@SubProcessID)

	--AND EM.CREATEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.CREATEDDATE <= (@TODATE + 1))

	AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) >= @FROMDATE AND (@TODATE IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) <= (@TODATE + 1))

	AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))

	AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))

	AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))
end
else
begin
	SELECT EM.CASEID

	,C.COUNTRY

	,SG.SUBPROCESSNAME

	,EB.EMAILBOXNAME

	,ISNULL(ECC.CATEGORY,'NA') as Category /*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/

	,CASE WHEN EM.ISMANUAL =1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS CASETYPE,
		
	EM.EMailFrom AS FROMMAILID		

    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET) as 'CreatedDate'

	,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS

	,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO
		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) as 'COMPLETEDDATE'

	,EM.LASTCOMMENT
		--Pranay 18 January 2017 for adding Survey Response and Comments
		--,Em.SurveyResponse
		--,EM.SurveyComments
		--,Case when SVD.VOC_Quality='Y' then 'Yes' else 'No' END AS VOC_Quality
	,SVD.VOC_Quality
	,SVD.VOC_Reason
		--,Case when SVD.VOC_TurnaroundTime='Y' then 'Yes' else 'No' END as VOC_TurnaroundTime
	,SVD.VOC_TurnaroundTime
	,SVD.VOC_TAT_Reason
	,SVD.Comments
	FROM EMAILMASTER EM WITH (NOLOCK) 
	LEFT JOIN  SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID
	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID
	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID
	JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId/*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/
	join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 

	WHERE EM.STATUSID NOT IN (select StatusId from Status where IsIgnored=1 and SubProcessID is null)

	--AND EM.CREATEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.CREATEDDATE <= (@TODATE + 1))

	AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) >= @FROMDATE AND (@TODATE IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) <= (@TODATE + 1))

	AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))

	AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))

	AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))

end	
end
else
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	SELECT EM.CASEID

	,C.COUNTRY

	,SG.SUBPROCESSNAME

	,EB.EMAILBOXNAME

	,ISNULL(ECC.CATEGORY,'NA') as Category /*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/

	,CASE WHEN EM.ISMANUAL =1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS CASETYPE,
		
	EM.EMailFrom AS FROMMAILID		

    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET) as 'CreatedDate'

	,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS

	,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO
		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) as 'COMPLETEDDATE'

	,EM.LASTCOMMENT

	FROM EMAILMASTER EM WITH (NOLOCK) 

	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID

	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID

	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID and STATUS.SubProcessID=SG.SubProcessGroupId 

	left JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId/*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/
	
	WHERE EM.STATUSID NOT IN (select StatusId from Status where IsIgnored=1 and SubProcessID=@SubProcessID)	

	AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) >= @FROMDATE AND (@TODATE IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) <= (@TODATE + 1))

	AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))

	AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))

	AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))
end
else
begin
	SELECT EM.CASEID

	,C.COUNTRY

	,SG.SUBPROCESSNAME

	,EB.EMAILBOXNAME

	,ISNULL(ECC.CATEGORY,'NA') as Category /*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/

	,CASE WHEN EM.ISMANUAL =1 THEN 'MANUAL CASE' ELSE 'EMAIL CASE' END AS CASETYPE,
		
	EM.EMailFrom AS FROMMAILID		

    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET) as 'CreatedDate'

	,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS

	,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO
		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) as 'COMPLETEDDATE'

	,EM.LASTCOMMENT

	FROM EMAILMASTER EM WITH (NOLOCK) 

	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID

	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID

	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID

	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID

	left JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId/*--Nagababu merge SP Relate to stackland servey POC--adding Category in Overall Report*/
	
	WHERE EM.STATUSID NOT IN (select StatusId from Status where IsIgnored=1  and SubProcessID is null)	

	AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) >= @FROMDATE AND (@TODATE IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),@Offset) <= (@TODATE + 1))

	AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))

	AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))

	AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))
end	
end

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GETOVERALLREPORT_dynamicchanges_dynamicSP]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*



* CREATED BY : RAGUVARAN E



* CREATED DATE : 07/16/2014



* PURPOSE : TO GET THE OVERALL CASE DETAILS



*/

--exec [USP_GETOVERALLREPORT_dynamicchanges_dynamicSP] '01-09-2017','09-22-2017','6','4','11','+05:30',''





CREATE PROCEDURE [dbo].[USP_GETOVERALLREPORT_dynamicchanges_dynamicSP]
(
	@FROMDATE DATETIME,

	@TODATE DATETIME,

	@SUBPROCESSGROUPID INT,

	@COUNTRYID INT,

	@EMAILBOXID INT,
	
	@OFFSET VARCHAR(15),

	@CategoryID varchar(200)
)
AS
BEGIN

declare @SubProcessID nvarchar(max)
set @SubProcessID=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMAILBOXID)

declare @dyColumn as nvarchar(max)
	If((Select IsVOCSurvey from emailbox where EMailBoxId = @EMAILBOXID) = 1)
		Begin
			set @dyColumn= ',EM.LASTCOMMENT,SVD.VOC_Quality,SVD.VOC_Reason,SVD.VOC_TurnaroundTime,SVD.VOC_TAT_Reason,SVD.Comments'
		End
	else
		Begin
			set @dyColumn= ',EM.LASTCOMMENT'
		END

--start dynamic fields
		if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'ReportResults'
			   )
	begin
			drop table ReportResults
	end 

		declare @cols AS NVARCHAR(MAX)		
select @cols = STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) 
                    from dbo.Tbl_FieldConfiguration FC 					 							 
				where FC.Active='1' and FC.MailBoxID=@EMAILBOXID                 
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @cols

		declare @colsCreateTable as NVARCHAR(Max)
		declare @queryDBReportsResult as NVArchar(max)
select @colsCreateTable=STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) +' NVARCHAR(max)'
                    from dbo.Tbl_FieldConfiguration FC 
					left join  dbo.Tbl_ClientTransaction CT  on CT.FieldMasterId=FC.FieldMasterId
								 
				where FC.Active=1 and FC.MailBoxID= @EMAILBOXID 
                    group by FC.FieldName
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		set @queryDBReportsResult='Create table ReportResults(CaseId bigint,'+@colsCreateTable+')'
		 print @queryDBReportsResult
		 exec sp_executesql @queryDBReportsResult

		declare @queryDB  AS NVARCHAR(MAX)
set @queryDB = N'insert into ReportResults(CaseId,'+@cols+') SELECT CaseID,' + @cols + N' from 
             (
                
				select CaseID, FieldValue, FC.FieldName
                from dbo.Tbl_ClientTransaction CT 
				inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 				 
				where FC.MailBoxID='+CONVERT(VARCHAR(50),@EMAILBOXID)+' and FC.Active=''1''				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldName in (' + @cols + N')
            ) p '
print @queryDB 
 exec sp_executesql @queryDB
 --end of Dynamic fields
--select * from ReportResults;
if (@CategoryID is not null) 
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	exec('SELECT EM.CASEID
	,C.COUNTRY
	,SG.SUBPROCESSNAME
	,EB.EMAILBOXNAME
	,ISNULL(ECC.CATEGORY,''NA'') as Category
	,CASE WHEN EM.ISMANUAL =1 THEN ''MANUAL CASE'' ELSE ''EMAIL CASE'' END AS CASETYPE,		
	 EM.EMailFrom AS FROMMAILID		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+''') as ''CreatedDate''
	,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS
	,UM.FIRSTNAME+'', ''+UM.LASTNAME AS ASSIGNEDTO		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''') as ''COMPLETEDDATE'''
	+@dyColumn+	
	','+@cols+
	' FROM EMAILMASTER EM WITH (NOLOCK) 
	LEFT JOIN  SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID
	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID
	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID and STATUS.SubProcessID=SG.SubProcessGroupId
	JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId
	left join ReportResults  RR on EM.CaseId=RR.CaseId
	join dbo.ConvertDelimitedListIntoTable('''+@CategoryID+''','','') arr ON EM.Categoryid= arr.Item 
	WHERE EM.STATUSID NOT IN (6)
	AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),'''+@Offset+''') >= '''+@FROMDATE+''' AND ('''+@TODATE+''' IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),'''+@Offset+''') <= DATEADD(Day,1,'''+@TODATE+'''))
	AND (('''+@SubProcessID+''' IS NULL) OR (SG.SUBPROCESSGROUPID='''+@SubProcessID+'''))
	AND (('''+@COUNTRYID+''' IS NULL) OR (EB.COUNTRYID='''+@COUNTRYID+'''))
	AND (('''+@EMAILBOXID+''' IS NULL) OR (EM.EMAILBOXID='''+@EMAILBOXID+'''))')
end
else
begin
	exec('SELECT EM.CASEID
	,C.COUNTRY
	,SG.SUBPROCESSNAME
	,EB.EMAILBOXNAME
	,ISNULL(ECC.CATEGORY,''NA'') as Category
	,CASE WHEN EM.ISMANUAL =1 THEN ''MANUAL CASE'' ELSE ''EMAIL CASE'' END AS CASETYPE,		
	 EM.EMailFrom AS FROMMAILID
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+''') as ''CreatedDate''
	,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS
	,UM.FIRSTNAME+'', ''+UM.LASTNAME AS ASSIGNEDTO		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''') as ''COMPLETEDDATE'''
	+@dyColumn+	
	','+@cols+' FROM EMAILMASTER EM WITH (NOLOCK) 
	LEFT JOIN  SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID
	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID
	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID
	JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId
	left join ReportResults  RR on EM.CaseId=RR.CaseId
	join dbo.ConvertDelimitedListIntoTable('''+@CategoryID+''','','') arr ON EM.Categoryid= arr.Item 
	WHERE EM.STATUSID NOT IN (6)
	AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),'''+@Offset+''') >= '''+@FROMDATE+''' AND ('''+@TODATE+''' IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),'''+@Offset+''') <= DATEADD(Day,1,'''+@TODATE+'''))
	AND (('''+@SubProcessID+''' IS NULL) OR (SG.SUBPROCESSGROUPID='''+@SubProcessID+'''))
	AND (('''+@COUNTRYID+''' IS NULL) OR (EB.COUNTRYID='''+@COUNTRYID+'''))
	AND (('''+@EMAILBOXID+''' IS NULL) OR (EM.EMAILBOXID='''+@EMAILBOXID+'''))')
end	
end
else
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	exec('SELECT EM.CASEID
	,C.COUNTRY
	,SG.SUBPROCESSNAME
	,EB.EMAILBOXNAME
	,ISNULL(ECC.CATEGORY,''NA'') as Category 
	,CASE WHEN EM.ISMANUAL =1 THEN ''MANUAL CASE'' ELSE ''EMAIL CASE'' END AS CASETYPE,		
	 EM.EMailFrom AS FROMMAILID		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+''') as ''CreatedDate''
	,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS
	,UM.FIRSTNAME+'', ''+UM.LASTNAME AS ASSIGNEDTO		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''') as ''COMPLETEDDATE'''
	+@dyColumn+
	','+@cols+' FROM EMAILMASTER EM WITH (NOLOCK) 
	LEFT JOIN  SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID
	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID
	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID and STATUS.SubProcessID=SG.SubProcessGroupId 
	left JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId
	left join ReportResults  RR on EM.CaseId=RR.CaseId
	WHERE EM.STATUSID NOT IN (6)	
	AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),'''+@Offset+''') >= '''+@FROMDATE+''' AND ('''+@TODATE+''' IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),'''+@Offset+''') <= DATEADD(Day,1,'''+@TODATE+'''))
	AND (('''+@SubProcessID+''' IS NULL) OR (SG.SUBPROCESSGROUPID='''+@SubProcessID+'''))
	AND (('''+@COUNTRYID+''' IS NULL) OR (EB.COUNTRYID='''+@COUNTRYID+'''))
	AND (('''+@EMAILBOXID+''' IS NULL) OR (EM.EMAILBOXID='''+@EMAILBOXID+'''))')
	end
else
begin
	exec('SELECT EM.CASEID
	,C.COUNTRY
	,SG.SUBPROCESSNAME
	,EB.EMAILBOXNAME
	,ISNULL(ECC.CATEGORY,''NA'') as Category 
	,CASE WHEN EM.ISMANUAL =1 THEN ''MANUAL CASE'' ELSE ''EMAIL CASE'' END AS CASETYPE,		
	EM.EMailFrom AS FROMMAILID		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+''') as ''CreatedDate''
	,STATUS.STATUSDESCRIPTION AS CURRENTSTATUS
	,UM.FIRSTNAME+'', ''+UM.LASTNAME AS ASSIGNEDTO		
    ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''') as ''COMPLETEDDATE'''
	+@dyColumn+
	','+@cols+
	' FROM EMAILMASTER EM WITH (NOLOCK) 
	LEFT JOIN  SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID
	LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID
	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
	LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID
	LEFT JOIN STATUS ON STATUS.STATUSID=EM.STATUSID
	left JOIN  EmailboxCategoryConfig ECC On ECC.EmailboxCategoryId=EM.CategoryId
	left join ReportResults  RR on EM.CaseId=RR.CaseId
	WHERE EM.STATUSID NOT IN (6)	
	AND SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),'''+@Offset+''') >='''+@FROMDATE+''' AND ('''+@TODATE+''' IS NULL OR SWITCHOFFSET(CONVERT(datetimeoffset,EM.CREATEDDATE),'''+@Offset+''') <= DATEADD(Day,1,'''+@TODATE+'''))
	AND (('''+@SubProcessID+''' IS NULL) OR (SG.SUBPROCESSGROUPID='''+@SubProcessID+'''))
	AND (('''+@COUNTRYID+''' IS NULL) OR (EB.COUNTRYID='''+@COUNTRYID+'''))
	AND (('''+@EMAILBOXID+''' IS NULL) OR (EM.EMAILBOXID='''+@EMAILBOXID+'''))')
end	
end
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetPreviousStatusID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================              
-- Author:  <SAKTHI>              
-- Create date: <28/05/2014>              
-- Description: <TO GET CASE AUDIT LOG >              
-- =============================================   
CREATE PROC [dbo].[USP_GetPreviousStatusID]
(
  @CASEID BIGINT
)
AS
BEGIN

 select Top 1 (EA.FromStatusID) as 'StatusId',S.StatusDescription from EMAILAUDIT EA
 inner join [Status] S on EA.FromStatusID=S.StatusId where CaseID=@CASEID order by EMAILAUDITID desc
 
END


GO
/****** Object:  StoredProcedure [dbo].[USP_GetProcessorsForQC]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetProcessorsForQC]  
            
@CountryId varchar(50),  
@EmailBoxId varchar(50),
@LoggedInUserId varchar(20)  
            
AS            
BEGIN             
SET NOCOUNT ON;            
  
SELECT UM.USERID , UM.FIRSTNAME +' '+ UM.LASTNAME +' ( '+  UM.USERID + ' ) ' USERNAME FROM USERMASTER UM   
JOIN USERMAILBOXMAPPING UMBM ON UM.USERID= UMBM.USERID  
JOIN EMAILBOX EB ON EB.EMAILBOXID = UMBM.MAILBOXID  
JOIN COUNTRY C ON EB.COUNTRYID= C.COUNTRYID   
WHERE C.COUNTRYID = @CountryId AND EB.EMAILBOXID =@EmailBoxId AND UM.USERID <> @LoggedInUserId
AND  UM.ISACTIVE=1 AND C.ISACTIVE=1 AND EB.ISACTIVE=1  
             
END   
  






GO
/****** Object:  StoredProcedure [dbo].[USP_GetProductLicenseKey]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetProductLicenseKey] 
(
  @Clientname varchar(max)
)
AS
 
BEGIN

SELECT LicenseKey from  ProductLicense where Clientname=@Clientname


END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetQCWorkQueue]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_GetQCWorkQueue]          
 (              
 @QCUSERID AS VARCHAR(20)    
 )              
AS              
BEGIN 
            
    
----------------------------------------------- QC USERID IS NOT  NULL ----------------------------------------------------------------               
SELECT EM.CASEID, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,   
EM.Subject, CASE WHEN em.IsUrgent=1 THEN 'High' ELSE 'Low' END IsUrgent,  UM.USERID, UM.FIRSTNAME + ' ' + UM.LASTNAME + ' (' + UM.USERID + ')'  AS USERNAME,   
SM.StatusDescription AS STATUSDESCRIPTION, SM.STATUSID, EMailboxId    
    
FROM EMAILMASTER EM    
JOIN USERMASTER UM ON UM.USERID= EM.AssignedToId    
JOIN STATUS SM ON EM.STATUSID = SM.STATUSID    
WHERE EM.QCUserId =@QCUSERID AND SM.STATUSID in (select StatusId from dbo.Status where IsQCPending='1') 
   
    
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_GetRandomCasesForSurvey]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_GetRandomCasesForSurvey]
As
BEGIN
SET NOCOUNT ON;
Select top 20 percent em.CaseId,em.EMailReceivedDate,em.IsManual,
case when em.ismanual=0 then em.EMailFrom when em.ismanual=1 then em.EMailTo end [TO],
case when em.ismanual=0 then eb.EMailBoxAddress when em.ismanual=1 then em.EMailFrom end [FROM]
,em.Subject,em.EMailBoxId,em.StatusId,em.CompletedDate,em.IsSurveySent,eb.IsVOCSurvey,ebl.EMailId [EMailboxLoginId],ebl.Password [EMailboxLoginPassword],eb.EMailFolderPath [ServiceURL] from dbo.EmailMaster em 
inner join 
dbo.EMailBox eb on eb.EMailBoxId=em.EMailBoxId and eb.IsLocked=0
inner join  EmailBoxLoginDetail ebl on eb.EMailboxLoginDetailId = ebl.EMailboxLoginDetailId and ebl.IsActive=1
where em.CompletedDate is not null and DATEDIFF(DAY,em.CompletedDate,GETDATE()) <=7
and em.IsSurveySent is null 
and em.StatusId=10 order by NEWID()
END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetSearchCaseList]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_GetSearchCaseList

CREATE PROCEDURE [dbo].[USP_GetSearchCaseList] --exec USP_GetSearchCaseList '2','1','','','1,2',''            

(             

@CountryId int = null,             

@EMailboxId int = null,              

@ReceivedFrom datetime = null,            

@ReceivedTo datetime = null,            

@CaseId varchar(40) = null,            

@StatusId int = null,

@CaseSubject varchar(max) =null,

@FromEmail varchar(max)=null,

@RoleId int = null,

@LoginUserId varchar(50) = null,

@FlagCriteria int = null

-- @OFFSET VARCHAR(30))            
)
AS                        

	BEGIN                         

		declare @CaseIdTemp varchar(40)            

		declare @StatusIdTemp int            

		declare @ReceivedFromTemp datetime            

		declare @ReceivedToTemp datetime            

        declare @OFFSET VARCHAR(30)  
		
		
		select @OFFSET = Offset from UserMaster where UserId=@LoginUserId 
		SET NOCOUNT ON;                   

			if(@CaseId='')                 

				 begin            

				  set @CaseIdTemp = null             

				 end            

			else            

				 begin            

				  set @CaseIdTemp = @CaseId             

				 end            



		if(@StatusId='')                 

			 begin            

			  set @StatusIdTemp = null             

			 end            

		else            

			 begin            

			  set @StatusIdTemp = @StatusId             

			 end      

		 

		 if(@RoleId=1 or @RoleId=2 or @RoleId=5)

		 (      

		SELECT em.CaseId,em.EMailFrom,		

		[dbo].[ChangeDatesAsPerUserTimeZone](EM.EmailReceivedDate,@OFFSET) [ReceivedDate],             

		em.Subject, Case when  um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' IS NULL then 'N/A'           

		else um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' end AssignedTo,             

		CASE WHEN em.IsUrgent=1 THEN 'High' ELSE 'Low' END as Priority, s.statusid as StatusId, s.StatusDescription Status, Cy.Country, eb.EmailboxId, eb.EmailboxName,       

		case when EB.ISACTIVE=0 then 'No' else 'Yes' end ISACTIVE ,

		Case when FCM.CreatedbyId IS Null then 'N/A' else (select firstname +' ' + lastname+' ('+userid+')' from usermaster where UserId in (FCM.CreatedbyId)) end FlaggedBY,

		Case when FCM.IsActive=1 Then 'Yes' ELSE 'No' END ISFlagged   ,

		Case when FCM.CreatedbyId IS Null then 'N/A' else FCM.CreatedbyId END FlaggedbyUserId     

		from EmailMaster em  WITH (NOLOCK) left join             

		UserMaster um  WITH (NOLOCK) on em.AssignedToId = um.UserId left JOIN             

		Emailbox eb  WITH (NOLOCK) on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join            

		Status s  WITH (NOLOCK) on em.StatusId = s.StatusId            

		left join Country Cy  WITH (NOLOCK) on  CY.countryId=eb.CountryId

		left join FlagCaseMaster FCM on FCM.CaseId = em.CaseId  AND FCM.IsActive=1        

		WHERE (eb.CountryId = @CountryId OR @CountryId IS NULL)            

		AND (eb.EmailboxId = @EMailboxId OR @EMailboxId IS NULL)            

		AND ((CAST(CONVERT(varchar(11), em.EmailReceivedDate) AS DATETIME) BETWEEN @ReceivedFrom AND @ReceivedTo) OR (@ReceivedFrom IS NULL AND @ReceivedTo IS NULL))               

		AND (em.CaseId in (select * from SplitCaseID(@CaseIdTemp, ',') ) OR @CaseIdTemp IS NULL)            

		AND (em.StatusId = @StatusIdTemp OR @StatusIdTemp IS NULL)             

		AND (em.Subject like '%'+@CaseSubject+'%' or @CaseSubject is null)

		AND (em.EMailFrom =@FromEmail or @FromEmail is null)   

		AND (FCM.Reference =@FlagCriteria or @FlagCriteria IS NULL) 

		)

		Else if(@RoleId=3 or @RoleId=4)

		(

		SELECT em.CaseId,em.EMailFrom,
        [dbo].[ChangeDatesAsPerUserTimeZone]( em.EmailReceivedDate,@OFFSET) [ReceivedDate],
		--CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) [ReceivedDate],             

		em.Subject, Case when  um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' IS NULL then 'N/A'           

		else um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' end AssignedTo,             

		CASE WHEN em.IsUrgent=1 THEN 'High' ELSE 'Low' END as Priority, s.statusid as StatusId, s.StatusDescription Status, Cy.Country, eb.EmailboxId, eb.EmailboxName,       

		case when EB.ISACTIVE=0 then 'No' else 'Yes' end ISACTIVE,

		Case when FCM.CreatedbyId IS Null then 'N/A' else (select firstname +' ' + lastname+' ('+userid+')' from usermaster where UserId in (FCM.CreatedbyId)) end FlaggedBY,

		Case when FCM.IsActive=1 Then 'Yes' ELSE 'No' END ISFlagged   ,

		Case when FCM.CreatedbyId IS Null then 'N/A' else FCM.CreatedbyId END FlaggedbyUserId

		from EmailMaster em WITH (NOLOCK) left join             

		UserMaster um WITH (NOLOCK) on em.AssignedToId = um.UserId left JOIN             

		Emailbox eb WITH (NOLOCK) on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join            

		Status s  WITH (NOLOCK)on em.StatusId = s.StatusId            

		left join Country Cy WITH (NOLOCK) on  CY.countryId=eb.CountryId 

		left join FlagCaseMaster FCM on FCM.CaseId = em.CaseId  AND FCM.IsActive=1   

		WHERE (eb.CountryId = @CountryId OR @CountryId IS NULL)            

		AND (eb.EmailboxId = @EMailboxId OR @EMailboxId IS NULL)            

		AND ((CAST(CONVERT(varchar(11), em.EmailReceivedDate) AS DATETIME) BETWEEN @ReceivedFrom AND @ReceivedTo) OR (@ReceivedFrom IS NULL AND @ReceivedTo IS NULL))           

		AND (em.CaseId in (select * from SplitCaseID(@CaseIdTemp, ',') ) OR @CaseIdTemp IS NULL)            

		AND (em.StatusId = @StatusIdTemp OR @StatusIdTemp IS NULL)             

		AND (em.Subject like '%'+@CaseSubject+'%' or @CaseSubject is null)

		AND (em.EMailFrom =@FromEmail or @FromEmail is null)

		AND (em.EMailBoxId in (select distinct MailBoxId from dbo.UserMailBoxMapping where UserId=@LoginUserId))

		AND (FCM.Reference =@FlagCriteria or @FlagCriteria IS NULL)

		)               

	END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetSearchCaseList_Export_Excel]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_GetSearchCaseList

CREATE PROCEDURE [dbo].[USP_GetSearchCaseList_Export_Excel] --exec USP_GetSearchCaseList '1','21','','','',''      
(       
@CountryId int = null,       
@EMailboxId int = null,        
@ReceivedFrom datetime = null,      
@ReceivedTo datetime = null,      
@CaseId int = null,      
@StatusId int = null      
)      
AS                  
BEGIN                   
declare @CaseIdTemp int      
declare @StatusIdTemp int      
declare @ReceivedFromTemp datetime      
declare @ReceivedToTemp datetime      
SET NOCOUNT ON;             
if(@CaseId='')           
 begin      
  set @CaseIdTemp = null       
 end      
else      
 begin      
  set @CaseIdTemp = @CaseId       
 end      
       
if(@StatusId='')           
 begin      
  set @StatusIdTemp = null       
 end      
else      
 begin      
  set @StatusIdTemp = @StatusId       
 end      
      
SELECT em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 101) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,       
em.Subject, Case when  um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' IS NULL then 'N/A'     
else um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' end AssignedTo,       
CASE WHEN em.IsUrgent=1 THEN 'High' ELSE 'Low' END IsUrgent, s.StatusDescription Status, Cy.Country, eb.EmailboxName, s.Statusdescription,
case when EB.ISACTIVE=0 then 'No' else 'Yes' end ISACTIVE
from EmailMaster em left join       
UserMaster um on em.AssignedToId = um.UserId left JOIN       
Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join      
Status s on em.StatusId = s.StatusId      
left join Country Cy on  CY.countryId=eb.CountryId
WHERE (eb.CountryId = @CountryId OR @CountryId IS NULL)      
AND (eb.EmailboxId = @EMailboxId OR @EMailboxId IS NULL)      
AND ((CAST(CONVERT(varchar(11), em.EmailReceivedDate) AS DATETIME) BETWEEN @ReceivedFrom AND @ReceivedTo) OR (@ReceivedFrom IS NULL AND @ReceivedTo IS NULL))      
AND (em.CaseId = @CaseIdTemp OR @CaseIdTemp IS NULL)       
AND (em.StatusId = @StatusIdTemp OR @StatusIdTemp IS NULL)       
                  
END 

--select * from emailbox
--select * from status






GO
/****** Object:  StoredProcedure [dbo].[USP_GetSearchCaseList_Pagination]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [USP_GetSearchCaseList_Pagination] 4,2,Null,Null,Null,10,null,null,4,'195174',null,1,10,'caseid','Descending'
--select * from EmailBox

CREATE PROCEDURE [dbo].[USP_GetSearchCaseList_Pagination] 
(             
@CountryId int = null,             
@EMailboxId int = null,              
@ReceivedFrom datetime = null,            
@ReceivedTo datetime = null,            
@CaseId varchar(40) = null,            
@StatusId int = null,
@CaseSubject varchar(max) =null,
@FromEmail varchar(max)=null,
@RoleId int = null,
@LoginUserId varchar(50) = null,
@FlagCriteria int = null,
@PageIndex INT,
@PageSize INT,

@SortExpName varchar(40),
@SortExpOrder varchar(10))            
AS                        
	BEGIN       

		declare @query1 nvarchar(max)
		declare @SortQuery nvarchar(max)
		declare @query2 nvarchar(max)
		declare @Assignee nvarchar(max)
		declare @AssignQuery nvarchar(max)
		declare @query3 nvarchar(max)
		declare @query4 nvarchar(max)
		declare @query5 nvarchar(max)
		declare @RecordCount int

		
		DECLARE @TotalPagecount float
                  
		declare @CaseIdTemp nvarchar(1000)            
		declare @StatusIdTemp int
		declare @ReceivedFromTemp datetime            
		declare @ReceivedToTemp datetime   
		
		SET NOCOUNT ON;          
			--if(@SortExpName<>'FirstName')
			--	set @SortExpName='em.'+@SortExpName 
			--else 
			--	set @SortExpName='um.'+@SortExpName 
  
         
			   
		 
		 --if(@RoleId=1 or @RoleId=2 or @RoleId=5)
		 --begin  
			set @query1='select ROW_NUMBER() OVER('
			--print @query1
			IF(@SortExpName is null)
				Begin 
					set @SortQuery='ORDER BY em.IsUrgent desc,em.EmailReceivedDate desc '-- +','+ @SortExpName +' '+ @SortExpOrder
				End
			ELSE
				Begin
					IF(@SortExpOrder='Ascending')
						SET @SortExpOrder='ASC'
					ELSE
						SET @SortExpOrder='DESC'


					if (lower(@SortExpName)='caseid' or lower(@SortExpName)='EmailReceivedDate' or lower(@SortExpName)='subject')
					begin 
						set @SortExpName='em.'+@SortExpName
					end 
					set @SortQuery='ORDER BY '+ @SortExpName +' '+ @SortExpOrder
					
				End
				--print @SortQuery
			set @query2=')AS RowNumber, em.CaseId,em.EmailFrom, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.Subject, '
			--print @query2
			
			if(@StatusId=1)
				begin 
					set @query3=''
					set @Assignee='''NA'''
		
				end 

			 else if (@StatusId is null)
				BEGIN
					set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''
					set @query3=' left join UserMaster um WITH (NOLOCK) on em.AssignedToId = um.UserId'

		
					IF(@LoginUserId <> '0')      
						begin 
							SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoginUserId)+''
						end 
				END
			 else
				begin 
					set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''
					set @query3=' left join UserMaster um WITH (NOLOCK) on em.AssignedToId = um.UserId'

		
					IF(@LoginUserId <> '0')      
						begin 
							SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoginUserId)+''
						end 
				end 
					
				--print @Assignee
			set @AssignQuery=' AssignedTo,             
		CASE WHEN em.IsUrgent=1 THEN ''High'' ELSE ''Low'' END as Priority, s.statusid as StatusId, s.StatusDescription Status, Cy.Country, eb.EmailboxId, eb.EmailboxName,       
		case when EB.ISACTIVE=0 then ''No'' else ''Yes'' end ISACTIVE, 
		
Case when FCM.CreatedbyId IS Null then ''N/A'' else (select firstname +'' '' + lastname+'' (''+userid+'')'' from usermaster where UserId in (FCM.CreatedbyId)) end FlaggedBY,
Case when FCM.IsActive=1 Then ''Yes'' ELSE ''No'' END ISFlagged,
Case when FCM.CreatedbyId IS Null then ''N/A'' else FCM.CreatedbyId END FlaggedbyUserId,
em.SkillDescription as ''Skill''

			from EmailMaster em with (nolock)
			left join Emailbox eb WITH (NOLOCK) on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 
			inner join [Status] s WITH (NOLOCK) on em.StatusId = s.StatusId 
			left join Country Cy WITH (NOLOCK) on  CY.countryId=eb.CountryId 
			left join FlagCaseMaster FCM on FCM.CaseId = em.CaseId  AND FCM.IsActive=1  '
			+ @query3 
			          
			

			--print @AssignQuery

				--AND ((CAST(CONVERT(varchar(11), em.EmailReceivedDate) AS DATETIME) BETWEEN '+ convert(varchar(max), @ReceivedFrom)+' AND 
				--'+ convert(varchar(max), @ReceivedTo)+') OR ('+ convert(varchar(max), @ReceivedFrom)+'
				-- IS NULL AND '+ convert(varchar(max), @ReceivedTo)+' IS NULL))  
				--'+ @CaseIdTemp+ ' 
				declare @LikeQuery as nvarchar(max)  
				declare @FromEmailQuery as nvarchar(max)
				declare @dateQuery as nvarchar(max)
				declare @statusQuery as nvarchar(max)
				declare @FlagQuery as nvarchar(max)

				if(@CaseSubject is null)
					SET @LikeQuery=N' '
				else
					SET @LikeQuery=N'AND (em.Subject like ''%'+ convert(varchar, @CaseSubject)+'%'' or '''+ convert(varchar, @CaseSubject)+''' is null) '

				if(@FromEmail is null)
					SET @FromEmailQuery=N' '
				else
					SET @FromEmailQuery=N'AND (em.EMailFrom ='''+ @FromEmail+''' or '''+@FromEmail+''' is null) '

			if(@CaseId is null)                 
				 begin            
				  set @CaseIdTemp = N' ' 
				              
				 end            
			else            
				 begin            
				  --set @CaseIdTemp = @CaseId             
				  set @CaseIdTemp= N' AND (em.CaseId in (select * from SplitCaseID('''+ convert(varchar, @CaseId) +''', '','') ) ) ' 
				  --print @CaseIdTemp
				 end   

			if(@ReceivedFrom is null or convert(varchar(11),@ReceivedFrom) = ('Jan  1 1900'))
				SET @dateQuery=N' '
			else
				BEGIN
					SET @dateQuery=N' AND ((CAST(CONVERT(varchar(11), em.EmailReceivedDate) AS DATETIME) BETWEEN '''+ convert(varchar(11), @ReceivedFrom)+''' AND 
					'''+ convert(varchar(11), @ReceivedTo)+''')) '
				END

			--print @dateQuery
			if(@StatusId is null)                 
				 begin            
				  set @statusQuery = N' '             
				 end            
			else            
				 begin            
				 --AND (eb.EmailboxId = '+ convert(varchar, @EMailboxId)+' OR '+ convert(varchar, @EMailboxId)+' IS NULL) '
					set @statusQuery = N' AND (em.StatusId = '+ convert(varchar,@StatusId)+' ) '
				  end

			if(@FlagCriteria is null)                 
				 begin            
				  set @FlagQuery = N' '             
				 end            
			else            
				 begin            
					set @FlagQuery = N' AND FCM.Reference = '+ convert(varchar,@FlagCriteria)+'  '
				  end
 


			declare @EmailboxQuery as nvarchar(max)

			if(@EMailboxId is null)                 
				 begin            
				  set @EmailboxQuery = N' '             
				 end            
			else            
				 begin            
				 --AND (eb.EmailboxId = '+ convert(varchar, @EMailboxId)+' OR '+ convert(varchar, @EMailboxId)+' IS NULL) '
				  set @EmailboxQuery = N'AND (eb.EmailboxId = '+ convert(varchar, @EMailboxId)+' ) '
				 
				 end 
				 
				    
				 
			SET @query4=N' where em.StatusID <> 6 AND
			(eb.CountryId = '+ convert(varchar, @CountryId) +' OR '+  convert(varchar, @CountryId)+' IS NULL)'            
				--AND (eb.EmailboxId = '+ convert(varchar, @EMailboxId)+' OR '+ @EMailboxId+' IS NULL) '
				+ @EmailboxQuery + ' '
				+ @dateQuery + ' '
				+ @CaseIdTemp + ' '
				+ @statusQuery +' '
				+ @FlagQuery+' '
				+ @LikeQuery +' ' 
				+ @FromEmailQuery

			--print @query4
			declare @query7 as varchar(max) = N''
			
			if(@RoleId=3 or @RoleId=4)
				Begin
					set @query7=N' AND (em.EMailBoxId in (select distinct MailBoxId from dbo.UserMailBoxMapping WITH (NOLOCK) where UserId='''+convert(varchar, @LoginUserId)+''')) '
					
				End
			

			 -- exec [USP_GetSearchCaseList_Pagination] 1,23,Null,Null,Null,1,null,null,1,'354126',1,10,'CaseID','Descending'

			 --exec USP_GetSearchCaseList_Pagination @StatusId=NULL,@ReceivedTo=NULL,@CaseSubject=NULL,@LoginUserId=N'354126',@SortExpName=NULL,@PageSize=10,@EMailboxId=N'23',@Roleid=1,@CountryId=N'1',@FromEmail=NULL,@ReceivedFrom=NULL,@SortExpOrder=NULL,@PageIndex=1,@CaseId=NULL


				set @query5=' order by RowNumber OFFSET '+ convert(varchar(MAX), (@PageSize * (@PageIndex - 1))) +''+' ROWS
					  FETCH NEXT '+ convert(varchar(MAX), @PageSize) +' ROWS ONLY'

--print @query5
				execute (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query4+''+@Query7+''+@query5)

				

				declare @Query6 nvarchar(max)
				set @Query6 =N'select @RecordCount =count(em.caseid) from EmailMaster em with (nolock)
				inner join Emailbox eb WITH (NOLOCK) on em.EmailboxId = eb.EmailboxId  and eb.IsActive=1             
				inner join [Status] s WITH (NOLOCK) on em.StatusId = s.StatusId            
				left join Country Cy WITH (NOLOCK) on  CY.countryId=eb.CountryId 
				left join FlagCaseMaster FCM on FCM.CaseId = em.CaseId  AND FCM.IsActive=1  '+  @query3+' '+  @query4 

				--execute (@Query6+''+@query3+''+@query4)]
				

				execute sp_executesql @Query6,N'@RecordCount int out', @RecordCount=@RecordCount out
  


				SET @TotalPagecount = cast(@RecordCount as float)/cast (@PageSize as float)
	
				select @RecordCount as TotalRecordCount--, ceiling(@TotalPagecount) as TotalPageCount 	
		          
	END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetSkillSet]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetSkillSet]
	
AS
BEGIN
	SET NOCOUNT ON 
	Select SkillId,SkillDescription from dbo.SkillMaster where IsActive='1';

    
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetStatus]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SaranyaDevi C
-- Create date: 26-Jul-2017
-- Description:	Return Status Transitions based on SubProcessId and UserRoleId
-- =============================================

--exec USP_GetStatusTransitionBySubProcessIdAndRoleId 1,4 
CREATE PROCEDURE [dbo].[USP_GetStatus]
	(
	@SubProcessId int
	)
AS
BEGIN
	
	SET NOCOUNT ON;

	
	if exists(select * from dbo.Status where SubProcessID=@SubProcessId and IsActive='1')
	Begin
	select * from dbo.Status where SubProcessID=@SubProcessId and IsActive='1'
	end
	else
	begin
	select * from dbo.Status where SubProcessID is null and IsActive='1'
	end
    
    
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetStatusList]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetStatusList]  
AS  
BEGIN  
 SELECT   
  StatusId,  
  StatusDescription  
 FROM   
 STATUS  
 WHERE StatusId IN (3,4,5,7,8,10,13)  
END


GO
/****** Object:  StoredProcedure [dbo].[USP_GetStatusTransition]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Karthikeyan A>
-- Create date: <17-July-2017>
-- Description:	<Get status transitions based on subprocess and role >
-- =============================================
CREATE PROCEDURE [dbo].[USP_GetStatusTransition]
	-- Add the parameters for the stored procedure here
	@SubProcessID as INT,
	@RoleID as INT,
	@FromStatusID as INT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Select S.StatusId,S.StatusDescription from StatusTransisitionMaster STM inner join [Status] S on s.StatusId=STM.ToStatusID
		  where STM.SubProcessID=@SubProcessID and STM.UserRoleID=@RoleID and STM.FromStatusID=@FromStatusID


END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetStatusTransitionBySubProcessIdAndRoleId]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SaranyaDevi C
-- Create date: 26-Jul-2017
-- Description:	Return Status Transitions based on SubProcessId and UserRoleId
-- =============================================

--exec USP_GetStatusTransitionBySubProcessIdAndRoleId 1,4 
CREATE PROCEDURE [dbo].[USP_GetStatusTransitionBySubProcessIdAndRoleId]
	@SubProcessId as int
	,@UserRoleId as int
	
AS
BEGIN
	
	SET NOCOUNT ON;
	if exists(select * from dbo.StatusTransisitionMaster where SubProcessID=@SubProcessId)
	Begin
	select STM.SubProcessID as SubProcessId,UserRoleID,FromStatusID,sm1.StatusDescription as FromStatus,ToStatusID,sm2.StatusDescription as ToStatus from dbo.StatusTransisitionMaster STM
	left join dbo.Status SM1 on stm.FromStatusID=sm1.StatusId
	left join dbo.Status SM2 on stm.ToStatusID=sm2.StatusId
	where STM.SubProcessID=@SubProcessId and UserRoleID=@UserRoleId
	end
	else
	begin
	select @SubProcessId as SubProcessId,UserRoleID,FromStatusID,sm1.StatusDescription as FromStatus,ToStatusID,sm2.StatusDescription as ToStatus  from dbo.StatusTransisitionMaster STM
	left join dbo.Status SM1 on stm.FromStatusID=sm1.StatusId
	left join dbo.Status SM2 on stm.ToStatusID=sm2.StatusId
	where STM.SubProcessID is NULL and UserRoleID=@UserRoleId
	end
    
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetSubProcessByCountryId]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetSubProcessByCountryId]
          
@COUNTRYID varchar(50),
@USERID varchar(10),
@ROLEID varchar(10)

          
AS          
BEGIN           
SET NOCOUNT ON;          


SELECT SG.SubProcessGroupId as SubProcessGroupId, SG.SubprocessName  as SubProcessGroupName FROM SUBPROCESSGROUPS SG
WHERE SG.COUNTRYIDMAPPING =@COUNTRYID AND SG.ISACTIVE =1

          
END 












GO
/****** Object:  StoredProcedure [dbo].[USP_GetTemplateContent]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		SaranyaDevi C
-- Create date: 26-Jul-2017
-- Description:	Return Status Transitions based on SubProcessId and UserRoleId
-- =============================================

--exec USP_GetStatusTransitionBySubProcessIdAndRoleId 1,4 
create PROCEDURE [dbo].[USP_GetTemplateContent]
	(
	@TemplateId int
	)
AS
BEGIN
	
	SET NOCOUNT ON;

	
	select TemplateContent from dbo.[dbo.ManualCaseTemplateConfiguration] where IsActive=1 and TemplateId=@TemplateId;
    
    
END

GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserIdsByCountryEmailboxRole]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--exec usp_GetUserIdsByCountryEmailboxRole 4,11,3,2
CREATE procedure [dbo].[usp_GetUserIdsByCountryEmailboxRole]    
(    
@CountryId int,    
@EMailbocId int,    
@RoleId int ,
@SkillId varchar(100)   
)    
AS                
BEGIN                 
SET NOCOUNT ON;     
   if(@SkillId='0')
   begin  
select um.UserId, um.FirstName + ' ' + um.LastName + ' ( ' + um.UserId + ' ) ' as UserName, mb.CountryId, mb.EMailboxId, urm.RoleID     
from UserMaster um inner join    
UserMailBoxMapping umbm on um.UserId = umbm.UserId inner join    
EMailbox mb on umbm.MailboxId = mb.EMailboxId and mb.Isactive=1 inner join    
UserRoleMapping urm  on um.UserId = urm.UserId    
where um.IsActive=1 and mb.CountryId=@CountryId and mb.EMailboxId=@EMailbocId and urm.RoleID=@RoleId order by um.UserId, UserName
    end
	else
	begin
	select um.UserId, um.FirstName + ' ' + um.LastName + ' ( ' + um.UserId + ' ) ' as UserName, mb.CountryId, mb.EMailboxId, urm.RoleID     
from UserMaster um inner join    
UserMailBoxMapping umbm on um.UserId = umbm.UserId inner join    
EMailbox mb on umbm.MailboxId = mb.EMailboxId and mb.Isactive=1 inner join    
UserRoleMapping urm  on um.UserId = urm.UserId    
where um.IsActive=1 and mb.CountryId=@CountryId and mb.EMailboxId=@EMailbocId and urm.RoleID=@RoleId and ';'+um.SkillId like '%;'+@SkillId+';%' order by um.UserId, UserName
	end
END






GO
/****** Object:  StoredProcedure [dbo].[usp_GetUserIdsByEmailboxId]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[usp_GetUserIdsByEmailboxId]
(  
@EmailboxId int  
)  
AS              
BEGIN               
SET NOCOUNT ON;   
   
select um.UserId, um.FirstName + ' ' + um.LastName + ' ( ' + um.UserId + ' ) ' as UserName    
from UserMaster um inner join  
UserMailBoxMapping umbm on um.UserId = umbm.UserId
where umbm.MailboxId=@EmailboxId and um.isactive=1

END







GO
/****** Object:  StoredProcedure [dbo].[USP_GetUsersFromCountry]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetUsersFromCountry]      
        
@CountryId int,
@SubProcessId int
AS                
BEGIN                 
SET NOCOUNT ON;                
  if(@SubProcessId=0) 
	begin
		SELECT DISTINCT UM.USERID, UM.FIRSTNAME +' '+  UM.LASTNAME + ' ( ' + UM.USERID + ' ) ' AS FIRSTNAME 
		FROM USERMASTER UM WITH(NOLOCK)    
		JOIN USERMAILBOXMAPPING UMBM WITH(NOLOCK) ON UM.USERID= UMBM.USERID      
		JOIN EMAILBOX EB WITH(NOLOCK) ON UMBM.MAILBOXID = EB.EMAILBOXID AND EB.ISACTIVE=1
		JOIN COUNTRY C WITH(NOLOCK) ON EB.COUNTRYID= C.COUNTRYID AND C.ISACTIVE=1  
		WHERE UM.ISACTIVE=1 AND C.COUNTRYID = @CountryId 
	end
 else	        
 	begin
		SELECT DISTINCT UM.USERID, UM.FIRSTNAME +' '+  UM.LASTNAME + ' ( ' + UM.USERID + ' ) ' AS FIRSTNAME 
		FROM USERMASTER UM  WITH(NOLOCK)
		JOIN USERMAILBOXMAPPING UMBM WITH(NOLOCK) ON UM.USERID= UMBM.USERID      
		JOIN EMAILBOX EB WITH(NOLOCK) ON UMBM.MAILBOXID = EB.EMAILBOXID AND EB.ISACTIVE=1
		JOIN COUNTRY C WITH(NOLOCK) ON EB.COUNTRYID= C.COUNTRYID AND C.ISACTIVE=1  
		WHERE UM.ISACTIVE=1 AND C.COUNTRYID = @CountryId AND EB.SubProcessGroupId = @SubProcessId
	end
END 







GO
/****** Object:  StoredProcedure [dbo].[USP_GetUsersPushForQCQueue]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[USP_GetUsersPushForQCQueue]       -- exec [USP_GetUsersPushForQCQueue] '226961','272637',1,0    



 (                  



 @LoggedInUserId AS VARCHAR(20),     



 @QCUserId AS VARCHAR(20) = null,     



 @EMAILBOXID AS INT,    



 @IsQCReassign bit                



 )                  



AS                  



BEGIN                 



        



----------------------------------------------- QC USERID IS NOT  NULL ----------------------------------------------------------------                   



if(@IsQCReassign=0)    



 begin     



 if((@QCUserId is null) OR (@QCUserId=''))    



  begin    



    SELECT CASEID,CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,       



    EM.Subject, CASE WHEN em.IsUrgent=1 THEN 'High' ELSE 'Low' END IsUrgent, UM.USERID,UM.FIRSTNAME + ' ' + UM.LASTNAME + ' (' + UM.USERID + ')'  AS USERNAME,         



    SM.StatusDescription AS STATUSDESCRIPTION, SM.STATUSID, EMailboxId, '' as 'QCUserId'            



    FROM EMAILMASTER EM        



    JOIN USERMASTER UM ON UM.USERID= EM.AssignedToId    



    JOIN STATUS SM ON EM.STATUSID = SM.STATUSID        



    WHERE EM.AssignedToId <> @LoggedInUserId AND    



    SM.STATUSID in (select StatusId from dbo.Status where IsQCPending='1') AND    



    EM.EMAILBOXID=@EMAILBOXID AND    



    (EM.QCUSERID IS NULL OR  EM.QCUSERID ='')    



   end    



  else    



   begin    



     SELECT CASEID,CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,       



     EM.Subject, CASE WHEN em.IsUrgent=1 THEN 'High' ELSE 'Low' END IsUrgent, UM.USERID,UM.FIRSTNAME + ' ' + UM.LASTNAME + ' (' + UM.USERID + ')'  AS USERNAME,         



     SM.StatusDescription AS STATUSDESCRIPTION, SM.STATUSID, EMailboxId, '' as 'QCUserId' --, EM.QCUserId, UM1.FIRSTNAME + ' ' + UM1.LASTNAME + ' (' + EM.QCUserId + ')'  AS USERNAME           



             



     FROM EMAILMASTER EM        



     JOIN USERMASTER UM ON UM.USERID= EM.AssignedToId   



     JOIN STATUS SM ON EM.STATUSID = SM.STATUSID        



     WHERE EM.AssignedToId <> @LoggedInUserId AND    



     SM.STATUSID in (select StatusId from dbo.Status where IsQCPending='1')AND    



     EM.EMAILBOXID=@EMAILBOXID AND    



      (EM.QCUSERID IS NULL OR  EM.QCUSERID ='')    



     and     



     em.assignedtoid is not null and (EM.ASSIGNEDTOID IS NULL OR EM.ASSIGNEDTOID =@QCUserId)    



   end    



 end    



else    



  begin    



    SELECT CASEID,CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,       



    EM.Subject, CASE WHEN em.IsUrgent=1 THEN 'High' ELSE 'Low' END IsUrgent, UM.USERID,UM.FIRSTNAME + ' ' + UM.LASTNAME + ' (' + EM.AssignedToId + ')'  AS USERNAME,         



    SM.StatusDescription AS STATUSDESCRIPTION, SM.STATUSID, EMailboxId, EM.QCUserId           



            



    FROM EMAILMASTER EM        



    JOIN USERMASTER UM ON UM.USERID= EM.AssignedToId  



    JOIN USERMASTER UM1 ON UM1.USERID= EM.QCUserId  



    JOIN STATUS SM ON EM.STATUSID = SM.STATUSID        



            



    WHERE EM.QCUSERID <> @LoggedInUserId AND    



    SM.STATUSID in (select StatusId from dbo.Status where IsQCPending='1') AND    



    EM.EMAILBOXID=@EMAILBOXID AND    



    EM.QCUSERID IS NOT NULL AND    



    (EM.QCUserId = @QCUserId OR @QCUserId IS NULL)    



  end    



end        











GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueList]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetWorkQueueList]  --exec [USP_GetWorkQueueList] 19, 1, '252123'     
@EMailboxId int,    
@StatusId int,    
@LoggedInUserId varchar(40)    
AS                
BEGIN                 
SET NOCOUNT ON;                
 --declare @CountryId int    
 --select @CountryId = CountryId from Emailbox where EMailboxId=@EMailboxId    
 select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     
 from Country c inner join     
 Emailbox eb on c.CountryId = eb.CountryId inner join     
 EmailMaster em on eb.EMailboxId = em.EMailboxId left join     
 Status s on em.StatusId = s.StatusId    
 where em.StatusId = @StatusId --and eb.CountryId = @CountryId     
  and em.EMailboxId = @EMailboxId    
 if(@StatusId=1)--Open    
  begin    
   select em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,     
   Em.EMailFrom as Sender,em.Subject, 'N/A' as AssignedTo,     
   case when em.IsUrgent=1 then 'High' else 'Low'  end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId    
   from EmailMaster em inner join     
   --UserMaster um on em.AssignedToId = um.UserId inner join     
   Emailbox eb on em.EmailboxId = eb.EmailboxId    
   where em.StatusId = @StatusId     
   and eb.EmailboxId = @EMailboxId    order by em.IsUrgent desc ,em.EMailReceivedDate desc,em.CaseId desc
  end    
 else    
  begin  
 IF(@LoggedInUserId = '0')      
   BEGIN       

     select em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,     
     Em.EMailFrom as Sender, em.Subject, um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' AssignedTo,     
     case when em.IsUrgent=1 then 'High' else 'Low'  end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId    
     from EmailMaster em inner join     
     UserMaster um on em.AssignedToId = um.UserId inner join     
     Emailbox eb on em.EmailboxId = eb.EmailboxId    
     where em.StatusId = @StatusId --and eb.CountryId = @CountryId     
     and eb.EmailboxId = @EMailboxId  order by em.IsUrgent desc ,em.EMailReceivedDate desc,em.CaseId desc
  END  
   ELSE  
    BEGIN       
     select em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,     
     Em.EMailFrom as Sender,em.Subject, um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' AssignedTo,     
     case when em.IsUrgent=1 then 'High' else 'Low'  end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId    
     from EmailMaster em inner join     
     UserMaster um on em.AssignedToId = um.UserId inner join     
     Emailbox eb on em.EmailboxId = eb.EmailboxId    
     where em.StatusId = @StatusId --and eb.CountryId = @CountryId     
     and eb.EmailboxId = @EMailboxId and em.AssignedToId = @LoggedInUserId  
	 order by em.IsUrgent desc ,em.EMailReceivedDate desc,em.CaseId desc
  END  
  end    
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueListDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetWorkQueueListDetails]  --exec [USP_GetWorkQueueListDetails] 'Siemens - Australia', 'Open', '0'     
@EMailboxName varchar(40),    
@Status varchar(40),    
@LoggedInUserId varchar(40)    
AS                
BEGIN                 
SET NOCOUNT ON;                
 --declare @CountryId int    
 --select @CountryId = CountryId from Emailbox where EMailboxId=@EMailboxId   
 declare @EMailboxId int
 declare @statusId int

 select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') = @Status
 Select  @EMailboxId=EmailboxID from Emailbox where EmailboxName=@EMailboxName
  
 select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     
 from Country c inner join     
 Emailbox eb on c.CountryId = eb.CountryId inner join     
 EmailMaster em on eb.EMailboxId = em.EMailboxId left join     
 Status s on em.StatusId = s.StatusId    
 where em.StatusId = @StatusId --and eb.CountryId = @CountryId     
  and em.EMailboxId = @EMailboxId    
 if(@StatusId=1)--Open    
  begin    
   select em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,     
   Em.EMailFrom as Sender,em.Subject, 'N/A' as AssignedTo,     
   case when em.IsUrgent=1 then 'High' else 'Low'  end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId ,
   case when em.IsVipMail=1 then 'Yes' else 'No'  end VIPMail   
   from EmailMaster em inner join     
   --UserMaster um on em.AssignedToId = um.UserId inner join     
   Emailbox eb on em.EmailboxId = eb.EmailboxId    
   where em.StatusId = @StatusId     
   and eb.EmailboxId = @EMailboxId    order by em.IsUrgent desc ,em.EMailReceivedDate desc,em.CaseId desc
  end    
 else    
  begin  
 IF(@LoggedInUserId = '0')      
   BEGIN       

     select em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,     
     Em.EMailFrom as Sender, em.Subject, um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' AssignedTo,     
     case when em.IsUrgent=1 then 'High' else 'Low'  end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId ,
	 case when em.IsVipMail=1 then 'Yes' else 'No'  end VIPMail
     from EmailMaster em inner join     
     UserMaster um on em.AssignedToId = um.UserId inner join     
     Emailbox eb on em.EmailboxId = eb.EmailboxId    
     where em.StatusId = @StatusId --and eb.CountryId = @CountryId     
     and eb.EmailboxId = @EMailboxId  order by em.IsUrgent desc ,em.EMailReceivedDate desc,em.CaseId desc
  END  
   ELSE  
    BEGIN       
     select em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +' ' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,     
     Em.EMailFrom as Sender,em.Subject, um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' AssignedTo,     
     case when em.IsUrgent=1 then 'High' else 'Low'  end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId ,
	 case when em.IsVipMail=1 then 'Yes' else 'No'  end VIPMail    
     from EmailMaster em inner join     
     UserMaster um on em.AssignedToId = um.UserId inner join     
     Emailbox eb on em.EmailboxId = eb.EmailboxId    
     where em.StatusId = @StatusId --and eb.CountryId = @CountryId     
     and eb.EmailboxId = @EMailboxId and em.AssignedToId = @LoggedInUserId  
	 order by em.IsUrgent desc ,em.EMailReceivedDate desc,em.CaseId desc
  END  
  end    
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueListDetails_Pagination]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_GetWorkQueueListDetails_Pagination]  

@EMailboxName varchar(40),    
@Status varchar(40),    
@LoggedInUserId varchar(40),    

@PageIndex INT,
@PageSize INT,

@SortExpName varchar(40),
@SortExpOrder varchar(10),

@RecordCount INT OUTPUT

AS                

BEGIN                 

SET NOCOUNT ON;  
         
declare @query1 nvarchar(max)
declare @SortQuery nvarchar(max)
declare @query2 nvarchar(max)
declare @Assignee nvarchar(max)
declare @AssignQuery nvarchar(max)
declare @query3 nvarchar(max)
declare @query4 nvarchar(max)
declare @query5 nvarchar(max)

  
declare @EMailboxId int
declare @statusId int
DECLARE @TotalPagecount float
 
	select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','')

	Select  @EMailboxId=EmailboxID from Emailbox where EmailboxName=@EMailboxName


 select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     
  from Country c inner join     
  Emailbox eb on c.CountryId = eb.CountryId inner join     
  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     
  Status s on em.StatusId = s.StatusId    
  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     
  and em.EMailboxId = @EMailboxId    

 if(@SortExpName<>'FirstName')
 set @SortExpName='em.'+@SortExpName 
 else 
 set @SortExpName='um.'+@SortExpName 
 
 
DELETE TempDashboardResult
  

set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId) select ROW_NUMBER() OVER('
set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder
set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '
set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId  
from EmailMaster em 
inner join Emailbox eb on em.EmailboxId = eb.EmailboxId '

SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.EmailboxId ='+convert(varchar(max),  @EMailboxId)


 if(@StatusId=1)
	begin 
		set @query3=''
		set @Assignee='''NA'''
		
	end 
 else
	begin 
		set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''
		set @query3='  inner join UserMaster um on em.AssignedToId = um.UserId'
		
		IF(@LoggedInUserId <> '0')      
			begin 
				SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoggedInUserId)+';'
			end 
	end 


execute   (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query3+''+@query4)


	
SELECT @RecordCount = COUNT(*) FROM TempDashboardResult

SET @TotalPagecount = cast(@RecordCount as float)/cast (@PageSize as float)
	
SELECT *, @RecordCount as TotalRecordCount, ceiling(@TotalPagecount) as TotalPageCount FROM TempDashboardResult
WHERE RowNumber BETWEEN(@PageIndex-1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1
 


DELETE TempDashboardResult
 

END





GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW]  

@SubProcessName varchar(40),

@EMailboxName varchar(40),    

@Status varchar(40),    

@LoggedInUserId varchar(40),    

@PageIndex INT,

@PageSize INT,

@SortExpName varchar(40),

@SortExpOrder varchar(10),

@RecordCount INT OUTPUT

AS                

BEGIN                 

SET NOCOUNT ON;  
        

declare @query1 nvarchar(max)

declare @SortQuery nvarchar(max)

declare @query2 nvarchar(max)

declare @Assignee nvarchar(max)

declare @AssignQuery nvarchar(max)

declare @query3 nvarchar(max)

declare @query4 nvarchar(max)

declare @query6 nvarchar(max)

declare @subprocessID int
declare @EMailboxId int

declare @statusId int

DECLARE @TotalPagecount float

		 select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','')	
	     -- Select  @EMailboxId=EmailboxID from Emailbox where EmailboxName=@EMailboxName	
		 select @subprocessID=SubProcessGroupId	 from SubProcessGroups where SubProcessName=@SubProcessName	
		 
  select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     

  from Country c inner join     

  Emailbox eb on c.CountryId = eb.CountryId inner join     

  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

  Status s on em.StatusId = s.StatusId    

  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     

  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID
  
 if(@SortExpName<>'FirstName')

 set @SortExpName='em.'+@SortExpName 

 else 

 set @SortExpName='um.'+@SortExpName 
  
DELETE TempDashboardResult

set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,VIPMail,ParentCaseId,OriginalCaseId) select ROW_NUMBER() OVER('

set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder

set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '

set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,  
(case when em.IsVipMail=1 then ''Yes'' else ''No'' end) VIPMail ,em.ParentCaseId,em.CaseId as OriginalCaseId  
from EmailMaster em 
inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
inner join SubProcessGroups SG on eb.SubProcessGroupId=SG.SubProcessGroupId'
SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) 
 

 if(@StatusId=1)

	begin 

		set @query3=''

		set @Assignee='''NA'''
		

	end 

 else

	begin 

		set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''

		set @query3='  inner join UserMaster um on em.AssignedToId = um.UserId'

		
		IF(@LoggedInUserId <> '0')      

			begin 

				SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoggedInUserId)+';'

			end 

	end 

execute   (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query3+''+@query4)

SELECT @RecordCount = COUNT(*) FROM TempDashboardResult


SET @TotalPagecount = cast(@RecordCount as float)/cast (@PageSize as float)

SELECT *, @RecordCount as TotalRecordCount, ceiling(@TotalPagecount) as TotalPageCount FROM TempDashboardResult

WHERE RowNumber BETWEEN(@PageIndex-1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

  

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_dynamicchnages]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


---exec [USP_GetWorkQueueListDetails_Pagination_NEW_dynamicchnages] 'AP','EMTDev5','Open',0,1,20,'EmailReceivedDate','desc',''



CREATE PROCEDURE [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_dynamicchnages] 

@SubProcessName varchar(40),

@EMailboxName varchar(40),    

@Status varchar(40),    

@LoggedInUserId varchar(40),    

@PageIndex INT,

@PageSize INT,

@SortExpName varchar(40),

@SortExpOrder varchar(10),

@RecordCount INT OUTPUT

AS                

BEGIN                 

SET NOCOUNT ON;  

declare @query1 nvarchar(max)

declare @SortQuery nvarchar(max)

declare @query2 nvarchar(max)

declare @Assignee nvarchar(max)

declare @AssignQuery nvarchar(max)

declare @query3 nvarchar(max)

declare @query4 nvarchar(max)

declare @query6 nvarchar(max)

declare @subprocessID int

declare @EMailboxId int

declare @statusId int

DECLARE @TotalPagecount float

 select @subprocessID=SubProcessGroupId	 from SubProcessGroups where SubprocessName=@SubProcessName	     

 		select @EMailboxId=EMailBoxId	 from emailbox where EMailBoxName=@EMailboxName	     



--dynamic workflow changes , modified by saranya



if exists(select * from dbo.Status where SubProcessID=@subprocessID and IsActive='1')

	Begin

		 select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','') and SubProcessID=@subprocessID	

	end

else

	begin

		select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','') and SubProcessID is null

	end



 select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription   

	from Country c inner join     

  Emailbox eb on c.CountryId = eb.CountryId inner join     

  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

  Status s on em.StatusId = s.StatusId    

  where em.StatusId = @StatusId--and eb.CountryId = @CountryId     

  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID



 if(@SortExpName<>'FirstName')

	set @SortExpName='em.'+@SortExpName 

 else 

	set @SortExpName='um.'+@SortExpName 



DELETE TempDashboardResult



if exists(select * from Status where SubProcessID=@subprocessID)



begin

	set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,VIPMail,ParentCaseId,OriginalCaseId,isNLPSuggestionMail,EMailBody) select ROW_NUMBER() OVER('

	set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder

	set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '

	set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,  

		(case when em.IsVipMail=1 then ''Yes'' else ''No'' end) VIPMail ,em.ParentCaseId,em.CaseId as OriginalCaseId , eb.isNLPSuggestionRequired, em.EMailBody

		from EmailMaster em 

		inner join Emailbox eb on em.EmailboxId = eb.EmailboxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox eb Join SubProcessGroups SG ON eb.SubProcessGroupId=SG.SubprocessGroupID and eb.CountryId=SG.CountryIdMapping 

		and SG.SubprocessName='''+@SubprocessName+''' and eb.ISACTIVE=1)

		join [Status] SM ON  EM.STATUSID = SM.STATUSID

		inner join SubProcessGroups SG on SG.SubProcessGroupId=SM.SubProcessID												

		and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubProcessName+''')'

	SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and em.EMailboxId = '+convert(varchar(max), @EMailboxId) +' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) 

end



else



begin



	set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,VIPMail,ParentCaseId,OriginalCaseId,isNLPSuggestionMail,EMailBody) select ROW_NUMBER() OVER('

	set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder



	set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '



	set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,  

		(case when em.IsVipMail=1 then ''Yes'' else ''No'' end) VIPMail ,em.ParentCaseId,em.CaseId as OriginalCaseId , eb.isNLPSuggestionRequired, em.EMailBody

		from EmailMaster em 

		inner join Emailbox eb on em.EmailboxId = eb.EmailboxId AND EM.EMailBoxId in (select EMAILBOXID from EmailBox eb Join SubProcessGroups SG ON eb.SubProcessGroupId=SG.SubprocessGroupID and eb.CountryId=SG.CountryIdMapping 

		and SG.SubprocessName='''+@SubprocessName+''' and eb.ISACTIVE=1)

		join [Status] SM ON  EM.STATUSID = SM.STATUSID

		inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId													

		and SM.SubProcessID is null'

	SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and em.EMailboxId = '+convert(varchar(max), @EMailboxId) +' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) 



end



 if(@StatusId in (Select statusId from dbo.Status where IsInitalStatus='1'))

	begin 

		set @query3=''

		set @Assignee='''NA'''

	end 

 else

	begin 

		set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''

		set @query3='  inner join UserMaster um on em.AssignedToId = um.UserId'

		IF(@LoggedInUserId <> '0')      

			begin 

				SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoggedInUserId)+';'

			end 

	end 

	print (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query3+''+@query4)

execute   (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query3+''+@query4)



SELECT @RecordCount = COUNT(*) FROM TempDashboardResult

SET @TotalPagecount = cast(@RecordCount as float)/cast (@PageSize as float)



SELECT *, @RecordCount as TotalRecordCount, ceiling(@TotalPagecount) as TotalPageCount FROM TempDashboardResult

WHERE RowNumber BETWEEN(@PageIndex-1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_old]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_old]  

@SubProcessName varchar(40),

@EMailboxName varchar(40),    

@Status varchar(40),    

@LoggedInUserId varchar(40),    

@PageIndex INT,

@PageSize INT,

@SortExpName varchar(40),

@SortExpOrder varchar(10),

@RecordCount INT OUTPUT

AS                

BEGIN                 

SET NOCOUNT ON;  
        

declare @query1 nvarchar(max)

declare @SortQuery nvarchar(max)

declare @query2 nvarchar(max)

declare @Assignee nvarchar(max)

declare @AssignQuery nvarchar(max)

declare @query3 nvarchar(max)

declare @query4 nvarchar(max)

declare @query6 nvarchar(max)

declare @subprocessID int
declare @EMailboxId int

declare @statusId int

DECLARE @TotalPagecount float

		 select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','')	
	     -- Select  @EMailboxId=EmailboxID from Emailbox where EmailboxName=@EMailboxName	
		 select @subprocessID=SubProcessGroupId	 from SubProcessGroups where SubProcessName=@SubProcessName	
		 
  select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     

  from Country c inner join     

  Emailbox eb on c.CountryId = eb.CountryId inner join     

  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

  Status s on em.StatusId = s.StatusId    

  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     

  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID
  
 if(@SortExpName<>'FirstName')

 set @SortExpName='em.'+@SortExpName 

 else 

 set @SortExpName='um.'+@SortExpName 
  
DELETE TempDashboardResult

set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId) select ROW_NUMBER() OVER('

set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder

set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '

set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId  

from EmailMaster em 
inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
inner join SubProcessGroups SG on eb.SubProcessGroupId=SG.SubProcessGroupId'
SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) 
 

 if(@StatusId=1)

	begin 

		set @query3=''

		set @Assignee='''NA'''
		

	end 

 else

	begin 

		set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''

		set @query3='  inner join UserMaster um on em.AssignedToId = um.UserId'

		
		IF(@LoggedInUserId <> '0')      

			begin 

				SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoggedInUserId)+';'

			end 

	end 

execute   (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query3+''+@query4)

SELECT @RecordCount = COUNT(*) FROM TempDashboardResult


SET @TotalPagecount = cast(@RecordCount as float)/cast (@PageSize as float)

SELECT *, @RecordCount as TotalRecordCount, ceiling(@TotalPagecount) as TotalPageCount FROM TempDashboardResult

WHERE RowNumber BETWEEN(@PageIndex-1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

DELETE TempDashboardResult
  

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_withClassification]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_withClassification]  

@SubProcessName varchar(40),

@EMailboxName varchar(40),    

@Status varchar(40),   

@ClassificationName varchar(40), 

@LoggedInUserId varchar(40),    

@PageIndex INT,

@PageSize INT,

@SortExpName varchar(40),

@SortExpOrder varchar(10),

@RecordCount INT OUTPUT

AS                

BEGIN                 

SET NOCOUNT ON;  
        

declare @query1 nvarchar(max)

declare @SortQuery nvarchar(max)

declare @query2 nvarchar(max)

declare @Assignee nvarchar(max)

declare @AssignQuery nvarchar(max)

declare @query3 nvarchar(max)

declare @query4 nvarchar(max)

declare @query6 nvarchar(max)

declare @subprocessID int
declare @EMailboxId int

declare @classificationId bigint

declare @statusId int

DECLARE @TotalPagecount float

		 select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','')	
	     Select  @EMailboxId=EmailboxID from Emailbox where EmailboxName=@EMailboxName	
		 select @subprocessID=SubProcessGroupId	 from SubProcessGroups where SubProcessName=@SubProcessName	
	if(@ClassificationName<>null or @ClassificationName<>'')
		begin		 
		 select @classificationId=ClassificationID from InboundClassification where ClassifiactionDescription=@ClassificationName

		  select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     

		  from Country c inner join     

		  Emailbox eb on c.CountryId = eb.CountryId inner join     

		  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

		  Status s on em.StatusId = s.StatusId    

		  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     

		  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID and em.ClassificationID=@classificationId
  
		if(@SortExpName<>'FirstName')

	 set @SortExpName='em.'+@SortExpName 

	 else 

	 set @SortExpName='um.'+@SortExpName 
  
	DELETE TempDashboardResult

set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,VIPMail,ParentCaseId,OriginalCaseId) select ROW_NUMBER() OVER('

set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder

set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '

set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,  
(case when em.IsVipMail=1 then ''Yes'' else ''No'' end) VIPMail,em.ParentCaseId,em.CaseId as OriginalCaseId 
from EmailMaster em 
inner join InboundClassification IC on em.ClassificationID=IC.ClassificationID
inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
inner join SubProcessGroups SG on eb.SubProcessGroupId=SG.SubProcessGroupId'
SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) +' and em.ClassificationID='+ convert(varchar(max),@classificationId)+' and em.EmailboxId='+ convert(varchar(max),@EMailboxId)
end
else
begin
 select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     

  from Country c inner join     

  Emailbox eb on c.CountryId = eb.CountryId inner join     

  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

  Status s on em.StatusId = s.StatusId    

  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     

  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID
  
 if(@SortExpName<>'FirstName')

 set @SortExpName='em.'+@SortExpName 

 else 

 set @SortExpName='um.'+@SortExpName 
  
DELETE TempDashboardResult

set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,VIPMail,ParentCaseId,OriginalCaseId) select ROW_NUMBER() OVER('

set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder

set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '

set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,  
(case when em.IsVipMail=1 then ''Yes'' else ''No'' end) VIPMail,em.ParentCaseId,em.CaseId as OriginalCaseId  
from EmailMaster em 
inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
inner join SubProcessGroups SG on eb.SubProcessGroupId=SG.SubProcessGroupId'
SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID)+' and em.EmailboxId ='+convert(varchar(max),@EMailboxId)
end
 

 if(@StatusId=1)

	begin 

		set @query3=''

		set @Assignee='''NA'''
		

	end 

 else

	begin 

		set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''

		set @query3='  inner join UserMaster um on em.AssignedToId = um.UserId'

		
		IF(@LoggedInUserId <> '0')      

			begin 

				SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoggedInUserId)+';'

			end 

	end 

execute   (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query3+''+@query4)

SELECT @RecordCount = COUNT(*) FROM TempDashboardResult


SET @TotalPagecount = cast(@RecordCount as float)/cast (@PageSize as float)

SELECT *, @RecordCount as TotalRecordCount, ceiling(@TotalPagecount) as TotalPageCount FROM TempDashboardResult

WHERE RowNumber BETWEEN(@PageIndex-1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

DELETE TempDashboardResult
  

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_withClassification_CID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_GetWorkQueueListDetails_Pagination_NEW_withClassification_CID

--sp_helptext USP_GetWorkQueueListDetails_Pagination_NEW_withClassification







CREATE PROCEDURE [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_withClassification_CID]  

@SubProcessName varchar(40),

@EMailboxName varchar(40),    

@Status varchar(40),   

@ClassificationName varchar(40), 

@LoggedInUserId varchar(40),    

@PageIndex INT,

@PageSize INT,

@SortExpName varchar(40),

@SortExpOrder varchar(10),

@RecordCount INT OUTPUT

AS                

BEGIN                 

SET NOCOUNT ON;  
 
declare @query1 nvarchar(max)

declare @SortQuery nvarchar(max)

declare @query2 nvarchar(max)

declare @Assignee nvarchar(max)

declare @AssignQuery nvarchar(max)


declare @query3 nvarchar(max)

declare @query4 nvarchar(max)

declare @query6 nvarchar(max)

declare @subprocessID int
declare @EMailboxId int

declare @classificationId bigint
declare @statusId int

DECLARE @TotalPagecount float

		 select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','')	


	     -- Select  @EMailboxId=EmailboxID from Emailbox where EmailboxName=@EMailboxName	


		 select @subprocessID=SubProcessGroupId	 from SubProcessGroups where SubProcessName=@SubProcessName	


if(@ClassificationName<>null or @ClassificationName<>'')


begin		 


		 select @classificationId=ClassificationID from InboundClassification where ClassifiactionDescription=@ClassificationName


  select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     

  

  from Country c inner join     

  
  Emailbox eb on c.CountryId = eb.CountryId inner join     


  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     


  Status s on em.StatusId = s.StatusId    



  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     


  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID and em.ClassificationID=@classificationId


 if(@SortExpName<>'FirstName')


 set @SortExpName='em.'+@SortExpName 

 else 

 set @SortExpName='um.'+@SortExpName 


DELETE TempDashboardResultNormal


set @query1='insert into TempDashboardResultNormal (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,classificationId) select ROW_NUMBER() OVER('

set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder

set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '


set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,em.ClassificationID 



from EmailMaster em 


inner join InboundClassification IC on em.ClassificationID=IC.ClassificationID


inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 


inner join SubProcessGroups SG on eb.SubProcessGroupId=SG.SubProcessGroupId'


SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) +' and em.ClassificationID='+ convert(varchar(max),@classificationId)


end


else


begin


 select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     


  from Country c inner join     


  Emailbox eb on c.CountryId = eb.CountryId inner join     


  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

  Status s on em.StatusId = s.StatusId    

  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     



  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID


 if(@SortExpName<>'FirstName')


 set @SortExpName='em.'+@SortExpName 


 else 


 set @SortExpName='um.'+@SortExpName 
   

DELETE TempDashboardResult


set @query1='insert into TempDashboardResultNormal (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId) select ROW_NUMBER() OVER('


set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder

set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '

set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId  


from EmailMaster em 

inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 

inner join SubProcessGroups SG on eb.SubProcessGroupId=SG.SubProcessGroupId'


SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) 


end


 if(@StatusId=1)

	begin 


		set @query3=''



		set @Assignee='''NA'''

	end 


 else



	begin 

		set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''


		set @query3='  inner join UserMaster um on em.AssignedToId = um.UserId'



		IF(@LoggedInUserId <> '0')      

		begin 
			SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoggedInUserId)+';'

			end 


	end 

execute   (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query3+''+@query4)


SELECT @RecordCount = COUNT(*) FROM TempDashboardResultNormal


SET @TotalPagecount = cast(@RecordCount as float)/cast (@PageSize as float)

SELECT *, @RecordCount as TotalRecordCount, ceiling(@TotalPagecount) as TotalPageCount FROM TempDashboardResultNormal

WHERE RowNumber BETWEEN(@PageIndex-1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

DELETE TempDashboardResultNormal
--DELETE TempDashboardResultNormal

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_withClassification_dynamicchanges]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_withClassification_dynamicchanges]  

@SubProcessName varchar(40),

@EMailboxName varchar(40),    

@Status varchar(40),   

@ClassificationName varchar(40), 

@LoggedInUserId varchar(40),    

@PageIndex INT,

@PageSize INT,

@SortExpName varchar(40),

@SortExpOrder varchar(10),

@RecordCount INT OUTPUT

AS                

BEGIN                 

SET NOCOUNT ON;  
        

declare @query1 nvarchar(max)

declare @SortQuery nvarchar(max)

declare @query2 nvarchar(max)

declare @Assignee nvarchar(max)

declare @AssignQuery nvarchar(max)

declare @query3 nvarchar(max)

declare @query4 nvarchar(max)

declare @query6 nvarchar(max)

declare @subprocessID int
declare @EMailboxId int

declare @classificationId bigint

declare @statusId int

DECLARE @TotalPagecount float
 select @subprocessID=SubProcessGroupId	 from SubProcessGroups where SubProcessName=@SubProcessName	
 --dynamic workflow changes , modified by saranya
if exists(select * from dbo.Status where SubProcessID=@subprocessID and IsActive='1')
	Begin
	 select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','') and SubProcessID=@subprocessID	
	end
	else
	begin
	select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','') and SubProcessID is null
	end
	     Select  @EMailboxId=EmailboxID from Emailbox where EmailboxName=@EMailboxName	
		
	if(@ClassificationName<>null or @ClassificationName<>'')
		begin		 
		 select @classificationId=ClassificationID from InboundClassification where ClassifiactionDescription=@ClassificationName

		  select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     

		  from Country c inner join     

		  Emailbox eb on c.CountryId = eb.CountryId inner join     

		  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

		  Status s on em.StatusId = s.StatusId    

		  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     

		  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID and em.ClassificationID=@classificationId
  
		if(@SortExpName<>'FirstName')

	 set @SortExpName='em.'+@SortExpName 

	 else 

	 set @SortExpName='um.'+@SortExpName 
  
	DELETE TempDashboardResult
if exists(select * from Status where SubProcessID=@subprocessID)
begin
	set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,VIPMail,ParentCaseId,OriginalCaseId) select ROW_NUMBER() OVER('
	set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder
	set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '
	set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,  
	(case when em.IsVipMail=1 then ''Yes'' else ''No'' end) VIPMail,em.ParentCaseId,em.CaseId as OriginalCaseId 
	from EmailMaster em 
	inner join InboundClassification IC on em.ClassificationID=IC.ClassificationID
	inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
	join [Status] SM ON  EM.STATUSID = SM.STATUSID
	inner join SubProcessGroups SG on SG.SubProcessGroupId=SM.SubProcessID												
	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubProcessName+''')'
	SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) +' and em.ClassificationID='+ convert(varchar(max),@classificationId)+' and em.EmailboxId='+ convert(varchar(max),@EMailboxId)
end
else
begin
	set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,VIPMail,ParentCaseId,OriginalCaseId) select ROW_NUMBER() OVER('
	set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder
	set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '
	set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,  
	(case when em.IsVipMail=1 then ''Yes'' else ''No'' end) VIPMail,em.ParentCaseId,em.CaseId as OriginalCaseId 
	from EmailMaster em 
	inner join InboundClassification IC on em.ClassificationID=IC.ClassificationID
	inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
	join [Status] SM ON  EM.STATUSID = SM.STATUSID
	inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId													
	and SM.SubProcessID is null'
	SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) +' and em.ClassificationID='+ convert(varchar(max),@classificationId)+' and em.EmailboxId='+ convert(varchar(max),@EMailboxId)
end
end
else
begin
 select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     

  from Country c inner join     

  Emailbox eb on c.CountryId = eb.CountryId inner join     

  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

  Status s on em.StatusId = s.StatusId    

  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     

  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID
  
 if(@SortExpName<>'FirstName')

 set @SortExpName='em.'+@SortExpName 

 else 

 set @SortExpName='um.'+@SortExpName 
  
DELETE TempDashboardResult
if exists(select * from Status where SubProcessID=@subprocessID)
begin
	set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,VIPMail,ParentCaseId,OriginalCaseId) select ROW_NUMBER() OVER('
	set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder
	set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '
	set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,  
	(case when em.IsVipMail=1 then ''Yes'' else ''No'' end) VIPMail,em.ParentCaseId,em.CaseId as OriginalCaseId  
	from EmailMaster em 
	inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
	join [Status] SM ON  EM.STATUSID = SM.STATUSID
	inner join SubProcessGroups SG on SG.SubProcessGroupId=SM.SubProcessID												
	and SM.SubProcessID in (select SubProcessGroupId from SubProcessGroups where SubprocessName='''+@SubProcessName+''')'
	SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID)+' and em.EmailboxId ='+convert(varchar(max),@EMailboxId)
end
else
begin
	set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId,VIPMail,ParentCaseId,OriginalCaseId) select ROW_NUMBER() OVER('
	set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder
	set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '
	set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId,  
	(case when em.IsVipMail=1 then ''Yes'' else ''No'' end) VIPMail,em.ParentCaseId,em.CaseId as OriginalCaseId  
	from EmailMaster em 
	inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
	join [Status] SM ON  EM.STATUSID = SM.STATUSID
	inner join SubProcessGroups SP on SP.SubProcessGroupId=EB.SubProcessGroupId													
	and SM.SubProcessID is null'
	SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID)+' and em.EmailboxId ='+convert(varchar(max),@EMailboxId)
end
end
 

 
 if(@StatusId in (Select statusId from dbo.Status where IsInitalStatus='1'))

	begin 

		set @query3=''

		set @Assignee='''NA'''
		

	end 

 else

	begin 

		set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''

		set @query3='  inner join UserMaster um on em.AssignedToId = um.UserId'

		
		IF(@LoggedInUserId <> '0')      

			begin 

				SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoggedInUserId)+';'

			end 

	end 

execute   (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query3+''+@query4)

SELECT @RecordCount = COUNT(*) FROM TempDashboardResult


SET @TotalPagecount = cast(@RecordCount as float)/cast (@PageSize as float)

SELECT *, @RecordCount as TotalRecordCount, ceiling(@TotalPagecount) as TotalPageCount FROM TempDashboardResult

WHERE RowNumber BETWEEN(@PageIndex-1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

DELETE TempDashboardResult
  

END
GO
/****** Object:  StoredProcedure [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_withClassification_old]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_GetWorkQueueListDetails_Pagination_NEW_withClassification_old]  

@SubProcessName varchar(40),

@EMailboxName varchar(40),    

@Status varchar(40),   

@ClassificationName varchar(40), 

@LoggedInUserId varchar(40),    

@PageIndex INT,

@PageSize INT,

@SortExpName varchar(40),

@SortExpOrder varchar(10),

@RecordCount INT OUTPUT

AS                

BEGIN                 

SET NOCOUNT ON;  
        

declare @query1 nvarchar(max)

declare @SortQuery nvarchar(max)

declare @query2 nvarchar(max)

declare @Assignee nvarchar(max)

declare @AssignQuery nvarchar(max)

declare @query3 nvarchar(max)

declare @query4 nvarchar(max)

declare @query6 nvarchar(max)

declare @subprocessID int
declare @EMailboxId int

declare @classificationId bigint

declare @statusId int

DECLARE @TotalPagecount float

		 select @statusId=StatusId from [Status] where REPLACE(StatusDescription,' ','') =REPLACE( @Status,' ','')	
	     Select  @EMailboxId=EmailboxID from Emailbox where EmailboxName=@EMailboxName	
		 select @subprocessID=SubProcessGroupId	 from SubProcessGroups where SubProcessName=@SubProcessName	
if(@ClassificationName<>null or @ClassificationName<>'')
begin		 
		 select @classificationId=ClassificationID from InboundClassification where ClassifiactionDescription=@ClassificationName

  select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     

  from Country c inner join     

  Emailbox eb on c.CountryId = eb.CountryId inner join     

  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

  Status s on em.StatusId = s.StatusId    

  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     

  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID and em.ClassificationID=@classificationId
  
 if(@SortExpName<>'FirstName')

 set @SortExpName='em.'+@SortExpName 

 else 

 set @SortExpName='um.'+@SortExpName 
  
DELETE TempDashboardResult

set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId) select ROW_NUMBER() OVER('

set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder

set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '

set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId  

from EmailMaster em 
inner join InboundClassification IC on em.ClassificationID=IC.ClassificationID
inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
inner join SubProcessGroups SG on eb.SubProcessGroupId=SG.SubProcessGroupId'
SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID) +' and em.ClassificationID='+ convert(varchar(max),@classificationId)+' and em.EmailboxId='+ convert(varchar(max),@EMailboxId)
end
else
begin
 select distinct c.CountryId, c.Country, eb.EMailboxId,eb.EMailboxName, s.StatusId, s.StatusDescription     

  from Country c inner join     

  Emailbox eb on c.CountryId = eb.CountryId inner join     

  EmailMaster em on eb.EMailboxId = em.EMailboxId left join     

  Status s on em.StatusId = s.StatusId    

  where em.StatusId = @StatusId --and eb.CountryId = @CountryId     

  and em.EMailboxId = @EMailboxId and Eb.SubProcessGroupId=@subprocessID
  
 if(@SortExpName<>'FirstName')

 set @SortExpName='em.'+@SortExpName 

 else 

 set @SortExpName='um.'+@SortExpName 
  
DELETE TempDashboardResult

set @query1='insert into TempDashboardResult (RowNumber,CaseId,ReceivedDate,Sender,Subject,AssignedTo,IsUrgent,CountryId,EMailBoxId,StatusId) select ROW_NUMBER() OVER('

set @SortQuery=' ORDER BY em.IsUrgent desc, '+@SortExpName +' '+ @SortExpOrder

set @query2=')AS RowNumber, em.CaseId, CONVERT(VARCHAR(10), em.EmailReceivedDate, 103) +'' '' +CONVERT(VARCHAR(8), em.EmailReceivedDate, 108) ReceivedDate,em.EMailFrom as Sender,em.Subject, '

set @AssignQuery=' as AssignedTo, case when em.IsUrgent=1 then ''High'' else ''Low'' end IsUrgent, eb.CountryId, eb.EmailboxId, em.StatusId  

from EmailMaster em 
inner join Emailbox eb on em.EmailboxId = eb.EmailboxId 
inner join SubProcessGroups SG on eb.SubProcessGroupId=SG.SubProcessGroupId'
SET @query4=' where em.StatusId = '+ convert(varchar(max), @StatusId)+' and eb.SubProcessGroupId ='+convert(varchar(max),  @subprocessID)+' and em.EmailboxId ='+convert(varchar(max),@EMailboxId)
end
 

 if(@StatusId=1)

	begin 

		set @query3=''

		set @Assignee='''NA'''
		

	end 

 else

	begin 

		set @Assignee= 'um.FirstName + um.LastName +''('' + um.UserId + '')'''

		set @query3='  inner join UserMaster um on em.AssignedToId = um.UserId'

		
		IF(@LoggedInUserId <> '0')      

			begin 

				SET @query4= @query4+' and em.AssignedToId = '+ convert(varchar(max), @LoggedInUserId)+';'

			end 

	end 

execute   (@query1+''+@SortQuery+''+@query2+''+@Assignee+''+@AssignQuery+''+@query3+''+@query4)

SELECT @RecordCount = COUNT(*) FROM TempDashboardResult


SET @TotalPagecount = cast(@RecordCount as float)/cast (@PageSize as float)

SELECT *, @RecordCount as TotalRecordCount, ceiling(@TotalPagecount) as TotalPageCount FROM TempDashboardResult

WHERE RowNumber BETWEEN(@PageIndex-1) * @PageSize + 1 AND(((@PageIndex -1) * @PageSize + 1) + @PageSize) - 1

DELETE TempDashboardResult
  

END
GO
/****** Object:  StoredProcedure [dbo].[USP_IGNOREMANUALCASE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
* CREATED BY : RAGUVARAN E
* CREATED DATE : 05/26/2014
* PURPOSE : TO IGNORE A MANUAL IF EMAIL SENDING FAILED
*/

CREATE PROCEDURE [dbo].[USP_IGNOREMANUALCASE]
(
	@CASEID AS BIGINT
)
AS
BEGIN

DECLARE @FROMSTATUS INT
DECLARE @ASSIGNEDTOID VARCHAR(20)

SELECT @FROMSTATUS=STATUSID,@ASSIGNEDTOID=ASSIGNEDTOID FROM EMAILMASTER WHERE CASEID=@CASEID

UPDATE EMAILMASTER SET STATUSID=6,MODIFIEDBYID=@ASSIGNEDTOID,MODIFIEDDATE=GETDATE(),LASTCOMMENT='Email sending failed. So this case has been ignored.' WHERE CASEID=@CASEID

INSERT INTO EMAILAUDIT (CASEID,FROMSTATUSID,TOSTATUSID,USERID,STARTTIME,ENDTIME)
VALUES (@CASEID,@FROMSTATUS,6,@ASSIGNEDTOID,GETDATE(),GETDATE())

END






GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_ClassificationID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Insert_ClassificationID]   
(
	@ClassificationDetails ClassificationDetails_NLP readonly
)   
AS  
 BEGIN  
	 create table #temp_category         
	(			
		ClassificationDescription varchar(100),
		Row_no int
	) 
	
	insert into #temp_category	
	select distinct ClassificationDescription,ROW_NUMBER() over(order by ClassificationDescription) from @ClassificationDetails 
	

	declare @j int
	declare @Category_count int
	declare @category_name varchar(100)

	set @j=1
	set @Category_count=(select count(*) from #temp_category)
	while(@j<=@Category_count)
	begin
		set @category_name=(select ClassificationDescription from #temp_category where Row_no=@j)
		if not exists(select * from InboundClassification where ClassifiactionDescription=@category_name)
		begin
			insert into InboundClassification(ClassifiactionDescription,CreatedBy,CreatedDate,IsActive)values(@category_name,NULL,getdate(),1)			
		end		
		set @j=@j+1
	end
	select * from #temp_category
	drop table #temp_category

	 create table #temp_NLP         
	(
		Row_no int,
		Case_Id int,
		Classification_Id bigint
	) 
	Insert into #temp_NLP
	select ROW_NUMBER() over (order by CD.CaseId),CD.CaseId,IC.ClassificationId from @ClassificationDetails CD	
	inner join InboundClassification IC on CD.[ClassificationDescription]=IC.[ClassifiactionDescription]	
	
	declare @Caseid int
	declare @Classification_Id int
	declare @i int
	declare @temp_count int	
	set @i=1
	set @temp_count=(select count(*) from #temp_NLP)
	while (@i<=@temp_count)
	begin
		select @Classification_Id=Classification_Id,@Caseid=Case_Id from #temp_NLP where Row_no=@i			 

		insert into ClassificationAudit(CaseId,FromClassificationId,ToClassificationId,ModifiedById,IsRemapped,CreatedDate)
		values(@Caseid,@Classification_Id,NULL,NULL,0,getutcdate())

		update EMailMaster set ClassificationId=@Classification_Id
		where CaseId=@Caseid		

		set @i=@i+1

	end
	
	drop table #temp_NLP
	--Update EMailMaster set ClassificationID=
	--(select ClassificationID from InboundClassification IC where ClassifiactionDescription=(select ClassificationDescription from @ClassificationDetails))
	--where CaseId=(select CaseId from @ClassificationDetails)		
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_EMailDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

 CREATED BY : RAGUVARAN E

 * CREATED DATE : 05/26/2014

 *PURPOSE : TO GET THE EMAILBOX DETAILS FOR SENDING EMAIL

[dbo].[USP_Update_Followup_Details]
*/

CREATE PROCEDURE [dbo].[USP_Insert_EMailDetails]
(

@CASEID AS BIGINT,

@EMAILTO AS VARCHAR(MAX),

@EMAILCC AS VARCHAR(MAX),

@EMAILBCC  AS VARCHAR(MAX),

@SUBJECT AS VARCHAR(MAX),

@EMAILBODY AS VARCHAR(MAX),

@EMAILTYPEID AS INT,

@EMAILSENTDATE AS DATETIME,

@SENTSTATUS AS BIT,

@plainbody AS VARCHAR(MAX),

@ishighimp as bit
)

AS

BEGIN

DECLARE @REQUIRED BIT 

SELECT @REQUIRED=IsUrgent FROM EMAILMASTER WHERE CASEID=@CaseId

UPDATE EMAILMASTER SET  AutoReplyText=Null, AutoReplyReceivedTime=NULL WHERE CASEID=@CASEID  

IF(@REQUIRED=0)
begin 
	UPDATE EMAILMASTER SET IsUrgent=@ishighimp WHERE CASEID=@CaseId  
end 

--IF not exists(select * from EMAILSENT where CaseId=@CASEID)
--begin
--		IF exists(select * from EmailMaster where CaseId=@CASEID and IsManual=1)
--		begin
--			update EmailMaster set IsUrgent=@ishighimp where CaseId=@CASEID
--		end
--end


IF @EMAILTYPEID = 3

BEGIN
		Declare @AuditIDD bigint

		Select @AuditIDD=EmailAuditId from EMAILAUDIT where CaseId=@CASEID and FromStatusId=1 and ToStatusId=3

	INSERT INTO EMAILSENT (CASEID,EMAILTO,EMAILCC,SUBJECT,EMAILBODY,EMAILTYPEID,EMAILSENTDATE,SENTSTATUS,AuditID,Plainbody,EMailBcc)
	VALUES (@CASEID,@EMAILTO,@EMAILCC,@SUBJECT,@EMAILBODY,@EMAILTYPEID,@EMAILSENTDATE,@SENTSTATUS,@AuditIDD,@plainbody,@EMAILBCC)

END

ELSE

BEGIN
	INSERT INTO EMAILSENT (CASEID,EMAILTO,EMAILCC,SUBJECT,EMAILBODY,EMAILTYPEID,EMAILSENTDATE,SENTSTATUS,Plainbody,EMailBcc)
	VALUES (@CASEID,@EMAILTO,@EMAILCC,@SUBJECT,@EMAILBODY,@EMAILTYPEID,@EMAILSENTDATE,@SENTSTATUS,@plainbody,@EMAILBCC)

END

END
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_EMailDetails_old]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*

 CREATED BY : RAGUVARAN E

 * CREATED DATE : 05/26/2014

 *PURPOSE : TO GET THE EMAILBOX DETAILS FOR SENDING EMAIL

[dbo].[USP_Update_Followup_Details]
*/

CREATE PROCEDURE [dbo].[USP_Insert_EMailDetails_old]
(

@CASEID AS BIGINT,

@EMAILTO AS VARCHAR(MAX),

@EMAILCC AS VARCHAR(MAX),

@EMAILBCC AS VARCHAR(MAX),

@SUBJECT AS VARCHAR(MAX),

@EMAILBODY AS VARCHAR(MAX),

@EMAILTYPEID AS INT,

@EMAILSENTDATE AS DATETIME,

@SENTSTATUS AS BIT,

@plainbody AS VARCHAR(MAX),

@ishighimp as bit,

@IsVip as bit
)

AS

BEGIN

DECLARE @REQUIRED BIT 

SELECT @REQUIRED=IsUrgent FROM EMAILMASTER WHERE CASEID=@CaseId

UPDATE EMAILMASTER SET  AutoReplyText=Null, AutoReplyReceivedTime=NULL WHERE CASEID=@CASEID  

IF(@REQUIRED=0)
begin 
	UPDATE EMAILMASTER SET IsUrgent=@ishighimp,IsVipMail=@IsVip WHERE CASEID=@CaseId  
end 

--IF not exists(select * from EMAILSENT where CaseId=@CASEID)
--begin
--		IF exists(select * from EmailMaster where CaseId=@CASEID and IsManual=1)
--		begin
--			update EmailMaster set IsUrgent=@ishighimp where CaseId=@CASEID
--		end
--end


IF @EMAILTYPEID = 3

BEGIN
		Declare @AuditIDD bigint

		Select @AuditIDD=EmailAuditId from EMAILAUDIT where CaseId=@CASEID and FromStatusId=1 and ToStatusId=3

	INSERT INTO EMAILSENT (CASEID,EMAILTO,EMAILCC,EMailBcc,SUBJECT,EMAILBODY,EMAILTYPEID,EMAILSENTDATE,SENTSTATUS,AuditID,Plainbody)
	VALUES (@CASEID,@EMAILTO,@EMAILCC,@EMAILBCC,@SUBJECT,@EMAILBODY,@EMAILTYPEID,@EMAILSENTDATE,@SENTSTATUS,@AuditIDD,@plainbody)

END

ELSE

BEGIN
	INSERT INTO EMAILSENT (CASEID,EMAILTO,EMAILCC,EMailBcc,SUBJECT,EMAILBODY,EMAILTYPEID,EMAILSENTDATE,SENTSTATUS,Plainbody)
	VALUES (@CASEID,@EMAILTO,@EMAILCC,@EMAILBCC,@SUBJECT,@EMAILBODY,@EMAILTYPEID,@EMAILSENTDATE,@SENTSTATUS,@plainbody)

END

END


GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_HOLIDAY_DETAILS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_helptext USP_CREATE_USERS

--EXEC [USP_CREATE_USERS] '254649','Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, '254649', getutcdate()  
-- =======================================================  
-- Author:  Kalaichelvan KB        
-- Create date: 07/11/2014        
-- Description: To insert the Holiday Details into the master table  
-- =======================================================  
  
CREATE PROCEDURE [dbo].[USP_INSERT_HOLIDAY_DETAILS]
(    
@HolidayDesc VARCHAR(100),  
@HolidayDATE DATETIME,
@ISACTIVE INT,
@LoggedinUserId VARCHAR(50)
)  
AS  
 BEGIN  
  IF not exists (SELECT HOLIDAYDATE FROM HOLIDAY WHERE HOLIDAYDATE=@HOLIDAYDATE)
   BEGIN  
    INSERT INTO HOLIDAY (HOLIDAYDESCRIPTION, HOLIDAYDATE, Isactive, CreatedById, CreatedDate, TotalMinutes)
    VALUES (@HolidayDesc, @HolidayDATE, @ISACTIVE, @LoggedinUserId , Convert(Varchar(10),getutcdate(),101), 1440)
    Select   1  
   END  
  Select   0  
 END  
   --INSERT INTO HOLIDAY (HOLIDAYDESCRIPTION, HOLIDAYDATE, Isactive, CreatedByID, CreatedDate)
   -- VALUES (@HolidayDesc, @HolidayDATE, @ISACTIVE, @LoggedinUserId, convert(varchar(10),getutcdate(),101))
--select * from UserMaster  
  
--insert into UserMaster values (254649,'Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, 254649, getutcdate())  
  
  
  --IF not exists (SELECT USERID,eMAIL FROM USERMASTER WHERE USERID=254649 AND EMAIL='Kalaichelvan.KB@Cognizant.com')  
  --select 1    
  --else select 0  
  --return
  --select * from holiday
  --truncate table holiday
  --select * from emailbox
 -- insert into holiday values('test', getutcdate()+1, 1, '226958', getutcdate(), 1440 )
-- select Convert(Varchar(10),getutcdate(),101)







GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_Mail_Attachment]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Insert_Mail_Attachment]            

(            

@ConversationID bigint,   

@AttachmentName varchar(100),  

@ContentType varchar(50),  

@AttachmentData IMAGE,      

@AttachmentType int,  

@CreatedBy varchar(50)  

)           

AS            

BEGIN             
  
		
		INSERT INTO EMailAttachment( FileName,Content,ConversationID,CreatedBy,CreatedDate,AttachmentTypeID,ContentType)  

		VALUES (@ATTACHMENTNAME,@AttachmentData,@ConversationID,@CreatedBy,getutcdate(),@AttachmentType,@ContentType)  

           

             

END



GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_Mail_Attachment_Draft_att]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Insert_Mail_Attachment_Draft_att]            

(            

@CaseId bigint,   

@AttachmentName varchar(100),  

@ContentType varchar(50),  

@AttachmentData IMAGE,      

@AttachmentType int,  

@CreatedBy varchar(50)  

)           

AS            

BEGIN             
  
		
		INSERT INTO Draftsave_att ( FileName,Content,CaseId,CreatedBy,CreatedDate,AttachmentTypeID,ContentType)  

		VALUES (@ATTACHMENTNAME,@AttachmentData,@CaseId,@CreatedBy,getutcdate(),@AttachmentType,@ContentType)  

           

             

END



GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_Mail_Attachment_For_Reopen_Cases]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/*

* CREATED BY : Pranay Ahuja

* CREATED DATE : 10/05/2016

* PURPOSE : TO GET THE CASE DETAILS TO DISPLAY IN PROCESSING PAGE

*/

CREATE PROCEDURE [dbo].[USP_Insert_Mail_Attachment_For_Reopen_Cases]
(
@OLDCASEID AS BIGINT,
@NEWCASEID AS BIGINT
)
AS 

Begin
SET NOCOUNT ON;  

IF EXISTS (SELECT CaseId FROM EmailMaster WHERE CaseId=@NEWCASEID)
  Begin
	insert into dbo.EMailAttachment
	(FileName,ContentType,Content,CaseId,CreatedBy,CreatedDate,AttachmentTypeID,IsDeleted) 
    ((select FileName,ContentType,Content,@NEWCASEID,CreatedBy,getutcdate(),AttachmentTypeID,IsDeleted 
	from dbo.EMailAttachment where CaseId = @OLDCASEID))
	END

END



GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_Mail_Conversation]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Insert_Mail_Conversation]            
(
@Subject varchar(max),
@From_Add varchar(250),
@Toaddress varchar(max),
@CCaddress varchar(max),
@BCCaddress varchar(max),
@ConversationDate datetime,          
@CaseId bigint,   
@AttachmentName varchar(100),  
@ContentType varchar(50),  
@AttachmentData IMAGE,      
@AttachmentType int,  
@CreatedBy varchar(50)
)           
AS            
BEGIN             
SET NOCOUNT ON;       



   		
		INSERT INTO EmailConversations( Subject,EmailFrom,EmailTo,EmailCc,EmailBcc,ConversationDate,Content,CaseId,CreatedBy,CreatedDate,AttachmentTypeID,IsDeleted)  
		VALUES (@Subject,@From_Add,@Toaddress,@CCaddress,@BCCaddress,@ConversationDate,@AttachmentData,@CaseId,@CreatedBy,GETDATE(),@AttachmentType,0)  
    
  
   SELECT SCOPE_IDENTITY();    
             
             
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_MailCaseDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Insert_MailCaseDetails]            
            
@Received_date DateTime,            
@MailFolder_Id varchar(10),            
@Status_Id varchar(10),            
@Subject varchar(500),            
@Message varchar(7000),            
@From_Add varchar(200),    
@Toaddress varchar(4000),     
@CCaddress varchar(4000),        
@BCCaddress varchar(4000),
@Priority bit,
@Bodycontent varchar(7000),
@IsVip bit 

AS            
BEGIN             
SET NOCOUNT ON;            
            
            
--IF NOT EXISTS(SELECT CaseID FROM EMAILMASTER WHERE Subject = @Subject AND EMailReceivedDate = @Received_date)    
--BEGIN    
            
  INSERT INTO EMAILMASTER(statusid,EMailReceivedDate,EMailBoxId ,Subject,EMailBody,EMailFrom,EmailTo,EmailCc,EmailBcc,CreatedDate,IsUrgent,IsManual,Bodycontent,IsVipMail)            
  VALUES(1,@Received_date, @MailFolder_Id, @Subject,@Message,@From_Add,@Toaddress,@CCaddress,@BCCaddress,getutcdate(),@Priority,0,@Bodycontent,@IsVip)            
  
--END            
    select SCOPE_IDENTITY();              
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_MailCaseDetails_dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Insert_MailCaseDetails_dynamic]            
            
@Received_date DateTime,            
@MailFolder_Id varchar(10),            
@Status_Id varchar(10),            
@Subject varchar(500),            
@Message varchar(7000),            
@From_Add varchar(200),    
@Toaddress varchar(4000),     
@CCaddress varchar(4000),        
@BCCaddress varchar(4000),
@Priority bit,
@Bodycontent varchar(7000),
@IsVip bit ,
@IsDuplicate bit
AS            
BEGIN             
SET NOCOUNT ON;            
            
declare @Subprocessid int
declare @Status int
set @Subprocessid=(select SubProcessGroupId from EMailBox where EMailBoxId=@MailFolder_Id)
if(@isduplicate=0)
begin
if exists(select * from Status where SubProcessID=@Subprocessid)
set @Status=(select StatusId from Status where SubProcessID=@Subprocessid and IsInitalStatus=1  and StatusDescription!='Duplicate')
else
set @Status=(select StatusId from Status where SubProcessID is null and IsInitalStatus=1)
    end
	else
	set @Status=(select StatusId from Status where SubProcessID=@Subprocessid and StatusDescription='Duplicate')
  INSERT INTO EMAILMASTER(statusid,EMailReceivedDate,EMailBoxId ,Subject,EMailBody,EMailFrom,EmailTo,EmailCc,EmailBcc,CreatedDate,IsUrgent,IsManual,Bodycontent,IsVipMail)            
  VALUES(@Status,@Received_date, @MailFolder_Id, @Subject,@Message,@From_Add,@Toaddress,@CCaddress,@BCCaddress,getutcdate(),@Priority,0,@Bodycontent,@IsVip)            

    select SCOPE_IDENTITY();              
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_MailCaseDetails_old]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Insert_MailCaseDetails_old]            
            
@Received_date DateTime,            
@MailFolder_Id varchar(10),            
@Status_Id varchar(10),            
@Subject varchar(500),            
@Message varchar(7000),            
@From_Add varchar(200),    
@Toaddress varchar(4000),     
@CCaddress varchar(4000),        
@BCCaddress varchar(4000),
@Priority bit,
@Bodycontent varchar(7000)
  
AS            
BEGIN             
SET NOCOUNT ON;            
            
            
--IF NOT EXISTS(SELECT CaseID FROM EMAILMASTER WHERE Subject = @Subject AND EMailReceivedDate = @Received_date)    
--BEGIN    
            
  INSERT INTO EMAILMASTER(statusid,EMailReceivedDate,EMailBoxId ,Subject,EMailBody,EMailFrom,EmailTo,EmailCc,EmailBcc,CreatedDate,IsUrgent,IsManual,Bodycontent)            
  VALUES(1,@Received_date, @MailFolder_Id, @Subject,@Message,@From_Add,@Toaddress,@CCaddress,@BCCaddress,getutcdate(),@Priority,0,@Bodycontent)            
  
--END            
    select SCOPE_IDENTITY();              
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_MailCaseDetailsForChildCase]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Insert_MailCaseDetailsForChildCase]            
   @ParentCaseId varchar(100),      
@Received_date DateTime,            
@MailFolder_Id varchar(10),            
@Status_Id varchar(10),            
@Subject varchar(500),            
@Message varchar(7000),            
@From_Add varchar(200),    
@Toaddress varchar(4000),     
@CCaddress varchar(4000),        
@BCCaddress varchar(4000),
@Priority bit,
@IsVip bit
  
AS            
BEGIN             
SET NOCOUNT ON;            
            
            
--IF NOT EXISTS(SELECT CaseID FROM EMAILMASTER WHERE Subject = @Subject AND EMailReceivedDate = @Received_date)    
--BEGIN    
            
  
  INSERT INTO EMAILMASTER(statusid,EMailReceivedDate,EMailBoxId ,Subject,EMailBody,EMailFrom,EmailTo,EmailCc,EmailBcc,CreatedDate,IsUrgent,IsManual,IsVipMail,ParentCaseId)            
  (select 1,@Received_date, @MailFolder_Id, @Subject,@Message,EMailFrom,@Toaddress,EmailCc,EmailBcc,getdate(),@Priority,0,@IsVip,CaseId from EmailMaster where CaseId=@ParentCaseId)            
  
--END            
    select SCOPE_IDENTITY();              
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_MailCaseDetailsForChildCase_dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[USP_Insert_MailCaseDetailsForChildCase_dynamic]            
   @ParentCaseId varchar(100),      
@Received_date DateTime,            
@MailFolder_Id varchar(10),            
@Status_Id varchar(10),            
@Subject varchar(500),            
@Message varchar(7000),            
@From_Add varchar(200),    
@Toaddress varchar(4000),     
@CCaddress varchar(4000),        
@BCCaddress varchar(4000),
@Priority bit,
@IsVip bit
  
AS            
BEGIN             
SET NOCOUNT ON;            
      
declare @Subprocessid nvarchar(250)
declare @Status nvarchar(250)
set @Subprocessid=(select SubProcessGroupId from EMailBox where EMailBoxId=@MailFolder_Id)
if exists(select * from Status where SubProcessID=@Subprocessid)
set @Status=(select StatusId from Status where SubProcessID=@Subprocessid and IsInitalStatus=1)
else
set @Status=(select StatusId from Status where SubProcessID is null and IsInitalStatus=1)
        
            
--IF NOT EXISTS(SELECT CaseID FROM EMAILMASTER WHERE Subject = @Subject AND EMailReceivedDate = @Received_date)    
--BEGIN    
            
  
  INSERT INTO EMAILMASTER(statusid,EMailReceivedDate,EMailBoxId ,Subject,EMailBody,EMailFrom,EmailTo,EmailCc,EmailBcc,CreatedDate,IsUrgent,IsManual,IsVipMail,ParentCaseId)            
  (select @Status,@Received_date, @MailFolder_Id, @Subject,@Message,EMailFrom,@Toaddress,EmailCc,EmailBcc,getdate(),@Priority,0,@IsVip,CaseId from EmailMaster where CaseId=@ParentCaseId)            
  
--END            
    select SCOPE_IDENTITY();              
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_MailCaseDetailsForChildCase_old]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Insert_MailCaseDetailsForChildCase_old]            
   @ParentCaseId varchar(100),      
@Received_date DateTime,            
@MailFolder_Id varchar(10),            
@Status_Id varchar(10),            
@Subject varchar(500),            
@Message varchar(7000),            
@From_Add varchar(200),    
@Toaddress varchar(4000),     
@CCaddress varchar(4000),        
@BCCaddress varchar(4000),
@Priority bit
  
  
AS            
BEGIN             
SET NOCOUNT ON;            
            
            
--IF NOT EXISTS(SELECT CaseID FROM EMAILMASTER WHERE Subject = @Subject AND EMailReceivedDate = @Received_date)    
--BEGIN    
            
  
  INSERT INTO EMAILMASTER(statusid,EMailReceivedDate,EMailBoxId ,Subject,EMailBody,EMailFrom,EmailTo,EmailCc,EmailBcc,CreatedDate,IsUrgent,IsManual,ParentCaseId)            
  (select 1,@Received_date, @MailFolder_Id, @Subject,@Message,EMailFrom,@Toaddress,EmailCc,EmailBcc,getdate(),@Priority,0,CaseId from EmailMaster where CaseId=@ParentCaseId)            
  
--END            
    select SCOPE_IDENTITY();              
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Insert_MailCaseDetailsForReopenCases]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_Insert_MailCaseDetailsForReopenCases]            
            
@Received_date DateTime,            
@MailFolder_Id varchar(10),            
@Status_Id varchar(10),            
@Subject varchar(500),            
@Message varchar(7000),            
@From_Add varchar(200),    
@Toaddress varchar(4000),     
@CCaddress varchar(4000),        
@BCCaddress varchar(4000),
@Priority bit,
@IsManual bit
  
  
AS            
BEGIN             
SET NOCOUNT ON;   
 declare @EmailBoxId int 
	   declare @SubProcessId int
	  declare @InitialStatus int     
     
	 Select @SubProcessId=SubprocessGroupId from Emailbox where Emailboxid=@MailFolder_Id

	 if exists(select * from dbo.Status where SubProcessID=@SubProcessId and IsActive='1')
	Begin
	select @InitialStatus=StatusId from dbo.Status where SubProcessID=@SubProcessId and IsInitalStatus='1' and StatusDescription!='Duplicate' and IsActive='1'
	end
	
	else
	begin
	select @InitialStatus=StatusId from dbo.Status where SubProcessID is null and IsInitalStatus='1' and StatusDescription!='Duplicate' and IsActive='1'
	end  
	    
            
--IF NOT EXISTS(SELECT CaseID FROM EMAILMASTER WHERE Subject = @Subject AND EMailReceivedDate = @Received_date)    
--BEGIN    
            
  INSERT INTO EMAILMASTER(statusid,EMailReceivedDate,EMailBoxId ,Subject,EMailBody,EMailFrom,EmailTo,EmailCc,EmailBcc,CreatedDate,IsUrgent,IsManual)            
  VALUES(@InitialStatus,@Received_date, @MailFolder_Id, @Subject,@Message,@From_Add,@Toaddress,@CCaddress,@BCCaddress,getutcdate(),@Priority,@IsManual)            
  
--END            
    select SCOPE_IDENTITY();              
END



GO
/****** Object:  StoredProcedure [dbo].[USP_INSERT_SURVEYDETAILS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
-- ===========================================================

-- Author  : Pranay

-- Created Date : 4/12/2017

-- Description:  For Inserting Survey Details 

-- ===========================================================

CREATE PROCEDURE [dbo].[USP_INSERT_SURVEYDETAILS]    
(    
@VOCQUALITY varchar(20),
@VOCREASON varchar(max),  
@VOCTAT varchar(20),
@VOCTATREASON varchar(max),
@COMMENTS varchar(max),
@CASEID int

)    
AS    
BEGIN    
 IF NOT EXISTS (SELECT *  FROM .SurveyVOC_Details WHERE CaseId in (@CASEID))       

		 BEGIN

			INSERT INTO [dbo].[SurveyVOC_Details](CaseID,VOC_Quality,VOC_Reason,VOC_TurnaroundTime,VOC_TAT_Reason,Comments) values (@CASEID,@VOCQUALITY,@VOCREASON,@VOCTAT,@VOCTATREASON,@COMMENTS)
			select 1
		 END 

		 ELSE   
            
		 BEGIN
		 Update [dbo].[SurveyVOC_Details] set VOC_Quality=@VOCQUALITY,VOC_Reason=@VOCREASON,VOC_TurnaroundTime=@VOCTAT,VOC_TAT_Reason=@VOCTATREASON,Comments=@COMMENTS where CaseID in (@CASEID)
         Select 2 
		 END 
   

END
GO
/****** Object:  StoredProcedure [dbo].[USP_InsertConfigureFields]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
















CREATE proc [dbo].[USP_InsertConfigureFields]   















@CountryID bigint,     















@MailboxID BigInt,        















@FieldName nvarchar(2000),        















@FieldTypeId BigInt,        















@FieldDataTypeID BigInt,        















@ValidationTypeID BigInt,        















@TextLength nvarchar(200) = null,        















@defaultValue nvarchar(200),        















@Active int,        















@CreatedBy nvarchar(500),



@FieldAliasName nvarchar(500),

@Mandatory int        















        















As        















Begin        















        















      















        















Declare @Retval int         















        















        















 BEGIN TRAN TXN_INSERT        















   BEGIN TRY        















 















 if not exists (Select StaticFieldName from Tbl_Master_StaticFields where ltrim(rtrim(lower(StaticFieldName))) = ltrim(rtrim(lower(@FieldName)))















 or ltrim(rtrim(lower(StaticFieldDisplayName))) = ltrim(rtrim(lower(@FieldName))))















 Begin















	  	  	  	  	  	  	  	  if not exists (Select FieldName from Tbl_FieldConfiguration where ltrim(rtrim(lower(FieldName))) = ltrim(rtrim(lower(@FieldName))) and MailBoxID=@MailboxID)















  







											 begin







													 Insert into dbo.Tbl_FieldConfiguration (FieldName,MailboxID,FieldTypeId,FieldDataTypeID,ValidationTypeID,        















													   TextLength,DefaultValue,Active,CreatedBy,CountryID,FieldAliasName,FieldPrivilegeID)        















													   Values(@FieldName,@MailboxID,@FieldTypeId,@FieldDataTypeID,@ValidationTypeID,@TextLength,@DefaultValue,@Active,@CreatedBy,@CountryID,@FieldAliasName,@Mandatory)        















													Set @Retval = 1        















													Select @Retval  







											 end







										 else







															 begin







															 Set @Retval = 3  -- already availble to same mailbox      















															Select @Retval  







										 end















        







       















	End































Else















Begin















Set @Retval = 2  -- already availble to as master value       















Select @Retval  















End        















END TRY        















            BEGIN CATCH        















                  GOTO HandleError1        















            END CATCH        















            IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT        















            RETURN 1        















      HandleError1:        















            IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT        















            RAISERROR('Error Insert table Tbl_FieldConfiguration', 16, 1)        















            RETURN -1        















        















        















        















End










GO
/****** Object:  StoredProcedure [dbo].[USP_InsertDetailsForFlaggedCases]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[USP_InsertDetailsForFlaggedCases]            
    
@Caseid Bigint,          
@CountryId Int,            
@EmailBoxId varchar(10),            
@ReferenceId Bigint,            
@ReferencedBy varchar(50),            
@CreatedDate varchar(7000)           

AS            
BEGIN             
--SET NOCOUNT ON;            
            
            
IF NOT EXISTS(SELECT * FROM dbo.FlagCaseMaster WHERE CaseId = @Caseid AND EmailboxId=@EmailBoxId AND Reference=@ReferenceId AND IsActive=1)    
BEGIN    
            
	  INSERT INTO dbo.FlagCaseMaster(CountryId,EmailBoxId,CaseId,Reference,CreatedbyId,CreatedDate,IsActive)            
	  VALUES(@CountryId,@EmailBoxId,@Caseid,@ReferenceId,@ReferencedBy,@CreatedDate,1)            
	  
	  Select 1
END  

ELSE
BEGIN
	 SELECT 0          
 END
   -- select SCOPE_IDENTITY();              
END 


GO
/****** Object:  StoredProcedure [dbo].[USP_InsertProductLicenseKey]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_InsertProductLicenseKey] 
(
  @LicenseKey AS VARCHAR(max),
  @Clientname AS VARCHAR(MAx)
) 
AS
 
BEGIN

INSERT INTO ProductLicense(LicenseKey,Clientname) 
values(@LicenseKey,@Clientname)

END
GO
/****** Object:  StoredProcedure [dbo].[USP_IsAccountLocked]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
     
        
CREATE PROC [dbo].[USP_IsAccountLocked] 
(   
@UserID varchar(20)    
     
)
--@success int out     
AS            
Begin    
 IF EXISTS (SELECT UserID FROM USERMASTER WHERE [UserId] = @UserID and IsLocked=1)
    Select 1
    else
    Select 0
END 
 
 --  group by UR.RoleDescription    
-- USE [EMT_Main_Sprint]  select * from usermaster    
-- select * from UserRoleMapping     
-- select * from userrole    
    
---update usermaster set IsLocked=0 where userid='195174'
GO
/****** Object:  StoredProcedure [dbo].[USP_IsAlreadyExist]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[USP_IsAlreadyExist]  
(  
@MailFolder_Id varchar(10),  
@Received_date datetime,  
@From_Add varchar(500),  
@Subject nvarchar(max),
@IsExist int out  
)  
AS    
 set nocount on;    
  BEGIN    
  if  EXISTS (select CaseId from EmailMaster where EMailBoxId=@MailFolder_Id and EMailReceivedDate = @Received_date and EMailFrom=@From_Add and Subject=@Subject)  
    BEGIN              
    set @IsExist = 1     
    END     
  else    
    BEGIN              
    set @IsExist = 0    
    END   
  END






GO
/****** Object:  StoredProcedure [dbo].[USP_IsSkillBasedAllocation]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[USP_IsSkillBasedAllocation](
@EmailBoxId int
) as 
begin 
   Select IsSkillBasedAllocation from dbo.EMailBox where EmailBoxId=@EmailBoxId
end


GO
/****** Object:  StoredProcedure [dbo].[USP_KPI_GETTAT]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [USP_KPI_GETTAT_test] '04-01-2016','04-27-2017',2, 4,2,'+05:30' ,'5'
/*  
* CREATED BY : RAGUVARAN E  

* CREATED DATE : 07/16/2014  
* PURPOSE : TO GET THE CASE WISE TAT DETAILS  

*/  
CREATE PROCEDURE [dbo].[USP_KPI_GETTAT]  
(  

 @FROMDATE DATETIME,  
 
 @TODATE DATETIME,  
 
 @SUBPROCESSGROUPID INT,  
 
 @COUNTRYID INT,  

  @EMAILBOXID INT  ,
  
  @OFFSET VARCHAR(30),

  @CategoryID varchar(200)  

 )  
 
AS  

BEGIN  

DECLARE @CONVERTSECONDSTOMIN DECIMAL  

SELECT @CONVERTSECONDSTOMIN = 1  

DECLARE @EMTTAT TABLE  

(  
 CASEID BIGINT,  
 
 EMTTAT DECIMAL(18,2),  
  SLA INT,  
 COUNTRY VARCHAR(25),
 EMAILBOXNAME  VARCHAR(25),  
 SUBPROCESSNAME VARCHAR(25),
 /*--Nagababu merge SP relate to Stackland servey POC*/
 CATEGORYNAME Varchar(25),  
 ISMANUAL BIT,  
 CREATEDDATE DATETIME,  
 COMPLETEDDATE DATETIME,  
 LASTCOMMENT VARCHAR(MAX),  
 ASSIGNEDTO VARCHAR(250),
 -- Pranay 18 January 2017 For adding Response and Comments provided by user as User Survey
 --SURVEYRESPONSE VARCHAR(50),
 --SURVEYCOMMENTS VARCHAR(4000)
 VOCQUALITY VARCHAR(50),
 VOCREASON VARCHAR(MAX),
 VOCTURNAROUNDTIME VARCHAR(50),
 VOCTATREASON VARCHAR(MAX),
 SURVEYCOMMENTS VARCHAR(MAX)  
)  
DECLARE @PROVIDED TABLE             
(  
 ROW BIGINT,  
 AUDITID BIGINT,             
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME            
)   
DECLARE @NEEDED TABLE             
(      
 ROW BIGINT,        
 AUDITID BIGINT,             
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME            
) 
DECLARE @PREFINALX TABLE            
(            
 AAUDIT BIGINT,             
 ACASEID BIGINT,              
 ATOCASESTATUSID INT,             
 AENDTIME DATETIME,              
 AUDITID BIGINT,            
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME,             
 DIFF INT,            
 DDIFF BIGINT            
)  

DECLARE @PREFINAL TABLE                           
(                          
 CASEID BIGINT,                           
 IDIFF BIGINT                          
) 

/*Nagababu merger code for ONHOLD*..Start*/

DECLARE @ONHOLD Table
(
CASEID BIGINT,
DIFF BIGINT
)
 -- GET EMT TAT             

 if @CategoryID is not null      
 begin
  INSERT INTO @EMTTAT             
 SELECT EM.CASEID  
  --,CAST(AVG ( CAST((DBO.FN_TAT_EXCLUDECUTOFFTIME(EM.CREATEDDATE, EM.COMPLETEDDATE)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  --,CAST(AVG ( CAST((DBO.FN_TAT_EXCLUDECUTOFFTIME([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
  ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  ,EB.TATINSECONDS AS SLA  
  ,C.COUNTRY  
  ,EB.EMAILBOXNAME  
  ,SG.SUBPROCESSNAME 
   ,ECC.CATEGORY  
  ,EM.ISMANUAL  
  --,EM.CREATEDDATE  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET)as 'CREATEDDATE'
  --,EM.COMPLETEDDATE  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE'
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO  
  --Praany 18 January -- Adding Survey Response and Comments
  --,EM.SurveyResponse
  --Pranay 7 April -- Getting details of survey details
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments  
 FROM EMAILMASTER EM WITH (NOLOCK) 
  LEFT JOIN SurveyVOC_Details SVD on Em.CaseId=SVD.CaseID    
 LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
 LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
 LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID  
 LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/
 --inner join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID
 LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId  
 inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item   
 WHERE EM.STATUSID IN (10)  
 AND EM.COMPLETEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.COMPLETEDDATE <= (@TODATE + 1))  
 AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))  
 AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))  
 AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))  
 GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
  ,EM.CREATEDDATE  
  ,EM.COMPLETEDDATE  
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME
  ,ECC.CATEGORY   
    --,EM.SurveyResponse
   --,EM.SurveyComments
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments   
  end
  else
  begin
  SELECT EM.CASEID  
  --,CAST(AVG ( CAST((DBO.FN_TAT_EXCLUDECUTOFFTIME(EM.CREATEDDATE, EM.COMPLETEDDATE)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  --,CAST(AVG ( CAST((DBO.FN_TAT_EXCLUDECUTOFFTIME([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
  ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  ,EB.TATINSECONDS AS SLA  
  ,C.COUNTRY  
  ,EB.EMAILBOXNAME  
  ,SG.SUBPROCESSNAME 
  ,ECC.CATEGORY  
  ,EM.ISMANUAL  
  --,EM.CREATEDDATE  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET)as 'CREATEDDATE'
  --,EM.COMPLETEDDATE  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE'
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO  
 FROM EMAILMASTER EM WITH (NOLOCK)   
 LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
 LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
 LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID  
 LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/
 --inner join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID
 LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId    
 WHERE EM.STATUSID IN (10)  
 AND EM.COMPLETEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.COMPLETEDDATE <= (@TODATE + 1))  
 AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))  
 AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))  
 AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))  
 GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
  ,EM.CREATEDDATE  
  ,EM.COMPLETEDDATE  
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME  
  ,ECC.CATEGORY 
  end

 --SPLIT CLARIFICATION NEEDED AND PROVIDED  
 INSERT INTO @PREFINAL   
 SELECT DISTINCT   
  O.CASEID  
  --,(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIME(AB.ENDTIME,A.ENDTIME))'TOTMINS'
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.   
  ,(SELECT SUM(dbo.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM   
  --(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I WITH (NOLOCK)                        
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                        
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (3)) AB   
  --JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I WITH (NOLOCK)                          
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                          
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (3)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O WITH (NOLOCK)
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (3)                          
 ORDER BY O.CASEID
      
   -- SPLIT PENDING FOR QC DATA  
    INSERT INTO @NEEDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID  
   --,ENDTIME   
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)  
  WHERE  
   TOSTATUSID IN (5)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)            

 -- SPLIT QC APPROVED AND REJECTED DATA  

    INSERT INTO @PROVIDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID  
   --,ENDTIME   
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)
  WHERE                
   TOSTATUSID IN (7,8)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)   

    -- MATCH THE PENDING FOR QC AND QC APPROVED OR REJECTED DATA             



    INSERT INTO @PREFINALX   
  SELECT   
    A.AUDITID 'AAUDIT'  
   ,A.CASEID 'ACASEID'  
   ,A.TOCASESTATUSID 'ATOCASESTATUSID'  
   ,A.ENDTIME 'AENDTIME'  
   ,B.AUDITID  
   ,B.CASEID  
   ,B.TOCASESTATUSID  
   ,B.ENDTIME  
   ,B.AUDITID-A.AUDITID 'DIFF'  
   --,DBO.FN_TAT_EXCLUDECUTOFFTIME(A.ENDTIME, B.ENDTIME) 'DDIFF'              
   --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
   ,dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.ENDTIME, B.ENDTIME) 'DDIFF'              
   FROM @NEEDED A             
   JOIN @PROVIDED B ON A.CASEID = B.CASEID AND A.ROW=B.ROW             
   WHERE B.AUDITID-A.AUDITID  > 0 AND B.AUDITID IS NOT NULL             
   ORDER BY A.CASEID 
  

  /*Nagababu --Getting ONHOLD Time ..Start */



 INSERT INTO @ONHOLD  
 SELECT DISTINCT   
  O.CASEID  
  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM          
  --(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I  
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (13)) AB   
  --JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'FROM EMAILAUDIT I                           
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (13)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O   
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (13)                          
 ORDER BY O.CASEID   

 /*Nagababu --Getting ONHOLD Time ..End */





             

     -- CACLUATE ALL TAT DATA            



    SELECT   
    TAT.CASEID  
   ,TAT.EMTTAT  
   ,TAT.SLA  
   ,TAT.COUNTRY  
   ,TAT.EMAILBOXNAME  
   ,TAT.SUBPROCESSNAME
   ,TAT.CATEGORYNAME   
  ,CAST(AVG(CAST((SiemensTAT.IDIFF/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'SiemensTAT'  
  ,CAST(0 AS BIGINT) AS 'TOTAL'  
  ,CAST(0 AS DECIMAL (18,2)) AS 'COGNIZANTTAT'  
  ,'SLA NOT MET' AS SLASTATUS  
  ,CAST (CAST((SUM(EXCLUDED.DDIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'EXCLUDEDTAT'  
  ,CAST (CAST((SUM(ONHOLD.DIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'ONHOLD' 
  ,TAT.ISMANUAL  
  ,TAT.CREATEDDATE  
  ,TAT.COMPLETEDDATE  
  ,UM.FIRSTNAME +', '+UM.LASTNAME AS LASTQUERYRAISEDBY  
  ,EQ.QUERYTEXT AS LASTQUERY  
  ,TAT.ASSIGNEDTO  
   --,TAT.SURVEYRESPONSE
  ,TAT.VOCQUALITY 
  ,TAT.VOCREASON
  ,TAT.VOCTURNAROUNDTIME
  ,TAT.VOCTATREASON
  ,TAT.SURVEYCOMMENTS
  INTO #FINAL            
   FROM EMAILMASTER EM WITH (NOLOCK)  
   JOIN @EMTTAT TAT ON TAT.CASEID = EM.CASEID   
   LEFT JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID   
   AND EA.EMAILAUDITID IN   
   (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT WITH (NOLOCK) WHERE ToStatusId = 3 AND CASEID=EM.CASEID)  
    LEFT JOIN EMAILQUERY EQ ON EQ.EMAILAUDITid=EA.EMAILAUDITid 
    LEFT JOIN USERMASTER UM ON UM.USERID=EQ.CreatedById 
    LEFT JOIN (SELECT CASEID, IDIFF 'IDIFF' FROM @PREFINAL) SiemensTAT  ON SiemensTAT.CASEID = EM.CASEID    
    LEFT JOIN (SELECT AAUDIT, CASEID, MIN(DDIFF) 'DDIFF', MIN(DIFF) 'DIFF' FROM @PREFINALX GROUP BY AAUDIT, CASEID) EXCLUDED ON EXCLUDED.CASEID = EM.CASEID         
    LEFT JOIN (SELECT CASEID, DIFF 'DIFF' from @ONHOLD)ONHOLD ON ONHOLD.CASEID = EM.CaseId
	GROUP BY TAT.CASEID,TAT.EMTTAT,TAT.SLA,TAT.COUNTRY,TAT.EMAILBOXNAME,TAT.SUBPROCESSNAME,TAT.CATEGORYNAME,TAT.ISMANUAL,TAT.CREATEDDATE,TAT.COMPLETEDDATE,TAT.LASTCOMMENT,TAT.ASSIGNEDTO  
	,UM.FIRSTNAME +', '+UM.LASTNAME ,EQ.QUERYTEXT , 
 TAT.VOCQUALITY,TAT.VOCREASON,TAT.VOCTURNAROUNDTIME,TAT.VOCTATREASON,TAT.SURVEYCOMMENTS  
    -- CALCULATE COGNIZANT TAT AND SLA STATUS  



    UPDATE #FINAL SET             
    TOTAL = ISNULL(SiemensTAT,0) + ISNULL(EXCLUDEDTAT,0)         



    UPDATE #FINAL SET             
    COGNIZANTTAT = (ISNULL(EMTTAT,0) - ISNULL(TOTAL,0)- ISNULL(ONHOLD,0))  

	   

    UPDATE #FINAL SET             
    SLASTATUS = CASE WHEN COGNIZANTTAT<SLA THEN 'SLA MET' when (COGNIZANTTAT =0 OR SLA=0) then 'NA' WHEN SLA=00 THEN 'NA' WHEN SLA=000 THEN 'NA' ELSE SLASTATUS END  
 
 

    -- GET FINAL DATA OUTPUT            

 SELECT   
   CASEID  
  ,COUNTRY  
  ,SUBPROCESSNAME AS SUBPROCESS  
  ,EMAILBOXNAME AS EMAILBOX  
  ,ISNULL(CATEGORYNAME,'NA') AS CATEGORYNAME
  ,CASE WHEN ISMANUAL=0 THEN 'EMAIL CASE' ELSE 'MANUAL CASE' END AS CASETYPE  
  ,CONVERT(VARCHAR, CREATEDDATE, 103)+' '+CONVERT(VARCHAR, CREATEDDATE, 108) AS STARTDATE  
  ,CONVERT(VARCHAR, COMPLETEDDATE, 103)+' '+CONVERT(VARCHAR, COMPLETEDDATE, 108) AS ENDDATE  

  

  --,' ||  ' +CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00))) + '  ||'  AS TOTALTAT



    --,' ||  ' +CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00))) + '  ||'  AS SiemensTAT  



  --,' ||  ' +CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) + '  ||'  AS EXCLUDEDTAT  

  

  --,' ||  ' +CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) + '  ||'  AS COGNIZANTTAT  

  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(ONHOLD,0.00)))  AS ONHOLD   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)))  AS TOTALTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00))) AS SiemensTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) AS EXCLUDEDTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) AS COGNIZANTTAT  

  

  --,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)) AS TOTALTAT  

    --,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00)) AS SiemensTAT  

  --,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00)) AS EXCLUDEDTAT  

    --,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00)) AS COGNIZANTTAT  

  ,SLASTATUS  
  ,ASSIGNEDTO  
  ,LASTQUERYRAISEDBY  
  ,LASTQUERY  
  --,SURVEYRESPONSE
  --,Case when VOCQUALITY='Y' then 'Yes' Else 'No' END as VOCQUALITY
  ,VOCQUALITY as 'VOC_Quality'
  ,VOCREASON  as 'VOC_Reason'
  --,Case when VOCTURNAROUNDTIME='Y' then 'Yes' ELSE 'No' END as VOCTURNAROUNDTIME
  ,VOCTURNAROUNDTIME as 'VOC_TurnaroundTime'
  ,VOCTATREASON as 'VOC_TAT_Reason'
  ,SURVEYCOMMENTS  as 'Comments'
  FROM #FINAL            
  ORDER BY CASEID            

 

  --DROP TEMP TABLE  

  

 DROP TABLE #FINAL  

 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_KPI_GETTAT_08_Aug_2017]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [USP_KPI_GETTAT_test] '04-01-2016','04-27-2017',2, 4,2,'+05:30' ,'5'
/*  
* CREATED BY : RAGUVARAN E  

* CREATED DATE : 07/16/2014  
* PURPOSE : TO GET THE CASE WISE TAT DETAILS  

*/  
Create PROCEDURE [dbo].[USP_KPI_GETTAT_08_Aug_2017]  
(  

 @FROMDATE DATETIME,  
 
 @TODATE DATETIME,  
 
 @SUBPROCESSGROUPID INT,  
 
 @COUNTRYID INT,  

  @EMAILBOXID INT  ,
  
  @OFFSET VARCHAR(30),

  @CategoryID varchar(200)  

 )  
 
AS  

BEGIN  

DECLARE @CONVERTSECONDSTOMIN DECIMAL  

SELECT @CONVERTSECONDSTOMIN = 1  

DECLARE @EMTTAT TABLE  

(  
 CASEID BIGINT,  
 
 EMTTAT DECIMAL(18,2),  
  SLA INT,  
 COUNTRY VARCHAR(25),
 EMAILBOXNAME  VARCHAR(25),  
 SUBPROCESSNAME VARCHAR(25),
 /*--Nagababu merge SP relate to Stackland servey POC*/
 CATEGORYNAME Varchar(25),  
 ISMANUAL BIT,  
 CREATEDDATE DATETIME,  
 COMPLETEDDATE DATETIME,  
 LASTCOMMENT VARCHAR(MAX),  
 ASSIGNEDTO VARCHAR(250),
 -- Pranay 18 January 2017 For adding Response and Comments provided by user as User Survey
 --SURVEYRESPONSE VARCHAR(50),
 --SURVEYCOMMENTS VARCHAR(4000)
 VOCQUALITY VARCHAR(50),
 VOCREASON VARCHAR(MAX),
 VOCTURNAROUNDTIME VARCHAR(50),
 VOCTATREASON VARCHAR(MAX),
 SURVEYCOMMENTS VARCHAR(MAX)  
)  
DECLARE @PROVIDED TABLE             
(  
 ROW BIGINT,  
 AUDITID BIGINT,             
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME            
)   
DECLARE @NEEDED TABLE             
(      
 ROW BIGINT,        
 AUDITID BIGINT,             
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME            
) 
DECLARE @PREFINALX TABLE            
(            
 AAUDIT BIGINT,             
 ACASEID BIGINT,              
 ATOCASESTATUSID INT,             
 AENDTIME DATETIME,              
 AUDITID BIGINT,            
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME,             
 DIFF INT,            
 DDIFF BIGINT            
)  

DECLARE @PREFINAL TABLE                           
(                          
 CASEID BIGINT,                           
 IDIFF BIGINT                          
) 

/*Nagababu merger code for ONHOLD*..Start*/

DECLARE @ONHOLD Table
(
CASEID BIGINT,
DIFF BIGINT
)
 -- GET EMT TAT             

 if @CategoryID is not null      
 begin
  INSERT INTO @EMTTAT             
 SELECT EM.CASEID  
  --,CAST(AVG ( CAST((DBO.FN_TAT_EXCLUDECUTOFFTIME(EM.CREATEDDATE, EM.COMPLETEDDATE)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  --,CAST(AVG ( CAST((DBO.FN_TAT_EXCLUDECUTOFFTIME([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
  ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  ,EB.TATINSECONDS AS SLA  
  ,C.COUNTRY  
  ,EB.EMAILBOXNAME  
  ,SG.SUBPROCESSNAME 
   ,ECC.CATEGORY  
  ,EM.ISMANUAL  
  --,EM.CREATEDDATE  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET)as 'CREATEDDATE'
  --,EM.COMPLETEDDATE  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE'
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO  
  --Praany 18 January -- Adding Survey Response and Comments
  --,EM.SurveyResponse
  --Pranay 7 April -- Getting details of survey details
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments  
 FROM EMAILMASTER EM WITH (NOLOCK) 
  LEFT JOIN SurveyVOC_Details SVD on Em.CaseId=SVD.CaseID    
 LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
 LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
 LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID  
 LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/
 --inner join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID
 LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId  
 inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item   
 WHERE EM.STATUSID IN (10)  
 AND EM.COMPLETEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.COMPLETEDDATE <= (@TODATE + 1))  
 AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))  
 AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))  
 AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))  
 GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
  ,EM.CREATEDDATE  
  ,EM.COMPLETEDDATE  
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME
  ,ECC.CATEGORY   
    --,EM.SurveyResponse
   --,EM.SurveyComments
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments   
  end
  else
  begin
  INSERT INTO @EMTTAT  
  SELECT EM.CASEID  
  --,CAST(AVG ( CAST((DBO.FN_TAT_EXCLUDECUTOFFTIME(EM.CREATEDDATE, EM.COMPLETEDDATE)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  --,CAST(AVG ( CAST((DBO.FN_TAT_EXCLUDECUTOFFTIME([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
  ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  ,EB.TATINSECONDS AS SLA  
  ,C.COUNTRY  
  ,EB.EMAILBOXNAME  
  ,SG.SUBPROCESSNAME 
  ,ECC.CATEGORY  
  ,EM.ISMANUAL  
  --,EM.CREATEDDATE  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET)as 'CREATEDDATE'
  --,EM.COMPLETEDDATE  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE'
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO 
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments   
 FROM EMAILMASTER EM WITH (NOLOCK) 
 LEFT JOIN SurveyVOC_Details SVD on Em.CaseId=SVD.CaseID   
 LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
 LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
 LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID  
 LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/
 --inner join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID
 LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId    
 WHERE EM.STATUSID IN (10)  
 AND EM.COMPLETEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.COMPLETEDDATE <= (@TODATE + 1))  
 AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))  
 AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))  
 AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))  
 GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
  ,EM.CREATEDDATE  
  ,EM.COMPLETEDDATE  
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME  
  ,ECC.CATEGORY 
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments 
  end

 --SPLIT CLARIFICATION NEEDED AND PROVIDED  
 INSERT INTO @PREFINAL   
 SELECT DISTINCT   
  O.CASEID  
  --,(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIME(AB.ENDTIME,A.ENDTIME))'TOTMINS'
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.   
  ,(SELECT SUM(dbo.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM   
  --(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I WITH (NOLOCK)                        
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                        
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (3)) AB   
  --JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I WITH (NOLOCK)                          
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                          
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (3)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O WITH (NOLOCK)
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (3)                          
 ORDER BY O.CASEID
      
   -- SPLIT PENDING FOR QC DATA  
    INSERT INTO @NEEDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID  
   --,ENDTIME   
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)  
  WHERE  
   TOSTATUSID IN (5)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)            

 -- SPLIT QC APPROVED AND REJECTED DATA  

    INSERT INTO @PROVIDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID  
   --,ENDTIME   
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)
  WHERE                
   TOSTATUSID IN (7,8)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)   

    -- MATCH THE PENDING FOR QC AND QC APPROVED OR REJECTED DATA             



    INSERT INTO @PREFINALX   
  SELECT   
    A.AUDITID 'AAUDIT'  
   ,A.CASEID 'ACASEID'  
   ,A.TOCASESTATUSID 'ATOCASESTATUSID'  
   ,A.ENDTIME 'AENDTIME'  
   ,B.AUDITID  
   ,B.CASEID  
   ,B.TOCASESTATUSID  
   ,B.ENDTIME  
   ,B.AUDITID-A.AUDITID 'DIFF'  
   --,DBO.FN_TAT_EXCLUDECUTOFFTIME(A.ENDTIME, B.ENDTIME) 'DDIFF'              
   --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
   ,dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.ENDTIME, B.ENDTIME) 'DDIFF'              
   FROM @NEEDED A             
   JOIN @PROVIDED B ON A.CASEID = B.CASEID AND A.ROW=B.ROW             
   WHERE B.AUDITID-A.AUDITID  > 0 AND B.AUDITID IS NOT NULL             
   ORDER BY A.CASEID 
  

  /*Nagababu --Getting ONHOLD Time ..Start */



 INSERT INTO @ONHOLD  
 SELECT DISTINCT   
  O.CASEID  
  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM          
  --(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I  
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (13)) AB   
  --JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'FROM EMAILAUDIT I                           
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (13)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O   
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (13)                          
 ORDER BY O.CASEID   

 /*Nagababu --Getting ONHOLD Time ..End */





             

     -- CACLUATE ALL TAT DATA            



    SELECT   
    TAT.CASEID  
   ,TAT.EMTTAT  
   ,TAT.SLA  
   ,TAT.COUNTRY  
   ,TAT.EMAILBOXNAME  
   ,TAT.SUBPROCESSNAME
   ,TAT.CATEGORYNAME   
  ,CAST(AVG(CAST((SiemensTAT.IDIFF/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'SiemensTAT'  
  ,CAST(0 AS BIGINT) AS 'TOTAL'  
  ,CAST(0 AS DECIMAL (18,2)) AS 'COGNIZANTTAT'  
  ,'SLA NOT MET' AS SLASTATUS  
  ,CAST (CAST((SUM(EXCLUDED.DDIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'EXCLUDEDTAT'  
  ,CAST (CAST((SUM(ONHOLD.DIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'ONHOLD' 
  ,TAT.ISMANUAL  
  ,TAT.CREATEDDATE  
  ,TAT.COMPLETEDDATE  
  ,UM.FIRSTNAME +', '+UM.LASTNAME AS LASTQUERYRAISEDBY  
  ,EQ.QUERYTEXT AS LASTQUERY  
  ,TAT.ASSIGNEDTO  
   --,TAT.SURVEYRESPONSE
  ,TAT.VOCQUALITY 
  ,TAT.VOCREASON
  ,TAT.VOCTURNAROUNDTIME
  ,TAT.VOCTATREASON
  ,TAT.SURVEYCOMMENTS
  INTO #FINAL            
   FROM EMAILMASTER EM WITH (NOLOCK)  
   JOIN @EMTTAT TAT ON TAT.CASEID = EM.CASEID   
   LEFT JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID   
   AND EA.EMAILAUDITID IN   
   (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT WITH (NOLOCK) WHERE ToStatusId = 3 AND CASEID=EM.CASEID)  
    LEFT JOIN EMAILQUERY EQ ON EQ.EMAILAUDITid=EA.EMAILAUDITid 
    LEFT JOIN USERMASTER UM ON UM.USERID=EQ.CreatedById 
    LEFT JOIN (SELECT CASEID, IDIFF 'IDIFF' FROM @PREFINAL) SiemensTAT  ON SiemensTAT.CASEID = EM.CASEID    
    LEFT JOIN (SELECT AAUDIT, CASEID, MIN(DDIFF) 'DDIFF', MIN(DIFF) 'DIFF' FROM @PREFINALX GROUP BY AAUDIT, CASEID) EXCLUDED ON EXCLUDED.CASEID = EM.CASEID         
    LEFT JOIN (SELECT CASEID, DIFF 'DIFF' from @ONHOLD)ONHOLD ON ONHOLD.CASEID = EM.CaseId
	GROUP BY TAT.CASEID,TAT.EMTTAT,TAT.SLA,TAT.COUNTRY,TAT.EMAILBOXNAME,TAT.SUBPROCESSNAME,TAT.CATEGORYNAME,TAT.ISMANUAL,TAT.CREATEDDATE,TAT.COMPLETEDDATE,TAT.LASTCOMMENT,TAT.ASSIGNEDTO  
	,UM.FIRSTNAME +', '+UM.LASTNAME ,EQ.QUERYTEXT , 
 TAT.VOCQUALITY,TAT.VOCREASON,TAT.VOCTURNAROUNDTIME,TAT.VOCTATREASON,TAT.SURVEYCOMMENTS  
    -- CALCULATE COGNIZANT TAT AND SLA STATUS  



    UPDATE #FINAL SET             
    TOTAL = ISNULL(SiemensTAT,0) + ISNULL(EXCLUDEDTAT,0)         



    UPDATE #FINAL SET             
    COGNIZANTTAT = (ISNULL(EMTTAT,0) - ISNULL(TOTAL,0)- ISNULL(ONHOLD,0))  

	   

    UPDATE #FINAL SET             
    SLASTATUS = CASE WHEN COGNIZANTTAT<SLA THEN 'SLA MET' when (COGNIZANTTAT =0 OR SLA=0) then 'NA' WHEN SLA=00 THEN 'NA' WHEN SLA=000 THEN 'NA' ELSE SLASTATUS END  
 
 

    -- GET FINAL DATA OUTPUT            

 SELECT   
   CASEID  
  ,COUNTRY  
  ,SUBPROCESSNAME AS SUBPROCESS  
  ,EMAILBOXNAME AS EMAILBOX  
  ,ISNULL(CATEGORYNAME,'NA') AS CATEGORYNAME
  ,CASE WHEN ISMANUAL=0 THEN 'EMAIL CASE' ELSE 'MANUAL CASE' END AS CASETYPE  
  ,CONVERT(VARCHAR, CREATEDDATE, 103)+' '+CONVERT(VARCHAR, CREATEDDATE, 108) AS STARTDATE  
  ,CONVERT(VARCHAR, COMPLETEDDATE, 103)+' '+CONVERT(VARCHAR, COMPLETEDDATE, 108) AS ENDDATE  

  

  --,' ||  ' +CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00))) + '  ||'  AS TOTALTAT



    --,' ||  ' +CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00))) + '  ||'  AS SiemensTAT  



  --,' ||  ' +CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) + '  ||'  AS EXCLUDEDTAT  

  

  --,' ||  ' +CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) + '  ||'  AS COGNIZANTTAT  

  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(ONHOLD,0.00)))  AS ONHOLD   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)))  AS TOTALTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00))) AS SiemensTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) AS EXCLUDEDTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) AS COGNIZANTTAT  

  

  --,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)) AS TOTALTAT  

    --,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00)) AS SiemensTAT  

  --,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00)) AS EXCLUDEDTAT  

    --,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00)) AS COGNIZANTTAT  

  ,SLASTATUS  
  ,ASSIGNEDTO  
  ,LASTQUERYRAISEDBY  
  ,LASTQUERY  
  --,SURVEYRESPONSE
  --,Case when VOCQUALITY='Y' then 'Yes' Else 'No' END as VOCQUALITY
  ,VOCQUALITY as 'VOC_Quality'
  ,VOCREASON  as 'VOC_Reason'
  --,Case when VOCTURNAROUNDTIME='Y' then 'Yes' ELSE 'No' END as VOCTURNAROUNDTIME
  ,VOCTURNAROUNDTIME as 'VOC_TurnaroundTime'
  ,VOCTATREASON as 'VOC_TAT_Reason'
  ,SURVEYCOMMENTS  as 'Comments'
  FROM #FINAL            
  ORDER BY CASEID            

 

  --DROP TEMP TABLE  

  

 DROP TABLE #FINAL  

 

END
GO
/****** Object:  StoredProcedure [dbo].[USP_KPI_GETTAT_dynamichanges]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [USP_KPI_GETTAT_dynamichanges] '04-01-2016','04-27-2017',2, 4,2,'+05:30' ,'5'
/*  
* CREATED BY : RAGUVARAN E  

* CREATED DATE : 07/16/2014  
* PURPOSE : TO GET THE CASE WISE TAT DETAILS  

*/  
CREATE PROCEDURE [dbo].[USP_KPI_GETTAT_dynamichanges]  
(  

 @FROMDATE DATETIME,  
 
 @TODATE DATETIME,  
 
 @SUBPROCESSGROUPID INT,  
 
 @COUNTRYID INT,  

  @EMAILBOXID INT  ,
  
  @OFFSET VARCHAR(30),

  @CategoryID varchar(200)  

 )  
 
AS  

BEGIN  

DECLARE @CONVERTSECONDSTOMIN DECIMAL  

SELECT @CONVERTSECONDSTOMIN = 1  

DECLARE @EMTTAT TABLE  

(  
 CASEID BIGINT,  
 
 EMTTAT DECIMAL(18,2),  
  SLA INT,  
 COUNTRY VARCHAR(25),
 EMAILBOXNAME  VARCHAR(25),  
 SUBPROCESSNAME VARCHAR(25),
 /*--Nagababu merge SP relate to Stackland servey POC*/
 CATEGORYNAME Varchar(25),  
 ISMANUAL BIT,  
 CREATEDDATE DATETIME,  
 COMPLETEDDATE DATETIME,  
 LASTCOMMENT VARCHAR(MAX),  
 ASSIGNEDTO VARCHAR(250),
 -- Pranay 18 January 2017 For adding Response and Comments provided by user as User Survey
 --SURVEYRESPONSE VARCHAR(50),
 --SURVEYCOMMENTS VARCHAR(4000)
 VOCQUALITY VARCHAR(50),
 VOCREASON VARCHAR(MAX),
 VOCTURNAROUNDTIME VARCHAR(50),
 VOCTATREASON VARCHAR(MAX),
 SURVEYCOMMENTS VARCHAR(MAX)  
)  
DECLARE @PROVIDED TABLE             
(  
 ROW BIGINT,  
 AUDITID BIGINT,             
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME            
)   
DECLARE @NEEDED TABLE             
(      
 ROW BIGINT,        
 AUDITID BIGINT,             
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME            
) 
DECLARE @PREFINALX TABLE            
(            
 AAUDIT BIGINT,             
 ACASEID BIGINT,              
 ATOCASESTATUSID INT,             
 AENDTIME DATETIME,              
 AUDITID BIGINT,            
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME,             
 DIFF INT,            
 DDIFF BIGINT            
)  

DECLARE @PREFINAL TABLE                           
(                          
 CASEID BIGINT,                           
 IDIFF BIGINT                          
) 

/*Nagababu merger code for ONHOLD*..Start*/

DECLARE @ONHOLD Table
(
CASEID BIGINT,
DIFF BIGINT
)

declare @SubProcessID nvarchar(max)
set @SubProcessID=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMAILBOXID)
 -- GET EMT TAT             

 if @CategoryID is not null      
 begin
 if exists(select * from Status where SubProcessID=@SubProcessID)
 begin
  INSERT INTO @EMTTAT             
  SELECT EM.CASEID      
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
  ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  ,EB.TATINSECONDS AS SLA  
  ,C.COUNTRY  
  ,EB.EMAILBOXNAME  
  ,SG.SUBPROCESSNAME 
  ,ECC.CATEGORY  
  ,EM.ISMANUAL    
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET)as 'CREATEDDATE'  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE'
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO   
  --Pranay 7 April -- Getting details of survey details
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments  
  FROM EMAILMASTER EM WITH (NOLOCK) 
  LEFT JOIN SurveyVOC_Details SVD on Em.CaseId=SVD.CaseID    
  LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
  LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
  LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
  inner JOIN Status ST ON ST.SubProcessID=SG.SubProcessGroupId and EM.StatusId=ST.StatusId
  LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/ 
  LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId  
  inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item   
  WHERE EM.STATUSID IN (select StatusId from Status where IsFinalStatus=1 and SubProcessID =@SubProcessID)  
  and ST.SubProcessID =@SUBPROCESSGROUPID 
  AND EM.COMPLETEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.COMPLETEDDATE <= (@TODATE + 1))  
  AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))  
  AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))  
  AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))  
  GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
  ,EM.CREATEDDATE  
  ,EM.COMPLETEDDATE  
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME
  ,ECC.CATEGORY       
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments   
 end
 else
 begin
  INSERT INTO @EMTTAT             
  SELECT EM.CASEID      
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
  ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
  ,EB.TATINSECONDS AS SLA  
  ,C.COUNTRY  
  ,EB.EMAILBOXNAME  
  ,SG.SUBPROCESSNAME 
  ,ECC.CATEGORY  
  ,EM.ISMANUAL    
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET)as 'CREATEDDATE'  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE'
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO   
  --Pranay 7 April -- Getting details of survey details
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments  
  FROM EMAILMASTER EM WITH (NOLOCK) 
  LEFT JOIN SurveyVOC_Details SVD on Em.CaseId=SVD.CaseID    
  LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
  LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
  LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
  inner JOIN Status ST ON EM.StatusId=ST.StatusId     
  LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/ 
  LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId  
  inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item   
  WHERE EM.STATUSID IN (select StatusId from Status where IsFinalStatus=1 and SubProcessID is null)  
  and ST.SubProcessID is null 
  AND EM.COMPLETEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.COMPLETEDDATE <= (@TODATE + 1))  
  AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))  
  AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))  
  AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))  
  GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
  ,EM.CREATEDDATE  
  ,EM.COMPLETEDDATE  
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+', '+UM.LASTNAME
  ,ECC.CATEGORY       
  ,SVD.VOC_Quality
  ,SVD.VOC_Reason
  ,SVD.VOC_TurnaroundTime
  ,SVD.VOC_TAT_Reason
  ,SVD.Comments   
 end  
  end
  else
  begin
  if exists (select * from Status where SubProcessID=@SubProcessID)
  begin 
	  SELECT EM.CASEID   
    --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
	 ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
	 ,EB.TATINSECONDS AS SLA  
	 ,C.COUNTRY  
	 ,EB.EMAILBOXNAME  
	 ,SG.SUBPROCESSNAME 
	 ,ECC.CATEGORY  
	 ,EM.ISMANUAL    
	 ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET)as 'CREATEDDATE'  
	 ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE'
	 ,EM.LASTCOMMENT  
	 ,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO  
	 FROM EMAILMASTER EM WITH (NOLOCK)   
	 LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
	 LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
	 LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID  
	 inner JOIN Status ST ON ST.SubProcessID=SG.SubProcessGroupId and EM.StatusId=ST.StatusId 
	 LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
	 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/ 
	 LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId    
	 WHERE EM.STATUSID IN (select StatusId from Status where IsFinalStatus=1 and SubProcessID=@SubProcessID)  
	 and ST.SubProcessID =@SUBPROCESSGROUPID 
	 AND EM.COMPLETEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.COMPLETEDDATE <= (@TODATE + 1))  
	 AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))  
	 AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))  
	 AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))  
	 GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
	 ,EM.CREATEDDATE  
	 ,EM.COMPLETEDDATE  
	 ,EM.LASTCOMMENT  
	 ,UM.FIRSTNAME+', '+UM.LASTNAME  
	 ,ECC.CATEGORY 
  end
  else
  begin
	SELECT EM.CASEID   
    --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
	 ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) )/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'EMTTAT'  
	 ,EB.TATINSECONDS AS SLA  
	 ,C.COUNTRY  
	 ,EB.EMAILBOXNAME  
	 ,SG.SUBPROCESSNAME 
	 ,ECC.CATEGORY  
	 ,EM.ISMANUAL    
	 ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET)as 'CREATEDDATE'  
	 ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE'
	 ,EM.LASTCOMMENT  
	 ,UM.FIRSTNAME+', '+UM.LASTNAME AS ASSIGNEDTO  
	 FROM EMAILMASTER EM WITH (NOLOCK)   
	 LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
	 LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
	 LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID  
	 inner JOIN Status ST ON EM.StatusId=ST.StatusId 
	 LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
	 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/ 
	 LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId    
	 WHERE EM.STATUSID IN (select StatusId from Status where IsFinalStatus=1 and SubProcessID is null)  
	 and ST.SubProcessID is null 
	 AND EM.COMPLETEDDATE >= @FROMDATE AND (@TODATE IS NULL OR EM.COMPLETEDDATE <= (@TODATE + 1))  
	 AND ((@SUBPROCESSGROUPID IS NULL) OR (SG.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))  
	 AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))  
	 AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))  
	 GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
	 ,EM.CREATEDDATE  
	 ,EM.COMPLETEDDATE  
	 ,EM.LASTCOMMENT  
	 ,UM.FIRSTNAME+', '+UM.LASTNAME  
	 ,ECC.CATEGORY 
  end
 
  end

 --SPLIT CLARIFICATION NEEDED AND PROVIDED
 if exists(select * from Status where SubProcessID=@SubProcessID)
 begin
	INSERT INTO @PREFINAL   
 SELECT DISTINCT   
  O.CASEID    
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.   
  ,(SELECT SUM(dbo.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM     
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                        
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID=@SubProcessID)) AB     
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                          
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID=@SubProcessID)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O WITH (NOLOCK)
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID=@SubProcessID)                          
 ORDER BY O.CASEID
      
   -- SPLIT PENDING FOR QC DATA  
    INSERT INTO @NEEDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID    
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)  
  WHERE  
   TOSTATUSID IN (select StatusId from Status where IsQCPending=1 and SubProcessID=@SubProcessID)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)            

 -- SPLIT QC APPROVED AND REJECTED DATA  

    INSERT INTO @PROVIDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID     
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)
  WHERE                
   TOSTATUSID IN (select StatusId from Status where IsQCApprovedorRejected=1 and SubProcessID=@SubProcessID)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)  
    -- MATCH THE PENDING FOR QC AND QC APPROVED OR REJECTED DATA             

    INSERT INTO @PREFINALX   
  SELECT   
    A.AUDITID 'AAUDIT'  
   ,A.CASEID 'ACASEID'  
   ,A.TOCASESTATUSID 'ATOCASESTATUSID'  
   ,A.ENDTIME 'AENDTIME'  
   ,B.AUDITID  
   ,B.CASEID  
   ,B.TOCASESTATUSID  
   ,B.ENDTIME  
   ,B.AUDITID-A.AUDITID 'DIFF'     
   --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
   ,dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.ENDTIME, B.ENDTIME) 'DDIFF'              
   FROM @NEEDED A             
   JOIN @PROVIDED B ON A.CASEID = B.CASEID AND A.ROW=B.ROW             
   WHERE B.AUDITID-A.AUDITID  > 0 AND B.AUDITID IS NOT NULL             
   ORDER BY A.CASEID   

  /*Nagababu --Getting ONHOLD Time ..Start */

 INSERT INTO @ONHOLD  
 SELECT DISTINCT   
  O.CASEID  
  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM          
  --(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I  
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID=@SubProcessID)) AB   
  --JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'FROM EMAILAUDIT I                           
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID=@SubProcessID)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O   
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID=@SubProcessID)                          
 ORDER BY O.CASEID   

 /*Nagababu --Getting ONHOLD Time ..End */             

     -- CACLUATE ALL TAT DATA       
	 
    SELECT   
    TAT.CASEID  
   ,TAT.EMTTAT  
   ,TAT.SLA  
   ,TAT.COUNTRY  
   ,TAT.EMAILBOXNAME  
   ,TAT.SUBPROCESSNAME
   ,TAT.CATEGORYNAME   
  ,CAST(AVG(CAST((SiemensTAT.IDIFF/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'SiemensTAT'  
  ,CAST(0 AS BIGINT) AS 'TOTAL'  
  ,CAST(0 AS DECIMAL (18,2)) AS 'COGNIZANTTAT'  
  ,'SLA NOT MET' AS SLASTATUS  
  ,CAST (CAST((SUM(EXCLUDED.DDIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'EXCLUDEDTAT'  
  ,CAST (CAST((SUM(ONHOLD.DIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'ONHOLD' 
  ,TAT.ISMANUAL  
  ,TAT.CREATEDDATE  
  ,TAT.COMPLETEDDATE  
  ,UM.FIRSTNAME +', '+UM.LASTNAME AS LASTQUERYRAISEDBY  
  ,EQ.QUERYTEXT AS LASTQUERY  
  ,TAT.ASSIGNEDTO  
   --,TAT.SURVEYRESPONSE
  ,TAT.VOCQUALITY 
  ,TAT.VOCREASON
  ,TAT.VOCTURNAROUNDTIME
  ,TAT.VOCTATREASON
  ,TAT.SURVEYCOMMENTS
  INTO #FINAL_dynamicchanges1           
   FROM EMAILMASTER EM WITH (NOLOCK)  
   JOIN @EMTTAT TAT ON TAT.CASEID = EM.CASEID   
   LEFT JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID   
   AND EA.EMAILAUDITID IN   
   (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT WITH (NOLOCK) WHERE ToStatusId in (select StatusId from Status where IsReminderStatus=1 and SubProcessID=@SubProcessID) AND CASEID=EM.CASEID)  
    LEFT JOIN EMAILQUERY EQ ON EQ.EMAILAUDITid=EA.EMAILAUDITid 
    LEFT JOIN USERMASTER UM ON UM.USERID=EQ.CreatedById 
    LEFT JOIN (SELECT CASEID, IDIFF 'IDIFF' FROM @PREFINAL) SiemensTAT  ON SiemensTAT.CASEID = EM.CASEID    
    LEFT JOIN (SELECT AAUDIT, CASEID, MIN(DDIFF) 'DDIFF', MIN(DIFF) 'DIFF' FROM @PREFINALX GROUP BY AAUDIT, CASEID) EXCLUDED ON EXCLUDED.CASEID = EM.CASEID         
    LEFT JOIN (SELECT CASEID, DIFF 'DIFF' from @ONHOLD)ONHOLD ON ONHOLD.CASEID = EM.CaseId
	GROUP BY TAT.CASEID,TAT.EMTTAT,TAT.SLA,TAT.COUNTRY,TAT.EMAILBOXNAME,TAT.SUBPROCESSNAME,TAT.CATEGORYNAME,TAT.ISMANUAL,TAT.CREATEDDATE,TAT.COMPLETEDDATE,TAT.LASTCOMMENT,TAT.ASSIGNEDTO  
	,UM.FIRSTNAME +', '+UM.LASTNAME ,EQ.QUERYTEXT , 
 TAT.VOCQUALITY,TAT.VOCREASON,TAT.VOCTURNAROUNDTIME,TAT.VOCTATREASON,TAT.SURVEYCOMMENTS   

 -- CALCULATE COGNIZANT TAT AND SLA STATUS  
    UPDATE #FINAL_dynamicchanges1 SET             
    TOTAL = ISNULL(SiemensTAT,0) + ISNULL(EXCLUDEDTAT,0)         

    UPDATE #FINAL_dynamicchanges1 SET             
    COGNIZANTTAT = (ISNULL(EMTTAT,0) - ISNULL(TOTAL,0)- ISNULL(ONHOLD,0))  	  

    UPDATE #FINAL_dynamicchanges1 SET             
    SLASTATUS = CASE WHEN COGNIZANTTAT<SLA THEN 'SLA MET' when (COGNIZANTTAT =0 OR SLA=0) then 'NA' WHEN SLA=00 THEN 'NA' WHEN SLA=000 THEN 'NA' ELSE SLASTATUS END   
 
    -- GET FINAL DATA OUTPUT            

 SELECT   
   CASEID  
  ,COUNTRY  
  ,SUBPROCESSNAME AS SUBPROCESS  
  ,EMAILBOXNAME AS EMAILBOX  
  ,ISNULL(CATEGORYNAME,'NA') AS CATEGORYNAME
  ,CASE WHEN ISMANUAL=0 THEN 'EMAIL CASE' ELSE 'MANUAL CASE' END AS CASETYPE  
  ,CONVERT(VARCHAR, CREATEDDATE, 103)+' '+CONVERT(VARCHAR, CREATEDDATE, 108) AS STARTDATE  
  ,CONVERT(VARCHAR, COMPLETEDDATE, 103)+' '+CONVERT(VARCHAR, COMPLETEDDATE, 108) AS ENDDATE   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(ONHOLD,0.00)))  AS ONHOLD   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)))  AS TOTALTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00))) AS SiemensTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) AS EXCLUDEDTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) AS COGNIZANTTAT  
  ,SLASTATUS  
  ,ASSIGNEDTO  
  ,LASTQUERYRAISEDBY  
  ,LASTQUERY  
  --,SURVEYRESPONSE 
  ,VOCQUALITY as 'VOC_Quality'
  ,VOCREASON  as 'VOC_Reason'  
  ,VOCTURNAROUNDTIME as 'VOC_TurnaroundTime'
  ,VOCTATREASON as 'VOC_TAT_Reason'
  ,SURVEYCOMMENTS  as 'Comments'
  FROM #FINAL_dynamicchanges1            
  ORDER BY CASEID             

  --DROP TEMP TABLE   

 DROP TABLE #FINAL_dynamicchanges1   

 end
 else
 begin
	INSERT INTO @PREFINAL   
 SELECT DISTINCT   
  O.CASEID    
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.   
  ,(SELECT SUM(dbo.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM     
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                        
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null)) AB     
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                          
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O WITH (NOLOCK)
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null)                          
 ORDER BY O.CASEID
      
   -- SPLIT PENDING FOR QC DATA  
    INSERT INTO @NEEDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID    
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)  
  WHERE  
   TOSTATUSID IN (select StatusId from Status where IsQCPending=1 and SubProcessID is null)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)            

 -- SPLIT QC APPROVED AND REJECTED DATA  

    INSERT INTO @PROVIDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID     
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)
  WHERE                
   TOSTATUSID IN (select StatusId from Status where IsQCApprovedorRejected=1 and SubProcessID is null)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)   

    -- MATCH THE PENDING FOR QC AND QC APPROVED OR REJECTED DATA             



    INSERT INTO @PREFINALX   
  SELECT   
    A.AUDITID 'AAUDIT'  
   ,A.CASEID 'ACASEID'  
   ,A.TOCASESTATUSID 'ATOCASESTATUSID'  
   ,A.ENDTIME 'AENDTIME'  
   ,B.AUDITID  
   ,B.CASEID  
   ,B.TOCASESTATUSID  
   ,B.ENDTIME  
   ,B.AUDITID-A.AUDITID 'DIFF'     
   --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
   ,dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.ENDTIME, B.ENDTIME) 'DDIFF'              
   FROM @NEEDED A             
   JOIN @PROVIDED B ON A.CASEID = B.CASEID AND A.ROW=B.ROW             
   WHERE B.AUDITID-A.AUDITID  > 0 AND B.AUDITID IS NOT NULL             
   ORDER BY A.CASEID 
  

  /*Nagababu --Getting ONHOLD Time ..Start */



 INSERT INTO @ONHOLD  
 SELECT DISTINCT   
  O.CASEID  
  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM          
  --(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I  
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID is null)) AB   
  --JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'FROM EMAILAUDIT I                           
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID is null)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O   
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID is null)                          
 ORDER BY O.CASEID   

 /*Nagababu --Getting ONHOLD Time ..End */             

     -- CACLUATE ALL TAT DATA       
	 
    SELECT   
    TAT.CASEID  
   ,TAT.EMTTAT  
   ,TAT.SLA  
   ,TAT.COUNTRY  
   ,TAT.EMAILBOXNAME  
   ,TAT.SUBPROCESSNAME
   ,TAT.CATEGORYNAME   
  ,CAST(AVG(CAST((SiemensTAT.IDIFF/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'SiemensTAT'  
  ,CAST(0 AS BIGINT) AS 'TOTAL'  
  ,CAST(0 AS DECIMAL (18,2)) AS 'COGNIZANTTAT'  
  ,'SLA NOT MET' AS SLASTATUS  
  ,CAST (CAST((SUM(EXCLUDED.DDIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'EXCLUDEDTAT'  
  ,CAST (CAST((SUM(ONHOLD.DIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'ONHOLD' 
  ,TAT.ISMANUAL  
  ,TAT.CREATEDDATE  
  ,TAT.COMPLETEDDATE  
  ,UM.FIRSTNAME +', '+UM.LASTNAME AS LASTQUERYRAISEDBY  
  ,EQ.QUERYTEXT AS LASTQUERY  
  ,TAT.ASSIGNEDTO  
   --,TAT.SURVEYRESPONSE
  ,TAT.VOCQUALITY 
  ,TAT.VOCREASON
  ,TAT.VOCTURNAROUNDTIME
  ,TAT.VOCTATREASON
  ,TAT.SURVEYCOMMENTS
  INTO #FINAL_dynamicchanges2            
   FROM EMAILMASTER EM WITH (NOLOCK)  
   JOIN @EMTTAT TAT ON TAT.CASEID = EM.CASEID   
   LEFT JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID   
   AND EA.EMAILAUDITID IN   
   (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT WITH (NOLOCK) WHERE ToStatusId in (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null) AND CASEID=EM.CASEID)  
    LEFT JOIN EMAILQUERY EQ ON EQ.EMAILAUDITid=EA.EMAILAUDITid 
    LEFT JOIN USERMASTER UM ON UM.USERID=EQ.CreatedById 
    LEFT JOIN (SELECT CASEID, IDIFF 'IDIFF' FROM @PREFINAL) SiemensTAT  ON SiemensTAT.CASEID = EM.CASEID    
    LEFT JOIN (SELECT AAUDIT, CASEID, MIN(DDIFF) 'DDIFF', MIN(DIFF) 'DIFF' FROM @PREFINALX GROUP BY AAUDIT, CASEID) EXCLUDED ON EXCLUDED.CASEID = EM.CASEID         
    LEFT JOIN (SELECT CASEID, DIFF 'DIFF' from @ONHOLD)ONHOLD ON ONHOLD.CASEID = EM.CaseId
	GROUP BY TAT.CASEID,TAT.EMTTAT,TAT.SLA,TAT.COUNTRY,TAT.EMAILBOXNAME,TAT.SUBPROCESSNAME,TAT.CATEGORYNAME,TAT.ISMANUAL,TAT.CREATEDDATE,TAT.COMPLETEDDATE,TAT.LASTCOMMENT,TAT.ASSIGNEDTO  
	,UM.FIRSTNAME +', '+UM.LASTNAME ,EQ.QUERYTEXT , 
 TAT.VOCQUALITY,TAT.VOCREASON,TAT.VOCTURNAROUNDTIME,TAT.VOCTATREASON,TAT.SURVEYCOMMENTS  
    -- CALCULATE COGNIZANT TAT AND SLA STATUS  

	-- CALCULATE COGNIZANT TAT AND SLA STATUS  
    UPDATE #FINAL_dynamicchanges2 SET             
    TOTAL = ISNULL(SiemensTAT,0) + ISNULL(EXCLUDEDTAT,0)         

    UPDATE #FINAL_dynamicchanges2 SET             
    COGNIZANTTAT = (ISNULL(EMTTAT,0) - ISNULL(TOTAL,0)- ISNULL(ONHOLD,0))  
	   
    UPDATE #FINAL_dynamicchanges2 SET             
    SLASTATUS = CASE WHEN COGNIZANTTAT<SLA THEN 'SLA MET' when (COGNIZANTTAT =0 OR SLA=0) then 'NA' WHEN SLA=00 THEN 'NA' WHEN SLA=000 THEN 'NA' ELSE SLASTATUS END  
 
    -- GET FINAL DATA OUTPUT            

 SELECT   
   CASEID  
  ,COUNTRY  
  ,SUBPROCESSNAME AS SUBPROCESS  
  ,EMAILBOXNAME AS EMAILBOX  
  ,ISNULL(CATEGORYNAME,'NA') AS CATEGORYNAME
  ,CASE WHEN ISMANUAL=0 THEN 'EMAIL CASE' ELSE 'MANUAL CASE' END AS CASETYPE  
  ,CONVERT(VARCHAR, CREATEDDATE, 103)+' '+CONVERT(VARCHAR, CREATEDDATE, 108) AS STARTDATE  
  ,CONVERT(VARCHAR, COMPLETEDDATE, 103)+' '+CONVERT(VARCHAR, COMPLETEDDATE, 108) AS ENDDATE   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(ONHOLD,0.00)))  AS ONHOLD   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)))  AS TOTALTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00))) AS SiemensTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) AS EXCLUDEDTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) AS COGNIZANTTAT  
  ,SLASTATUS  
  ,ASSIGNEDTO  
  ,LASTQUERYRAISEDBY  
  ,LASTQUERY  
  --,SURVEYRESPONSE 
  ,VOCQUALITY as 'VOC_Quality'
  ,VOCREASON  as 'VOC_Reason'  
  ,VOCTURNAROUNDTIME as 'VOC_TurnaroundTime'
  ,VOCTATREASON as 'VOC_TAT_Reason'
  ,SURVEYCOMMENTS  as 'Comments'
  FROM #FINAL_dynamicchanges2            
  ORDER BY CASEID             

  --DROP TEMP TABLE   

 DROP TABLE #FINAL_dynamicchanges2  

 end
 
 
 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_KPI_GETTAT_dynamichanges_dynamicSP]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec [USP_KPI_GETTAT_dynamichanges] '04-01-2016','04-27-2017',2, 4,2,'+05:30' ,'5'
--exec USP_KPI_GETTAT_dynamichanges_dynamicSP @FROMDATE=N'06-01-2015',@TODATE=N'10-03-2017',@COUNTRYID=N'4',@EMAILBOXID=N'11',@SUBPROCESSGROUPID=N'6',@CategoryID=NULL,@OFFSET=N'-04:00'
/*  
* CREATED BY : RAGUVARAN E  

* CREATED DATE : 07/16/2014  
* PURPOSE : TO GET THE CASE WISE TAT DETAILS  

*/  
CREATE PROCEDURE [dbo].[USP_KPI_GETTAT_dynamichanges_dynamicSP]  
(  

 @FROMDATE DATETIME,  
 
 @TODATE DATETIME,  
 
 @SUBPROCESSGROUPID INT,  
 
 @COUNTRYID INT,  

  @EMAILBOXID INT  ,
  
  @OFFSET VARCHAR(30),

  @CategoryID varchar(200)  

 )  
 
AS  

BEGIN  

DECLARE @CONVERTSECONDSTOMIN DECIMAL  

SELECT @CONVERTSECONDSTOMIN = 1  

DECLARE @EMTTAT TABLE  

(  
 CASEID BIGINT,  
 
 EMTTAT DECIMAL(18,2),  
  SLA INT,  
 COUNTRY VARCHAR(25),
 EMAILBOXNAME  VARCHAR(25),  
 SUBPROCESSNAME VARCHAR(25),
 /*--Nagababu merge SP relate to Stackland servey POC*/
 CATEGORYNAME Varchar(25),  
 ISMANUAL BIT,  
 CREATEDDATE DATETIME,  
 COMPLETEDDATE DATETIME,  
 LASTCOMMENT VARCHAR(MAX),  
 ASSIGNEDTO VARCHAR(250),
 -- Pranay 18 January 2017 For adding Response and Comments provided by user as User Survey
 --SURVEYRESPONSE VARCHAR(50),
 --SURVEYCOMMENTS VARCHAR(4000)
 VOCQUALITY VARCHAR(50),
 VOCREASON VARCHAR(MAX),
 VOCTURNAROUNDTIME VARCHAR(50),
 VOCTATREASON VARCHAR(MAX),
 SURVEYCOMMENTS VARCHAR(MAX)  
)  
DECLARE @PROVIDED TABLE             
(  
 ROW BIGINT,  
 AUDITID BIGINT,             
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME            
)   
DECLARE @NEEDED TABLE             
(      
 ROW BIGINT,        
 AUDITID BIGINT,             
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME            
) 
DECLARE @PREFINALX TABLE            
(            
 AAUDIT BIGINT,             
 ACASEID BIGINT,              
 ATOCASESTATUSID INT,             
 AENDTIME DATETIME,              
 AUDITID BIGINT,            
 CASEID BIGINT,             
 TOCASESTATUSID INT,             
 ENDTIME DATETIME,             
 DIFF INT,            
 DDIFF BIGINT            
)  

DECLARE @PREFINAL TABLE                           
(                          
 CASEID BIGINT,                           
 IDIFF BIGINT                          
) 

/*Nagababu merger code for ONHOLD*..Start*/

DECLARE @ONHOLD Table
(
CASEID BIGINT,
DIFF BIGINT
)

--Saranya to display dynamic fields in reports
if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'ReportResults'
			   )
	begin
			drop table ReportResults
	end 

		declare @cols AS NVARCHAR(MAX)		
select @cols = STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) 
                    from dbo.Tbl_FieldConfiguration FC 					 							 
				where FC.Active='1' and FC.MailBoxID=@EMAILBOXID                 
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @cols

		declare @colsCreateTable as NVARCHAR(Max)
		declare @queryDBReportsResult as NVArchar(max)
select @colsCreateTable=STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) +' NVARCHAR(max)'
                    from dbo.Tbl_FieldConfiguration FC 
					left join  dbo.Tbl_ClientTransaction CT  on CT.FieldMasterId=FC.FieldMasterId
								 
				where FC.Active=1 and FC.MailBoxID= @EMAILBOXID 
                    group by FC.FieldName
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		set @queryDBReportsResult='Create table ReportResults(CaseId bigint,'+@colsCreateTable+')'
		 print @queryDBReportsResult
		 exec sp_executesql @queryDBReportsResult

		declare @queryDB  AS NVARCHAR(MAX)
set @queryDB = N'insert into ReportResults(CaseID,'+@cols+') SELECT CaseID,' + @cols + N' from 
             (
                
				select CaseID, FieldValue, FC.FieldName
                from dbo.Tbl_ClientTransaction CT 
				inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 				 
				where FC.MailBoxID='+CONVERT(VARCHAR(50),@EMAILBOXID)+' and FC.Active=''1''				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldName in (' + @cols + N')
            ) p '
print @queryDB 
 exec sp_executesql @queryDB
 --end of dynamic fields
 --select * from reportresults
declare @SubProcessID nvarchar(max)
set @SubProcessID=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMAILBOXID)

declare @dyColumn as nvarchar(max)
declare @sortorder as nvarchar(max)
	If((Select IsVOCSurvey from emailbox where EMailBoxId = @EMAILBOXID) = 1)
		Begin
			set @dyColumn= ',SVD.VOC_Quality,SVD.VOC_Reason,SVD.VOC_TurnaroundTime,SVD.VOC_TAT_Reason,SVD.Comments FROM EMAILMASTER EM WITH (NOLOCK)'
			set @sortorder=',ECC.CATEGORY,SVD.VOC_Quality,SVD.VOC_Reason,SVD.VOC_TurnaroundTime,SVD.VOC_TAT_Reason,SVD.Comments'
		End
	else
		Begin
			set @dyColumn= '  ,'''','''','''','''','''' FROM EMAILMASTER EM WITH (NOLOCK)'
			set @sortorder=',ECC.CATEGORY'
		END

if @CategoryID is not null      
 begin
 if exists(select * from Status where SubProcessID=@SubProcessID)
 begin
 INSERT INTO @EMTTAT
  EXEC('SELECT EM.CASEID      
  --Pranay 7 April 2017 Chnaging function from  ''DBO.FN_TAT_EXCLUDECUTOFFTIME''   to ''fn_TAT_ExcludeCutOffTimeSatSun'' to exclude weekends.
  ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+'''),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''') )/'''+@CONVERTSECONDSTOMIN+''') AS DECIMAL(18,8))) AS DECIMAL(18,2)) ''EMTTAT''  
  ,EB.TATINSECONDS AS SLA  
  ,C.COUNTRY  
  ,EB.EMAILBOXNAME  
  ,SG.SUBPROCESSNAME 
  ,ECC.CATEGORY  
  ,EM.ISMANUAL    
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+''')as ''CREATEDDATE''  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''')as ''COMPLETEDDATE''
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+'', ''+UM.LASTNAME AS ASSIGNEDTO'
 + @dyColumn+
  ' LEFT JOIN SurveyVOC_Details SVD on Em.CaseId=SVD.CaseID   
  left join ReportResults  RR on EM.CaseId=RR.CaseId   
  LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
  LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
  LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
  inner JOIN Status ST ON ST.SubProcessID=SG.SubProcessGroupId and EM.StatusId=ST.StatusId
  LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/ 
  LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId  
  inner join dbo.ConvertDelimitedListIntoTable('''+@CategoryID+''','','') arr ON EM.Categoryid= arr.Item   
  WHERE EM.STATUSID IN (select StatusId from Status where IsFinalStatus=1 and SubProcessID ='''+@SubProcessID+''')  
  and ST.SubProcessID ='''+@SubProcessID+'''
  AND EM.COMPLETEDDATE >= '''+@FROMDATE+''' AND ('''+@TODATE+''' IS NULL OR EM.COMPLETEDDATE <= DATEADD(Day,1,'''+@TODATE+'''))  
  AND (('''+@SubProcessID+''' IS NULL) OR (SG.SUBPROCESSGROUPID='''+@SubProcessID+'''))  
  AND (('''+@COUNTRYID+''' IS NULL) OR (EB.COUNTRYID='''+@COUNTRYID+'''))  
  AND (('''+@EMAILBOXID+''' IS NULL) OR (EM.EMAILBOXID='''+@EMAILBOXID+'''))  
  GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
  ,EM.CREATEDDATE  
  ,EM.COMPLETEDDATE  
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+'', ''+UM.LASTNAME'
   +@sortorder)
 end
 else
 begin
 INSERT INTO @EMTTAT  
  EXEC('SELECT EM.CASEID      
  ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+'''),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''') )/'''+@CONVERTSECONDSTOMIN+''') AS DECIMAL(18,8))) AS DECIMAL(18,2)) ''EMTTAT''  
  ,EB.TATINSECONDS AS SLA  
  ,C.COUNTRY  
  ,EB.EMAILBOXNAME  
  ,SG.SUBPROCESSNAME 
  ,ECC.CATEGORY  
  ,EM.ISMANUAL    
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+''')as ''CREATEDDATE''  
  ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''')as ''COMPLETEDDATE''
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+'', ''+UM.LASTNAME AS ASSIGNEDTO'
 +@dyColumn+
  ' LEFT JOIN SurveyVOC_Details SVD on Em.CaseId=SVD.CaseID  
  left join ReportResults  RR on EM.CaseId=RR.CaseId   
  LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
  LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
  LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
  inner JOIN Status ST ON EM.StatusId=ST.StatusId     
  LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/ 
  LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId  
  inner join dbo.ConvertDelimitedListIntoTable('''+@CategoryID+''','','') arr ON EM.Categoryid= arr.Item   
  WHERE EM.STATUSID IN (select StatusId from Status where IsFinalStatus=1 and SubProcessID is null)  
  and ST.SubProcessID is null 
  AND EM.COMPLETEDDATE >='''+@FROMDATE+''' AND ('''+@TODATE+''' IS NULL OR EM.COMPLETEDDATE <= DATEADD(Day,1,'''+@TODATE+'''))  
  AND (('''+@SubProcessID+''' IS NULL) OR (SG.SUBPROCESSGROUPID='''+@SubProcessID+'''))  
  AND (('''+@COUNTRYID+''' IS NULL) OR (EB.COUNTRYID='''+@COUNTRYID+'''))  
  AND (('''+@EMAILBOXID+''' IS NULL) OR (EM.EMAILBOXID='''+@EMAILBOXID+'''))  
  GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
  ,EM.CREATEDDATE  
  ,EM.COMPLETEDDATE  
  ,EM.LASTCOMMENT  
  ,UM.FIRSTNAME+'', ''+UM.LASTNAME'
   +@sortorder)
 end 
 end
 else
 begin
 if exists (select * from Status where SubProcessID=@SubProcessID)
  begin  
  Insert into @EMTTAT 
  EXEC('SELECT EM.CASEID   	  
	 ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+'''),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''') )/'''+@CONVERTSECONDSTOMIN+''') AS DECIMAL(18,8))) AS DECIMAL(18,2)) ''EMTTAT''
	 ,EB.TATINSECONDS AS SLA  
	 ,C.COUNTRY  
	 ,EB.EMAILBOXNAME  
	 ,SG.SUBPROCESSNAME 
	 ,ECC.CATEGORY  
	 ,EM.ISMANUAL    
	 ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+''')as ''CREATEDDATE''
	 ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''')as ''COMPLETEDDATE''
	 ,EM.LASTCOMMENT  
	 ,UM.FIRSTNAME+'', ''+UM.LASTNAME AS ASSIGNEDTO'  
	 +@dyColumn+
	 ' LEFT JOIN SurveyVOC_Details SVD on Em.CaseId=SVD.CaseID
	 left join ReportResults  RR on EM.CaseId=RR.CaseId  
	 LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
	 LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
	 LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
	 inner JOIN Status ST ON ST.SubProcessID=SG.SubProcessGroupId and EM.StatusId=ST.StatusId
	 LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
	 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/ 
	 LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId    
	 WHERE EM.STATUSID IN (select StatusId from Status where IsFinalStatus=1 and SubProcessID='''+@SubProcessID+''')  	 
	 AND EM.COMPLETEDDATE >= '''+@FROMDATE+''' AND ('''+@TODATE+''' IS NULL OR EM.COMPLETEDDATE <= DATEADD(Day,1,'''+@TODATE+'''))  
	 AND (('''+@SubProcessID+''' IS NULL) OR (SG.SUBPROCESSGROUPID='''+@SubProcessID+'''))  
	 AND (('''+@COUNTRYID+''' IS NULL) OR (EB.COUNTRYID='''+@COUNTRYID+'''))  
	 AND (('''+@EMAILBOXID+''' IS NULL) OR (EM.EMAILBOXID='''+@EMAILBOXID+'''))  
	 GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,EM.ISMANUAL  
	 ,EM.CREATEDDATE  
	 ,EM.COMPLETEDDATE  
	 ,EM.LASTCOMMENT  
	 ,UM.FIRSTNAME+'', ''+UM.LASTNAME' 
	  +@sortorder)
  end
  else
  begin
   Insert into @EMTTAT 
	EXEC('SELECT EM.CASEID       
	 ,CAST(AVG ( CAST((dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+'''),[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''') )/'''+@CONVERTSECONDSTOMIN+''') AS DECIMAL(18,8))) AS DECIMAL(18,2)) ''EMTTAT''
	 ,EB.TATINSECONDS AS SLA  
	 ,C.COUNTRY  
	 ,EB.EMAILBOXNAME  
	 ,SG.SUBPROCESSNAME 
	 ,ECC.CATEGORY  
	 ,EM.ISMANUAL    
	 ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,'''+@OFFSET+''')as ''CREATEDDATE''
	 ,[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,'''+@OFFSET+''')as ''COMPLETEDDATE''
	 ,EM.LASTCOMMENT  
	 ,UM.FIRSTNAME+'', ''+UM.LASTNAME AS ASSIGNEDTO'  
	  +@dyColumn+' LEFT JOIN SurveyVOC_Details SVD on Em.CaseId=SVD.CaseID
	 left join ReportResults  RR on EM.CaseId=RR.CaseId  
	 LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID  
	 LEFT JOIN COUNTRY C ON EB.COUNTRYID=C.COUNTRYID  
	 LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID  
	 inner JOIN Status ST ON EM.StatusId=ST.StatusId 
	 LEFT JOIN USERMASTER UM ON UM.USERID=EM.ASSIGNEDTOID 
	 /*--Nagababu merge SP relate to Stackland servey POC--Adding Category*/ 
	 LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId    
	 WHERE EM.STATUSID IN (select StatusId from Status where IsFinalStatus=1 and SubProcessID is null)  
	 and ST.SubProcessID is null 
	 AND EM.COMPLETEDDATE >= '''+@FROMDATE+''' AND ('''+@TODATE+''' IS NULL OR EM.COMPLETEDDATE <= DATEADD(Day,1,'''+@TODATE+'''))  
	 AND (('''+@SubProcessID+''' IS NULL) OR (SG.SUBPROCESSGROUPID='''+@SubProcessID+'''))  
	 AND (('''+@COUNTRYID+''' IS NULL) OR (EB.COUNTRYID='''+@COUNTRYID+'''))  
	 AND (('''+@EMAILBOXID+''' IS NULL) OR (EM.EMAILBOXID='''+@EMAILBOXID+'''))  
	 GROUP BY EM.CASEID,EB.TATINSECONDS,C.COUNTRY,EB.EMAILBOXNAME,SG.SUBPROCESSNAME,ECC.CATEGORY,EM.ISMANUAL  
	 ,EM.CREATEDDATE  
	 ,EM.COMPLETEDDATE  
	 ,EM.LASTCOMMENT  
	 ,UM.FIRSTNAME+'', ''+UM.LASTNAME' 
	  +@sortorder)
  end
 end


  if exists(select * from Status where SubProcessID=@SubProcessID)
 begin
 INSERT INTO @PREFINAL   
 SELECT DISTINCT   
  O.CASEID    
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.   
  ,(SELECT SUM(dbo.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM     
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                        
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID =@SubProcessID)) AB     
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                          
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID=@SubProcessID)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O WITH (NOLOCK)
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID=@SubProcessID)                          
 ORDER BY O.CASEID
      
   -- SPLIT PENDING FOR QC DATA  
    INSERT INTO @NEEDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID    
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)  
  WHERE  
   TOSTATUSID IN (select StatusId from Status where IsQCPending=1 and SubProcessID=@SubProcessID)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)            

 -- SPLIT QC APPROVED AND REJECTED DATA  

    INSERT INTO @PROVIDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID     
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)
  WHERE                
   TOSTATUSID IN (select StatusId from Status where IsQCApprovedorRejected=1 and SubProcessID=@SubProcessID)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)   

    -- MATCH THE PENDING FOR QC AND QC APPROVED OR REJECTED DATA             



    INSERT INTO @PREFINALX   
  SELECT   
    A.AUDITID 'AAUDIT'  
   ,A.CASEID 'ACASEID'  
   ,A.TOCASESTATUSID 'ATOCASESTATUSID'  
   ,A.ENDTIME 'AENDTIME'  
   ,B.AUDITID  
   ,B.CASEID  
   ,B.TOCASESTATUSID  
   ,B.ENDTIME  
   ,B.AUDITID-A.AUDITID 'DIFF'     
   --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
   ,dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.ENDTIME, B.ENDTIME) 'DDIFF'              
   FROM @NEEDED A             
   JOIN @PROVIDED B ON A.CASEID = B.CASEID AND A.ROW=B.ROW             
   WHERE B.AUDITID-A.AUDITID  > 0 AND B.AUDITID IS NOT NULL             
   ORDER BY A.CASEID 
  

  /*Nagababu --Getting ONHOLD Time ..Start */



 INSERT INTO @ONHOLD  
 SELECT DISTINCT   
  O.CASEID  
  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM          
  --(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I  
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID=@SubProcessID)) AB   
  --JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'FROM EMAILAUDIT I                           
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID=@SubProcessID)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O   
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID=@SubProcessID)                          
 ORDER BY O.CASEID   

 /*Nagababu --Getting ONHOLD Time ..End */             

     -- CACLUATE ALL TAT DATA       
if ((select IsVOCSurvey from EMailBox where EMailBoxId=@EMAILBOXID)=1)
begin
	SELECT   
    TAT.CASEID  
   ,TAT.EMTTAT  
   ,TAT.SLA  
   ,TAT.COUNTRY  
   ,TAT.EMAILBOXNAME  
   ,TAT.SUBPROCESSNAME
   ,TAT.CATEGORYNAME   
  ,CAST(AVG(CAST((SiemensTAT.IDIFF/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'SiemensTAT'  
  ,CAST(0 AS BIGINT) AS 'TOTAL'  
  ,CAST(0 AS DECIMAL (18,2)) AS 'COGNIZANTTAT'  
  ,'SLA NOT MET' AS SLASTATUS  
  ,CAST (CAST((SUM(EXCLUDED.DDIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'EXCLUDEDTAT'  
  ,CAST (CAST((SUM(ONHOLD.DIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'ONHOLD' 
  ,TAT.ISMANUAL  
  ,TAT.CREATEDDATE  
  ,TAT.COMPLETEDDATE  
  ,UM.FIRSTNAME +', '+UM.LASTNAME AS LASTQUERYRAISEDBY  
  ,EQ.QUERYTEXT AS LASTQUERY      
  ,TAT.ASSIGNEDTO   
  ,TAT.VOCQUALITY 
  ,TAT.VOCREASON
  ,TAT.VOCTURNAROUNDTIME
  ,TAT.VOCTATREASON
  ,TAT.SURVEYCOMMENTS  
  INTO #FINAL_dynamicchanges1            
   FROM EMAILMASTER EM WITH (NOLOCK)  
   JOIN @EMTTAT TAT ON TAT.CASEID = EM.CASEID   
   LEFT JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID   
   AND EA.EMAILAUDITID IN   
   (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT WITH (NOLOCK) WHERE ToStatusId in (select StatusId from Status where IsReminderStatus=1 and SubProcessID=@SubProcessID) AND CASEID=EM.CASEID)  
    LEFT JOIN EMAILQUERY EQ ON EQ.EMAILAUDITid=EA.EMAILAUDITid 
    LEFT JOIN USERMASTER UM ON UM.USERID=EQ.CreatedById 
    LEFT JOIN (SELECT CASEID, IDIFF 'IDIFF' FROM @PREFINAL) SiemensTAT  ON SiemensTAT.CASEID = EM.CASEID    
    LEFT JOIN (SELECT AAUDIT, CASEID, MIN(DDIFF) 'DDIFF', MIN(DIFF) 'DIFF' FROM @PREFINALX GROUP BY AAUDIT, CASEID) EXCLUDED ON EXCLUDED.CASEID = EM.CASEID         
    LEFT JOIN (SELECT CASEID, DIFF 'DIFF' from @ONHOLD)ONHOLD ON ONHOLD.CASEID = EM.CaseId
	GROUP BY TAT.CASEID,TAT.EMTTAT,TAT.SLA,TAT.COUNTRY,TAT.EMAILBOXNAME,TAT.SUBPROCESSNAME,TAT.CATEGORYNAME,TAT.ISMANUAL,TAT.CREATEDDATE,TAT.COMPLETEDDATE,TAT.LASTCOMMENT,TAT.ASSIGNEDTO  
	,UM.FIRSTNAME +', '+UM.LASTNAME ,EQ.QUERYTEXT , 
    TAT.VOCQUALITY,TAT.VOCREASON,TAT.VOCTURNAROUNDTIME,TAT.VOCTATREASON,TAT.SURVEYCOMMENTS     

	-- CALCULATE COGNIZANT TAT AND SLA STATUS  
    UPDATE #FINAL_dynamicchanges1 SET             
    TOTAL = ISNULL(SiemensTAT,0) + ISNULL(EXCLUDEDTAT,0)         

    UPDATE #FINAL_dynamicchanges1 SET             
    COGNIZANTTAT = (ISNULL(EMTTAT,0) - ISNULL(TOTAL,0)- ISNULL(ONHOLD,0))  
	   
    UPDATE #FINAL_dynamicchanges1 SET             
    SLASTATUS = CASE WHEN COGNIZANTTAT<SLA THEN 'SLA MET' when (COGNIZANTTAT =0 OR SLA=0) then 'NA' WHEN SLA=00 THEN 'NA' WHEN SLA=000 THEN 'NA' ELSE SLASTATUS END  
 
    -- GET FINAL DATA OUTPUT            

 EXEC('SELECT   
   DC.CASEID  
  ,COUNTRY  
  ,SUBPROCESSNAME AS SUBPROCESS  
  ,EMAILBOXNAME AS EMAILBOX  
  ,ISNULL(CATEGORYNAME,''NA'') AS CATEGORYNAME
  ,CASE WHEN ISMANUAL=0 THEN ''EMAIL CASE'' ELSE ''MANUAL CASE'' END AS CASETYPE  
  ,CONVERT(VARCHAR, CREATEDDATE, 103)+'' ''+CONVERT(VARCHAR, CREATEDDATE, 108) AS STARTDATE  
  ,CONVERT(VARCHAR, COMPLETEDDATE, 103)+'' ''+CONVERT(VARCHAR, COMPLETEDDATE, 108) AS ENDDATE   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(ONHOLD,0.00)))  AS ONHOLD   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)))  AS TOTALTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00))) AS CustomerTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) AS EXCLUDEDTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) AS COGNIZANTTAT  
  ,SLASTATUS  
  ,ASSIGNEDTO  
  ,LASTQUERYRAISEDBY  
  ,LASTQUERY   
  ,VOCQUALITY as ''VOC_Quality''
  ,VOCREASON  as ''VOC_Reason''  
  ,VOCTURNAROUNDTIME as ''VOC_TurnaroundTime''
  ,VOCTATREASON as ''VOC_TAT_Reason''
  ,SURVEYCOMMENTS  as ''Comments''
   ,'+@cols+  
 ' FROM #FINAL_dynamicchanges1  DC
  left join ReportResults RR 
  on DC.CaseId=RR.CaseId          
  ORDER BY CASEID ')            

  --DROP TEMP TABLE   

	 DROP TABLE #FINAL_dynamicchanges1  	
end
else
begin
	SELECT   
    TAT.CASEID  
   ,TAT.EMTTAT  
   ,TAT.SLA  
   ,TAT.COUNTRY  
   ,TAT.EMAILBOXNAME  
   ,TAT.SUBPROCESSNAME
   ,TAT.CATEGORYNAME   
  ,CAST(AVG(CAST((SiemensTAT.IDIFF/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'SiemensTAT'  
  ,CAST(0 AS BIGINT) AS 'TOTAL'  
  ,CAST(0 AS DECIMAL (18,2)) AS 'COGNIZANTTAT'  
  ,'SLA NOT MET' AS SLASTATUS  
  ,CAST (CAST((SUM(EXCLUDED.DDIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'EXCLUDEDTAT'  
  ,CAST (CAST((SUM(ONHOLD.DIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'ONHOLD' 
  ,TAT.ISMANUAL  
  ,TAT.CREATEDDATE  
  ,TAT.COMPLETEDDATE  
  ,UM.FIRSTNAME +', '+UM.LASTNAME AS LASTQUERYRAISEDBY  
  ,EQ.QUERYTEXT AS LASTQUERY      
  ,TAT.ASSIGNEDTO      
  INTO #FINAL_dynamicchanges2            
   FROM EMAILMASTER EM WITH (NOLOCK)  
   JOIN @EMTTAT TAT ON TAT.CASEID = EM.CASEID   
   LEFT JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID   
   AND EA.EMAILAUDITID IN   
   (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT WITH (NOLOCK) WHERE ToStatusId in (select StatusId from Status where IsReminderStatus=1 and SubProcessID=@SubProcessID) AND CASEID=EM.CASEID)  
    LEFT JOIN EMAILQUERY EQ ON EQ.EMAILAUDITid=EA.EMAILAUDITid 
    LEFT JOIN USERMASTER UM ON UM.USERID=EQ.CreatedById 
    LEFT JOIN (SELECT CASEID, IDIFF 'IDIFF' FROM @PREFINAL) SiemensTAT  ON SiemensTAT.CASEID = EM.CASEID    
    LEFT JOIN (SELECT AAUDIT, CASEID, MIN(DDIFF) 'DDIFF', MIN(DIFF) 'DIFF' FROM @PREFINALX GROUP BY AAUDIT, CASEID) EXCLUDED ON EXCLUDED.CASEID = EM.CASEID         
    LEFT JOIN (SELECT CASEID, DIFF 'DIFF' from @ONHOLD)ONHOLD ON ONHOLD.CASEID = EM.CaseId
	GROUP BY TAT.CASEID,TAT.EMTTAT,TAT.SLA,TAT.COUNTRY,TAT.EMAILBOXNAME,TAT.SUBPROCESSNAME,TAT.CATEGORYNAME,TAT.ISMANUAL,TAT.CREATEDDATE,TAT.COMPLETEDDATE,TAT.LASTCOMMENT,TAT.ASSIGNEDTO  
	,UM.FIRSTNAME +', '+UM.LASTNAME ,EQ.QUERYTEXT 
 
	-- CALCULATE COGNIZANT TAT AND SLA STATUS  
    UPDATE #FINAL_dynamicchanges2 SET             
    TOTAL = ISNULL(SiemensTAT,0) + ISNULL(EXCLUDEDTAT,0)         

    UPDATE #FINAL_dynamicchanges2 SET             
    COGNIZANTTAT = (ISNULL(EMTTAT,0) - ISNULL(TOTAL,0)- ISNULL(ONHOLD,0))  
	   
    UPDATE #FINAL_dynamicchanges2 SET             
    SLASTATUS = CASE WHEN COGNIZANTTAT<SLA THEN 'SLA MET' when (COGNIZANTTAT =0 OR SLA=0) then 'NA' WHEN SLA=00 THEN 'NA' WHEN SLA=000 THEN 'NA' ELSE SLASTATUS END  
 
    -- GET FINAL DATA OUTPUT            

 EXEC('SELECT   
   DC.CASEID  
  ,COUNTRY  
  ,SUBPROCESSNAME AS SUBPROCESS  
  ,EMAILBOXNAME AS EMAILBOX  
  ,ISNULL(CATEGORYNAME,''NA'') AS CATEGORYNAME
  ,CASE WHEN ISMANUAL=0 THEN ''EMAIL CASE'' ELSE ''MANUAL CASE'' END AS CASETYPE  
  ,CONVERT(VARCHAR, CREATEDDATE, 103)+'' ''+CONVERT(VARCHAR, CREATEDDATE, 108) AS STARTDATE  
  ,CONVERT(VARCHAR, COMPLETEDDATE, 103)+'' ''+CONVERT(VARCHAR, COMPLETEDDATE, 108) AS ENDDATE   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(ONHOLD,0.00)))  AS ONHOLD   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)))  AS TOTALTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00))) AS SiemensTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) AS EXCLUDEDTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) AS COGNIZANTTAT  
  ,SLASTATUS  
  ,ASSIGNEDTO  
  ,LASTQUERYRAISEDBY  
  ,LASTQUERY 
   ,'+@cols+      
  'FROM #FINAL_dynamicchanges2 DC  
    left join ReportResults RR 
  on DC.CaseId=RR.CaseId                   
  ORDER BY CASEID ')            

  --DROP TEMP TABLE   

	 DROP TABLE #FINAL_dynamicchanges2  

	end	
end
else
begin
	INSERT INTO @PREFINAL   
 SELECT DISTINCT   
  O.CASEID    
  --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.   
  ,(SELECT SUM(dbo.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM     
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                        
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null)) AB     
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I WITH (NOLOCK)                          
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O WITH (NOLOCK)
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null)                          
 ORDER BY O.CASEID
      
   -- SPLIT PENDING FOR QC DATA  
    INSERT INTO @NEEDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID    
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)  
  WHERE  
   TOSTATUSID IN (select StatusId from Status where IsQCPending=1 and SubProcessID is null)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)            

 -- SPLIT QC APPROVED AND REJECTED DATA  

    INSERT INTO @PROVIDED   
  SELECT   
   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  
   ,EMAILAUDITID  
   ,CASEID  
   ,TOSTATUSID     
   ,[dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'
  FROM EMAILAUDIT WITH (NOLOCK)
  WHERE                
   TOSTATUSID IN (select StatusId from Status where IsQCApprovedorRejected=1 and SubProcessID is null)            
   AND CASEID IN (SELECT CASEID FROM @EMTTAT)   

    -- MATCH THE PENDING FOR QC AND QC APPROVED OR REJECTED DATA             



    INSERT INTO @PREFINALX   
  SELECT   
    A.AUDITID 'AAUDIT'  
   ,A.CASEID 'ACASEID'  
   ,A.TOCASESTATUSID 'ATOCASESTATUSID'  
   ,A.ENDTIME 'AENDTIME'  
   ,B.AUDITID  
   ,B.CASEID  
   ,B.TOCASESTATUSID  
   ,B.ENDTIME  
   ,B.AUDITID-A.AUDITID 'DIFF'     
   --Pranay 7 April 2017 Chnaging function from  'DBO.FN_TAT_EXCLUDECUTOFFTIME'   to 'fn_TAT_ExcludeCutOffTimeSatSun' to exclude weekends.
   ,dbo.fn_TAT_ExcludeCutOffTimeSatSun(A.ENDTIME, B.ENDTIME) 'DDIFF'              
   FROM @NEEDED A             
   JOIN @PROVIDED B ON A.CASEID = B.CASEID AND A.ROW=B.ROW             
   WHERE B.AUDITID-A.AUDITID  > 0 AND B.AUDITID IS NOT NULL             
   ORDER BY A.CASEID 
  

  /*Nagababu --Getting ONHOLD Time ..Start */



 INSERT INTO @ONHOLD  
 SELECT DISTINCT   
  O.CASEID  
  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS'   
  FROM          
  --(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME' FROM EMAILAUDIT I  
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID is null)) AB   
  --JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           
  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', [dbo].[ChangeDatesAsPerUserTimeZone](ENDTIME,@OFFSET)as 'ENDTIME'FROM EMAILAUDIT I                           
    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID is null)) A ON A.ROWID=AB.ROWID) 'MINS'                          
 FROM EMAILAUDIT O   
 WHERE   
 O.CASEID IN (SELECT CASEID FROM @EMTTAT) AND TOSTATUSID IN (select StatusId from Status where IsOnHold=1 and SubProcessID is null)                          
 ORDER BY O.CASEID   

 /*Nagababu --Getting ONHOLD Time ..End */             

     -- CACLUATE ALL TAT DATA       
if ((select IsVOCSurvey from EMailBox where EMailBoxId=@EMAILBOXID)=1)
begin
	SELECT   
    TAT.CASEID  
   ,TAT.EMTTAT  
   ,TAT.SLA  
   ,TAT.COUNTRY  
   ,TAT.EMAILBOXNAME  
   ,TAT.SUBPROCESSNAME
   ,TAT.CATEGORYNAME   
  ,CAST(AVG(CAST((SiemensTAT.IDIFF/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'CustomerTAT'  
  ,CAST(0 AS BIGINT) AS 'TOTAL'  
  ,CAST(0 AS DECIMAL (18,2)) AS 'COGNIZANTTAT'  
  ,'SLA NOT MET' AS SLASTATUS  
  ,CAST (CAST((SUM(EXCLUDED.DDIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'EXCLUDEDTAT'  
  ,CAST (CAST((SUM(ONHOLD.DIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'ONHOLD' 
  ,TAT.ISMANUAL  
  ,TAT.CREATEDDATE  
  ,TAT.COMPLETEDDATE  
  ,UM.FIRSTNAME +', '+UM.LASTNAME AS LASTQUERYRAISEDBY  
  ,EQ.QUERYTEXT AS LASTQUERY      
  ,TAT.ASSIGNEDTO   
  ,TAT.VOCQUALITY 
  ,TAT.VOCREASON
  ,TAT.VOCTURNAROUNDTIME
  ,TAT.VOCTATREASON
  ,TAT.SURVEYCOMMENTS  
  INTO #FINAL_dynamicchanges3            
   FROM EMAILMASTER EM WITH (NOLOCK)  
   JOIN @EMTTAT TAT ON TAT.CASEID = EM.CASEID   
   LEFT JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID   
   AND EA.EMAILAUDITID IN   
   (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT WITH (NOLOCK) WHERE ToStatusId in (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null) AND CASEID=EM.CASEID)  
    LEFT JOIN EMAILQUERY EQ ON EQ.EMAILAUDITid=EA.EMAILAUDITid 
    LEFT JOIN USERMASTER UM ON UM.USERID=EQ.CreatedById 
    LEFT JOIN (SELECT CASEID, IDIFF 'IDIFF' FROM @PREFINAL) SiemensTAT  ON SiemensTAT.CASEID = EM.CASEID    
    LEFT JOIN (SELECT AAUDIT, CASEID, MIN(DDIFF) 'DDIFF', MIN(DIFF) 'DIFF' FROM @PREFINALX GROUP BY AAUDIT, CASEID) EXCLUDED ON EXCLUDED.CASEID = EM.CASEID         
    LEFT JOIN (SELECT CASEID, DIFF 'DIFF' from @ONHOLD)ONHOLD ON ONHOLD.CASEID = EM.CaseId
	GROUP BY TAT.CASEID,TAT.EMTTAT,TAT.SLA,TAT.COUNTRY,TAT.EMAILBOXNAME,TAT.SUBPROCESSNAME,TAT.CATEGORYNAME,TAT.ISMANUAL,TAT.CREATEDDATE,TAT.COMPLETEDDATE,TAT.LASTCOMMENT,TAT.ASSIGNEDTO  
	,UM.FIRSTNAME +', '+UM.LASTNAME ,EQ.QUERYTEXT , 
    TAT.VOCQUALITY,TAT.VOCREASON,TAT.VOCTURNAROUNDTIME,TAT.VOCTATREASON,TAT.SURVEYCOMMENTS     

	-- CALCULATE COGNIZANT TAT AND SLA STATUS  
    UPDATE #FINAL_dynamicchanges3 SET             
    TOTAL = ISNULL(CustomerTAT,0) + ISNULL(EXCLUDEDTAT,0)         

    UPDATE #FINAL_dynamicchanges3 SET             
    COGNIZANTTAT = (ISNULL(EMTTAT,0) - ISNULL(TOTAL,0)- ISNULL(ONHOLD,0))  
	   
    UPDATE #FINAL_dynamicchanges3 SET             
    SLASTATUS = CASE WHEN COGNIZANTTAT<SLA THEN 'SLA MET' when (COGNIZANTTAT =0 OR SLA=0) then 'NA' WHEN SLA=00 THEN 'NA' WHEN SLA=000 THEN 'NA' ELSE SLASTATUS END  
 
    -- GET FINAL DATA OUTPUT            

 EXEC('SELECT   
   CASEID  
  ,COUNTRY  
  ,SUBPROCESSNAME AS SUBPROCESS  
  ,EMAILBOXNAME AS EMAILBOX  
  ,ISNULL(CATEGORYNAME,''NA'') AS CATEGORYNAME
  ,CASE WHEN ISMANUAL=0 THEN ''EMAIL CASE'' ELSE ''MANUAL CASE'' END AS CASETYPE  
  ,CONVERT(VARCHAR, CREATEDDATE, 103)+'' ''+CONVERT(VARCHAR, CREATEDDATE, 108) AS STARTDATE  
  ,CONVERT(VARCHAR, COMPLETEDDATE, 103)+'' ''+CONVERT(VARCHAR, COMPLETEDDATE, 108) AS ENDDATE   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(ONHOLD,0.00)))  AS ONHOLD   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)))  AS TOTALTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(CustomerTAT,0.00))) AS CustomerTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) AS EXCLUDEDTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) AS COGNIZANTTAT  
  ,SLASTATUS  
  ,ASSIGNEDTO  
  ,LASTQUERYRAISEDBY  
  ,LASTQUERY   
  ,VOCQUALITY as ''VOC_Quality''
  ,VOCREASON  as ''VOC_Reason''  
  ,VOCTURNAROUNDTIME as ''VOC_TurnaroundTime''
  ,VOCTATREASON as ''VOC_TAT_Reason''
  ,SURVEYCOMMENTS  as ''Comments''
  ,'+@cols+   
 ' FROM #FINAL_dynamicchanges3 DC 
  Left join ReportResults RR
  on DC.CaseId=RR.CaseId            
  ORDER BY CASEID ')            

  --DROP TEMP TABLE   

	 DROP TABLE #FINAL_dynamicchanges3
end
else
begin
	SELECT   
    TAT.CASEID  
   ,TAT.EMTTAT  
   ,TAT.SLA  
   ,TAT.COUNTRY  
   ,TAT.EMAILBOXNAME  
   ,TAT.SUBPROCESSNAME
   ,TAT.CATEGORYNAME   
  ,CAST(AVG(CAST((SiemensTAT.IDIFF/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8))) AS DECIMAL(18,2)) 'SiemensTAT'  
  ,CAST(0 AS BIGINT) AS 'TOTAL'  
  ,CAST(0 AS DECIMAL (18,2)) AS 'COGNIZANTTAT'  
  ,'SLA NOT MET' AS SLASTATUS  
  ,CAST (CAST((SUM(EXCLUDED.DDIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'EXCLUDEDTAT'  
  ,CAST (CAST((SUM(ONHOLD.DIFF)/@CONVERTSECONDSTOMIN) AS DECIMAL(18,8)) AS DECIMAL(18,2)) 'ONHOLD' 
  ,TAT.ISMANUAL  
  ,TAT.CREATEDDATE  
  ,TAT.COMPLETEDDATE  
  ,UM.FIRSTNAME +', '+UM.LASTNAME AS LASTQUERYRAISEDBY  
  ,EQ.QUERYTEXT AS LASTQUERY      
  ,TAT.ASSIGNEDTO      
  INTO #FINAL_dynamicchanges4            
   FROM EMAILMASTER EM WITH (NOLOCK)  
   JOIN @EMTTAT TAT ON TAT.CASEID = EM.CASEID   
   LEFT JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID   
   AND EA.EMAILAUDITID IN   
   (SELECT MAX(EMAILAUDITID) FROM EMAILAUDIT WITH (NOLOCK) WHERE ToStatusId in (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null) AND CASEID=EM.CASEID)  
    LEFT JOIN EMAILQUERY EQ ON EQ.EMAILAUDITid=EA.EMAILAUDITid 
    LEFT JOIN USERMASTER UM ON UM.USERID=EQ.CreatedById 
    LEFT JOIN (SELECT CASEID, IDIFF 'IDIFF' FROM @PREFINAL) SiemensTAT  ON SiemensTAT.CASEID = EM.CASEID    
    LEFT JOIN (SELECT AAUDIT, CASEID, MIN(DDIFF) 'DDIFF', MIN(DIFF) 'DIFF' FROM @PREFINALX GROUP BY AAUDIT, CASEID) EXCLUDED ON EXCLUDED.CASEID = EM.CASEID         
    LEFT JOIN (SELECT CASEID, DIFF 'DIFF' from @ONHOLD)ONHOLD ON ONHOLD.CASEID = EM.CaseId
	GROUP BY TAT.CASEID,TAT.EMTTAT,TAT.SLA,TAT.COUNTRY,TAT.EMAILBOXNAME,TAT.SUBPROCESSNAME,TAT.CATEGORYNAME,TAT.ISMANUAL,TAT.CREATEDDATE,TAT.COMPLETEDDATE,TAT.LASTCOMMENT,TAT.ASSIGNEDTO  
	,UM.FIRSTNAME +', '+UM.LASTNAME ,EQ.QUERYTEXT 
 
	-- CALCULATE COGNIZANT TAT AND SLA STATUS  
    UPDATE #FINAL_dynamicchanges4 SET             
    TOTAL = ISNULL(SiemensTAT,0) + ISNULL(EXCLUDEDTAT,0)         

    UPDATE #FINAL_dynamicchanges4 SET             
    COGNIZANTTAT = (ISNULL(EMTTAT,0) - ISNULL(TOTAL,0)- ISNULL(ONHOLD,0))  
	   
    UPDATE #FINAL_dynamicchanges4 SET             
    SLASTATUS = CASE WHEN COGNIZANTTAT<SLA THEN 'SLA MET' when (COGNIZANTTAT =0 OR SLA=0) then 'NA' WHEN SLA=00 THEN 'NA' WHEN SLA=000 THEN 'NA' ELSE SLASTATUS END  
 
    -- GET FINAL DATA OUTPUT            

 EXEC('SELECT   
   DC.CASEID    
  ,COUNTRY  
  ,SUBPROCESSNAME AS SUBPROCESS  
  ,EMAILBOXNAME AS EMAILBOX  
  ,ISNULL(CATEGORYNAME,''NA'') AS CATEGORYNAME
  ,CASE WHEN ISMANUAL=0 THEN ''EMAIL CASE'' ELSE ''MANUAL CASE'' END AS CASETYPE  
  ,CONVERT(VARCHAR, CREATEDDATE, 103)+'' ''+CONVERT(VARCHAR, CREATEDDATE, 108) AS STARTDATE  
  ,CONVERT(VARCHAR, COMPLETEDDATE, 103)+'' ''+CONVERT(VARCHAR, COMPLETEDDATE, 108) AS ENDDATE   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(ONHOLD,0.00)))  AS ONHOLD   
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EMTTAT,0.00)))  AS TOTALTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(SiemensTAT,0.00))) AS SiemensTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(EXCLUDEDTAT,0.00))) AS EXCLUDEDTAT  
  , CONVERT(VARCHAR,dbo.fn_TimeFormat(ISNULL(COGNIZANTTAT,0.00))) AS COGNIZANTTAT  
  ,SLASTATUS  
  ,ASSIGNEDTO  
  ,LASTQUERYRAISEDBY  
  ,LASTQUERY,'
   +@cols+ '    
  FROM #FINAL_dynamicchanges4 DC
  left join ReportResults RR on DC.CaseID=RR.CaseID
  ORDER BY CASEID ')            

  --DROP TEMP TABLE   

	 DROP TABLE #FINAL_dynamicchanges4  

	end	

	end 

 end
GO
/****** Object:  StoredProcedure [dbo].[USP_LoadEMailBoxDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_LoadEMailBoxDetails]
(
      @EMAILBOXID AS INT,

      @USERID VARCHAR(50)
)
AS
BEGIN
      if exists(select * from UserMailBoxMapping where MailBoxId=@EMAILBOXID and UserId=@USERID)
      begin
      select 1
      end
      else
      begin
      select 0
      end
END

      

GO
/****** Object:  StoredProcedure [dbo].[USP_LOCKEMAIL]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
* CREATED BY : RAGUVARAN E
* CREATED DATE : 05/26/2014
* PURPOSE : TO LOCK THE EMAIL IF IT IS UNAUTHORIZED
*/

CREATE PROCEDURE [dbo].[USP_LOCKEMAIL]
(
	@EMAILBOXTYPE INT,
	@EMAILID VARCHAR(200)
)
AS
BEGIN


	IF @EMAILBOXTYPE = 1
	BEGIN
	
		UPDATE EMAILBOXLOGINDETAIL SET ISLOCKED=1,LOCKEDDATE=getutcdate() WHERE EMAILID=@EMAILID AND ISACTIVE=1 AND ISLOCKED=0
		
	END
	ELSE
	BEGIN
	
		UPDATE EMAILBOX SET ISLOCKED=1,LOCKEDDATE=getutcdate() WHERE EMAILBOXADDRESS=@EMAILID AND ISACTIVE=1 AND ISLOCKED=0
		
	END


END









GO
/****** Object:  StoredProcedure [dbo].[USP_Logout_Session]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_Logout_Session] 

@UserId varchar(max)      

AS              

BEGIN   

Update UserMaster set SessionId=null,sessionTime=null where UserId=@UserId

END
GO
/****** Object:  StoredProcedure [dbo].[USP_MAILBOX_CONFIGURATION]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =======================================================                    
-- AUTHOR:  KALAICHELVAN KB                          
-- CREATE DATE: 05/23/2014                          
-- DESCRIPTION: MAILBOX CONFIGURATION                    
-- =======================================================                    
CREATE PROCEDURE [dbo].[USP_MAILBOX_CONFIGURATION]                    
(                    
@EMAILBOXNAME VARCHAR(500),                    
@EMAILBOXADDRESS VARCHAR(500),
@EMailBoxADDRESSOpt Varchar(500),                    
@EMAILFOLDERPATH VARCHAR(500),                    
@DOMAIN VARCHAR(50),                    
@USERID VARCHAR(25),                    
@PASSWORD VARCHAR(100),                    
@COUNTRYNAME VARCHAR(100),          
@SUBPROCESSGROUPID VARCHAR(20),            
@EMAILID VARCHAR(100),      
@TATHRS VARCHAR(10),         
@ISACTIVE INT,                    
@ISQCREQUIRED INT,  
@IsApprovalRequired int,                   
@TRIGGERMAIL INT,             
@ISREPLYNOTREQUIRED INT,               
@ISLOCKED INT,             
@CREATEDBYID VARCHAR(25),
@TIMEZONE VARCHAR(100),
@OFFSET VARCHAR(100),
@IsVocSurvey INT,
@IsSkillBasedAllocation INT                         
)                    
AS                    
DECLARE @COUNTRYID INT                    
SELECT @COUNTRYID = COUNTRYID FROM COUNTRY WHERE COUNTRY=@COUNTRYNAME                    
DECLARE @EMAILBOXLOGINDETAILID INT                    
SELECT @EMAILBOXLOGINDETAILID = EMAILBOXLOGINDETAILID FROM EMAILBOXLOGINDETAIL WHERE EMAILID=@EMAILID       
DECLARE @EMAILBOXID INT                    
SELECT @EMAILBOXID = EMAILBOXID FROM EMAILBOX WHERE EMAILBOXADDRESS=@EMAILBOXADDRESS      
DECLARE @PREVIOUSTATINHRS VARCHAR(10)                    
SELECT @PREVIOUSTATINHRS = TATINHOURS FROM EMAILBOX WHERE EMAILBOXID=@EMAILBOXID      
DECLARE @PREVIOUSTATINSECS VARCHAR(10)                    
SELECT @PREVIOUSTATINSECS = TATINSECONDS FROM EMAILBOX WHERE EMAILBOXID=@EMAILBOXID      
            
BEGIN                    
 IF NOT EXISTS (SELECT @EMAILBOXADDRESS FROM EMAILBOX WHERE EMAILBOXADDRESS=@EMAILBOXADDRESS)                    
  BEGIN                    
   INSERT INTO EMAILBOX (EMAILBOXNAME, EMAILBOXADDRESS,EMailBoxAddressOptional, EMAILFOLDERPATH, DOMAIN, USERID, [PASSWORD], COUNTRYID, SUBPROCESSGROUPID, TATInHours, ISACTIVE,   
   ISQCREQUIRED,IsApprovalRequired, ISMAILTRIGGERREQUIRED, CREATEDBYID, CREATEDDATE, EMAILBOXLOGINDETAILID, ISREPLYNOTREQUIRED, IsLocked, LockedDate, TATInSeconds,TimeZone,Offset,IsVOCSurvey,IsSkillBasedAllocation)          
   VALUES (@EMAILBOXNAME, @EMAILBOXADDRESS,@EMailBoxADDRESSOpt, @EMAILFOLDERPATH, @DOMAIN, @USERID, @PASSWORD, @COUNTRYID, @SUBPROCESSGROUPID, @TATHRS, @ISACTIVE,   
   @ISQCREQUIRED,@IsApprovalRequired, @TRIGGERMAIL, @CREATEDBYID, getutcdate(), @EMAILBOXLOGINDETAILID, @ISREPLYNOTREQUIRED, @ISLOCKED, getutcdate(), (@TATHRS*3600),@TIMEZONE,@OFFSET,@IsVocSurvey,@IsSkillBasedAllocation)       
         
   DECLARE @MAXEMAILBOXID INT      
   SET @MAXEMAILBOXID = (SELECT MAX(EMAILBOXID) FROM EMAILBOX)      
         
   INSERT INTO SLAAUDITMASTER (EMAILBOXID, PREVIOUSTATINHOURS, PREVIOUSTATINSECS, CURRENTTATINHOURS, CURRENTTATINSECS, CREATEDBYID, CREATEDDATE)      
   VALUES (@MAXEMAILBOXID, 0, 0, @TATHRS, (@TATHRS*3600), @CREATEDBYID, getutcdate())      
   SELECT  1                    
  END                    
 ELSE                    
   SELECT  0                    
END                    
                    
                    
--SELECT * FROM EMAILBOXLOGINDETAIL                    
--SELECT * FROM COUNTRY                
--SELECT * FROM EMAILBOX          
--select * from subprocessgroups      
--select * from Slaauditmaster      
      
--DECLARE @EMAILBOXID INT                    
--SELECT @EMAILBOXID = EMAILBOXID FROM EMAILBOX WHERE EMAILBOXADDRESS='CTS-VMD@se.issworld.com'      
--PRINT @EMAILBOXID       
      
--DECLARE @PREVIOUSTATHRS VARCHAR(10)                    
--SELECT @PREVIOUSTATHRS = TATINHOURS FROM EMAILBOX WHERE EMAILBOXID=3      
--SELECT @PREVIOUSTATHRS      
      
--DECLARE @PREVIOUSTATSECS VARCHAR(10)                    
--SELECT @PREVIOUSTATSECS = TATINSECONDS FROM EMAILBOX WHERE EMAILBOXID=3      
--SELECT @PREVIOUSTATSECS      
      
--SELECT TATINHOURS, TATINSECONDS FROM EMAILBOX WHERE EMAILBOXID=3
GO
/****** Object:  StoredProcedure [dbo].[USP_MoveCaseFromClarifNeededToClarifReceived]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[USP_MoveCaseFromClarifNeededToClarifReceived]
(  
 @CaseIds as varchar(1000),  
 @LoggedInUserId as varchar(50)
)  
as  
Begin
		create table #ActiveTable (CaseId bigint)

		insert into #ActiveTable(CaseId) 
		select *  from [SplitCaseID](@CaseIds, ',')

		declare @CaseId bigint

		while (select count(*) from #ActiveTable) > 0
		Begin
				select top 1 @CaseId = CaseId From #ActiveTable
				--Start
			
				DECLARE @AUDITID AS BIGINT
				DECLARE @STATUS AS INT
				DECLARE @COMMENTS AS VARCHAR(1000)
				set @STATUS = 4 
				set @COMMENTS = 'Case moved manually from clarification needed to clarification provided.'

				IF @CASEID IS NOT NULL  
					 BEGIN 
							
						  DECLARE @PREVIOUSSTATUSID INT  
						    
						  SELECT @PREVIOUSSTATUSID = STATUSID FROM EMAILMASTER WHERE CASEID=@CaseId  
						    
						  UPDATE EMAILMASTER SET STATUSID=@STATUS,LASTCOMMENT=@COMMENTS,MODIFIEDBYID=@LoggedInUserId,MODIFIEDDATE=getutcdate()  
						  WHERE CASEID=@CaseId  
					    
						  INSERT INTO EMAILAUDIT (CaseId,FromStatusId,ToStatusId,UserId,StartTime,EndTime)   
						  VALUES (@CaseId,@PREVIOUSSTATUSID,@STATUS,@LoggedInUserId,getutcdate(),getutcdate())  
					    
						  SELECT @AUDITID=@@IDENTITY  
							IF((@COMMENTS<>'' OR @COMMENTS IS NOT NULL) AND @AUDITID IS NOT NULL)  
								BEGIN 
									INSERT INTO EMAILQUERY (CASEID,EmailAuditID,QUERYTEXT,CREATEDBYID,CREATEDDATE)  
									VALUES (@CaseId,@AUDITID,@COMMENTS,@LoggedInUserId,getutcdate())  
								END  
				  END 
					Delete #ActiveTable Where CaseId = @CaseId
		END
End

DROP TABLE #ActiveTable








GO
/****** Object:  StoredProcedure [dbo].[USP_REFERENCE_MAILBOXADD]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_REFERENCE_MAILBOXADD]    
(    
@CountryId int,
@MailBoxId INT,  
@Reference varchar(200),
@isActive bit,
@createdby varchar(20)
)    
AS    
BEGIN    
 IF NOT EXISTS (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxReferenceConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId and Reference =@Reference)       
	 BEGIN
			INSERT INTO [dbo].[EmailboxReferenceConfig] values (@CountryId,@MailBoxId,@Reference,@createdby,getutcdate(),NULL,NULL,@isActive)
			select 1
	 END 
 ELSE   
	 BEGIN
            Select 0 
     END 

END 



GO
/****** Object:  StoredProcedure [dbo].[USP_REMAINDER_MAILBOXADD]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================================================    

-- Author:  Ranjith        

-- Create date: 04/27/2015         

-- Description: To configure the remainders for mailbox

-- ====================================================  

CREATE PROCEDURE [dbo].[USP_REMAINDER_MAILBOXADD]    
(    
@CountryId int,
@MailBoxId INT,  
@freq int,
@count int,
@isescalation int,
@isActive bit,
@createdby varchar(20),
@TemplateType int,
@Template nvarchar(max)
)    
AS    
BEGIN    
 IF NOT EXISTS (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId and TemplateType=@TemplateType)       

		 BEGIN

			INSERT INTO [dbo].[EmailboxRemainderConfig](CountryId,EmailboxId,Frequency,Count,IsEscalation,CreatedbyId,CreatedDate,ModifiedbyId,ModifiedDate,IsActive,TemplateType,Template) values (@CountryId,@MailBoxId,@freq,@count,@isescalation,@createdby,getutcdate(),NULL,NULL,@isActive,@TemplateType,@Template)
			select 1
		 END 

		 ELSE   

		 BEGIN
 Select 0 
		 END 
   

END





GO
/****** Object:  StoredProcedure [dbo].[USP_REMAINDER_MAILBOXADD_dynamicstatus]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ====================================================    

-- Author:  Ranjith        

-- Create date: 04/27/2015         

-- Description: To configure the remainders for mailbox

-- ====================================================  

CREATE PROCEDURE [dbo].[USP_REMAINDER_MAILBOXADD_dynamicstatus]    
(    
@CountryId int,
@MailBoxId INT, 
@FromStatusId int,
@ToStatusId int, 
@freq int,
@count int,
@isescalation int,
@isActive bit,
@createdby varchar(20),
@TemplateType int,
@Template nvarchar(max),
@EscalationMailId nvarchar(max)
)    
AS    
BEGIN    
declare @SubproceesId int
set @SubproceesId=(select SubProcessGroupId from EMailBox where EMailBoxId=@MailBoxId)
	INSERT INTO [dbo].[EmailboxRemainderConfig](CountryId,EmailboxId,Frequency,[Count],IsEscalation,CreatedbyId,CreatedDate,ModifiedbyId,ModifiedDate,IsActive,TemplateType,Template,FromStatus,Tostatus,EscalationMailId) 
	
	values (@CountryId,@MailBoxId,@freq,@count,@isescalation,@createdby,getutcdate(),NULL,NULL,@isActive,@TemplateType,@Template,@FromStatusId,@ToStatusId,@EscalationMailId)
    select 1
END


--select * from [EmailboxRemainderConfig]


			
		 

		 




GO
/****** Object:  StoredProcedure [dbo].[USP_RemoveCaseInlineAttachments]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-----------------------------------------------
-- Author	: Varma
-- Date		: 12 Apr 2016
-- Descripation: Removing Inlineattachments of the Case
-----------------------------------------------
--exec USP_RemoveCaseInlineAttachments 392528
CREATE PROCEDURE [dbo].[USP_RemoveCaseInlineAttachments]
	@CaseId bigint,@AttachmentType int
AS
BEGIN
	if exists(SELECT * from EMailAttachment where caseid=@CaseId and AttachmentTypeID=@AttachmentType and IsDeleted=0)
		begin 
			--update EMailAttachment set IsDeleted=1 where caseid=@CaseId and AttachmentTypeID=3 and IsDeleted=0
			delete EMailAttachment where caseid=@CaseId and AttachmentTypeID=@AttachmentType and IsDeleted=0
			select 1
		end
	else
		begin 
			select 0
		end
END

--select * from EMailAttachment where caseid=835 and AttachmentTypeID=3
GO
/****** Object:  StoredProcedure [dbo].[USP_REPORT_CLARIFICATIONSENTREPORT]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 -- EXEC [USP_REPORT_CLARIFICATIONSENTREPORT_test] 1,1,'06/05/2015','06/05/2015'
 
 CREATE PROCEDURE [dbo].[USP_REPORT_CLARIFICATIONSENTREPORT] 
  (      
		 @COUNTRYID INT = NULL,
		 @EMAILBOXID INT = NULL,  
		 @FROMDATE DATETIME = NULL, 
		 @TODATE DATETIME = NULL,
		 @SUBPROCESSGROUPID INT =NULL,		 
		 @OFFSET varchar(15)= NULL,
		 @CategoryID varchar(200)=null 
)          
AS           
BEGIN    
SET NOCOUNT ON;    
DECLARE @TEMP1 TABLE ( CASEID BIGINT,EMAILRECEIVEDDATE DATETIME,CLARIFICATIONSENTDATE DATETIME,CATEGORY VARCHAR(200),PLAINBODY VARCHAR(MAX),TOSTATUSID INT,FROMSTATUSID INT,CategoryID bigint,AUDITID BIGINT)

if (@CategoryID is not null)    
begin
INSERT INTO @TEMP1
		SELECT  DISTINCT  EM.CASEID AS 'CASE ID'
		,CONVERT(DATETIME,EMAILRECEIVEDDATE,121) AS 'EMAIL RECEIVED DATE'
		--,[dbo].[ChangeDatesAsPerUserTimeZone](EMAILRECEIVEDDATE,@OFFSET) as 'EMAIL RECEIVED DATE'
		,CONVERT(DATETIME,ES.EMAILSENTDATE,121) AS 'CLARIFICATION SENT DATE'
		--,[dbo].[ChangeDatesAsPerUserTimeZone](ES.EMAILSENTDATE,@OFFSET) as 'CLARIFICATION SENT DATE'
		,EBCC.CATEGORY,ES.PLAINBODY,EA.TOSTATUSID,EA.FROMSTATUSID,ct.CateroryID,ea.EmailAuditId 
		
		FROM EMAILMASTER EM WITH(NOLOCK)
		 JOIN  EMAILAUDIT EA ON EM.CASEID=EA.CASEID 
		JOIN [dbo].[CategoryTransaction] CT WITH(NOLOCK) ON CT.AuditID= EA.EmailAuditId and em.CaseId=ct.CaseId
		JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId
		JOIN EMAILSENT ES ON ES.AuditID =EA.EmailAuditId
		JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID
		JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
		left join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 
		WHERE EA.TOSTATUSID=3 AND EM.ISMANUAL=0 
		AND ES.EMAILTYPEID=1 
		--AND EM.CASEID = 168
		AND (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)   
		AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)  
		AND ((@CategoryID IS NULL) OR (EM.CategoryId in (@CategoryID)))
		AND ((CAST(CONVERT(VARCHAR(11),EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL))   
		--AND ((CAST(CONVERT(VARCHAR(15),SWITCHOFFSET(CONVERT(datetimeoffset,EA.STARTTIME),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL))   
end
else
begin
	INSERT INTO @TEMP1
		SELECT  DISTINCT  EM.CASEID AS 'CASE ID'
		,CONVERT(DATETIME,EMAILRECEIVEDDATE,121) AS 'EMAIL RECEIVED DATE'
		--,[dbo].[ChangeDatesAsPerUserTimeZone](EMAILRECEIVEDDATE,@OFFSET) as 'EMAIL RECEIVED DATE'
		,CONVERT(DATETIME,ES.EMAILSENTDATE,121) AS 'CLARIFICATION SENT DATE'
		--,[dbo].[ChangeDatesAsPerUserTimeZone](ES.EMAILSENTDATE,@OFFSET) as 'CLARIFICATION SENT DATE'
		,EBCC.CATEGORY,ES.PLAINBODY,EA.TOSTATUSID,EA.FROMSTATUSID,ct.CateroryID,ea.EmailAuditId 
		
		FROM EMAILMASTER EM WITH(NOLOCK)
		 JOIN  EMAILAUDIT EA ON EM.CASEID=EA.CASEID 
		JOIN [dbo].[CategoryTransaction] CT WITH(NOLOCK) ON CT.AuditID= EA.EmailAuditId and em.CaseId=ct.CaseId
		JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId
		JOIN EMAILSENT ES ON ES.AuditID =EA.EmailAuditId
		JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID
		JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
		WHERE EA.TOSTATUSID=3 AND EM.ISMANUAL=0 
		AND ES.EMAILTYPEID=1 
		--AND EM.CASEID = 168
		AND (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)   
		AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)  
		AND ((@CategoryID IS NULL) OR (EM.CategoryId in (@CategoryID)))
		AND ((CAST(CONVERT(VARCHAR(11),EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL))   
		--AND ((CAST(CONVERT(VARCHAR(15),SWITCHOFFSET(CONVERT(datetimeoffset,EA.STARTTIME),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL))   
	
end

--SELECT * FROM @TEMP1
DECLARE  @TEMP2 TABLE (CASEID BIGINT,CLARIFICATIONREPLYRECEIVEDDATE DATETIME,TOSTATUSID INT,FROMSTATUSID INT,AUDITID BIGINT)

INSERT INTO @TEMP2
		SELECT   DISTINCT EM.CASEID
		,CONVERT(DATETIME,EA.STARTTIME,121) AS CLARIFICATIONREPLYRECEIVEDDATE
		--,[dbo].[ChangeDatesAsPerUserTimeZone](EA.STARTTIME,@OFFSET) as CLARIFICATIONREPLYRECEIVEDDATE
		,EA.TOSTATUSID,EA.FROMSTATUSID,ea.EmailAuditId 
		FROM EMAILMASTER EM WITH(NOLOCK)
		JOIN EMAILAUDIT EA WITH(NOLOCK) ON EM.CASEID=EA.CASEID 
		JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID
		JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
		WHERE  EA.TOSTATUSID IN (4) AND EM.ISMANUAL=0
		-- AND EM.CASEID = 168
		AND (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)    
		AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)   
		AND ((@CategoryID IS NULL) OR (EM.CategoryId in (@CategoryID)))
		AND ((CAST(CONVERT(VARCHAR(11), EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL)) 
        --AND ((CAST(CONVERT(VARCHAR(15), SWITCHOFFSET(CONVERT(datetimeoffset,EA.STARTTIME),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL)) 

--SELECT * FROM @TEMP2

SELECT  DISTINCT S.CASEID AS 'CASE ID' , 
--CONVERT(VARCHAR, S.EMAILRECEIVEDDATE, 103)+' '+CONVERT(VARCHAR, S.EMAILRECEIVEDDATE, 108)  AS 'EMAIL RECEIVED DATE',
[dbo].[ChangeDatesAsPerUserTimeZone](S.EMAILRECEIVEDDATE,@OFFSET) AS 'EMAIL RECEIVED DATE',
--CONVERT(VARCHAR, S.CLARIFICATIONSENTDATE, 103)+' '+CONVERT(VARCHAR, S.CLARIFICATIONSENTDATE, 108)  AS 'CLARIFICATION SENT DATE',
[dbo].[ChangeDatesAsPerUserTimeZone](S.CLARIFICATIONSENTDATE,@OFFSET) AS 'CLARIFICATION SENT DATE',
(SELECT   ebcc.Category FROM [dbo].[CategoryTransaction] CT WITH(NOLOCK) join  EMAILBOXCATEGORYCONFIG EBCC ON ct.CateroryID =ebcc.EmailboxCategoryId
 WHERE ct.CASEID = S.CASEID AND ct.AuditID=S.AUDITID  ) AS CATEGORY,
 S.PLAINBODY AS 'CLARIFICATION MAIL TEXT',
 
--(SELECT  TOP 1  CONVERT(VARCHAR, A.STARTTIME, 103)+' '+CONVERT(VARCHAR, A.STARTTIME, 108)  FROM EMAILAUDIT A WITH(NOLOCK) WHERE A.CASEID = S.CASEID AND A.FROMSTATUSID=S.TOSTATUSID AND A.STARTTIME >= S.CLARIFICATIONSENTDATE ) AS 'CLARIFICATION REPLY RECEIVED DATE' 
(SELECT  TOP 1  [dbo].[ChangeDatesAsPerUserTimeZone](A.STARTTIME,@OFFSET)  FROM EMAILAUDIT A WITH(NOLOCK) WHERE A.CASEID = S.CASEID AND A.FROMSTATUSID=S.TOSTATUSID AND SWITCHOFFSET(CONVERT(datetimeoffset,A.STARTTIME),@Offset) >= SWITCHOFFSET(CONVERT(datetimeoffset,S.CLARIFICATIONSENTDATE),@Offset) ) AS 'CLARIFICATION REPLY RECEIVED DATE' 

FROM @TEMP1 S   
INNER JOIN @TEMP2 S1 ON S1.CASEID=S.CASEID
WHERE S.TOSTATUSID = S1.FROMSTATUSID

 END
GO
/****** Object:  StoredProcedure [dbo].[USP_REPORT_CLARIFICATIONSENTREPORT_dynamicchanges]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 -- EXEC [USP_REPORT_CLARIFICATIONSENTREPORT_dynamicchanges] 4,5,'06/05/2015','06/05/2017',null,'-4:00',''
 
 CREATE PROCEDURE [dbo].[USP_REPORT_CLARIFICATIONSENTREPORT_dynamicchanges] 
  (      
		 @COUNTRYID INT = NULL,
		 @EMAILBOXID INT = NULL,  
		 @FROMDATE DATETIME = NULL, 
		 @TODATE DATETIME = NULL,
		 @SUBPROCESSGROUPID INT =NULL,		 
		 @OFFSET varchar(15)= NULL,
		 @CategoryID varchar(200)=null 
)          
AS           
BEGIN    
SET NOCOUNT ON;   

if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = '#Temp1'
			   )
	begin
			drop table #Temp1
	end 
	if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = '#Temp2'
			   )
	begin
			drop table #Temp2
	end 
	 
CREATE TABLE #TEMP1 ( CASEID BIGINT,EMAILRECEIVEDDATE DATETIME,CLARIFICATIONSENTDATE DATETIME,CATEGORY VARCHAR(200),PLAINBODY VARCHAR(MAX),TOSTATUSID INT,FROMSTATUSID INT,CategoryID bigint,AUDITID BIGINT)

declare @SubProcessID as nvarchar(max)
set @SubProcessID=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMAILBOXID)


if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'ReportResults'
			   )
	begin
			drop table ReportResults
	end 

		declare @cols AS NVARCHAR(MAX)		
select @cols = STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) 
                    from dbo.Tbl_FieldConfiguration FC 					 							 
				where FC.Active='1' and FC.MailBoxID=@EMAILBOXID                 
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @cols

		declare @colsCreateTable as NVARCHAR(Max)
		declare @queryDBReportsResult as NVArchar(max)
select @colsCreateTable=STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) +' NVARCHAR(max)'
                    from dbo.Tbl_FieldConfiguration FC 
					left join  dbo.Tbl_ClientTransaction CT  on CT.FieldMasterId=FC.FieldMasterId
								 
				where FC.Active=1 and FC.MailBoxID= @EMAILBOXID 
                    group by FC.FieldName
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		set @queryDBReportsResult='Create table ReportResults(CaseId bigint,'+@colsCreateTable+')'
		 print @queryDBReportsResult
		 exec sp_executesql @queryDBReportsResult

		declare @queryDB  AS NVARCHAR(MAX)
set @queryDB = N'insert into ReportResults(CaseId,'+@cols+') SELECT CaseID,' + @cols + N' from 
             (
                
				select CaseID, FieldValue, FC.FieldName
                from dbo.Tbl_ClientTransaction CT 
				inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 				 
				where FC.MailBoxID='+CONVERT(VARCHAR(50),@EMAILBOXID)+' and FC.Active=''1''				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldName in (' + @cols + N')
            ) p '
print @queryDB 
 exec sp_executesql @queryDB


if (@CategoryID is not null)    
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	INSERT INTO #TEMP1
		SELECT  DISTINCT  EM.CASEID AS 'CASE ID'
		,CONVERT(DATETIME,EMAILRECEIVEDDATE,121) AS 'EMAIL RECEIVED DATE'		
		,CONVERT(DATETIME,ES.EMAILSENTDATE,121) AS 'CLARIFICATION SENT DATE'		
		,EBCC.CATEGORY,ES.PLAINBODY,EA.TOSTATUSID,EA.FROMSTATUSID,ct.CateroryID,ea.EmailAuditId 		
		FROM EMAILMASTER EM WITH(NOLOCK)
		 JOIN  EMAILAUDIT EA ON EM.CASEID=EA.CASEID 
		JOIN [dbo].[CategoryTransaction] CT WITH(NOLOCK) ON CT.AuditID= EA.EmailAuditId and em.CaseId=ct.CaseId
		JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId
		JOIN EMAILSENT ES ON ES.AuditID =EA.EmailAuditId
		JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID		    
		JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
		JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
		JOIN Status ST ON EM.StatusId=ST.StatusId  and ST.SubProcessID=SG.SubProcessGroupId
		left join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 
		WHERE EA.TOSTATUSID in(select StatusId from Status where IsReminderStatus=1 and SubProcessID=@SubProcessID) AND EM.ISMANUAL=0 
		AND ES.EMAILTYPEID=1 		
		AND (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)   
		AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)  
		AND ((@CategoryID IS NULL) OR (EM.CategoryId in (@CategoryID)))
		AND ((CAST(CONVERT(VARCHAR(11),EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL))
end
else
begin
	INSERT INTO #TEMP1
		SELECT  DISTINCT  EM.CASEID AS 'CASE ID'
		,CONVERT(DATETIME,EMAILRECEIVEDDATE,121) AS 'EMAIL RECEIVED DATE'		
		,CONVERT(DATETIME,ES.EMAILSENTDATE,121) AS 'CLARIFICATION SENT DATE'		
		,EBCC.CATEGORY,ES.PLAINBODY,EA.TOSTATUSID,EA.FROMSTATUSID,ct.CateroryID,ea.EmailAuditId 		
		FROM EMAILMASTER EM WITH(NOLOCK)
		 JOIN  EMAILAUDIT EA ON EM.CASEID=EA.CASEID 
		JOIN [dbo].[CategoryTransaction] CT WITH(NOLOCK) ON CT.AuditID= EA.EmailAuditId and em.CaseId=ct.CaseId
		JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId
		JOIN EMAILSENT ES ON ES.AuditID =EA.EmailAuditId
		JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID		    
		JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID		
		JOIN Status ST ON EM.StatusId=ST.StatusId  
		left join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 
		WHERE EA.TOSTATUSID in (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null) AND EM.ISMANUAL=0 
		AND ES.EMAILTYPEID=1 		
		AND (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)   
		AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)  
		AND ((@CategoryID IS NULL) OR (EM.CategoryId in (@CategoryID)))
		AND ((CAST(CONVERT(VARCHAR(11),EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL))
end   		
end
else
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	INSERT INTO #TEMP1
		SELECT  DISTINCT  EM.CASEID AS 'CASE ID'
		,CONVERT(DATETIME,EMAILRECEIVEDDATE,121) AS 'EMAIL RECEIVED DATE'		
		,CONVERT(DATETIME,ES.EMAILSENTDATE,121) AS 'CLARIFICATION SENT DATE'		
		,EBCC.CATEGORY,ES.PLAINBODY,EA.TOSTATUSID,EA.FROMSTATUSID,ct.CateroryID,ea.EmailAuditId 		
		FROM EMAILMASTER EM WITH(NOLOCK)
		JOIN  EMAILAUDIT EA ON EM.CASEID=EA.CASEID 
		JOIN [dbo].[CategoryTransaction] CT WITH(NOLOCK) ON CT.AuditID= EA.EmailAuditId and em.CaseId=ct.CaseId
		JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId
		JOIN EMAILSENT ES ON ES.AuditID =EA.EmailAuditId
		JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID
		JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
		JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
		JOIN Status ST ON EM.StatusId=ST.StatusId  and ST.SubProcessID=SG.SubProcessGroupId
		WHERE EA.TOSTATUSID in(select StatusId from Status where IsReminderStatus=1 and SubProcessID =@SUBPROCESSGROUPID) AND EM.ISMANUAL=0 
		AND ES.EMAILTYPEID=1 		
		AND (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)   
		AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)  
		AND ((@CategoryID IS NULL) OR (EM.CategoryId in (@CategoryID)))
		AND ((CAST(CONVERT(VARCHAR(11),EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL))
end
else
begin
	INSERT INTO #TEMP1
		SELECT  DISTINCT  EM.CASEID AS 'CASE ID'
		,CONVERT(DATETIME,EMAILRECEIVEDDATE,121) AS 'EMAIL RECEIVED DATE'		
		,CONVERT(DATETIME,ES.EMAILSENTDATE,121) AS 'CLARIFICATION SENT DATE'		
		,EBCC.CATEGORY,ES.PLAINBODY,EA.TOSTATUSID,EA.FROMSTATUSID,ct.CateroryID,ea.EmailAuditId 		
		FROM EMAILMASTER EM WITH(NOLOCK)
		JOIN  EMAILAUDIT EA ON EM.CASEID=EA.CASEID 
		JOIN [dbo].[CategoryTransaction] CT WITH(NOLOCK) ON CT.AuditID= EA.EmailAuditId and em.CaseId=ct.CaseId
		JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId
		JOIN EMAILSENT ES ON ES.AuditID =EA.EmailAuditId
		JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID
		JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
		JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
		JOIN Status ST ON EM.StatusId=ST.StatusId
		WHERE EA.TOSTATUSID in(select StatusId from Status where IsReminderStatus=1 and SubProcessID is null) AND EM.ISMANUAL=0 
		AND ES.EMAILTYPEID=1 		
		AND (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)   
		AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)  
		AND ((@CategoryID IS NULL) OR (EM.CategoryId in (@CategoryID)))
		AND ((CAST(CONVERT(VARCHAR(11),EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL))
end   	
	
end


CREATE TABLE  #TEMP2 (CASEID BIGINT,CLARIFICATIONREPLYRECEIVEDDATE DATETIME,TOSTATUSID INT,FROMSTATUSID INT,AUDITID BIGINT)

if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	INSERT INTO #TEMP2
		SELECT   DISTINCT EM.CASEID
		,CONVERT(DATETIME,EA.STARTTIME,121) AS CLARIFICATIONREPLYRECEIVEDDATE		
		,EA.TOSTATUSID,EA.FROMSTATUSID,ea.EmailAuditId 
		FROM EMAILMASTER EM WITH(NOLOCK)
		JOIN EMAILAUDIT EA WITH(NOLOCK) ON EM.CASEID=EA.CASEID 
		JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID
		JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
		LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
		inner JOIN Status ST ON ST.SubProcessID=SG.SubProcessGroupId and EM.StatusId=ST.StatusId
		WHERE  EA.TOSTATUSID IN (select StatusId from Status where IsFollowupStatus=1 and SubProcessID=@SubProcessID) AND EM.ISMANUAL=0		
		AND (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)    
		AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)   
		AND ((@CategoryID IS NULL) OR (EM.CategoryId in (@CategoryID)))
		AND ((CAST(CONVERT(VARCHAR(11), EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL)) 
end
else
begin
	INSERT INTO #TEMP2
		SELECT   DISTINCT EM.CASEID
		,CONVERT(DATETIME,EA.STARTTIME,121) AS CLARIFICATIONREPLYRECEIVEDDATE		
		,EA.TOSTATUSID,EA.FROMSTATUSID,ea.EmailAuditId 
		FROM EMAILMASTER EM WITH(NOLOCK)
		JOIN EMAILAUDIT EA WITH(NOLOCK) ON EM.CASEID=EA.CASEID 
		JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID
		JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
		LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
		inner JOIN Status ST ON EM.StatusId=ST.StatusId
		WHERE  EA.TOSTATUSID IN (select StatusId from Status where IsFollowupStatus=1 and SubProcessID is null) AND EM.ISMANUAL=0		
		AND (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)    
		AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)   
		AND ((@CategoryID IS NULL) OR (EM.CategoryId in (@CategoryID)))
		AND ((CAST(CONVERT(VARCHAR(11), EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) OR (@FROMDATE IS NULL AND @TODATE IS NULL)) 
end        

EXEC ('SELECT  DISTINCT S.CASEID AS ''CASE ID'' , 
[dbo].[ChangeDatesAsPerUserTimeZone](S.EMAILRECEIVEDDATE,'''+@OFFSET+''') AS ''EMAIL RECEIVED DATE'',
[dbo].[ChangeDatesAsPerUserTimeZone](S.CLARIFICATIONSENTDATE,'''+@OFFSET+''') AS ''CLARIFICATION SENT DATE'',
(SELECT   ebcc.Category FROM [dbo].[CategoryTransaction] CT WITH(NOLOCK) join  EMAILBOXCATEGORYCONFIG EBCC ON ct.CateroryID =ebcc.EmailboxCategoryId
 WHERE ct.CASEID = S.CASEID AND ct.AuditID=S.AUDITID  ) AS CATEGORY,
 S.PLAINBODY AS ''CLARIFICATION MAIL TEXT'', 
(SELECT  TOP 1  [dbo].[ChangeDatesAsPerUserTimeZone](A.STARTTIME,'''+@OFFSET+''')  FROM EMAILAUDIT A WITH(NOLOCK) WHERE A.CASEID = S.CASEID AND A.FROMSTATUSID=S.TOSTATUSID AND SWITCHOFFSET(CONVERT(datetimeoffset,A.STARTTIME),'''+@Offset+''') >= SWITCHOFFSET(CONVERT(datetimeoffset,S.CLARIFICATIONSENTDATE),'''+@Offset+''') ) AS ''CLARIFICATION REPLY RECEIVED DATE''
,'+@cols+' 
FROM #TEMP1 S   
INNER JOIN #TEMP2 S1 ON S1.CASEID=S.CASEID
left join ReportResults RR on S.CASEID=RR.CASEID
WHERE S.TOSTATUSID = S1.FROMSTATUSID
')




--select * from @Temp1 t1 left join @temp2 t2 on t1.caseid=t2.caseid
 END
GO
/****** Object:  StoredProcedure [dbo].[USP_REPORT_OPENCLARIFICATIONAGEING]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -- exec [USP_REPORT_OPENCLARIFICATIONAGEING_test] 2,103,'05/28/2015','08/19/2015'

  CREATE PROCEDURE [dbo].[USP_REPORT_OPENCLARIFICATIONAGEING] 

  (           

@COUNTRYID INT = NULL,           

@EMAILBOXID INT = NULL,            

@FROMDATE DATETIME = NULL,          

@TODATE DATETIME = NULL,

@SUBPROCESSGROUPID int  = NULL,

@OFFSET VARCHAR(15) = NULL,

@CategoryID varchar(200)=null  
)

AS                      

BEGIN                       

SET NOCOUNT ON; 

if (@CategoryID is not null) 
begin
SELECT  distinct  EM.CASEID AS 'CASE ID',
--CONVERT(VARCHAR, EMAILRECEIVEDDATE, 103)+' '+CONVERT(VARCHAR, EMAILRECEIVEDDATE, 108) AS 'EMAIL RECEIVED DATE',
[dbo].[ChangeDatesAsPerUserTimeZone](EMAILRECEIVEDDATE,@OFFSET) as 'EMAIL RECEIVED DATE',
--CONVERT(VARCHAR, EA.ENDTIME, 103)+' '+CONVERT(VARCHAR, EA.ENDTIME, 108) AS 'CLARIFICATION SENT DATE',
[dbo].[ChangeDatesAsPerUserTimeZone](EA.ENDTIME,@OFFSET) as 'CLARIFICATION SENT DATE',

	 EBCC.CATEGORY  as Category,es.EMailTo,es.EMailCc,

ISNULL((DATEDIFF(DD, (select max(EndTime) from EMAILAUDIT WITH(NOLOCK) where ToStatusId=3 and CaseID=EM.CaseID ), GETDATE())), 0) [AGEING IN DAYS]

	FROM EMAILMASTER EM WITH (NOLOCK)

	JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID AND EA.EmailAuditId in (select Max(EmailAuditId) from EMAILAUDIT where TOSTATUSID=3 and CaseID=EM.CaseID and em.StatusId=3)

	JOIN [dbo].[CategoryTransaction] CT WITH (NOLOCK) ON CT.AuditID= EA.EmailAuditId 

    JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId

	 join  EMAILSENT ES WITH (NOLOCK) ON  ES.AuditID=EA.EmailAuditId and EMAILTYPEID IN (1,3) 

	JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID

JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID

left join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID
inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 

WHERE (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)          

AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)          

--AND ((CAST(CONVERT(VARCHAR(11),EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE)

AND ((CAST(CONVERT(VARCHAR(11),SWITCHOFFSET(CONVERT(datetimeoffset,EA.STARTTIME),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE)

 OR (@FROMDATE IS NULL AND @TODATE IS NULL))   order by em.caseid

end
else
begin
	SELECT  distinct  EM.CASEID AS 'CASE ID',
--CONVERT(VARCHAR, EMAILRECEIVEDDATE, 103)+' '+CONVERT(VARCHAR, EMAILRECEIVEDDATE, 108) AS 'EMAIL RECEIVED DATE',
[dbo].[ChangeDatesAsPerUserTimeZone](EMAILRECEIVEDDATE,@OFFSET) as 'EMAIL RECEIVED DATE',
--CONVERT(VARCHAR, EA.ENDTIME, 103)+' '+CONVERT(VARCHAR, EA.ENDTIME, 108) AS 'CLARIFICATION SENT DATE',
[dbo].[ChangeDatesAsPerUserTimeZone](EA.ENDTIME,@OFFSET) as 'CLARIFICATION SENT DATE',

	 EBCC.CATEGORY  as Category,es.EMailTo,es.EMailCc,

ISNULL((DATEDIFF(DD, (select max(EndTime) from EMAILAUDIT WITH(NOLOCK) where ToStatusId=3 and CaseID=EM.CaseID ), GETDATE())), 0) [AGEING IN DAYS]

	FROM EMAILMASTER EM WITH (NOLOCK)

	JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID AND EA.EmailAuditId in (select Max(EmailAuditId) from EMAILAUDIT where TOSTATUSID=3 and CaseID=EM.CaseID and em.StatusId=3)

	JOIN [dbo].[CategoryTransaction] CT WITH (NOLOCK) ON CT.AuditID= EA.EmailAuditId 

    JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId

	 join  EMAILSENT ES WITH (NOLOCK) ON  ES.AuditID=EA.EmailAuditId and EMAILTYPEID IN (1,3) 

	JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID

JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID

left join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID

WHERE (EB.COUNTRYID = @COUNTRYID OR @COUNTRYID IS NULL)          

AND (EB.EMAILBOXID = @EMAILBOXID OR @EMAILBOXID IS NULL)          

--AND ((CAST(CONVERT(VARCHAR(11),EA.STARTTIME) AS DATETIME) BETWEEN @FROMDATE AND @TODATE)

AND ((CAST(CONVERT(VARCHAR(11),SWITCHOFFSET(CONVERT(datetimeoffset,EA.STARTTIME),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE)

 OR (@FROMDATE IS NULL AND @TODATE IS NULL))   order by em.caseid

end
END
GO
/****** Object:  StoredProcedure [dbo].[USP_REPORT_OPENCLARIFICATIONAGEING_dynamicchanges]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 -- exec [USP_REPORT_OPENCLARIFICATIONAGEING_test] 2,103,'05/28/2015','08/19/2015'

  CREATE PROCEDURE [dbo].[USP_REPORT_OPENCLARIFICATIONAGEING_dynamicchanges] 

  (           

@COUNTRYID INT = NULL,           

@EMAILBOXID INT = NULL,            

@FROMDATE DATETIME = NULL,          

@TODATE DATETIME = NULL,

@SUBPROCESSGROUPID int  = NULL,

@OFFSET VARCHAR(15) = NULL,

@CategoryID varchar(200)=null  
)

AS                      

BEGIN                       

SET NOCOUNT ON; 


--Saranya to display dynamic fields in reports

		if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'ReportResults'
			   )
	begin
			drop table ReportResults
	end 

		declare @cols AS NVARCHAR(MAX)		
select @cols = STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) 
                    from dbo.Tbl_FieldConfiguration FC 					 							 
				where FC.Active='1' and FC.MailBoxID=@EMAILBOXID                 
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @cols

		declare @colsCreateTable as NVARCHAR(Max)
		declare @queryDBReportsResult as NVArchar(max)
select @colsCreateTable=STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) +' NVARCHAR(max)'
                    from dbo.Tbl_FieldConfiguration FC 
					left join  dbo.Tbl_ClientTransaction CT  on CT.FieldMasterId=FC.FieldMasterId
								 
				where FC.Active=1 and FC.MailBoxID= @EMAILBOXID 
                    group by FC.FieldName
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		set @queryDBReportsResult='Create table ReportResults(CaseId bigint,'+@colsCreateTable+')'
		 print @queryDBReportsResult
		 exec sp_executesql @queryDBReportsResult

		declare @queryDB  AS NVARCHAR(MAX)
set @queryDB = N'insert into ReportResults(CaseId,'+@cols+') SELECT CaseID,' + @cols + N' from 
             (
                
				select CaseID, FieldValue, FC.FieldName
                from dbo.Tbl_ClientTransaction CT 
				inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 				 
				where FC.MailBoxID='+CONVERT(VARCHAR(50),@EMAILBOXID)+' and FC.Active=''1''				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldName in (' + @cols + N')
            ) p '
print @queryDB 
 exec sp_executesql @queryDB
 
 --end of dynamic fields

declare @SubProcessID nvarchar(max)
set @SubProcessID=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMAILBOXID)

if (@CategoryID is not null) 
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	EXEC('SELECT  distinct  EM.CASEID AS ''CASE ID'',
	[dbo].[ChangeDatesAsPerUserTimeZone](EMAILRECEIVEDDATE,'''+@OFFSET+''') as ''EMAIL RECEIVED DATE'',
	[dbo].[ChangeDatesAsPerUserTimeZone](EA.ENDTIME,'''+@OFFSET+''') as ''CLARIFICATION SENT DATE'',
	EBCC.CATEGORY  as Category,es.EMailTo,es.EMailCc,
	ISNULL((DATEDIFF(DD, (select max(EndTime) from EMAILAUDIT WITH(NOLOCK) where ToStatusId in (select Statusid from Status where IsReminderStatus=1 and SubProcessID='''+@SubProcessID+''') and CaseID=EM.CaseID ), GETDATE())), 0) [AGEING IN DAYS]
	,'+@cols+'
	FROM EMAILMASTER EM WITH (NOLOCK)
	JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID AND EA.EmailAuditId in (select Max(EmailAuditId) from EMAILAUDIT where TOSTATUSID in (select Statusid from Status where IsReminderStatus=1 and SubProcessID='''+@SubProcessID+''') and CaseID=EM.CaseID and em.StatusId in (select Statusid from Status where IsReminderStatus=1 and SubProcessID='''+@SubProcessID+'''))
	JOIN [dbo].[CategoryTransaction] CT WITH (NOLOCK) ON CT.AuditID= EA.EmailAuditId 
	JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId
	join  EMAILSENT ES WITH (NOLOCK) ON  ES.AuditID=EA.EmailAuditId and EMAILTYPEID IN (1,3) 
	JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID
	JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
	inner JOIN Status ST ON ST.SubProcessID=SG.SubProcessGroupId and EM.StatusId=ST.StatusId
	left join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID
	inner join dbo.ConvertDelimitedListIntoTable('+@CategoryID+','','') arr ON EM.Categoryid= arr.Item 
	left join ReportResults RR on EM.CaseID=RR.CaseID
	WHERE (EB.COUNTRYID = '''+ @COUNTRYID+''' OR'''+ @COUNTRYID+''' IS NULL)          
	AND (EB.EMAILBOXID = '''+@EMAILBOXID+''' OR'''+ @EMAILBOXID+''' IS NULL)          
	AND ((CAST(CONVERT(VARCHAR(11),SWITCHOFFSET(CONVERT(datetimeoffset,EA.STARTTIME),'''+@OFFSET+''')) AS DATETIME) BETWEEN '''+@FROMDATE+''' AND '''+@TODATE+''')
	OR ('''+@FROMDATE+''' IS NULL AND '''+@TODATE+''' IS NULL))   order by em.caseid')
end
else
begin
	EXEC('SELECT  distinct  EM.CASEID AS ''CASE ID'',
	[dbo].[ChangeDatesAsPerUserTimeZone](EMAILRECEIVEDDATE,'''+@OFFSET+''') as ''EMAIL RECEIVED DATE'',
	[dbo].[ChangeDatesAsPerUserTimeZone](EA.ENDTIME,'''+@OFFSET+''') as ''CLARIFICATION SENT DATE'',
	EBCC.CATEGORY  as Category,es.EMailTo,es.EMailCc,
	ISNULL((DATEDIFF(DD, (select max(EndTime) from EMAILAUDIT WITH(NOLOCK) where ToStatusId in (select Statusid from Status where IsReminderStatus=1 and SubProcessID is null) and CaseID=EM.CaseID ), GETDATE())), 0) [AGEING IN DAYS]
	,'+@cols+'
	FROM EMAILMASTER EM WITH (NOLOCK)
	JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID AND EA.EmailAuditId in (select Max(EmailAuditId) from EMAILAUDIT where TOSTATUSID in (select Statusid from Status where IsReminderStatus=1 and SubProcessID is null) and CaseID=EM.CaseID and em.StatusId in (select Statusid from Status where IsReminderStatus=1 and SubProcessID is null))
	JOIN [dbo].[CategoryTransaction] CT WITH (NOLOCK) ON CT.AuditID= EA.EmailAuditId 
	JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId
	join  EMAILSENT ES WITH (NOLOCK) ON  ES.AuditID=EA.EmailAuditId and EMAILTYPEID IN (1,3) 
	JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID
	JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID
	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
	inner JOIN Status ST ON EM.StatusId=ST.StatusId  
	left join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID
	inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,'','') arr ON EM.Categoryid= arr.Item 
	left join ReportResults RR on EM.CaseID=RR.CaseID
	WHERE (EB.COUNTRYID = '''+ @COUNTRYID+''' OR'''+ @COUNTRYID+''' IS NULL)          
	AND (EB.EMAILBOXID = '''+@EMAILBOXID+''' OR'''+ @EMAILBOXID+''' IS NULL)          
	AND ((CAST(CONVERT(VARCHAR(11),SWITCHOFFSET(CONVERT(datetimeoffset,EA.STARTTIME),'''+@OFFSET+''')) AS DATETIME) BETWEEN '''+@FROMDATE+''' AND '''+@TODATE+''')
	OR ('''+@FROMDATE+''' IS NULL AND '''+@TODATE+''' IS NULL))   order by em.caseid')

end
end
else
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	EXEC('SELECT  distinct  EM.CASEID AS ''CASE ID'',
	[dbo].[ChangeDatesAsPerUserTimeZone](EMAILRECEIVEDDATE,'''+@OFFSET+''') as ''EMAIL RECEIVED DATE'',
	[dbo].[ChangeDatesAsPerUserTimeZone](EA.ENDTIME,'''+@OFFSET+''') as ''CLARIFICATION SENT DATE'',

	EBCC.CATEGORY  as Category,es.EMailTo,es.EMailCc,

	ISNULL((DATEDIFF(DD, (select max(EndTime) from EMAILAUDIT WITH(NOLOCK) where ToStatusId in (select StatusId from Status where IsReminderStatus=1 and SubProcessID='''+@SubProcessID+''') and CaseID=EM.CaseID ), GETDATE())), 0) [AGEING IN DAYS]

	,'+@cols+'

	FROM EMAILMASTER EM WITH (NOLOCK)

	JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID AND EA.EmailAuditId in (select Max(EmailAuditId) from EMAILAUDIT where TOSTATUSID=(select StatusId from Status where IsReminderStatus=1 and SubProcessID='''+@SubProcessID+''') and CaseID=EM.CaseID and em.StatusId=(select StatusId from Status where IsReminderStatus=1 and SubProcessID='''+@SubProcessID+'''))

	JOIN [dbo].[CategoryTransaction] CT WITH (NOLOCK) ON CT.AuditID= EA.EmailAuditId 

    JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId

	 join  EMAILSENT ES WITH (NOLOCK) ON  ES.AuditID=EA.EmailAuditId and EMAILTYPEID IN (1,3) 

	JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID

	JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID

	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID

	inner JOIN Status ST ON ST.SubProcessID=SG.SubProcessGroupId and EM.StatusId=ST.StatusId

	left join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID
	left join ReportResults RR on EM.CaseID=RR.CaseID

	WHERE (EB.COUNTRYID = '''+ @COUNTRYID+''' OR'''+ @COUNTRYID+''' IS NULL)          
	AND (EB.EMAILBOXID = '''+@EMAILBOXID+''' OR'''+ @EMAILBOXID+''' IS NULL) 
		
	AND ((CAST(CONVERT(VARCHAR(11),SWITCHOFFSET(CONVERT(datetimeoffset,EA.STARTTIME),'''+@OFFSET+''')) AS DATETIME) BETWEEN '''+@FROMDATE+''' AND '''+@TODATE+''')

	OR ('''+@FROMDATE+''' IS NULL AND '''+@TODATE+''' IS NULL))   order by em.caseid')
end
else
begin
	EXEC('SELECT  distinct  EM.CASEID AS ''CASE ID'',
	[dbo].[ChangeDatesAsPerUserTimeZone](EMAILRECEIVEDDATE,'''+@OFFSET+''') as ''EMAIL RECEIVED DATE'',
	[dbo].[ChangeDatesAsPerUserTimeZone](EA.ENDTIME,'''+@OFFSET+''') as ''CLARIFICATION SENT DATE'',

	EBCC.CATEGORY  as Category,es.EMailTo,es.EMailCc,

	ISNULL((DATEDIFF(DD, (select max(EndTime) from EMAILAUDIT WITH(NOLOCK) where ToStatusId in (select StatusId from Status where IsReminderStatus=1 and SubProcessID is null) and CaseID=EM.CaseID ), GETDATE())), 0) [AGEING IN DAYS]
	,'+@cols+'
	FROM EMAILMASTER EM WITH (NOLOCK)
	
	JOIN EMAILAUDIT EA WITH (NOLOCK) ON EM.CASEID=EA.CASEID AND EA.EmailAuditId in (select Max(EmailAuditId) from EMAILAUDIT where TOSTATUSID=(select StatusId from Status where IsReminderStatus=1 and SubProcessID is null) and CaseID=EM.CaseID and em.StatusId=(select StatusId from Status where IsReminderStatus=1 and SubProcessID is null))

	JOIN [dbo].[CategoryTransaction] CT WITH (NOLOCK) ON CT.AuditID= EA.EmailAuditId 

    JOIN EMAILBOXCATEGORYCONFIG EBCC ON CT.CateroryID = EBCC.EmailboxCategoryId

	 join  EMAILSENT ES WITH (NOLOCK) ON  ES.AuditID=EA.EmailAuditId and EMAILTYPEID IN (1,3) 

	JOIN EMAILBOX EB ON EB.EMAILBOXID = EM.EMAILBOXID

	JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID

	LEFT JOIN SUBPROCESSGROUPS SG ON EB.SUBPROCESSGROUPID=SG.SUBPROCESSGROUPID
  
	inner JOIN Status ST ON EM.StatusId=ST.StatusId 

	left join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID
	left join ReportResults RR on EM.CaseID=RR.CaseID
	WHERE (EB.COUNTRYID = '''+ @COUNTRYID+''' OR'''+ @COUNTRYID+''' IS NULL)          
	AND (EB.EMAILBOXID = '''+@EMAILBOXID+''' OR'''+ @EMAILBOXID+''' IS NULL) 
		
	AND ((CAST(CONVERT(VARCHAR(11),SWITCHOFFSET(CONVERT(datetimeoffset,EA.STARTTIME),'''+@OFFSET+''')) AS DATETIME) BETWEEN '''+@FROMDATE+''' AND '''+@TODATE+''')

	OR ('''+@FROMDATE+''' IS NULL AND '''+@TODATE+''' IS NULL))   order by em.caseid')
end	
end
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Report_Productivity]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




  

--USP_Report_Productivity_test 4,2,'01-01-2014', '05-05-2017',2,'+05:30','6'

    

-- ==============================================================        

-- Author:  SAKTHIVE MANIKANDAN              

-- Create date: 07/15/2014              

-- Description: To GET PRODUCTIVITY DATA

-- ==============================================================  

      

      

CREATE PROCEDURE [dbo].[USP_Report_Productivity] 

(           

@COUNTRYID int = null,           

@EMAILBOXID int = null,            

@FROMDATE datetime = null,          

@TODATE datetime = null,

@SUBPROCESSGROUPID int = null,

@OFFSET varchar(15) = null,

@CategoryID varchar(200) = NULL
)          

AS                      

BEGIN                          

SET NOCOUNT ON;                           

if (@CategoryID is not null)          
   begin 
SELECT em.CaseId, --CONVERT(VARCHAR(10), em.CreatedDate, 103) +' ' +CONVERT(VARCHAR(8), em.CreatedDate, 108) [CreatedDate], 
[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,@OFFSET) as 'CreatedDate',

eb.EmailboxName, 
ISNULL(ECC.CATEGORY,'NA') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/ 

s.StatusDescription Status,         

Case when  um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' IS NULL then 'N/A'         

else um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' end CompletedBy,  

--CONVERT(VARCHAR(10), em.completeddate, 103) +' ' +CONVERT(VARCHAR(8), em.completeddate, 108) as 'Completed Date', 
[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,@OFFSET) as 'Completed Date',

case when em.ismanual=1 then 'Manual' else  'Email' end as 'Case Type',       

sg.SubprocessName,

Cy.Country,  
--Pranay 18 DEc 2016 for adding Survey Response and comments 
--EM.SurveyResponse,Em.SurveyComments
--Case when SVD.VOC_Quality='Y' then 'Yes' else 'No' END AS VOC_Quality
 SVD.VOC_Quality
,SVD.VOC_Reason
--,Case when SVD.VOC_TurnaroundTime='Y' then 'Yes' else 'No' END as VOC_TurnaroundTime
,SVD.VOC_TurnaroundTime
,SVD.VOC_TAT_Reason
,SVD.Comments    

from EmailMaster em WITH(NOLOCK) left join           

UserMaster um on em.CompletedById = um.UserId left JOIN           

Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join          

Status s on em.StatusId = s.StatusId          

left join Country Cy on  CY.countryId=eb.CountryId    

left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid
LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */
LEFT JOIN SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID

inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 

WHERE (eb.CountryId = @COUNTRYID OR @COUNTRYID IS NULL)          

AND (eb.EmailboxId = @EMAILBOXID OR @EMAILBOXID IS NULL)          

--AND ((CAST(CONVERT(varchar(11), em.CompletedDate) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) 

AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) 

 OR (@FROMDATE IS NULL AND @TODATE IS NULL))         

AND (em.StatusId = 10) 

AND (eb.SubProcessGroupId = @SUBPROCESSGROUPID OR @SUBPROCESSGROUPID IS NULL)   

end
else
begin
SELECT em.CaseId, --CONVERT(VARCHAR(10), em.CreatedDate, 103) +' ' +CONVERT(VARCHAR(8), em.CreatedDate, 108) [CreatedDate], 
[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,@OFFSET) as 'CreatedDate',

eb.EmailboxName, 
ISNULL(ECC.CATEGORY,'NA') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/ 

s.StatusDescription Status,         

Case when  um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' IS NULL then 'N/A'         

else um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' end CompletedBy,  

--CONVERT(VARCHAR(10), em.completeddate, 103) +' ' +CONVERT(VARCHAR(8), em.completeddate, 108) as 'Completed Date', 
[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,@OFFSET) as 'Completed Date',

case when em.ismanual=1 then 'Manual' else  'Email' end as 'Case Type',       

sg.SubprocessName,

Cy.Country    

from EmailMaster em WITH(NOLOCK) left join           

UserMaster um on em.CompletedById = um.UserId left JOIN           

Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join          

Status s on em.StatusId = s.StatusId          

left join Country Cy on  CY.countryId=eb.CountryId    

left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid
LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */

WHERE (eb.CountryId = @COUNTRYID OR @COUNTRYID IS NULL)          

AND (eb.EmailboxId = @EMAILBOXID OR @EMAILBOXID IS NULL)          

--AND ((CAST(CONVERT(varchar(11), em.CompletedDate) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) 

AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) 

 OR (@FROMDATE IS NULL AND @TODATE IS NULL))         

AND (em.StatusId = 10) 

AND (eb.SubProcessGroupId = @SUBPROCESSGROUPID OR @SUBPROCESSGROUPID IS NULL)   

end

END
GO
/****** Object:  StoredProcedure [dbo].[USP_Report_Productivity_dynamicchanges]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




  

--USP_Report_Productivity_test 4,2,'01-01-2014', '05-05-2017',2,'+05:30','6'

    

-- ==============================================================        

-- Author:  SAKTHIVE MANIKANDAN              

-- Create date: 07/15/2014              

-- Description: To GET PRODUCTIVITY DATA

-- ==============================================================  

      

      

CREATE PROCEDURE [dbo].[USP_Report_Productivity_dynamicchanges] 

(           

@COUNTRYID int = null,           

@EMAILBOXID int = null,            

@FROMDATE datetime = null,          

@TODATE datetime = null,

@SUBPROCESSGROUPID int = null,

@OFFSET varchar(15) = null,

@CategoryID varchar(200) = NULL
)          

AS                      

BEGIN                          

SET NOCOUNT ON; 

declare @dyColumn as nvarchar(150)

	If((Select IsVOCSurvey from emailbox where EMailBoxId = @EMAILBOXID) = 1)
		Begin
			set @dyColumn= 'sg.SubprocessName,Cy.Country,SVD.VOC_Quality,SVD.VOC_Reason	,SVD.VOC_TurnaroundTime	,SVD.VOC_TAT_Reason	,SVD.Comments'
		End
	else
		Begin
			set @dyColumn= 'sg.SubprocessName,Cy.Country'
		END

declare @SubProcessID nvarchar(max)
set @SubProcessID=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMAILBOXID)

if (@CategoryID is not null)          
begin 
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	SELECT em.CaseId, 
	[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,@OFFSET) as 'CreatedDate',

	eb.EmailboxName, 
	ISNULL(ECC.CATEGORY,'NA') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/ 

	s.StatusDescription Status,         

	Case when  um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' IS NULL then 'N/A'         

	else um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' end CompletedBy,  

	[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,@OFFSET) as 'Completed Date',

	case when em.ismanual=1 then 'Manual' else  'Email' end as 'Case Type',       

	+ @dyColumn
	--sg.SubprocessName,

	--Cy.Country , case when @dyColumn<>NULL then @dyColumn end
		--Pranay 18 DEc 2016 for adding Survey Response and comments 
		-- , SVD.VOC_Quality
		--,SVD.VOC_Reason
		--,SVD.VOC_TurnaroundTime
		--,SVD.VOC_TAT_Reason
		--,SVD.Comments    

	from EmailMaster em WITH(NOLOCK) left join           

	UserMaster um on em.CompletedById = um.UserId left JOIN           

	Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join          

	Status s on em.StatusId = s.StatusId          

	left join Country Cy on  CY.countryId=eb.CountryId    

	left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid and s.SubProcessID=sg.SubProcessGroupId
	LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */
	LEFT JOIN SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID

	inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 

	WHERE (eb.CountryId = @COUNTRYID OR @COUNTRYID IS NULL)          

	AND (eb.EmailboxId = @EMAILBOXID OR @EMAILBOXID IS NULL)          

	AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) 

	 OR (@FROMDATE IS NULL AND @TODATE IS NULL))         

	AND (em.StatusId = (select StatusId from Status where IsCompleted=1 and SubProcessID=@SubProcessID) )

	AND (eb.SubProcessGroupId = @SUBPROCESSGROUPID OR @SUBPROCESSGROUPID IS NULL)   

end
else
begin
	SELECT em.CaseId, 
	[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,@OFFSET) as 'CreatedDate',

	eb.EmailboxName, 
	ISNULL(ECC.CATEGORY,'NA') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/ 

	s.StatusDescription Status,         

	Case when  um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' IS NULL then 'N/A'         

	else um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' end CompletedBy,  

	[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,@OFFSET) as 'Completed Date',

	case when em.ismanual=1 then 'Manual' else  'Email' end as 'Case Type',       
	
	+ @dyColumn
	--sg.SubprocessName,

	--Cy.Country,  
	----Pranay 18 DEc 2016 for adding Survey Response and comments 
	-- SVD.VOC_Quality
	--,SVD.VOC_Reason
	--,SVD.VOC_TurnaroundTime
	--,SVD.VOC_TAT_Reason
	--,SVD.Comments    

	from EmailMaster em WITH(NOLOCK) left join           

	UserMaster um on em.CompletedById = um.UserId left JOIN           

	Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join          

	Status s on em.StatusId = s.StatusId          

	left join Country Cy on  CY.countryId=eb.CountryId    

	left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid 
	LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */
	LEFT JOIN SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID

	inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON EM.Categoryid= arr.Item 

	WHERE (eb.CountryId = @COUNTRYID OR @COUNTRYID IS NULL)          

	AND (eb.EmailboxId = @EMAILBOXID OR @EMAILBOXID IS NULL)          

	AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) 

	 OR (@FROMDATE IS NULL AND @TODATE IS NULL))         

	AND (em.StatusId = (select StatusId from Status where IsCompleted=1 and SubProcessID is null) )

	AND (eb.SubProcessGroupId = @SUBPROCESSGROUPID OR @SUBPROCESSGROUPID IS NULL)   
	end

end
else
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	SELECT em.CaseId, 
	[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,@OFFSET) as 'CreatedDate',

	eb.EmailboxName, 
	ISNULL(ECC.CATEGORY,'NA') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/ 

	s.StatusDescription Status,         

	Case when  um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' IS NULL then 'N/A'         

	else um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' end CompletedBy,  

	[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,@OFFSET) as 'Completed Date',

	case when em.ismanual=1 then 'Manual' else  'Email' end as 'Case Type',       

	+ @dyColumn
	--sg.SubprocessName,

	--Cy.Country    

	from EmailMaster em WITH(NOLOCK) left join           

	UserMaster um on em.CompletedById = um.UserId left JOIN           

	Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join          

	Status s on em.StatusId = s.StatusId          

	left join Country Cy on  CY.countryId=eb.CountryId    

	left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid and s.SubProcessID=sg.SubProcessGroupId 

	LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */

	WHERE (eb.CountryId = @COUNTRYID OR @COUNTRYID IS NULL)          

	AND (eb.EmailboxId = @EMAILBOXID OR @EMAILBOXID IS NULL)          

	AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) 

	 OR (@FROMDATE IS NULL AND @TODATE IS NULL))         

	AND (em.StatusId = (select StatusId from Status where IsCompleted=1 and SubProcessID=@SubProcessID)) 

	AND (eb.SubProcessGroupId = @SUBPROCESSGROUPID OR @SUBPROCESSGROUPID IS NULL)   

end
else
begin
	SELECT em.CaseId, 
	[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,@OFFSET) as 'CreatedDate',

	eb.EmailboxName, 
	ISNULL(ECC.CATEGORY,'NA') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/ 

	s.StatusDescription Status,         

	Case when  um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' IS NULL then 'N/A'         

	else um.FirstName +' '+ um.LastName +' (' + um.UserId + ')' end CompletedBy,  

	[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,@OFFSET) as 'Completed Date',

	case when em.ismanual=1 then 'Manual' else  'Email' end as 'Case Type',       

	+ @dyColumn
	--sg.SubprocessName,

	--Cy.Country    

	from EmailMaster em WITH(NOLOCK) left join           

	UserMaster um on em.CompletedById = um.UserId left JOIN           

	Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join          

	Status s on em.StatusId = s.StatusId          

	left join Country Cy on  CY.countryId=eb.CountryId    

	left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid

	LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */

	WHERE (eb.CountryId = @COUNTRYID OR @COUNTRYID IS NULL)          

	AND (eb.EmailboxId = @EMAILBOXID OR @EMAILBOXID IS NULL)          

	AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),@Offset)) AS DATETIME) BETWEEN @FROMDATE AND @TODATE) 

	 OR (@FROMDATE IS NULL AND @TODATE IS NULL))         

	AND (em.StatusId = (select StatusId from Status where IsCompleted=1 and SubProcessID is null)) 

	AND (eb.SubProcessGroupId = @SUBPROCESSGROUPID OR @SUBPROCESSGROUPID IS NULL)   
end
end

END
GO
/****** Object:  StoredProcedure [dbo].[USP_Report_Productivity_dynamicchanges_dynamicSP]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




  

--USP_Report_Productivity_test 4,2,'01-01-2014', '05-05-2017',2,'+05:30','6'

    

-- ==============================================================        

-- Author:  SAKTHIVE MANIKANDAN              

-- Create date: 07/15/2014              

-- Description: To GET PRODUCTIVITY DATA

-- ==============================================================  

      

      

CREATE PROCEDURE [dbo].[USP_Report_Productivity_dynamicchanges_dynamicSP] 

(           

@COUNTRYID int = null,           

@EMAILBOXID int = null,            

@FROMDATE datetime = null,          

@TODATE datetime = null,

@SUBPROCESSGROUPID int = null,

@OFFSET varchar(15) = null,

@CategoryID varchar(200) = NULL
)          

AS                      

BEGIN                          

SET NOCOUNT ON; 

declare @dyColumn as nvarchar(max)

	If((Select IsVOCSurvey from emailbox where EMailBoxId = @EMAILBOXID) = 1)
		Begin
			set @dyColumn= 'sg.SubprocessName,Cy.Country,SVD.VOC_Quality,SVD.VOC_Reason	,SVD.VOC_TurnaroundTime	,SVD.VOC_TAT_Reason	,SVD.Comments'
		End
	else
		Begin
			set @dyColumn= 'sg.SubprocessName,Cy.Country'
		END

declare @SubProcessID nvarchar(max)
set @SubProcessID=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMAILBOXID)
declare @query1 nvarchar(max)
declare @query2 nvarchar(max)
declare @query3 nvarchar(max)

if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'ReportResults'
			   )
	begin
			drop table ReportResults
	end 

		declare @cols AS NVARCHAR(MAX)		
select @cols = STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) 
                    from dbo.Tbl_FieldConfiguration FC 					 							 
				where FC.Active='1' and FC.MailBoxID=@EMAILBOXID                 
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @cols

		declare @colsCreateTable as NVARCHAR(Max)
		declare @queryDBReportsResult as NVArchar(max)
select @colsCreateTable=STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) +' NVARCHAR(max)'
                    from dbo.Tbl_FieldConfiguration FC 
					left join  dbo.Tbl_ClientTransaction CT  on CT.FieldMasterId=FC.FieldMasterId
								 
				where FC.Active=1 and FC.MailBoxID= @EMAILBOXID 
                    group by FC.FieldName
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		set @queryDBReportsResult='Create table ReportResults(CaseId bigint,'+@colsCreateTable+')'
		 print @queryDBReportsResult
		 exec sp_executesql @queryDBReportsResult

		declare @queryDB  AS NVARCHAR(MAX)
set @queryDB = N'insert into ReportResults(CaseId,'+@cols+') SELECT CaseID,' + @cols + N' from 
             (
                
				select CaseID, FieldValue, FC.FieldName
                from dbo.Tbl_ClientTransaction CT 
				inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 				 
				where FC.MailBoxID='+CONVERT(VARCHAR(50),@EMAILBOXID)+' and FC.Active=''1''				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldName in (' + @cols + N')
            ) p '
print @queryDB 
 exec sp_executesql @queryDB

if (@CategoryID is not null)          
begin 
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	EXEC ('SELECT em.CaseId, 
	[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,'''+@OFFSET+''') as ''CreatedDate'',
	eb.EmailboxName, 
	ISNULL(ECC.CATEGORY,''NA'') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/ 
	s.StatusDescription Status,         
	Case when  um.FirstName +'' ''+ um.LastName +'' ('' + um.UserId + '')'' IS NULL then ''N/A''        
	else um.FirstName +'' ''+ um.LastName +'' ('' + um.UserId + '')'' end CompletedBy,  
	[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,'''+@OFFSET+''') as ''Completed Date'',
	case when em.ismanual=1 then ''Manual'' else ''Email'' end as ''Case Type'','     
	+@dyColumn+
	','+@cols+' from EmailMaster em WITH(NOLOCK) left join 
	ReportResults  RR on EM.CaseId=RR.CaseId left join
	UserMaster um on em.CompletedById = um.UserId left JOIN           
	Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join          
	Status s on em.StatusId = s.StatusId          
	left join Country Cy on  CY.countryId=eb.CountryId    
	left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid and s.SubProcessID=sg.SubProcessGroupId
	LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */
	LEFT JOIN SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	inner join dbo.ConvertDelimitedListIntoTable('''+@CategoryID+''','','') arr ON EM.Categoryid= arr.Item 
	WHERE (eb.CountryId ='''+ @COUNTRYID+''' OR '''+@COUNTRYID+''' IS NULL)        
	AND (eb.EmailboxId = '''+@EMAILBOXID+''' OR '''+@EMAILBOXID+''' IS NULL)          
	AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),'''+@Offset+''')) AS DATETIME) BETWEEN '''+@FROMDATE+''' AND '''+@TODATE+''') 
	 OR ('''+@FROMDATE+''' IS NULL AND '''+@TODATE+''' IS NULL))         
	AND (em.StatusId in (select StatusId from Status where IsFinalStatus=1 and SubProcessID='''+@SubProcessID+''') )
	AND (eb.SubProcessGroupId = '''+@SubProcessID+''' OR '''+@SubProcessID+''' IS NULL)')
end
else
begin
	EXEC('SELECT em.CaseId, 
	[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,'''+@OFFSET+''') as ''CreatedDate'',
	eb.EmailboxName, 
	ISNULL(ECC.CATEGORY,''NA'') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/ 
	s.StatusDescription Status,         
	Case when  um.FirstName +'' ''+ um.LastName +'' ('' + um.UserId + '')'' IS NULL then ''N/A''
	else um.FirstName +'' ''+ um.LastName +'' ('' + um.UserId + '')'' end CompletedBy,
	[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,'''+@OFFSET+''') as ''Completed Date'',
	case when em.ismanual=1 then ''Manual'' else  ''Email'' end as ''Case Type'','    
	+ @dyColumn+
	','+@cols+' from EmailMaster em WITH(NOLOCK) left join  
	ReportResults  RR on EM.CaseId=RR.CaseId left join         
	UserMaster um on em.CompletedById = um.UserId left JOIN
	Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join
	Status s on em.StatusId = s.StatusId
	left join Country Cy on  CY.countryId=eb.CountryId
	left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid
	LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */
	LEFT JOIN SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	inner join dbo.ConvertDelimitedListIntoTable('''+@CategoryID+''','','') arr ON EM.Categoryid= arr.Item
	WHERE (eb.CountryId = '''+@COUNTRYID+''' OR '''+@COUNTRYID+''' IS NULL)
	AND (eb.EmailboxId = '''+@EMAILBOXID+''' OR '''+@EMAILBOXID+''' IS NULL)
	AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),'''+@Offset+''')) AS DATETIME) BETWEEN '''+@FROMDATE+''' AND '''+@TODATE+''')
	OR ('''+@FROMDATE+''' IS NULL AND '''+@TODATE+''' IS NULL))
	AND (em.StatusId in (select StatusId from Status where IsFinalStatus=1 and SubProcessID is null))
	AND (eb.SubProcessGroupId = '''+@SubProcessID+''' OR '''+@SubProcessID+''' IS NULL)')
	end
end
else
begin
if exists(select * from Status where SubProcessID=@SubProcessID)
begin
	EXEC('SELECT em.CaseId,
	[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,'''+@OFFSET+''') as ''CreatedDate'',
	eb.EmailboxName,
	ISNULL(ECC.CATEGORY,''NA'') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/
	s.StatusDescription Status,
	Case when  um.FirstName +'' ''+ um.LastName +'' ('' + um.UserId + '')'' IS NULL then ''N/A''
	else um.FirstName +'' ''+ um.LastName +'' ('' + um.UserId + '')'' end CompletedBy,
	[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,+'''+@OFFSET+''') as ''Completed Date'',
	case when em.ismanual=1 then ''Manual'' else  ''Email'' end as ''Case Type'','
	+ @dyColumn+
	','+@cols+' from EmailMaster em WITH(NOLOCK) left join
	ReportResults  RR on EM.CaseId=RR.CaseId left join
	UserMaster um on em.CompletedById = um.UserId left JOIN
	Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join
	Status s on em.StatusId = s.StatusId
	left join Country Cy on  CY.countryId=eb.CountryId
	left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid and s.SubProcessID=sg.SubProcessGroupId
	LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */
	LEFT JOIN SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	WHERE (eb.CountryId = '''+@COUNTRYID+''' OR '''+@COUNTRYID+''' IS NULL)
	AND (eb.EmailboxId = '''+@EMAILBOXID+''' OR '''+@EMAILBOXID+''' IS NULL)
	AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),'''+@Offset+''')) AS DATETIME) BETWEEN '''+@FROMDATE+''' AND '''+@TODATE+''')
	OR ('''+@FROMDATE+''' IS NULL AND '''+@TODATE+''' IS NULL))
	AND (em.StatusId in (select StatusId from Status where IsFinalStatus=1 and SubProcessID='''+@SubProcessID+'''))
	AND (eb.SubProcessGroupId = '''+@SubProcessID+''' OR '''+@SubProcessID+''' IS NULL)')
end
else
begin
	EXEC('SELECT em.CaseId, 
	[dbo].[ChangeDatesAsPerUserTimeZone](em.CreatedDate,'''+@OFFSET+''') as ''CreatedDate'',
	eb.EmailboxName,
	ISNULL(ECC.CATEGORY,''NA'') as Category,/*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report*/
	s.StatusDescription Status,
	Case when  um.FirstName +'' ''+ um.LastName +'' ('' + um.UserId + '')'' IS NULL then ''N/A''
	else um.FirstName +'' ''+ um.LastName +'' ('' + um.UserId + '')'' end CompletedBy,
	[dbo].[ChangeDatesAsPerUserTimeZone](em.completeddate,'''+@OFFSET+''') as ''Completed Date'',
	case when em.ismanual=1 then ''Manual'' else  ''Email'' end as ''Case Type'','
	+ @dyColumn+
	','+@cols+' from EmailMaster em WITH(NOLOCK) left join    
	ReportResults  RR on EM.CaseId=RR.CaseId left join  
	UserMaster um on em.CompletedById = um.UserId left JOIN           
	Emailbox eb on em.EmailboxId = eb.EmailboxId and eb.IsActive=1 inner join          
	Status s on em.StatusId = s.StatusId          
	left join Country Cy on  CY.countryId=eb.CountryId    
	left join subprocessgroups sg on sg.subprocessgroupid=eb.subprocessgroupid
	LEFT JOIN  EmailboxCategoryConfig ECC On EM.CategoryId=ECC.EmailboxCategoryId /*Nagababu merge SP relate to stackland servey POC--adding Category in Productivity Report */
	LEFT JOIN SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseID
	WHERE (eb.CountryId ='''+@COUNTRYID+''' OR '''+@COUNTRYID+''' IS NULL)          
	AND (eb.EmailboxId = '''+@EMAILBOXID+''' OR '''+@EMAILBOXID+''' IS NULL)         
	AND ((CAST(CONVERT(varchar(11), SWITCHOFFSET(CONVERT(datetimeoffset,em.CompletedDate),'''+@Offset+''')) AS DATETIME) BETWEEN '''+@FROMDATE+''' AND '''+@TODATE+''') 
	 OR ('''+@FROMDATE+''' IS NULL AND '''+@TODATE+''' IS NULL))         
	AND (em.StatusId in (select StatusId from Status where IsFinalStatus=1 and SubProcessID is null)) 
	AND (eb.SubProcessGroupId = '''+@SubProcessID+''' OR '''+@SubProcessID+''' IS NULL)')   
end
end
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Report_TAT_Casewise_Details]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec USP_Report_TAT_Casewise_Details 6,'04-01-2017',null, '1', '04-25-2017','5,21'  

CREATE PROCEDURE [dbo].[USP_Report_TAT_Casewise_Details]                          

   @EMAILBOXID varchar(10) = null, 

  @FROMDATE datetime = null,  

  @SUBPROCESSGROUPID varchar(10) = null, 
   
  @COUNTRYID Varchar(10) = null,
                
  @TODATE datetime = null,
  
  @OFFSET varchar(30) = null,

  @CATEGORYID varchar(200)=null               

AS                          

BEGIN  

if(@CategoryID is not null)
begin 
	exec USP_Report_TAT_Casewise_Details_sub2 @EMAILBOXID,@FROMDATE,@SUBPROCESSGROUPID,@COUNTRYID,@TODATE,@OFFSET,@CategoryID
end 
else 
begin 
	exec USP_Report_TAT_Casewise_Details_sub1 @EMAILBOXID,@FROMDATE,@SUBPROCESSGROUPID,@COUNTRYID,@TODATE,@OFFSET,@CategoryID
end 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Report_TAT_Casewise_Details_sub1]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Report_TAT_Casewise_Details_sub1]

 @EMAILBOXID varchar(10) = null, 



  @FROMDATE datetime = null,  



  @SUBPROCESSGROUPID varchar(10) = null,  



  @COUNTRYID Varchar(10) = null,              



  @TODATE datetime = null,


  @OFFSET varchar(30) = null,


  @CategoryID varchar(200)=null                



AS   





BEGIN   

--saranya

BEGIN

DECLARE @CHILDCASES TABLE



(



CASEID BIGINT,



PARENTCASEID BIGINT



)

DECLARE @CUSTOMERTAT TABLE  -- clarification needed to provided                         



(   



 CASEID BIGINT,     



 IDIFF BIGINT        



)  
DECLARE @CUSTAT TABLE  -- clarification needed to provided                         

(                          
 CASEID BIGINT,      
 IDIFF BIGINT          
)  
  DECLARE @EXCLUDEDTAT TABLE  -- clarification needed to provided                         



(                          



 CASEID BIGINT,  



 IDIFF BIGINT   



)  

DECLARE @QCCOMPLETED TABLE  



(  



 ROW BIGINT,  



 AUDITID BIGINT,    



 CASEID BIGINT,    



 TOCASESTATUSID INT,  



 ENDTIME DATETIME     



)     

DECLARE @PENDINGQC TABLE     



(      



 ROW BIGINT,        



 AUDITID BIGINT,       



 CASEID BIGINT,    



 TOCASESTATUSID INT,   



 ENDTIME DATETIME          



)  
DECLARE @ONHOLD Table



(



CASEID BIGINT,



DIFF BIGINT



)

DECLARE @QCTAT TABLE            



(            



 AAUDIT BIGINT,             



 ACASEID BIGINT,              



 ATOCASESTATUSID INT,             



 AENDTIME DATETIME,              



 AUDITID BIGINT,         



 CASEID BIGINT,       



 TOCASESTATUSID INT,       



 ENDTIME DATETIME,    



 DIFF INT,            



 DDIFF BIGINT     



) 
END
 
 --Saranya to display dynamic fields in reports
if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'ReportResults'
			   )
	begin
			drop table ReportResults
	end 

		declare @cols AS NVARCHAR(MAX)		
select @cols = STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) 
                    from dbo.Tbl_FieldConfiguration FC 					 							 
				where FC.Active='1' and FC.MailBoxID=@EMAILBOXID                 
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @cols

		declare @colsCreateTable as NVARCHAR(Max)
		declare @queryDBReportsResult as NVArchar(max)
select @colsCreateTable=STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) +' NVARCHAR(max)'
                    from dbo.Tbl_FieldConfiguration FC 
					left join  dbo.Tbl_ClientTransaction CT  on CT.FieldMasterId=FC.FieldMasterId
								 
				where FC.Active=1 and FC.MailBoxID= @EMAILBOXID 
                    group by FC.FieldName
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		set @queryDBReportsResult='Create table ReportResults(CaseId bigint,'+@colsCreateTable+')'
		 print @queryDBReportsResult
		 exec sp_executesql @queryDBReportsResult

		declare @queryDB  AS NVARCHAR(MAX)
set @queryDB = N'insert into ReportResults(CaseId,'+@cols+') SELECT CaseID,' + @cols + N' from 
             (
                
				select CaseID, FieldValue, FC.FieldName
                from dbo.Tbl_ClientTransaction CT 
				inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 				 
				where FC.MailBoxID='+CONVERT(VARCHAR(50),@EMAILBOXID)+' and FC.Active=''1''				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldName in (' + @cols + N')
            ) p '
print @queryDB 
 exec sp_executesql @queryDB
 --end of dynamic fields

SELECT 
	EM.CASEID,
	[dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET) as 'CREATEDDATE',
	(
		SELECT dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](MA1.ENDTIME,@OFFSET))	
		
		FROM EMAILAUDIT MA1  WITH (NOLOCK)

		WHERE MA1.FROMSTATUSID = 1   

		AND MA1.TOSTATUSID = 2

		AND MA1.CASEID=EM.CASEID

	) AS 'NEW - ASSIGNED', 

	
	(SELECT

	(SELECT SUM(dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 	

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)		

		WHERE TOSTATUSID=2 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)			

		WHERE FROMSTATUSID=2 AND TOSTATUSID=3 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -
		
	ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=2 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=11 AND TOSTATUSID=2 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)

	,0)) AS 'ASSIGNED - CLARIFICATION NEEDED', 

	(SELECT

	(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=2 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=2 AND TOSTATUSID=5 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -	

	ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=2 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=11 AND TOSTATUSID=2 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)

	,0)) AS 'ASSIGNED - PENDING FOR QC',

	(SELECT

	(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=4 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=4 AND TOSTATUSID=5 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -		

		ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=4 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=11 AND TOSTATUSID=4 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)

	,0)) AS 'CLARIFICATION RECEIVED - PENDING FOR QC', 

	(
		SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=7 AND CASEID=EM.CASEID) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=7 AND TOSTATUSID=10 AND CASEID=EM.CASEID) T2 ON T1.ROWID=T2.ROWID

	) AS 'QC ACCEPTED - COMPLETED',

	(

		SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=8 AND CASEID=EM.CASEID) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)
		
		WHERE FROMSTATUSID=8 AND TOSTATUSID=10 AND CASEID=EM.CASEID) T2 ON T1.ROWID=T2.ROWID

	) AS 'QC REJECTED - COMPLETED',

	(

		SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=8 AND CASEID=EM.CASEID) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=8 AND TOSTATUSID=5 AND CASEID=EM.CASEID) T2 ON T1.ROWID=T2.ROWID

	) AS 'QC REJECTED - PENDING FOR QC',

	(SELECT

	(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=2 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=2 AND TOSTATUSID=10 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -	

	ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=2 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=11 AND TOSTATUSID=2 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)

	,0)) AS 'ASSIGNED - COMPLETED', 

	(SELECT

	(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 
	
		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=4 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=4 AND TOSTATUSID=10 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -		

	ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 
	
		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=4 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=11 AND TOSTATUSID=4 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)

	,0))as 'CLARIFICATION RECEIVED - COMPLETED',

	--INCLUDE TOTAL ONHOLD SEPARATELY AS A NEW COLUMN

	(SELECT SUM(dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](AB.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](A.ENDTIME,@OFFSET)))'TOTMINS'

		FROM         

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT

		 WHERE CASEID=EM.CaseId AND TOSTATUSID IN (13)) AB   

		JOIN 

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT                          

		WHERE CASEID=EM.CaseId AND FROMSTATUSID IN (13)) A ON A.ROWID=AB.ROWID) as 'ON HOLD',    

	[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE',	

	EB.EMAILBOXNAME,

	SP.SUBPROCESSNAME,

	--C.COUNTRY,

	EM.EmailFrom,

	CAST(0 AS BIGINT) AS 'TOTAL TIME TAKEN BY CTS',

	'TAT NOT MET' AS 'SLA STATUS',

	EB.TATINSECONDS,

	ECC.Category,
	-- Pranay 18 JAN 2017 for adding Survey Comments and Survey Response
	--EM.SurveyResponse,
	--EM.SurveyComments
	SVD.VOC_Quality
	,SVD.VOC_Reason
	,SVD.VOC_TurnaroundTime
	,SVD.VOC_TAT_Reason
	,SVD.Comments

	INTO #FINAL

FROM EMAILMASTER EM
LEFT JOIN SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseId

LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

--LEFT JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID

LEFT JOIN SUBPROCESSGROUPS SP ON SP.SUBPROCESSGROUPID=EB.SUBPROCESSGROUPID

inner join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID

--inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON em.Categoryid= arr.Item

WHERE EM.STATUSID IN (10)

AND [dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) >= @FROMDATE AND (@TODATE IS NULL OR [dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) <= (@TODATE + 1))

AND ((@SUBPROCESSGROUPID IS NULL) OR (SP.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))

AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))

AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))

INSERT INTO @CHILDCASES   

  SELECT caseID,ParentCaseId 

  FROM EmailMaster 

  WHERE 

  ParentCaseId IN 

  (SELECT CASEID FROM #FINAL) 

  AND 

  StatusId=10 ;     

--SPLIT CLARIFICATION NEEDED AND PROVIDED -- get the interval from needed to provided - multiple times too, and multiple cases too

 INSERT INTO @CUSTAT 
 
  SELECT DISTINCT   

  O.CASEID  

  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](AB.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](A.ENDTIME,@OFFSET)))'TOTMINS' --interval between needed and provided  
  
    FROM          

  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I  --needed timestamp                         
  
   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (3)) AB   

  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           

    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (3)) A ON A.ROWID=AB.ROWID) 'MINS'        --provided timestamp                  
	
 FROM EMAILAUDIT O   

 WHERE   

 O.CASEID IN (SELECT CASEID FROM @CHILDCASES) AND TOSTATUSID IN (3)                          

 INSERT INTO @CUSTOMERTAT  

SELECT PARENTCASEID,SUM(CT.IDIFF)

FROM @CUSTAT CT

 JOIN

 (SELECT caseid,PARENTCASEID FROM @CHILDCASES )CHILD

 ON CT.CaseId=CHILD.CASEID GROUP BY CHILD.ParentCaseId;

	 -- SPLIT PENDING FOR QC DATA  --get end time for pending for QC 

   -- WITH PENDINGQC as

   INSERT INTO @PENDINGQC  

  SELECT   

   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  

   ,EMAILAUDITID  

   ,CASEID  

   ,TOSTATUSID  

   ,ENDTIME   

  FROM EMAILAUDIT (NOLOCK)  

  WHERE  

   TOSTATUSID IN (5)            

   AND CASEID IN (SELECT CASEID FROM @CHILDCASES) 

  -- SPLIT PENDING FOR QC DATA  --get end time for QC approved/rejected

  -- QCCOMPLETED   as

  INSERT INTO @QCCOMPLETED

  SELECT   

   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  

   ,EMAILAUDITID  

   ,CASEID  

   ,TOSTATUSID  

   ,ENDTIME   

  FROM EMAILAUDIT   

  WHERE             

   TOSTATUSID IN (7,8)            

   AND CASEID IN (SELECT CASEID FROM @CHILDCASES)

   --get difference between pending for QC and QC Approved/Rejected 

	INSERT INTO @QCTAT    

  SELECT   

   A.AUDITID 'AAUDIT'  

   ,A.CASEID 'ACASEID'  

   ,A.TOCASESTATUSID 'ATOCASESTATUSID'  

   ,A.ENDTIME 'AENDTIME'  

   ,B.AUDITID  

   ,B.CASEID  

   ,B.TOCASESTATUSID  

   ,B.ENDTIME  

   ,B.AUDITID-A.AUDITID 'DIFF'  

   ,DBO.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](A.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](B.ENDTIME,@OFFSET)) 'DDIFF'              

  FROM @PENDINGQC A             

  JOIN @QCCOMPLETED B ON A.CASEID = B.CASEID AND A.ROW=B.ROW             

  WHERE B.AUDITID-A.AUDITID  > 0 AND B.AUDITID IS NOT NULL             

INSERT INTO @EXCLUDEDTAT  

SELECT PARENTCASEID,SUM(DDIFF)

FROM @QCTAT QC

 JOIN

 (SELECT caseid,PARENTCASEID FROM @CHILDCASES )CHILD

 ON QC.CASEID=CHILD.CaseId GROUP BY ParentCaseId;   

--ON HOLD

 WITH ONHOLD as

 (SELECT DISTINCT   

  O.CASEID  

  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun(AB.ENDTIME,A.ENDTIME))'TOTMINS' --interval between needed and provided    

  FROM          

  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I  --on hold start time                         

   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (13)) AB   

  JOIN 

  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           

    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (13)) A ON A.ROWID=AB.ROWID) 'MINS'        --on hold end time                 

 FROM EMAILAUDIT O   

 WHERE   
 
 O.CASEID IN (SELECT CASEID FROM @CHILDCASES) AND TOSTATUSID IN (13)                          

 ) 

 INSERT INTO @ONHOLD  

SELECT PARENTCASEID,SUM(MINS)

FROM ONHOLD

 JOIN

 (SELECT caseid,PARENTCASEID FROM @CHILDCASES )CHILD

 ON ONHOLD.CaseId=CHILD.CASEID GROUP BY ParentCaseId;

UPDATE #FINAL SET [TOTAL TIME TAKEN BY CTS]=(ISNULL([NEW - ASSIGNED], 0)+ISNULL([ASSIGNED - CLARIFICATION NEEDED],0)+

ISNULL([ASSIGNED - PENDING FOR QC],0)+ISNULL([CLARIFICATION RECEIVED - PENDING FOR QC],0)+ISNULL([QC ACCEPTED - COMPLETED],0)+

ISNULL([QC REJECTED - PENDING FOR QC],0)+ISNULL([QC REJECTED - COMPLETED],0)+ISNULL([ASSIGNED - COMPLETED],0)+ISNULL([CLARIFICATION RECEIVED - COMPLETED],0) )

UPDATE F SET F.[TOTAL TIME TAKEN BY CTS]=F.[TOTAL TIME TAKEN BY CTS]-(ISNULL(CT.IDIFF,0)+ISNULL(ET.IDIFF,0)+ISnUll(OH.DIFF,0))

from #FINAL F 

LEFT JOIN @CUSTOMERTAT CT ON F.CaseId=CT.CASEID

LEFT JOIN @EXCLUDEDTAT ET ON F.CaseId=ET.CASEID

LEFT JOIN @ONHOLD OH ON F.CaseId=OH.CASEID;

--Update Onhold of parent to include on hold of child

UPDATE F SET F.[ON HOLD]=F.[ON HOLD]+(ISnUll(OH.DIFF,0))

from #FINAL F 

LEFT JOIN @ONHOLD OH ON F.CaseId=OH.CASEID;

UPDATE #FINAL SET [SLA STATUS] = CASE WHEN [TOTAL TIME TAKEN BY CTS]<TATINSECONDS THEN 'SLA MET' WHEN ([TOTAL TIME TAKEN BY CTS] =0 OR TATINSECONDS =0) THEN 'NA' WHEN 

TATInSeconds =00 THEN 'NA' WHEN TATInSeconds =00 THEN 'NA'

 ELSE 'SLA NOT MET' END


EXEC('SELECT FIN.CASEID

	,EMailFrom AS SENDER

	,SUBPROCESSNAME AS PROCESS

	,EMAILBOXNAME AS EMAILBOX

	,CONVERT(VARCHAR, CREATEDDATE, 103)+'' ''+CONVERT(VARCHAR, CREATEDDATE, 108) AS CREATEDDATE

	,ISNULL(DBO.FN_TIMEFORMAT([NEW - ASSIGNED]),''00:00:00'') AS [NEW - ASSIGNED]
	
	,ISNULL(DBO.FN_TIMEFORMAT([ASSIGNED - CLARIFICATION NEEDED]),''00:00:00'') AS [ASSIGNED - CLARIFICATION NEEDED]	

	,ISNULL(DBO.FN_TIMEFORMAT([ASSIGNED - PENDING FOR QC]),''00:00:00'') AS [ASSIGNED - PENDING FOR QC]

	,ISNULL(DBO.FN_TIMEFORMAT([CLARIFICATION RECEIVED - PENDING FOR QC]),''00:00:00'') AS [CLARIFICATION RECEIVED - PENDING FOR QC]

	,ISNULL(DBO.FN_TIMEFORMAT([QC ACCEPTED - COMPLETED]),''00:00:00'') AS [QC ACCEPTED - COMPLETED]

	,ISNULL(DBO.FN_TIMEFORMAT([QC REJECTED - COMPLETED]),''00:00:00'') AS [QC REJECTED - COMPLETED]

	,ISNULL(DBO.FN_TIMEFORMAT([QC REJECTED - PENDING FOR QC]),''00:00:00'') AS [QC REJECTED - PENDING FOR QC]

	,ISNULL(DBO.FN_TIMEFORMAT([ASSIGNED - COMPLETED]),''00:00:00'') AS [ASSIGNED - COMPLETED]

	,ISNULL(DBO.FN_TIMEFORMAT([CLARIFICATION RECEIVED - COMPLETED]),''00:00:00'') AS [CLARIFICATION RECEIVED - COMPLETED]

	,ISNULL(DBO.fn_TimeFormat([ON HOLD]),''00:00:00'') AS [ON HOLD]

	--,CONVERT(VARCHAR, COMPLETEDDATE, 103)+'' ''+CONVERT(VARCHAR, COMPLETEDDATE, 108) AS COMPLETEDDATE

	,COMPLETEDDATE
	
	,ISNULL(DBO.FN_TIMEFORMAT([TOTAL TIME TAKEN BY CTS]),''00:00:00'') AS [TOTAL TIME TAKEN BY CTS]

	,[SLA STATUS], Category,'+@cols+'

	 FROM #FINAL FIN
	 left join ReportResults RR on FIN.CaseId=RR.CaseId')

DROP TABLE #FINAL

END
GO
/****** Object:  StoredProcedure [dbo].[USP_Report_TAT_Casewise_Details_sub2]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Report_TAT_Casewise_Details_sub2]

 @EMAILBOXID varchar(10) = null, 

  @FROMDATE datetime = null,  

  @SUBPROCESSGROUPID varchar(10) = null,  

  @COUNTRYID Varchar(10) = null,          

  @TODATE datetime = null,

  @OFFSET varchar(30) = null,

  @CategoryID varchar(200)=null                

AS   

BEGIN

--saranya

BEGIN

DECLARE @CHILDCASES TABLE

(

CASEID BIGINT,

PARENTCASEID BIGINT

)











DECLARE @CUSTOMERTAT TABLE  -- clarification needed to provided                         



(   



 CASEID BIGINT,     



 IDIFF BIGINT        



)  







DECLARE @CUSTAT TABLE  -- clarification needed to provided                         



(                          



 CASEID BIGINT,      



 IDIFF BIGINT          



)  







  DECLARE @EXCLUDEDTAT TABLE  -- clarification needed to provided                         



(                          



 CASEID BIGINT,  



 IDIFF BIGINT   



)  







DECLARE @QCCOMPLETED TABLE  



(  



 ROW BIGINT,  



 AUDITID BIGINT,    



 CASEID BIGINT,    



 TOCASESTATUSID INT,  



 ENDTIME DATETIME     



)     







DECLARE @PENDINGQC TABLE     



(      



 ROW BIGINT,        



 AUDITID BIGINT,       



 CASEID BIGINT,    



 TOCASESTATUSID INT,   



 ENDTIME DATETIME          



)  







DECLARE @ONHOLD Table



(



CASEID BIGINT,



DIFF BIGINT



)







DECLARE @QCTAT TABLE            



(            



 AAUDIT BIGINT,             



 ACASEID BIGINT,              



 ATOCASESTATUSID INT,             



 AENDTIME DATETIME,              



 AUDITID BIGINT,         



 CASEID BIGINT,       



 TOCASESTATUSID INT,       



 ENDTIME DATETIME,    



 DIFF INT,            



 DDIFF BIGINT     



) 







END

 
 if exists (select 'x'
			   from sys.objects (nolock)
			   where type  = 'u'
			   and name  = 'ReportResults'
			   )
	begin
			drop table ReportResults
	end 

		declare @cols AS NVARCHAR(MAX)		
select @cols = STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) 
                    from dbo.Tbl_FieldConfiguration FC 					 							 
				where FC.Active='1' and FC.MailBoxID=@EMAILBOXID                 
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		print @cols

		declare @colsCreateTable as NVARCHAR(Max)
		declare @queryDBReportsResult as NVArchar(max)
select @colsCreateTable=STUFF((SELECT  ',' + QUOTENAME(FC.FieldName) +' NVARCHAR(max)'
                    from dbo.Tbl_FieldConfiguration FC 
					left join  dbo.Tbl_ClientTransaction CT  on CT.FieldMasterId=FC.FieldMasterId
								 
				where FC.Active=1 and FC.MailBoxID= @EMAILBOXID 
                    group by FC.FieldName
                    
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

		set @queryDBReportsResult='Create table ReportResults(CaseId bigint,'+@colsCreateTable+')'
		 print @queryDBReportsResult
		 exec sp_executesql @queryDBReportsResult

		declare @queryDB  AS NVARCHAR(MAX)
set @queryDB = N'insert into ReportResults(CaseId,'+@cols+') SELECT CaseID,' + @cols + N' from 
             (
                
				select CaseID, FieldValue, FC.FieldName
                from dbo.Tbl_ClientTransaction CT 
				inner join dbo.Tbl_FieldConfiguration FC on CT.FieldMasterId=FC.FieldMasterId 				 
				where FC.MailBoxID='+CONVERT(VARCHAR(50),@EMAILBOXID)+' and FC.Active=''1''				
            ) x
            pivot 
            (
                max(FieldValue)
                for FieldName in (' + @cols + N')
            ) p '
print @queryDB 
 exec sp_executesql @queryDB
  

SELECT 

	EM.CASEID,

	EM.CREATEDDATE,

	(

		SELECT dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](EM.CREATEDDATE,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](MA1.ENDTIME,@OFFSET))			
		
		FROM EMAILAUDIT MA1 

		WHERE MA1.FROMSTATUSID = 1   

		AND MA1.TOSTATUSID = 2

		AND MA1.CASEID=EM.CASEID

	) AS 'NEW - ASSIGNED', 



	(SELECT

	(SELECT SUM(dbo.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 	
	
		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=2 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)
		
		WHERE FROMSTATUSID=2 AND TOSTATUSID=3 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -		

	ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 
	
		FROM
		
		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=2 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)
		
		WHERE FROMSTATUSID=11 AND TOSTATUSID=2 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)

	,0)) AS 'ASSIGNED - CLARIFICATION NEEDED', 

	(SELECT

	(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)
		
		WHERE TOSTATUSID=2 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)
		
		WHERE FROMSTATUSID=2 AND TOSTATUSID=5 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -	

	ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 
	
		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=2 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=11 AND TOSTATUSID=2 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)

	,0)) AS 'ASSIGNED - PENDING FOR QC',

	(SELECT

	(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=4 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=4 AND TOSTATUSID=5 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -		

		ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=4 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=11 AND TOSTATUSID=4 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)

	,0)) AS 'CLARIFICATION RECEIVED - PENDING FOR QC', 

	(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=7 AND CASEID=EM.CASEID) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=7 AND TOSTATUSID=10 AND CASEID=EM.CASEID) T2 ON T1.ROWID=T2.ROWID

	) AS 'QC ACCEPTED - COMPLETED',

	(
		SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=8 AND CASEID=EM.CASEID) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=8 AND TOSTATUSID=10 AND CASEID=EM.CASEID) T2 ON T1.ROWID=T2.ROWID

	) AS 'QC REJECTED - COMPLETED',

	(

		SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=8 AND CASEID=EM.CASEID) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=8 AND TOSTATUSID=5 AND CASEID=EM.CASEID) T2 ON T1.ROWID=T2.ROWID

	) AS 'QC REJECTED - PENDING FOR QC',

	(SELECT

	(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=2 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=2 AND TOSTATUSID=10 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -	

	ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 

		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=2 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=11 AND TOSTATUSID=2 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)
		
	,0)) AS 'ASSIGNED - COMPLETED', 

	(SELECT

	(SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'TOTMINS' 
	
		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE TOSTATUSID=4 AND CASEID=EM.CaseId) AS T1
		
		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=4 AND TOSTATUSID=10 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID) -		

	ISNULL((SELECT SUM(DBO.FN_TAT_EXCLUDECUTOFFTIMESatSun([dbo].[ChangeDatesAsPerUserTimeZone](T1.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](T2.ENDTIME,@OFFSET)))'ONHOLDMINS' 
	
		FROM

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID ) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=4 and TOSTATUSID=13 AND CASEID=EM.CaseId) AS T1

		JOIN

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) AS 'ROWID',ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		WHERE FROMSTATUSID=11 AND TOSTATUSID=4 AND CASEID=EM.CaseId) T2 ON T1.ROWID=T2.ROWID)

	,0))as 'CLARIFICATION RECEIVED - COMPLETED',

	--INCLUDE TOTAL ONHOLD SEPARATELY AS A NEW COLUMN

	(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](AB.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](A.ENDTIME,@OFFSET)))'TOTMINS'     
	
		FROM         

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT WITH (NOLOCK)

		 WHERE CASEID=EM.CaseId AND TOSTATUSID IN (13)) AB   

		JOIN 

		(SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT WITH (NOLOCK)                  
		
		WHERE CASEID=EM.CaseId AND FROMSTATUSID IN (13)) A ON A.ROWID=AB.ROWID) as 'ON HOLD',    

	[dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET)as 'COMPLETEDDATE',

	EB.EMAILBOXNAME,

	SP.SUBPROCESSNAME,

	--C.COUNTRY,

	EM.EmailFrom,

	CAST(0 AS BIGINT) AS 'TOTAL TIME TAKEN BY CTS',

	'TAT NOT MET' AS 'SLA STATUS',

	EB.TATINSECONDS,

	ECC.Category,
	-- Pranay 18 JAN 2017 for adding Survey Comments and Survey Response
	--EM.SurveyResponse,
	--EM.SurveyComments
	SVD.VOC_Quality
	,SVD.VOC_Reason
	,SVD.VOC_TurnaroundTime
	,SVD.VOC_TAT_Reason
	,SVD.Comments

	INTO #FINAL

FROM EMAILMASTER EM


LEFT JOIN SurveyVOC_Details SVD ON EM.CaseId=SVD.CaseId

LEFT JOIN EMAILBOX EB ON EM.EMAILBOXID=EB.EMAILBOXID

--LEFT JOIN COUNTRY C ON C.COUNTRYID=EB.COUNTRYID

LEFT JOIN SUBPROCESSGROUPS SP ON SP.SUBPROCESSGROUPID=EB.SUBPROCESSGROUPID

inner join EmailboxCategoryConfig ECC on ECC.EmailboxCategoryId=EM.CategoryID

inner join dbo.ConvertDelimitedListIntoTable(@CategoryID,',') arr ON em.Categoryid= arr.Item

WHERE EM.STATUSID IN (10)

AND [dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) >= @FROMDATE AND (@TODATE IS NULL OR [dbo].[ChangeDatesAsPerUserTimeZone](EM.COMPLETEDDATE,@OFFSET) <= (@TODATE + 1))

AND ((@SUBPROCESSGROUPID IS NULL) OR (SP.SUBPROCESSGROUPID=@SUBPROCESSGROUPID))

AND ((@COUNTRYID IS NULL) OR (EB.COUNTRYID=@COUNTRYID))

AND ((@EMAILBOXID IS NULL) OR (EM.EMAILBOXID=@EMAILBOXID))

INSERT INTO @CHILDCASES   

  SELECT caseID,ParentCaseId 

  FROM EmailMaster 

  WHERE 

  ParentCaseId IN 

  (SELECT CASEID FROM #FINAL) 

  AND 

  StatusId=10 ;     

--SPLIT CLARIFICATION NEEDED AND PROVIDED -- get the interval from needed to provided - multiple times too, and multiple cases too

 INSERT INTO @CUSTAT 

 SELECT DISTINCT   

  O.CASEID  

  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](AB.EndTime,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](A.EndTime,@OFFSET)))'TOTMINS' --interval between needed and provided  

  FROM          

  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I  --needed timestamp                         

   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (3)) AB   

  JOIN (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           

    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (3)) A ON A.ROWID=AB.ROWID) 'MINS'        --provided timestamp                  

 FROM EMAILAUDIT O   

 WHERE   

 O.CASEID IN (SELECT CASEID FROM @CHILDCASES) AND TOSTATUSID IN (3)                          

 INSERT INTO @CUSTOMERTAT  

SELECT PARENTCASEID,SUM(CT.IDIFF)

FROM @CUSTAT CT

 JOIN

 (SELECT caseid,PARENTCASEID FROM @CHILDCASES )CHILD

 ON CT.CaseId=CHILD.CASEID GROUP BY CHILD.ParentCaseId;

	 -- SPLIT PENDING FOR QC DATA  --get end time for pending for QC 

   -- WITH PENDINGQC as

   INSERT INTO @PENDINGQC  

  SELECT   

   ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  

   ,EMAILAUDITID  

   ,CASEID  

   ,TOSTATUSID  

   ,ENDTIME   

  FROM EMAILAUDIT (NOLOCK)  

  WHERE  

   TOSTATUSID IN (5)            

   AND CASEID IN (SELECT CASEID FROM @CHILDCASES) 

  -- SPLIT PENDING FOR QC DATA  --get end time for QC approved/rejected

  -- QCCOMPLETED   as

  INSERT INTO @QCCOMPLETED

  SELECT   

  ROW_NUMBER() OVER(ORDER BY CASEID,EMAILAUDITID ASC) AS ROW  

   ,EMAILAUDITID  

   ,CASEID  

   ,TOSTATUSID  

   ,ENDTIME   

  FROM EMAILAUDIT   

  WHERE                

   TOSTATUSID IN (7,8)            

   AND CASEID IN (SELECT CASEID FROM @CHILDCASES)

   --get difference between pending for QC and QC Approved/Rejected 

	INSERT INTO @QCTAT    

  SELECT   

   A.AUDITID 'AAUDIT'  

   ,A.CASEID 'ACASEID'  

   ,A.TOCASESTATUSID 'ATOCASESTATUSID'  

   ,A.ENDTIME 'AENDTIME'  

   ,B.AUDITID  

   ,B.CASEID  

   ,B.TOCASESTATUSID  

   ,B.ENDTIME  

   ,B.AUDITID-A.AUDITID 'DIFF'  

   ,DBO.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](A.ENDTIME,@OFFSET), [dbo].[ChangeDatesAsPerUserTimeZone](B.ENDTIME,@OFFSET)) 'DDIFF'              

  FROM @PENDINGQC A             

  JOIN @QCCOMPLETED B ON A.CASEID = B.CASEID AND A.ROW=B.ROW             

  WHERE B.AUDITID-A.AUDITID  > 0 AND B.AUDITID IS NOT NULL             

INSERT INTO @EXCLUDEDTAT  

SELECT PARENTCASEID,SUM(DDIFF)

FROM @QCTAT QC

 JOIN

 (SELECT caseid,PARENTCASEID FROM @CHILDCASES )CHILD

 ON QC.CASEID=CHILD.CaseId GROUP BY ParentCaseId;   

--ON HOLD

 WITH ONHOLD as

 (SELECT DISTINCT   

  O.CASEID  

  ,(SELECT SUM(DBO.fn_TAT_ExcludeCutOffTimeSatSun([dbo].[ChangeDatesAsPerUserTimeZone](AB.ENDTIME,@OFFSET),[dbo].[ChangeDatesAsPerUserTimeZone](A.ENDTIME,@OFFSET)))'TOTMINS' --interval between needed and provided    

  FROM          

  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I  --on hold start time                         

   WHERE I.CASEID=O.CASEID AND I.TOSTATUSID IN (13)) AB   

  JOIN 

  (SELECT ROW_NUMBER() OVER (ORDER BY EMAILAUDITID) 'ROWID', ENDTIME FROM EMAILAUDIT I                           

    WHERE I.CASEID=O.CASEID AND I.FROMSTATUSID IN (13)) A ON A.ROWID=AB.ROWID) 'MINS'        --on hold end time                 

 FROM EMAILAUDIT O   

 WHERE   

 O.CASEID IN (SELECT CASEID FROM @CHILDCASES) AND TOSTATUSID IN (13)                          

 ) 

 INSERT INTO @ONHOLD  

SELECT PARENTCASEID,SUM(MINS)

FROM ONHOLD

 JOIN

 (SELECT caseid,PARENTCASEID FROM @CHILDCASES )CHILD

 ON ONHOLD.CaseId=CHILD.CASEID GROUP BY ParentCaseId;

UPDATE #FINAL SET [TOTAL TIME TAKEN BY CTS]=(ISNULL([NEW - ASSIGNED], 0)+ISNULL([ASSIGNED - CLARIFICATION NEEDED],0)+

ISNULL([ASSIGNED - PENDING FOR QC],0)+ISNULL([CLARIFICATION RECEIVED - PENDING FOR QC],0)+ISNULL([QC ACCEPTED - COMPLETED],0)+

ISNULL([QC REJECTED - PENDING FOR QC],0)+ISNULL([QC REJECTED - COMPLETED],0)+ISNULL([ASSIGNED - COMPLETED],0)+ISNULL([CLARIFICATION RECEIVED - COMPLETED],0) )

UPDATE F SET F.[TOTAL TIME TAKEN BY CTS]=F.[TOTAL TIME TAKEN BY CTS]-(ISNULL(CT.IDIFF,0)+ISNULL(ET.IDIFF,0)+ISnUll(OH.DIFF,0))

from #FINAL F 

LEFT JOIN @CUSTOMERTAT CT ON F.CaseId=CT.CASEID

LEFT JOIN @EXCLUDEDTAT ET ON F.CaseId=ET.CASEID

LEFT JOIN @ONHOLD OH ON F.CaseId=OH.CASEID;

--Update Onhold of parent to include on hold of child

UPDATE F SET F.[ON HOLD]=F.[ON HOLD]+(ISnUll(OH.DIFF,0))

from #FINAL F 

LEFT JOIN @ONHOLD OH ON F.CaseId=OH.CASEID;

UPDATE #FINAL SET [SLA STATUS] = CASE WHEN [TOTAL TIME TAKEN BY CTS]<TATINSECONDS THEN 'SLA MET' WHEN ([TOTAL TIME TAKEN BY CTS] =0 OR TATINSECONDS =0) THEN 'NA' WHEN 

TATInSeconds =00 THEN 'NA' WHEN TATInSeconds =00 THEN 'NA'

 ELSE 'SLA NOT MET' END

EXEC('SELECT CASEID

	,EMailFrom AS SENDER

	,SUBPROCESSNAME AS PROCESS

	,EMAILBOXNAME AS EMAILBOX

	,CONVERT(VARCHAR, CREATEDDATE, 103)+'' ''+CONVERT(VARCHAR, CREATEDDATE, 108) AS CREATEDDATE

	,ISNULL(DBO.FN_TIMEFORMAT([NEW - ASSIGNED]),''00:00:00'') AS [NEW - ASSIGNED]

	,ISNULL(DBO.FN_TIMEFORMAT([ASSIGNED - CLARIFICATION NEEDED]),''00:00:00'') AS [ASSIGNED - CLARIFICATION NEEDED]	

	,ISNULL(DBO.FN_TIMEFORMAT([ASSIGNED - PENDING FOR QC]),''00:00:00'') AS [ASSIGNED - PENDING FOR QC]

	,ISNULL(DBO.FN_TIMEFORMAT([CLARIFICATION RECEIVED - PENDING FOR QC]),''00:00:00'') AS [CLARIFICATION RECEIVED - PENDING FOR QC]

	,ISNULL(DBO.FN_TIMEFORMAT([QC ACCEPTED - COMPLETED]),''00:00:00'') AS [QC ACCEPTED - COMPLETED]

	,ISNULL(DBO.FN_TIMEFORMAT([QC REJECTED - COMPLETED]),''00:00:00'') AS [QC REJECTED - COMPLETED]

	,ISNULL(DBO.FN_TIMEFORMAT([QC REJECTED - PENDING FOR QC]),''00:00:00'') AS [QC REJECTED - PENDING FOR QC]

	,ISNULL(DBO.FN_TIMEFORMAT([ASSIGNED - COMPLETED]),''00:00:00'') AS [ASSIGNED - COMPLETED]

	,ISNULL(DBO.FN_TIMEFORMAT([CLARIFICATION RECEIVED - COMPLETED]),''00:00:00'') AS [CLARIFICATION RECEIVED - COMPLETED]

	,ISNULL(DBO.fn_TimeFormat([ON HOLD]),''00:00:00'') AS [ON HOLD]

	,COMPLETEDDATE

	,ISNULL(DBO.FN_TIMEFORMAT([TOTAL TIME TAKEN BY CTS]),''00:00:00'') AS [TOTAL TIME TAKEN BY CTS]

	,[SLA STATUS], Category,'+@cols+'

	 FROM #FINAL FIN

	 left join ReportResults RR on FIN.CaseId=RR.CaseId')

DROP TABLE #FINAL

END
GO
/****** Object:  StoredProcedure [dbo].[USP_ReportSubscriptionUsers]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[USP_ReportSubscriptionUsers]

as 

begin



--select distinct Userid, SubscriptionStatus,subject  from MailerSubscription group by Userid,subject order by 1 desc 



--select ms.* from MailerSubscription ms inner join 

--(select max(id) maxid, UserID from MailerSubscription group by userid) t1 

--on ms.id=t1.maxid order by ms.SubscriptionStatus


select RSU.* from [dbo].[ReportSubscriptionUsers] RSU inner join 

(select max(id) maxid, UserID, subject,Interval from [ReportSubscriptionUsers] group by userid, subject,Interval ) t1 

on RSU.id=t1.maxid and RSU.SubscriptionStatus='Subscribe'  order by RSU.SubscriptionStatus


end 



GO
/****** Object:  StoredProcedure [dbo].[USP_SAVECaseOnEscalationMailTrigger]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_SAVECaseOnEscalationMailTrigger]
@CaseId bigint, 
@MasterId int
as 
BEGIN 

Insert into SLABreachNotificationsTransaction values (@CaseId,getdate(),@MasterId)

END
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_FROMSTATUS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[USP_SELECT_FROMSTATUS]             
@Mailboxid int,
@Fromstatus int
AS           
BEGIN            
 SET NOCOUNT ON;  
 declare @SubProcessId nvarchar(250)
 set @SubProcessId=(select SubProcessGroupId from EMailBox where EMailBoxId=@Mailboxid)

 if(@Fromstatus=1)
	 begin
		 if exists(select * from Status where SubProcessID=@SubProcessId)
		 begin
			select StatusId,StatusDescription from Status where SubProcessID=@SubProcessId and IsFinalStatus<>1 and ShownInUI=1
		 end
		 else
		 begin
			select StatusId,StatusDescription from Status where SubProcessID is null and IsFinalStatus<>1 and ShownInUI=1
		 end
	 end
 else
	 begin
		 if exists(select * from Status where SubProcessID=@SubProcessId)
		 begin
			select StatusId,StatusDescription from Status where SubProcessID=@SubProcessId and IsInitalStatus<>1 and ShownInUI=1
		 end
		 else
		 begin
			select StatusId,StatusDescription from Status where SubProcessID is null and IsInitalStatus<>1 and ShownInUI=1
		 end
	 end
END 








--select Distinct S.StatusID,S.StatusDescription from [Status] S
--		left outer join  StatusTransisitionMaster ST on S.StatusId=ST.FromStatusID
--		inner join EmailboxRemainderConfig ERC on S.StatusId!=ERC.FromStatus and ERC.FromStatus=ST.FromStatusID

--select * from  StatusTransisitionMaster where FromStatusID=3

--Select * from EmailboxRemainderConfig 


GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MAILBOXMAPPED_ACKNOWLEDGE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Pranay Ahuja>
-- Create date: < 8/15/2016>
-- Description:	<To select the mapped MAILBOx to Acknowledge>
-- =============================================
CREATE PROCEDURE [dbo].[USP_SELECT_MAILBOXMAPPED_ACKNOWLEDGE]
@Country int,    
@Mailboxid int
AS
BEGIN
	SET NOCOUNT ON;   
IF @Country = 0 and @Mailboxid =0
	BEGIN
		SELECT  ER.EmailboxremainId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,ER.Template,
		EB.EMailBoxAddress, ER.Frequency,ER.Count , ER.FromStatus,ER.ToStatus,ER.EscalationMailId,           
		case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation, 
		case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),ER.ModifiedDate,103) 
		ER.ModifiedDate as ModifiedDate  		
		from [dbo].[EmailboxRemainderConfig] ER 
		left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
		left outer join country Cy on Cy.CountryId=ER.CountryId           
		left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
		where Cy.IsActive=1 and EB.IsActive=1 and ER.TemplateType=2 order by ER.EmailboxremainId asc  
	END
ELSE IF @Country <> 0 and @Mailboxid = 0
	BEGIN
		SELECT  ER.EmailboxremainId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,ER.Template,EB.EMailBoxAddress,
		ER.Frequency,ER.Count , ER.FromStatus,ER.ToStatus,ER.EscalationMailId,               
		case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation,
		case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,                 
		UM.FirstName +' '+ UM.LastName as ModifiedById,-- Convert(Varchar(10),ER.ModifiedDate,103) 
		ER.ModifiedDate as ModifiedDate    
		from [dbo].[EmailboxRemainderConfig] ER 
		left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
		left outer join country Cy on Cy.CountryId=ER.CountryId           
		left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
		where Cy.IsActive=1 and EB.IsActive=1 and ER.TemplateType=2 order by ER.EmailboxremainId asc    
	END
ELSE IF ((@Country = 0 and @Mailboxid <> 0) or (@Country<>0 and @Mailboxid<>0))
	BEGIN
	SELECT  ER.EmailboxremainId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,ER.Template,EB.EMailBoxAddress,
	ER.Frequency,ER.Count , ER.FromStatus,ER.ToStatus,ER.EscalationMailId,               
	case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation, 
	case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,                
	UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),ER.ModifiedDate,103) as ModifiedDate 
	ER.ModifiedDate as ModifiedDate  
	   from [dbo].[EmailboxRemainderConfig] ER	
	left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
	left outer join country Cy on Cy.CountryId=ER.CountryId           
	left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
	where Cy.IsActive=1 and EB.IsActive=1 and eb.EMailBoxId=@Mailboxid and ER.TemplateType=2 order by ER.EmailboxremainId asc    
	END

END
GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MAILBOXMAPPED_CATEGORY]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec USP_SELECT_MAILBOXMAPPED_REMAINDER 4,0
-- ======================================================          
-- Author:  Ranjith           
-- Create date: 05/19/2015               
-- Description: To select the mapped MAILBOx to country for category config page
-- ======================================================          
CREATE PROCEDURE [dbo].[USP_SELECT_MAILBOXMAPPED_CATEGORY]          
@Country int,    
@Mailboxid int
AS          
BEGIN   
SET NOCOUNT ON;   
IF @Country = 0 and @Mailboxid =0
BEGIN
		SELECT  EC.EmailboxCategoryId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress, 
		EC.Category, case when EC.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),EC.ModifiedDate,103) as ModifiedDate              
		EC.ModifiedDate as ModifiedDate
			from [dbo].[EmailboxCategoryConfig] EC 
				left outer join [EMailBox] EB on EB.EMailBoxId = EC.EmailboxId
				left outer join country Cy on Cy.CountryId=EC.CountryId           
				left outer join Usermaster UM on UM.UserId=EC.ModifiedbyId  
			where Cy.IsActive=1 and EB.IsActive=1  order by EC.EmailboxCategoryId asc  
END
ELSE IF @Country <> 0 and @Mailboxid = 0
BEGIN
		SELECT  EC.EmailboxCategoryId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress, 
		EC.Category, case when EC.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),EC.ModifiedDate,103) as ModifiedDate              
		EC.ModifiedDate as ModifiedDate
			from [dbo].[EmailboxCategoryConfig] EC 
				left outer join [EMailBox] EB on EB.EMailBoxId = EC.EmailboxId
				left outer join country Cy on Cy.CountryId=EC.CountryId           
				left outer join Usermaster UM on UM.UserId=EC.ModifiedbyId  
			where Cy.IsActive=1  and cy.CountryId=@Country and EB.IsActive=1 order by EC.EmailboxCategoryId asc    
END
ELSE IF @Country = 0 and @Mailboxid <> 0
BEGIN
		SELECT  EC.EmailboxCategoryId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress, 
		EC.Category, case when EC.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById,-- Convert(Varchar(10),EC.ModifiedDate,103) as ModifiedDate              
		EC.ModifiedDate as ModifiedDate
				from [dbo].[EmailboxCategoryConfig] EC 
					left outer join [EMailBox] EB on EB.EMailBoxId = EC.EmailboxId
					left outer join country Cy on Cy.CountryId=EC.CountryId           
					left outer join Usermaster UM on UM.UserId=EC.ModifiedbyId  
				where Cy.IsActive=1  and eb.EMailBoxId=@Mailboxid and EB.IsActive=1  order by EC.EmailboxCategoryId asc    
END
ELSE IF @Country <> 0 and @Mailboxid <> 0
BEGIN
		SELECT  EC.EmailboxCategoryId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress, 
		EC.Category, case when EC.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById,-- Convert(Varchar(10),EC.ModifiedDate,103) as ModifiedDate              
		EC.ModifiedDate as ModifiedDate
				from [dbo].[EmailboxCategoryConfig] EC 
					left outer join [EMailBox] EB on EB.EMailBoxId = EC.EmailboxId
					left outer join country Cy on Cy.CountryId=EC.CountryId           
					left outer join Usermaster UM on UM.UserId=EC.ModifiedbyId  
				where Cy.IsActive=1  and eb.EMailBoxId=@Mailboxid and cy.CountryId=@Country and EB.IsActive=1  order by EC.EmailboxCategoryId asc    
END
END            






GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MAILBOXMAPPED_country]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================          

-- Author:  Ranjith           

-- Create date: 04/27/2015               

-- Description: To select the mapped MAILBOx to country

-- ======================================================          

CREATE PROCEDURE [dbo].[USP_SELECT_MAILBOXMAPPED_country]          



@Country int,    



@Mailboxid int



AS          



BEGIN   



SET NOCOUNT ON;   



IF @Country = 0 and @Mailboxid =0

BEGIN

SELECT  ER.EmailboxremainId, cy.Country ,EB.EMailBoxAddress, 

ER.Frequency,ER.Count ,            

case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation,           

UM.FirstName +' '+ UM.LastName as ModifiedById, Convert(Varchar(10),ER.ModifiedDate,103) as ModifiedDate              

from [dbo].[EmailboxRemainderConfig] ER 

left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId

left outer join country Cy on Cy.CountryId=ER.CountryId           

left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  

where Cy.IsActive=1 and EB.IsActive=1 and EB.IsLocked=0 order by ER.EmailboxremainId asc  

END

ELSE IF @Country <> 0 and @Mailboxid = 0

BEGIN

SELECT  ER.EmailboxremainId, cy.Country ,EB.EMailBoxAddress,

ER.Frequency,ER.Count ,            

case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation,           

UM.FirstName +' '+ UM.LastName as ModifiedById, Convert(Varchar(10),ER.ModifiedDate,103) as ModifiedDate              

from [dbo].[EmailboxRemainderConfig] ER 

left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId

left outer join country Cy on Cy.CountryId=ER.CountryId           

left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  

where Cy.IsActive=1 and EB.IsActive=1 and EB.IsLocked=0 and cy.CountryId=@Country  order by ER.EmailboxremainId asc    

END

ELSE IF @Country = 0 and @Mailboxid <> 0

BEGIN

SELECT  ER.EmailboxremainId, cy.Country ,EB.EMailBoxAddress,

ER.Frequency,ER.Count ,            

case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation,           

UM.FirstName +' '+ UM.LastName as ModifiedById, Convert(Varchar(10),ER.ModifiedDate,103) as ModifiedDate              

from [dbo].[EmailboxRemainderConfig] ER 

left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId

left outer join country Cy on Cy.CountryId=ER.CountryId           

left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  

where Cy.IsActive=1 and EB.IsActive=1 and EB.IsLocked=0 and eb.EMailBoxId=@Mailboxid  order by ER.EmailboxremainId asc    

END



       



       







END            







          







GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MAILBOXMAPPED_FIELDS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- exec USP_SELECT_MAILBOXMAPPED_REMAINDER 4,0



-- ======================================================          



-- Author:  Ranjith           



-- Create date: 05/19/2015               



-- Description: To select the mapped MAILBOx to country for category config page



-- ======================================================          

CREATE PROCEDURE [dbo].[USP_SELECT_MAILBOXMAPPED_FIELDS]          



@Country int,    

@Mailboxid int



AS          

BEGIN   



SET NOCOUNT ON;   



IF @Country = 0 and @Mailboxid =0

BEGIN



SELECT MFT.FieldTypeId,MFDT.FieldDataTypeId,MVT.ValidationTypeId,

fc.CountryID,fc.MailBoxID,cy.Country,eb.EMailBoxName,FC.FieldMasterId,FC.FieldName ,MFT.FieldTypeAlias,MFT.FieldType,

CASE when FC.TextLength=0 then NULL else FC.TextLength end as TextLength ,MFDT.FieldDataTypeAlias,

MVT.ValidationType,FC.DefaultValue,case when FC.Active=0 then 'No' else 'Yes' end Active, UM.FirstName +' '+ UM.LastName as ModifiedBy,FC.ModifiedDate ,FC.FieldAliasName,case when FC.FieldPrivilegeID=1 then 'Yes' else 'No' end Mandatory



from [dbo].[Tbl_FieldConfiguration] FC 



left outer join [EMailBox] EB on EB.EMailBoxId = FC.MailBoxID



left outer join country Cy on Cy.CountryId=FC.CountryId 



left outer join Tbl_Master_FieldType MFT on MFT.FieldTypeId=FC.FieldTypeId   and mft.Active =1



left outer join [dbo].[Tbl_Master_FieldDataType] MFDT on MFDT.FieldDataTypeId=FC.FieldDataTypeID  and MFDT.Active =1



left outer join [dbo].[Tbl_Master_ValidationType] MVT on MVT.ValidationTypeId=FC.ValidationTypeID  and MVT.Active =1



left outer join Usermaster UM on UM.UserId=FC.ModifiedBy  



  order by FC.FieldMasterId asc  



END



ELSE IF @Country <> 0 and @Mailboxid = 0





BEGIN



SELECT MFT.FieldTypeId,MFDT.FieldDataTypeId,MVT.ValidationTypeId,fc.CountryID,fc.MailBoxID,cy.Country,eb.EMailBoxName,



FC.FieldMasterId,FC.FieldName ,MFT.FieldTypeAlias,MFT.FieldType,CASE when FC.TextLength=0 then NULL else FC.TextLength end as TextLength,MFDT.FieldDataTypeAlias,





MVT.ValidationType,FC.DefaultValue,case when FC.Active=0 then 'No' else 'Yes' end Active, UM.FirstName +' '+ UM.LastName as ModifiedBy,FC.ModifiedDate,FC.FieldAliasName ,case when FC.FieldPrivilegeID=1 then 'Yes' else 'No' end Mandatory





from [dbo].[Tbl_FieldConfiguration] FC 



left outer join [EMailBox] EB on EB.EMailBoxId = FC.MailBoxID



left outer join country Cy on Cy.CountryId=FC.CountryId 



left outer join Tbl_Master_FieldType MFT on MFT.FieldTypeId=FC.FieldTypeId   and mft.Active =1



left outer join [dbo].[Tbl_Master_FieldDataType] MFDT on MFDT.FieldDataTypeId=FC.FieldDataTypeID  and MFDT.Active =1



left outer join [dbo].[Tbl_Master_ValidationType] MVT on MVT.ValidationTypeId=FC.ValidationTypeID  and MVT.Active =1



left outer join Usermaster UM on UM.UserId=FC.ModifiedBy  



where  cy.CountryId=@Country  order by FC.FieldMasterId asc  



END





ELSE IF @Country = 0 and @Mailboxid <> 0



BEGIN

SELECT MFT.FieldTypeId,MFDT.FieldDataTypeId,MVT.ValidationTypeId,fc.CountryID,fc.MailBoxID,cy.Country,eb.EMailBoxName,



FC.FieldMasterId,FC.FieldName ,MFT.FieldTypeAlias,MFT.FieldType,CASE when FC.TextLength=0 then NULL else FC.TextLength end as TextLength,MFDT.FieldDataTypeAlias,



MVT.ValidationType,FC.DefaultValue,case when FC.Active=0 then 'No' else 'Yes' end Active, UM.FirstName +' '+ UM.LastName as ModifiedBy,FC.ModifiedDate,FC.FieldAliasName ,case when FC.FieldPrivilegeID=1 then 'Yes' else 'No' end Mandatory





from [dbo].[Tbl_FieldConfiguration] FC 



left outer join [EMailBox] EB on EB.EMailBoxId = FC.MailBoxID



left outer join country Cy on Cy.CountryId=FC.CountryId 



left outer join Tbl_Master_FieldType MFT on MFT.FieldTypeId=FC.FieldTypeId   and mft.Active =1

left outer join [dbo].[Tbl_Master_FieldDataType] MFDT on MFDT.FieldDataTypeId=FC.FieldDataTypeID  and MFDT.Active =1



left outer join [dbo].[Tbl_Master_ValidationType] MVT on MVT.ValidationTypeId=FC.ValidationTypeID  and MVT.Active =1



left outer join Usermaster UM on UM.UserId=FC.ModifiedBy 



where eb.EMailBoxId=@Mailboxid  order by FC.FieldMasterId asc  



END



ELSE IF @Country <> 0 and @Mailboxid <> 0



BEGIN



SELECT MFT.FieldTypeId,MFDT.FieldDataTypeId,MVT.ValidationTypeId,fc.CountryID,fc.MailBoxID,cy.Country,eb.EMailBoxName,FC.FieldMasterId,FC.FieldName

 ,MFT.FieldTypeAlias,MFT.FieldType,



 CASE when FC.TextLength=0 then NULL else FC.TextLength end as TextLength ,MFDT.FieldDataTypeAlias,



MVT.ValidationType,FC.DefaultValue,case when FC.Active=0 then 'No' else 'Yes' end Active, UM.FirstName +' '+ UM.LastName as ModifiedBy,FC.ModifiedDate,FC.FieldAliasName,case when FC.FieldPrivilegeID=1 then 'Yes' else 'No' end Mandatory



from [dbo].[Tbl_FieldConfiguration] FC 



left outer join [EMailBox] EB on EB.EMailBoxId = FC.MailBoxID



left outer join country Cy on Cy.CountryId=FC.CountryId 



left outer join Tbl_Master_FieldType MFT on MFT.FieldTypeId=FC.FieldTypeId   and mft.Active =1



left outer join [dbo].[Tbl_Master_FieldDataType] MFDT on MFDT.FieldDataTypeId=FC.FieldDataTypeID  and MFDT.Active =1































































left outer join [dbo].[Tbl_Master_ValidationType] MVT on MVT.ValidationTypeId=FC.ValidationTypeID  and MVT.Active =1































































left outer join Usermaster UM on UM.UserId=FC.ModifiedBy 































































































































































































































































where  eb.EMailBoxId=@Mailboxid and cy.CountryId=@Country  order by FC.FieldMasterId asc  































































































































































































































































END































































































































































































































































END            






















GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MAILBOXMAPPED_REFERENCE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec USP_SELECT_MAILBOXMAPPED_REMAINDER 4,0
-- ======================================================          
-- Author: Pranay Ahuja          
-- Create date: 10/21/2016               
-- Description: To select the Reference folder made for Folder Structure CR Patheon
-- ======================================================          
CREATE PROCEDURE [dbo].[USP_SELECT_MAILBOXMAPPED_REFERENCE]          
@Country int,    
@Mailboxid int
AS          
BEGIN   
SET NOCOUNT ON;   
IF @Country = 0 and @Mailboxid =0
BEGIN
		SELECT  ER.EmailboxReferenceId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress, 
		ER.Reference, case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),ER.ModifiedDate,103) as ModifiedDate              
		Er.ModifiedDate as ModifiedDate
			from [dbo].[EmailboxReferenceConfig] ER 
				left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
				left outer join country Cy on Cy.CountryId=ER.CountryId           
				left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
			where Cy.IsActive=1 and EB.IsActive=1  order by ER.EmailboxReferenceId asc  
END
ELSE IF @Country <> 0 and @Mailboxid = 0
BEGIN
		SELECT  ER.EmailboxReferenceId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress, 
		ER.Reference, case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),ER.ModifiedDate,103) as ModifiedDate              
		Er.ModifiedDate as ModifiedDate
			from [dbo].[EmailboxReferenceConfig] ER  
				left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
				left outer join country Cy on Cy.CountryId=ER.CountryId           
				left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
			where Cy.IsActive=1  and cy.CountryId=@Country and EB.IsActive=1 order by ER.EmailboxReferenceId asc    
END
ELSE IF @Country = 0 and @Mailboxid <> 0
BEGIN
		SELECT  ER.EmailboxReferenceId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress, 
		ER.Reference, case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),ER.ModifiedDate,103) as ModifiedDate              
		Er.ModifiedDate as ModifiedDate
				from [dbo].[EmailboxReferenceConfig] ER
					left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
					left outer join country Cy on Cy.CountryId=ER.CountryId           
					left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
				where Cy.IsActive=1  and eb.EMailBoxId=@Mailboxid and EB.IsActive=1  order by ER.EmailboxReferenceId asc    
END
ELSE IF @Country <> 0 and @Mailboxid <> 0
BEGIN
		SELECT  ER.EmailboxReferenceId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,EB.EMailBoxAddress, 
		ER.Reference, case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),ER.ModifiedDate,103) as ModifiedDate              
		Er.ModifiedDate as ModifiedDate
				from [dbo].[EmailboxReferenceConfig] ER
					left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
					left outer join country Cy on Cy.CountryId=ER.CountryId           
					left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
				where Cy.IsActive=1  and eb.EMailBoxId=@Mailboxid and cy.CountryId=@Country and EB.IsActive=1  order by ER.EmailboxReferenceId asc    
END
END



GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MAILBOXMAPPED_REMAINDER]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec USP_SELECT_MAILBOXMAPPED_REMAINDER 4,0







-- ======================================================          



-- Author:  Ranjith           



-- Create date: 04/27/2015               



-- Description: To select the mapped MAILBOx to Remainder



-- ======================================================          



CREATE PROCEDURE [dbo].[USP_SELECT_MAILBOXMAPPED_REMAINDER]
@Country int,    
@Mailboxid int
AS          
BEGIN   
SET NOCOUNT ON;   
IF @Country = 0 and @Mailboxid =0
	BEGIN
		SELECT  ER.EmailboxremainId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,ER.Template,
		EB.EMailBoxAddress, ER.Frequency,ER.Count ,            
		case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation, 
		case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById,-- Convert(Varchar(10),ER.ModifiedDate,103) 
		ER.ModifiedDate as ModifiedDate    
		from [dbo].[EmailboxRemainderConfig] ER 
		left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
		left outer join country Cy on Cy.CountryId=ER.CountryId           
		left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
		where Cy.IsActive=1 and EB.IsActive=1 and ER.TemplateType=1 order by ER.EmailboxremainId asc  
	END
ELSE IF @Country <> 0 and @Mailboxid = 0
	BEGIN
		SELECT  ER.EmailboxremainId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,ER.Template,EB.EMailBoxAddress,
		ER.Frequency,ER.Count ,            
		case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation,
		case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,                 
		UM.FirstName +' '+ UM.LastName as ModifiedById,-- Convert(Varchar(10),ER.ModifiedDate,103) 
		ER.ModifiedDate as ModifiedDate    
		from [dbo].[EmailboxRemainderConfig] ER 
		left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
		left outer join country Cy on Cy.CountryId=ER.CountryId           
		left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
		where Cy.IsActive=1 and EB.IsActive=1 and ER.TemplateType=1 order by ER.EmailboxremainId asc    
	END
ELSE IF ((@Country = 0 and @Mailboxid <> 0 )OR (@Country<>0 and @Mailboxid<>0))
	BEGIN
	SELECT  ER.EmailboxremainId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,ER.Template,EB.EMailBoxAddress,
	ER.Frequency,ER.Count ,            
	case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation, 
	case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,                
	UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),ER.ModifiedDate,103) 
	ER.ModifiedDate as ModifiedDate    from [dbo].[EmailboxRemainderConfig] ER 
	left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
	left outer join country Cy on Cy.CountryId=ER.CountryId           
	left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
	where Cy.IsActive=1 and EB.IsActive=1 and eb.EMailBoxId=@Mailboxid and ER.TemplateType=1 order by ER.EmailboxremainId asc    
	END

END





GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MAILBOXMAPPED_REMAINDER_Dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- exec USP_SELECT_MAILBOXMAPPED_REMAINDER 4,0
-- ======================================================          
-- Author:  Ranjith           
-- Create date: 04/27/2015               
-- Description: To select the mapped MAILBOx to Remainder
-- ======================================================          

CREATE PROCEDURE [dbo].[USP_SELECT_MAILBOXMAPPED_REMAINDER_Dynamic]
@Country int,    
@Mailboxid int
AS          
BEGIN   
SET NOCOUNT ON;   
IF @Country = 0 and @Mailboxid =0
	BEGIN
		SELECT  ER.EmailboxremainId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,ER.Template,
		EB.EMailBoxAddress,S.StatusDescription as FromStatus,ST.StatusDescription as ToStatus, ER.Frequency,ER.Count ,            
		case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation, ER.EscalationMailId,
		case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,           
		UM.FirstName +' '+ UM.LastName as ModifiedById,-- Convert(Varchar(10),ER.ModifiedDate,103) 
		ER.ModifiedDate as ModifiedDate    
		from [dbo].[EmailboxRemainderConfig] ER 
		left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
		left outer join country Cy on Cy.CountryId=ER.CountryId           
		left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
		left outer join [Status] S on S.StatusID=ER.FromStatus
		left outer join [Status] ST on ST.StatusID=ER.ToStatus
		where Cy.IsActive=1 and EB.IsActive=1 and ER.TemplateType=1 order by ER.EmailboxremainId asc  
	END
ELSE IF @Country <> 0 and @Mailboxid = 0
	BEGIN
		SELECT  ER.EmailboxremainId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,ER.Template,EB.EMailBoxAddress,
		S.StatusDescription as FromStatus,ST.StatusDescription as ToStatus,ER.Frequency,ER.Count ,            
		case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation,ER.EscalationMailId,
		case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,                 
		UM.FirstName +' '+ UM.LastName as ModifiedById,-- Convert(Varchar(10),ER.ModifiedDate,103) 
		ER.ModifiedDate as ModifiedDate    
		from [dbo].[EmailboxRemainderConfig] ER 
		left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
		left outer join country Cy on Cy.CountryId=ER.CountryId           
		left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId  
		left outer join [Status] S on S.StatusID=ER.FromStatus
		left outer join [Status] ST on ST.StatusID=ER.ToStatus
		where Cy.IsActive=1 and EB.IsActive=1 and ER.TemplateType=1 order by ER.EmailboxremainId asc    
	END
ELSE IF ((@Country = 0 and @Mailboxid <> 0 )OR (@Country<>0 and @Mailboxid<>0))
	BEGIN
	SELECT  ER.EmailboxremainId, Cy.CountryId,Cy.Country ,EB.EMAILBOXID,ER.Template,EB.EMailBoxAddress,
	S.StatusDescription as FromStatus,ST.StatusDescription as ToStatus,ER.Frequency,ER.Count ,            
	case when ER.IsEscalation=0 then 'No' else 'Yes' end IsEscalation, ER.EscalationMailId,
	case when ER.IsActive=0 then 'No' else 'Yes' end IsActive,                
	UM.FirstName +' '+ UM.LastName as ModifiedById, --Convert(Varchar(10),ER.ModifiedDate,103) 
	ER.ModifiedDate as ModifiedDate    from [dbo].[EmailboxRemainderConfig] ER 
	left outer join [EMailBox] EB on EB.EMailBoxId = ER.EmailboxId
	left outer join country Cy on Cy.CountryId=ER.CountryId           
	left outer join Usermaster UM on UM.UserId=ER.ModifiedbyId 
	left outer join [Status] S on S.StatusID=ER.FromStatus
	left outer join [Status] ST on ST.StatusID=ER.ToStatus 
	where Cy.IsActive=1 and EB.IsActive=1 and eb.EMailBoxId=@Mailboxid and ER.TemplateType=1 order by ER.EmailboxremainId asc    
	END

END





GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MAILBOXMAPPED_USERS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext USP_SELECT_MAILBOXMAPPED_USERS


 -- exec [USP_SELECT_MAILBOXMAPPED_USERS] 3,'252123'
      

-- ======================================================          

-- Author:  Kalaichelvan KB                

-- Create date: 05/26/2014                

-- Description: To select the mapped users to the MAILBOX          

-- ======================================================          

CREATE PROCEDURE [dbo].[USP_SELECT_MAILBOXMAPPED_USERS]          
@Roleid int,    
@ASSOCIATEID varchar(40)   
AS          
BEGIN   
SET NOCOUNT ON;   

IF(@Roleid=3)   --Team Lead

BEGIN  
SELECT UMB.UserMailBoxMappingID, UM.UserId, (UM.FirstName + ' ' + UM.LastName) as UserName, Cntry.CountryId as CountryId,  Cntry.Country as Country,       
 EBox.EMAILBOXID, EBox.EMailBoxName as MailBoxName, um1.FirstName +' '+ Um1.LastName as ModifiedById, UMB.ModifiedDate as ModifiedDate         
 FROM UserMailBoxMapping UMB 
 left outer join
 [dbo].[USERMASTER] UM               
  on UMB.userid = um.userid  
  left outer join
 [dbo].[USERMASTER] UM1               
   on UM1.UserId=UMB.ModifiedById
 inner join EmailBox EBox on EBox.EmailBoxId = UMB.MailBoxId      
 inner join Country Cntry on Cntry.CountryId = Ebox.CountryId              
 WHERE UM.IsActive <> '0' and EBOX.IsActive=1 
 and EBox.CountryId in( SELECT DISTINCT C.COUNTRYID FROM COUNTRY C INNER JOIN         

EMAILBOX EB ON C.COUNTRYID= EB.COUNTRYID     

INNER JOIN         

USERMAILBOXMAPPING UMBP ON EB.EMAILBOXID= UMBP.MAILBOXID     

inner join userrolemapping ur on UMBP.userid=ur.userid    

inner join usermaster um on um.userid=ur.userid    

WHERE UMBp.USERID = @ASSOCIATEID AND C.ISACTIVE=1 AND EB.ISACTIVE=1     

and ur.Roleid = @Roleid and UM.IsActive=1   )
 
 order by um.userid asc   
END
ELSE   --
BEGIN
SELECT UMB.UserMailBoxMappingID, UM.UserId, (UM.FirstName + ' ' + UM.LastName) as UserName, Cntry.CountryId as CountryId,  Cntry.Country as Country,       

 EBox.EMAILBOXID, EBox.EMailBoxName as MailBoxName, um1.FirstName +' '+ Um1.LastName as ModifiedById, --Convert(Varchar(10),UMB.ModifiedDate,101) as ModifiedDate         
 
 UMB.ModifiedDate as ModifiedDate 

 FROM UserMailBoxMapping UMB 

 left outer join

 [dbo].[USERMASTER] UM               

  on UMB.userid = um.userid  

  left outer join

 [dbo].[USERMASTER] UM1               

   on UM1.UserId=UMB.ModifiedById

 inner join EmailBox EBox on EBox.EmailBoxId = UMB.MailBoxId      

 inner join Country Cntry on Cntry.CountryId = Ebox.CountryId              

 WHERE UM.IsActive <> '0' and EBOX.IsActive=1 order by um.userid asc   
END 
       
       

END            

          









GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_MAILBOXMAPPED_USERS_BY_USERWISE]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
      
            
-- =====================================================================                
-- Author:  Kalaichelvan KB                      
-- Create date: 05/26/2014                      
-- Description: To select the mapped users to the MAILBOX USERWISE               
-- =====================================================================                
CREATE PROCEDURE [dbo].[USP_SELECT_MAILBOXMAPPED_USERS_BY_USERWISE]                
(    
@UserId VARCHAR(50),  
@CountryId VARCHAR(10)  
)                
AS                
BEGIN                
 if @CountryId!=0  or @countryid!='' 
 BEGIN       
 SELECT UMB.UserMailBoxMappingID, UM.UserId, (UM.FirstName + ' ' + UM.LastName) as UserName, Cntry.CountryId as CountryId,  Cntry.Country as Country,             
 --EBox.EMAILBOXID, EBox.EMailBoxName as MailBoxName, um1.FirstName +' '+ Um1.LastName as ModifiedById, Convert(Varchar(10),UMB.ModifiedDate,103) as ModifiedDate               
 EBox.EMAILBOXID, EBox.EMailBoxName as MailBoxName, um1.FirstName +' '+ Um1.LastName as ModifiedById,UMB.ModifiedDate as ModifiedDate               
 FROM UserMailBoxMapping UMB       
 left outer join      
 [dbo].[USERMASTER] UM                     
  on UMB.userid = um.userid        
  left outer join      
 [dbo].[USERMASTER] UM1                     
   on UM1.UserId=UMB.ModifiedById      
 inner join EmailBox EBox on EBox.EmailBoxId = UMB.MailBoxId            
 inner join Country Cntry on Cntry.CountryId = Ebox.CountryId                    
 WHERE UMB.userid=@UserId and  Cntry.CountryId=@CountryId and UM.IsActive <> '0' and EBOX.IsActive=1 order by um.userid asc               
END    
ELSE  
BEGIN  
 SELECT UMB.UserMailBoxMappingID, UM.UserId, (UM.FirstName + ' ' + UM.LastName) as UserName, Cntry.CountryId as CountryId,  Cntry.Country as Country,             
 --EBox.EMAILBOXID, EBox.EMailBoxName as MailBoxName, um1.FirstName +' '+ Um1.LastName as ModifiedById, Convert(Varchar(10),UMB.ModifiedDate,103) as ModifiedDate               
 EBox.EMAILBOXID, EBox.EMailBoxName as MailBoxName, um1.FirstName +' '+ Um1.LastName as ModifiedById,UMB.ModifiedDate as ModifiedDate               
 FROM UserMailBoxMapping UMB       
 left outer join      
 [dbo].[USERMASTER] UM                     
  on UMB.userid = um.userid        
  left outer join      
 [dbo].[USERMASTER] UM1                     
   on UM1.UserId=UMB.ModifiedById      
 inner join EmailBox EBox on EBox.EmailBoxId = UMB.MailBoxId            
 inner join Country Cntry on Cntry.CountryId = Ebox.CountryId                    
 WHERE UMB.userid=@UserId and UM.IsActive <> '0' and EBOX.IsActive=1 order by um.userid asc      
END  
END  
  






GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ROLEMAPPED_USERS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_SELECT_ROLEMAPPED_USERS]                    
AS                    
BEGIN                    
	SELECT UsrMap.UserRoleMappingID, UM.UserId, (UM.FirstName + ' ' + UM.LastName) as UserName,UR.UserRoleId as RoleId,  UR.RoleDescription  as Role,         
	um1.FirstName +' '+ Um1.LastName as CreatedById, UsrMap.CreatedDate as CreatedDate,
	CountriesMapped as CountryIdsMapped, isnull((select dbo.fn_RowConcatenation(UsrMap.CountriesMapped) as [er]), 'N/A') as CountriesMapped
	FROM [dbo].UserRoleMapping UsrMap    
	inner join UserMaster UM on UsrMap.userid = um.userid                      
	inner join UserRole UR on UR.UserRoleId = UsrMap.roleid     
	left outer join USERMASTER UM1 on UM1.UserId=UsrMap.CreatedById                     
	WHERE UM.IsActive <> '0' and UR.userroleid!=1 order by UserID asc, Role asc            
END 







GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_ROLEMAPPED_USERS_BY_USERID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_SELECT_ROLEMAPPED_USERS_BY_USERID]    
(    
@UserId VARCHAR(50)    
)                                       
AS                      
BEGIN                      
                       
 SELECT UsrMap.UserRoleMappingID, UM.UserId, (UM.FirstName + ' ' + UM.LastName) as UserName, UR.UserRoleId as RoleId, UR.RoleDescription  as Role,           
 um1.FirstName +' '+ Um1.LastName as CreatedById, --Convert(varchar(10),UsrMap.CreatedDate,101) as CreatedDate,
 UsrMap.CreatedDate as CreatedDate,
 CountriesMapped as CountryIdsMapped, isnull((select dbo.fn_RowConcatenation(UsrMap.CountriesMapped) as [er]), 'N/A') as CountriesMapped        
 FROM [dbo].UserRoleMapping UsrMap      
 inner join UserMaster UM on UsrMap.userid = um.userid                        
 inner join UserRole UR on UR.UserRoleId = UsrMap.roleid       
 left outer join USERMASTER UM1 on UM1.UserId=UsrMap.CreatedById                       
 WHERE UsrMap.userid=@UserId and UM.IsActive <> '0' and UR.userroleid!=1 order by UserID asc, Role asc              
END 







GO
/****** Object:  StoredProcedure [dbo].[USP_SELECT_USERROLES]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SELECT_USERROLES]    
@UserID varchar(25)    
--@success int out     
AS            
BEGIN     
     
 SELECT UR.UserRoleID, UR.RoleDescription FROM [dbo].[USERMASTER] UM     
 inner join UserRoleMapping UsrMap on UsrMap.userid = um.userid      
 inner join UserRole UR on UR.UserRoleId = UsrMap.roleid    
 WHERE UM.[Userid]=@UserID AND IsActive <> '0'  order by  UR.UserRoleID
     
END






GO
/****** Object:  StoredProcedure [dbo].[USP_SET_AUTO_ACKNOWLEDGEMENT]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[USP_SET_AUTO_ACKNOWLEDGEMENT]
		(
		@CaseID int,@AutoAcknowledgement bit
		)
AS
BEGIN
	Update dbo.EmailMaster set IsAutoAcknowledgement=@AutoAcknowledgement where CaseId=@CaseID;
END




GO
/****** Object:  StoredProcedure [dbo].[USP_Signature_CONFIGURATION]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Signature_CONFIGURATION]    



(    



@Signature VARCHAR(max),    



@UserID VARCHAR(25)    



--@SUCCESS INT OUT    



)    



AS    



BEGIN    



 IF not exists (select Signature from Signature where Userid=@UserID)    



  BEGIN    



   INSERT INTO Signature (Signature, Userid, LastModifiedOn)                    



   VALUES (@Signature, @UserID, Convert(Varchar(10),getutcdate(),103))    



   SELECT 1    



  END    



 ELSE    



  SELECT 0    



END 







GO
/****** Object:  StoredProcedure [dbo].[USP_SUBPROCESS_ROLEBASED_BIND]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_SUBPROCESS_ROLEBASED_BIND]  --exec USP_SUBPROCESS_ROLEBASED_BIND '379743','1',3 
(  
@LOGGEDINUSERID VARCHAR(10),  
@LOGGEDINROLEID INT,  
@COUNTRYID INT  
)  
AS  
BEGIN  
 IF(@LOGGEDINROLEID <> 1 AND @LOGGEDINROLEID <> 2 )  
  BEGIN  
   SELECT SUBPROCESSGROUPID, SUBPROCESSNAME FROM SUBPROCESSGROUPS WHERE ISACTIVE=1 AND SUBPROCESSGROUPID IN  
   (SELECT SUBPROCESSGROUPID FROM EMAILBOX WHERE EMAILBOXID IN (SELECT MAILBOXID FROM USERMAILBOXMAPPING WHERE USERID=@LOGGEDINUSERID) AND COUNTRYID=@COUNTRYID)  
   ORDER BY SUBPROCESSNAME ASC    
  END  
  ELSE   
  BEGIN  
   SELECT SUBPROCESSGROUPID, SUBPROCESSNAME FROM SUBPROCESSGROUPS WHERE ISACTIVE=1 AND COUNTRYIDMAPPING=@COUNTRYID  ORDER BY SUBPROCESSNAME ASC   
  END  
END  






GO
/****** Object:  StoredProcedure [dbo].[USP_SUBPROCESSGROUPS_CONFIGURATION]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =======================================================    
-- Author:  Kalaichelvan KB          
-- Create date: 06/23/2014          
-- Description: To insert the SUBPROCESS NAMES into the master table    
-- =======================================================    
CREATE PROCEDURE [dbo].[USP_SUBPROCESSGROUPS_CONFIGURATION]    
(    
@SubProcessName VARCHAR(200),    
@ProcessOwnerId VARCHAR(100),
@ISACTIVE INT,    
@CREATEDBY VARCHAR(25),
@CountryId INT
)    
AS    
BEGIN    
 IF not exists (select SubProcessName from [SUBPROCESSGROUPS] where SubProcessName=@SubProcessName and countryidmapping = @CountryId)    
  BEGIN    
   INSERT INTO SUBPROCESSGROUPS (SubProcessName, ProcessOwnerId, ISACTIVE, CreatedByID, CreatedDate,COUNTRYIDMAPPING)                    
   VALUES (@SubProcessName, @ProcessOwnerId, @ISACTIVE, @CREATEDBY, Convert(Varchar(10),getutcdate(),101),@CountryId)    
   SELECT 1    
  END    
 ELSE    
  SELECT 0    
END    
  
--select * from [SUBPROCESSGROUPS]








GO
/****** Object:  StoredProcedure [dbo].[USP_TokenLock]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext USP_USERLOGIN
--sp_helptext USP_USERSESSION  
--sp_helptext USP_USERLOGIN    
    
 --select * from UserMaster    
    
--insert into UserMaster values (254649,'Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, 254649, getdate())    
-- =============================================          
-- Author:  Kalaichelvan KB          
-- Create date: 05/23/2014          
-- Description: To check whether the user exists    
-- =============================================      
    
--Exec USP_USERLOGIN '254649','dGVzdA=='          
        
CREATE PROC [dbo].[USP_TokenLock] 
@UserId varchar(50),   
@IsLocked bit,    
@Token varchar(100),
@TokenExpirationTime datetime     
--@success int out     
AS            
Begin  
 
 if exists (Select UserId from USERMASTER Where Userid=@UserID)    
 BEGIN  
 update USERMASTER set IsLocked= @IsLocked,Token=@Token,TokenExpirationTime=@TokenExpirationTime Where Userid=@UserID
  END 
         END
    
 --  group by UR.RoleDescription    
--   select * from usermaster    
-- select * from UserRoleMapping     
-- select * from userrole    
    
---update usermaster set password='dGVzdA==' where userid='254649'
GO
/****** Object:  StoredProcedure [dbo].[USP_TokenValidation]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



     
        
CREATE PROC [dbo].[USP_TokenValidation]    
@UserID varchar(20),    
@IsLocked bit,    
@Token varchar(100)
  
--@success int out     
AS 
          
Begin  
 --if exists (Select UserId from USERMASTER Where Userid=@UserID)    
 --BEGIN     
 if exists (select Token from USERMASTER Where Userid=@UserID and Token=@Token)
   begin
   --if ((select DATEDIFF(MINUTE,GETDATE(),TokenExpirationTime)from UserMaster where userid=@UserID)<30)
    if ((select DATEDIFF(MINUTE,GETUTCDATE(),TokenExpirationTime)from UserMaster where userid=@UserID)between 1 and 30)
     begin
  --token has not expired
 update USERMASTER set IsLocked=0,Token=null,TokenExpirationTime=null Where Userid=@UserID
   SELECT 1 
  end
  ELSE SELECT 2--failed    
 END   
 else
 Select 0
 end    
--Select 0  --id doesnt exist  
--END        
    
 --  group by UR.RoleDescription    
-- USE [EMT_Main_Sprint]  select * from usermaster    
-- select * from UserRoleMapping     
-- select * from userrole    
    
---update usermaster set IsLocked=0 where userid='195174'
GO
/****** Object:  StoredProcedure [dbo].[USP_TotalNoUsersCount]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_TotalNoUsersCount

CREATE PROCEDURE [dbo].[USP_TotalNoUsersCount]  

AS

BEGIN

SELECT  COUNT(UserId) AS  TotalNoOfUsers FROM UserMaster 


END
GO
/****** Object:  StoredProcedure [dbo].[USP_Trigger_Forgot_Password]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================      
-- Author:  Kalaichelvan     
-- Create date: 23/05/2014      
-- Description: To trigger the password to the user    
-- =============================================      
 -- EXEC [PROC_TriggerPassword] '254649'    
CREATE PROCEDURE [dbo].[USP_Trigger_Forgot_Password]            
(              
 @UserId nvarchar(200)  ,  
 @NEWPASSWORD varchar(max)  
)    
AS      
BEGIN    
select UM.EMAIl from UserMaster UM where UM.UserId = @UserId    
update UserMater set [Password]=@NEWPASSWORD where UserId = @UserId
END






GO
/****** Object:  StoredProcedure [dbo].[USP_UpdatCaseDetails_Reminder]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UpdatCaseDetails_Reminder]          
@CaseId int,          
@Status int,
@Comments varchar(max)


AS          

BEGIN   
	
	DECLARE @CURRENTSTATUS INT          
	DECLARE @MAILASSIGNEDTO NVARCHAR(50) 
	declare @Subprocessid nvarchar(250)
	declare @FromStatus int
	declare @ToStatusId int

	SET @CURRENTSTATUS = (SELECT StatusID FROM EMAILMASTER WHERE caseid=@CaseId)    

	SET @MAILASSIGNEDTO =(SELECT AssignedToId FROM EMAILMASTER WHERE caseid=@CaseId)  
			
	

	          
	IF(@Status is not null)
	begin
	Update EmailMaster set StatusId=@Status,ModifiedDate=getutcdate() where CaseId=@CaseId
	if(@CURRENTSTATUS is not null)
	begin
		INSERT INTO EMAILAUDIT (CASEID,FromStatusId,ToStatusId,userId,StartTime,EndTime)  
		VALUES(@CaseId,@CURRENTSTATUS,@Status,@MAILASSIGNEDTO,getutcdate(),getutcdate())
		end 
		else
		begin
		INSERT INTO EMAILAUDIT (CASEID,FromStatusId,ToStatusId,userId,StartTime,EndTime)  
		VALUES(@CaseId,'-',@Status,NULL,getutcdate(),getutcdate()) 
		end

	END  
	
		
 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_ACKNOWLEDGEMAILBOXMAPPED]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Pranay Ahuja>
-- Create date: <8/16/2016>
-- Description:	<To UPDATE the Acknowledge configuration to  MAILBOXES  >
-- =============================================
CREATE PROCEDURE [dbo].[USP_UPDATE_ACKNOWLEDGEMAILBOXMAPPED]  
	(
	@raminsermailboxmapping int,    
    @CountryId int,
    @MailBoxId INT,
    @isActive bit,
    @createdby varchar(20),
	@TemplateType int,
	@Template nvarchar(max)
	)
AS
BEGIN
	IF Exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE EmailboxremainId=@raminsermailboxmapping)

  BEGIN

   IF  exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId)

    BEGIN    

     UPDATE [EmailboxRemainderConfig] SET CountryId=@CountryId , EmailboxId=@MailBoxId,IsActive=@isActive, ModifiedById=@createdby, ModifiedDate=getutcdate(),TemplateType=@TemplateType,Template=@Template WHERE EmailboxremainId=@raminsermailboxmapping    

     SELECT 1   

    END    

   ELSE    

    SELECT 2  

  END

 ELSE

  SELECT 0 
END






GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_CATEGORYMAILBOXMAPPED]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--sp_helptext USP_UPDATE_MAILBOXMAPPED_USERS   

--===================================================    

-- Author:  Ranjith          

-- Create date: 04/28/2015          

-- Description: To UPDATE the Remainder configuration to  MAILBOXES    

-- ====================================================    

CREATE PROCEDURE [dbo].[USP_UPDATE_CATEGORYMAILBOXMAPPED]    

(  

@raminsermailboxmapping int,    

@CountryId int,

@MailBoxId INT,  

@Category varchar(200),

@isActive bit,

@createdby varchar(20)

)As

BEGIN  

 IF Exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxCategoryConfig] WHERE EmailboxCategoryId=@raminsermailboxmapping)

  BEGIN

   IF  exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxCategoryConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId 

   and EmailboxCategoryId=@raminsermailboxmapping)

   BEGIN

   IF   not exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxCategoryConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId 

   and Category=@Category and IsActive=@isActive )

    BEGIN    

     UPDATE [EmailboxCategoryConfig] SET CountryId=@CountryId , EmailboxId=@MailBoxId,Category=@Category,IsActive=@isActive,

	  ModifiedById=@createdby, ModifiedDate=GETUTCDATE()
	  --Convert(Varchar(10),getutcdate(),101) 
	  WHERE EmailboxCategoryId=@raminsermailboxmapping    

     SELECT 1   

    END  

	ELSE

	select 3 

	END  

   ELSE    

    SELECT 2  

  END

 ELSE

  SELECT 0   

END    































    































--select * from usermailboxmapping










GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_COUNTRY]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UPDATE_COUNTRY]                
(      
@CountryId VARCHAR(10) ,    
@COUNTRYNAME VARCHAR(200),      
@ISACTIVE INT,      
@CREATEDBY VARCHAR(25)      
      
)                   
AS                
BEGIN                 
 IF  EXISTS (select [COUNTRYID] from COUNTRY where [CountryId] = @COUNTRYId)      
  BEGIN           
   Update COUNTRY set Country=@CountryName, IsActive=@ISActive, ModifiedBYID=@CreatedBy, ModifiedDATE=getutcdate() FROM [dbo].[COUNTRY]      
   where [CountryId] = @COUNTRYId      
   SELECT 1      
  END           
 ELSE                  
  SELECT 0      
End







GO
/****** Object:  StoredProcedure [dbo].[USP_Update_EMailAttachment_Details]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Update_EMailAttachment_Details]      
@Work_Id varchar(10),      
@Filename varchar(200)      
AS      
BEGIN      
SET NOCOUNT ON;      
UPDATE EMAILMASTER set AttachmentLocation = 'mail\'+ @Work_Id + '\'  where caseid =@Work_Id      
      
END







GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_EMAILBOXLOGINDETAIL]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_UPDATE_EMAILBOXLOGINDETAIL


-- ==============================================================      
-- Author:  Kalaichelvan KB            
-- Create date: 05/23/2014            
-- Description: To update the EmailBoxLoginDetails      
-- ==============================================================      
CREATE PROCEDURE [dbo].[USP_UPDATE_EMAILBOXLOGINDETAIL]                
(      
@EmailBoxLoginDetailId VARCHAR(10),    
@EMAILID VARCHAR(200),    
@PASSWORD VARCHAR(100),    
@ISLOCKED int,    
@ISACTIVE int    
)                   
AS                
BEGIN                 
 IF  EXISTS (select [EmailBoxLoginDetailId] from EmailBoxLoginDetail where [EmailBoxLoginDetailId] = @EmailBoxLoginDetailId)      
  BEGIN           
   if (@Password is not null)  
    BEGIN  
    Update EmailBoxLoginDetail set EMAILID=@EMAILID,  ISLOCKED=@ISLOCKED, Password=@Password, ISACTIVE=@ISACTIVE FROM [dbo].EmailBoxLoginDetail      
    where [EmailBoxLoginDetailId] = @EmailBoxLoginDetailId    
    SELECT 1    
 END  
   ELSE  
    BEGIN     
     Update EmailBoxLoginDetail set EMAILID=@EMAILID,  ISLOCKED=@ISLOCKED, ISACTIVE=@ISACTIVE FROM [dbo].EmailBoxLoginDetail      
  where [EmailBoxLoginDetailId] = @EmailBoxLoginDetailId    
  SELECT 1    
 END     
  END           
 ELSE                  
  SELECT 0      
End  
  
    
--select * from EmailBoxLoginDetail   
--where [EmailBoxLoginDetailId] = @EmailBoxLoginDetailId) 






GO
/****** Object:  StoredProcedure [dbo].[USP_Update_Followup_Details]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Update_Followup_Details]          
@CaseId int,          

@Received_date varchar(50),          
@MailFolder_Id varchar(10),          
@Subject varchar(500),          
@Message varchar(7000),          
@From_Add varchar(200),      
@Toaddress varchar(4000),   
@CCaddress varchar(4000),      
@BCCaddress varchar(4000),        
@SubCaseId int =null ,
@Priority bit,
@IsVip bit

AS          

BEGIN   
	DECLARE @CURRENTSTATUS INT          
	DECLARE @MAILASSIGNEDTO NVARCHAR(50) 
	SET @CURRENTSTATUS = (SELECT StatusID FROM EMAILMASTER WHERE caseid=@CaseId)    

	SET @MAILASSIGNEDTO =(SELECT AssignedToId FROM EMAILMASTER WHERE caseid=@CaseId)     
	
	IF(@CURRENTSTATUS = 3) -- CLARIFICATION NEEDED  

	BEGIN           

		INSERT INTO EMAILAUDIT (CASEID,FromStatusId,ToStatusId,userId,StartTime,EndTime)  
		VALUES(@CaseId,@CURRENTSTATUS,4,@MAILASSIGNEDTO,getutcdate(),getutcdate())    

		DECLARE @REQUIRED BIT 
		SELECT @REQUIRED=IsUrgent FROM EMAILMASTER WHERE CASEID=@CaseId
 
		IF(@REQUIRED=0)
				UPDATE EMAILMASTER SET StatusId=4,MODIFIEDDATE=getutcdate(),IsUrgent=@Priority,IsVipMail=@IsVip  WHERE CASEID=@CaseId  
		ELSE
				UPDATE EMAILMASTER SET StatusId=4,MODIFIEDDATE=getutcdate(),IsVipMail=@IsVip WHERE CASEID=@CaseId  
				
	END  
	
		IF EXISTS(SELECT CASEID FROM Draftsave_att where CaseId=@CaseId)    
		BEGIN 
		   
			delete from Draftsave_att where CaseId=@CaseId    
		END    
		IF EXISTS (SELECT CASEID FROM Draftsave WHERE CASEID=@CaseId)  
		BEGIN  
			delete from Draftsave where CASEID=@CaseId  
		END  
 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Update_Followup_Details_Autoreply ]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --sp_helptext USP_Update_Followup_Details_Autoreply

CREATE PROCEDURE [dbo].[USP_Update_Followup_Details_Autoreply ]         
(

@CaseId int,        

@Received_date varchar(50),    

@Message varchar(7000)         

)

AS          

BEGIN   

	DECLARE @CURRENTSTATUS INT  
	declare @MAILASSIGNEDTO  varchar(50)     
	
	SET @CURRENTSTATUS = (SELECT StatusID FROM EMAILMASTER WHERE caseid=@CaseId)    

	SET @MAILASSIGNEDTO =(SELECT AssignedToId FROM EMAILMASTER WHERE caseid=@CaseId)     
		
	IF(@CURRENTSTATUS = 3) -- CLARIFICATION NEEDED  

	BEGIN           
			UPDATE EMAILMASTER SET AutoReplyText=@Message, AutoReplyReceivedTime=@Received_date ,StatusId=4,MODIFIEDDATE=GETDATE() WHERE  CASEID=@CaseId  	

			INSERT INTO EMAILAUDIT (CASEID,FromStatusId,ToStatusId,userId,StartTime,EndTime)  
			VALUES(@CaseId,@CURRENTSTATUS,4,@MAILASSIGNEDTO,getutcdate(),getutcdate())    

 
	END  
	 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Update_Followup_Details_Autoreply_dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --sp_helptext USP_Update_Followup_Details_Autoreply

CREATE PROCEDURE [dbo].[USP_Update_Followup_Details_Autoreply_dynamic]         
(

@CaseId int,        

@Received_date varchar(50),    

@Message varchar(7000)         

)

AS          

BEGIN   

	DECLARE @CURRENTSTATUS INT  
	declare @MAILASSIGNEDTO  varchar(50)     
	declare @SubProcessId int
	declare @EMailBoxId int
	declare @FromStatusID int
	declare @TostatusId int
	set @EMailBoxId=(select EMailBoxId from EmailMaster where CaseId=@CaseId)
	set @SubProcessId=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMailBoxId)

	if exists(select * from Status where SubProcessID=@SubProcessId)
	begin
	set @FromStatusID=(select StatusId from Status where SubProcessID=@SubProcessId and IsReminderStatus=1)
	set @TostatusId=(select StatusId from Status where SubProcessID=@SubProcessId and IsFollowupStatus=1)
	end
	else
	begin
	set @FromStatusID=(select StatusId from Status where SubProcessID is null and IsReminderStatus=1)
	set @TostatusId=(select StatusId from Status where SubProcessID is null and IsFollowupStatus=1)
	end
	
	SET @CURRENTSTATUS = (SELECT StatusID FROM EMAILMASTER WHERE caseid=@CaseId)    

	SET @MAILASSIGNEDTO =(SELECT AssignedToId FROM EMAILMASTER WHERE caseid=@CaseId)     
		
	IF(@CURRENTSTATUS = @FromStatusID) -- CLARIFICATION NEEDED  

	BEGIN           
			UPDATE EMAILMASTER SET AutoReplyText=@Message, AutoReplyReceivedTime=@Received_date ,StatusId=@TostatusId,MODIFIEDDATE=GETDATE() WHERE  CASEID=@CaseId  	

			INSERT INTO EMAILAUDIT (CASEID,FromStatusId,ToStatusId,userId,StartTime,EndTime)  
			VALUES(@CaseId,@CURRENTSTATUS,@TostatusId,@MAILASSIGNEDTO,getutcdate(),getutcdate())    

 
	END  
	 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Update_Followup_Details_dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Update_Followup_Details_dynamic]          
@CaseId int,          

@Received_date varchar(50),          
@MailFolder_Id varchar(10),          
@Subject varchar(500),          
@Message varchar(7000),          
@From_Add varchar(200),      
@Toaddress varchar(4000),   
@CCaddress varchar(4000),      
@BCCaddress varchar(4000),        
@SubCaseId int =null ,
@Priority bit,
@IsVip bit

AS          

BEGIN   
	
	DECLARE @CURRENTSTATUS INT          
	DECLARE @MAILASSIGNEDTO NVARCHAR(50) 
	declare @Subprocessid nvarchar(250)
	declare @FromStatus int
	declare @ToStatusId int

	SET @CURRENTSTATUS = (SELECT StatusID FROM EMAILMASTER WHERE caseid=@CaseId)    

	SET @MAILASSIGNEDTO =(SELECT AssignedToId FROM EMAILMASTER WHERE caseid=@CaseId)  
		
	set @Subprocessid=(select SubProcessGroupId from EMailBox where EMailBoxId=@MailFolder_Id)
	if exists(select * from Status where SubProcessID=@Subprocessid)
	begin
	set @FromStatus=(select StatusId from Status where SubProcessID=@Subprocessid and IsReminderStatus=1)
	set @ToStatusId=(select StatusId from Status where SubProcessID=@Subprocessid and IsFollowupStatus=1)
	end
	else
	begin
	set @FromStatus=(select StatusId from Status where SubProcessID is null and IsReminderStatus=1)
	set @ToStatusId=(select StatusId from Status where SubProcessID is null and IsFollowupStatus=1)
	end

	
	IF(@CURRENTSTATUS = @FromStatus) -- CLARIFICATION NEEDED  

	BEGIN           
	IF(@ToStatusId is not null)
	begin
		INSERT INTO EMAILAUDIT (CASEID,FromStatusId,ToStatusId,userId,StartTime,EndTime)  
		VALUES(@CaseId,@CURRENTSTATUS,@ToStatusId,@MAILASSIGNEDTO,getutcdate(),getutcdate())  
		

		DECLARE @REQUIRED BIT 
		SELECT @REQUIRED=IsUrgent FROM EMAILMASTER WHERE CASEID=@CaseId
 
		IF(@REQUIRED=0)
				UPDATE EMAILMASTER SET StatusId=@ToStatusId,MODIFIEDDATE=getutcdate(),IsUrgent=@Priority,IsVipMail=@IsVip  WHERE CASEID=@CaseId  
		ELSE
				UPDATE EMAILMASTER SET StatusId=@ToStatusId,MODIFIEDDATE=getutcdate(),IsVipMail=@IsVip WHERE CASEID=@CaseId  
		end  		
	END  
	
		IF EXISTS(SELECT CASEID FROM Draftsave_att where CaseId=@CaseId)    
		BEGIN 
		   
			delete from Draftsave_att where CaseId=@CaseId    
		END    
		IF EXISTS (SELECT CASEID FROM Draftsave WHERE CASEID=@CaseId)  
		BEGIN  
			delete from Draftsave where CASEID=@CaseId  
		END  
 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Update_Followup_Details_old]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Update_Followup_Details_old]          
@CaseId int,          

@Received_date varchar(50),          
@MailFolder_Id varchar(10),          
@Subject varchar(500),          
@Message varchar(7000),          
@From_Add varchar(200),      
@Toaddress varchar(4000),   
@CCaddress varchar(4000),      
@BCCaddress varchar(4000),        
@SubCaseId int =null ,
@Priority bit
--,@IsVip bit

AS          

BEGIN   
	DECLARE @CURRENTSTATUS INT          
	DECLARE @MAILASSIGNEDTO NVARCHAR(50) 
	SET @CURRENTSTATUS = (SELECT StatusID FROM EMAILMASTER WHERE caseid=@CaseId)    

	SET @MAILASSIGNEDTO =(SELECT AssignedToId FROM EMAILMASTER WHERE caseid=@CaseId)     
	
	IF(@CURRENTSTATUS = 3) -- CLARIFICATION NEEDED  

	BEGIN           

		INSERT INTO EMAILAUDIT (CASEID,FromStatusId,ToStatusId,userId,StartTime,EndTime)  
		VALUES(@CaseId,@CURRENTSTATUS,4,@MAILASSIGNEDTO,getutcdate(),getutcdate())    

		DECLARE @REQUIRED BIT 
		SELECT @REQUIRED=IsUrgent FROM EMAILMASTER WHERE CASEID=@CaseId
 
		IF(@REQUIRED=0)
				UPDATE EMAILMASTER SET StatusId=4,MODIFIEDDATE=getutcdate(),IsUrgent=@Priority WHERE CASEID=@CaseId  
		ELSE
				UPDATE EMAILMASTER SET StatusId=4,MODIFIEDDATE=getutcdate() WHERE CASEID=@CaseId  
				
	END  
	
		IF EXISTS(SELECT CASEID FROM Draftsave_att where CaseId=@CaseId)    
		BEGIN 
		   
			delete from Draftsave_att where CaseId=@CaseId    
		END    
		IF EXISTS (SELECT CASEID FROM Draftsave WHERE CASEID=@CaseId)  
		BEGIN  
			delete from Draftsave where CASEID=@CaseId  
		END  
 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_HOLIDAYDETAILS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =======================================================  
-- Author:  Kalaichelvan KB        
-- Create date: 07/12/2014        
-- Description: To UPDATE the Holiday details
-- =======================================================  
CREATE PROCEDURE [dbo].[USP_UPDATE_HOLIDAYDETAILS]
(        
@HOLIDAYID VARCHAR(10) ,      
@HOLIDAYDESC VARCHAR(50),     
@HolidayDate DATETIME,  
@ISACTIVE INT,   
@LoggedinUserId VARCHAR(50)
)                     
AS                  
BEGIN                   
 IF  EXISTS (select [HOLIDAYID] from HOLIDAY where [HOLIDAYID] = @HOLIDAYId)        
  BEGIN             
   Update HOLIDAY set HolidayDescription=@HOLIDAYDESC, HolidayDate=@HolidayDate, IsActive=@ISActive, CREATEDBYID=@LoggedinUserId, CREATEDDATE=getutcdate(), TotalMinutes=1440
   FROM [dbo].[HOLIDAY]
   where [HOLIDAYID] = @HOLIDAYID
   SELECT 1        
  END             
 ELSE                    
  SELECT 0        
End

--select * from emailbox
--update emailbox set isqcrequired=0 where emailboxid=2







GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_MAILBOX]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--EXEC USP_UPDATE_USERS '254649','Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, '254649', getutcdate(),1                        







-- ==================================================================          







-- Author:  Kalaichelvan KB                              







-- Create date: 09/05/2014                              







-- Description: To update the MAilBox Details into the master table                        







-- ==================================================================             







                        







CREATE PROCEDURE [dbo].[USP_UPDATE_MAILBOX]                        







(                        







@EMailBoxId Varchar(10),                        







@EMailBoxName VARCHAR(100),                        







@EMailBoxAddress VARCHAR(100),                        


@EMailBoxADDRESSOPT VARCHAR(max), 





@EMailFolderPath VARCHAR(500),                        







@Domain VARCHAR(10),                        







@EMAILID VARCHAR(100),                       







@USERID VARCHAR(50),                        







@Password VARCHAR(100),                        







@CountryName Varchar(100),                  







@SUBPROCESSGROUPID VARCHAR(10),              







@TATHRS VARCHAR(10),                    







@IsActive INT,                        







@IsQCRequired INT,                        



@IsApprovalRequired int,



@TriggerMAil INT,                     







@ISREPLYNOTREQUIRED INT,                







@ISLOCKED INT,                            







@CreatedById VARCHAR(50),                        


@IsVocSurvey int,
@IsSkillBasedAllocation int,

@TIMEZONE VARCHAR(100),

@OFFSET VARCHAR(100)


)                        







AS                        







Declare @CountryId INT                        







SELECT @CountryId = countryId from country where Country=@CountryName                        







DECLARE @EMAILBOXLOGINDETAILID INT                          







SELECT @EMAILBOXLOGINDETAILID = EMAILBOXLOGINDETAILID FROM EMAILBOXLOGINDETAIL WHERE EMAILID=@EMAILID                   







DECLARE @PREVIOUSTATINHRS VARCHAR(10)                        







SELECT @PREVIOUSTATINHRS = TATINHOURS FROM EMAILBOX WHERE EMAILBOXID=@EMAILBOXID          







DECLARE @PREVIOUSTATINSECS VARCHAR(10)                        







SELECT @PREVIOUSTATINSECS = TATINSECONDS FROM EMAILBOX WHERE EMAILBOXID=@EMAILBOXID          







                       







BEGIN                        







 IF exists (select EMailBoxAddress from EMailBox where EMAILBOXId=@EMailBoxId)                      







  BEGIN           







   IF NOT EXISTS (SELECT * FROM EMAILBOX WHERE (EMAILBOXADDRESS=@EMAILBOXADDRESS OR EMailBoxAddressOptional= @EMailBoxADDRESSOPT ) and EMailBoxId != @EMailBoxId)                        







    BEGIN                    







     UPDATE EMailBox SET EMailBoxName=@EMailBoxName, EMailBoxAddress=@EMailBoxAddress,EMailBoxAddressOptional=@EMailBoxADDRESSOPT, --EMailFolderPath=@EMailFolderPath, 
	 Domain=@Domain,                         







     USERID=@USERID, CountryId=@CountryId, SUBPROCESSGROUPID=@SUBPROCESSGROUPID, TATInHours=@TATHRS, Isactive=@ISACTIVE, IsQCRequired=@IsQCRequired,IsApprovalRequired=@IsApprovalRequired, ISMAILTRIGGERREQUIRED=@TriggerMAil, CreatedById=@CreatedById,                         







     CreatedDate=getutcdate(), EMAILBOXLOGINDETAILID=@EMAILBOXLOGINDETAILID, ISREPLYNOTREQUIRED=@ISREPLYNOTREQUIRED,IsSkillBasedAllocation=@IsSkillBasedAllocation, ISLOCKED=@ISLOCKED, LockedDate=getutcdate(), TATInSeconds=(@TATHRS * 3600),IsVOCSurvey=@IsVocSurvey,TimeZone=@TIMEZONE,Offset=@OFFSET WHERE EMAILBOXId=@EMailBoxId                    







     INSERT INTO SLAAUDITMASTER (EMAILBOXID, PREVIOUSTATINHOURS, PREVIOUSTATINSECS, CURRENTTATINHOURS, CURRENTTATINSECS, CREATEDBYID, CREATEDDATE)          







     VALUES (@EMAILBOXID, @PREVIOUSTATINHRS, @PREVIOUSTATINSECS, @TATHRS, (@TATHRS*3600), @CREATEDBYID, getutcdate())  



	 



	        

            







    SELECT 1                        







   END       







 ENd                   







ELSE             







   SELECT  0                       







END                        







                      





--SELECT * FROM EMAILBOXLOGINDETAIL                   







--SELECT * FROM COUNTRY                      







--SELECT * FROM EMAILBOX                  







--select * from subprocessgroups          







--select * from Slaauditmaster  







--update Slaauditmaster set emailboxid=5 where slaauditid=1          







          







          







--DECLARE @TATSecs VARCHAR              







--SET @TATSecs=(1 * 3600 )          







--PRINT @TATSecs 







--SELECT EMAILBOXADDRESS FROM EMAILBOX WHERE EMAILBOXId != 1
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_MAILBOXMAPPED_USERS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--sp_helptext USP_UPDATE_MAILBOXMAPPED_USERS   
    
-- ====================================================    
-- Author:  Kalaichelvan KB          
-- Create date: 05/26/2014          
-- Description: To UPDATE the mapped users to the MAILBOXES    
-- ====================================================    
CREATE PROCEDURE [dbo].[USP_UPDATE_MAILBOXMAPPED_USERS]    
(    
@UsermailBoxMappingId int,    
@UserId VARCHAR(50),    
@MailBoxId INT,  
@LoggedinUserId VARCHAR(50)   
)    
AS    
BEGIN    
 IF Exists (select USERID,MailBoxId from usermailboxmapping where UsermailBoxMappingId=@UsermailBoxMappingId)
  BEGIN
   IF not exists (select USERID, MailBoxId from UserMailBoxMapping where USERID=@UserId and MailBoxId=@MailBoxId)
    BEGIN    
     UPDATE UserMailBoxMapping SET USERID=@UserId, MailBoxId=@MailBoxId, ModifiedById=@LoggedinUserId, ModifiedDate=getutcdate() where UsermailBoxMappingId=@UsermailBoxMappingId    
     SELECT 1   
    END    
   ELSE    
    SELECT 2  
  END
 ELSE
  SELECT 0   
END    
    
--select * from usermailboxmapping








GO
/****** Object:  StoredProcedure [dbo].[USP_Update_MailCaseDetailsForChildCase]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_Update_MailCaseDetailsForChildCase]            
            
(
@ParentCaseId varchar(100),
@MailBoxId varchar(100),
@ChildCaseId varchar(100)
)
  
  
AS            
BEGIN             
SET NOCOUNT ON; 

DECLARE @StatusId int,
          @EMailReceivedDate datetime,
		  @EMailBoxId int,
		  @Subject varchar,
		  @EmailBody varchar,
		  @EMailFrom varchar,
            @EmailTo varchar,
            @EmailCc varchar,
  @EmailBcc varchar,
  @CreatedDate datetime,
@IsUrgent bit,
@IsManual bit;

            
 
  select @StatusId=statusid,@EMailReceivedDate=EMailReceivedDate, @EMailBoxId=EMailBoxId,@Subject= Subject,@EmailBody=EMailBody,
  @EMailFrom=EMailFrom,@EmailTo=EmailTo,@EmailCc=EmailCc,@EmailBcc=EmailBcc,@CreatedDate=CreatedDate,@IsUrgent=IsUrgent,@IsManual=IsManual from EmailMaster where CaseId=@ParentCaseId           
  
 
 Update EmailMaster set statusid=1,EMailReceivedDate=@EMailReceivedDate,EMailBoxId=@EMailBoxId,Subject=@Subject,EMailBody=@EmailBody,
   EMailFrom=@EMailFrom,EmailTo=@EmailTo,EmailCc=@EmailCc,EmailBcc=@EmailBcc,CreatedDate=@CreatedDate,IsUrgent=@IsUrgent,IsManual=@IsManual where CaseId=@ChildCaseId;    
        
END
GO
/****** Object:  StoredProcedure [dbo].[USP_Update_MailCaseDetailsForChildCase_dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[USP_Update_MailCaseDetailsForChildCase_dynamic]            
            
(
@ParentCaseId varchar(100),
@MailBoxId varchar(100),
@ChildCaseId varchar(100)
)
  
AS            
BEGIN             
SET NOCOUNT ON; 

DECLARE @StatusId int,
          @EMailReceivedDate datetime,
		  @EMailBoxId int,
		  @Subject varchar,
		  @EmailBody varchar,
		  @EMailFrom varchar,
            @EmailTo varchar,
            @EmailCc varchar,
  @EmailBcc varchar,
  @CreatedDate datetime,
@IsUrgent bit,
@IsManual bit;


declare @Subprocessid nvarchar(250)
declare @Status nvarchar(250)
set @Subprocessid=(select SubProcessGroupId from EMailBox where EMailBoxId=@EMailBoxId)
if exists(select * from Status where SubProcessID=@Subprocessid)
set @Status=(select StatusId from Status where SubProcessID=@Subprocessid and IsInitalStatus=1)
else
set @Status=(select StatusId from Status where SubProcessID is null and IsInitalStatus=1)
    
 
  select @StatusId=statusid,@EMailReceivedDate=EMailReceivedDate, @EMailBoxId=EMailBoxId,@Subject= Subject,@EmailBody=EMailBody,
  @EMailFrom=EMailFrom,@EmailTo=EmailTo,@EmailCc=EmailCc,@EmailBcc=EmailBcc,@CreatedDate=CreatedDate,@IsUrgent=IsUrgent,@IsManual=IsManual from EmailMaster where CaseId=@ParentCaseId           
  
 
 Update EmailMaster set statusid=@Status,EMailReceivedDate=@EMailReceivedDate,EMailBoxId=@EMailBoxId,Subject=@Subject,EMailBody=@EmailBody,
   EMailFrom=@EMailFrom,EmailTo=@EmailTo,EmailCc=@EmailCc,EmailBcc=@EmailBcc,CreatedDate=@CreatedDate,IsUrgent=@IsUrgent,IsManual=@IsManual where CaseId=@ChildCaseId;    
        
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_REFERENCEMAILBOXMAPPED]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--===================================================    

-- Author:  Pranay          

-- Create date: 10/21/2016          

-- Description: To UPDATE the Reference configuration to MAILBOXES    

-- ====================================================    

CREATE PROCEDURE [dbo].[USP_UPDATE_REFERENCEMAILBOXMAPPED]    

(  

@raminsermailboxmapping int,    

@CountryId int,

@MailBoxId INT,  

@Reference varchar(200),

@isActive bit,

@createdby varchar(20)

)As

BEGIN  

 IF Exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxReferenceConfig] WHERE EmailboxReferenceId=@raminsermailboxmapping)

  BEGIN

   IF  exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxReferenceConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId 

   and EmailboxReferenceId=@raminsermailboxmapping)

   BEGIN

   IF   not exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxReferenceConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId 

   and Reference=@Reference and IsActive=@isActive )

    BEGIN    

     UPDATE [EmailboxReferenceConfig] SET CountryId=@CountryId , EmailboxId=@MailBoxId,Reference=@Reference,IsActive=@isActive,

	  ModifiedById=@createdby, ModifiedDate=getutcdate() WHERE EmailboxReferenceId=@raminsermailboxmapping    

     SELECT 1   

    END  

	ELSE

	select 3 

	END  

   ELSE    

    SELECT 2  

  END

 ELSE

  SELECT 0   

END    

--select * from usermailboxmapping




GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_REMAINDERMAILBOXMAPPED]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext USP_UPDATE_MAILBOXMAPPED_USERS   

    

-- ====================================================    

-- Author:  Ranjith          

-- Create date: 04/28/2015          

-- Description: To UPDATE the Remainder configuration to  MAILBOXES    

-- ====================================================    

CREATE PROCEDURE [dbo].[USP_UPDATE_REMAINDERMAILBOXMAPPED]    

(    

@raminsermailboxmapping int,    
@CountryId int,
@MailBoxId INT,  
@freq int,
@count int,
@isescalation int,
@isActive bit,
@createdby varchar(20),
@TemplateType int,
@Template nvarchar(max)
)    

AS    

BEGIN    

 IF Exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE EmailboxremainId=@raminsermailboxmapping)

  BEGIN

   IF  exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId)

    BEGIN    

     UPDATE [EmailboxRemainderConfig] SET CountryId=@CountryId , EmailboxId=@MailBoxId,Frequency=@freq,Count=@count,IsEscalation=@isescalation,IsActive=@isActive, ModifiedById=@createdby, ModifiedDate=getutcdate(),TemplateType=@TemplateType,Template=@Template WHERE EmailboxremainId=@raminsermailboxmapping    

     SELECT 1   

    END    

   ELSE    

    SELECT 2  

  END

 ELSE

  SELECT 0   

END    

    

--select * from usermailboxmapping






GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_REMAINDERMAILBOXMAPPED_Dynamic]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext USP_UPDATE_MAILBOXMAPPED_USERS   

    

-- ====================================================    

-- Author:  Ranjith          

-- Create date: 04/28/2015          

-- Description: To UPDATE the Remainder configuration to  MAILBOXES    

-- ====================================================    

Create PROCEDURE [dbo].[USP_UPDATE_REMAINDERMAILBOXMAPPED_Dynamic]    

(    

@raminsermailboxmapping int,    
@CountryId int,
@MailBoxId INT,
@FromStatusId int,
@ToStatusId int,   
@freq int,
@count int,
@isescalation int,
@isActive bit,
@createdby varchar(20),
@TemplateType int,
@Template nvarchar(max),
@EscalationMailId nvarchar(max)
)    

AS    

BEGIN    

 IF Exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE EmailboxremainId=@raminsermailboxmapping)

  BEGIN

   IF  exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId)

    BEGIN    

     UPDATE [EmailboxRemainderConfig] SET CountryId=@CountryId , EmailboxId=@MailBoxId,Frequency=@freq,[Count]=@count,IsEscalation=@isescalation,IsActive=@isActive, 
		ModifiedById=@createdby, ModifiedDate=getutcdate(),TemplateType=@TemplateType,Template=@Template,FromStatus=@FromStatusId,ToStatus=@ToStatusId,
		EscalationMailId=@EscalationMailId 
	 WHERE EmailboxremainId=@raminsermailboxmapping    

     SELECT 1   

    END    

   ELSE    

    SELECT 2  

  END

 ELSE

  SELECT 0   

END    

    

--select * from usermailboxmapping






GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_REMAINDERMAILBOXMAPPED_dynamicstatus]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext USP_UPDATE_MAILBOXMAPPED_USERS   

    

-- ====================================================    

-- Author:  Ranjith          

-- Create date: 04/28/2015          

-- Description: To UPDATE the Remainder configuration to  MAILBOXES    

-- ====================================================    

CREATE PROCEDURE [dbo].[USP_UPDATE_REMAINDERMAILBOXMAPPED_dynamicstatus]    

(    

@raminsermailboxmapping int,    
@CountryId int,
@MailBoxId INT,
@FromStatusId int,
@ToStatusId int,   
@freq int,
@count int,
@isescalation int,
@isActive bit,
@createdby varchar(20),
@TemplateType int,
@Template nvarchar(max),
@EscalationMailId nvarchar(max)
)    

AS    

BEGIN    

 IF Exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE EmailboxremainId=@raminsermailboxmapping)

  BEGIN

   IF  exists (SELECT CountryId,EmailboxId FROM [dbo].[EmailboxRemainderConfig] WHERE CountryId=@CountryId and EmailboxId=@MailBoxId)

    BEGIN    

     UPDATE [EmailboxRemainderConfig] SET CountryId=@CountryId , EmailboxId=@MailBoxId,Frequency=@freq,[Count]=@count,IsEscalation=@isescalation,IsActive=@isActive, 
		ModifiedById=@createdby, ModifiedDate=getutcdate(),TemplateType=@TemplateType,Template=@Template,FromStatus=@FromStatusId,ToStatus=@ToStatusId,
		EscalationMailId=@EscalationMailId 
	 WHERE EmailboxremainId=@raminsermailboxmapping    

     SELECT 1   

    END    

   ELSE    

    SELECT 2  

  END

 ELSE

  SELECT 0   

END    

    

--select * from usermailboxmapping






GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_ROLEMAPPED_USERS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ====================================================      
-- Author:  Kalaichelvan KB            
-- Create date: 05/26/2014            
-- Description: To select the mapped users to the roles      
-- ====================================================      
CREATE PROCEDURE [dbo].[USP_UPDATE_ROLEMAPPED_USERS]      
(      
@UserRoleMappingId int,      
--@UserId VARCHAR(50),      
--@RoleId INT,  
--@LoggedinUserId VARCHAR(50),
@CountryIdsToMap VARCHAR(50)
)      
AS      
BEGIN      
 --IF Exists(select USERID, RoleId from UserRoleMapping where UserRoleMappingID=@UserRoleMappingID)       
 --  BEGIN    
    UPDATE UserRoleMapping SET CountriesMapped=@CountryIdsToMap where UserRoleMappingID=@UserRoleMappingID      
    SELECT 1      
 --  END    
 --ELSE      
 -- SELECT 0        
END     
--select * from userrolemapping where UserRoleMappingID=134






GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_Signature]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_UPDATE_Signature]                
(      
@SignId VARCHAR(10) ,    
@Signature VARCHAR(max),    
@UserID VARCHAR(25)    
)                   



AS                



BEGIN                 



IF  exists (select Signature from Signature where SignID=@SignId)        



  BEGIN           



   --Update Signature set Signature=@Signature, LastModifiedOn= getutcdate() FROM [dbo].[Signature]      

	Update Signature set Signature=@Signature, LastModifiedOn= Convert(Varchar(10),getutcdate(),103) FROM [dbo].[Signature]      

   where SignID = @SignId      



   SELECT 1      



  END           



 ELSE                  



  SELECT 0      



End
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_SUBPROCESSGROUPS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UPDATE_SUBPROCESSGROUPS]                  
(        
@SubProcessGroupID VARCHAR(10) ,   
@ProcessOwnerId VARCHAR(100) ,   
@SubProcessName VARCHAR(200),        
@ISACTIVE INT,        
@CREATEDBY VARCHAR(25),
@CountryId INT ,
@PreSubProcessname VARCHAR(200)    
)                     
AS                  
BEGIN 
  IF  EXISTS (select [SubProcessGroupID],SubprocessName from subprocessgroups where [SubProcessGroupID] =@SubProcessGroupID and SubprocessName=@PreSubProcessname)  
  BEGIN 
	if(@SubProcessName=@PreSubProcessname)
	--Begin
	  --if Not Exists(select SubprocessName from subprocessgroups where SubprocessName= @SubProcessName and CountryIdMapping=1)            
		  BEGIN
				Update subprocessgroups set SubProcessName=@SubProcessName, 
				ProcessOwnerId=@ProcessOwnerId,
				IsActive=@ISActive,
				CREATEDBYID=@CreatedBy,
				CREATEDDATE=getutcdate(),
				CountryIdMapping = @CountryId FROM [dbo].[subprocessgroups]  
				where [SubProcessGroupID] = @SubProcessGroupID   and   SubprocessName=@PreSubProcessname and CountryIdMapping=@CountryId   
				SELECT 1        
		  END   
	  Else if Not Exists(select SubprocessName from subprocessgroups where SubprocessName= @SubProcessName and CountryIdMapping=@CountryId)          
		  BEGIN
				Update subprocessgroups set SubProcessName=@SubProcessName, 
				ProcessOwnerId=@ProcessOwnerId,
				IsActive=@ISActive,
				CREATEDBYID=@CreatedBy,
				CREATEDDATE=getutcdate(),
				CountryIdMapping = @CountryId FROM [dbo].[subprocessgroups]  
				where [SubProcessGroupID] = @SubProcessGroupID   and   SubprocessName=@PreSubProcessname and CountryIdMapping=@CountryId   
				SELECT 1         
		  END  
	  Else
			BEGIn
				Select 0
			END  
	--END
  END        
 ELSE                    
  SELECT 0        
End





GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_SURVEYRESPONSE_COMMENTS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




/*
* CREATED BY : Pranay Ahuja
* CREATED DATE : 12/13/2016
* PURPOSE : TO update response and comments from mail 
*/
CREATE PROCEDURE [dbo].[USP_UPDATE_SURVEYRESPONSE_COMMENTS]
		(
		@CaseID int,@Response varchar(100),@Comments varchar(4000)
		)
AS
BEGIN
	--Update dbo.EmailMaster set SurveyResponse=@Response,SurveyComments=@Comments where CaseId=@CaseID;
	--Update dbo.EmailMaster set SurveyResponse=@Response,SurveyComments=Substring(@Comments, 1,Charindex('This e-mail', @Comments)-1) where CaseId=@CaseID;
	Update dbo.EmailMaster set SurveyResponse=@Response,
	SurveyComments = case when @Comments like '%This e-mail%' then Substring(ltrim(rtrim((@Comments))), 1,Charindex('This e-mail', ltrim(rtrim((@Comments))))-1)
	else ltrim(rtrim((@Comments))) end
	 where CaseId=@CaseID;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UPDATE_USERS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_UPDATE_USERS]  
(  
@USERID VARCHAR(25),  
@FIRSTNAME VARCHAR(100),  
@LASTNAME VARCHAR(100),  
@EMAIL VARCHAR(300),  
@Password VARCHAR(300),  
@ISACTIVE INT,  
@LoggedinUserId VARCHAR(25),
@TIMEZONE VARCHAR(100),
@OFFSET VARCHAR(100),
@SkillId VARCHAR(250),
@SkillDescription varchar(250)
)  
AS  
BEGIN  
 IF exists (select userid from usermaster WHERE USERID=@userid)  
  
	  BEGIN  
	   if(@password is not null)
		BEGIN
		 UPDATE USERMASTER SET FirstName=@FIRSTNAME, LastName=@LASTNAME, EMAIL=@EMAIL, Password=@password, Isactive=@ISACTIVE,   
		 ModifiedById=@LoggedinUserId, ModifiedDate=getutcdate(),TimeZone=@TIMEZONE,Offset=@OFFSET,SkillId=@SkillId,SkillDescription=@SkillDescription WHERE USERID=@userid  
		 Select 1  
		END
	   ELSE 
		BEGIN
		 UPDATE USERMASTER SET FirstName=@FIRSTNAME, LastName=@LASTNAME, EMAIL=@EMAIL, Isactive=@ISACTIVE,   
		 ModifiedById=@LoggedinUserId, ModifiedDate=getutcdate(),TimeZone=@TIMEZONE,Offset=@OFFSET,SkillId=@SkillId,SkillDescription=@SkillDescription WHERE USERID=@userid  
		 Select 1    
		END  
     END  
 ELSE  
   Select 0  
END  









GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateCaseDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*  
  
  
* CREATED BY : RAGUVARAN E  
  
* CREATED DATE : 06/09/2014  
 
* PURPOSE : TO UPDATE THE CASE DETAILS  
  
*/  
 
  
CREATE PROCEDURE [dbo].[USP_UpdateCaseDetails]  
 
(  
 
 @CASEID AS BIGINT,  
 
 @STATUS AS INT,  
    
 @COMMENTS AS VARCHAR(1000),  
 
 @USERID AS VARCHAR(50),  
  
 @STARTTIME AS DATETIME,  
  
 @CATEGORY as INT,
 @ApproverUserId as varchar(50) 
  
)  
  
AS  

BEGIN  
IF @CASEID IS NOT NULL AND @STATUS in(Select StatusId from dbo.status where IsOnHold='1')
BEGIN
DECLARE @PREVIOUSSTATUSID_AD INT  
    SELECT @PREVIOUSSTATUSID_AD = STATUSID FROM EMAILMASTER WHERE CASEID=@CASEID  
  
  

  UPDATE EMAILMASTER SET STATUSID=@STATUS,LASTCOMMENT=@COMMENTS,MODIFIEDBYID=@USERID, AutoReplyText=Null, AutoReplyReceivedTime=NULL  

  ,MODIFIEDDATE=getutcdate(),CategoryId=@CATEGORY ,ApproverUserId=@ApproverUserId
    WHERE CASEID=@CASEID  

  INSERT INTO EMAILAUDIT (CaseId,FromStatusId,ToStatusId,UserId,StartTime,EndTime)   

  VALUES (@CASEID,@PREVIOUSSTATUSID_AD,@STATUS,@USERID,@STARTTIME,getutcdate())  
  END
  
DECLARE @AUDITID AS BIGINT  
 
 IF @CASEID IS NOT NULL AND @STATUS not in(Select StatusId from dbo.status where IsOnHold='1')
 BEGIN   
  DECLARE @PREVIOUSSTATUSID INT  
    SELECT @PREVIOUSSTATUSID = STATUSID FROM EMAILMASTER WHERE CASEID=@CASEID  
  
  

  UPDATE EMAILMASTER SET STATUSID=@STATUS,LASTCOMMENT=@COMMENTS,MODIFIEDBYID=@USERID, AutoReplyText=Null, AutoReplyReceivedTime=NULL 
 

  ,MODIFIEDDATE=getutcdate(),CategoryId=@CATEGORY, RemainderMailCount=0,ApproverUserId=@ApproverUserId
 
  WHERE CASEID=@CASEID

  INSERT INTO EMAILAUDIT (CaseId,FromStatusId,ToStatusId,UserId,StartTime,EndTime)   

  VALUES (@CASEID,@PREVIOUSSTATUSID,@STATUS,@USERID,@STARTTIME,getutcdate())
  
 
  SELECT @AUDITID=@@IDENTITY  
 
  IF((@COMMENTS<>'' OR @COMMENTS IS NOT NULL) AND @AUDITID IS NOT NULL)  
  
  BEGIN  
  
   INSERT INTO EMAILQUERY (CASEID,EmailAuditID,QUERYTEXT,CREATEDBYID,CREATEDDATE)  
  
   VALUES (@CASEID,@AUDITID,@COMMENTS,@USERID,getutcdate())  
  
   Declare @AuditIDD bigint  
   select @AuditIDD=max(EmailAuditId) from EMAILAUDIT where CaseId=@CASEID and ToStatusId in (Select statusid from status where IsClarificationStatus='1') 
           update EMAILSENT set AuditID=@AuditIDD where CaseId=@CASEID and  
      EMailSentId in (select max(EMailSentId) from EMAILSENT where  CaseId=@CASEID)  
 END  

  IF(@COMMENTS not in ('Clarification user is in vacation','Clarification received through email','Clarification received through phone'))  

  BEGIN  

  INSERT INTO [dbo].[CategoryTransaction] (CASEID,AuditID,CateroryID,CREATEDDATE)  

  VALUES (@CASEID,@AUDITID,@CATEGORY,getutcdate())  

  END  
 
  IF @STATUS in (Select StatusId from dbo.Status where IsFinalStatus='1')  
 
  
  BEGIN  
 
   UPDATE EMAILMASTER SET COMPLETEDBYID=@USERID,COMPLETEDDATE=getutcdate(),AutoReplyText=Null, AutoReplyReceivedTime=NULL   

  
   WHERE CASEID=@CASEID  
 
  
  END  

 END  
 
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateCaseFromClarifNeededToClarifReceived]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[USP_UpdateCaseFromClarifNeededToClarifReceived]
(  
 @CaseIds as varchar(1000),  
 @LoggedInUserId as varchar(50)
)  
as  
Begin

declare @EmailBoxId int 
	   declare @SubProcessId int
	  declare @InitialStatus int
	  declare @FollowupStatus int
		create table #ActiveTable (CaseId bigint)

		insert into #ActiveTable(CaseId) 
		select *  from [SplitCaseID](@CaseIds, ',')
		 Select @EmailBoxId=Emailboxid from EmailMaster where Caseid in ( Select Top 1 CaseId from #ActiveTable)
	 Select @SubProcessId=SubprocessGroupId from Emailbox where Emailboxid=@EmailBoxId

	  if exists(select * from dbo.Status where SubProcessID=@SubProcessId and IsActive='1')
	Begin
	select @FollowupStatus=StatusId from dbo.Status where SubProcessID=@SubProcessId and IsFollowupStatus='1' and IsActive='1'
	
	end
	else
	begin
	select @FollowupStatus=StatusId from dbo.Status where SubProcessID is null and IsFollowupStatus='1' and IsActive='1'
	
	end

		declare @CaseId bigint

		while (select count(*) from #ActiveTable) > 0
		Begin
				select top 1 @CaseId = CaseId From #ActiveTable
				--Start
			
				DECLARE @AUDITID AS BIGINT
				DECLARE @STATUS AS INT
				DECLARE @COMMENTS AS VARCHAR(1000)
				set @STATUS = @FollowupStatus 
				set @COMMENTS = 'TL updated the status of the case. <br />Reason: Client has communicated over phone <br />OR
								 The communication is FYI from BO <br />OR The task is completed through a known alternative path.'

				IF @CASEID IS NOT NULL  
					 BEGIN 
							
						  DECLARE @PREVIOUSSTATUSID INT  
						    
						  SELECT @PREVIOUSSTATUSID = STATUSID FROM EMAILMASTER WHERE CASEID=@CaseId  
						    
						  UPDATE EMAILMASTER SET STATUSID=@STATUS,LASTCOMMENT=@COMMENTS,MODIFIEDBYID=@LoggedInUserId,MODIFIEDDATE=getutcdate()  
						  WHERE CASEID=@CaseId  
					    
						  INSERT INTO EMAILAUDIT (CaseId,FromStatusId,ToStatusId,UserId,StartTime,EndTime)   
						  VALUES (@CaseId,@PREVIOUSSTATUSID,@STATUS,@LoggedInUserId,getutcdate(),getutcdate())  
					    
						  SELECT @AUDITID=@@IDENTITY  
							IF((@COMMENTS<>'' OR @COMMENTS IS NOT NULL) AND @AUDITID IS NOT NULL)  
								BEGIN 
									INSERT INTO EMAILQUERY (CASEID,EmailAuditID,QUERYTEXT,CREATEDBYID,CREATEDDATE)  
									VALUES (@CaseId,@AUDITID,@COMMENTS,@LoggedInUserId,getutcdate())  
								END  
				  END 
					Delete #ActiveTable Where CaseId = @CaseId
		END
End

DROP TABLE #ActiveTable







GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateCaseOnEscalationMailTrigger]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[USP_UpdateCaseOnEscalationMailTrigger]
@CaseId bigint,
@MailCount int
AS    
BEGIN            
update emailmaster set EscalationCount= @MailCount, ModifiedDate=getutcdate() where CaseId=@CaseId
END 







GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateCaseOnRemainderMailTrigger]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE [dbo].[USP_UpdateCaseOnRemainderMailTrigger]
          
@CaseId bigint,
@RemainderMailCount int
          
AS          
BEGIN           
SET NOCOUNT ON;          

update emailmaster set RemainderMailCount= @RemainderMailCount, ModifiedDate=getutcdate() where CaseId=@CaseId
          
END 







GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateConfigureFields]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE proc [dbo].[USP_UpdateConfigureFields]   







@CountryID bigint,     







@MailboxID BigInt,        







@FieldName nvarchar(2000),        







@FieldTypeId BigInt,        







@FieldDataTypeID BigInt,        







@ValidationTypeID BigInt,        







@TextLength nvarchar(200) = null,        







@defaultValue nvarchar(200),        







@Active bit,        







@CreatedBy nvarchar(500),







@FieldMasterId bigint,



@FieldAliasName nvarchar(500),

@Mandatory int   







As        







Begin        







Declare @Retval int         







if not exists (Select StaticFieldName from Tbl_Master_StaticFields where ltrim(rtrim(lower(StaticFieldName))) = ltrim(rtrim(lower(@FieldName)))



  or ltrim(rtrim(lower(StaticFieldDisplayName))) = ltrim(rtrim(lower(@FieldName))))







	Begin



		if not exists (Select FieldName from Tbl_FieldConfiguration where ltrim(rtrim(lower(FieldName))) = ltrim(rtrim(lower(@FieldName))) and MailBoxID=@MailboxID and CountryID=@CountryID and Active=@Active)



		begin



			if  exists (Select FieldName from Tbl_FieldConfiguration where



			--ltrim(rtrim(lower(FieldName))) = ltrim(rtrim(lower(@FieldName)))  and 



			FieldMasterId = @FieldMasterId and MailBoxID=@MailboxID and CountryID=@CountryID)



				begin



					update Tbl_FieldConfiguration set CountryID=@CountryID, MailBoxID=@MailboxID,FieldName=@FieldName, FieldTypeId=@FieldTypeId,



			FieldDataTypeID=@FieldDataTypeID ,ValidationTypeID=@ValidationTypeID ,TextLength=@TextLength ,DefaultValue=@defaultValue ,Active=@Active ,



			ModifiedBy=@CreatedBy,ModifiedDate=getutcdate(),FieldAliasName=@FieldAliasName,FieldPrivilegeID=@Mandatory where FieldMasterId=@FieldMasterId	Set @Retval = 1        



					



					Select @Retval  



				end



			



			else







				begin







					Set @Retval = 4  -- already availble to same mailbox      







					Select @Retval  







				end



		end



		



		--Newly added by Varma



		else if ((Select FieldName from Tbl_FieldConfiguration where ltrim(rtrim(lower(FieldName))) = ltrim(rtrim(lower(@FieldName))) and FieldMasterId = @FieldMasterId) = @FieldName )



			begin



				update Tbl_FieldConfiguration set CountryID=@CountryID, MailBoxID=@MailboxID,FieldName=@FieldName, FieldTypeId=@FieldTypeId,



 			FieldDataTypeID=@FieldDataTypeID ,ValidationTypeID=@ValidationTypeID ,TextLength=@TextLength ,DefaultValue=@defaultValue ,Active=@Active   ,



			ModifiedBy=@CreatedBy,ModifiedDate=getutcdate(),FieldAliasName=@FieldAliasName,FieldPrivilegeID=@Mandatory  where FieldMasterId=@FieldMasterId	Set @Retval = 1        



			



				Select @Retval  



			end



		--End







		else



			begin



					Set @Retval = 3  -- already availble to same mailbox      



					Select @Retval 



			end



	End







Else







	Begin



		Set @Retval = 2  -- already availble to as master value       



		Select @Retval  



	End        



End







GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateDetailsForUnFlaggedCases]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[USP_UpdateDetailsForUnFlaggedCases]            
    
@Caseid Bigint,          
@UnflaggedBy Bigint,                      
@ModifiedDate varchar(7000)           

AS            
BEGIN             
SET NOCOUNT ON;            
            
            
--IF NOT EXISTS(SELECT CaseID FROM EMAILMASTER WHERE Subject = @Subject AND EMailReceivedDate = @Received_date)    
--BEGIN    
            
  Update dbo.FlagCaseMaster set  IsActive=0,ModifiedbyId=@UnflaggedBy,ModifiedDate=@ModifiedDate where CaseId=@Caseid         
  
--END            
               
END


GO
/****** Object:  StoredProcedure [dbo].[USP_Updatedynamicfields]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Updatedynamicfields]            
(            
@caseid BigInt,            
@xml XML,         
@userid nvarchar(50)
)            
AS           
BEGIN            
SET NOCOUNT ON;   
BEGIN TRAN TXN_INSERT        
 BEGIN TRY 

		 Declare @ClientransID bigint
		 Declare @temp table(FieldMasterID bigint,fieldvalue nvarchar(max),fieldtext nvarchar(max),islistvalue bigint)
		  insert into @temp 
		 select FieldMasterID,FieldValue,fieldtext,IsListValue from
		 (SELECT      

		  (XMLFILELIST.Item.value('@FieldMasterID', 'bigint')) as FieldMasterID ,     

		  (XMLFILELIST.Item.value('@FieldValue', 'nvarchar(max)'))  as FieldValue,

		  (XMLFILELIST.Item.value('@FieldText', 'nvarchar(max)'))  as FieldText,    

		  (XMLFILELIST.Item.value('@IsListValue', 'int'))  as IsListValue 

		  FROM @xml.nodes('/root/row') AS XMLFILELIST(Item)) as D

		  select * from @temp

		  declare @update int
		  
		  select @update=count(CaseID) from [Tbl_ClientTransaction] where CaseID=@caseid

		  if (@Update=0)

			  BEGIN
					Insert into [dbo].[Tbl_ClientTransaction](CaseID,FieldMasterID,FieldValue,IsListValue,CreatedBy,CreatedDate)
						select @caseid,FieldMasterID,FieldValue,IsListValue,@userid,getutcdate()from 
							(SELECT (XMLFILELIST.Item.value('@FieldMasterID', 'bigint')) as FieldMasterID ,     

							  (XMLFILELIST.Item.value('@FieldValue', 'nvarchar(max)'))  as FieldValue,    

							  (XMLFILELIST.Item.value('@IsListValue', 'int'))  as IsListValue 

							  FROM @xml.nodes('/root/row') AS XMLFILELIST(Item)) as A


					select @ClientransID=ClientTransactionID from [dbo].[Tbl_ClientTransaction] where IsListValue= 1 and CaseID=@caseid


					Insert into Tbl_SelectedListDetails(ClientTransactionID,DefaultListValueId)
					select @ClientransID,DLV.DefaultListValueId from Tbl_DefaultListValues DLV inner join 
					 Tbl_ClientTransaction CT on CT.FieldMasterID=DLV.FieldMasterId and CT.CaseID = @CaseID AND CT.IsListValue = 1 
					 and  DLV.DefaultListValueId in (select * from dbo.SplitCaseID((SELECT  distinct STUFF((SELECT ', ' + CAST(FieldValue AS VARCHAR(10)) [text()]
					 FROM [Tbl_ClientTransaction] 
					 WHERE CaseID = t.CaseID and isListValue = 1 AND CaseID=@CaseID
					 FOR XML PATH(''), TYPE)
					.value('.','NVARCHAR(MAX)'),1,2,' ') List_Output
						FROM [Tbl_ClientTransaction] t where t.isListValue = 1 AND t.CaseID=@CaseID),','))

					--select @ClientransID,DLV.DefaultListValueId from Tbl_DefaultListValues DLV inner join 
					-- Tbl_ClientTransaction CT on CT.FieldMasterID=DLV.FieldMasterId and CT.CaseID = @CaseID AND CT.IsListValue = 1 
					-- and  DLV.DefaultListValueId in (select * from dbo.SplitCaseID((select FieldValue from [Tbl_ClientTransaction] 
					-- where isListValue = 1 AND CaseID=@caseid),','))


					 Update CT set CT.FieldValue = T2.FieldText from Tbl_ClientTransaction CT    
					  Inner Join   @temp T2 on  CT.FieldMasterId = T2.FieldMasterID  
					   and CT.CaseID = @CaseID and CT.IsListValue = 1 
			END
		ELSE
			BEGIN

				Declare @ClientransID_del bigint
				select @ClientransID_del=ClientTransactionID from [dbo].[Tbl_ClientTransaction] where IsListValue= 1 and CaseID=@caseid

				delete from Tbl_SelectedListDetails where ClientTransactionID = @ClientransID_del

				delete from [Tbl_ClientTransaction] where CaseID = @CaseID
									
				Insert into [dbo].[Tbl_ClientTransaction](CaseID,FieldMasterID,FieldValue,IsListValue,CreatedBy,CreatedDate)
						select @caseid,FieldMasterID,FieldValue,IsListValue,@userid,getutcdate()from 
							(SELECT (XMLFILELIST.Item.value('@FieldMasterID', 'bigint')) as FieldMasterID ,     

							  (XMLFILELIST.Item.value('@FieldValue', 'nvarchar(max)'))  as FieldValue,    

							  (XMLFILELIST.Item.value('@IsListValue', 'int'))  as IsListValue 

							  FROM @xml.nodes('/root/row') AS XMLFILELIST(Item)) as A

				
					--Update [Tbl_ClientTransaction] set CaseID=@caseid, FieldMasterID=FieldMasterID_XML,FieldValue=FieldValue_XML,
					--	IsListValue=IsListValue_XML,CreatedBy=@userid,CreatedDate=getdate() from 
					--		(SELECT (XMLFILELIST.Item.value('@FieldMasterID', 'bigint')) as FieldMasterID_XML ,     

					--		  (XMLFILELIST.Item.value('@FieldValue', 'nvarchar(max)'))  as FieldValue_XML,    

					--		  (XMLFILELIST.Item.value('@IsListValue', 'int'))  as IsListValue_XML 

					--		  FROM @xml.nodes('/root/row') AS XMLFILELIST(Item)) as A

					--declare @ClientransID bigint
					--select  @ClientransID=ClientTransactionID from [dbo].[Tbl_ClientTransaction] where IsListValue= 1 and CaseID=1272

					select @ClientransID=ClientTransactionID from [dbo].[Tbl_ClientTransaction] where IsListValue= 1 and CaseID=@caseid

					Insert into Tbl_SelectedListDetails(ClientTransactionID,DefaultListValueId)
					select @ClientransID,DLV.DefaultListValueId from Tbl_DefaultListValues DLV inner join 
					 Tbl_ClientTransaction CT on CT.FieldMasterID=DLV.FieldMasterId and CT.CaseID = @CaseID AND CT.IsListValue = 1 
					 and  DLV.DefaultListValueId in (select * from dbo.SplitCaseID((SELECT  distinct STUFF((SELECT ', ' + CAST(FieldValue AS VARCHAR(10)) [text()]
					 FROM [Tbl_ClientTransaction] 
					 WHERE CaseID = t.CaseID and isListValue = 1 AND CaseID=@CaseID
					 FOR XML PATH(''), TYPE)
					.value('.','NVARCHAR(MAX)'),1,2,' ') List_Output
						FROM [Tbl_ClientTransaction] t where t.isListValue = 1 AND t.CaseID=@CaseID),','))

					--select @ClientransID,DLV.DefaultListValueId from Tbl_DefaultListValues DLV inner join 
					-- Tbl_ClientTransaction CT on CT.FieldMasterID=DLV.FieldMasterId and CT.CaseID = @CaseID AND CT.IsListValue = 1 
					-- and  DLV.DefaultListValueId in (select * from dbo.SplitCaseID((select FieldValue from [Tbl_ClientTransaction] 
					-- where isListValue = 1 AND CaseID=@caseid),','))


					 Update CT set CT.FieldValue = T2.FieldText from Tbl_ClientTransaction CT    
					  Inner Join   @temp T2 on  CT.FieldMasterId = T2.FieldMasterID  
					   and CT.CaseID = @CaseID and CT.IsListValue = 1 
			END

 END TRY        
    BEGIN CATCH        
          GOTO HandleError1       
    END CATCH       
    IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT        
    RETURN 1        

HandleError1:        
    IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT        
    RAISERROR('Error Inserting table Tbl_Comments', 16, 1)        
    RETURN -1     
end



 







GO
/****** Object:  StoredProcedure [dbo].[USP_Updatedynamicfields1]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_Updatedynamicfields1]            
(            
@caseid BigInt,            
@xml XML,         
@userid nvarchar(50)
)            
AS           
BEGIN            
SET NOCOUNT ON;   
BEGIN TRAN TXN_INSERT        
 BEGIN TRY 
		 Declare @temp table(FieldMasterID bigint,fieldvalue nvarchar(max),fieldtext nvarchar(max),islistvalue bigint)
		  insert into @temp 
		 select FieldMasterID,FieldValue,fieldtext,IsListValue from
		 (SELECT      

		  (XMLFILELIST.Item.value('@FieldMasterID', 'bigint')) as FieldMasterID ,     

		  (XMLFILELIST.Item.value('@FieldValue', 'nvarchar(max)'))  as FieldValue,

		  (XMLFILELIST.Item.value('@FieldText', 'nvarchar(max)'))  as FieldText,    

		  (XMLFILELIST.Item.value('@IsListValue', 'int'))  as IsListValue 

		  FROM @xml.nodes('/root/row') AS XMLFILELIST(Item)) as D

		  select * from @temp

		  Insert into [dbo].[Tbl_ClientTransaction](CaseID,FieldMasterID,FieldValue,IsListValue,CreatedBy,CreatedDate)
		select @caseid,FieldMasterID,FieldValue,IsListValue,@userid,getutcdate()from 

		(SELECT      

		  (XMLFILELIST.Item.value('@FieldMasterID', 'bigint')) as FieldMasterID ,     

		  (XMLFILELIST.Item.value('@FieldValue', 'nvarchar(max)'))  as FieldValue,    

		  (XMLFILELIST.Item.value('@IsListValue', 'int'))  as IsListValue 

		  FROM @xml.nodes('/root/row') AS XMLFILELIST(Item)) as A


		Declare @ClientransID bigint

		select @ClientransID=ClientTransactionID from [dbo].[Tbl_ClientTransaction] where IsListValue= 1 and CaseID=@caseid

		--select DLV.* from Tbl_DefaultListValues DLV inner join 
		-- Tbl_ClientTransaction CT on CT.FieldMasterID=DLV.FieldMasterId and CT.CaseID = '1161' 

		 --delete  from Tbl_DefaultListValues where DefaultListValueId=32
		 --delete from Tbl_ClientTransaction where caseID=1161

		Insert into Tbl_SelectedListDetails(ClientTransactionID,DefaultListValueId)
		select @ClientransID,DLV.DefaultListValueId from Tbl_DefaultListValues DLV inner join 
		 Tbl_ClientTransaction CT on CT.FieldMasterID=DLV.FieldMasterId and CT.CaseID = @CaseID AND CT.IsListValue = 1 
		 and  DLV.DefaultListValueId in (select * from dbo.SplitCaseID((select FieldValue from [Tbl_ClientTransaction] 
		 where isListValue = 1 AND CaseID=@caseid),','))


		 Update CT set CT.FieldValue = T2.FieldText from Tbl_ClientTransaction CT    
		  Inner Join   @temp T2 on  CT.FieldMasterId = T2.FieldMasterID  
		   and CT.CaseID = @CaseID and CT.IsListValue = 1 

--   delete from  [dbo].[Tbl_ClientTransaction]

--   delete from  [dbo].[Tbl_SelectedListDetails]
	 -- select * from [dbo].[Tbl_ClientTransaction]

	 -- select * from Tbl_SelectedListDetails
 END TRY        
    BEGIN CATCH        
          GOTO HandleError1       
    END CATCH       
    IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT        
    RETURN 1        

HandleError1:        
    IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT        
    RAISERROR('Error Inserting table Tbl_Comments', 16, 1)        
    RETURN -1     
end



 







GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateForwardToGMB]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UpdateForwardToGMB]

(

	@CASEID AS BIGINT,

	@FORWARDTOGMB as BIT

)

AS

BEGIN
Update EmailMaster set ForwardedToGMB=@FORWARDTOGMB where CaseId=@CASEID;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateIsSurveyMailSentFlag]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[USP_UpdateIsSurveyMailSentFlag]
		(
		@CaseID int,@IsMailSent bit
		)
AS
BEGIN
	Update dbo.EmailMaster set IsSurveySent=@IsMailSent where CaseId=@CaseID;
END
GO
/****** Object:  StoredProcedure [dbo].[USP_update-missedAttach]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[USP_update-missedAttach]            
(   @AttachmentID bigint,   
@AttachmentData IMAGE      
)           
AS            
BEGIN             
SET NOCOUNT ON;       

  BEGIN        
		UPDATE EMAILATTACHMENT SET Content=@AttachmentData WHERE AttachmentID=@AttachmentID 
  END        
             
END 






GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateOnReassign]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec USP_UpdateOnReassign '195174','21418','195174'
CREATE PROCEDURE [dbo].[USP_UpdateOnReassign]   
(  
  @AllocatedToId AS VARCHAR(20),              
  @CaseIds AS varchar(max),  
  @LoggedInUserId AS VARCHAR(20)  
)   
AS  
BEGIN  
  BEGIN TRANSACTION [TranReassign]   
  
  BEGIN TRY  
  
    --creating temp table to insert list of case ids  
    declare @tempTable table    
     (    
     CASE_ID varchar(max)    
     )   
       declare @EmailBoxId int 
	   declare @SubProcessId int
	  declare @InitialStatus int
	  declare @AssignedStatus int
	   declare @ReassignedStatus int
	   declare @OnHoldStatus int
    --inserting the list of case ids into temp table   
    insert into @tempTable select CaseId from EMailMaster where CaseId in (select items from dbo.splitcaseid(@CaseIds,','))     
      
	 Select @EmailBoxId=Emailboxid from EmailMaster where Caseid in ( Select Top 1 Case_id from @tempTable)
	 Select @SubProcessId=SubprocessGroupId from Emailbox where Emailboxid=@EmailBoxId

	 if exists(select * from dbo.Status where SubProcessID=@SubProcessId and IsActive='1')
	Begin
	select @InitialStatus=StatusId from dbo.Status where SubProcessID=@SubProcessId and IsInitalStatus='1' and StatusDescription!='Duplicate' and IsActive='1'
	select @AssignedStatus=StatusId from dbo.Status where SubProcessID=@SubProcessId and IsAssigned='1' and IsActive='1'
	select @ReassignedStatus=StatusId from dbo.Status where SubProcessID=@SubProcessId and IsReassignStatus='1' and IsActive='1'
	select @OnHoldStatus=StatusId from dbo.Status where SubProcessID=@SubProcessId and IsOnHold='1' and IsActive='1'

	end
	else
	begin
	select @InitialStatus=StatusId from dbo.Status where SubProcessID is null and IsInitalStatus='1' and StatusDescription!='Duplicate' and IsActive='1'
	select @AssignedStatus=StatusId from dbo.Status where SubProcessID is null and IsAssigned='1' and IsActive='1'
	select @ReassignedStatus=StatusId from dbo.Status where SubProcessID is null and IsReassignStatus='1' and IsActive='1'
	select @OnHoldStatus=StatusId from dbo.Status where SubProcessID is null and IsOnHold='1' and IsActive='1'
	
	end

	
	print @initialstatus;
    WHILE ((SELECT count(*) FROM @tempTable) >0)                           
     BEGIN  --begin 2    
          
      declare @FirstCaseId int    
      declare @FromStatus int   
      declare @ToStatus int 
	 
        
		  
      SELECT TOP 1 @FirstCaseId = CASE_ID FROM @tempTable    
          
      IF(@FirstCaseId IS NOT NULL)    
          
        BEGIN  --begin 3  
             
        select @FromStatus = STATUSID FROM EMailMaster WHERE CASEID= @FirstCaseId    
             
         if(@FromStatus = @InitialStatus) --Open  
          begin  
           set @ToStatus = @AssignedStatus --Assigned  
          end  
          
         else  
          begin  
           set @ToStatus = @ReassignedStatus --Reassigned   
          end  
                
        insert into EMailAudit (CaseId,FromStatusId,ToStatusId,UserId,StartTime,EndTime)    
        values (@FirstCaseId,@FromStatus,@ToStatus,@LoggedInUserId,getutcdate(),getutcdate())  
        
		 if(@FromStatus <> @InitialStatus) --Open  
          begin 
              if(@FromStatus <> @OnHoldStatus) 
                Begin
                  insert into EMailAudit (CaseId,FromStatusId,ToStatusId,UserId,StartTime,EndTime)    
			      values (@FirstCaseId,@ToStatus,@FromStatus,@AllocatedToId,getutcdate(),getutcdate())    
			    End
			  else
			    Begin
			      set @FromStatus = (select top 1 FromStatusId from EMailAudit where ToStatusId in (@OnHoldStatus) and FromStatusId Not in (@OnHoldStatus)order by EmailAuditId desc)
			      insert into EMailAudit (CaseId,FromStatusId,ToStatusId,UserId,StartTime,EndTime)    
			      values (@FirstCaseId,@ToStatus,@FromStatus,@AllocatedToId,getutcdate(),getutcdate()) 
			    End
          end  
        
               
        update EMailMaster   
        set StatusId = case when @FromStatus=@InitialStatus then @AssignedStatus else @FromStatus end, AssignedToId=@AllocatedToId, AssignedDate=getutcdate(), ModifiedById=@LoggedInUserId, ModifiedDate=getutcdate()  
        where CASEID = @FirstCaseId    
               
      END  --end 3  
          
       DELETE FROM @tempTable WHERE CASE_ID=@FirstCaseId    
         
     END --end 2  
  
  
   COMMIT TRANSACTION [TranReassign]  
  
  END TRY  
  BEGIN CATCH  
   ROLLBACK TRANSACTION [TranReassign]  
  END CATCH   
END



GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateOnRemapOfCategory]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_UpdateOnRemapOfCategory]   
(  
  @MappedCategory AS VARCHAR(200),              
  @CaseId AS int,
  @Modifiedby AS VARCHAR(50)
)   
AS  
BEGIN  
 BEGIN TRANSACTION [TranRecategorize] 
   BEGIN TRY  
declare @newcategoryid varchar(max)
declare @oldcategoryid varchar(max)

	select @oldcategoryid=ClassificationID from EMailMaster where CaseId=@CaseId		 

    select @newcategoryid=ClassificationID from InboundClassification where classifiactionDescription=@MappedCategory	

	insert into ClassificationAudit(CaseId,FromClassificationId,ToClassificationId,ModifiedById,IsRemapped,CreatedDate)
	values(@CaseId,@oldcategoryid,@newcategoryid,@Modifiedby,1,getutcDate())
	
	--insert into ReCategorized_Tbl (CaseId,InCorrectCategory,CorrectedCategory)    
 --   values (@CaseId,@oldcategoryname,@MappedCategory)  

	update EMailMaster set ClassificationID=@newcategoryid where CaseId=@CaseId

	COMMIT TRANSACTION [TranRecategorize]  
	  END TRY  
  BEGIN CATCH  
   ROLLBACK TRANSACTION [TranRecategorize]  
  END CATCH   
END
GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateOption]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[USP_UpdateOption]   
@OptionText nvarchar(200),  
@OptionValue int  ,   
@Active bit,        
@CreatedBy varchar(100),
@hdnddlid int,
@fieldmasterid int      

As        
Begin        
Declare @Retval int         
BEGIN TRAN TXN_INSERT        
BEGIN TRY        
if  exists (select OptionText from [dbo].[Tbl_DefaultListValues] where  FieldMasterId=@fieldmasterid and OptionText =  @OptionText and  Active=@Active )

	begin

	set @Retval =2
	select @Retval
end
else
begin
	Update [dbo].[Tbl_DefaultListValues] set OptionText=@OptionText,Active=@Active 
	,ModifiedBy=@CreatedBy,ModifiedDate=GETUTCDATE()
where DefaultListValueId =@hdnddlid and FieldMasterId=@fieldmasterid
	set @Retval =1
	select @Retval
	end































END TRY        































































            BEGIN CATCH        































































                  GOTO HandleError1        































































            END CATCH        































































            IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT        































































            RETURN 1        































































      HandleError1:        































































            IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT        































































            RAISERROR('Error Insert table Tbl_FieldConfiguration', 16, 1)        































































            RETURN -1        































































        































































        































































        































































End

 









GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateQCAssignPeerToPeer]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================              
-- Author:  <SAKTHI>              
-- Create date: <28/05/2014>              
-- Description: <QC ASSIGN PEER TO PEER>              
-- =============================================         
--EXEC [dbo].[USP_UpdateQCAssignPeerToPeer] '254649','5','2,3'   
CREATE Procedure [dbo].[USP_UpdateQCAssignPeerToPeer]          
 (          
  @QCUSERID AS VARCHAR(20),          
  @EMAILBOXID AS INT,
  @CASEID AS varchar(max)
 )          
AS          
BEGIN   

 
 DECLARE @CASETABLE TABLE
 (
 CASE_ID varchar(max)
 )
 
 INSERT INTO @CASETABLE 
 SELECT CASEID FROM EMAILMASTER WHERE CASEID IN (select items from dbo.splitcaseid(@CASEID,',')) 
 
WHILE ((SELECT count(*) FROM @CASETABLE) >0)                       
BEGIN  
 
 DECLARE @FIRSTCASEID INT
 DECLARE @FROMSTATUS INT
 
 SELECT TOP 1 @FIRSTCASEID = CASE_ID FROM @CASETABLE
 
 
 IF(@FIRSTCASEID IS NOT NULL)
 
	 BEGIN
	 
			 SELECT @FROMSTATUS = STATUSID FROM EMAILMASTER WHERE CASEID= @FIRSTCASEID
			  
			 --INSERT INTO EMAILAUDIT (CaseId,FromStatusId,ToStatusId,UserId,StartTime,EndTime)
			 --VALUES (@FIRSTCASEID,@FROMSTATUS,6,@QCUSERID,GETDATE(),GETDATE())
			 
			 UPDATE EMAILMASTER SET MODIFIEDBYID=@QCUSERID,
			  MODIFIEDDATE=GETUTCDATE(),QCUSERID=@QCUSERID
			  WHERE CASEID = @FIRSTCASEID
			 
			-- SET @FIRSTCASEID=NULL
END
 
 DELETE FROM @CASETABLE WHERE CASE_ID=@FIRSTCASEID
 
 
END
 
 END
 
 
 







GO
/****** Object:  StoredProcedure [dbo].[USP_USER_MAILBOXMAP]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ====================================================    
-- Author:  Kalaichelvan KB          
-- Create date: 05/26/2014          
-- Description: To map users to the MailBox
-- ====================================================  
CREATE PROCEDURE [dbo].[USP_USER_MAILBOXMAP]    
(    
@UserId VARCHAR(50),    
@MailBoxId INT,  
@LoggedinUserId VARCHAR(50)  
)    
AS    
BEGIN    
 IF EXISTS (SELECT USERID FROM USERMASTER WHERE USERID=@USERID)       
  BEGIN     
   IF not exists (select USERID, MailBoxId from UserMailBoxMapping where USERID=@UserId and MailBoxId=@MailBoxId)    
    BEGIN    
     INSERT INTO UserMailBoxMapping (USERID, MailBoxId, CreatedById, CreatedDate, ModifiedById, ModifiedDate) 
     VALUES (@USERID, @MailBoxId, @LoggedinUserId , getutcdate(), @LoggedinUserId, getutcdate()) 
     SELECT 1    
    END    
   ELSE    
    SELECT 2     
  END    
 ELSE    
  SELECT 0    
END 









GO
/****** Object:  StoredProcedure [dbo].[USP_USER_ROLEMAP]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext USP_USER_ROLEMAP    
-- ==========================================        
-- Author:  Kalaichelvan KB              
-- Create date: 05/26/2014              
-- Description: To map the roles to the user         
-- ==========================================        
CREATE PROCEDURE [dbo].[USP_USER_ROLEMAP]        
(        
@UserId VARCHAR(50),        
@RoleId INT,      
@LoggedinUserId VARCHAR(50),  
@CountryIdsToMap VARCHAR(20)
)        
AS        
BEGIN        
 IF EXISTS (SELECT USERID FROM USERMASTER WHERE USERID=@USERID)            
  BEGIN         
   IF not exists (select USERID, ROLEID from UserRoleMapping where USERID=@UserId and ROLEID=@ROlEID)        
    BEGIN        
     INSERT INTO UserRoleMapping (USERID, ROLEID, CreatedByID, CreatedDate, CountriesMapped) VALUES     
     (@USERID, @ROLEID, @LoggedinUserId , getutcdate(), @CountryIdsToMap)      
     SELECT 1        
    END        
   ELSE        
    SELECT 2         
  END        
 ELSE        
  SELECT 0        
         
END 








GO
/****** Object:  StoredProcedure [dbo].[USP_USERLOGIN]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--sp_helptext USP_USERLOGIN
--sp_helptext USP_USERSESSION  
--sp_helptext USP_USERLOGIN    
    
 --select * from UserMaster    
    
--insert into UserMaster values (254649,'Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, 254649, getdate())    
-- =============================================          
-- Author:  Kalaichelvan KB          
-- Create date: 05/23/2014          
-- Description: To check whether the user exists    
-- =============================================      
    
--Exec USP_USERLOGIN '254649','dGVzdA=='          
        
CREATE PROC [dbo].[USP_USERLOGIN]    
@UserID varchar(20),    
@Password Varchar(50)    
--@success int out     
AS            
Begin    
 if exists (Select UserId from USERMASTER Where Userid=@UserID)    
 BEGIN     
  if exists (select userid, password from usermaster where userid=@userid and password=@password)    
  if exists (select roleid from userrolemapping where userid=@userid and roleid !=1)    
  BEGIN
	Select 1    
  END
  ELSE SELECT 2    
 END       
Select 0    
END        
    
 --  group by UR.RoleDescription    
--   select * from usermaster    
-- select * from UserRoleMapping     
-- select * from userrole    
    
---update usermaster set password='dGVzdA==' where userid='254649'






GO
/****** Object:  StoredProcedure [dbo].[USP_USERLOGIN1]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext USP_USERLOGIN
--sp_helptext USP_USERSESSION  
--sp_helptext USP_USERLOGIN    
    
 --select * from UserMaster    
    
--insert into UserMaster values (254649,'Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, 254649, getdate())    
-- =============================================          
-- Author:  Kalaichelvan KB          
-- Create date: 05/23/2014          
-- Description: To check whether the user exists    
-- =============================================      
    
--Exec USP_USERLOGIN '254649','dGVzdA=='          
        
CREATE PROC [dbo].[USP_USERLOGIN1]    
@UserID varchar(20),    
@Password Varchar(50)    
--@success int out     
AS            
Begin  
Declare @Localvar INT  
 if exists (Select UserId from USERMASTER Where Userid=@UserID)    
 BEGIN     
  if exists (select userid, password from usermaster where userid=@userid and password=@password)    
  if exists (select roleid from userrolemapping where userid=@userid and roleid !=1)   
  begin
 SET @Localvar=1
  --Select 1 
 
  if(@Localvar=1)
  begin
  if ((select DATEDIFF(DD,PasswordCreatedDate,GETDATE())from UserMaster where userid=@userid)>=15)
  Select 3
  ELSE SELECT 4  
 END
 end
  ELSE SELECT 2    
 END       
Select 0    
END        
    
 --  group by UR.RoleDescription    
--   select * from usermaster    
-- select * from UserRoleMapping     
-- select * from userrole    
    
---update usermaster set PasswordCreatedDate='2017-01-01' where userid='572814'
GO
/****** Object:  StoredProcedure [dbo].[USP_USERSESSION]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--sp_helptext USP_USERSESSION
--sp_helptext USP_USERSESSION  
  
    
--insert into UserMaster values (254649,'Kalaichelvan', 'KB', 'Kalaichelvan.KB@Cogniznant.com', 'sXmehjaISGw7EGi/Ogvt7A==', 1, 254649, getdate())    
-- =============================================          
-- Author:  Kalaichelvan KB          
-- Create date: 05/23/2014          
-- Description: To MAntain the session    
-- =============================================      
    
--Exec USP_USERLOGIN '254649','dGVzdA=='          
        
CREATE PROC [dbo].[USP_USERSESSION]    
(  
@UserID varchar(20)    
)  
AS            
BEGIN     
 SELECT  UM.UserId, UM.FirstName as [First Name], UM.LastName as [Last Name], UM.Password,UM.TimeZone,Um.Offset,   
 UR.USERROLEId as RoleID, UR.RoleDescription  as RoleName         
 FROM [dbo].[USERMASTER] UM     
 inner join UserRoleMapping UsrMap on UsrMap.userid = um.userid      
 inner join UserRole UR on UR.UserRoleId = UsrMap.roleid    
 WHERE UM.[Userid]=@UserID AND IsActive <> '0' order by UsrMap.RoleId asc  
END       
    
 --  group by UR.RoleDescription    
--   select * from usermaster    
-- select * from UserRoleMapping     
-- select * from userrole    
    
---update usermaster set password='dGVzdA==' where userid='254649'








GO
/****** Object:  StoredProcedure [dbo].[USP_VALIDATE_TL_LOGIN]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =================================================================
-- Author:  Kalaichelvan KB            
-- Create date: 07/11/2014            
-- Description: To check whether the TL has been mapped to any Mailbox
-- =================================================================        
             
          
CREATE PROC [dbo].[USP_VALIDATE_TL_LOGIN]      
@USERID VARCHAR(20)     
AS              
BEGIN      
 IF EXISTS (SELECT USERID FROM UserMailBoxMapping WITH(NOLOCK) WHERE USERID=@USERID) 
  SELECT 1
 ELSE SELECT 2      
END  
    
--   select * from usermaster      
-- select * from UserRoleMapping       
-- select * from userrole 
--select * from  UserMailBoxMapping    

--if exists (Select UserId, roleid from UserRoleMapping Where Userid=254650 and roleid=2)






GO
/****** Object:  StoredProcedure [dbo].[USP_VALIDATEPASSWORD]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================    
-- Author:  Kalaichelvan.K.B.  
-- Create date: 05/30/2014    
-- Description: To VALIDATE the OLD Password
-- ============================================= 
CREATE Procedure [dbo].[USP_VALIDATEPASSWORD]
(  
 @UserId varchar(25),          
 @OldPassword varchar(200) 
)  
AS  
BEGIN    
SELECT COUNT(*) FROM USERMASTER WHERE [UserId] = @UserId and password=@OldPassword
END






GO
/****** Object:  StoredProcedure [dbo].[USP_VALIDATEUSERID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================    

-- Author:  Kalaichelvan.K.B.  

-- Create date: 05/30/2014    

-- Description: To VALIDATE the USER ID

-- ============================================= 

CREATE Procedure [dbo].[USP_VALIDATEUSERID]

(  

 @UserId varchar(25)
 --@PasswordCreatedDate datetime

)  

AS  

BEGIN    

IF EXISTS (SELECT UserID FROM USERMASTER WHERE [UserId] = @UserId and IsActive=1)
	SELECT 1
Else
	select 0
END
GO
/****** Object:  StoredProcedure [dbo].[USP_VIP_User]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[USP_VIP_User] 

As  
Begin  

	Select EmailAddress from VIPUsers where IsActive=1
End
 




GO
/****** Object:  StoredProcedure [dbo].[WriteToFile]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[WriteToFile]
 
@File        VARCHAR(2000),
@Text        VARCHAR(2000)
 
AS 
 
BEGIN 
 
DECLARE @OLE            INT 
DECLARE @FileID         INT 
 
 
EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT 
       
EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @File, 8, 1 
     
EXECUTE sp_OAMethod @FileID, 'WriteLine', Null, @Text
 
EXECUTE sp_OADestroy @FileID 
EXECUTE sp_OADestroy @OLE 
 
END 




GO
/****** Object:  UserDefinedFunction [dbo].[ChangeDatesAsPerUserTimeZone]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[ChangeDatesAsPerUserTimeZone](@DatetobeConverted datetime, @Offset varchar(15))
RETURNS VARCHAR(30)

AS 
BEGIN

DECLARE @UserTimeZoneTimings NVARCHAR(20)

SET @UserTimeZoneTimings =
 Convert(Varchar(10),CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,@DatetobeConverted),@Offset)),101) 
 +' '+
 Convert(Varchar(10),CONVERT(datetime,SWITCHOFFSET(CONVERT(datetimeoffset,@DatetobeConverted),@Offset)),108)
 
 
 return @UserTimeZoneTimings
 
 END
GO
/****** Object:  UserDefinedFunction [dbo].[ConvertDelimitedListIntoTable]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ConvertDelimitedListIntoTable] (
     @list NVARCHAR(MAX) ,@delimiter CHAR(1) )
RETURNS @table TABLE ( 
     item VARCHAR(255) NOT NULL )
AS 
    BEGIN
        DECLARE @pos INT ,@nextpos INT ,@valuelen INT

        SELECT  @pos = 0 ,@nextpos = 1

        WHILE @nextpos > 0 
            BEGIN
                SELECT  @nextpos = CHARINDEX(@delimiter,@list,@pos + 1)
                SELECT  @valuelen = CASE WHEN @nextpos > 0 THEN @nextpos
                                         ELSE LEN(@list) + 1
                                    END - @pos - 1
                
				if(@list is not null)
				begin 
					INSERT  @table ( item )
					VALUES  ( CONVERT(INT,SUBSTRING(@list,@pos + 1,@valuelen)) )
				end 
                SELECT  @pos = @nextpos

            END

        DELETE  FROM @table
        WHERE   item = ''

        RETURN 
    END


--declare @category varchar(200)

--set @category='5,21'  

--select * from emailmaster where CategoryId in (@category)
GO
/****** Object:  UserDefinedFunction [dbo].[fn_RowConcatenation]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_RowConcatenation](@String varchar(40))          
returns varchar(1000)          
as          
begin    

    declare @val nvarchar(1000)
	select @val= STUFF((select ',' + Country from(
	select * from SplitcaseID(@String,',') where items  in (
	select countryID from country	)) as A
	inner join country	C
	on A.Items=C.CountryID FOR XML PATH (''), type).value('.', 'NVARCHAR(MAX)'),1,1,'')
	return @val
	
end  






GO
/****** Object:  UserDefinedFunction [dbo].[fn_TAT_ExcludeCutOffTime]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Function [dbo].[fn_TAT_ExcludeCutOffTime]  
(  
@FromDate datetime,  
@Todate datetime  
)  
returns decimal(18,2)  
As  
Begin  
Declare @FrmStr int  
Declare @ToStr int  
Set @FrmStr=datepart(dw,@FromDate) -- Get day of a week  
Set @ToStr=datepart(dw,@Todate) -- Get day of a week  
  
-- Calculate Total minutes  
Declare @TotalMins bigint  
If (@FrmStr=1 or @FrmStr=7) -- Sun,Sat  
Begin  
 If (@FrmStr=1) -- Sun  
  Set @FromDate=dateadd(dd,1,convert(varchar,@FromDate,111)) -- Set as Monday 00:00:00:000  
 Else -- Sat  
  Set @FromDate=dateadd(dd,2,convert(varchar,@FromDate,111)) -- Set as Monday 00:00:00:000  
End  
If (@ToStr=1 or @ToStr=7) --Sun,Sat  
Begin  
 If (@ToStr=1) -- Sun  
  Set @Todate=dateadd(dd,-1,convert(varchar,@Todate,111)) -- Set as Saturday 00:00:00:000  
 Else -- Sat  
  Set @Todate=convert(varchar,@Todate,111) --Set as Saturday 00:00:00:000  
End  
Set @TotalMins=DateDiff(ss,@FromDate,@Todate)  
  
-- Calculate Holidays in minutes  
Declare @Start datetime  
Declare @End datetime  
Declare @HolidayMins bigint  
Set @HolidayMins=0   
-- In Between Holidays  
-- In Between Holidays  
Select @HolidayMins=isnull(sum(TotalMinutes),0)*60 from Holiday (NOLOCK)   
where (HolidayDate between @FromDate and @ToDate) and (dateadd(dd,1,HolidayDate) between @FromDate and @ToDate)  
-- @FromDate lies in Holiday  
Select @End=dateadd(dd,1,HolidayDate) from Holiday (NOLOCK)   
where HolidayDate<@FromDate and dateadd(dd,1,HolidayDate)>@FromDate and TotalMinutes!=0  
If(@End is not null)  
 Set @HolidayMins=@HolidayMins+DateDiff(ss,@FromDate,@End)  
-- @ToDate lies in Holiday  
Select @Start=HolidayDate from Holiday (NOLOCK)   
where HolidayDate<@ToDate and dateadd(dd,1,HolidayDate)>@ToDate and TotalMinutes!=0  
If(@Start is not null)  
 Set @HolidayMins=@HolidayMins+DateDiff(ss,@Start,@ToDate) 
-- Count no. of CutOff time within @FromDate and @ToDate  
Declare @Cnt int  
Set @Cnt=0  
While(@FromDate<@Todate)  
Begin  
If (datepart(dw,@FromDate)=1)  
 Begin  
 Set @Cnt=@Cnt+1  
 Set @FromDate=@FromDate+7  
 End  
Else  
 Set @FromDate=@FromDate+1  
End  
  
Declare @var bigint
Set @var=@TotalMins-@Cnt*172800-@HolidayMins -- 2880 is CutOff time duration in minutes  
If(sign(@var)=-1)
	Set @var=0
Return @var 
End  







GO
/****** Object:  UserDefinedFunction [dbo].[fn_TAT_ExcludeCutOffTimeSatSun]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  UserDefinedFunction [dbo].[fn_TAT_ExcludeCutOffTime]    Script Date: 11/03/2016 14:49:03 ******/

CREATE Function [dbo].[fn_TAT_ExcludeCutOffTimeSatSun]  
(  
@FromDate datetime,  
@Todate datetime  
)  
returns decimal(18,2)  
--returns datetime
--returns int 
As  
Begin  
Declare @FrmStr int  
Declare @ToStr int

Set @FrmStr=datepart(dw,@FromDate) -- Get day of a week  
Set @ToStr=datepart(dw,@Todate) -- Get day of a week  
  
-- Calculate Total minutes  
Declare @TotalMins bigint  
If (@FrmStr=1 or @FrmStr=7 or @FrmStr=2) -- Sun,Sat  
Begin  
 If (@FrmStr=1) -- Sun  
  Set @FromDate=dateadd(hh,31,convert(DateTime,Convert(Date,@FromDate))) -- Set as Monday 07:00:00:000  
 Else IF ( DATEPART(DW, @FromDate) =7 AND DATEPART(HOUR,@FromDate) >= 3  ) -- Sat  
  --Set @FromDate=dateadd(hh,(55-DATEPART(HOUR,@FromDate)),@FromDate) -- Set as Monday 07:00:00:000 
  Set @FromDate= DATEADD(hour,DATEDIFF(hour,0,dateadd(hh,(55-DATEPART(HOUR,@FromDate)),@FromDate)),0)-- Set as Monday 07:00:00:000 
 Else IF(DATEPART(DW, @FromDate) =7 AND DATEPART(HOUR,@FromDate) =0 )
  Set @FromDate=dateadd(hh,55,convert(DateTime,Convert(Date,@FromDate))) -- Set as Monday 07:00:00:000 
 Else IF(DATEPART(DW, @FromDate) =2 AND DATEPART(HOUR,@FromDate) < 7  )
Set @FromDate= DATEADD(hour,DATEDIFF(hour,0,dateadd(hh,(7-DATEPART(HOUR,@FromDate)),@FromDate)),0)-- Set as Monday 07:00:00:000 
End  
If (@ToStr=1 or @ToStr=7) --Sun,Sat  
Begin  
 If (@ToStr=1) -- Sun  
  --Set @Todate=dateadd(hh,-((DATEPART(HOUR,@Todate)+21)),@Todate) -- Set as Saturday 03:00:00:000
  Set @Todate=DATEADD(hour,DATEDIFF(hour,0,dateadd(hh,-((DATEPART(HOUR,@Todate)+21)),@Todate)),0) 
 Else -- Sat  
  --Set @Todate=dateadd(hh,-((DATEPART(HOUR,@Todate)-3)),@Todate) --Set as Saturday 03:00:00:000 
  Set @Todate= DATEADD(hour,DATEDIFF(hour,0,dateadd(hh,-((DATEPART(HOUR,@Todate)-3)),@Todate)),0) 
End  
Set @TotalMins=DateDiff(ss,@FromDate,@Todate)  

DECLARE @FinalFromDate datetime
DECLARE @FinalToDate datetime

SET @FinalFromDate=@FromDate
SET @FinalToDate=@Todate

  
-- Calculate Holidays in minutes  
Declare @Start datetime  
Declare @End datetime  
Declare @HolidayMins bigint  
Set @HolidayMins=0   
 --In Between Holidays 
Select @HolidayMins=isnull(sum(TotalMinutes),0)*60 from Holiday (NOLOCK)   
where (HolidayDate between @FromDate and @ToDate) and (dateadd(dd,1,HolidayDate) between @FromDate and @ToDate)  
-- @FromDate lies in Holiday  
Select @End=dateadd(dd,1,HolidayDate) from Holiday (NOLOCK)   
where HolidayDate<@FromDate and dateadd(dd,1,HolidayDate)>@FromDate and TotalMinutes!=0  
If(@End is not null)  
 Set @HolidayMins=@HolidayMins+DateDiff(ss,@FromDate,@End)  
-- @ToDate lies in Holiday  
Select @Start=HolidayDate from Holiday (NOLOCK)   
where HolidayDate<@ToDate and dateadd(dd,1,HolidayDate)>@ToDate and TotalMinutes!=0  
If(@Start is not null)  
 Set @HolidayMins=@HolidayMins+DateDiff(ss,@Start,@ToDate) 

-- Count no. of Monday within @FromDate and @ToDate  
Declare @Cnt int  
Set @Cnt=1  
--While(Datepart(day,@FinalFromDate)<datepart(day,@FinalToDate) AND Datepart(month,@FinalFromDate)<datepart(month,@FinalToDate))  
while(DATEADD(ms, -DATEPART(ms, @FinalFromDate), @FinalFromDate) < DATEADD(ms, -DATEPART(ms, @FinalToDate), @FinalToDate) )
--while(@FinalFromDate<@FinalToDate)
Begin  
If (datepart(dw,@FinalFromDate)=2)  
 Begin  
   
 SET @FinalFromDate=DateAdd(d, 1, @FinalFromDate)
Set @Cnt=@Cnt+1  
 End  
 ELse
BEGIN
   Set @FinalFromDate=DateAdd(d, 1, @FinalFromDate) 
 END
End  
  
Declare @var bigint
IF ( DATEPART(DW, @FromDate) =2 AND DATEPART(HOUR,@FromDate) >= 7 AND DateDiff(WK,@FromDate,@Todate)=1 AND DATEPART(DW, @Todate) =2)
Set @var=@TotalMins-((DateDiff(WK,@FromDate,@Todate)*172800)-(DateDiff(WK,@FromDate,@Todate)*10800))-@HolidayMins -(1*25200)-- 2880 is CutOff time duration in minutes  
ELSE IF ( DATEPART(DW, @FromDate) =2 AND DATEPART(HOUR,@FromDate) >= 7 )
Set @var=@TotalMins-((DateDiff(WK,@FromDate,@Todate)*172800)-(DateDiff(WK,@FromDate,@Todate)*10800))-@HolidayMins-((@Cnt-2)*25200)
Else IF(DateDiff(WK,@FromDate,@Todate)>=1)
Set @var=@TotalMins-((DateDiff(WK,@FromDate,@Todate)*172800)-(DateDiff(WK,@FromDate,@Todate)*10800))-@HolidayMins-((@Cnt)*25200) -- 2880 is CutOff time duration in minutes 

Else
Set @var=@TotalMins-((DateDiff(WK,@FromDate,@Todate)*172800)-(DateDiff(WK,@FromDate,@Todate)*10800))-@HolidayMins-- 2880 is CutOff time duration in minutes  
--Set @var=11111
If(sign(@var)=-1)
      Set @var=0
Return @var
--Return @Cnt 
--Return @FromDate
--Return @ToDate
--Return @Cnt 
--Return @FinalFromDate
End
GO
/****** Object:  UserDefinedFunction [dbo].[fn_TimeFormat]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select dbo.fn_DateFormat( 86400)
CREATE FUNCTION [dbo].[fn_TimeFormat]  
(  
@duration bigint -- in seconds
)  
returns varchar(100)  
As  
Begin  

declare @var varchar(100)

SELECT @var = CASE WHEN LEN(H) = 1
		THEN '0' + h
		ELSE h END
		+ ':' +
		CASE WHEN LEN(m) = 1
		THEN '0' + m
		ELSE m END
		+ ':' + 
		CASE WHEN LEN(s) = 1
		THEN '0' + s
		ELSE s END
		FROM
		(
select
  CAST(@duration / 3600 AS VARCHAR(10)) as [h],
  CAST(@duration % 3600 / 60 AS VARCHAR(10)) as [m],
  CAST(@duration % 3600 % 60 AS VARCHAR(10))as [s]) AS X

Return @var 


End







GO
/****** Object:  UserDefinedFunction [dbo].[Split]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[Split](@String varchar(8000), @Delimiter char(1))        
returns @temptable TABLE (items varchar(8000))        
as        
begin        
    declare @idx int        
    declare @slice varchar(8000)        
    select @idx = 1        
        if len(@String)<1 or @String is null  return        
    while @idx!= 0        
    begin        
        set @idx = charindex(@Delimiter,@String)        
        if @idx!=0        
            set @slice = left(@String,@idx - 1)        
        else        
            set @slice = @String        
        if(len(@slice)>0)   
            insert into @temptable(Items) values(@slice)        
        set @String = LTrim(Rtrim(right(@String,len(@String) - @idx)))        
        if len(@String) = 0 break        
    end    
return        
end


GO
/****** Object:  UserDefinedFunction [dbo].[SplitCaseID]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[SplitCaseID](@String varchar(8000), @Delimiter char(1))        
returns @temptable TABLE (items varchar(8000))        
as        
begin  
--Declare @String varchar(8000)
--Declare @Delimiter char(1)
--Declare @temptable TABLE 
--(items varchar(8000))

--set @String='SVC895MEE,SVC795MEE,SVC995MEE,SVC995ME2' 
--set @Delimiter=','
     
    declare @idx int        
    declare @slice varchar(8000)        
       
    select @idx = 1        
        if len(@String)<1 or @String is null  return        
       
    while @idx!= 0        
    begin    
  
        set @idx = charindex(@Delimiter,@String)        
        if @idx!=0        
            set @slice = left(@String,@idx - 1)        
        else        
            set @slice = @String        
           
        if(len(@slice)>0)   
            insert into @temptable(Items) values(@slice)        
  
        set @String = right(@String,len(@String) - @idx)        
--        if len(@String) = 0 break        
    end    

return    
end


--ALTER PROCEDURE [dbo].[GetImageDetails]
--(

--Declare @BatchSplit varchar(20)
----)      
----AS  
--
--SET @BatchSplit='SVC895MEE,SVC795MEE,SVC995MEE,SVC995ME2'
--
--select items from  dbo.SplitCaseID(@BatchSplit,',')
--select charindex(',',@BatchSplit) 











GO
/****** Object:  Table [dbo].[AccessControlMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AccessControlMaster](
	[PageId] [int] NOT NULL,
	[AccessMode] [nvarchar](10) NOT NULL,
	[RoleID] [int] NOT NULL,
	[SubProcessID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[AttachmentType]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AttachmentType](
	[AttachmentTypeID] [int] IDENTITY(1,1) NOT NULL,
	[AttachmentType] [varchar](100) NOT NULL,
 CONSTRAINT [PK_AttachmentType] PRIMARY KEY CLUSTERED 
(
	[AttachmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[AutoIndexingConfiguration]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AutoIndexingConfiguration](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[IndexedField] [varchar](250) NOT NULL,
	[StartText] [varchar](250) NULL,
	[EndText] [varchar](250) NULL,
	[IsActive] [bit] NULL,
	[RetrieveFrom] [varchar](50) NOT NULL,
	[FieldMasterId] [bigint] NULL,
	[MailBoxId] [bigint] NULL,
	[ContainsText] [varchar](250) NULL,
	[DetectDuplicate] [bit] NULL,
	[IndexedText] [varchar](250) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CaseCreationConfiguration]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CaseCreationConfiguration](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[KeywordInSubject] [varchar](250) NOT NULL,
	[Include] [bit] NOT NULL,
	[IsActive] [bit] NULL,
	[MailBoxId] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CategoryTransaction]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CategoryTransaction](
	[CategoryTransID] [bigint] IDENTITY(1,1) NOT NULL,
	[Caseid] [bigint] NOT NULL,
	[AuditID] [bigint] NOT NULL,
	[CateroryID] [bigint] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_CategoryTransaction] PRIMARY KEY CLUSTERED 
(
	[CategoryTransID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClarificationResetReason]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ClarificationResetReason](
	[ResetReasonID] [int] IDENTITY(1,1) NOT NULL,
	[ResetReason] [nvarchar](250) NOT NULL,
 CONSTRAINT [PK_ClarificationResetReason] PRIMARY KEY CLUSTERED 
(
	[ResetReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ClassificationAudit]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ClassificationAudit](
	[ClassificationAuditId] [int] IDENTITY(1,1) NOT NULL,
	[CaseId] [bigint] NOT NULL,
	[FromClassificationId] [int] NOT NULL,
	[ToClassificationId] [int] NULL,
	[ModifiedbyId] [varchar](max) NULL,
	[IsRemapped] [bit] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK__Classifi__D810C08ED710536D] PRIMARY KEY CLUSTERED 
(
	[ClassificationAuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Country]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Country](
	[CountryId] [int] IDENTITY(1,1) NOT NULL,
	[Country] [varchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedById] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED 
(
	[CountryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DataArchiveErrorLog]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DataArchiveErrorLog](
	[ErrorLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[ErrorMessage] [nvarchar](4000) NULL,
	[ErrorLogDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[dbo.ManualCaseTemplateConfiguration]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[dbo.ManualCaseTemplateConfiguration](
	[TemplateId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateCategory] [varchar](250) NULL,
	[TemplateContent] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[EMailBoxId] [int] NULL,
	[TemplateType] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Draftsave]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Draftsave](
	[CASEID] [int] NULL,
	[date] [datetime] NULL,
	[Content] [varchar](max) NULL,
	[AssignedId] [varchar](250) NULL,
	[ToAddress] [varchar](200) NULL,
	[CcAddress] [varchar](200) NULL,
	[RadioButtonClicked] [varchar](50) NULL,
	[isHighImportance] [bit] NULL,
	[IsShowQuotedText] [bit] NULL,
	[SelectedAttachments] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Draftsave_att]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Draftsave_att](
	[FileName] [varchar](255) NULL,
	[ContentType] [varchar](255) NULL,
	[Content] [image] NULL,
	[CaseId] [bigint] NULL,
	[CreatedBy] [bigint] NULL,
	[CreatedDate] [date] NULL,
	[AttachmentTypeID] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EMailAttachment]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EMailAttachment](
	[AttachmentID] [bigint] IDENTITY(1,1) NOT NULL,
	[FileName] [varchar](100) NOT NULL,
	[ContentType] [varchar](50) NULL,
	[Content] [image] NOT NULL,
	[ConversationID] [bigint] NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[AttachmentTypeID] [int] NOT NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_EMailAttachment] PRIMARY KEY CLUSTERED 
(
	[AttachmentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EMailAudit]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EMailAudit](
	[EmailAuditId] [bigint] IDENTITY(1,1) NOT NULL,
	[CaseId] [bigint] NOT NULL,
	[FromStatusId] [int] NOT NULL,
	[ToStatusId] [int] NOT NULL,
	[UserId] [varchar](50) NOT NULL,
	[StartTime] [datetime] NOT NULL,
	[EndTime] [datetime] NOT NULL,
	[AllocatedById] [varchar](50) NULL,
 CONSTRAINT [PK_EmailAudit] PRIMARY KEY CLUSTERED 
(
	[EmailAuditId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EMailBox]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EMailBox](
	[EMailBoxId] [int] IDENTITY(1,1) NOT NULL,
	[EMailBoxName] [varchar](100) NOT NULL,
	[EMailBoxAddress] [varchar](100) NOT NULL,
	[EMailFolderPath] [varchar](500) NOT NULL,
	[Domain] [varchar](10) NULL,
	[UserId] [varchar](100) NULL,
	[Password] [varchar](100) NULL,
	[CountryId] [int] NOT NULL,
	[SubProcessGroupId] [int] NOT NULL,
	[TATInHours] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[IsQCRequired] [bit] NOT NULL,
	[CreatedById] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IsMailTriggerRequired] [bit] NOT NULL,
	[EmailBoxLoginDetailId] [bigint] NOT NULL,
	[IsReplyNotRequired] [bit] NOT NULL,
	[IsLocked] [bit] NOT NULL,
	[LockedDate] [datetime] NULL,
	[TATInSeconds] [int] NULL,
	[TimeZone] [varchar](100) NULL,
	[Offset] [varchar](100) NULL,
	[EMailBoxAddressOptional] [varchar](max) NULL,
	[IsVOCSurvey] [bit] NOT NULL,
	[IsSkillBasedAllocation] [bit] NULL,
	[IsApprovalRequired] [bit] NULL,
	[IsNLPSuggestionRequired] [bit] NULL,
 CONSTRAINT [PK_MailBox] PRIMARY KEY CLUSTERED 
(
	[EMailBoxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailboxCategoryConfig]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailboxCategoryConfig](
	[EmailboxCategoryId] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NULL,
	[EmailboxId] [int] NULL,
	[Category] [varchar](200) NULL,
	[CreatedbyId] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedbyId] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_EmailboxCategoryConfig] PRIMARY KEY CLUSTERED 
(
	[EmailboxCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailBoxLoginDetail]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailBoxLoginDetail](
	[EmailBoxLoginDetailId] [bigint] IDENTITY(1,1) NOT NULL,
	[EMailId] [nvarchar](250) NOT NULL,
	[Password] [nvarchar](250) NOT NULL,
	[IsLocked] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LockedDate] [datetime] NULL,
 CONSTRAINT [PK_EmailBoxLoginDetail] PRIMARY KEY CLUSTERED 
(
	[EmailBoxLoginDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmailboxReferenceConfig]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailboxReferenceConfig](
	[EmailboxReferenceId] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NULL,
	[EmailboxId] [int] NULL,
	[Reference] [varchar](200) NULL,
	[CreatedbyId] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedbyId] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__Emailbox__D5F26BD7BFB88A69] PRIMARY KEY CLUSTERED 
(
	[EmailboxReferenceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailboxRemainderConfig]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailboxRemainderConfig](
	[EmailboxremainId] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NULL,
	[EmailboxId] [int] NULL,
	[Frequency] [int] NULL,
	[Count] [int] NULL,
	[IsEscalation] [bit] NULL,
	[CreatedbyId] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedbyId] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
	[TemplateType] [int] NULL,
	[Template] [nvarchar](max) NULL,
	[FromStatus] [int] NOT NULL,
	[ToStatus] [int] NULL,
	[EscalationMailId] [nvarchar](70) NULL,
 CONSTRAINT [PK_EmailboxRemainderConfig] PRIMARY KEY CLUSTERED 
(
	[EmailboxremainId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EMailboxTest]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EMailboxTest](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EMailbox] [varchar](200) NULL,
	[LoginEmailId] [varchar](200) NULL,
	[password] [varchar](100) NULL,
	[Path] [varchar](400) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailConversations]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailConversations](
	[ConversationID] [bigint] IDENTITY(1,1) NOT NULL,
	[Subject] [varchar](max) NULL,
	[Content] [image] NOT NULL,
	[CaseId] [bigint] NOT NULL,
	[CreatedBy] [nchar](10) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[AttachmentTypeID] [int] NOT NULL,
	[IsDeleted] [bit] NULL,
	[EmailFrom] [varchar](250) NOT NULL,
	[EmailTo] [varchar](max) NOT NULL,
	[EmailCc] [varchar](max) NULL,
	[EmailBcc] [varchar](max) NULL,
	[ConversationDate] [datetime] NOT NULL,
 CONSTRAINT [PK__EmailCon__C050D897A9AF2F1B] PRIMARY KEY CLUSTERED 
(
	[ConversationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailMaster](
	[CaseId] [bigint] IDENTITY(1001,1) NOT NULL,
	[EMailReceivedDate] [datetime] NOT NULL,
	[EMailFrom] [varchar](250) NOT NULL,
	[EmailTo] [varchar](max) NOT NULL,
	[EmailCc] [varchar](max) NULL,
	[EmailBcc] [varchar](max) NULL,
	[Subject] [varchar](max) NULL,
	[EMailBody] [varchar](max) NOT NULL,
	[EMailBoxId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[AssignedToId] [varchar](50) NULL,
	[AssignedDate] [datetime] NULL,
	[ModifiedById] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[CompletedById] [varchar](50) NULL,
	[CompletedDate] [datetime] NULL,
	[LastComment] [varchar](max) NULL,
	[QCUserId] [varchar](50) NULL,
	[IsUrgent] [bit] NULL,
	[IsManual] [bit] NULL,
	[CreatedById] [varchar](50) NULL,
	[AttachmentLocation] [varchar](100) NULL,
	[RemainderMailCount] [int] NOT NULL,
	[CategoryId] [bigint] NULL,
	[Isnotification] [bit] NULL,
	[EscalationCount] [int] NOT NULL,
	[IsAutoAcknowledgement] [bit] NULL,
	[IsVipMail] [bit] NULL,
	[ClassificationID] [bigint] NULL,
	[Bodycontent] [varchar](max) NULL,
	[AutoReplyText] [varchar](max) NULL,
	[AutoReplyReceivedTime] [datetime] NULL,
	[ParentCaseId] [bigint] NULL,
	[ForwardedToGMB] [bit] NULL,
	[IsSurveySent] [bit] NULL,
	[SurveyResponse] [varchar](max) NULL,
	[SurveyComments] [varchar](max) NULL,
	[SkillDescription] [varchar](max) NULL,
	[ApproverUserId] [varchar](50) NULL,
 CONSTRAINT [PK_EmailMaster] PRIMARY KEY CLUSTERED 
(
	[CaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailMasterCopyForUBS]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailMasterCopyForUBS](
	[CaseId] [bigint] IDENTITY(1001,1) NOT NULL,
	[EMailReceivedDate] [datetime] NOT NULL,
	[EMailFrom] [varchar](250) NOT NULL,
	[EmailTo] [varchar](max) NOT NULL,
	[EmailCc] [varchar](max) NULL,
	[EmailBcc] [varchar](max) NULL,
	[Subject] [varchar](max) NULL,
	[EMailBody] [varchar](max) NOT NULL,
	[EMailBoxId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[AssignedToId] [varchar](50) NULL,
	[AssignedDate] [datetime] NULL,
	[ModifiedById] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[CompletedById] [varchar](50) NULL,
	[CompletedDate] [datetime] NULL,
	[LastComment] [varchar](max) NULL,
	[QCUserId] [varchar](50) NULL,
	[IsUrgent] [bit] NULL,
	[IsManual] [bit] NULL,
	[CreatedById] [varchar](50) NULL,
	[AttachmentLocation] [varchar](100) NULL,
	[RemainderMailCount] [int] NOT NULL,
	[CategoryId] [bigint] NULL,
	[Isnotification] [bit] NULL,
	[EscalationCount] [int] NOT NULL,
	[IsAutoAcknowledgement] [bit] NULL,
	[IsVipMail] [bit] NULL,
	[ClassificationID] [bigint] NULL,
	[Bodycontent] [varchar](max) NULL,
	[AutoReplyText] [varchar](max) NULL,
	[AutoReplyReceivedTime] [datetime] NULL,
	[ParentCaseId] [bigint] NULL,
	[ForwardedToGMB] [bit] NULL,
	[IsSurveySent] [bit] NULL,
	[SurveyResponse] [varchar](max) NULL,
	[SurveyComments] [varchar](max) NULL,
	[SkillDescription] [varchar](max) NULL,
	[ApproverUserId] [varchar](50) NULL,
 CONSTRAINT [PK_EmailMasterCopyForUBS] PRIMARY KEY CLUSTERED 
(
	[CaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmailQuery]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmailQuery](
	[QueryId] [bigint] IDENTITY(1,1) NOT NULL,
	[CaseId] [bigint] NOT NULL,
	[EmailAuditID] [bigint] NULL,
	[QueryText] [varchar](max) NOT NULL,
	[CreatedById] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_EmailQuery] PRIMARY KEY CLUSTERED 
(
	[QueryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EMailSent]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EMailSent](
	[EMailSentId] [bigint] IDENTITY(1,1) NOT NULL,
	[CaseId] [bigint] NOT NULL,
	[EMailTo] [varchar](max) NOT NULL,
	[EMailCc] [varchar](max) NOT NULL,
	[Subject] [varchar](max) NOT NULL,
	[EMailBody] [varchar](max) NOT NULL,
	[EMailTypeId] [int] NOT NULL,
	[EMailSentDate] [datetime] NOT NULL,
	[SentStatus] [bit] NOT NULL,
	[AuditID] [bigint] NULL,
	[PLAINBODY] [varchar](max) NULL,
	[EMailBcc] [varchar](max) NULL,
 CONSTRAINT [PK_eMailSent] PRIMARY KEY CLUSTERED 
(
	[EMailSentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EMailTemplate]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EMailTemplate](
	[EmailTemplateId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateName] [varchar](50) NOT NULL,
	[EMailFrom] [varchar](250) NOT NULL,
	[Subject] [varchar](max) NOT NULL,
	[EMailBody] [varchar](max) NOT NULL,
	[EMailBoxId] [int] NOT NULL,
	[EMailTypeId] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_eMailTemplate] PRIMARY KEY CLUSTERED 
(
	[EmailTemplateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EMailType]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EMailType](
	[EMailTypeId] [int] IDENTITY(1,1) NOT NULL,
	[EMailTypeDescription] [varchar](50) NOT NULL,
 CONSTRAINT [PK_eMailType] PRIMARY KEY CLUSTERED 
(
	[EMailTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EscalationMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EscalationMaster](
	[EscalationMasterID] [bigint] IDENTITY(1,1) NOT NULL,
	[EmailBoxID] [int] NULL,
	[ToMailID] [varchar](100) NULL,
	[EscalationMailID] [varchar](100) NULL,
	[isActive] [int] NULL,
	[TimeFrequency] [int] NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_EscalationMaster] PRIMARY KEY CLUSTERED 
(
	[EscalationMasterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FlagCaseMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FlagCaseMaster](
	[ReferenceFlagId] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryId] [int] NULL,
	[EmailboxId] [int] NULL,
	[CaseId] [bigint] NOT NULL,
	[Reference] [bigint] NULL,
	[CreatedbyId] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedbyId] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK__FlagCase__B2BC1F3BE6EF9AC1] PRIMARY KEY CLUSTERED 
(
	[ReferenceFlagId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Holiday]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Holiday](
	[HolidayId] [bigint] IDENTITY(1,1) NOT NULL,
	[HolidayDescription] [varchar](100) NOT NULL,
	[HolidayDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedById] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[TotalMinutes] [int] NOT NULL,
 CONSTRAINT [PK_HolidayMaster] PRIMARY KEY CLUSTERED 
(
	[HolidayId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[InboundClassification]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[InboundClassification](
	[ClassificationID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClassifiactionDescription] [varchar](100) NOT NULL,
	[CreatedBy] [varchar](50) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_InboundClassification] PRIMARY KEY CLUSTERED 
(
	[ClassificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[MailerSubscription]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MailerSubscription](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](50) NULL,
	[Subject] [nvarchar](max) NULL,
	[SubscriptionStatus] [nvarchar](50) NULL,
	[UpdatedDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OrgConfigurationMailTrac]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OrgConfigurationMailTrac](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrgCode] [varchar](50) NOT NULL,
	[OrgDescription] [varchar](max) NOT NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PageMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PageMaster](
	[PageId] [int] NOT NULL,
	[PageName] [nvarchar](60) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[URL] [nvarchar](200) NULL,
	[Module] [nvarchar](50) NULL,
	[ChildMenuGroupID] [int] NULL,
	[MenuOrder] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductLicense]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductLicense](
	[LicenseKeyId] [int] IDENTITY(1,1) NOT NULL,
	[LicenseKey] [varchar](max) NOT NULL,
	[Clientname] [varchar](max) NULL,
 CONSTRAINT [PK_LicenseKey] PRIMARY KEY CLUSTERED 
(
	[LicenseKeyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[QueryType]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QueryType](
	[QueryTypeId] [int] NOT NULL,
	[QueryDescription] [varchar](50) NOT NULL,
 CONSTRAINT [PK_QueryType] PRIMARY KEY CLUSTERED 
(
	[QueryTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReCategorized_Tbl]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReCategorized_Tbl](
	[CaseId] [int] NOT NULL,
	[InCorrectCategory] [varchar](max) NOT NULL,
	[CorrectedCategory] [varchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ReportResults]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReportResults](
	[CaseId] [bigint] NULL,
	[a1] [nvarchar](max) NULL,
	[Amount] [nvarchar](max) NULL,
	[BatchName] [nvarchar](max) NULL,
	[gg] [nvarchar](max) NULL,
	[InvoiceDate] [nvarchar](max) NULL,
	[InvoiceNumber] [nvarchar](max) NULL,
	[MailCategory] [nvarchar](max) NULL,
	[Organisation] [nvarchar](max) NULL,
	[R1] [nvarchar](max) NULL,
	[ss1] [nvarchar](max) NULL,
	[StoreNo] [nvarchar](max) NULL,
	[SupplierName] [nvarchar](max) NULL,
	[SupplierNo] [nvarchar](max) NULL,
	[tenanttest] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ReportSubscriptionUsers]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReportSubscriptionUsers](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserID] [varchar](50) NULL,
	[Subject] [nvarchar](max) NULL,
	[SubscriptionStatus] [nvarchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[Interval] [nvarchar](50) NULL,
 CONSTRAINT [PK_ReportSubscriptionUsers] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Signature]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Signature](
	[SignID] [int] IDENTITY(1,1) NOT NULL,
	[Signature] [varchar](max) NOT NULL,
	[Userid] [varchar](50) NOT NULL,
	[LastModifiedOn] [nchar](10) NULL,
 CONSTRAINT [PK_Signature] PRIMARY KEY CLUSTERED 
(
	[SignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SkillMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SkillMaster](
	[SkillId] [bigint] IDENTITY(1,1) NOT NULL,
	[SkillDescription] [varchar](max) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SLAAuditMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SLAAuditMaster](
	[SLAAuditID] [int] IDENTITY(1,1) NOT NULL,
	[EMailBoxID] [int] NOT NULL,
	[PreviousTATinHours] [varchar](50) NOT NULL,
	[PreviousTATinSecs] [int] NOT NULL,
	[CurrentTATinHours] [varchar](50) NOT NULL,
	[CurrentTATinSecs] [int] NOT NULL,
	[CreatedByID] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SLAAuditMaster] PRIMARY KEY CLUSTERED 
(
	[SLAAuditID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SLABreachNotificationsMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SLABreachNotificationsMaster](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmailboxID] [bigint] NULL,
	[EscalationEmailID] [nvarchar](max) NULL,
	[SeqNo] [int] NULL,
	[IsActive] [bit] NULL,
	[FrequencyInSeconds] [int] NULL,
 CONSTRAINT [PK_SLABreachNotificationsMaster] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SLABreachNotificationsTransaction]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SLABreachNotificationsTransaction](
	[BreachID] [bigint] IDENTITY(1,1) NOT NULL,
	[CaseID] [int] NULL,
	[MailSentDate] [datetime] NULL,
	[MasterID] [int] NULL,
 CONSTRAINT [PK_SLABreachNotificationsTransaction] PRIMARY KEY CLUSTERED 
(
	[BreachID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Status]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Status](
	[StatusId] [int] IDENTITY(1,1) NOT NULL,
	[StatusDescription] [varchar](100) NOT NULL,
	[IsInitalStatus] [bit] NULL,
	[IsFinalStatus] [bit] NULL,
	[IsActive] [bit] NULL,
	[IsReminderStatus] [bit] NULL,
	[IsFollowupStatus] [bit] NULL,
	[SubProcessID] [int] NULL,
	[ShownInUI] [bit] NULL,
	[IsShowninDonut] [bit] NULL,
	[IsOnHold] [bit] NULL,
	[IsQCPending] [bit] NULL,
	[IsQCApprovedorRejected] [bit] NULL,
	[IsAssigned] [bit] NULL,
	[IsClarificationStatus] [bit] NULL,
	[IsReassignStatus] [bit] NULL,
	[IsShownInManual] [bit] NULL,
	[IsApprovalStatus] [bit] NULL,
 CONSTRAINT [PK_StatusMaster] PRIMARY KEY CLUSTERED 
(
	[StatusId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StatusTransisitionMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StatusTransisitionMaster](
	[StatusTransisitionID] [int] IDENTITY(1,1) NOT NULL,
	[FromStatusID] [int] NOT NULL,
	[ToStatusID] [int] NOT NULL,
	[UserRoleID] [int] NOT NULL,
	[SubProcessID] [int] NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_StatusTransisitionMaster] PRIMARY KEY CLUSTERED 
(
	[StatusTransisitionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[StoreNoEmailAddressMapping]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StoreNoEmailAddressMapping](
	[StoreNo] [int] NULL,
	[EmailAddress] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SubProcessGroups]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SubProcessGroups](
	[SubProcessGroupId] [int] IDENTITY(1,1) NOT NULL,
	[SubprocessName] [varchar](50) NOT NULL,
	[ProcessOwnerID] [varchar](250) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedById] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[CountryIdMapping] [int] NULL,
 CONSTRAINT [PK_SubProcessGroups] PRIMARY KEY CLUSTERED 
(
	[SubProcessGroupId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SurveyVOC_Details]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyVOC_Details](
	[ID] [bigint] IDENTITY(1,1) NOT NULL,
	[CaseID] [bigint] NOT NULL,
	[VOC_Quality] [nvarchar](50) NULL,
	[VOC_Reason] [nvarchar](max) NULL,
	[VOC_TurnaroundTime] [nvarchar](50) NULL,
	[VOC_TAT_Reason] [nvarchar](50) NULL,
	[Comments] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TBL]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TBL](
	[key1] [varchar](25) NULL,
	[Soucecolumn Name] [varchar](25) NULL,
	[ColumnValue] [varchar](25) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Tbl_ClientTransaction]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_ClientTransaction](
	[ClientTransactionID] [bigint] IDENTITY(1,1) NOT NULL,
	[CaseID] [bigint] NOT NULL,
	[FieldMasterID] [bigint] NOT NULL,
	[FieldValue] [nvarchar](max) NOT NULL,
	[IsListValue] [bit] NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](200) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Tbl_ClientTransaction] PRIMARY KEY CLUSTERED 
(
	[ClientTransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tbl_DefaultListValues]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_DefaultListValues](
	[DefaultListValueId] [bigint] IDENTITY(1,1) NOT NULL,
	[FieldMasterId] [bigint] NOT NULL,
	[OptionValue] [bigint] NOT NULL,
	[OptionText] [nvarchar](500) NOT NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedBy] [nvarchar](200) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Tbl_DynamicDropDownValues] PRIMARY KEY CLUSTERED 
(
	[DefaultListValueId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tbl_FieldConfiguration]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_FieldConfiguration](
	[FieldMasterId] [bigint] IDENTITY(100,1) NOT NULL,
	[FieldName] [nvarchar](500) NOT NULL,
	[MailBoxID] [bigint] NULL,
	[FieldTypeId] [bigint] NOT NULL,
	[FieldDataTypeID] [bigint] NOT NULL,
	[ValidationTypeID] [bigint] NULL,
	[TextLength] [bigint] NULL,
	[DefaultValue] [nvarchar](50) NULL,
	[Active] [bit] NOT NULL,
	[CreatedBy] [nvarchar](200) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](200) NULL,
	[ModifiedDate] [datetime] NULL,
	[CountryID] [bigint] NULL,
	[FieldAliasName] [nvarchar](500) NULL,
	[FieldPrivilegeID] [int] NULL,
 CONSTRAINT [PK_Tbl_MasterField] PRIMARY KEY CLUSTERED 
(
	[FieldMasterId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tbl_Master_FieldDataType]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Master_FieldDataType](
	[FieldDataTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[FieldDataType] [nvarchar](500) NOT NULL,
	[FieldDataTypeAlias] [nvarchar](50) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_Tbl_FieldDataTypeMaster] PRIMARY KEY CLUSTERED 
(
	[FieldDataTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tbl_Master_FieldPrivilege]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Master_FieldPrivilege](
	[FieldPrivilegeID] [int] IDENTITY(1,1) NOT NULL,
	[FieldPrivilegeName] [nvarchar](100) NULL,
	[Active] [bit] NULL,
 CONSTRAINT [PK_Tbl_FieldPrivilegeMaster] PRIMARY KEY CLUSTERED 
(
	[FieldPrivilegeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tbl_Master_FieldType]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Master_FieldType](
	[FieldTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[FieldType] [nvarchar](500) NOT NULL,
	[FieldAbbrv] [nvarchar](50) NULL,
	[FieldTypeAlias] [nvarchar](500) NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_TBL_FIELDTYPEMASTER] PRIMARY KEY CLUSTERED 
(
	[FieldTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tbl_Master_StaticFields]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Master_StaticFields](
	[StaticFieldId] [bigint] IDENTITY(1,1) NOT NULL,
	[StaticFieldName] [nvarchar](1000) NOT NULL,
	[StaticFieldDisplayName] [nvarchar](1000) NULL,
 CONSTRAINT [PK_Tbl_StaticFileds] PRIMARY KEY CLUSTERED 
(
	[StaticFieldId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tbl_Master_ValidationType]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_Master_ValidationType](
	[ValidationTypeId] [bigint] IDENTITY(1,1) NOT NULL,
	[ValidationType] [nvarchar](500) NOT NULL,
	[Active] [bit] NOT NULL,
 CONSTRAINT [PK_TBL_MasterValidationType] PRIMARY KEY CLUSTERED 
(
	[ValidationTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Tbl_SelectedListDetails]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tbl_SelectedListDetails](
	[SelectedListID] [bigint] IDENTITY(1,1) NOT NULL,
	[ClientTransactionID] [bigint] NULL,
	[DefaultListValueId] [bigint] NULL,
 CONSTRAINT [PK_Tbl_SelectedListDetails] PRIMARY KEY CLUSTERED 
(
	[SelectedListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TempDashboardResult]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TempDashboardResult](
	[RowNumber] [bigint] NOT NULL,
	[CaseId] [bigint] NOT NULL,
	[ReceivedDate] [varchar](max) NOT NULL,
	[Sender] [varchar](200) NOT NULL,
	[Subject] [varchar](max) NULL,
	[AssignedTo] [varchar](50) NULL,
	[IsUrgent] [varchar](10) NULL,
	[CountryId] [int] NOT NULL,
	[EmailboxId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[VIPMail] [varchar](200) NULL,
	[ParentCaseId] [bigint] NULL,
	[OriginalCaseId] [bigint] NULL,
	[isNLPSuggestionMail] [bit] NULL,
	[EMailBody] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TempDashboardResultNEW]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TempDashboardResultNEW](
	[RowNumber] [bigint] NOT NULL,
	[CaseId] [bigint] NOT NULL,
	[ReceivedDate] [varchar](max) NOT NULL,
	[Sender] [varchar](200) NOT NULL,
	[Subject] [varchar](max) NULL,
	[AssignedTo] [varchar](50) NULL,
	[IsUrgent] [varchar](10) NULL,
	[CountryId] [int] NOT NULL,
	[EmailboxId] [int] NOT NULL,
	[StatusId] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TempDashboardResultNormal]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TempDashboardResultNormal](
	[RowNumber] [bigint] NOT NULL,
	[CaseId] [bigint] NOT NULL,
	[ReceivedDate] [varchar](max) NOT NULL,
	[Sender] [varchar](200) NOT NULL,
	[Subject] [varchar](max) NULL,
	[AssignedTo] [varchar](50) NULL,
	[IsUrgent] [varchar](10) NULL,
	[CountryId] [int] NOT NULL,
	[EmailboxId] [int] NOT NULL,
	[StatusId] [int] NOT NULL,
	[classificationId] [int] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TempTable]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TempTable](
	[DateTime] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[UserMailBoxMapping]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserMailBoxMapping](
	[UsermailBoxMappingId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](50) NOT NULL,
	[MailBoxId] [int] NOT NULL,
	[CreatedByID] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedById] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_UserMailBoxMapping] PRIMARY KEY CLUSTERED 
(
	[UsermailBoxMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserMaster](
	[UserId] [varchar](50) NOT NULL,
	[FirstName] [varchar](100) NOT NULL,
	[LastName] [varchar](100) NOT NULL,
	[EMail] [varchar](250) NOT NULL,
	[Password] [varchar](250) NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedBy] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[ModifiedById] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[TimeZone] [varchar](100) NULL,
	[Offset] [varchar](100) NULL,
	[PasswordCreatedDate] [datetime] NULL,
	[IsLocked] [bit] NULL,
	[Token] [varchar](100) NULL,
	[TokenExpirationTime] [datetime] NULL,
	[SessionId] [varchar](max) NULL,
	[SessionTime] [datetime] NULL,
	[SkillDescription] [varchar](max) NULL,
	[SkillId] [varchar](max) NULL,
 CONSTRAINT [PK_UserMaster] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRole]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserRole](
	[UserRoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleDescription] [varchar](100) NOT NULL,
	[RoleReferenceId] [int] NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserRoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserRoleMapping]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserRoleMapping](
	[UserRoleMappingId] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [varchar](50) NOT NULL,
	[RoleId] [int] NOT NULL,
	[CreatedById] [varchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[CountriesMapped] [nvarchar](20) NULL,
 CONSTRAINT [PK_UserRoleMapping] PRIMARY KEY CLUSTERED 
(
	[UserRoleMappingId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VIPUsers]    Script Date: 11/8/2017 10:07:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VIPUsers](
	[RollNumber] [bigint] NOT NULL,
	[LoginID] [nvarchar](15) NOT NULL,
	[FirstName] [nvarchar](50) NULL,
	[LastName] [nvarchar](50) NULL,
	[Role] [nvarchar](50) NULL,
	[EmailAddress] [nvarchar](70) NULL,
	[IsActive] [bit] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ix_Country_Country]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_Country_Country] ON [dbo].[Country]
(
	[Country] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
/****** Object:  Index [ix_Country_IsActive]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_Country_IsActive] ON [dbo].[Country]
(
	[IsActive] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
/****** Object:  Index [ix_EMailAttachment]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_EMailAttachment] ON [dbo].[EMailAttachment]
(
	[ConversationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
/****** Object:  Index [ix_EmailboxCategoryConfig]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_EmailboxCategoryConfig] ON [dbo].[EmailboxCategoryConfig]
(
	[CountryId] ASC,
	[EmailboxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ix_EmailBoxLoginDetail]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_EmailBoxLoginDetail] ON [dbo].[EmailBoxLoginDetail]
(
	[EMailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
/****** Object:  Index [ix_EmailboxRemainderConfig]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_EmailboxRemainderConfig] ON [dbo].[EmailboxRemainderConfig]
(
	[CountryId] ASC,
	[EmailboxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
/****** Object:  Index [ix_EmailQuery]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_EmailQuery] ON [dbo].[EmailQuery]
(
	[CaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
/****** Object:  Index [ix_EMailSent]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_EMailSent] ON [dbo].[EMailSent]
(
	[CaseId] ASC,
	[EMailTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
/****** Object:  Index [ix_SLAAuditMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_SLAAuditMaster] ON [dbo].[SLAAuditMaster]
(
	[EMailBoxID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ix_UserMailBoxMapping]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_UserMailBoxMapping] ON [dbo].[UserMailBoxMapping]
(
	[UserId] ASC,
	[MailBoxId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ix_UserMaster]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_UserMaster] ON [dbo].[UserMaster]
(
	[FirstName] ASC,
	[LastName] ASC,
	[EMail] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [ix_UserRoleMapping]    Script Date: 11/8/2017 10:07:34 PM ******/
CREATE NONCLUSTERED INDEX [ix_UserRoleMapping] ON [dbo].[UserRoleMapping]
(
	[UserId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EMailBox] ADD  CONSTRAINT [DF_EMailBox_IsVOCSurvey]  DEFAULT ((0)) FOR [IsVOCSurvey]
GO
ALTER TABLE [dbo].[EMailBox] ADD  CONSTRAINT [DF_EMailBox_IsSkillBasedAllocation]  DEFAULT ((0)) FOR [IsSkillBasedAllocation]
GO
ALTER TABLE [dbo].[EmailboxRemainderConfig] ADD  CONSTRAINT [DF_EmailboxRemainderConfig_FromStatus]  DEFAULT ((3)) FOR [FromStatus]
GO
ALTER TABLE [dbo].[EmailMaster] ADD  CONSTRAINT [DF__EmailMast__Remai__10E07F16]  DEFAULT ('0') FOR [RemainderMailCount]
GO
ALTER TABLE [dbo].[EmailMaster] ADD  CONSTRAINT [DF_EmailMaster_EscalationCount]  DEFAULT ((0)) FOR [EscalationCount]
GO
ALTER TABLE [dbo].[StatusTransisitionMaster] ADD  CONSTRAINT [DF_StatusTransisitionMaster_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Tbl_ClientTransaction] ADD  CONSTRAINT [DF_Tbl_ClientTransaction_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Tbl_ClientTransaction] ADD  CONSTRAINT [DF_Table_1_CreatedDate1]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[Tbl_DefaultListValues] ADD  CONSTRAINT [DF_Tbl_DynamicDropDownValues_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Tbl_DefaultListValues] ADD  CONSTRAINT [DF_Tbl_DynamicDropDownValues_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration] ADD  CONSTRAINT [DF_Tbl_MasterField_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration] ADD  CONSTRAINT [DF_Tbl_MasterField_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Tbl_Master_FieldDataType] ADD  CONSTRAINT [DF_Tbl_FieldDataTypeMaster_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Tbl_Master_FieldPrivilege] ADD  CONSTRAINT [DF_Tbl_FieldPrivilegeMaster_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Tbl_Master_FieldType] ADD  CONSTRAINT [DF_TBL_FIELDTYPEMASTER_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Tbl_Master_ValidationType] ADD  CONSTRAINT [DF_TBL_MasterValidationType_Active]  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [dbo].[Country]  WITH CHECK ADD  CONSTRAINT [FK_Country_UserMaster] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[Country] CHECK CONSTRAINT [FK_Country_UserMaster]
GO
ALTER TABLE [dbo].[EMailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EMailAttachment_AttachmentType] FOREIGN KEY([AttachmentTypeID])
REFERENCES [dbo].[AttachmentType] ([AttachmentTypeID])
GO
ALTER TABLE [dbo].[EMailAttachment] CHECK CONSTRAINT [FK_EMailAttachment_AttachmentType]
GO
ALTER TABLE [dbo].[EMailAttachment]  WITH CHECK ADD  CONSTRAINT [FK_EmailAttachment_EmailConversations] FOREIGN KEY([ConversationID])
REFERENCES [dbo].[EmailConversations] ([ConversationID])
GO
ALTER TABLE [dbo].[EMailAttachment] CHECK CONSTRAINT [FK_EmailAttachment_EmailConversations]
GO
ALTER TABLE [dbo].[EMailAudit]  WITH CHECK ADD  CONSTRAINT [FK_EmailAudit_EmailMaster] FOREIGN KEY([CaseId])
REFERENCES [dbo].[EmailMaster] ([CaseId])
GO
ALTER TABLE [dbo].[EMailAudit] CHECK CONSTRAINT [FK_EmailAudit_EmailMaster]
GO
ALTER TABLE [dbo].[EMailAudit]  WITH CHECK ADD  CONSTRAINT [FK_EmailAudit_StatusMaster] FOREIGN KEY([FromStatusId])
REFERENCES [dbo].[Status] ([StatusId])
GO
ALTER TABLE [dbo].[EMailAudit] CHECK CONSTRAINT [FK_EmailAudit_StatusMaster]
GO
ALTER TABLE [dbo].[EMailAudit]  WITH CHECK ADD  CONSTRAINT [FK_EmailAudit_StatusMaster1] FOREIGN KEY([ToStatusId])
REFERENCES [dbo].[Status] ([StatusId])
GO
ALTER TABLE [dbo].[EMailAudit] CHECK CONSTRAINT [FK_EmailAudit_StatusMaster1]
GO
ALTER TABLE [dbo].[EMailAudit]  WITH CHECK ADD  CONSTRAINT [FK_EmailAudit_UserMaster] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[EMailAudit] CHECK CONSTRAINT [FK_EmailAudit_UserMaster]
GO
ALTER TABLE [dbo].[EMailBox]  WITH CHECK ADD  CONSTRAINT [FK_EMailBox_Country] FOREIGN KEY([SubProcessGroupId])
REFERENCES [dbo].[SubProcessGroups] ([SubProcessGroupId])
GO
ALTER TABLE [dbo].[EMailBox] CHECK CONSTRAINT [FK_EMailBox_Country]
GO
ALTER TABLE [dbo].[EMailBox]  WITH CHECK ADD  CONSTRAINT [FK_EMailBox_EmailBoxLoginDetail] FOREIGN KEY([EmailBoxLoginDetailId])
REFERENCES [dbo].[EmailBoxLoginDetail] ([EmailBoxLoginDetailId])
GO
ALTER TABLE [dbo].[EMailBox] CHECK CONSTRAINT [FK_EMailBox_EmailBoxLoginDetail]
GO
ALTER TABLE [dbo].[EMailBox]  WITH CHECK ADD  CONSTRAINT [FK_EMailBox_SubProcessGroups] FOREIGN KEY([SubProcessGroupId])
REFERENCES [dbo].[SubProcessGroups] ([SubProcessGroupId])
GO
ALTER TABLE [dbo].[EMailBox] CHECK CONSTRAINT [FK_EMailBox_SubProcessGroups]
GO
ALTER TABLE [dbo].[EMailBox]  WITH CHECK ADD  CONSTRAINT [FK_MailBox_UserMaster] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[EMailBox] CHECK CONSTRAINT [FK_MailBox_UserMaster]
GO
ALTER TABLE [dbo].[EmailboxCategoryConfig]  WITH CHECK ADD  CONSTRAINT [FK_EmailboxCategoryConfig_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[EmailboxCategoryConfig] CHECK CONSTRAINT [FK_EmailboxCategoryConfig_Country]
GO
ALTER TABLE [dbo].[EmailboxCategoryConfig]  WITH CHECK ADD  CONSTRAINT [FK_EmailboxCategoryConfig_EMailBox] FOREIGN KEY([EmailboxId])
REFERENCES [dbo].[EMailBox] ([EMailBoxId])
GO
ALTER TABLE [dbo].[EmailboxCategoryConfig] CHECK CONSTRAINT [FK_EmailboxCategoryConfig_EMailBox]
GO
ALTER TABLE [dbo].[EmailboxCategoryConfig]  WITH CHECK ADD  CONSTRAINT [FK_EmailboxCategoryConfig_UserMaster] FOREIGN KEY([CreatedbyId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[EmailboxCategoryConfig] CHECK CONSTRAINT [FK_EmailboxCategoryConfig_UserMaster]
GO
ALTER TABLE [dbo].[EmailboxCategoryConfig]  WITH CHECK ADD  CONSTRAINT [FK_EmailboxCategoryConfig_UserMaster1] FOREIGN KEY([ModifiedbyId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[EmailboxCategoryConfig] CHECK CONSTRAINT [FK_EmailboxCategoryConfig_UserMaster1]
GO
ALTER TABLE [dbo].[EmailboxReferenceConfig]  WITH CHECK ADD  CONSTRAINT [FK__EmailboxR__Count__2EA5EC27] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[EmailboxReferenceConfig] CHECK CONSTRAINT [FK__EmailboxR__Count__2EA5EC27]
GO
ALTER TABLE [dbo].[EmailboxReferenceConfig]  WITH CHECK ADD  CONSTRAINT [FK__EmailboxR__Creat__0C1BC9F9] FOREIGN KEY([CreatedbyId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[EmailboxReferenceConfig] CHECK CONSTRAINT [FK__EmailboxR__Creat__0C1BC9F9]
GO
ALTER TABLE [dbo].[EmailboxReferenceConfig]  WITH CHECK ADD  CONSTRAINT [FK__EmailboxR__Email__308E3499] FOREIGN KEY([EmailboxId])
REFERENCES [dbo].[EMailBox] ([EMailBoxId])
GO
ALTER TABLE [dbo].[EmailboxReferenceConfig] CHECK CONSTRAINT [FK__EmailboxR__Email__308E3499]
GO
ALTER TABLE [dbo].[EmailboxReferenceConfig]  WITH CHECK ADD  CONSTRAINT [FK__EmailboxR__Modif__0D0FEE32] FOREIGN KEY([ModifiedbyId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[EmailboxReferenceConfig] CHECK CONSTRAINT [FK__EmailboxR__Modif__0D0FEE32]
GO
ALTER TABLE [dbo].[EmailboxRemainderConfig]  WITH CHECK ADD  CONSTRAINT [FK_EmailboxRemainderConfig_Country] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[EmailboxRemainderConfig] CHECK CONSTRAINT [FK_EmailboxRemainderConfig_Country]
GO
ALTER TABLE [dbo].[EmailboxRemainderConfig]  WITH CHECK ADD  CONSTRAINT [FK_EmailboxRemainderConfig_EMailBox] FOREIGN KEY([EmailboxId])
REFERENCES [dbo].[EMailBox] ([EMailBoxId])
GO
ALTER TABLE [dbo].[EmailboxRemainderConfig] CHECK CONSTRAINT [FK_EmailboxRemainderConfig_EMailBox]
GO
ALTER TABLE [dbo].[EmailboxRemainderConfig]  WITH CHECK ADD  CONSTRAINT [FK_EmailboxRemainderConfig_UserMaster] FOREIGN KEY([CreatedbyId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[EmailboxRemainderConfig] CHECK CONSTRAINT [FK_EmailboxRemainderConfig_UserMaster]
GO
ALTER TABLE [dbo].[EmailboxRemainderConfig]  WITH CHECK ADD  CONSTRAINT [FK_EmailboxRemainderConfig_UserMaster1] FOREIGN KEY([ModifiedbyId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[EmailboxRemainderConfig] CHECK CONSTRAINT [FK_EmailboxRemainderConfig_UserMaster1]
GO
ALTER TABLE [dbo].[EmailConversations]  WITH CHECK ADD  CONSTRAINT [FK_EmailConversations_AttachmentType] FOREIGN KEY([AttachmentTypeID])
REFERENCES [dbo].[AttachmentType] ([AttachmentTypeID])
GO
ALTER TABLE [dbo].[EmailConversations] CHECK CONSTRAINT [FK_EmailConversations_AttachmentType]
GO
ALTER TABLE [dbo].[EmailConversations]  WITH CHECK ADD  CONSTRAINT [FK_EmailConversations_EmailMaster] FOREIGN KEY([CaseId])
REFERENCES [dbo].[EmailMaster] ([CaseId])
GO
ALTER TABLE [dbo].[EmailConversations] CHECK CONSTRAINT [FK_EmailConversations_EmailMaster]
GO
ALTER TABLE [dbo].[EmailMaster]  WITH CHECK ADD  CONSTRAINT [FK_EmailMaster_MailBox] FOREIGN KEY([EMailBoxId])
REFERENCES [dbo].[EMailBox] ([EMailBoxId])
GO
ALTER TABLE [dbo].[EmailMaster] CHECK CONSTRAINT [FK_EmailMaster_MailBox]
GO
ALTER TABLE [dbo].[EmailMaster]  WITH CHECK ADD  CONSTRAINT [FK_EmailMaster_StatusMaster] FOREIGN KEY([StatusId])
REFERENCES [dbo].[Status] ([StatusId])
GO
ALTER TABLE [dbo].[EmailMaster] CHECK CONSTRAINT [FK_EmailMaster_StatusMaster]
GO
ALTER TABLE [dbo].[EMailSent]  WITH CHECK ADD  CONSTRAINT [FK_eMailSent_EmailMaster] FOREIGN KEY([CaseId])
REFERENCES [dbo].[EmailMaster] ([CaseId])
GO
ALTER TABLE [dbo].[EMailSent] CHECK CONSTRAINT [FK_eMailSent_EmailMaster]
GO
ALTER TABLE [dbo].[EMailSent]  WITH CHECK ADD  CONSTRAINT [FK_eMailSent_eMailType] FOREIGN KEY([EMailTypeId])
REFERENCES [dbo].[EMailType] ([EMailTypeId])
GO
ALTER TABLE [dbo].[EMailSent] CHECK CONSTRAINT [FK_eMailSent_eMailType]
GO
ALTER TABLE [dbo].[EMailTemplate]  WITH CHECK ADD  CONSTRAINT [FK_eMailTemplate_eMailType] FOREIGN KEY([EMailTypeId])
REFERENCES [dbo].[EMailType] ([EMailTypeId])
GO
ALTER TABLE [dbo].[EMailTemplate] CHECK CONSTRAINT [FK_eMailTemplate_eMailType]
GO
ALTER TABLE [dbo].[EMailTemplate]  WITH CHECK ADD  CONSTRAINT [FK_eMailTemplate_MailBox] FOREIGN KEY([EMailBoxId])
REFERENCES [dbo].[EMailBox] ([EMailBoxId])
GO
ALTER TABLE [dbo].[EMailTemplate] CHECK CONSTRAINT [FK_eMailTemplate_MailBox]
GO
ALTER TABLE [dbo].[EscalationMaster]  WITH NOCHECK ADD  CONSTRAINT [FK_EscalationMaster_EscalationMaster] FOREIGN KEY([EmailBoxID])
REFERENCES [dbo].[EMailBox] ([EMailBoxId])
GO
ALTER TABLE [dbo].[EscalationMaster] NOCHECK CONSTRAINT [FK_EscalationMaster_EscalationMaster]
GO
ALTER TABLE [dbo].[FlagCaseMaster]  WITH CHECK ADD  CONSTRAINT [FK__FlagCaseM__CaseI__3CF40B7E] FOREIGN KEY([CaseId])
REFERENCES [dbo].[EmailMaster] ([CaseId])
GO
ALTER TABLE [dbo].[FlagCaseMaster] CHECK CONSTRAINT [FK__FlagCaseM__CaseI__3CF40B7E]
GO
ALTER TABLE [dbo].[FlagCaseMaster]  WITH CHECK ADD  CONSTRAINT [FK__FlagCaseM__Count__3DE82FB7] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([CountryId])
GO
ALTER TABLE [dbo].[FlagCaseMaster] CHECK CONSTRAINT [FK__FlagCaseM__Count__3DE82FB7]
GO
ALTER TABLE [dbo].[FlagCaseMaster]  WITH CHECK ADD  CONSTRAINT [FK__FlagCaseM__Creat__0FEC5ADD] FOREIGN KEY([CreatedbyId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[FlagCaseMaster] CHECK CONSTRAINT [FK__FlagCaseM__Creat__0FEC5ADD]
GO
ALTER TABLE [dbo].[FlagCaseMaster]  WITH CHECK ADD  CONSTRAINT [FK__FlagCaseM__Email__3FD07829] FOREIGN KEY([EmailboxId])
REFERENCES [dbo].[EMailBox] ([EMailBoxId])
GO
ALTER TABLE [dbo].[FlagCaseMaster] CHECK CONSTRAINT [FK__FlagCaseM__Email__3FD07829]
GO
ALTER TABLE [dbo].[FlagCaseMaster]  WITH CHECK ADD  CONSTRAINT [FK__FlagCaseM__Modif__10E07F16] FOREIGN KEY([ModifiedbyId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[FlagCaseMaster] CHECK CONSTRAINT [FK__FlagCaseM__Modif__10E07F16]
GO
ALTER TABLE [dbo].[FlagCaseMaster]  WITH CHECK ADD  CONSTRAINT [FK__FlagCaseM__Refer__41B8C09B] FOREIGN KEY([Reference])
REFERENCES [dbo].[EmailboxReferenceConfig] ([EmailboxReferenceId])
GO
ALTER TABLE [dbo].[FlagCaseMaster] CHECK CONSTRAINT [FK__FlagCaseM__Refer__41B8C09B]
GO
ALTER TABLE [dbo].[Holiday]  WITH CHECK ADD  CONSTRAINT [FK_Holiday_UserMaster] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[Holiday] CHECK CONSTRAINT [FK_Holiday_UserMaster]
GO
ALTER TABLE [dbo].[SLAAuditMaster]  WITH CHECK ADD  CONSTRAINT [FK_SLAAuditMaster_EMailBox] FOREIGN KEY([EMailBoxID])
REFERENCES [dbo].[EMailBox] ([EMailBoxId])
GO
ALTER TABLE [dbo].[SLAAuditMaster] CHECK CONSTRAINT [FK_SLAAuditMaster_EMailBox]
GO
ALTER TABLE [dbo].[SLAAuditMaster]  WITH CHECK ADD  CONSTRAINT [FK_SLAAuditMaster_UserMaster] FOREIGN KEY([CreatedByID])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[SLAAuditMaster] CHECK CONSTRAINT [FK_SLAAuditMaster_UserMaster]
GO
ALTER TABLE [dbo].[SubProcessGroups]  WITH CHECK ADD  CONSTRAINT [FK_SubProcessMaster_UserMaster] FOREIGN KEY([CreatedById])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[SubProcessGroups] CHECK CONSTRAINT [FK_SubProcessMaster_UserMaster]
GO
ALTER TABLE [dbo].[Tbl_ClientTransaction]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_ClientTransaction_TBL_ClientFieldConfiguration] FOREIGN KEY([FieldMasterID])
REFERENCES [dbo].[Tbl_FieldConfiguration] ([FieldMasterId])
GO
ALTER TABLE [dbo].[Tbl_ClientTransaction] CHECK CONSTRAINT [FK_Tbl_ClientTransaction_TBL_ClientFieldConfiguration]
GO
ALTER TABLE [dbo].[Tbl_DefaultListValues]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_DynamicDropDownValues_Tbl_ConfigureField] FOREIGN KEY([FieldMasterId])
REFERENCES [dbo].[Tbl_FieldConfiguration] ([FieldMasterId])
GO
ALTER TABLE [dbo].[Tbl_DefaultListValues] CHECK CONSTRAINT [FK_Tbl_DynamicDropDownValues_Tbl_ConfigureField]
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_ConfigureField_Tbl_FieldDataTypeMaster] FOREIGN KEY([FieldDataTypeID])
REFERENCES [dbo].[Tbl_Master_FieldDataType] ([FieldDataTypeId])
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration] CHECK CONSTRAINT [FK_Tbl_ConfigureField_Tbl_FieldDataTypeMaster]
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_ConfigureField_TBL_FieldTypeMaster] FOREIGN KEY([FieldTypeId])
REFERENCES [dbo].[Tbl_Master_FieldType] ([FieldTypeId])
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration] CHECK CONSTRAINT [FK_Tbl_ConfigureField_TBL_FieldTypeMaster]
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_ConfigureField_TBL_ValidationTypeMaster] FOREIGN KEY([ValidationTypeID])
REFERENCES [dbo].[Tbl_Master_ValidationType] ([ValidationTypeId])
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration] CHECK CONSTRAINT [FK_Tbl_ConfigureField_TBL_ValidationTypeMaster]
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_FieldConfiguration_Tbl_FieldConfiguration] FOREIGN KEY([FieldMasterId])
REFERENCES [dbo].[Tbl_FieldConfiguration] ([FieldMasterId])
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration] CHECK CONSTRAINT [FK_Tbl_FieldConfiguration_Tbl_FieldConfiguration]
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_FieldConfiguration_Tbl_Master_FieldPrivilege] FOREIGN KEY([FieldPrivilegeID])
REFERENCES [dbo].[Tbl_Master_FieldPrivilege] ([FieldPrivilegeID])
GO
ALTER TABLE [dbo].[Tbl_FieldConfiguration] CHECK CONSTRAINT [FK_Tbl_FieldConfiguration_Tbl_Master_FieldPrivilege]
GO
ALTER TABLE [dbo].[Tbl_SelectedListDetails]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_SelectedListDetails_Tbl_ClientTransaction] FOREIGN KEY([ClientTransactionID])
REFERENCES [dbo].[Tbl_ClientTransaction] ([ClientTransactionID])
GO
ALTER TABLE [dbo].[Tbl_SelectedListDetails] CHECK CONSTRAINT [FK_Tbl_SelectedListDetails_Tbl_ClientTransaction]
GO
ALTER TABLE [dbo].[Tbl_SelectedListDetails]  WITH CHECK ADD  CONSTRAINT [FK_Tbl_SelectedListDetails_Tbl_DefaultListValues] FOREIGN KEY([DefaultListValueId])
REFERENCES [dbo].[Tbl_DefaultListValues] ([DefaultListValueId])
GO
ALTER TABLE [dbo].[Tbl_SelectedListDetails] CHECK CONSTRAINT [FK_Tbl_SelectedListDetails_Tbl_DefaultListValues]
GO
ALTER TABLE [dbo].[UserMailBoxMapping]  WITH CHECK ADD  CONSTRAINT [FK_UserMailBoxMapping_MailBox] FOREIGN KEY([MailBoxId])
REFERENCES [dbo].[EMailBox] ([EMailBoxId])
GO
ALTER TABLE [dbo].[UserMailBoxMapping] CHECK CONSTRAINT [FK_UserMailBoxMapping_MailBox]
GO
ALTER TABLE [dbo].[UserMailBoxMapping]  WITH CHECK ADD  CONSTRAINT [FK_UserMailBoxMapping_UserMaster] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[UserMailBoxMapping] CHECK CONSTRAINT [FK_UserMailBoxMapping_UserMaster]
GO
ALTER TABLE [dbo].[UserRoleMapping]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleMapping_UserMaster] FOREIGN KEY([UserId])
REFERENCES [dbo].[UserMaster] ([UserId])
GO
ALTER TABLE [dbo].[UserRoleMapping] CHECK CONSTRAINT [FK_UserRoleMapping_UserMaster]
GO
ALTER TABLE [dbo].[UserRoleMapping]  WITH CHECK ADD  CONSTRAINT [FK_UserRoleMapping_UserRoles] FOREIGN KEY([RoleId])
REFERENCES [dbo].[UserRole] ([UserRoleId])
GO
ALTER TABLE [dbo].[UserRoleMapping] CHECK CONSTRAINT [FK_UserRoleMapping_UserRoles]
GO
USE [master]
GO
ALTER DATABASE [EMT_SV_RT] SET  READ_WRITE 
GO

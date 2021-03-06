USE [master]
GO
/****** Object:  Database [ToolTenant]    Script Date: 11/8/2017 10:03:21 PM ******/
CREATE DATABASE [ToolTenant]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'ToolTenant', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ToolTenant.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ToolTenant_log', FILENAME = N'D:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\ToolTenant_log.ldf' , SIZE = 3136KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ToolTenant] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ToolTenant].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ToolTenant] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ToolTenant] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ToolTenant] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ToolTenant] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ToolTenant] SET ARITHABORT OFF 
GO
ALTER DATABASE [ToolTenant] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ToolTenant] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ToolTenant] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ToolTenant] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ToolTenant] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ToolTenant] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ToolTenant] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ToolTenant] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ToolTenant] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ToolTenant] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ToolTenant] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ToolTenant] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ToolTenant] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ToolTenant] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ToolTenant] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ToolTenant] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ToolTenant] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ToolTenant] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ToolTenant] SET RECOVERY FULL 
GO
ALTER DATABASE [ToolTenant] SET  MULTI_USER 
GO
ALTER DATABASE [ToolTenant] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ToolTenant] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ToolTenant] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ToolTenant] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ToolTenant', N'ON'
GO
USE [ToolTenant]
GO
/****** Object:  StoredProcedure [dbo].[USP_GET_EMailBox]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[USP_GET_EMailBox]

 @szTenantName varchar(50)

AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		declare @output int;
		--declare @localvar int;
		
				BEGIN TRY
					
				select TI.UserId,TI.Password,TI.IsLocked,TI.IsActive from tblTenantInstance TI join [dbo].[tblTenant] Tent
				on TI.TenantId=Tent.TenantId where Tent.TenantName=@szTenantName

				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Retrieving table EMailBox. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_UPDATE
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_UPDATE
					SELECT 1
	

		
	

END




GO
/****** Object:  StoredProcedure [dbo].[USP_GET_Hierarchy]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_GET_Hierarchy]  
	
    @szTenantName VarChar(100),
    @szHierarchyName VarChar(100),
	 @szHierarchyLevel VarChar(100)
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;	
			declare @localvar int;	
			declare @localHierarchyLevel int;	
			declare @ParentId int;		
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY

				set @localvar=(select TenantId from [dbo].[tblTenant] where TenantName=@szTenantName)
				
				set @localHierarchyLevel=(select ParentId from [Hierarchy] where HierarchyName=@szHierarchyName and HierarchyLevel=@szHierarchyLevel)
				
				select * from [Hierarchy] where TenantId=@localvar and HierarchyName=@szHierarchyName and HierarchyLevel=@szHierarchyLevel
				
				select * from [Hierarchy] where HierarchyID=@localHierarchyLevel								
				set @ParentId= (select ParentId from [Hierarchy] where HierarchyID=@localHierarchyLevel)						
					if( @ParentId Is not null)
					select * from [Hierarchy] where HierarchyID=(select ParentId from [Hierarchy] where HierarchyID= @localHierarchyLevel)
					
				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Retrieving from table Hierarchy. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END
   
	
END











GO
/****** Object:  StoredProcedure [dbo].[USP_GET_LookUp]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_GET_LookUp]  
	
    @szTenantName VarChar(100),
    @szLookUpName VarChar(100),
	 @szLookUpLevel VarChar(100)
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;	
			declare @localvar int;	
			declare @localLookUpLevel int;	
			declare @ParentId int;		
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY

				set @localvar=(select TenantId from [dbo].[tblTenant] where TenantName=@szTenantName)
				
				--set @localLookUpLevel=(select ParentId from [Lookup] where LookupName=@szLookUpName and LookupLevel=@szLookUpLevel)
				
				select * from [Lookup] where TenantId=@localvar and LookupName=@szLookUpName and LookupLevel=@szLookUpLevel
				
				--select * from [Lookup] where LookupID=@localLookUpLevel								
				--set @ParentId= (select ParentId from [Lookup] where LookupID=@localLookUpLevel)						
				--	if( @ParentId Is not null)
				--	select * from [Lookup] where LookupID=(select ParentId from [Lookup] where LookupID= @localLookUpLevel)
					
				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Retrieving from table Lookup. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END
   
	
END
select * from Lookup










GO
/****** Object:  StoredProcedure [dbo].[USP_GET_TenantConfigurationChanges]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[USP_GET_TenantConfigurationChanges]	
	@TenantName nvarchar(50)	

    
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		declare @output int;
		declare @localvar int;	
	    declare @EMail_ADDON_localvar int;	
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY
				
				select * from [dbo].[TenantProgramFeatures] where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where [TenantName]=@TenantName and IsActive=1)
				
				set @localvar=(select [AuditFeatureId] from [dbo].[TenantProgramFeatures] where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where [TenantName]=@TenantName and IsActive=1))
				if( @localvar is  null)
				select null
				else
				select * from [dbo].[tblAuditFeatures] where [iProgramFeaturesSetUpId]=@localvar

				set @localvar=(select [MailFeatureId] from [dbo].[TenantProgramFeatures] where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where [TenantName]=@TenantName and IsActive=1))
				if( @localvar is  null)
				select null
				else
				begin
				select * from [dbo].[EMailFeatures] where [EMailBoxFeatureId]=@localvar
				set @EMail_ADDON_localvar=(select [AddOnFeaturesId] from [dbo].[EMailFeatures] where [EMailBoxFeatureId]=@localvar )
				select * from [dbo].[tblEMT_ADDON_Features] where AddOnFeaturesId=@EMail_ADDON_localvar
				end
				--set @localvar=(select [ProcessingFeatureId] from [dbo].[TenantProgramFeatures])
				--if( @localvar is not null)
				--select * from [dbo].[EMailFeatures] where [EMailBoxFeatureId]=@localvar


				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error selecting from USP_GET_TenantConfigurationChanges. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					SELECT SCOPE_IDENTITY()--RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END
   
	
END










GO
/****** Object:  StoredProcedure [dbo].[USP_GET_TenantConnectionDetails]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[USP_GET_TenantConnectionDetails]	
	@TenantName nvarchar(50),
	@AppId	nvarchar(50)

    
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		declare @output int;
		declare @localvar int;	
	    declare @EMail_ADDON_localvar int;	
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY				
				
				
				--select [ConnectionString] from [dbo].[tblTenantInstance]
				-- where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where Lower([TenantName])= Lower(@TenantName) and Lower([AppId]) =Lower(@AppId ))
				
				select tblTI.ConnectionString from [dbo].[tblTenantInstance] tblTI
				 left outer join  [dbo].[tblTenant] tblT on  tblT.TenantId=tblTI.TenantId where Lower([TenantName])= Lower(@TenantName) and Lower([AppId]) =Lower(@AppId)
				


				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error selecting from USP_GET_TenantConnectionDetails. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					SELECT SCOPE_IDENTITY()--RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END
   
	
END











GO
/****** Object:  StoredProcedure [dbo].[USP_GET_TenantDBDetails]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[USP_GET_TenantDBDetails] 
    @iTenantId INT,
	@szAppId varchar(50)

AS 
BEGIN 
BEGIN TRY

--select * from [dbo].[tblTenantDBDetails] where iAppDbId=(select iAppDbId from [dbo].[tblQuartTenantMaster] where  iAppId=1)
select tblTI.ConnectionString from [dbo].[tblTenantInstance] tblTI inner join [dbo].[tblTenant] tblT 
on tblTI.TenantId=tblT.TenantId 
where  upper(lower(tblT.AppId))=upper(lower(@szAppId)) and tblT.TenantId =@iTenantId
 
 End Try
 BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
    SET @ErrorMessage = ERROR_MESSAGE();  
    SET @ErrorSeverity = ERROR_SEVERITY();  
    SET @ErrorState = ERROR_STATE();  
    RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
	--RETURN -1  
 END CATCH
 END




GO
/****** Object:  StoredProcedure [dbo].[USP_GET_TenantDetails]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[USP_GET_TenantDetails] 
    @szTenantName varchar(50),
	@szAppId varchar(50)

AS 
BEGIN 
BEGIN TRY

select * from [dbo].[tblTenant] where TenantName=@szTenantName and AppId=@szAppId

select * from [dbo].[tblTenantInstance] where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where TenantName=@szTenantName and AppId=@szAppId)
 
 End Try
 BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
    SET @ErrorMessage = ERROR_MESSAGE();  
    SET @ErrorSeverity = ERROR_SEVERITY();  
    SET @ErrorState = ERROR_STATE();  
    RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
	--RETURN -1  
 END CATCH
 END





GO
/****** Object:  StoredProcedure [dbo].[USP_GET_ZoneANDMenuChanges]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[USP_GET_ZoneANDMenuChanges]	
	@TenantName nvarchar(50)	

    
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		declare @output int;
		declare @localvar int;	
	    declare @EMail_ADDON_localvar int;	
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY
				
				select * from [dbo].[tblZoneMaster] where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where [TenantName]=@TenantName)
				
				--set @localvar=(select [AuditFeatureId] from [dbo].[TenantProgramFeatures] where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where [TenantName]=@TenantName and IsActive=1))
			--	if( @localvar is  null)
				--select null
				--else
				select * from [dbo].[tblAccessMenuMaster] where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where [TenantName]=@TenantName)

				--set @localvar=(select [iMenuId][MailFeatureId] from [dbo].[TenantProgramFeatures] where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where [TenantName]=@TenantName and IsActive=1))
				--if( @localvar is  null)
				--select null
				--else
				--begin
				--select * from [dbo].[EMailFeatures] where [EMailBoxFeatureId]=@localvar
				--set @EMail_ADDON_localvar=(select [AddOnFeaturesId] from [dbo].[EMailFeatures] where [EMailBoxFeatureId]=@localvar )
				select * from [dbo].[tblAccessTypeMaster] where [TenantId]=(select [TenantId] from [dbo].[tblTenant] where [TenantName]=@TenantName)
				--end
				--set @localvar=(select [ProcessingFeatureId] from [dbo].[TenantProgramFeatures])
				--if( @localvar is not null)
				--select * from [dbo].[EMailFeatures] where [EMailBoxFeatureId]=@localvar


				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error selecting from USP_GET_ZoneANDMenuChanges. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					SELECT SCOPE_IDENTITY()--RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END
   
	
END










GO
/****** Object:  StoredProcedure [dbo].[USP_SET_EMail_MailBoxLoginDetails]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[USP_SET_EMail_MailBoxLoginDetails] 
    @szUserId varchar(50),
	@szPassword varchar(50),
	@IsLocked bit,
	@IsActive bit,
	@szTenantName varchar(50)

AS 
BEGIN 
BEGIN TRY

If exists(select UserId from [dbo].[tblTenantInstance] where UserId=@szUserId)
begin
update [tblTenantInstance] set Password=@szPassword,IsLocked=@IsLocked,IsActive=@IsActive
end
else
begin
insert into [tblTenantInstance] select NUll,@szUserId,@szPassword,NULL,NULL,
TenantId=(select tblT.TenantId from [dbo].[tblTenant] tblT join [tblTenantInstance] tblTI on tblTI.TenantId=tblT.TenantId where tblT.TenantName=@szTenantName),
@IsLocked,@IsActive
 end
 End Try
 BEGIN CATCH
	DECLARE @ErrorMessage NVARCHAR(4000);  
    DECLARE @ErrorSeverity INT;  
    DECLARE @ErrorState INT;  
    SET @ErrorMessage = ERROR_MESSAGE();  
    SET @ErrorSeverity = ERROR_SEVERITY();  
    SET @ErrorState = ERROR_STATE();  
    RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
	--RETURN -1  
 END CATCH
 END




GO
/****** Object:  StoredProcedure [dbo].[USP_SET_Hierarchy]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[USP_SET_Hierarchy]  
	@HierarchyLevel int,
	@HierarchyLevelName nvarchar(50),
	@HierarchyName nvarchar(50) ,
	@HierarchyDesc nvarchar(250) ,	
	@IsActive bit,
	@CreatedBy nvarchar(50),
	--@CreatedDate datetime,
	@TenantName Varchar(50) ,
	@ParentHierarchyName Varchar(50),--eg vertical, its value is Healthcare
	@ParentHierarchyValue varchar(50),
	@HierarchyPOC varchar(50)
    
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		declare @output int;
		declare @localvar int;	
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY
				if (@HierarchyLevel=1)
				INSERT INTO [dbo].[Hierarchy] select @HierarchyLevel,@HierarchyLevelName,@HierarchyName,@HierarchyDesc,NULL,@IsActive,@CreatedBy,GETDATE(),
					TenantId=(select tblT.TenantId from [dbo].[tblTenant] tblT left join Hierarchy tblH on tblT.TenantId=tblH.TenantId where tblT.TenantName=@TenantName),@HierarchyPOC
    else	
	INSERT INTO [dbo].[Hierarchy] select @HierarchyLevel,@HierarchyLevelName,@HierarchyName,@HierarchyDesc,
	ParentId= (select tblHBase.HierarchyID from [dbo].[Hierarchy] tblHDerived join Hierarchy tblHBase on tblHDerived.HierarchyID=tblHBase.HierarchyID where tblHBase.HierarchyLevelName=@ParentHierarchyName and tblHBase.HierarchyName=@ParentHierarchyValue),
	@IsActive,@CreatedBy,GETDATE(),
	TenantId=(select tblT.TenantId from [dbo].[tblTenant] tblT where tblT.TenantName=@TenantName),@HierarchyPOC
	
	select * from [Hierarchy]
	if(@HierarchyLevelName='Program' or @HierarchyLevelName='SubProcess')
	update  [dbo].[TenantProgramFeatures] set [ProgramId]=(select SCOPE_IDENTITY() )--HierarchyID from [dbo].[Hierarchy] where HierarchyName=@HierarchyName )
					where [TenantId]=(select TenantId from [dbo].[tblTenant] where TenantName=@TenantName)
					
				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Inserting into table Hierarchy. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					SELECT SCOPE_IDENTITY()--RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END
   
	
END









GO
/****** Object:  StoredProcedure [dbo].[USP_SET_LookUp]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[USP_SET_LookUp]  
	@LookUpLevel int,
	@LookUpLevelName nvarchar(50),
	@LookUpName nvarchar(50) ,
	@LookUpDesc nvarchar(250) ,	
	@LookUpValue nvarchar(250) ,	
	@IsActive bit,
	@CreatedBy nvarchar(50),
	--@CreatedDate datetime,
	@TenantName Varchar(50) ,
	@ParentLookUpName Varchar(50),--eg vertical, its value is Healthcare
	@ParentLookUpValue varchar(50)
	
    
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		declare @output int;
		declare @localvar int;	
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY
				if (@LookUpLevel=1)
				INSERT INTO [dbo].[Lookup] select @LookUpLevel,@LookUpLevelName,@LookUpName,@LookUpDesc,@LookUpValue,NULL,@IsActive,@CreatedBy,GETDATE(),
					TenantId=(select tblT.TenantId from [dbo].[tblTenant] tblT left join Lookup tblH on tblT.TenantId=tblH.TenantId where tblT.TenantName=@TenantName)
    else	
	INSERT INTO [dbo].[Lookup] select @LookUpLevel,@LookUpLevelName,@LookUpName,@LookUpDesc,@LookUpValue,
	ParentId= (select tblHBase.[LookupID] from [dbo].[Lookup] tblHDerived join [Lookup] tblHBase on tblHDerived.LookupID=tblHBase.LookupID where tblHBase.LookUpLevelName=@LookUpLevelName and tblHBase.LookUpName=@ParentLookUpValue),
	@IsActive,@CreatedBy,GETDATE(),
	TenantId=(select tblT.TenantId from [dbo].[tblTenant] tblT where tblT.TenantName=@TenantName)
	
	--select * from [dbo].[Lookup]
	--if(@LookUpLevelName='Program' or @HierarchyLevelName='SubProcess')
	--update  [dbo].[TenantProgramFeatures] set [ProgramId]=(select SCOPE_IDENTITY() )--HierarchyID from [dbo].[Hierarchy] where HierarchyName=@HierarchyName )
	--				where [TenantId]=(select TenantId from [dbo].[tblTenant] where TenantName=@TenantName)
					
				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Inserting into table LookUp. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					SELECT SCOPE_IDENTITY()--RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END
   
	
END










GO
/****** Object:  StoredProcedure [dbo].[USP_SET_MailBoxFeatures]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE PROCEDURE [dbo].[USP_SET_MailBoxFeatures]
--	@sOpertaionName VarChar(50),	
	@EMailBoxName VarChar(100),
    @EMailBoxAddress VarChar(100),
    @EMailFolderPath VarChar(100),
	 @Domain VarChar(100),
   -- @UserId VarChar(100),
  --  @Password VarChar(50),
 --   @CountryId int,
   -- @SubProcessGroupId int,
    @TATInHours VarChar(50),
	 @IsActive bit, 
	  @IsQCRequired bit,
    @CreatedById VarChar(50),
    @CreatedDate datetime,
	 @TimeZone VarChar(100),
	 @IsMailTriggerRequired bit,
  --  @EmailBoxLoginDetailId bigint,   
	   @IsReplyNotRequired bit,  
	       @TATInSeconds int,
    @Offset VarChar(100),
    @EMailBoxAddressOptional VarChar(max),
    @IsVOCSurvey bit,
--Fields for [dbo].[tblEMT_ADDON_Features]
	 @IsADLogin bit,
    @IsSubjectEditable bit,
    @IsGMBToGMB bit,
    @IsConversationHistory bit,
    @IsCustomizableCaseId bit,
	@TenantName varchar(50),
	@HierarchyName varchar(50),
	@HierarchyLevelName varchar(50)
	


   
    
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		declare @output int;
		declare @localvar int;
		declare @localUserId varchar(50);
		declare @localPwd varchar(50);
		declare @localCountryId int;
		declare @localSubProcessId int;
		declare @localProgramId int;
	--IF (@sOpertaionName = 'INSERT')
	if exists(select tblemt.EMailBoxName from [dbo].[EMailFeatures]tblemt where tblemt.EMailBoxName=@EMailBoxName )

	BEGIN 
	
			BEGIN TRAN TXN_UPDATE
				BEGIN TRY
								
				UPDATE [dbo].[tblEMT_ADDON_Features]
					set  IsADLogin=@IsADLogin,IsSubjectEditable= @IsSubjectEditable,IsGMBToGMB= @IsGMBToGMB,IsConversationHistory= @IsConversationHistory,IsCustomizableCaseId=@IsCustomizableCaseId
					
				UPDATE [dbo].[EMailFeatures]
					set EMailBoxName=@EMailBoxName,EMailBoxAddress= @EMailBoxAddress,EMailFolderPath= @EMailFolderPath,Domain=@Domain,
					TATInHours= @TATInHours,IsActive= @IsActive,IsQCRequired= @IsQCRequired,CreatedById= @CreatedById,CreatedDate=@CreatedDate,
					IsMailTriggerRequired= @IsMailTriggerRequired,IsReplyNotRequired= @IsReplyNotRequired, TATInSeconds=@TATInSeconds,
					TimeZone=@TimeZone,Offset=@Offset, EMailBoxAddressOptional=@EMailBoxAddressOptional,IsVOCSurvey=@IsVOCSurvey

				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Updating table EMailFeatures. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_UPDATE
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_UPDATE
					SELECT 1
		END

		ELSE
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY
				INSERT INTO [dbo].[tblEMT_ADDON_Features]
					SELECT  @IsADLogin, @IsSubjectEditable, @IsGMBToGMB, @IsConversationHistory,@IsCustomizableCaseId
					set @localvar=(SELECT SCOPE_IDENTITY() )
					
					select @localUserId=TI.UserId,@localPwd=TI.Password from [dbo].tblTenantInstance TI join [dbo].[tblTenant] Tent on Tent.TenantId=
					TI.TenantId where Tent.TenantName=@TenantName

					set @localSubProcessId=(select tblH.HierarchyID from [dbo].[Hierarchy] tblH join tblTenant tblT on tblT.TenantId=tblH.TenantId where tblT.TenantName=@TenantName and tblH.HierarchyName=@HierarchyName and tblH.HierarchyLevelName=@HierarchyLevelName)

				INSERT INTO [dbo].[EMailFeatures]
					SELECT @EMailBoxName, @EMailBoxAddress, @EMailFolderPath,@Domain,
					 @localUserId, @localPwd,					  
					  CountryId=(select  tblH.ParentId from [dbo].[Hierarchy]tblH where tblH.HierarchyID=@localSubProcessId), 
					 SubProcessGroupId=@localSubProcessId, 
					 @TATInHours, @IsActive, @IsQCRequired, @CreatedById,@CreatedDate,
					 @IsMailTriggerRequired,
					 EmailBoxLoginDetailId=(select TI.TenantDbId from [dbo].tblTenantInstance TI join [dbo].[tblTenant] Tent on Tent.TenantId=
					TI.TenantId where Tent.TenantName=@TenantName and TI.IsActive=1 and TI.ServerName = NULL and TI.ConnectionString = NULL ),
					  @IsReplyNotRequired,
					  TATInSeconds=@TATInSeconds,
					@TimeZone,@Offset, @EMailBoxAddressOptional,@IsVOCSurvey,@localvar,TenantId=(select TenantId from [dbo].[tblTenant] where TenantName=@TenantName)
					
					set @localProgramId=(SELECT SCOPE_IDENTITY())

					update  [dbo].[TenantProgramFeatures] set MailFeatureId=@localProgramId,CreatedBy= @CreatedById,CreatedDate= @CreatedDate,ModifiedBy=@CreatedById,ModifiedDate=@CreatedDate
					where [TenantId]=(select TenantId from [dbo].[tblTenant] where TenantName=@TenantName)
					
				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Inserting into table EMailFeatures and tblEMT_ADDON_Features. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					SELECT SCOPE_IDENTITY()--RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END

END










GO
/****** Object:  StoredProcedure [dbo].[USP_SET_TenantDetails]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_SET_TenantDetails]
	@iTenantDbId [int]=null,
	@iTenantId [int]=null,
   @szDatabaseName VarChar(50),
	@szUserId VarChar(50),
	@szPassword VarChar(50),
	@szServerName VarChar(50),
	@szInstanceName VarChar(50),
	@szConnectionString VarChar(250),
	@szTenantName VarChar(50),
	@iTenantUserId int, --POC
	@szLicenceKey VarChar(50),
	@szURL varchar(50)=null,
	@dsEffectiveFrom datetime,
	@dsEffectiveTo datetime,	
	@szSameURL VarChar(50),
	@szAppId varchar(50),
	@sOpertaionName VarChar(50),
		@IsActive bit,
@IsADLogin bit
	

    
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		declare @output int;
		declare @localvar int;
	IF (@sOpertaionName = 'INSERT')
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY
			
				INSERT INTO [dbo].[tblTenant] ([TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo],[AppId],[IsADLogin])
					SELECT @szTenantName,@szInstanceName,@iTenantUserId,@szLicenceKey,@szSameURL,@szURL,@dsEffectiveFrom,@dsEffectiveTo,@szAppId,@IsADLogin
					set @localvar=SCOPE_IDENTITY()
					INSERT INTO [dbo].[tblTenantInstance] ([DatabaseName], [UserId], [Password], [ServerName],[ConnectionString],[TenantId],[IsLocked],[IsActive])
					SELECT @szDatabaseName,@szUserId,@szPassword,@szServerName,@szConnectionString,@localvar,NULL,@IsActive
				
				Insert into [dbo].[TenantProgramFeatures] select @localvar,NULL,NULL,NULL,NULL,@IsActive,NULL,NULL,NULL,NULL

				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Inserting into table tblTenantInstance and tblTenant. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					SELECT SCOPE_IDENTITY()--RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END
    ELSE IF (@sOpertaionName = 'UPDATE')
		BEGIN 
	
			BEGIN TRAN TXN_UPDATE
				BEGIN TRY
					--UPDATE [dbo].[tblTenantDBDetails]
					--SET    [szDatabaseName] = @szDatabaseName, [szUserId] = @szUserId, [szPassword] = @szPassword, [szServerName] = @szServerName
					--WHERE  [iTenantDbId] = @iTenantDbId
				
					UPDATE [dbo].[tblTenant]
					set EffectiveTo=@dsEffectiveTo
					where TenantId=@iTenantId

				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Updating table tblTenant. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_UPDATE
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_UPDATE
					SELECT 1
		END
	ELSE IF (@sOpertaionName = 'DELETE')
		BEGIN 
	
			BEGIN TRAN TXN_DELETE
				BEGIN TRY
					DELETE
					FROM   [dbo].[tblTenantInstance]
					WHERE  [TenantDbId] = @iTenantDbId
				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Deleting from table tblTenantInstance. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_DELETE
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_DELETE
					SELECT 1
		END
END










GO
/****** Object:  StoredProcedure [dbo].[USP_SET_ZoneANDMenuDetails]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[USP_SET_ZoneANDMenuDetails]	
   @szMenuName VarChar(50),
	@szMenuDesc VarChar(50),
	@szMenuControllerName VarChar(50),
	@szMenuActionName VarChar(50),
	@iSequenceNo int,
	@bIsActive bit,
	@szAccessType VarChar(500),
	@szCategory VarChar(500),
	@szZoneName VarChar(50),
	@szZoneDesc VarChar(50),
	@szZoneOffsetName VarChar(50),
	@szZoneOffsetDesc VarChar(50),
	@szTenantName VarChar(50)

    
AS
BEGIN
		SET NOCOUNT ON 
		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;
		declare @output int;
		declare @localvar int;
	---IF (@sOpertaionName = 'INSERT')
		BEGIN
	
		BEGIN TRAN TXN_INSERT
				BEGIN TRY
			
				INSERT INTO [dbo].[tblZoneMaster]
					SELECT @szZoneName,@szZoneDesc,@szZoneOffsetName,@szZoneOffsetDesc,TenantId=(select TenantId from [dbo].[tblTenant] where TenantName= @szTenantName )
					

					INSERT INTO [dbo].[tblAccessMenuMaster]
					SELECT @szMenuName,	@szMenuDesc,@szMenuControllerName,@szMenuActionName,@iSequenceNo,@bIsActive,TenantId=(select TenantId from [dbo].[tblTenant] where TenantName= @szTenantName )
					set @localvar=(select SCOPE_IDENTITY())

				Insert into [dbo].[tblAccessTypeMaster]
				select @localvar,@szAccessType,@szCategory,@bIsActive,TenantId=(select TenantId from [dbo].[tblTenant] where TenantName= @szTenantName )
	
				select 1

				END TRY
				BEGIN CATCH
					SET @ErrorMessage = CONCAT('Error Inserting into table tblZoneMaster, tblAccessMenuMaster and tblAccessTypeMaster. ',ERROR_MESSAGE());  
					SET @ErrorSeverity = ERROR_SEVERITY();  
					SET @ErrorState = ERROR_STATE();  
					RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
					IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_INSERT
					SELECT -1
				END CATCH
				IF @@TRANCOUNT > 0 COMMIT TRAN TXN_INSERT				
					SELECT SCOPE_IDENTITY()--RETURN @@IDENTITY-- SCOPE_IDENTITY() --1 --select @@IDENTITY
		END
 --   ELSE IF (@sOpertaionName = 'UPDATE')
	--	BEGIN 
	
	--		BEGIN TRAN TXN_UPDATE
	--			BEGIN TRY
	--				--UPDATE [dbo].[tblTenantDBDetails]
	--				--SET    [szDatabaseName] = @szDatabaseName, [szUserId] = @szUserId, [szPassword] = @szPassword, [szServerName] = @szServerName
	--				--WHERE  [iTenantDbId] = @iTenantDbId
				
	--				UPDATE [dbo].[tblTenant]
	--				set EffectiveTo=@dsEffectiveTo
	--				where TenantId=@iTenantId

	--			END TRY
	--			BEGIN CATCH
	--				SET @ErrorMessage = CONCAT('Error Updating table tblTenant. ',ERROR_MESSAGE());  
	--				SET @ErrorSeverity = ERROR_SEVERITY();  
	--				SET @ErrorState = ERROR_STATE();  
	--				RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
	--				IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_UPDATE
	--				SELECT -1
	--			END CATCH
	--			IF @@TRANCOUNT > 0 COMMIT TRAN TXN_UPDATE
	--				SELECT 1
	--	END
	--ELSE IF (@sOpertaionName = 'DELETE')
	--	BEGIN 
	
	--		BEGIN TRAN TXN_DELETE
	--			BEGIN TRY
	--				DELETE
	--				FROM   [dbo].[tblTenantInstance]
	--				WHERE  [TenantDbId] = @iTenantDbId
	--			END TRY
	--			BEGIN CATCH
	--				SET @ErrorMessage = CONCAT('Error Deleting from table tblTenantInstance. ',ERROR_MESSAGE());  
	--				SET @ErrorSeverity = ERROR_SEVERITY();  
	--				SET @ErrorState = ERROR_STATE();  
	--				RAISERROR (@ErrorMessage,@ErrorSeverity,@ErrorState);
	--				IF @@TRANCOUNT > 0 ROLLBACK TRAN TXN_DELETE
	--				SELECT -1
	--			END CATCH
	--			IF @@TRANCOUNT > 0 COMMIT TRAN TXN_DELETE
	--				SELECT 1
	--	END
END










GO
/****** Object:  Table [dbo].[EMailFeatures]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EMailFeatures](
	[EMailBoxFeatureId] [int] IDENTITY(1,1) NOT NULL,
	[EMailBoxName] [varchar](100) NOT NULL,
	[EMailBoxAddress] [varchar](100) NOT NULL,
	[EMailFolderPath] [varchar](500) NOT NULL,
	[Domain] [varchar](10) NULL,
	[UserId] [varchar](100) NULL,
	[Password] [varchar](100) NULL,
	[ProcessId] [int] NOT NULL,
	[SubProcessId] [int] NOT NULL,
	[TATInHours] [varchar](50) NULL,
	[IsActive] [bit] NOT NULL,
	[IsQCRequired] [bit] NOT NULL,
	[CreatedById] [varchar](50) NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[IsMailTriggerRequired] [bit] NOT NULL,
	[IsReplyNotRequired] [bit] NOT NULL,
	[TATInSeconds] [int] NULL,
	[TimeZone] [varchar](100) NULL,
	[Offset] [varchar](100) NULL,
	[EMailBoxAddressOptional] [varchar](max) NULL,
	[IsVOCSurvey] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[IsSubjectEditable] [bit] NULL,
	[IsGMBToGMB] [bit] NULL,
	[IsConversationHistory] [bit] NULL,
	[IsCustomizableCaseId] [bit] NULL,
 CONSTRAINT [PK_MailBox] PRIMARY KEY CLUSTERED 
(
	[EMailBoxFeatureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 85) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Hierarchy]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Hierarchy](
	[HierarchyID] [int] IDENTITY(1,1) NOT NULL,
	[HierarchyLevel] [int] NULL,
	[HierarchyLevelName] [nvarchar](50) NULL,
	[HierarchyName] [nvarchar](50) NULL,
	[HierarchyDesc] [nvarchar](250) NULL,
	[ParentId] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[TenantId] [int] NULL,
	[HierarchyPOC] [varchar](50) NULL,
 CONSTRAINT [PK_Hierarchy] PRIMARY KEY CLUSTERED 
(
	[HierarchyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Lookup]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lookup](
	[LookupID] [int] IDENTITY(1,1) NOT NULL,
	[LookupLevel] [int] NULL,
	[LookupLevelName] [nvarchar](50) NULL,
	[LookupName] [nvarchar](50) NULL,
	[LookupDesc] [nvarchar](250) NULL,
	[LookupValue] [nvarchar](250) NULL,
	[ParentId] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_Lookup] PRIMARY KEY CLUSTERED 
(
	[LookupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblAccessMenuMaster]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAccessMenuMaster](
	[iMenuId] [int] IDENTITY(1,1) NOT NULL,
	[szMenuName] [varchar](100) NULL,
	[szMenuDesc] [varchar](200) NULL,
	[szMenuControllerName] [varchar](50) NULL,
	[szMenuActionName] [varchar](50) NULL,
	[iSequenceNo] [int] NULL,
	[bIsActive] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_tblMenuMaster] PRIMARY KEY CLUSTERED 
(
	[iMenuId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAccessTypeMaster]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAccessTypeMaster](
	[iAccessTypeId] [int] IDENTITY(1,1) NOT NULL,
	[iMenuId] [int] NOT NULL,
	[szAccessType] [varchar](500) NOT NULL,
	[szCategory] [varchar](500) NULL,
	[bIsActive] [bit] NOT NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_tblAccessMenuMap] PRIMARY KEY CLUSTERED 
(
	[iAccessTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblAuditFeatures]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblAuditFeatures](
	[iProgramFeaturesSetUpId] [int] IDENTITY(1,1) NOT NULL,
	[siProgramId] [smallint] NOT NULL,
	[bIsSupervisorAuditApplicable] [bit] NOT NULL,
	[szAuditingLogic] [varchar](500) NOT NULL,
	[szScoringLogic] [varchar](500) NOT NULL,
	[bIsEmployeeApplicable] [bit] NOT NULL,
	[bIsEnableDataEntryByAuditor] [bit] NOT NULL,
	[bIsEnablePeerToPeerAuditInfo] [bit] NOT NULL,
	[iNoOfElement] [int] NOT NULL,
	[szSystemEffects] [varchar](500) NOT NULL,
	[bIsDefaultRating] [bit] NULL,
	[bIsStratifiedSamplingRequired] [bit] NULL,
	[bIsFreezingOfSamples] [bit] NOT NULL,
	[bIsFreezingOfExternalSamples] [bit] NULL,
	[bIsFatalErrorApplicable] [bit] NOT NULL,
	[bIsSLAActivityApplicable] [bit] NULL,
	[bIsTotalVolumeApplicable] [bit] NULL,
	[bIsMailTriggerRequired] [bit] NOT NULL,
	[bIsReworkRemainderMailRequired] [bit] NOT NULL,
	[iMaxRemainderCnt] [int] NOT NULL,
	[iMailSchedulerFrequency] [int] NULL,
	[szMailboxName] [varchar](500) NULL,
	[szAuditTypes] [varchar](500) NULL,
	[iMaxCorrectionCnt] [int] NULL,
	[bIsMetricsRequired] [bit] NULL,
	[bIsWorkFlowNeedforCorrection] [bit] NULL,
	[iCreatedBy] [int] NOT NULL,
	[dsCreatedDate] [smalldatetime] NOT NULL,
	[iModifiedBy] [int] NOT NULL,
	[dsModifiedDate] [smalldatetime] NOT NULL,
	[bIsLineApplicable] [bit] NULL,
	[iMaxCorrectionDayCnt] [int] NULL,
	[bIsDayNeedforCorrection] [bit] NULL,
	[bIsDOCriticality] [bit] NULL,
	[bIsTATEnable] [bit] NULL,
	[bIsCombinedAccuracy] [bit] NULL,
	[bIsDeletMailEnable] [bit] NULL,
	[szDateFormat] [varchar](50) NULL,
	[szSamplingMethodInternal] [varchar](30) NULL,
	[szSamplingMethodBusiness] [varchar](30) NULL,
	[iIntAllocCnt] [int] NULL,
	[iExtAllocCnt] [int] NULL,
	[iBusiAllocCnt] [int] NULL,
	[szStaticFields] [varchar](500) NULL,
	[blsAHTEnable] [bit] NULL,
	[blsCTQComments] [bit] NULL,
	[bIsRatingDifferenceMailEnable] [bit] NULL,
	[bIsSLAAccuracyEnabled] [bit] NULL,
	[szSamplingPctCalculation] [varchar](30) NULL,
	[IsFatalMailRequire] [bit] NULL,
	[IsSLABasedSubProcess] [bit] NULL,
	[szCombinedAccuracyType] [varchar](20) NULL,
	[bIsSamplingtypeCustomMode] [bit] NULL,
	[bIsDataPurgingEnabled] [bit] NULL,
	[bIsSubProcessValidationEnabled] [bit] NULL,
	[bIsStaticConditionEnabled] [bit] NULL,
	[bIsTop5MailDataElement] [bit] NULL,
	[bSamplingByVolume] [bit] NULL,
	[szRestriction_MaxLength] [varchar](500) NULL,
	[TenantId] [int] NULL,
 CONSTRAINT [PK_tblProgramFeaturesSetUpMaster] PRIMARY KEY CLUSTERED 
(
	[iProgramFeaturesSetUpId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblEMT_ADDON_Features]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tblEMT_ADDON_Features](
	[AddOnFeaturesId] [int] IDENTITY(1,1) NOT NULL,
	[IsADLogin] [bit] NOT NULL,
	[IsSubjectEditable] [bit] NOT NULL,
	[IsGMBToGMB] [bit] NOT NULL,
	[IsConversationHistory] [bit] NOT NULL,
	[IsCustomizableCaseId] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[AddOnFeaturesId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[tblTenant]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTenant](
	[TenantId] [int] IDENTITY(1,1) NOT NULL,
	[TenantName] [varchar](50) NOT NULL,
	[InstanceName] [varchar](50) NOT NULL,
	[TenantUserId] [int] NOT NULL,
	[LicenceKey] [varchar](50) NOT NULL,
	[SameURL] [bit] NOT NULL,
	[URL] [varchar](50) NULL,
	[EffectiveFrom] [datetime] NOT NULL,
	[EffectiveTo] [datetime] NOT NULL,
	[AppId] [varchar](50) NOT NULL,
	[IsADLogin] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[TenantId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[tblTenantInstance]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[tblTenantInstance](
	[TenantDbId] [int] IDENTITY(1,1) NOT NULL,
	[DatabaseName] [varchar](50) NULL,
	[UserId] [varchar](50) NOT NULL,
	[Password] [varchar](50) NOT NULL,
	[ServerName] [varchar](50) NULL,
	[ConnectionString] [varchar](250) NULL,
	[TenantId] [int] NULL,
	[IsLocked] [bit] NULL,
	[IsActive] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[TenantDbId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[TenantProgramFeatures]    Script Date: 11/8/2017 10:03:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TenantProgramFeatures](
	[TenantProgramId] [int] IDENTITY(1,1) NOT NULL,
	[TenantId] [int] NULL,
	[ProgramId] [int] NULL,
	[AuditFeatureId] [int] NULL,
	[MailFeatureId] [int] NULL,
	[ProcessingFeatureId] [int] NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedBy] [nvarchar](50) NULL,
	[ModifiedDate] [datetime] NULL
) ON [PRIMARY]

GO
SET IDENTITY_INSERT [dbo].[EMailFeatures] ON 

INSERT [dbo].[EMailFeatures] ([EMailBoxFeatureId], [EMailBoxName], [EMailBoxAddress], [EMailFolderPath], [Domain], [UserId], [Password], [ProcessId], [SubProcessId], [TATInHours], [IsActive], [IsQCRequired], [CreatedById], [CreatedDate], [IsMailTriggerRequired], [IsReplyNotRequired], [TATInSeconds], [TimeZone], [Offset], [EMailBoxAddressOptional], [IsVOCSurvey], [TenantId], [IsSubjectEditable], [IsGMBToGMB], [IsConversationHistory], [IsCustomizableCaseId]) VALUES (2, N'Mail1', N'addr', N'Path1', N'Domain', N'sa', N'pwd', 7, 8, N'40', 1, 1, N'123', CAST(0x0000A7E1010EAD25 AS DateTime), 1, 1, 2, N'T1', N'12', N'em1', 1, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[EMailFeatures] OFF
SET IDENTITY_INSERT [dbo].[Hierarchy] ON 

INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (1, 1, N'Vertical', N'Insurance', N'Insurance', NULL, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (2, 1, N'Vertical', N'HealthCare', N'HealthCare', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (3, 2, N'Account', N'HIG', N'HIG', 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (4, 2, N'Account', N'ING', N'ING', 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (5, 2, N'Account', N'Utica', N'Utica', 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (6, 2, N'Account', N'HealthCare', N'HealthCare', 2, NULL, NULL, NULL, 1, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (7, 1, N'Country', N'IPA', N'IPA', NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (8, 2, N'SubProcess', N'BPOHealthDesk', N'BPOHealthDesk', 7, NULL, NULL, NULL, 1, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (9, 3, N'Program', N'HealthCare', N'HealthCare', 6, NULL, NULL, NULL, 1, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (10, 3, N'MailBox', N'HelpDESK@Cognizant.com', N'HelpDESK@Cognizant.com', 8, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (14, 1, N'Vertical', N'F&A', N'FundAndAccounting', NULL, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (15, 2, N'Account', N'Patheon', N'Patheon', 14, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (16, 3, N'Process', N'PatheonProcurmet', N'PatheonProcurmet', 15, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (17, 4, N'SubProcess', N'Procrument', N'Procrument', 16, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[Hierarchy] ([HierarchyID], [HierarchyLevel], [HierarchyLevelName], [HierarchyName], [HierarchyDesc], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId], [HierarchyPOC]) VALUES (18, 5, N'Mailbox', N'Patheon', N'Patheon', 17, 1, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Hierarchy] OFF
SET IDENTITY_INSERT [dbo].[Lookup] ON 

INSERT [dbo].[Lookup] ([LookupID], [LookupLevel], [LookupLevelName], [LookupName], [LookupDesc], [LookupValue], [ParentId], [IsActive], [CreatedBy], [CreatedDate], [TenantId]) VALUES (1, 1, N'Zone', N'EST', N'Eastern Standard Time', N'UTC-05:00', NULL, 1, NULL, CAST(0x0000A7E700D3FA11 AS DateTime), 1)
SET IDENTITY_INSERT [dbo].[Lookup] OFF
SET IDENTITY_INSERT [dbo].[tblAuditFeatures] ON 

INSERT [dbo].[tblAuditFeatures] ([iProgramFeaturesSetUpId], [siProgramId], [bIsSupervisorAuditApplicable], [szAuditingLogic], [szScoringLogic], [bIsEmployeeApplicable], [bIsEnableDataEntryByAuditor], [bIsEnablePeerToPeerAuditInfo], [iNoOfElement], [szSystemEffects], [bIsDefaultRating], [bIsStratifiedSamplingRequired], [bIsFreezingOfSamples], [bIsFreezingOfExternalSamples], [bIsFatalErrorApplicable], [bIsSLAActivityApplicable], [bIsTotalVolumeApplicable], [bIsMailTriggerRequired], [bIsReworkRemainderMailRequired], [iMaxRemainderCnt], [iMailSchedulerFrequency], [szMailboxName], [szAuditTypes], [iMaxCorrectionCnt], [bIsMetricsRequired], [bIsWorkFlowNeedforCorrection], [iCreatedBy], [dsCreatedDate], [iModifiedBy], [dsModifiedDate], [bIsLineApplicable], [iMaxCorrectionDayCnt], [bIsDayNeedforCorrection], [bIsDOCriticality], [bIsTATEnable], [bIsCombinedAccuracy], [bIsDeletMailEnable], [szDateFormat], [szSamplingMethodInternal], [szSamplingMethodBusiness], [iIntAllocCnt], [iExtAllocCnt], [iBusiAllocCnt], [szStaticFields], [blsAHTEnable], [blsCTQComments], [bIsRatingDifferenceMailEnable], [bIsSLAAccuracyEnabled], [szSamplingPctCalculation], [IsFatalMailRequire], [IsSLABasedSubProcess], [szCombinedAccuracyType], [bIsSamplingtypeCustomMode], [bIsDataPurgingEnabled], [bIsSubProcessValidationEnabled], [bIsStaticConditionEnabled], [bIsTop5MailDataElement], [bSamplingByVolume], [szRestriction_MaxLength], [TenantId]) VALUES (1, 4, 0, N'DPO,DPU,WDPO', N'Heading Based', 0, 0, 0, 10, N'Complete', 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 3, N'cQualityFeedback@Cognizant.com', N'Internal,External', 2, 0, 1, 329, CAST(0xA7E7048D AS SmallDateTime), 329, CAST(0xA7E7048D AS SmallDateTime), 1, 2, 1, 1, 1, 1, 1, N'DMY', N'Sub-process', N'Sub-process', 7, 7, 0, NULL, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[tblAuditFeatures] OFF
SET IDENTITY_INSERT [dbo].[tblEMT_ADDON_Features] ON 

INSERT [dbo].[tblEMT_ADDON_Features] ([AddOnFeaturesId], [IsADLogin], [IsSubjectEditable], [IsGMBToGMB], [IsConversationHistory], [IsCustomizableCaseId]) VALUES (4, 1, 1, 1, 1, 1)
INSERT [dbo].[tblEMT_ADDON_Features] ([AddOnFeaturesId], [IsADLogin], [IsSubjectEditable], [IsGMBToGMB], [IsConversationHistory], [IsCustomizableCaseId]) VALUES (5, 1, 1, 1, 1, 1)
INSERT [dbo].[tblEMT_ADDON_Features] ([AddOnFeaturesId], [IsADLogin], [IsSubjectEditable], [IsGMBToGMB], [IsConversationHistory], [IsCustomizableCaseId]) VALUES (15, 1, 1, 1, 1, 0)
INSERT [dbo].[tblEMT_ADDON_Features] ([AddOnFeaturesId], [IsADLogin], [IsSubjectEditable], [IsGMBToGMB], [IsConversationHistory], [IsCustomizableCaseId]) VALUES (16, 1, 1, 1, 1, 0)
INSERT [dbo].[tblEMT_ADDON_Features] ([AddOnFeaturesId], [IsADLogin], [IsSubjectEditable], [IsGMBToGMB], [IsConversationHistory], [IsCustomizableCaseId]) VALUES (18, 1, 1, 1, 1, 1)
INSERT [dbo].[tblEMT_ADDON_Features] ([AddOnFeaturesId], [IsADLogin], [IsSubjectEditable], [IsGMBToGMB], [IsConversationHistory], [IsCustomizableCaseId]) VALUES (19, 1, 1, 0, 0, 0)
INSERT [dbo].[tblEMT_ADDON_Features] ([AddOnFeaturesId], [IsADLogin], [IsSubjectEditable], [IsGMBToGMB], [IsConversationHistory], [IsCustomizableCaseId]) VALUES (20, 1, 1, 0, 0, 0)
SET IDENTITY_INSERT [dbo].[tblEMT_ADDON_Features] OFF
SET IDENTITY_INSERT [dbo].[tblTenant] ON 

INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (1, N'Test', N'Test1', 1, N'License', 0, NULL, CAST(0x0000A7E001054332 AS DateTime), CAST(0x0000A7E001054332 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (2, N'HealthCare', N'test', 2, N'license', 0, NULL, CAST(0x0000A73200000000 AS DateTime), CAST(0x0000A89F00000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (3, N'qwq', N'abc123', 123, N'Sd6/6P5af3Qr3Igzkfb0nwFAGyBJ7YMnppJCuDXyR3IfNGGYwk', 1, N'', CAST(0x0000A81500000000 AS DateTime), CAST(0x0000A81E00000000 AS DateTime), N'QUART', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (4, N'qwert', N'hhh', 123, N'nkiojiull', 1, N'', CAST(0x0000A81500000000 AS DateTime), CAST(0x0000A83B00000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (5, N'qwerttttt', N'potty', 572748, N'Sd6/6P5af3Qr3Igzkfb0n1FDvYaL6QTKq7IrLX2KE4AwWqOduE', 1, N'', CAST(0x0000A81500000000 AS DateTime), CAST(0x0000A83B00000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (6, N'HP123', N'HP123', 572748, N'q/wytDJuYVeSspJY5QwfmCgetl/J30fntWXRVReTR71QqS14sV', 1, N'', CAST(0x0000A81D00000000 AS DateTime), CAST(0x0000A85A00000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (7, N'HP456', N'HP456', 572748, N'q/wytDJuYVeSspJY5QwfmDD5D4V7P8nn+/VLN/+ZlOhdh8BH/7', 1, N'', CAST(0x0000A81D00000000 AS DateTime), CAST(0x0000A85A00000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (8, N'Voya', N'Voya', 188598, N'q/wytDJuYVeSspJY5QwfmBYnWJ+UymT9hG+YvxfEC//QJCSbI4', 0, N'https:// Voya-quart', CAST(0x0000A81D00000000 AS DateTime), CAST(0x0000A85A00000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (9, N'dw', N'aqw', 123, N'q/wytDJuYVeSspJY5QwfmPBAuAZOXL3QCnao9RWEuE+oUNxAHW', 1, N'', CAST(0x0000A81D00000000 AS DateTime), CAST(0x0000A82700000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (10, N'da', N'aass', 12, N'q/wytDJuYVeSspJY5QwfmKTDLHqaYr1hHBE4fZS48JD+S5MHin', 1, N'', CAST(0x0000A81D00000000 AS DateTime), CAST(0x0000A82800000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (11, N'MEDPLUS', N'MEDPLUS', 572748, N'q/wytDJuYVeSspJY5QwfmIJysRN8LgFwP2tTzLlP9EzcaxMUd9', 1, N'', CAST(0x0000A81D00000000 AS DateTime), CAST(0x0000A85A00000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (12, N'ss', N'as', 123456, N'vzsQj6CJP+hTxaqgChN5R9XgXjN1kVPL16ZAM4quNP/O+1JT1q', 1, N'', CAST(0x0000A81F00000000 AS DateTime), CAST(0x0000A83C00000000 AS DateTime), N'Quart', NULL)
INSERT [dbo].[tblTenant] ([TenantId], [TenantName], [InstanceName], [TenantUserId], [LicenceKey], [SameURL], [URL], [EffectiveFrom], [EffectiveTo], [AppId], [IsADLogin]) VALUES (13, N'saqw', N'asz', 12345, N'Sjj6sZLnFFW38/R0yaZ6NzGV6NlhjmTM1m8yshWWPtKIqCGT4Z', 1, N'', CAST(0x0000A82000000000 AS DateTime), CAST(0x0000A84200000000 AS DateTime), N'Quart', NULL)
SET IDENTITY_INSERT [dbo].[tblTenant] OFF
SET IDENTITY_INSERT [dbo].[tblTenantInstance] ON 

INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (1, N'db', N'sa', N'pwd', NULL, N'Data Source=CTSC00806852101; Initial Catalog=QuartcodeBaseUI;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 1, 0, 1)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (2, NULL, N'Suji@gmail.com', N'pd1', NULL, NULL, NULL, 0, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (3, N'HC', N'sa', N'password-1', NULL, N'Data Source=CTSC00806852101; Initial Catalog=HC;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 2, 0, 1)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (4, N'abc123', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=abc123;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 3, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (5, N'hhh', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=hhh;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 4, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (6, N'potty', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=potty;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 5, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (7, N'HP123', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=HP123;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 6, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (8, N'HP456', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=HP456;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 7, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (9, N'Voya', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=Voya;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 8, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (10, N'aqw', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=aqw;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 9, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (11, N'aass', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=aass;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 10, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (12, N'MEDPLUS', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=MEDPLUS;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 11, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (13, N'as', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=as;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 12, NULL, 0)
INSERT [dbo].[tblTenantInstance] ([TenantDbId], [DatabaseName], [UserId], [Password], [ServerName], [ConnectionString], [TenantId], [IsLocked], [IsActive]) VALUES (14, N'asz', N'sa', N'password-1', N'CTSC00806852101', N'Data Source=CTSC00806852101; Initial Catalog=asz;  User Id=sa; Password=password-1; Min Pool Size=10; Max Pool Size=100;Trusted_Connection=No;MultipleActiveResultSets=True;', 13, NULL, 0)
SET IDENTITY_INSERT [dbo].[tblTenantInstance] OFF
SET IDENTITY_INSERT [dbo].[TenantProgramFeatures] ON 

INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (1, 1, 10, 1, 2, NULL, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (2, 3, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (3, 4, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (4, 5, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (5, 6, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (6, 7, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (9, 10, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (10, 11, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (11, 12, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (12, 13, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (7, 8, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
INSERT [dbo].[TenantProgramFeatures] ([TenantProgramId], [TenantId], [ProgramId], [AuditFeatureId], [MailFeatureId], [ProcessingFeatureId], [IsActive], [CreatedBy], [CreatedDate], [ModifiedBy], [ModifiedDate]) VALUES (8, 9, NULL, NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[TenantProgramFeatures] OFF
ALTER TABLE [dbo].[EMailFeatures] ADD  CONSTRAINT [DF_EMailBox_IsVOCSurvey]  DEFAULT ((0)) FOR [IsVOCSurvey]
GO
ALTER TABLE [dbo].[tblAccessMenuMaster] ADD  CONSTRAINT [DF_tblMenuMaster_bIsActive]  DEFAULT ((1)) FOR [bIsActive]
GO
ALTER TABLE [dbo].[tblAccessTypeMaster] ADD  CONSTRAINT [DF_tblAccessMaster_bIsActive]  DEFAULT ((1)) FOR [bIsActive]
GO
ALTER TABLE [dbo].[tblAuditFeatures] ADD  CONSTRAINT [DF_tblProgramFeaturesSetUpMaster_dsCreatedDate]  DEFAULT (getdate()) FOR [dsCreatedDate]
GO
ALTER TABLE [dbo].[tblAuditFeatures] ADD  CONSTRAINT [DF_tblProgramFeaturesSetUpMaster_dsModifiedDate]  DEFAULT (getdate()) FOR [dsModifiedDate]
GO
ALTER TABLE [dbo].[Hierarchy]  WITH CHECK ADD  CONSTRAINT [FK_Hierarchy_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Hierarchy] ([HierarchyID])
GO
ALTER TABLE [dbo].[Hierarchy] CHECK CONSTRAINT [FK_Hierarchy_ParentId]
GO
ALTER TABLE [dbo].[Hierarchy]  WITH CHECK ADD  CONSTRAINT [FK_Hierarchy_TenantId] FOREIGN KEY([TenantId])
REFERENCES [dbo].[tblTenant] ([TenantId])
GO
ALTER TABLE [dbo].[Hierarchy] CHECK CONSTRAINT [FK_Hierarchy_TenantId]
GO
ALTER TABLE [dbo].[Lookup]  WITH CHECK ADD  CONSTRAINT [FK_Lookup_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Lookup] ([LookupID])
GO
ALTER TABLE [dbo].[Lookup] CHECK CONSTRAINT [FK_Lookup_ParentId]
GO
ALTER TABLE [dbo].[Lookup]  WITH CHECK ADD  CONSTRAINT [FK_Lookup_TenantId] FOREIGN KEY([TenantId])
REFERENCES [dbo].[tblTenant] ([TenantId])
GO
ALTER TABLE [dbo].[Lookup] CHECK CONSTRAINT [FK_Lookup_TenantId]
GO
ALTER TABLE [dbo].[tblAccessTypeMaster]  WITH CHECK ADD  CONSTRAINT [FK_tblAccessTypeMaster_tblMenuMaster] FOREIGN KEY([iMenuId])
REFERENCES [dbo].[tblAccessMenuMaster] ([iMenuId])
GO
ALTER TABLE [dbo].[tblAccessTypeMaster] CHECK CONSTRAINT [FK_tblAccessTypeMaster_tblMenuMaster]
GO
ALTER TABLE [dbo].[tblTenantInstance]  WITH CHECK ADD  CONSTRAINT [fk_tblTenantInstance_TenantId] FOREIGN KEY([TenantId])
REFERENCES [dbo].[tblTenant] ([TenantId])
GO
ALTER TABLE [dbo].[tblTenantInstance] CHECK CONSTRAINT [fk_tblTenantInstance_TenantId]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Active status of the defect opportunity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblAccessMenuMaster', @level2type=N'COLUMN',@level2name=N'bIsActive'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User who created program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblAuditFeatures', @level2type=N'COLUMN',@level2name=N'iCreatedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Program creation date' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblAuditFeatures', @level2type=N'COLUMN',@level2name=N'dsCreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'User who last modified the program' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblAuditFeatures', @level2type=N'COLUMN',@level2name=N'iModifiedBy'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date when the program details were last modified' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tblAuditFeatures', @level2type=N'COLUMN',@level2name=N'dsModifiedDate'
GO
USE [master]
GO
ALTER DATABASE [ToolTenant] SET  READ_WRITE 
GO

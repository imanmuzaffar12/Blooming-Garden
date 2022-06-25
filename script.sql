USE [master]
GO
/****** Object:  Database [BloomingGarden]    Script Date: 17/06/2022 7:03:53 am ******/
CREATE DATABASE [BloomingGarden]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'BloomingGarden', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BloomingGarden.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'BloomingGarden_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\BloomingGarden_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [BloomingGarden] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BloomingGarden].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BloomingGarden] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BloomingGarden] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BloomingGarden] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BloomingGarden] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BloomingGarden] SET ARITHABORT OFF 
GO
ALTER DATABASE [BloomingGarden] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BloomingGarden] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BloomingGarden] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BloomingGarden] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BloomingGarden] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BloomingGarden] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BloomingGarden] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BloomingGarden] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BloomingGarden] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BloomingGarden] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BloomingGarden] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BloomingGarden] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BloomingGarden] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BloomingGarden] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BloomingGarden] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BloomingGarden] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BloomingGarden] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BloomingGarden] SET RECOVERY FULL 
GO
ALTER DATABASE [BloomingGarden] SET  MULTI_USER 
GO
ALTER DATABASE [BloomingGarden] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BloomingGarden] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BloomingGarden] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BloomingGarden] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [BloomingGarden] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [BloomingGarden] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'BloomingGarden', N'ON'
GO
ALTER DATABASE [BloomingGarden] SET QUERY_STORE = OFF
GO
USE [BloomingGarden]
GO
/****** Object:  UserDefinedFunction [dbo].[TimeElapsed]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TimeElapsed] 
(
  @DateTime DATETIME,
  @LanguageID INT
)
RETURNS NVARCHAR(50)
AS
BEGIN
    RETURN 
    (
        SELECT TimeElapsed = 
            CASE
                WHEN @DateTime IS NULL THEN NULL
                WHEN SECONDS_AGO < 60 THEN CONCAT(MINUTES_AGO, 
					(CASE WHEN @LanguageID = 1 THEN N' منذ ثوانى' ELSE ' sec ago' END)
				)
                WHEN MINUTES_AGO < 60 THEN CONCAT(MINUTES_AGO, 
					(CASE WHEN @LanguageID = 1 THEN N' دقائق مضت' ELSE ' mins ago' END)
				)
                WHEN HOURS_AGO < 24 THEN CONCAT(HOURS_AGO, 
					(CASE WHEN @LanguageID = 1 THEN N' منذ ساعات' ELSE ' hrs ago' END)
				)
                WHEN DAYS_AGO < 365 THEN CONCAT(DAYS_AGO, 
					(CASE WHEN @LanguageID = 1 THEN N' أيام مضت' ELSE 'd ago' END)
				)
                ELSE CONCAT(YEARS_AGO, 
					(CASE WHEN @LanguageID = 1 THEN N' منذ عام' ELSE 'y ago' END)
				) END
        FROM ( 
		SELECT SECONDS_AGO = DATEDIFF(SECOND, @DateTime, GETDATE()) ) TIMESPAN_SEC
		CROSS APPLY ( SELECT MINUTES_AGO = DATEDIFF(MINUTE, @DateTime, GETDATE())) TIMESPAN_MIN
        CROSS APPLY ( SELECT HOURS_AGO = DATEDIFF(HOUR, @DateTime, GETDATE())) TIMESPAN_HOUR
        CROSS APPLY ( SELECT DAYS_AGO = DATEDIFF(DAY, @DateTime, GETDATE())) TIMESPAN_DAY
        CROSS APPLY ( SELECT YEARS_AGO = DATEDIFF(YEAR, @DateTime, GETDATE())) TIMESPAN_YEAR
    )
END
GO
/****** Object:  Table [dbo].[APIConfigurations]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[APIConfigurations](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[UrlName] [nvarchar](50) NULL,
	[MethodType] [nvarchar](50) NULL,
	[Description] [nvarchar](500) NULL,
	[URL] [nvarchar](500) NULL,
	[SqlQuery] [nvarchar](max) NOT NULL,
	[DefaultParams] [nvarchar](2048) NULL,
	[IsActive] [bit] NULL,
	[UrlParams] [nvarchar](500) NULL,
	[DataParams] [nvarchar](max) NULL,
	[SuccessResponse] [nvarchar](500) NULL,
	[ErrorResponse] [nvarchar](500) NULL,
	[SampleCall] [nvarchar](500) NULL,
	[Notes] [nvarchar](500) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[IsCacheAllowed] [bit] NULL,
 CONSTRAINT [PK_APIConfigurations] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppConfigs]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppConfigs](
	[AppConfigID] [int] IDENTITY(1,1) NOT NULL,
	[AppConfigKey] [nvarchar](max) NOT NULL,
	[AppConfigValue] [nvarchar](max) NOT NULL,
	[CreatedBy] [int] NULL,
	[ModifiedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_AppConfigs] PRIMARY KEY CLUSTERED 
(
	[AppConfigID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AppMenus]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppMenus](
	[AppMenuID] [int] IDENTITY(1,1) NOT NULL,
	[NameEn] [nvarchar](500) NOT NULL,
	[NameAr] [nvarchar](500) NOT NULL,
	[NameTr] [nvarchar](500) NULL,
	[IsActive] [bit] NOT NULL,
	[MenuUrl] [nvarchar](50) NULL,
	[ActiveIconUrl] [nvarchar](200) NULL,
	[InActiveIconUrl] [nvarchar](200) NULL,
	[DisplaySeqNo] [int] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_AppMenus] PRIMARY KEY CLUSTERED 
(
	[AppMenuID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Blogs]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Blogs](
	[BlogID] [int] IDENTITY(1,1) NOT NULL,
	[BlogName] [nvarchar](50) NOT NULL,
	[BlogDetails] [nvarchar](500) NOT NULL,
	[BlogImageUrl] [nvarchar](500) NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_Blogs] PRIMARY KEY CLUSTERED 
(
	[BlogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[CategoryID] [int] IDENTITY(1,1) NOT NULL,
	[NameAr] [nvarchar](500) NOT NULL,
	[NameEn] [nvarchar](500) NOT NULL,
	[ParentCategoryID] [int] NULL,
	[DisplaySeqNo] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[ImageUrl] [nvarchar](200) NULL,
	[ImageUrl2] [nvarchar](200) NULL,
	[IsDeleted] [bit] NOT NULL,
	[WebImages] [varchar](600) NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[CategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cities]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cities](
	[CityID] [int] IDENTITY(1,1) NOT NULL,
	[NameEn] [nvarchar](200) NOT NULL,
	[NameAr] [nvarchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[CountryID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Contacts]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Contacts](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[Name] [nvarchar](150) NOT NULL,
	[Email] [nvarchar](100) NOT NULL,
	[PhoneNo] [nvarchar](20) NOT NULL,
	[Message] [nvarchar](500) NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Contacts] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ContactUs]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContactUs](
	[ContactUsID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Email] [nvarchar](200) NOT NULL,
	[Phone] [numeric](20, 0) NULL,
	[Message] [nvarchar](500) NULL,
PRIMARY KEY CLUSTERED 
(
	[ContactUsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Countries]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Countries](
	[CountryID] [int] NOT NULL,
	[NameEn] [nvarchar](200) NOT NULL,
	[NameAr] [nvarchar](200) NOT NULL,
	[NameTr] [nvarchar](200) NULL,
	[FlagUrl] [nvarchar](200) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Countries] PRIMARY KEY CLUSTERED 
(
	[CountryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Currencies]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Currencies](
	[CurrencyID] [int] IDENTITY(1,1) NOT NULL,
	[CurrencyCode] [nvarchar](5) NOT NULL,
	[NameEn] [nvarchar](20) NOT NULL,
	[NameAr] [nvarchar](20) NOT NULL,
	[NameTr] [nvarchar](20) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Currencies] PRIMARY KEY CLUSTERED 
(
	[CurrencyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeviceRegistrations]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceRegistrations](
	[DeviceRegistrationID] [int] IDENTITY(1,1) NOT NULL,
	[Token] [nvarchar](500) NULL,
	[UserID] [int] NOT NULL,
	[DeviceTypeID] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
 CONSTRAINT [PK_DeviceRegistrations] PRIMARY KEY CLUSTERED 
(
	[DeviceRegistrationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DeviceTypes]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DeviceTypes](
	[DeviceID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](20) NOT NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_DeviceTypes] PRIMARY KEY CLUSTERED 
(
	[DeviceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[DynamicSetupScreens]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DynamicSetupScreens](
	[DynamicSetupScreenID] [int] IDENTITY(1,1) NOT NULL,
	[ModuleName] [nvarchar](150) NULL,
	[ScreenName] [nvarchar](150) NULL,
	[DS_TableName] [nvarchar](50) NOT NULL,
	[DS_Title] [nvarchar](250) NOT NULL,
	[DS_AllowAddEdit] [bit] NULL,
	[DS_AllowPreview] [bit] NULL,
	[DS_AllowSearchFilter] [bit] NULL,
	[DS_AllowListingGrid] [bit] NULL,
	[DS_GridColumns] [nvarchar](1024) NULL,
	[DS_AllowDelete] [bit] NULL,
	[DS_AllowEdit] [bit] NULL,
	[DS_AllowApprovals] [bit] NULL,
	[DS_ExcludeAddEditColumns] [nvarchar](1024) NULL,
	[DS_ExcludeSearchColumns] [nvarchar](1024) NULL,
	[DS_ShowAddNewButton] [nchar](10) NULL,
	[DS_GridTitle] [nvarchar](100) NULL,
	[DS_OrderBy] [nvarchar](100) NULL,
	[DS_DoNotRenderJavaScript] [bit] NULL,
	[DS_ExtenderName] [nvarchar](250) NULL,
	[DS_DontLoadRecursiveData] [bit] NULL,
	[DS_AllowImport] [bit] NULL,
	[DS_ParentColumnNameForRecursiveGrid] [nvarchar](500) NULL,
	[DS_RecordsPerPage] [int] NULL,
	[DS_ImportURL] [nvarchar](500) NULL,
	[DS_ManualCrud] [bit] NULL,
	[DS_Filters] [nvarchar](1024) NULL,
	[DS_DisableSorting] [bit] NULL,
	[DS_ShowHistory] [bit] NULL,
	[DS_IsMenuNavigation] [bit] NULL,
	[DS_TableConfigs] [nvarchar](max) NULL,
	[DS_CustomJavaScript] [nvarchar](max) NULL,
	[DS_Condition] [nvarchar](1024) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[DS_CustomQuery] [nvarchar](max) NULL,
 CONSTRAINT [PK_DynamicScreens] PRIMARY KEY CLUSTERED 
(
	[DynamicSetupScreenID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Entities]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Entities](
	[EntityID] [int] IDENTITY(1,1) NOT NULL,
	[EntityName] [varchar](64) NOT NULL,
	[DataVersion] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[LinkUrl] [nvarchar](250) NULL,
 CONSTRAINT [PK4] PRIMARY KEY CLUSTERED 
(
	[EntityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[EntityDetails]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EntityDetails](
	[EntityDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[EntityID] [int] NOT NULL,
	[ColumnName] [nvarchar](256) NOT NULL,
	[DisplayNameEn] [nvarchar](256) NOT NULL,
	[DisplayNameAr] [nvarchar](256) NULL,
	[DbTypeID] [smallint] NOT NULL,
	[IsRequired] [bit] NOT NULL,
	[IsGroup] [bit] NULL,
	[ParentSubGroupID] [int] NULL,
	[ParentEntityDetailsID] [int] NULL,
	[IsForeignkey] [bit] NOT NULL,
	[RefrencedTableName] [varchar](256) NULL,
	[EnableAutoComplate] [bit] NOT NULL,
	[AutoCompleteSourceQuery] [nvarchar](max) NULL,
	[IsDigit] [bit] NULL,
	[ValidationExpression] [nvarchar](256) NULL,
	[AddEditVisible] [bit] NOT NULL,
	[GridVisible] [bit] NOT NULL,
	[SearchFilterVisible] [bit] NOT NULL,
	[MaxLength] [smallint] NOT NULL,
	[IsAutoID] [bit] NOT NULL,
	[IsPrimaryKey] [bit] NOT NULL,
	[DisplaySeqNo] [int] NULL,
	[IsFileUpload] [bit] NULL,
	[AllowedFiles] [nvarchar](256) NULL,
	[ShowGroupTitle] [bit] NOT NULL,
	[PlaceHolderText] [nvarchar](200) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_EntityDetails] PRIMARY KEY CLUSTERED 
(
	[EntityDetailsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Languages]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Languages](
	[LanguageID] [int] IDENTITY(1,1) NOT NULL,
	[NameAr] [nvarchar](500) NOT NULL,
	[NameEn] [nvarchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[MenuNavigations]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MenuNavigations](
	[MenuNavigationID] [int] IDENTITY(1,1) NOT NULL,
	[MenuNavigationName] [nvarchar](150) NOT NULL,
	[ParentMenuNavigationID] [int] NULL,
	[DisplaySeqNo] [int] NULL,
	[LinkUrl] [nvarchar](250) NULL,
	[IconClass] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[EntityID] [int] NULL,
 CONSTRAINT [PK_Menus] PRIMARY KEY CLUSTERED 
(
	[MenuNavigationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[OrderDetailID] [int] IDENTITY(1,1) NOT NULL,
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[Price] [decimal](10, 2) NOT NULL,
	[CurrencyID] [int] NOT NULL,
	[VendorID] [int] NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[OrderDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[OrderDate] [datetime] NOT NULL,
	[StatusID] [nvarchar](50) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlantGuide]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlantGuide](
	[PlantGuideID] [int] IDENTITY(1,1) NOT NULL,
	[PlantGuideName] [nvarchar](50) NOT NULL,
	[PlantGuideDetails] [nvarchar](800) NOT NULL,
	[PlantGuideImageUrl] [nvarchar](500) NOT NULL,
	[IsActive] [bit] NULL,
	[IsDeleted] [bit] NOT NULL,
 CONSTRAINT [PK_PlantGuide] PRIMARY KEY CLUSTERED 
(
	[PlantGuideID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductCategories]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductCategories](
	[ProductCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NULL,
	[CategoryID] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ProductImages]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductImages](
	[ProductImageID] [int] IDENTITY(1,1) NOT NULL,
	[ImageUrl] [nvarchar](500) NOT NULL,
	[ProductID] [int] NULL,
	[IsDefault] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[WebImage] [varchar](600) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductImageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Products]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Products](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[NameAr] [nvarchar](500) NOT NULL,
	[NameEn] [nvarchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[DescriptionAr] [nvarchar](max) NOT NULL,
	[DescriptionEn] [nvarchar](max) NOT NULL,
	[Price] [decimal](10, 2) NULL,
	[Stock] [int] NOT NULL,
	[TotalQuantity] [int] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
	[OldPrice] [decimal](10, 2) NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ResourceLocalizations]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ResourceLocalizations](
	[ResourceKey] [nvarchar](200) NOT NULL,
	[ResourceValueAr] [nvarchar](max) NULL,
	[ResourceValueEn] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Resources]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Resources](
	[ResourceID] [int] IDENTITY(1,1) NOT NULL,
	[LanguageID] [int] NOT NULL,
	[ResourceKey] [nvarchar](150) NOT NULL,
	[ResourceValue] [nvarchar](2000) NOT NULL,
 CONSTRAINT [PK_Resources] PRIMARY KEY CLUSTERED 
(
	[ResourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rights]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rights](
	[RightID] [int] NOT NULL,
	[RightName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Rights] PRIMARY KEY CLUSTERED 
(
	[RightID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RoleRights]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RoleRights](
	[RoleRightID] [int] IDENTITY(1,1) NOT NULL,
	[RoleID] [int] NOT NULL,
	[RightID] [int] NOT NULL,
	[EntityID] [int] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_RoleRights] PRIMARY KEY CLUSTERED 
(
	[RoleRightID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[RoleID] [int] NOT NULL,
	[RoleName] [nvarchar](50) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[RoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Statuses]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Statuses](
	[StatusID] [int] NOT NULL,
	[NameEn] [nvarchar](50) NOT NULL,
	[NameAr] [nvarchar](50) NULL,
	[IsActive] [bit] NOT NULL,
 CONSTRAINT [PK_Statuses] PRIMARY KEY CLUSTERED 
(
	[StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[UserRoles]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserRoles](
	[UserRoleID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[RoleID] [int] NOT NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
 CONSTRAINT [PK_UserRoles] PRIMARY KEY CLUSTERED 
(
	[UserRoleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[FullName] [nvarchar](200) NOT NULL,
	[EmailAddress] [nvarchar](200) NOT NULL,
	[Password] [nvarchar](200) NOT NULL,
	[PhoneNo] [nvarchar](30) NOT NULL,
	[CountryID] [int] NULL,
	[CityID] [int] NULL,
	[ProfileUrl] [nvarchar](500) NULL,
	[VerificationCode] [nvarchar](100) NULL,
	[IsVerified] [bit] NOT NULL,
	[StatusID] [int] NOT NULL,
	[IsTermOfUseAccepted] [bit] NULL,
	[IsPrivacyPolicyAccepted] [bit] NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[BillingAddress] [nvarchar](500) NULL,
	[ShippingAddress] [nvarchar](500) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VariantCategories]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VariantCategories](
	[VariantCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[CategoryID] [int] NOT NULL,
	[VariantID] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[VariantCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Variants]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Variants](
	[VariantID] [int] IDENTITY(1,1) NOT NULL,
	[NameAr] [nvarchar](500) NOT NULL,
	[NameEn] [nvarchar](500) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[VariantID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Vendors]    Script Date: 17/06/2022 7:03:53 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Vendors](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](200) NOT NULL,
	[Contact] [numeric](18, 0) NOT NULL,
	[Email] [nvarchar](200) NOT NULL,
	[City] [nvarchar](200) NULL,
	[Area] [nvarchar](300) NOT NULL,
	[Street] [nvarchar](300) NOT NULL,
	[HouseNo] [nvarchar](300) NOT NULL,
	[Notes] [nvarchar](max) NULL,
	[CityID] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[APIConfigurations] ON 

INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (4, N'All Resources', N'get-allresources', N'GET', NULL, N'/get-allresources', N';EXEC GetResources @LanguageID', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (5, N'Forgot Password', N'forgot-password', N'POST', NULL, N'/forgot-password', N'
Select CAST(ISNULL((
SELECT * FROM Users WHERE EmailAddress = @EmailAddress
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER), ''[]'') AS NVARCHAR(MAX)) AS Data', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (6, N'Register User', N'register-user', N'POST', NULL, N'/register-user', N'
INSERT INTO Users ([FullName], [EmailAddress], [Password], [PhoneNo], [CountryID], [CityID], [ProfileUrl], [VerificationCode], [IsVerified], [StatusID],[IsTermOfUseAccepted], [IsPrivacyPolicyAccepted], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [BillingAddress], [ShippingAddress]) 
SELECT * FROM OPENJSON(@JSON) WITH (FullName nvarchar(200),  EmailAddress nvarchar(200),  [Password] nvarchar(200),  PhoneNo nvarchar(30),  CountryID int,  CityID int,  ProfileUrl nvarchar(500),  VerificationCode nvarchar(100),  IsVerified bit,  StatusID int,  IsTermOfUseAccepted bit,  IsPrivacyPolicyAccepted bit,  CreatedOn datetime,  CreatedBy int, ModifiedOn datetime, ModifiedBy int, BillingAddress nvarchar(500), ShippingAddress nvarchar(500)); 

Select CAST((Select Top 1 [UserID], [FullName], [EmailAddress], [Password], [PhoneNo], [CountryID], [CityID], [ProfileUrl], [VerificationCode], [IsVerified], [StatusID],[IsTermOfUseAccepted], [IsPrivacyPolicyAccepted], Convert(varchar, [CreatedOn], 101) CreatedOn, [CreatedBy], Convert(varchar, [ModifiedOn], 101) ModifiedOn, [ModifiedBy], [BillingAddress], [ShippingAddress]
From Users Order By 1 Desc FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS NVARCHAR(MAX)) Data
', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (7, N'Login', N'login', N'POST', NULL, N'/login', N'

Select 
CAST(
	ISNULL(
		(Select TOP 1
			UserID, 
			FullName,
			EmailAddress,
			PhoneNo,
			CountryID,
			CityID,
			ISNULL(ProfileUrl, '''') ProfileUrl,
			IsVerified,
			IsTermOfUseAccepted,
			IsPrivacyPolicyAccepted,
			CONVERT(varchar, CreatedOn, 101) CreatedOn,
			CONVERT(varchar, ModifiedOn, 101) ModifiedOn,
			BillingAddress, ShippingAddress
		From Users
		Where StatusID = 1 AND EmailAddress = @Email AND [Password] = @Password
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER), 
	''[]'') AS NVARCHAR(MAX)) AS Data', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (8, N'Cities', N'cities', N'POST', NULL, N'/cities', N'
Select 
	(CASE WHEN @LanguageID = 1 THEN NameAr ELSE NameEn END) CityName,
	CityID
From Cities
Where CountryID = @CountryID AND IsActive = 1
FOR JSON PATH', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (9, N'My Orders', N'my-orders', N'POST', NULL, N'/my-orders', N'Select 
	ISNULL(
		CAST(
		(
			select O.OrderID, O.OrderDate, O.StatusID, Od.Price AS Total from Orders O inner join OrderDetails OD 
on O.OrderID = OD.OrderID where UserID = @UserID 
			For Json Path)
		AS NVARCHAR(MAX)
	), ''[]'') AS Data', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (10, N'Categories', N'categories', N'POST', NULL, N'/categories', N'
Select 
	ISNULL(
		CAST(
		(
			Select 
				ISNULL((CASE WHEN @LanguageID = 1 THEN C.NameAr ELSE C.NameEn END), '''') CategoryName, ISNULL(C.ImageUrl, '''') ImageUrl,
				Count(PC.ProductID) AS TOTALPRODUCT
				From Categories C Inner join ProductCategories PC On C.CategoryID = PC.CategoryID 
				Group by C.NameAr, C.NameEn, C.ImageUrl Order by TOTALPRODUCT ASC
			For Json Path)
		AS NVARCHAR(MAX)
	), ''[]'') AS Data
', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (11, N'Products', N'products', N'POST', NULL, N'/products', N'Select 
	ISNULL(
		CAST(
		(
			Select 
				ISNULL((CASE WHEN @LanguageID = 1 THEN P.NameAr ELSE P.NameEn END), '''') ProductName, ISNULL([PI].ImageUrl, '''') ImageUrl,
				P.Price 
				From Products P 
				Inner Join ProductImages [PI] on P.ProductID = [PI].ProductID 
				inner join ProductCategories PC on PC.ProductID = P.ProductID
				where PC.CategoryID = @CategoryID
			For Json Path)
		AS NVARCHAR(MAX)
	), ''[]'') AS Data', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (12, N'Plant Detail', N'plant-detail', N'POST', NULL, N'/plant-detail', N'Select 
	ISNULL(
		CAST(
		(
			Select P.Price,
				ISNULL((CASE WHEN @LanguageID = 1 THEN P.NameAr ELSE P.NameEn END), '''') ProductName, 
				ISNULL([PI].ImageUrl, '''') ImageUrl,
				ISNULL((CASE WHEN @LanguageID = 1 THEN P.DescriptionAr ELSE P.DescriptionEn END), '''') ProductDesc 
				From Products P Inner Join ProductImages [PI] on P.ProductID = [PI].ProductID where P.ProductID = @ProductID
			For Json Path)
		AS NVARCHAR(MAX)
	), ''[]'') AS Data', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (13, N'SearchByType', N'searchby-type', N'POST', NULL, N'/searchby-type', N'Select 
	ISNULL(
		CAST(
		(
			Select 
				ISNULL((CASE WHEN @LanguageID = 1 THEN P.NameAr ELSE P.NameEn END), '''') ProductName, ISNULL([PI].ImageUrl, '''') ImageUrl,
				P.Price 
				From Products P 
				Inner Join ProductImages [PI] on P.ProductID = [PI].ProductID 
				inner join ProductCategories PC on PC.ProductID = P.ProductID
				where PC.CategoryID = @CategoryID
			For Json Path)
		AS NVARCHAR(MAX)
	), ''[]'') AS Data
', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (14, N'Home', N'home', N'POST', NULL, N'/home', N'Select ISNULL(CAST((
	Select
	--Last month me bestselling is month ka plant of the month
		Plantofthemonth = 
		ISNULL(CAST((
				Select Top 1
					(CASE WHEN @LanguageID = 1 THEN P.NameAr ELSE P.NameEn END) ProductName, [PI].ImageUrl, P.Price
					 From ORders O 
					 inner join OrderDetails OD on O.OrderID = OD.OrderID 
					 inner join Products P on OD.ProductID = P.ProductID 
					 inner join ProductImages [PI] on P.ProductID = [PI].ProductID 
					 where Month(O.Orderdate) = Month(Current_Timestamp)-1  Group by P.ProductID, P.NameAr,P.NameEn,P.Price,[PI].ImageUrl Order by Sum(OD.Quantity) DESC
					 For Json Path) AS NVARCHAR(MAX) 
		), ''[]''),
		TopCategory = 
		ISNULL(CAST((
				Select Top 1 
					(CASE WHEN @LanguageID = 1 THEN C.NameAr ELSE C.NameEn END) CategoryName, ISNULL(C.ImageUrl, '''') ImageUrl, 
					 Count(PC.ProductID) AS TOTALPRODUCT
					 From Orders O inner join OrderDetails OD on O.OrderID = OD.OrderID 
					 inner join ProductCategories PC on OD.ProductID = PC.ProductID 
					 inner join Categories C on PC.CategoryID = C.CategoryID
					 where Month(O.Orderdate) = Month(Current_Timestamp)-1  Group by C.NameAr,C.NameEn,C.ImageUrl Order by Sum(OD.Quantity) DESC
					 For Json Path) AS NVARCHAR(MAX) 
		), ''[]''),
		BestSeller = 
		ISNULL(CAST((
				Select Top 4
					(CASE WHEN @LanguageID = 1 THEN P.NameAr ELSE P.NameEn END) ProductName, [PI].ImageUrl, P.Price
					 From ORders O 
					 inner join OrderDetails OD on O.OrderID = OD.OrderID 
					 inner join Products P on OD.ProductID = P.ProductID 
					 inner join ProductImages [PI] on P.ProductID = [PI].ProductID 
					 where Month(O.Orderdate) = Month(Current_Timestamp)-1  Group by P.ProductID, P.NameAr,P.NameEn,P.Price,[PI].ImageUrl Order by Sum(OD.Quantity) DESC
					For Json Path) AS NVARCHAR(MAX) 
		), ''[]'')
	For Json Path, Without_Array_Wrapper
) AS NVARCHAR(MAX)), ''[]'') Data', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[APIConfigurations] ([ID], [Title], [UrlName], [MethodType], [Description], [URL], [SqlQuery], [DefaultParams], [IsActive], [UrlParams], [DataParams], [SuccessResponse], [ErrorResponse], [SampleCall], [Notes], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [IsCacheAllowed]) VALUES (15, N'My Address', N'my-address', N'POST', NULL, N'/my-address', N'Select ISNULL(CAST((
	Select
	--Last month me bestselling is month ka plant of the month
		BillingAddress = 
		ISNULL(CAST((
				Select
					FullName, ISNULL(BillingAddress, '''')BillingAddress
					From Users where UserID = @USerID
					For Json Path) AS NVARCHAR(MAX) 
		), ''[]''),
		ShippingAddress = 
		ISNULL(CAST((
				Select
					FullName, ISNULL(ShippingAddress, '''') ShippingAddress
					From Users where UserID = @USerID
					For Json Path) AS NVARCHAR(MAX) 
		), ''[]'')
	For Json Path, Without_Array_Wrapper
) AS NVARCHAR(MAX)), ''[]'') Data', NULL, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[APIConfigurations] OFF
GO
SET IDENTITY_INSERT [dbo].[AppConfigs] ON 

INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (1, N'PrivacyPolicyEn', N'<!DOCTYPE html>
<html>
<head>
  <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
</head>
<body>
    <p style=''font-family: "Montserrat";font-size: medium;padding: 10px;text-align: justify;''> This Policy is a legally binding agreement between you (“you” or “user”) and us. By visiting, accessing or using the Website or App, or providing information to us in any other format, you agree to and accept the terms of this Privacy Policy, as amended from time to time, and you consent to the collection and use of information in the manner set out in this Policy. We encourage you to review this Policy carefully and to periodically refer to it so that you understand it and its subsequent changes if any. If you do not agree to the terms of this privacy policy, please stop using the service immediately and where relevant uninstall. The definitions in the terms and conditions apply to this privacy policy unless stated otherwise. In addition to this policy, please review our terms and conditions and cookie policy which are incorporated herein by reference, together with such other policies of which you may be notified of by us from time to time. </p>
</body>
</html>', NULL, NULL, NULL, NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (2, N'PrivacyPolicyAr', N'<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
   <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
</head>
<body>
    <p style=''font-family: "Montserrat";font-size: medium;padding: 10px;text-align: justify;''> هذه السياسة هي اتفاقية ملزمة قانونًا بينك ("أنت" أو "المستخدم") وبيننا. من خلال زيارة الموقع أو التطبيق أو الوصول إليهما أو استخدامه ، أو تقديم المعلومات إلينا بأي تنسيق آخر ، فإنك توافق على شروط سياسة الخصوصية هذه وتقبلها ، بصيغتها المعدلة من وقت لآخر ، وتوافق على جمع المعلومات واستخدامها بالطريقة المنصوص عليها في هذه السياسة. نحن نشجعك على مراجعة هذه السياسة بعناية والرجوع إليها بشكل دوري حتى تفهمها والتغييرات اللاحقة لها إن وجدت. إذا كنت لا توافق على شروط سياسة الخصوصية هذه ، فيرجى التوقف عن استخدام الخدمة فورًا وعند الاقتضاء إلغاء التثبيت. تنطبق التعريفات الواردة في الشروط والأحكام على سياسة الخصوصية هذه ما لم ينص على خلاف ذلك. بالإضافة إلى هذه السياسة ، يرجى مراجعة الشروط والأحكام وسياسة ملفات تعريف الارتباط الخاصة بنا التي تم تضمينها هنا بالإشارة ، إلى جانب هذه السياسات الأخرى التي قد يتم إبلاغك بها من قبلنا من وقت لآخر-</p>
</body>
</html>', NULL, NULL, NULL, NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (3, N'TermsOfUseEn', N'<!DOCTYPE html>
<html>
<head>
  <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
</head>
<body>
    <p style=''font-family: "Montserrat";font-size: medium;padding: 10px;text-align: justify;''>  1.1 Access to the Mobile Application and use of the Services offered on the Mobile Application by Singapore Post Limited and/or its group of companies is subject to this Privacy Policy. By accessing the Mobile Application and by continuing to use the Services offered, you are deemed to have accepted this Privacy Policy, and in particular, you are deemed to have consented to our use and disclosure of your personal information in the manner prescribed in this Privacy Policy and for the purposes set out in Clauses 3.7 and/or 4.1. We reserve the right to amend this Privacy Policy from time to time. If you disagree with any part of this Privacy Policy, you must immediately discontinue your access to the Mobile Application and your use of the Services.    1.2 As part of the normal operation of our Services, we collect, use and, in some cases, disclose information about you to third parties. Accordingly, we have developed this Privacy Policy in order for you to understand how we collect, use, communicate and disclose and make use of your personal information when you use the Services on the Mobile Application:-  (a) Before or at the time of collecting personal information, we will identify the purposes for which information is being collected.  (b) We will collect and use of personal information solely with the objective of fulfilling those purposes specified by us and for other compatible purposes, unless we obtain the consent of the individual concerned or as required by law.  (c) We will only retain personal information as long as necessary for the fulfillment of those purposes.  (d) We will collect personal information by lawful and fair means and, where appropriate, with the knowledge or consent of the individual concerned.  (e) Personal information should be relevant to the purposes for which it is to be used, and, to the extent necessary for those purposes, should be accurate, complete, and up-to-date.  (f) We will protect personal information by reasonable security safeguards against loss or theft, as well as unauthorized access, disclosure, copying, use or modification. We are committed to conducting our business in accordance with these principles in order to ensure that the confidentiality of personal information is protected and maintained.  </p>
</body>
</html>', NULL, NULL, NULL, NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (4, N'TermsOfUseAr', N'<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
  <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
</head>
<body>
    <p style=''font-family: "Montserrat";font-size: medium;padding: 10px;text-align: right;''> 1.1 يخضع الوصول إلى تطبيق الهاتف المحمول واستخدام الخدمات المقدمة على تطبيق الهاتف المحمول من قبل شركة سنغافورة بوست المحدودة و / أو مجموعة شركاتها لسياسة الخصوصية هذه. من خلال الوصول إلى تطبيق الهاتف المحمول والاستمرار في استخدام الخدمات المقدمة ، يُعتبر أنك قد قبلت سياسة الخصوصية هذه ، وعلى وجه الخصوص ، يُعتبر أنك قد وافقت على استخدامنا لمعلوماتك الشخصية والكشف عنها بالطريقة المنصوص عليها في هذه الخصوصية. السياسة وللأغراض المنصوص عليها في البنود 3.7 و / أو 4.1. نحتفظ بالحق في تعديل سياسة الخصوصية هذه من وقت لآخر. إذا كنت لا توافق على أي جزء من سياسة الخصوصية هذه ، فيجب عليك التوقف فورًا عن وصولك إلى تطبيق الهاتف المحمول واستخدامك للخدمات. 1.2 كجزء من التشغيل العادي لخدماتنا ، نجمع معلومات عنك ونستخدمها ، وفي بعض الحالات ، نكشف عنها لأطراف ثالثة. وفقًا لذلك ، قمنا بتطوير سياسة الخصوصية هذه حتى تتمكن من فهم كيفية جمع معلوماتك الشخصية واستخدامها والتواصل والكشف عنها والاستفادة منها عند استخدام الخدمات على تطبيق الهاتف المحمول: - (أ) قبل أو في وقت بجمع المعلومات الشخصية ، سنحدد الأغراض التي يتم جمع المعلومات من أجلها. (ب) سنقوم بجمع واستخدام المعلومات الشخصية فقط بهدف تحقيق تلك الأغراض المحددة من قبلنا ولأغراض أخرى متوافقة ، ما لم نحصل على موافقة الفرد المعني أو وفقًا لما يقتضيه القانون. (ج) سنحتفظ بالمعلومات الشخصية فقط طالما كان ذلك ضروريًا لتحقيق تلك الأغراض. (د) سنقوم بجمع المعلومات الشخصية بوسائل قانونية وعادلة ، وعند الاقتضاء ، بمعرفة أو موافقة الفرد المعني. (هـ) يجب أن تكون المعلومات الشخصية ذات صلة بالأغراض التي سيتم استخدامها من أجلها ، ويجب أن تكون دقيقة وكاملة وحديثة بالقدر اللازم لتلك الأغراض. (و) سنحمي المعلومات الشخصية من خلال ضمانات أمنية معقولة ضد الفقد أو السرقة ، بالإضافة إلى الوصول غير المصرح به أو الكشف أو النسخ أو الاستخدام أو التعديل. نحن ملتزمون بإجراء أعمالنا وفقًا لهذه المبادئ من أجل ضمان حماية سرية المعلومات الشخصية والحفاظ عليها. </p>
</body>
</html>', NULL, NULL, NULL, NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (5, N'AboutAppEn', N'<!DOCTYPE html>
<html>
<head>
   <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
</head>
<body>
    <p style=''font-family: "Montserrat";font-size: medium;padding: 10px;text-align: justify;''> Basketo is a discount app with a new idea to help clients getting discounts on every purchase they make from specific merchants. The app has an add-value for both sides, the customer & the merchant. As for the merchant, the business will be getting more traffic. And as for the customer, he/she will be paying less.</p>
</body>
</html>', NULL, NULL, NULL, NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (7, N'AboutAppAr', N'<!DOCTYPE html>
<html>
<head>
    <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
</head>
<body>
    <p style=''font-family: "Montserrat";font-size: medium;padding: 10px;text-align: right;''>
        باسكتو
        هو تطبيق خصم بفكرة جديدة لمساعدة العملاء على الحصول على خصومات على كل عملية شراء يقومون بها من تجار معينين. التطبيق له قيمة مضافة لكلا الجانبين ، العميل والتاجر. أما بالنسبة إلى التاجر ، فسيكتسب النشاط التجاري حركة مرور أكثر. أما بالنسبة للعميل ، فسوف يدفع أقل.
    </p>
</body>
</html>', NULL, NULL, NULL, NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (8, N'EnableRoleRights', N'true', 1, NULL, CAST(N'2020-12-08T19:57:34.970' AS DateTime), NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (9, N'PrivacyPolicyTr', N'<!DOCTYPE html>
<html>
<head>
 <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
</head>
<body>
    <p style=''font-family: "Montserrat";font-size: medium;padding: 10px;text-align: justify;''>Bu Politika, siz ("siz" veya "kullanıcı") ve bizim aramızda yasal olarak bağlayıcı bir sözleşmedir. Web Sitesini veya Uygulamayı ziyaret ederek, bunlara erişerek veya kullanarak veya bize başka herhangi bir biçimde bilgi sağlayarak, zaman zaman değiştirilen bu Gizlilik Politikasının şartlarını kabul edersiniz ve bilgilerin toplanmasına ve kullanılmasına izin verirsiniz. bu Politikada belirtilen şekilde. Bu Politikayı dikkatlice incelemenizi ve varsa onu ve varsa sonraki değişikliklerini anlamanız için periyodik olarak başvurmanızı öneririz. Bu gizlilik politikasının şartlarını kabul etmiyorsanız, lütfen hizmeti hemen kullanmayı bırakın ve gerektiğinde kaldırın. Hüküm ve koşullardaki tanımlar, aksi belirtilmedikçe bu gizlilik politikası için geçerlidir. Bu politikaya ek olarak, lütfen burada referans olarak dahil edilen hüküm ve koşullarımızı ve çerez politikamızı, zaman zaman tarafımızdan bildirilebilecek diğer politikalarla birlikte inceleyin.</p>
</body>
</html>', NULL, NULL, NULL, NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (10, N'AboutAppTr', N'<!DOCTYPE html>
<html>
<head>
     <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@600;700&display=swap" rel="stylesheet">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
</head>
<body>
    <p style=''font-family: "Montserrat, sans-serif";font-size: medium;padding: 10px;text-align: justify;''> Basketo, müşterilerin belirli satıcılardan yaptıkları her alışverişte indirim almalarına yardımcı olacak yeni bir fikir içeren bir indirim uygulamasıdır. Uygulamanın her iki taraf, müşteri ve satıcı için bir katma değeri vardır. Satıcıya gelince, işletme daha fazla trafik alacak. Müşteri ise daha az ödeyecek.</p>
</body>
</html>', NULL, NULL, NULL, NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (11, N'TermsOfUseTr', N'<!DOCTYPE html>
<html>
<head>
   <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
</head>
<body>
    <p style=''font-family: "Montserrat";font-size: medium;padding: 10px;text-align: justify;''>
        1.1 Singapore Post Limited ve / veya şirketler grubu tarafından Mobil Uygulamaya erişim ve Mobil Uygulama üzerinde sunulan Hizmetlerin kullanımı bu Gizlilik Politikasına tabidir. Mobil Uygulamaya erişerek ve sunulan Hizmetleri kullanmaya devam ederek, bu Gizlilik Politikasını kabul etmiş sayılırsınız ve özellikle kişisel bilgilerinizi bu Gizlilik''te belirtilen şekilde kullanmamıza ve ifşa etmemize izin vermiş olursunuz. Politika ve Madde 3.7 ve / veya 4.1''de belirtilen amaçlar için. Bu Gizlilik Politikasını zaman zaman değiştirme hakkımız saklıdır. Bu Gizlilik Politikasının herhangi bir kısmına katılmıyorsanız, Mobil Uygulamaya erişiminizi ve Hizmetleri kullanımınızı derhal durdurmalısınız. 1.2 Hizmetlerimizin normal işleyişinin bir parçası olarak sizinle ilgili bilgileri topluyor, kullanıyor ve bazı durumlarda üçüncü şahıslara ifşa ediyoruz. Buna göre, Mobil Uygulamada Hizmetleri kullandığınızda kişisel bilgilerinizi nasıl topladığımızı, kullandığımızı, ilettiğimizi ve ifşa ettiğimizi anlamanız ve bunları nasıl kullandığımızı anlamanız için bu Gizlilik Politikasını geliştirdik: - (a) Öncesinde veya zamanında kişisel bilgileri toplayarak, bilgilerin hangi amaçla toplandığını belirleyeceğiz. (b) Kişisel bilgileri, yalnızca tarafımızca belirtilen amaçları yerine getirmek amacıyla ve ilgili kişinin rızasını almadığımız sürece veya yasaların gerektirdiği şekilde diğer uygun amaçlarla toplayıp kullanacağız. (c) Kişisel bilgileri yalnızca bu amaçların yerine getirilmesi için gerekli olduğu sürece saklayacağız. (d) Kişisel bilgileri yasal ve adil yollarla ve uygun olduğunda ilgili kişinin bilgisi veya rızasıyla toplayacağız. (e) Kişisel bilgiler, kullanılacağı amaçlarla ilgili olmalı ve bu amaçlar için gerekli olduğu ölçüde, doğru, eksiksiz ve güncel olmalıdır. (f) Kişisel bilgileri, kayıp veya hırsızlığın yanı sıra yetkisiz erişim, ifşa, kopyalama, kullanım veya değiştirmeye karşı makul güvenlik önlemleri ile koruyacağız. Kişisel bilgilerin gizliliğinin korunmasını ve korunmasını sağlamak için işimizi bu ilkelere uygun olarak yürütmeyi taahhüt ediyoruz.
    </p>
</body>
</html>', NULL, NULL, NULL, NULL)
INSERT [dbo].[AppConfigs] ([AppConfigID], [AppConfigKey], [AppConfigValue], [CreatedBy], [ModifiedBy], [CreatedOn], [ModifiedOn]) VALUES (12, N'PrivacyPolicyTr', N'<!DOCTYPE html>
<html>
<head>
   <link rel="preconnect" href="https://fonts.gstatic.com">
<link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@700&display=swap" rel="stylesheet">
    <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
</head>
<body>
    <p style=''font-family: "Montserrat";font-size: medium;padding: 10px;text-align: justify;''> Bu Politika, siz ("siz" veya "kullanıcı") ve bizim aramızda yasal olarak bağlayıcı bir sözleşmedir. Web Sitesini veya Uygulamayı ziyaret ederek, bunlara erişerek veya kullanarak veya bize başka herhangi bir biçimde bilgi sağlayarak, zaman zaman değiştirilen bu Gizlilik Politikasının şartlarını kabul edersiniz ve bilgilerin toplanmasına ve kullanılmasına izin verirsiniz. bu Politikada belirtilen şekilde. Bu Politikayı dikkatlice incelemenizi ve varsa onu ve varsa sonraki değişikliklerini anlamanız için periyodik olarak başvurmanızı öneririz. Bu gizlilik politikasının şartlarını kabul etmiyorsanız, lütfen hizmeti hemen kullanmayı bırakın ve gerektiğinde kaldırın. Hüküm ve koşullardaki tanımlar, aksi belirtilmedikçe bu gizlilik politikası için geçerlidir. Bu politikaya ek olarak, lütfen burada referans olarak dahil edilen hüküm ve koşullarımızı ve çerez politikamızı, zaman zaman tarafımızdan bildirilebilecek diğer politikalarla birlikte inceleyin.</p>
</body>
</html>', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[AppConfigs] OFF
GO
SET IDENTITY_INSERT [dbo].[AppMenus] ON 

INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (1, N'About App', N'حول التطبيق', N'Uygulama hakkında
', 0, N'AboutUs', N'http://110.93.230.117:19005/images/master/about.png', NULL, 13, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (2, N'How It Works!', N'كيف تعمل!', N'Nasıl çalışır!', 1, N'HowItWorks', N'http://110.93.230.117:19005/images/master/howitworks.png', NULL, 8, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (3, N'Language', N'لغة', N'Dil', 1, N'Language', N'http://110.93.230.117:19005/images/master/language.png', NULL, 2, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (4, N'Notifications', N'إشعارات', N'Bildirimler', 1, N'Notification', N'http://110.93.230.117:19005/images/master/notification.png', NULL, 5, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (5, N'Privacy Policy', N'سياسة خاصة', N'Gizlilik Politikası', 1, N'PrivacyPolicy', N'http://110.93.230.117:19005/images/master/privacy.png', NULL, 7, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (6, N'Terms of Use', N'تعليمات الاستخدام', N'Kullanım Şartları', 0, N'TermsOfUse', N'http://110.93.230.117:19005/images/master/privacy.png', NULL, 14, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (7, N'My Profile', N'ملفي', N'Benim profilim', 1, N'MyProfile', N'http://110.93.230.117:19005/images/master/profile.png', NULL, 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (8, N'Admin', N'مشرف', N'Yönetici', 1, N'Admin', N'http://110.93.230.117:19005/images/master/admin.png', NULL, 10, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (9, N'Calendar', N'التقويم', N'Takvim', 0, N'Calender', NULL, NULL, 15, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (10, N'Country', N'بلد', N'Ülke', 0, N'country', NULL, NULL, 12, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (11, N'Logout', N'تسجيل خروج', N'Çıkış Yap', 1, N'logout', N'http://110.93.230.117:19005/images/master/logout.png', NULL, 11, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (18, N'Change Password', N'غير كلمة السر
', N'Şifre değiştir', 1, N'ChangePassword', N'http://110.93.230.117:19005/images/master/password.png', NULL, 3, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (19, N'Location', N'موقعك', N'yer', 1, N'Location', N'http://110.93.230.117:19005/images/master/location.png', NULL, 4, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (20, N'About Basketo', N'حول باسكتو', N'Basketo hakkında', 1, N'AboutBasketo', N'http://110.93.230.117:19005/images/master/about.png', NULL, 6, NULL, NULL, NULL, NULL)
INSERT [dbo].[AppMenus] ([AppMenuID], [NameEn], [NameAr], [NameTr], [IsActive], [MenuUrl], [ActiveIconUrl], [InActiveIconUrl], [DisplaySeqNo], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (21, N'Contact Us', N'اتصل بنا', N'Bize Ulaşın', 1, N'ContactUs', N'http://110.93.230.117:19005/images/master/contact.png', NULL, 9, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[AppMenus] OFF
GO
SET IDENTITY_INSERT [dbo].[Blogs] ON 

INSERT [dbo].[Blogs] ([BlogID], [BlogName], [BlogDetails], [BlogImageUrl], [IsActive], [IsDeleted]) VALUES (1, N'Grass', N'Lorem ipsum dolor sit amet, consectetur adipiscing elit Suspendisse eu enim magna. Cras in semper lectus, a semper purus. Nulla pellentesque lectus porta purus iaculis pharetra. Nam ac elementum arcu. Nunc at nisl dictum, aliquet purus eget, pretium lectus.', N'http://www.nursery.com.pk/wp-content/uploads/2019/02/nursery-lemon-grass-plant47.jpg', 1, 0)
SET IDENTITY_INSERT [dbo].[Blogs] OFF
GO
SET IDENTITY_INSERT [dbo].[Categories] ON 

INSERT [dbo].[Categories] ([CategoryID], [NameAr], [NameEn], [ParentCategoryID], [DisplaySeqNo], [IsActive], [ImageUrl], [ImageUrl2], [IsDeleted], [WebImages]) VALUES (2, N'نباتات مزدهرة', N'Flowering Plants', NULL, 1, 1, NULL, NULL, 0, NULL)
INSERT [dbo].[Categories] ([CategoryID], [NameAr], [NameEn], [ParentCategoryID], [DisplaySeqNo], [IsActive], [ImageUrl], [ImageUrl2], [IsDeleted], [WebImages]) VALUES (3, N'زائدة', N'Trailing', NULL, 2, 1, NULL, NULL, 0, NULL)
INSERT [dbo].[Categories] ([CategoryID], [NameAr], [NameEn], [ParentCategoryID], [DisplaySeqNo], [IsActive], [ImageUrl], [ImageUrl2], [IsDeleted], [WebImages]) VALUES (4, N'نبات عصاري', N'Secculant Plant', NULL, 3, 1, NULL, NULL, 0, NULL)
INSERT [dbo].[Categories] ([CategoryID], [NameAr], [NameEn], [ParentCategoryID], [DisplaySeqNo], [IsActive], [ImageUrl], [ImageUrl2], [IsDeleted], [WebImages]) VALUES (5, N'النخيل الداخلي', N'Indoor Palm', NULL, 4, 1, NULL, NULL, 0, NULL)
SET IDENTITY_INSERT [dbo].[Categories] OFF
GO
SET IDENTITY_INSERT [dbo].[Cities] ON 

INSERT [dbo].[Cities] ([CityID], [NameEn], [NameAr], [IsActive], [IsDeleted], [CountryID]) VALUES (8, N'NewYork', N'نيويورك', 1, 0, 2)
SET IDENTITY_INSERT [dbo].[Cities] OFF
GO
SET IDENTITY_INSERT [dbo].[Contacts] ON 

INSERT [dbo].[Contacts] ([ContactID], [UserID], [Name], [Email], [PhoneNo], [Message], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (1, 17, N'Hamza', N'Hamza@gmail.com', N'03313304883', N'Yup', CAST(N'2020-12-25T04:17:30.000' AS DateTime), 1, NULL, NULL)
INSERT [dbo].[Contacts] ([ContactID], [UserID], [Name], [Email], [PhoneNo], [Message], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (2, 16, N'Sammy', N'sammy.saam10@gmail.com', N'7273373737', N'Susky app', CAST(N'2020-12-26T09:24:37.000' AS DateTime), 1, NULL, NULL)
INSERT [dbo].[Contacts] ([ContactID], [UserID], [Name], [Email], [PhoneNo], [Message], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (3, 28, N'Osama ishaq', N'osama.ishaq10@gmail.com', N'73737338337', N'Susky app', CAST(N'2020-12-28T07:11:32.000' AS DateTime), 1, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Contacts] OFF
GO
INSERT [dbo].[Countries] ([CountryID], [NameEn], [NameAr], [NameTr], [FlagUrl], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (1, N'Iraq', N'العراق', N'Irak', N'https://admin.basketo.io/images/master/iraq.png', 1, NULL, NULL, NULL, NULL)
INSERT [dbo].[Countries] ([CountryID], [NameEn], [NameAr], [NameTr], [FlagUrl], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (2, N'United States', N'الولايات المتحدة الأمريكية', N'Amerika Birleşik Devletleri', N'https://admin.basketo.io/images/master/usa.png', 0, CAST(N'2020-12-06T23:27:49.000' AS DateTime), 1, CAST(N'2020-12-06T23:27:49.000' AS DateTime), 1)
GO
SET IDENTITY_INSERT [dbo].[Currencies] ON 

INSERT [dbo].[Currencies] ([CurrencyID], [CurrencyCode], [NameEn], [NameAr], [NameTr], [IsActive]) VALUES (1, N'IQD', N'Iraqi Dinar', N'الدينار العراقي', N'Irak Dinarı', 1)
INSERT [dbo].[Currencies] ([CurrencyID], [CurrencyCode], [NameEn], [NameAr], [NameTr], [IsActive]) VALUES (2, N'USD', N'USD', N'دولار', N'Amerikan Doları
', 1)
INSERT [dbo].[Currencies] ([CurrencyID], [CurrencyCode], [NameEn], [NameAr], [NameTr], [IsActive]) VALUES (3, N'TRL', N'ليرا', N'ريال', N'LİRA', 1)
INSERT [dbo].[Currencies] ([CurrencyID], [CurrencyCode], [NameEn], [NameAr], [NameTr], [IsActive]) VALUES (4, N'SAR', N'Saudi Riyal', N'الريال السعودي', N'Suudi Riyali', 1)
SET IDENTITY_INSERT [dbo].[Currencies] OFF
GO
SET IDENTITY_INSERT [dbo].[DynamicSetupScreens] ON 

INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (1, N'configuration', N'setup-screen', N'DynamicSetupScreens', N'DynamicSetupScreens', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, N'DynamicSetupScreenExtender', 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-28T01:10:56.000' AS DateTime), 1, CAST(N'2020-11-28T01:10:56.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (5, N'configurations', N'languages', N'Languages', N'Manage Languages', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:10:01.000' AS DateTime), 1, CAST(N'2020-11-27T23:10:01.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (6, N'configurations', N'countries', N'Countries', N'Manage Countries', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-28T01:04:24.000' AS DateTime), 1, CAST(N'2020-11-28T01:04:24.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (7, N'configurations', N'cities', N'Cities', N'Manage Cities', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:11:20.000' AS DateTime), 1, CAST(N'2020-11-27T23:11:20.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (8, N'configurations', N'intro', N'Intros', N'Manage Intro', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:12:13.000' AS DateTime), 1, CAST(N'2020-11-27T23:12:13.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (9, N'configurations', N'resources', N'Resources', N'Manage Resources', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:13:35.000' AS DateTime), 1, CAST(N'2020-11-27T23:13:35.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (10, N'configurations', N'currencies', N'Currencies', N'Manage Currencies', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:14:04.000' AS DateTime), 1, CAST(N'2020-11-27T23:14:04.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (11, N'configurations', N'entities', N'Entities', N'Manage Entities', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, N'EntitiesExtender', 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-28T00:08:44.000' AS DateTime), 1, CAST(N'2020-11-28T00:08:44.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (12, N'configurations', N'entity-details', N'EntityDetails', N'Manage Entity Details', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:15:51.000' AS DateTime), 1, CAST(N'2020-11-27T23:15:51.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (13, N'user-management', N'roles', N'Roles', N'Manage Roles', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-28T01:07:44.000' AS DateTime), 1, CAST(N'2020-11-28T01:07:44.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (14, N'user-management', N'rights', N'Rights', N'Manage Rights', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:16:59.000' AS DateTime), 1, CAST(N'2020-11-27T23:16:59.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (15, N'user-management', N'user-roles', N'UserRoles', N'Manage User Roles', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:17:34.000' AS DateTime), 1, CAST(N'2020-11-27T23:17:34.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (16, N'user-management', N'users', N'Users', N'Manage Users', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, N'UserExtender', 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-12-12T01:52:37.000' AS DateTime), 1, CAST(N'2020-12-12T01:52:37.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (17, N'settings', N'app-menus', N'AppMenus', N'Manage App Menus', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:18:44.000' AS DateTime), 1, CAST(N'2020-11-27T23:18:44.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (18, N'settings', N'menus', N'MenuNavigations', N'Manage Menus', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-27T23:19:08.000' AS DateTime), 1, CAST(N'2022-04-10T10:51:08.000' AS DateTime), 5, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (26, N'configurations', N'api-configurations', N'APIConfigurations', N'Manage API Configurations', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-28T00:31:26.000' AS DateTime), 1, CAST(N'2020-11-28T00:31:26.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (27, N'configurations', N'app-configs', N'AppConfigs', N'Manage App Configurations', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2020-11-28T01:07:12.000' AS DateTime), 1, CAST(N'2020-11-28T01:07:12.000' AS DateTime), 1, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (38, N'Vendors', N'Vendors', N'Vendors', N'Manage Vendors', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2022-04-12T07:09:20.000' AS DateTime), 5, CAST(N'2022-04-19T07:33:35.000' AS DateTime), 3, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (40, N'Plant Categories', N'Categories', N'Categories', N'Manage Categories', 1, 0, 1, 1, N'CategoryID,NameEn,NameAr,ImageUrl,IsActive', 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2022-04-19T01:26:21.000' AS DateTime), 3, CAST(N'2022-04-19T13:40:13.000' AS DateTime), 3, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (51, N'Blogs Management', N'Blogs', N'Blogs', N'Manage Blogs', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2022-04-21T11:22:38.000' AS DateTime), 5, CAST(N'2022-04-21T23:23:07.000' AS DateTime), NULL, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (52, N'Plant Guide', N'PlantGuide', N'PlantGuide', N'Manage Plants Guide', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2022-04-21T11:31:56.000' AS DateTime), 5, CAST(N'2022-04-21T23:32:52.000' AS DateTime), NULL, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (54, N'Orders', N'Order-details', N'OrderDetails', N'Order Details', 0, 0, 1, 1, NULL, 0, 0, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2022-06-05T07:00:04.000' AS DateTime), 5, CAST(N'2022-06-05T19:00:32.000' AS DateTime), NULL, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (55, N'Orders', N'Orders', N'Orders', N'All Orders', 1, 0, 1, 1, NULL, 0, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2022-06-05T07:01:10.000' AS DateTime), 5, CAST(N'2022-06-05T19:01:58.000' AS DateTime), NULL, NULL)
INSERT [dbo].[DynamicSetupScreens] ([DynamicSetupScreenID], [ModuleName], [ScreenName], [DS_TableName], [DS_Title], [DS_AllowAddEdit], [DS_AllowPreview], [DS_AllowSearchFilter], [DS_AllowListingGrid], [DS_GridColumns], [DS_AllowDelete], [DS_AllowEdit], [DS_AllowApprovals], [DS_ExcludeAddEditColumns], [DS_ExcludeSearchColumns], [DS_ShowAddNewButton], [DS_GridTitle], [DS_OrderBy], [DS_DoNotRenderJavaScript], [DS_ExtenderName], [DS_DontLoadRecursiveData], [DS_AllowImport], [DS_ParentColumnNameForRecursiveGrid], [DS_RecordsPerPage], [DS_ImportURL], [DS_ManualCrud], [DS_Filters], [DS_DisableSorting], [DS_ShowHistory], [DS_IsMenuNavigation], [DS_TableConfigs], [DS_CustomJavaScript], [DS_Condition], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [DS_CustomQuery]) VALUES (56, N'Products', N'Products', N'Products', N'Manage Products', 1, 0, 1, 1, NULL, 1, 1, 0, NULL, NULL, NULL, NULL, NULL, 0, NULL, 0, 0, NULL, NULL, NULL, 0, NULL, 0, 0, 0, NULL, NULL, NULL, CAST(N'2022-06-12T11:49:01.000' AS DateTime), 5, CAST(N'2022-06-12T23:50:48.000' AS DateTime), 5, NULL)
SET IDENTITY_INSERT [dbo].[DynamicSetupScreens] OFF
GO
SET IDENTITY_INSERT [dbo].[Entities] ON 

INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (1, N'Languages', 0, 1, CAST(N'2021-03-02T17:09:23.000' AS DateTime), 1, CAST(N'2021-03-02T17:09:23.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (2, N'Countries', 0, 1, CAST(N'2021-03-02T17:13:25.000' AS DateTime), 1, CAST(N'2021-03-02T17:13:25.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (3, N'Cities', 0, 1, CAST(N'2021-03-02T17:13:28.000' AS DateTime), 1, CAST(N'2021-03-02T17:13:28.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (5, N'Resources', 0, 1, CAST(N'2021-03-02T17:13:32.000' AS DateTime), 1, CAST(N'2021-03-02T17:13:32.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (6, N'Currencies', 0, 1, CAST(N'2021-03-02T17:13:35.000' AS DateTime), 1, CAST(N'2021-03-02T17:13:35.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (7, N'Entities', 0, 1, CAST(N'2021-03-02T17:13:38.000' AS DateTime), 1, CAST(N'2021-03-02T17:13:38.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (8, N'EntityDetails', 0, 1, CAST(N'2021-03-02T17:13:44.000' AS DateTime), 1, CAST(N'2021-03-02T17:13:44.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (9, N'Roles', 0, 1, CAST(N'2021-03-02T17:13:48.000' AS DateTime), 1, CAST(N'2021-03-02T17:13:48.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (10, N'Rights', 0, 1, CAST(N'2021-03-02T17:13:54.000' AS DateTime), 1, CAST(N'2021-03-02T17:13:54.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (11, N'UserRoles', 0, 1, CAST(N'2021-03-02T17:13:59.000' AS DateTime), 1, CAST(N'2021-03-02T17:13:59.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (12, N'Users', 0, 1, CAST(N'2021-03-02T17:14:44.000' AS DateTime), 1, CAST(N'2021-03-02T17:14:44.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (13, N'AppMenus', 0, 1, CAST(N'2021-03-02T17:14:39.000' AS DateTime), 1, CAST(N'2021-03-02T17:14:39.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (14, N'MenuNavigations', 0, 1, CAST(N'2021-03-02T17:14:31.000' AS DateTime), 1, CAST(N'2021-03-02T17:14:31.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (16, N'Businesses', 0, 1, CAST(N'2021-03-02T17:14:20.000' AS DateTime), 1, CAST(N'2021-03-02T17:14:20.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (22, N'DynamicSetupScreens', 1, 1, CAST(N'2020-11-28T12:08:56.000' AS DateTime), 1, CAST(N'2021-03-02T17:14:14.000' AS DateTime), 1, N'/admin/configuration/setup-screen')
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (23, N'APIConfigurations', 0, 1, CAST(N'2021-03-02T17:14:09.000' AS DateTime), 1, CAST(N'2021-03-02T17:14:09.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (24, N'AppConfigs', 0, 1, CAST(N'2021-03-02T17:14:04.000' AS DateTime), 1, CAST(N'2021-03-02T17:14:04.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (30, N'Teams', 0, 1, CAST(N'2021-03-02T17:38:57.000' AS DateTime), 1, CAST(N'2021-03-02T17:38:57.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (31, N'TeamMembers', 0, 1, CAST(N'2021-03-02T17:39:18.000' AS DateTime), 1, CAST(N'2021-03-02T17:39:18.000' AS DateTime), 1, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (35, N'Vendors', 0, 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (37, N'Categories', 0, 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (46, N'Status', 0, 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (48, N'Blogs', 0, 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (49, N'PlantGuide', 0, 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (51, N'OrderDetails', 0, 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (52, N'Orders', 0, 1, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Entities] ([EntityID], [EntityName], [DataVersion], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [LinkUrl]) VALUES (53, N'Products', 0, 1, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Entities] OFF
GO
SET IDENTITY_INSERT [dbo].[EntityDetails] ON 

INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (454, 2, N'CountryID', N'CountryID', N'CountryID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (455, 2, N'NameEn', N'NameEn', N'NameEn', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (456, 2, N'NameAr', N'NameAr', N'NameAr', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (457, 2, N'NameTr', N'NameTr', N'NameTr', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (458, 2, N'FlagUrl', N'FlagUrl', N'FlagUrl', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (459, 2, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (460, 2, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (461, 2, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (462, 2, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (463, 2, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (474, 5, N'ResourceID', N'ResourceID', N'ResourceID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (475, 5, N'LanguageID', N'LanguageID', N'LanguageID', 56, 1, 0, NULL, NULL, 1, N'Languages', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (476, 5, N'ResourceKey', N'ResourceKey', N'ResourceKey', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 300, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (477, 5, N'ResourceValue', N'ResourceValue', N'ResourceValue', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (478, 6, N'CurrencyID', N'CurrencyID', N'CurrencyID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (479, 6, N'CurrencyCode', N'CurrencyCode', N'CurrencyCode', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 10, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (480, 6, N'NameEn', N'NameEn', N'NameEn', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 40, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (481, 6, N'NameAr', N'NameAr', N'NameAr', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 40, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (482, 6, N'NameTr', N'NameTr', N'NameTr', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 40, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (483, 6, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (484, 7, N'EntityID', N'EntityID', N'EntityID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (485, 7, N'EntityName', N'EntityName', N'EntityName', 167, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 64, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (486, 7, N'DataVersion', N'DataVersion', N'DataVersion', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (487, 7, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (488, 7, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (489, 7, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (490, 7, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (491, 7, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (492, 7, N'LinkUrl', N'LinkUrl', N'LinkUrl', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 500, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (493, 8, N'EntityDetailsID', N'EntityDetailsID', N'EntityDetailsID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (494, 8, N'EntityID', N'EntityID', N'EntityID', 56, 1, 0, NULL, NULL, 1, N'Entities', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (495, 8, N'ColumnName', N'ColumnName', N'ColumnName', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 512, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (496, 8, N'DisplayNameEn', N'DisplayNameEn', N'DisplayNameEn', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 512, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (497, 8, N'DisplayNameAr', N'DisplayNameAr', N'DisplayNameAr', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 512, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (498, 8, N'DbTypeID', N'DbTypeID', N'DbTypeID', 52, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (499, 8, N'IsRequired', N'IsRequired', N'IsRequired', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (500, 8, N'IsGroup', N'IsGroup', N'IsGroup', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (501, 8, N'ParentSubGroupID', N'ParentSubGroupID', N'ParentSubGroupID', 56, 0, 0, NULL, NULL, 1, N'EntityDetails', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (502, 8, N'ParentEntityDetailsID', N'ParentEntityDetailsID', N'ParentEntityDetailsID', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (503, 8, N'IsForeignkey', N'IsForeignkey', N'IsForeignkey', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (504, 8, N'RefrencedTableName', N'RefrencedTableName', N'RefrencedTableName', 167, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 256, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (505, 8, N'EnableAutoComplate', N'EnableAutoComplate', N'EnableAutoComplate', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (506, 8, N'AutoCompleteSourceQuery', N'AutoCompleteSourceQuery', N'AutoCompleteSourceQuery', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (507, 8, N'IsDigit', N'IsDigit', N'IsDigit', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (508, 8, N'ValidationExpression', N'ValidationExpression', N'ValidationExpression', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 512, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (509, 8, N'AddEditVisible', N'AddEditVisible', N'AddEditVisible', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (510, 8, N'GridVisible', N'GridVisible', N'GridVisible', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (511, 8, N'SearchFilterVisible', N'SearchFilterVisible', N'SearchFilterVisible', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (512, 8, N'MaxLength', N'MaxLength', N'MaxLength', 52, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (513, 8, N'IsAutoID', N'IsAutoID', N'IsAutoID', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (514, 8, N'IsPrimaryKey', N'IsPrimaryKey', N'IsPrimaryKey', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (515, 8, N'DisplaySeqNo', N'DisplaySeqNo', N'DisplaySeqNo', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (516, 8, N'IsFileUpload', N'IsFileUpload', N'IsFileUpload', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (517, 8, N'AllowedFiles', N'AllowedFiles', N'AllowedFiles', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 512, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (518, 8, N'ShowGroupTitle', N'ShowGroupTitle', N'ShowGroupTitle', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (519, 8, N'PlaceHolderText', N'PlaceHolderText', N'PlaceHolderText', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (520, 8, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (521, 8, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (522, 8, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (523, 8, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (524, 9, N'RoleID', N'RoleID', N'RoleID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (525, 9, N'RoleName', N'RoleName', N'RoleName', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (526, 9, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (527, 9, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (528, 9, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (529, 9, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (530, 9, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (531, 10, N'RightID', N'RightID', N'RightID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (532, 10, N'RightName', N'RightName', N'RightName', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (533, 10, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (534, 10, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (535, 10, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (536, 10, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (537, 10, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (538, 11, N'UserRoleID', N'UserRoleID', N'UserRoleID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (539, 11, N'UserID', N'UserID', N'UserID', 56, 1, 0, NULL, NULL, 1, N'Users', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (540, 11, N'RoleID', N'RoleID', N'RoleID', 56, 1, 0, NULL, NULL, 1, N'Roles', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (541, 11, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (542, 11, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (543, 11, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (544, 11, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (545, 24, N'AppConfigID', N'AppConfigID', N'AppConfigID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (546, 24, N'AppConfigKey', N'AppConfigKey', N'AppConfigKey', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (547, 24, N'AppConfigValue', N'AppConfigValue', N'AppConfigValue', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (548, 24, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (549, 24, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (550, 24, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (551, 24, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (552, 23, N'ID', N'ID', N'ID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (553, 23, N'Title', N'Title', N'Title', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (554, 23, N'UrlName', N'UrlName', N'UrlName', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (555, 23, N'MethodType', N'MethodType', N'MethodType', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (556, 23, N'Description', N'Description', N'Description', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (557, 23, N'URL', N'URL', N'URL', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (558, 23, N'SqlQuery', N'SqlQuery', N'SqlQuery', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (559, 23, N'DefaultParams', N'DefaultParams', N'DefaultParams', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4096, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (560, 23, N'IsActive', N'IsActive', N'IsActive', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (561, 23, N'UrlParams', N'UrlParams', N'UrlParams', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (562, 23, N'DataParams', N'DataParams', N'DataParams', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (563, 23, N'SuccessResponse', N'SuccessResponse', N'SuccessResponse', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (564, 23, N'ErrorResponse', N'ErrorResponse', N'ErrorResponse', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (565, 23, N'SampleCall', N'SampleCall', N'SampleCall', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (566, 23, N'Notes', N'Notes', N'Notes', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (567, 23, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (568, 23, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (569, 23, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (570, 23, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (571, 23, N'IsCacheAllowed', N'IsCacheAllowed', N'IsCacheAllowed', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (572, 22, N'DynamicSetupScreenID', N'DynamicSetupScreenID', N'DynamicSetupScreenID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (573, 22, N'ModuleName', N'ModuleName', N'ModuleName', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 300, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (574, 22, N'ScreenName', N'ScreenName', N'ScreenName', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 300, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (575, 22, N'DS_TableName', N'DS_TableName', N'DS_TableName', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (576, 22, N'DS_Title', N'DS_Title', N'DS_Title', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 500, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (577, 22, N'DS_AllowAddEdit', N'DS_AllowAddEdit', N'DS_AllowAddEdit', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (578, 22, N'DS_AllowPreview', N'DS_AllowPreview', N'DS_AllowPreview', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (579, 22, N'DS_AllowSearchFilter', N'DS_AllowSearchFilter', N'DS_AllowSearchFilter', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (580, 22, N'DS_AllowListingGrid', N'DS_AllowListingGrid', N'DS_AllowListingGrid', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (581, 22, N'DS_GridColumns', N'DS_GridColumns', N'DS_GridColumns', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2048, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (582, 22, N'DS_AllowDelete', N'DS_AllowDelete', N'DS_AllowDelete', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (583, 22, N'DS_AllowEdit', N'DS_AllowEdit', N'DS_AllowEdit', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (584, 22, N'DS_AllowApprovals', N'DS_AllowApprovals', N'DS_AllowApprovals', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (585, 22, N'DS_ExcludeAddEditColumns', N'DS_ExcludeAddEditColumns', N'DS_ExcludeAddEditColumns', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2048, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (586, 22, N'DS_ExcludeSearchColumns', N'DS_ExcludeSearchColumns', N'DS_ExcludeSearchColumns', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2048, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (587, 22, N'DS_ShowAddNewButton', N'DS_ShowAddNewButton', N'DS_ShowAddNewButton', 239, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 20, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (588, 22, N'DS_GridTitle', N'DS_GridTitle', N'DS_GridTitle', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 200, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (589, 22, N'DS_OrderBy', N'DS_OrderBy', N'DS_OrderBy', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 200, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (590, 22, N'DS_DoNotRenderJavaScript', N'DS_DoNotRenderJavaScript', N'DS_DoNotRenderJavaScript', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (591, 22, N'DS_ExtenderName', N'DS_ExtenderName', N'DS_ExtenderName', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 500, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (592, 22, N'DS_DontLoadRecursiveData', N'DS_DontLoadRecursiveData', N'DS_DontLoadRecursiveData', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (593, 22, N'DS_AllowImport', N'DS_AllowImport', N'DS_AllowImport', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (594, 22, N'DS_ParentColumnNameForRecursiveGrid', N'DS_ParentColumnNameForRecursiveGrid', N'DS_ParentColumnNameForRecursiveGrid', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (595, 22, N'DS_RecordsPerPage', N'DS_RecordsPerPage', N'DS_RecordsPerPage', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (596, 22, N'DS_ImportURL', N'DS_ImportURL', N'DS_ImportURL', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (597, 22, N'DS_ManualCrud', N'DS_ManualCrud', N'DS_ManualCrud', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (598, 22, N'DS_Filters', N'DS_Filters', N'DS_Filters', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2048, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (599, 22, N'DS_DisableSorting', N'DS_DisableSorting', N'DS_DisableSorting', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (600, 22, N'DS_ShowHistory', N'DS_ShowHistory', N'DS_ShowHistory', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (601, 22, N'DS_IsMenuNavigation', N'DS_IsMenuNavigation', N'DS_IsMenuNavigation', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (602, 22, N'DS_TableConfigs', N'DS_TableConfigs', N'DS_TableConfigs', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (603, 22, N'DS_CustomJavaScript', N'DS_CustomJavaScript', N'DS_CustomJavaScript', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (604, 22, N'DS_Condition', N'DS_Condition', N'DS_Condition', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2048, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (605, 22, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (606, 22, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (607, 22, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (608, 22, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (609, 22, N'DS_CustomQuery', N'DS_CustomQuery', N'DS_CustomQuery', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (610, 16, N'BusinessID', N'BusinessID', N'BusinessID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (611, 16, N'CategoryID', N'CategoryID', N'CategoryID', 56, 1, 0, NULL, NULL, 1, N'Categories', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (612, 16, N'NameEn', N'NameEn', N'NameEn', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (613, 16, N'NameAr', N'NameAr', N'NameAr', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (614, 16, N'NameTr', N'NameTr', N'NameTr', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (615, 16, N'LogoUrl', N'LogoUrl', N'LogoUrl', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, 0, NULL, 0, 0, 0, 500, 0, 0, 0, 1, N'.jpg,.png,.jpeg', 0, NULL, CAST(N'2021-03-02T17:15:51.000' AS DateTime), 1, CAST(N'2021-03-02T17:15:51.000' AS DateTime), 1)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (616, 16, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (617, 16, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (618, 16, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (619, 16, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (620, 16, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (621, 16, N'InfoEn', N'InfoEn', N'InfoEn', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (622, 16, N'InfoAr', N'InfoAr', N'InfoAr', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (623, 16, N'InfoTr', N'InfoTr', N'InfoTr', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 2000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (636, 14, N'MenuNavigationID', N'MenuNavigationID', N'MenuNavigationID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (637, 14, N'MenuNavigationName', N'MenuNavigationName', N'MenuNavigationName', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 300, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (638, 14, N'ParentMenuNavigationID', N'ParentMenuNavigationID', N'ParentMenuNavigationID', 56, 0, 0, NULL, NULL, 1, N'MenuNavigations', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (639, 14, N'DisplaySeqNo', N'DisplaySeqNo', N'DisplaySeqNo', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (640, 14, N'LinkUrl', N'LinkUrl', N'LinkUrl', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 500, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (641, 14, N'IconClass', N'IconClass', N'IconClass', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (642, 14, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (643, 14, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (644, 14, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (645, 14, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (646, 14, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (647, 14, N'EntityID', N'EntityID', N'EntityID', 56, 0, 0, NULL, NULL, 1, N'Entities', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (648, 13, N'AppMenuID', N'AppMenuID', N'AppMenuID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (649, 13, N'NameEn', N'NameEn', N'NameEn', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (650, 13, N'NameAr', N'NameAr', N'NameAr', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (651, 13, N'NameTr', N'NameTr', N'NameTr', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (652, 13, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (653, 13, N'MenuUrl', N'MenuUrl', N'MenuUrl', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (654, 13, N'ActiveIconUrl', N'ActiveIconUrl', N'ActiveIconUrl', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (655, 13, N'InActiveIconUrl', N'InActiveIconUrl', N'InActiveIconUrl', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (656, 13, N'DisplaySeqNo', N'DisplaySeqNo', N'DisplaySeqNo', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (657, 13, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (658, 13, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (659, 13, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (660, 13, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (661, 12, N'UserID', N'UserID', N'UserID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (662, 12, N'FullName', N'FullName', N'FullName', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (663, 12, N'EmailAddress', N'EmailAddress', N'EmailAddress', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (664, 12, N'Password', N'Password', N'Password', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (665, 12, N'PhoneNo', N'PhoneNo', N'PhoneNo', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 60, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (666, 12, N'CountryID', N'CountryID', N'CountryID', 56, 0, 0, NULL, NULL, 1, N'Countries', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (667, 12, N'CityID', N'CityID', N'CityID', 56, 0, 0, NULL, NULL, 1, N'Cities', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (668, 12, N'ProfileUrl', N'ProfileUrl', N'ProfileUrl', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, 0, NULL, 0, 0, 0, 1000, 0, 0, 0, 1, N'.jpg,.png,.jpeg', 0, NULL, CAST(N'2021-03-02T17:15:27.000' AS DateTime), 1, CAST(N'2021-03-02T17:15:27.000' AS DateTime), 1)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (669, 12, N'VerificationCode', N'VerificationCode', N'VerificationCode', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 200, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (670, 12, N'IsVerified', N'IsVerified', N'IsVerified', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (671, 12, N'StatusID', N'StatusID', N'StatusID', 56, 1, 0, NULL, NULL, 1, N'Statuses', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (673, 12, N'IsTermOfUseAccepted', N'IsTermOfUseAccepted', N'IsTermOfUseAccepted', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (674, 12, N'IsPrivacyPolicyAccepted', N'IsPrivacyPolicyAccepted', N'IsPrivacyPolicyAccepted', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (675, 12, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
GO
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (676, 12, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (677, 12, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (678, 12, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (692, 30, N'TeamID', N'TeamID', N'TeamID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (693, 30, N'BusinessID', N'BusinessID', N'BusinessID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (694, 30, N'TeamName', N'TeamName', N'TeamName', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (695, 30, N'ManagerID', N'ManagerID', N'ManagerID', 56, 1, 0, NULL, NULL, 1, N'Users', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (696, 30, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (697, 30, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (698, 30, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (699, 30, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (700, 30, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (713, 31, N'TeamMemberID', N'TeamMemberID', N'TeamMemberID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (714, 31, N'TeamID', N'TeamID', N'TeamID', 56, 1, 0, NULL, NULL, 1, N'Teams', 0, NULL, 0, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, CAST(N'2021-03-02T17:43:28.000' AS DateTime), 1, CAST(N'2021-03-02T17:43:28.000' AS DateTime), 1)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (715, 31, N'SalesPersonID', N'SalesPersonID', N'SalesPersonID', 56, 1, 0, NULL, NULL, 1, N'Users', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (716, 31, N'BusinessID', N'BusinessID', N'BusinessID', 56, 0, 0, NULL, NULL, 1, N'Businesses', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (717, 31, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (718, 31, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (719, 31, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (720, 31, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (721, 31, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (746, 35, N'VendorID', N'VendorID', N'VendorID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (747, 35, N'Name', N'Name', N'Name', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (748, 35, N'Contact', N'Contact', N'Contact', 108, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 9, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (749, 35, N'Email', N'Email', N'Email', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (750, 35, N'City', N'City', N'City', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (751, 35, N'Area', N'Area', N'Area', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 600, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (752, 35, N'Street', N'Street', N'Street', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 600, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (753, 35, N'HouseNo', N'HouseNo', N'HouseNo', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 600, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (754, 35, N'Notes', N'Notes', N'Notes', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (755, 35, N'CityID', N'CityID', N'CityID', 56, 0, 0, NULL, NULL, 1, N'Cities', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (766, 37, N'CategoryID', N'CategoryID', N'CategoryID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (767, 37, N'NameAr', N'NameAr', N'NameAr', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (768, 37, N'NameEn', N'NameEn', N'NameEn', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (769, 37, N'ParentCategoryID', N'ParentCategoryID', N'ParentCategoryID', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (770, 37, N'DisplaySeqNo', N'DisplaySeqNo', N'DisplaySeqNo', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (771, 37, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (772, 37, N'ImageUrl', N'ImageUrl', N'ImageUrl', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (773, 37, N'ImageUrl2', N'ImageUrl2', N'ImageUrl2', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 400, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (774, 37, N'IsDeleted', N'IsDeleted', N'IsDeleted', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (775, 37, N'WebImages', N'WebImages', N'WebImages', 167, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 600, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (820, 48, N'BlogID', N'BlogID', N'BlogID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (821, 48, N'BlogName', N'BlogName', N'BlogName', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (822, 48, N'BlogDetails', N'BlogDetails', N'BlogDetails', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (823, 48, N'BlogImageUrl', N'BlogImageUrl', N'BlogImageUrl', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (824, 48, N'IsActive', N'IsActive', N'IsActive', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (825, 48, N'IsDeleted', N'IsDeleted', N'IsDeleted', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (826, 49, N'PlantGuideID', N'PlantGuideID', N'PlantGuideID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (827, 49, N'PlantGuideName', N'PlantGuideName', N'PlantGuideName', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (828, 49, N'PlantGuideDetails', N'PlantGuideDetails', N'PlantGuideDetails', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1600, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (829, 49, N'PlantGuideImageUrl', N'PlantGuideImageUrl', N'PlantGuideImageUrl', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (830, 49, N'IsActive', N'IsActive', N'IsActive', 104, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (831, 49, N'IsDeleted', N'IsDeleted', N'IsDeleted', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (844, 51, N'OrderDetailID', N'OrderDetailID', N'OrderDetailID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (845, 51, N'OrderID', N'OrderID', N'OrderID', 56, 1, 0, NULL, NULL, 1, N'Orders', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (846, 51, N'ProductID', N'ProductID', N'ProductID', 56, 1, 0, NULL, NULL, 1, N'Products', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (847, 51, N'Quantity', N'Quantity', N'Quantity', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (848, 51, N'Price', N'Price', N'Price', 106, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 9, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (849, 51, N'CurrencyID', N'CurrencyID', N'CurrencyID', 56, 1, 0, NULL, NULL, 1, N'Currencies', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (850, 51, N'VendorID', N'VendorID', N'VendorID', 56, 0, 0, NULL, NULL, 1, N'Vendors', 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (851, 52, N'OrderID', N'OrderID', N'OrderID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (852, 52, N'UserID', N'UserID', N'UserID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (853, 52, N'OrderDate', N'OrderDate', N'OrderDate', 61, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (854, 52, N'StatusID', N'StatusID', N'StatusID', 231, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 100, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (855, 52, N'CreatedOn', N'CreatedOn', N'CreatedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (856, 52, N'CreatedBy', N'CreatedBy', N'CreatedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (857, 52, N'ModifiedOn', N'ModifiedOn', N'ModifiedOn', 61, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 8, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (858, 52, N'ModifiedBy', N'ModifiedBy', N'ModifiedBy', 56, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (859, 53, N'ProductID', N'ProductID', N'ProductID', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 1, 1, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (860, 53, N'NameAr', N'NameAr', N'NameAr', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (861, 53, N'NameEn', N'NameEn', N'NameEn', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1000, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (862, 53, N'IsActive', N'IsActive', N'IsActive', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (863, 53, N'DescriptionAr', N'DescriptionAr', N'DescriptionAr', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (864, 53, N'DescriptionEn', N'DescriptionEn', N'DescriptionEn', 231, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, -1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (865, 53, N'Price', N'Price', N'Price', 106, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 9, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (866, 53, N'Stock', N'Stock', N'Stock', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (867, 53, N'TotalQuantity', N'TotalQuantity', N'TotalQuantity', 56, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 4, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (868, 53, N'IsDeleted', N'IsDeleted', N'IsDeleted', 104, 1, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 1, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[EntityDetails] ([EntityDetailsID], [EntityID], [ColumnName], [DisplayNameEn], [DisplayNameAr], [DbTypeID], [IsRequired], [IsGroup], [ParentSubGroupID], [ParentEntityDetailsID], [IsForeignkey], [RefrencedTableName], [EnableAutoComplate], [AutoCompleteSourceQuery], [IsDigit], [ValidationExpression], [AddEditVisible], [GridVisible], [SearchFilterVisible], [MaxLength], [IsAutoID], [IsPrimaryKey], [DisplaySeqNo], [IsFileUpload], [AllowedFiles], [ShowGroupTitle], [PlaceHolderText], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (869, 53, N'OldPrice', N'OldPrice', N'OldPrice', 106, 0, 0, NULL, NULL, 0, NULL, 0, NULL, NULL, NULL, 0, 0, 0, 9, 0, 0, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[EntityDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Languages] ON 

INSERT [dbo].[Languages] ([LanguageID], [NameAr], [NameEn], [IsActive], [IsDeleted]) VALUES (1, N'عربى', N'Arabic', 1, 0)
INSERT [dbo].[Languages] ([LanguageID], [NameAr], [NameEn], [IsActive], [IsDeleted]) VALUES (2, N'الإنجليزية', N'English', 1, 0)
SET IDENTITY_INSERT [dbo].[Languages] OFF
GO
SET IDENTITY_INSERT [dbo].[MenuNavigations] ON 

INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (9, N'Settings', NULL, 9, NULL, N'fa fa-file', 1, CAST(N'2020-11-28T12:04:22.000' AS DateTime), 1, CAST(N'2022-04-21T23:24:58.000' AS DateTime), 5, NULL)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (10, N'App Menus', 9, 1, N'/admin/settings/app-menus', N'fa fa-file', 0, CAST(N'2020-11-28T12:04:43.000' AS DateTime), 1, CAST(N'2020-11-28T00:05:12.000' AS DateTime), NULL, 13)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (11, N'Menus', 9, 2, N'/admin/settings/menus', N'fa fa-file', 1, CAST(N'2020-11-28T12:05:29.000' AS DateTime), 1, CAST(N'2020-11-28T00:05:54.000' AS DateTime), NULL, 14)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (12, N'Configurations', NULL, 8, NULL, N'fa fa-file', 1, CAST(N'2020-11-28T12:06:08.000' AS DateTime), 1, CAST(N'2022-04-21T23:25:13.000' AS DateTime), 5, NULL)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (13, N'Setup Screen', 12, 1, N'/admin/configuration/setup-screen', N'fa fa-file', 0, CAST(N'2020-11-28T12:10:29.000' AS DateTime), 1, CAST(N'2020-11-28T00:10:59.000' AS DateTime), NULL, 22)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (14, N'Languages', 12, 2, N'/admin/configuration/languages', N'fa fa-file', 1, CAST(N'2020-11-28T12:11:04.000' AS DateTime), 1, CAST(N'2020-11-28T00:11:30.000' AS DateTime), NULL, 1)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (15, N'Countries', 12, 3, N'/admin/configuration/countries', N'fa fa-file', 1, CAST(N'2020-11-28T12:11:33.000' AS DateTime), 1, CAST(N'2020-11-28T00:12:10.000' AS DateTime), NULL, 2)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (16, N'Cities', 12, 4, N'/admin/configuration/cities', N'fa fa-file', 1, CAST(N'2020-11-28T12:12:17.000' AS DateTime), 1, CAST(N'2020-11-28T00:12:33.000' AS DateTime), NULL, 3)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (18, N'Resources', 12, 6, N'/admin/configuration/resources', N'fa fa-file', 0, CAST(N'2020-11-28T12:13:13.000' AS DateTime), 1, CAST(N'2020-11-28T00:13:48.000' AS DateTime), NULL, 5)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (19, N'Currencies', 12, 7, N'/admin/configuration/currencies', N'fa fa-file', 0, CAST(N'2020-11-28T12:13:51.000' AS DateTime), 1, CAST(N'2020-11-28T00:14:25.000' AS DateTime), NULL, 6)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (20, N'Entities', 12, 8, N'/admin/configuration/entities', N'fa fa-file', 0, CAST(N'2020-11-28T12:14:32.000' AS DateTime), 1, CAST(N'2020-11-28T00:15:55.000' AS DateTime), 1, 7)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (21, N'Entity Details', 12, 9, N'/admin/configuration/entity-details', N'fa fa-file', 0, CAST(N'2020-11-28T12:15:11.000' AS DateTime), 1, CAST(N'2020-11-28T00:15:31.000' AS DateTime), NULL, 8)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (22, N'Manage API''s', 12, 10, N'/admin/configuration/api-configurations', N'fa fa-file', 0, CAST(N'2020-11-28T12:32:24.000' AS DateTime), 1, CAST(N'2020-11-28T00:33:18.000' AS DateTime), NULL, 23)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (23, N'Manage App', 12, 11, N'/admin/configuration/app-configs', N'fa fa-file', 0, CAST(N'2020-11-28T12:33:21.000' AS DateTime), 1, CAST(N'2020-11-28T00:33:46.000' AS DateTime), NULL, 24)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (24, N'User Management', NULL, 7, NULL, N'fa fa-file', 1, CAST(N'2020-11-28T02:18:06.000' AS DateTime), 1, CAST(N'2022-04-21T23:25:42.000' AS DateTime), 5, NULL)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (25, N'Roles', 24, 1, N'/admin/user-management/roles', N'fa fa-file', 1, CAST(N'2020-11-28T02:18:26.000' AS DateTime), 1, CAST(N'2020-11-28T02:18:51.000' AS DateTime), NULL, 9)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (26, N'Rights', 24, 5, N'/admin/user-management/rights', N'fa fa-file', 1, CAST(N'2020-11-28T02:18:57.000' AS DateTime), 1, CAST(N'2022-04-22T09:37:24.000' AS DateTime), 5, 10)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (27, N'User Roles', 24, 3, N'/admin/user-management/user-roles', N'fa fa-file', 1, CAST(N'2020-11-28T02:19:38.000' AS DateTime), 1, CAST(N'2020-11-28T02:20:08.000' AS DateTime), NULL, 11)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (28, N'Users', 24, 4, N'/admin/user-management/users', N'fa fa-file', 1, CAST(N'2020-11-28T02:20:11.000' AS DateTime), 1, CAST(N'2020-11-28T02:20:36.000' AS DateTime), NULL, 12)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (43, N'Vendors', NULL, 5, NULL, N'fa fa-file', 1, CAST(N'2022-04-12T10:35:46.000' AS DateTime), 5, CAST(N'2022-04-19T13:38:09.000' AS DateTime), 3, NULL)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (44, N'Vendors', 43, 1, N'/admin/vendors/vendors', N'fa fa-file', 1, CAST(N'2022-04-12T10:42:27.000' AS DateTime), 5, CAST(N'2022-04-19T07:37:39.000' AS DateTime), 3, 35)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (47, N'Plants Categories', NULL, 3, NULL, N'fa fa-file', 1, CAST(N'2022-04-19T01:33:33.000' AS DateTime), 3, CAST(N'2022-04-21T23:37:01.000' AS DateTime), 5, NULL)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (48, N'Categories', 47, 1, N'/admin/Plantcategories/categories', N'fa fa-file', 1, CAST(N'2022-04-19T01:35:32.000' AS DateTime), 3, CAST(N'2022-06-13T00:01:06.000' AS DateTime), 5, 37)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (53, N'Orders', NULL, 6, NULL, N'fa fa-file', 1, CAST(N'2022-04-20T08:17:28.000' AS DateTime), 5, CAST(N'2022-04-21T23:26:09.000' AS DateTime), 5, NULL)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (62, N'Products', NULL, 4, NULL, N'fa fa-file', 1, CAST(N'2022-04-21T11:16:03.000' AS DateTime), 5, CAST(N'2022-04-21T23:36:26.000' AS DateTime), 5, NULL)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (64, N'Blogs Management', NULL, 1, NULL, N'fa fa-file', 1, CAST(N'2022-04-21T11:23:30.000' AS DateTime), 5, CAST(N'2022-04-21T23:23:44.000' AS DateTime), NULL, NULL)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (65, N'Blogs', 64, 1, N'/admin/blogs-management/blogs', N'fa fa-file', 1, CAST(N'2022-04-21T11:23:47.000' AS DateTime), 5, CAST(N'2022-04-21T23:24:07.000' AS DateTime), NULL, 48)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (66, N'Plant Guide', NULL, 2, NULL, N'fa fa-file', 1, CAST(N'2022-04-21T11:33:10.000' AS DateTime), 5, CAST(N'2022-04-21T23:34:13.000' AS DateTime), 5, NULL)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (67, N'Plant Guide', 66, 1, N'/admin/PlantGuide/PlantGuide', N'fa fa-file', 1, CAST(N'2022-04-21T11:34:20.000' AS DateTime), 5, CAST(N'2022-04-21T23:34:45.000' AS DateTime), NULL, 49)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (69, N'Display Orders', 53, 1, N'/admin/orders/orders', N'fa fa-file', 1, CAST(N'2022-06-05T07:02:08.000' AS DateTime), 5, CAST(N'2022-06-05T19:02:49.000' AS DateTime), NULL, 52)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (70, N'Order Details', 53, 2, N'/admin/orders/order-details', N'fa fa-file', 1, CAST(N'2022-06-05T07:02:53.000' AS DateTime), 5, CAST(N'2022-06-05T19:03:13.000' AS DateTime), NULL, 51)
INSERT [dbo].[MenuNavigations] ([MenuNavigationID], [MenuNavigationName], [ParentMenuNavigationID], [DisplaySeqNo], [LinkUrl], [IconClass], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [EntityID]) VALUES (71, N'Products', 62, 1, N'/admin/Products/Products', N'fa-fa-file', 1, CAST(N'2022-06-12T11:52:07.000' AS DateTime), 5, CAST(N'2022-06-12T23:53:14.000' AS DateTime), NULL, 53)
SET IDENTITY_INSERT [dbo].[MenuNavigations] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetails] ON 

INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [CurrencyID], [VendorID]) VALUES (1, 3, 5, 2, CAST(600.00 AS Decimal(10, 2)), 2, 1)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [CurrencyID], [VendorID]) VALUES (2, 4, 5, 1, CAST(300.00 AS Decimal(10, 2)), 2, 1)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [CurrencyID], [VendorID]) VALUES (3, 5, 6, 4, CAST(1400.00 AS Decimal(10, 2)), 2, 1)
INSERT [dbo].[OrderDetails] ([OrderDetailID], [OrderID], [ProductID], [Quantity], [Price], [CurrencyID], [VendorID]) VALUES (4, 6, 5, 3, CAST(900.00 AS Decimal(10, 2)), 2, 1)
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [StatusID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (3, 3, CAST(N'2022-05-25T01:46:22.000' AS DateTime), N'Delieverd', NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [StatusID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (4, 3, CAST(N'2022-05-25T02:46:22.000' AS DateTime), N'Delieverd', NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [StatusID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (5, 7, CAST(N'2022-06-05T01:46:22.000' AS DateTime), N'Delieverd', NULL, NULL, NULL, NULL)
INSERT [dbo].[Orders] ([OrderID], [UserID], [OrderDate], [StatusID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (6, 3, CAST(N'2022-06-08T01:46:22.000' AS DateTime), N'Delieverd', NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductCategories] ON 

INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (1, 5, 2, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (2, 6, 2, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (3, 7, 2, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (4, 10, 2, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (5, 11, 2, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (6, 12, 2, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (7, 13, 2, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (8, 8, 3, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (9, 9, 3, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (10, 10, 3, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (11, 11, 4, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (12, 12, 5, 0)
INSERT [dbo].[ProductCategories] ([ProductCategoryID], [ProductID], [CategoryID], [IsDeleted]) VALUES (13, 13, 5, 0)
SET IDENTITY_INSERT [dbo].[ProductCategories] OFF
GO
SET IDENTITY_INSERT [dbo].[ProductImages] ON 

INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (1, N'', 5, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (2, N'', 6, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (5, N'', 7, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (6, N'', 8, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (7, N'', 9, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (12, N'', 10, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (13, N'', 11, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (14, N'', 12, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (15, N'', 13, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (16, N'', 14, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (17, N'', 15, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (18, N'', 16, 0, 0, N'')
INSERT [dbo].[ProductImages] ([ProductImageID], [ImageUrl], [ProductID], [IsDefault], [IsDeleted], [WebImage]) VALUES (19, N'', 17, 0, 0, N'')
SET IDENTITY_INSERT [dbo].[ProductImages] OFF
GO
SET IDENTITY_INSERT [dbo].[Products] ON 

INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (5, N'زهرة الآليوم', N'Allium', 1, N'الثوم ، المعروف باسم الثوم ، هو بصلي معمر من عائلة البصل. موطنها منطقة البحر الأبيض المتوسط. تتكون أوراق الشجر من أوراق خضراء عطرية وخطية ومسطحة تشبه العشب.', N'Allium sativum, commonly called garlic, is a bulbous perennial of the onion family. It is native to the Mediterranean area. Foliage consists of aromatic, linear, flattened, grass-like green leaves.', CAST(300.00 AS Decimal(10, 2)), 35, 35, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (6, N'زهرة الآليوم', N'Buckswheat', 1, N'الثوم ، المعروف باسم الثوم ، هو بصلي معمر من عائلة البصل. موطنها منطقة البحر الأبيض المتوسط. تتكون أوراق الشجر من أوراق خضراء عطرية وخطية ومسطحة تشبه العشب.', N'Allium sativum, commonly called garlic, is a bulbous perennial of the onion family. It is native to the Mediterranean area. Foliage consists of aromatic, linear, flattened, grass-like green leaves.', CAST(350.00 AS Decimal(10, 2)), 85, 85, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (7, N'البرسيم', N'alfala', 1, N'البرسيم ، (ميديكاغو ساتيفا) ، ويسمى أيضًا لوسيرن أو ميديك الأرجواني ، نبات معمر ، يشبه البرسيم ، نبات بقولي من عائلة البازلاء (فاباسي) ، يزرع على نطاق واسع في المقام الأول للتبن والمراعي والسيلاج. تشتهر البرسيم بتحمله للجفاف والحرارة والبرودة ولإنتاجية وجودة أعشابه الرائعة.', N'alfalfa, (Medicago sativa), also called lucerne or purple medic, perennial, cloverlike, leguminous plant of the pea family (Fabaceae), widely grown primarily for hay, pasturage, and silage. Alfalfa is known for its tolerance of drought, heat, and cold and for the remarkable productivity and quality of its herbage.', CAST(800.00 AS Decimal(10, 2)), 80, 80, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (8, N'قرون الأيائل', N'Staghorn', 1, N'سرخس قرون الأيائل عبارة عن مجموعة من حوالي 18 نوعًا من السرخس المشاشية في جنس Platycerium من عائلة polypodiaceae (Polypodiaceae) موطنها في المقام الأول إفريقيا وأستراليا وجنوب شرق آسيا ، والتي من المفترض أن تشبه سعفها القرون المتشعبة من ذكر الغزلان أو الأيائل.', N'Staghorn ferns are a group of about 18 species of epiphytic ferns in the genus Platycerium of the polypod family (Polypodiaceae) native primarily to Africa, Australia and Southeast Asia, whose fronds supposedly resemble the forked antlers of male deer or elk.', CAST(800.00 AS Decimal(10, 2)), 80, 80, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (9, N'سيدوم', N'Sedum', 1, N'هو جنس كبير من النباتات المزهرة في عائلة سيدوم Crassulaceae ، والتي يُعرف أعضاؤها عادةً باسم الحجارة الحجرية. تم وصف الجنس بأنه يحتوي على ما يصل إلى 600 نوع ، ثم تم تقليله لاحقًا إلى 400-500.', N'Sedum is a large genus of flowering plants in the family Crassulaceae, members of which are commonly known as stonecrops. The genus has been described as containing up to 600 species, subsequently reduced to 400–500.', CAST(700.00 AS Decimal(10, 2)), 80, 80, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (10, N'كالاتيا', N'Calathea', 1, N'تعتبر نباتات الكالاتا جزءًا من عائلة النباتات المعروفة باسم Marantaceae ، وهي نوع من النباتات المزهرة من المناطق الاستوائية مثل إفريقيا. تشتهر بأوراقها العريضة والخضراء والملونة. هذه الأوراق العريضة تجعلها شائعة في المناطق ذات الإضاءة المنخفضة.', N'Calathea plants are part of the family of plants known as Marantaceae, which is a species of flowering plants from tropical areas such as Africa. They are famous for their wide, green, colorful leaves. These wide leaves make them popular for areas of low light.', CAST(700.00 AS Decimal(10, 2)), 80, 80, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (11, N'الأرقطيون', N'Burdock', 1, N'الأرقطيون هو عشب خشن قبيح. خلال السنة الأولى تنتج فقط وردة من الأوراق الكبيرة من جذر طويل مستدق. في السنة الثانية ينمو النبات إلى حجم كبير يتراوح ارتفاعه من 3 إلى 7 أقدام.', N'Burdock is a coarse, unsightly weed. During the first year it produces only a rosette of large leaves from a long tapering root. In the second year the plant grows to a large size, measuring from 3 to 7 feet in height.', CAST(700.00 AS Decimal(10, 2)), 80, 80, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (12, N'الهندباء', N'Chicory', 1, N'الهندباء لها جذر طويل سمين وجذع مشعر صلب ومتفرّع. أوراقها ذات الأسنان المفصصة ، في الهندباء البرية مشابهة في مظهرها لأوراق الهندباء ، تُحمل حول القاعدة.', N'Chicory is a plant. Its seeds, roots, and dried, above-ground parts are used to make medicine. Chicory is used for liver and heart health, constipation, swelling, and other conditions, but there is no good evidence to support its use.', CAST(900.00 AS Decimal(10, 2)), 90, 90, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (13, N'آذريون', N'Calendula', 1, N'آذريون هو نبات يعرف باسم وعاء القطيفة. إنها ليست مثل القطيفة المزخرفة من جنس Tagetes المزروعة في حدائق الخضروات', N'Calendula (Calendula officinalis) is a plant known as pot marigold. It is not the same as ornamental marigolds of the Tagetes genus grown in vegetable gardens.', CAST(900.00 AS Decimal(10, 2)), 90, 90, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (14, N'السرخس', N'Fern', 1, N'السرخس هو عضو في مجموعة من النباتات الوعائية (نباتات مع نسيج الخشب واللحاء) التي تتكاثر عن طريق الأبواغ وليس لها بذور ولا أزهار.', N'A fern is a member of a group of vascular plants (plants with xylem and phloem) that reproduce via spores and have neither seeds nor flowers..', CAST(1500.00 AS Decimal(10, 2)), 100, 100, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (15, N'كوليوس', N'Coleus', 1, N' نمو نبات القوليوس في تربة باردة ، رطبة بشكل متساوٍ ، جيدة التصريف. الرطوبة المستمرة جيدة ، لكن الظروف المبللة تسبب مرضًا جذريًا.', N'Coleus thrive in cool, evenly moist, well-drained soil. Consistent moisture is good, but soggy conditions cause root disease.', CAST(1600.00 AS Decimal(10, 2)), 100, 100, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (16, N'تاج من الشوك', N'Crown of thrones', 1, N'تاج الأشواك نبات منزلي رائع لأنه يتكيف جيدًا مع البيئات الداخلية الجافة ودرجات حرارة الغرفة.', N'The crown of thorns is a great houseplant because it adjusts well to dry indoor environments and room temperatures.', CAST(1000.00 AS Decimal(10, 2)), 90, 90, 0, NULL)
INSERT [dbo].[Products] ([ProductID], [NameAr], [NameEn], [IsActive], [DescriptionAr], [DescriptionEn], [Price], [Stock], [TotalQuantity], [IsDeleted], [OldPrice]) VALUES (17, N'نبات اليشم', N'jade plant', 1, N'يشبه نبات اليشم نبات البونساي في طريقة نموه والحفاظ عليه. لها جذع سميك بأغصان بارزة مثل شجرة مصغرة.', N'The jade plant is similar to a bonsai plant in the way that it grows and is maintained. It has a thick trunk with branches that jut out like a miniature tree. ', CAST(1000.00 AS Decimal(10, 2)), 90, 90, 0, NULL)
SET IDENTITY_INSERT [dbo].[Products] OFF
GO
SET IDENTITY_INSERT [dbo].[Resources] ON 

INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (1, 2, N'About', N'Some description of about page')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (2, 1, N'About', N'بعض وصف حول الصفحة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (3, 1, N'Contact', N'اتصل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (4, 2, N'Contact', N'Contact')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (5, 1, N'Language', N'لغة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (6, 2, N'Language', N'Language')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (7, 2, N'FoodDiscount', N'Food Discounts')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (8, 1, N'FoodDiscount', N'خصم على الطعام')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (9, 2, N'FoodDiscountParagraph', N'Earn discounts when ever you visit restaurants and cafes')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (10, 1, N'FoodDiscountParagraph', N'اربح خصومات عندما تزور المطاعم والمقاهي')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (11, 2, N'ShoppingDiscounts', N'Shopping Discounts')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (12, 1, N'ShoppingDiscounts', N'خصومات التسوق')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (13, 2, N'ShoppingDiscountsParagraph', N'Earn discounts from the stores you buy stuff from online and offline')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (14, 1, N'ShoppingDiscountsParagraph', N'اربح خصومات من المتاجر التي تشتري أشياء منها عبر الإنترنت وغير متصل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (15, 2, N'SignUp', N'SIGN UP')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (16, 1, N'SignUp', N'سجل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (17, 2, N'SignIn', N'SIGN IN')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (18, 1, N'SignIn', N'تسجيل الدخول')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (19, 2, N'RememberMe', N'Remember Me')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (20, 1, N'RememberMe', N'تذكرنى')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (21, 2, N'ForgetPasswordWithQuestion', N'FORGET PASSWORD?')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (22, 1, N'ForgetPasswordWithQuestion', N'هل نسيت كلمة المرور؟')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (23, 2, N'WelcomeBack', N'Welcome Back!')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (24, 1, N'WelcomeBack', N'مرحبا بعودتك!')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (25, 2, N'SignInToContinue', N'Sign-in to continue to name')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (26, 1, N'SignInToContinue', N'قم بتسجيل الدخول لمتابعة الاسم')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (27, 2, N'CreateAccount', N'Create Account')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (28, 1, N'CreateAccount', N'إصنع حساب')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (29, 2, N'TermsOfUse', N'Terms of Use')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (30, 1, N'TermsOfUse', N'تعليمات الاستخدام')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (31, 2, N'ForgetPassword', N'Forget Password')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (32, 1, N'ForgetPassword', N'نسيت كلمة المرور')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (33, 2, N'ForgetPasswordParagraph', N'You can request a new password through entering your email address and a code will be sent to you.')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (34, 1, N'ForgetPasswordParagraph', N'يمكنك طلب كلمة مرور جديدة من خلال إدخال عنوان بريدك الإلكتروني وسيتم إرسال رمز إليك')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (35, 2, N'RecoverPassword', N'RECOVER PASSWORD')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (36, 1, N'RecoverPassword', N'إستعادة كلمة المرور')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (37, 2, N'Hello', N'Hello!')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (38, 1, N'Hello', N'!مرحبا!')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (39, 2, N'RecentMerchants', N'Recent Merchants')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (40, 1, N'RecentMerchants', N'التجار الجدد')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (41, 2, N'ViewAll', N'View All')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (42, 1, N'ViewAll', N'مشاهدة الكل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (43, 2, N'LatestOffers', N'Latest Offers')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (44, 1, N'LatestOffers', N'آخر العروض')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (45, 2, N'Categories', N'Categories')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (46, 1, N'Categories', N'التصنيفات')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (47, 2, N'Restaurants', N'Restaurants')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (48, 1, N'Restaurants', N'مطاعم')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (49, 2, N'ResturantOffers', N'Resturant Offers')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (50, 1, N'ResturantOffers', N'عروض المطعم')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (51, 2, N'MyWallet', N'My Wallet')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (52, 1, N'MyWallet', N'محفظتي')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (53, 2, N'ScanQRCode', N'Scan QR Code')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (54, 1, N'ScanQRCode', N'مسح رمز الاستجابة السريعة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (55, 2, N'Nearby', N'Nearby')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (56, 1, N'Nearby', N'مجاور')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (57, 2, N'Points', N'Points')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (58, 1, N'Points', N'نقاط')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (59, 2, N'MyProfile', N'My Profile')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (60, 1, N'MyProfile', N'ملفي')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (61, 2, N'Language', N'Language')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (62, 1, N'Language', N'لغة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (63, 2, N'ChangePassword', N'Change Password')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (64, 1, N'ChangePassword', N'غير كلمة السر')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (65, 2, N'UpdatePassword', N'UPDATE PASSWORD')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (66, 1, N'UpdatePassword', N'تطوير كلمة السر')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (67, 2, N'YourCurrentLocation', N'Your Current Location')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (68, 1, N'YourCurrentLocation', N'موقعك الحالي')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (69, 2, N'Notification', N'Notification')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (70, 1, N'Notification', N'تنبيه')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (71, 2, N'AboutBasketo', N'About Basketo')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (72, 1, N'AboutBasketo', N'حول باسكتو')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (73, 2, N'HowItWorks', N'How it works')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (74, 1, N'HowItWorks', N'كيف تعمل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (75, 2, N'ContactUs', N'Contact Us')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (76, 1, N'ContactUs', N'اتصل بنا')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (77, 2, N'Send', N'SEND')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (78, 1, N'Send', N'إرسال')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (79, 2, N'Admin', N'Admin')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (80, 1, N'Admin', N'مشرف')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (81, 2, N'ScanQROfTheUser', N'Scan QR of the user?')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (82, 1, N'ScanQROfTheUser', N'للمستخدم؟ QR مسح 
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (83, 2, N'Amount', N'Amount')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (84, 1, N'Amount', N'كمية')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (85, 2, N'Received', N'Received')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (86, 1, N'Received', N'تم الاستلام')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (88, 2, N'SentPoints', N'Sent Points')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (89, 1, N'SentPoints', N'النقاط المرسلة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (90, 2, N'ReceivedPoints', N'Received Points')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (91, 1, N'ReceivedPoints', N'النقاط المستلمة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (92, 2, N'NetPoints', N'Net Points')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (93, 1, N'NetPoints', N'صافي النقاط')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (94, 2, N'ExpiryDateAdminAccount', N'Expiry Date Admin Account')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (95, 1, N'ExpiryDateAdminAccount', N'حساب المسؤول تاريخ انتهاء الصلاحية')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (96, 2, N'More', N'More')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (97, 1, N'More', N'أكثر')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (98, 2, N'Back', N'Back')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (99, 1, N'Back', N'عودة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (100, 2, N'Edit', N'Edit')
GO
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (101, 1, N'Edit', N'تعديل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (102, 2, N'Change', N'Change')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (103, 1, N'Change', N'يتغيرون')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (104, 2, N'FirstName', N'First Name')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (105, 1, N'FirstName', N'الاسم الاول')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (106, 1, N'PhoneNumber', N'رقم الهاتف')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (107, 2, N'PhoneNumber', N'Phone Number')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (108, 2, N'EmailAddress', N'Email Address')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (109, 1, N'EmailAddress', N'عنوان بريد الكتروني')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (110, 2, N'Country', N'Country')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (111, 1, N'Country', N'بلد')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (112, 2, N'City', N'City')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (113, 1, N'City', N'مدينة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (114, 2, N'RegistrationDate', N'Registration Date')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (115, 1, N'RegistrationDate', N'تاريخ التسجيل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (116, 2, N'Password', N'Password')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (117, 1, N'Password', N'كلمه السر')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (118, 2, N'UserName', N'User Name')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (119, 1, N'UserName', N'اسم المستخدم')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (120, 2, N'SelectCountry', N'Select a Country')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (121, 1, N'SelectCountry', N'اختر دولة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (122, 2, N'SelectCity', N'Select a City')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (123, 1, N'SelectCity', N'اختر مدينة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (124, 1, N'CurrentPassword', N'كلمة المرور الحالية')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (125, 2, N'CurrentPassword', N'Current Password')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (126, 2, N'NewPassword', N'New Password')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (127, 1, N'NewPassword', N'كلمة سر جديدة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (128, 2, N'ConfirmPassword', N'Confirm Password')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (129, 1, N'ConfirmPassword', N'تأكيد كلمة المرور')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (130, 2, N'Text', N'Text')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (131, 1, N'Text', N'نص')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (132, 2, N'GoBronze', N'Go Bronze')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (133, 1, N'GoBronze', N'اذهب البرونزية')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (134, 2, N'Earn', N'Earn 1.000 points and become Silver')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (135, 1, N'Earn', N'اكسب 1.000 نقطة وتصبح فضية')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (136, 2, N'Update', N'Update')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (137, 1, N'Update', N'تحديث')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (138, 2, N'Search', N'Search')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (139, 1, N'Search', N'بحث')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (140, 2, N'Bronze', N'Bronze')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (141, 1, N'Bronze', N'برونزية')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (142, 2, N'Silver', N'Silver')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (143, 1, N'Silver', N'فضة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (144, 1, N'Gold', N'ذهب')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (145, 2, N'Gold', N'Gold')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (146, 2, N'Enter', N'Enter')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (147, 1, N'Enter', N'أدخل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (148, 2, N'PrivacyPolicy', N'Privacy Policy')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (149, 1, N'PrivacyPolicy', N'سياسة خاصة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (150, 1, N'Address', N'عنوان')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (151, 2, N'Address', N'Address')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (152, 2, N'Info', N'Info')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (153, 1, N'Info', N'معلومات')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (154, 2, N'HoursInformation', N'Hours Information')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (155, 1, N'HoursInformation', N'معلومات الساعات')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (156, 2, N'Discount', N'Discount')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (157, 1, N'Discount', N'خصم')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (158, 2, N'TimingNotAvailable', N'Timing is not available')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (159, 1, N'TimingNotAvailable', N'التوقيت غير متوفر')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (160, 2, N'View', N'View')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (161, 1, N'View', N'رأي')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (162, 2, N'BronzePoints', N'50 to 100')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (163, 1, N'BronzePoints', N'من 50 إلى 100')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (164, 2, N'SilverPoints', N'101 to 500')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (165, 1, N'SilverPoints', N'101 إلى 500')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (166, 2, N'GoldPoints', N'501 and above')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (167, 1, N'GoldPoints', N'501 وما فوق')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (168, 2, N'Directions', N'Directions')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (169, 1, N'Directions', N'الاتجاهات')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (171, 2, N'PrivacyPolicyText', N'Do you accept our Privacy Policy ?')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (172, 1, N'PrivacyPolicyText', N'هل تقبل سياسة الخصوصية الخاصة بنا ؟')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (173, 2, N'TermsOfUseText', N'Do you accept our Terms and conditions ?')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (174, 1, N'TermsOfUseText', N'هل تقبل الشروط والأحكام الخاصة بنا؟')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (175, 2, N'YourMessage', N'Your Message')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (176, 1, N'YourMessage', N'رسالتك')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (177, 2, N'Next', N'Next')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (178, 1, N'Next', N'التالى')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (179, 2, N'NextText1', N'Earn points every time you make a purchase from one of our stores')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (180, 1, N'NextText1', N'اكسب نقاطًا في كل مرة تقوم فيها بالشراء من أحد متاجرنا')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (181, 2, N'NextText2', N'Once you collect lots of points, you will be able to use them for purchases')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (182, 1, N'NextText2', N'بمجرد جمع الكثير من النقاط ، ستتمكن من استخدامها في عمليات الشراء')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (183, 2, N'NextText3', N'Gain points and enter our unlimited special offers of big surprising gifts')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (184, 1, N'NextText3', N'احصل على نقاط وادخل عروضنا الخاصة غير المحدودة من الهدايا الكبيرة المفاجئة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (185, 2, N'EmailExistMessage', N'Email already exists')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (186, 1, N'EmailExistMessage', N'البريد الالكتروني موجود بالفعل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (191, 2, N'FailedReq', N'Something went wrong please try again later')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (192, 1, N'FailedReq', N'هناك شئ خاطئ، يرجى المحاولة فى وقت لاحق')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (193, 2, N'FullNameUpdateMessage', N'Full Name Updated')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (194, 1, N'FullNameUpdateMessage', N'تم تحديث الاسم بالكامل')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (195, 2, N'PhoneNoUpdateMessage', N'Phone Number Updated')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (196, 1, N'PhoneNoUpdateMessage', N'تم تحديث رقم الهاتف')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (197, 2, N'EmailUpdateMessage', N'Email Updated')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (198, 1, N'EmailUpdateMessage', N'تم تحديث البريد الإلكتروني')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (199, 2, N'CountryUpdateMessage', N'Country Updated')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (200, 1, N'CountryUpdateMessage', N'تم تحديث البلد')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (201, 2, N'CityUpdateMessage', N'City Updated')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (202, 1, N'CityUpdateMessage', N'تم تحديث المدينة')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (203, 2, N'ProfilePhotoMessage', N'Profile photo update')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (204, 1, N'ProfilePhotoMessage', N'تحديث صورة الملف الشخصي')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (207, 3, N'About', N'Sayfayla ilgili bazı açıklamalar')
GO
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (208, 3, N'Contact', N'İletişim')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (209, 3, N'Language', N'
Dil')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (210, 3, N'FoodDiscount', N'
Yiyecek İndirimleri')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (211, 3, N'FoodDiscountParagraph', N'Restoran ve kafeleri ziyaret ettiğinizde indirim kazanın')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (212, 3, N'ShoppingDiscounts', N'
Alışveriş İndirimleri')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (213, 3, N'ShoppingDiscountsParagraph', N'Çevrimiçi ve çevrimdışı satın aldığınız mağazalardan indirim kazanın')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (214, 3, N'SignUp', N'KAYDOL')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (215, 3, N'SignIn', N'OTURUM AÇ')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (216, 3, N'RememberMe', N'Beni Hatırla')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (217, 3, N'ForgetPasswordWithQuestion', N'
ŞİFREYİ UNUT?')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (218, 3, N'WelcomeBack', N'
Tekrar hoşgeldiniz!')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (219, 3, N'SignInToContinue', N'Ad vermeye devam etmek için oturum açın')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (221, 3, N'CreateAccount', N'Hesap oluştur')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (222, 3, N'TermsOfUse', N'Kullanım Şartları')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (223, 3, N'ForgetPassword', N'
Şifreyi unut')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (224, 3, N'ForgetPasswordParagraph', N'
E-posta adresinizi girerek yeni bir şifre talep edebilirsiniz ve size bir kod gönderilecektir.')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (225, 3, N'RecoverPassword', N'
ŞİFRE KURTARMA')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (226, 3, N'Hello', N'Merhaba!')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (228, 3, N'RecentMerchants', N'
Son Satıcılar')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (229, 3, N'ViewAll', N'Hepsini gör
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (230, 3, N'LatestOffers', N'
Son Teklifler')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (231, 3, N'Categories', N'Kategoriler')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (232, 3, N'Restaurants', N'Restoranlar')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (233, 3, N'ResturantOffers', N'Restoran Teklifleri
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (234, 3, N'MyWallet', N'Cüzdanım')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (235, 3, N'ScanQRCode', N'QR Kodunu Tara')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (236, 3, N'Nearby', N'Yakın')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (237, 3, N'Points', N'Puanlar')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (238, 3, N'MyProfile', N'Benim profilim')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (239, 3, N'ChangePassword', N'Şifre değiştir')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (240, 3, N'UpdatePassword', N'Şifre güncelle')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (241, 3, N'YourCurrentLocation', N'Şu anki konumunuz')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (242, 3, N'Notification', N'Bildirim')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (243, 3, N'AboutBasketo', N'
Basketo hakkında')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (244, 3, N'HowItWorks', N'
Nasıl çalışır')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (245, 3, N'ContactUs', N'
Bize Ulaşın')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (246, 3, N'Send', N'Gönder')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (247, 3, N'Admin', N'Yönetici')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (248, 3, N'ScanQROfTheUser', N'Kullanıcının QR''si taransın mı?')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (249, 3, N'Amount', N'Miktar')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (250, 3, N'Received', N'Alınan')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (251, 3, N'SentPoints', N'Gönderilen Puanlar
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (253, 3, N'ReceivedPoints', N'Alınan Puanlar')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (254, 3, N'NetPoints', N'Net Puan')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (255, 3, N'ExpiryDateAdminAccount', N'Son Kullanma Tarihi Yönetici Hesabı')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (256, 3, N'More', N'Daha')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (257, 3, N'Back', N'Geri')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (258, 3, N'Edit', N'Düzenle')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (259, 3, N'Change', N'Değişiklik')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (260, 3, N'FirstName', N'İsim')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (261, 3, N'PhoneNumber', N'Telefon numarası')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (263, 3, N'EmailAddress', N'E')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (264, 3, N'Country', N'Ülke')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (265, 3, N'City', N'Kent')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (266, 3, N'RegistrationDate', N'Kayıt Tarihi')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (268, 3, N'Password', N'Parola')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (269, 3, N'UserName', N'Kullanıcı adı')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (270, 3, N'SelectCountry', N'Bir ülke seçin')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (271, 3, N'SelectCity', N'Bir Şehir Seçin')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (272, 3, N'CurrentPassword', N'Şimdiki Şifre
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (273, 3, N'NewPassword', N'Yeni Şifre
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (274, 3, N'ConfirmPassword', N'Şifreyi Onayla')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (275, 3, N'Text', N'Metin')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (276, 3, N'GoBronze', N'Bronz git')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (277, 3, N'Earn', N'1.000 puan kazanın ve Gümüş olun')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (278, 3, N'Update', N'Güncelleme')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (279, 3, N'Search', N'Arama')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (280, 3, N'Bronze', N'Bronz')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (281, 3, N'Silver', N'Gümüş')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (282, 3, N'Gold', N'Altın')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (283, 3, N'Enter', N'Giriş')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (284, 3, N'PrivacyPolicy', N'Gizlilik Politikası')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (286, 3, N'Address', N'Adres')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (287, 3, N'Info', N'Bilgi')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (288, 3, N'HoursInformation', N'
Saat Bilgileri')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (289, 3, N'Discount', N'İndirim')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (290, 3, N'TimingNotAvailable', N'Zamanlama mevcut değil')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (291, 3, N'View', N'Görünüm')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (292, 3, N'BronzePoints', N'50 - 100')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (293, 3, N'SilverPoints', N'101 - 500
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (294, 3, N'GoldPoints', N'501 ve üstü')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (295, 3, N'Directions', N'Talimatlar')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (296, 3, N'PrivacyPolicyText', N'Gizlilik Politikamızı kabul ediyor musunuz?')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (298, 3, N'TermsOfUseText', N'
Hüküm ve koşullarımızı kabul ediyor musunuz?')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (299, 3, N'YourMessage', N'Mesajın')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (300, 3, N'Next', N'Sonraki')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (301, 3, N'NextText1', N'Mağazalarımızdan her alışveriş yaptığınızda puan kazanın')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (302, 3, N'NextText2', N'Çok fazla puan topladığınızda, bunları satın alımlar için kullanabileceksiniz.')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (303, 3, N'NextText3', N'
Puan kazanın ve sınırsız özel büyük sürpriz hediyelerimize katılın')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (304, 3, N'EmailExistMessage', N'Bu e-posta zaten var
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (305, 3, N'FailedReq', N'Bir şeyler yanlış oldu. Lütfen sonra tekrar deneyiniz')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (306, 3, N'FullNameUpdateMessage', N'Tam Ad Güncellendi
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (307, 3, N'PhoneNoUpdateMessage', N'
Telefon Numarası Güncellendi')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (308, 3, N'EmailUpdateMessage', N'E-posta Güncellendi
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (309, 3, N'CountryUpdateMessage', N'Ülke Güncellendi')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (310, 3, N'CityUpdateMessage', N'Şehir Güncellendi
')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (311, 3, N'ProfilePhotoMessage', N'Profil fotoğrafı güncellemesi')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (312, 2, N'NoNotifications', N'No Notifications Found')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (313, 1, N'NoNotifications', N'لم يتم العثور على إخطارات')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (314, 3, N'NoNotifications', N'Bildirim Bulunamadı')
GO
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (315, 1, N'Save', N'حفظ')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (316, 2, N'Save', N'Save')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (317, 3, N'Save', N'kayıt etmek')
INSERT [dbo].[Resources] ([ResourceID], [LanguageID], [ResourceKey], [ResourceValue]) VALUES (318, 2, N'Bookaguide', N'BOOK A GUIDE')
SET IDENTITY_INSERT [dbo].[Resources] OFF
GO
INSERT [dbo].[Rights] ([RightID], [RightName], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (1, N'Add', 1, CAST(N'2020-11-28T02:21:38.000' AS DateTime), 1, CAST(N'2020-11-28T02:21:38.000' AS DateTime), 1)
INSERT [dbo].[Rights] ([RightID], [RightName], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (2, N'Update', 1, CAST(N'2020-11-28T02:20:54.000' AS DateTime), 1, CAST(N'2020-11-28T02:21:01.000' AS DateTime), NULL)
INSERT [dbo].[Rights] ([RightID], [RightName], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (3, N'Delete', 1, CAST(N'2020-11-28T02:21:02.000' AS DateTime), 1, CAST(N'2020-11-28T02:21:08.000' AS DateTime), NULL)
INSERT [dbo].[Rights] ([RightID], [RightName], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (4, N'View-Self', 1, CAST(N'2020-11-28T02:21:10.000' AS DateTime), 1, CAST(N'2020-11-28T02:21:19.000' AS DateTime), NULL)
INSERT [dbo].[Rights] ([RightID], [RightName], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (5, N'View-All', 1, CAST(N'2020-11-28T02:21:20.000' AS DateTime), 1, CAST(N'2020-11-28T02:21:26.000' AS DateTime), NULL)
GO
SET IDENTITY_INSERT [dbo].[RoleRights] ON 

INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (727, 1, 1, 23, CAST(N'2022-04-20T05:25:35.763' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.763' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (728, 1, 1, 24, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (729, 1, 1, 13, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (730, 1, 1, 34, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (731, 1, 1, 16, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (732, 1, 1, 37, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.767' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (733, 1, 1, 3, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (734, 1, 1, 2, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (735, 1, 1, 6, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (736, 1, 1, 22, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (737, 1, 1, 7, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (738, 1, 1, 8, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (739, 1, 1, 1, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (740, 1, 1, 14, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (741, 1, 1, 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (742, 1, 1, 10, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (743, 1, 1, 9, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.770' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (744, 1, 1, 30, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (745, 1, 1, 31, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (746, 1, 1, 12, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (747, 1, 1, 11, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (748, 1, 1, 38, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (749, 1, 1, 35, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (750, 1, 3, 23, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (751, 1, 3, 24, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (752, 1, 3, 13, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (753, 1, 3, 34, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (754, 1, 3, 16, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.773' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (755, 1, 3, 37, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (756, 1, 3, 3, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (757, 1, 3, 2, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (758, 1, 3, 6, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (759, 1, 3, 22, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (760, 1, 3, 7, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (761, 1, 3, 8, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (762, 1, 3, 1, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.777' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (763, 1, 3, 14, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (764, 1, 3, 5, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (765, 1, 3, 10, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (766, 1, 3, 9, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (767, 1, 3, 30, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (768, 1, 3, 31, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.800' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (769, 1, 3, 12, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (770, 1, 3, 11, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (771, 1, 3, 38, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (772, 1, 3, 35, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (773, 1, 2, 23, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (774, 1, 2, 24, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (775, 1, 2, 13, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (776, 1, 2, 34, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (777, 1, 2, 16, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (778, 1, 2, 37, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (779, 1, 2, 3, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.803' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (780, 1, 2, 2, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (781, 1, 2, 6, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (782, 1, 2, 22, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (783, 1, 2, 7, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (784, 1, 2, 8, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (785, 1, 2, 1, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (786, 1, 2, 14, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (787, 1, 2, 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (788, 1, 2, 10, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (789, 1, 2, 9, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (790, 1, 2, 30, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (791, 1, 2, 31, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (792, 1, 2, 12, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.807' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (793, 1, 2, 11, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (794, 1, 2, 38, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (795, 1, 2, 35, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (796, 1, 5, 23, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (797, 1, 5, 24, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (798, 1, 5, 13, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (799, 1, 5, 34, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (800, 1, 5, 16, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (801, 1, 5, 37, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (802, 1, 5, 3, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (803, 1, 5, 2, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (804, 1, 5, 6, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (805, 1, 5, 22, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (806, 1, 5, 7, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.810' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (807, 1, 5, 8, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (808, 1, 5, 1, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (809, 1, 5, 14, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (810, 1, 5, 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (811, 1, 5, 10, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (812, 1, 5, 9, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (813, 1, 5, 30, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (814, 1, 5, 31, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (815, 1, 5, 12, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (816, 1, 5, 11, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (817, 1, 5, 38, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (818, 1, 5, 35, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (819, 1, 4, 23, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (820, 1, 4, 24, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.813' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (821, 1, 4, 13, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (822, 1, 4, 34, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (823, 1, 4, 16, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (824, 1, 4, 37, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (825, 1, 4, 3, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
GO
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (826, 1, 4, 2, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (827, 1, 4, 6, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (828, 1, 4, 22, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (829, 1, 4, 7, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (830, 1, 4, 8, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (831, 1, 4, 1, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (832, 1, 4, 14, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.817' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (833, 1, 4, 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (834, 1, 4, 10, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (835, 1, 4, 9, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (836, 1, 4, 30, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (837, 1, 4, 31, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (838, 1, 4, 12, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (839, 1, 4, 11, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (840, 1, 4, 38, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (841, 1, 4, 35, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5, CAST(N'2022-04-20T05:25:35.820' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (842, 1, 1, 39, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (843, 1, 2, 39, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (844, 1, 3, 39, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (845, 1, 4, 39, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (846, 1, 5, 39, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5, CAST(N'2022-04-20T05:57:04.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (847, 1, 1, 40, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (848, 1, 2, 40, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (849, 1, 3, 40, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (850, 1, 4, 40, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (851, 1, 5, 40, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:12.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (852, 1, 1, 41, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (853, 1, 2, 41, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (854, 1, 3, 41, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (855, 1, 4, 41, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (856, 1, 5, 41, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5, CAST(N'2022-04-20T06:53:58.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (857, 1, 1, 42, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (858, 1, 2, 42, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (859, 1, 3, 42, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (860, 1, 4, 42, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (861, 1, 5, 42, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5, CAST(N'2022-04-20T06:55:25.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (862, 1, 1, 43, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (863, 1, 2, 43, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (864, 1, 3, 43, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (865, 1, 4, 43, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (866, 1, 5, 43, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:00.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (867, 1, 1, 44, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (868, 1, 2, 44, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (869, 1, 3, 44, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (870, 1, 4, 44, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (871, 1, 5, 44, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5, CAST(N'2022-04-20T08:59:59.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (872, 1, 1, 45, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (873, 1, 2, 45, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (874, 1, 3, 45, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (875, 1, 4, 45, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (876, 1, 5, 45, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5, CAST(N'2022-04-20T09:01:09.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (877, 1, 1, 46, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (878, 1, 2, 46, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (879, 1, 3, 46, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (880, 1, 4, 46, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (881, 1, 5, 46, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5, CAST(N'2022-04-20T09:17:32.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (948, 1, 1, 47, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (949, 1, 2, 47, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (950, 1, 3, 47, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (951, 1, 4, 47, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (952, 1, 5, 47, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5, CAST(N'2022-04-21T11:13:39.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (953, 1, 1, 48, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (954, 1, 2, 48, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (955, 1, 3, 48, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (956, 1, 4, 48, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (957, 1, 5, 48, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5, CAST(N'2022-04-21T11:23:07.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (958, 1, 1, 49, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (959, 1, 2, 49, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (960, 1, 3, 49, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (961, 1, 4, 49, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (962, 1, 5, 49, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5, CAST(N'2022-04-21T11:32:52.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (963, 2, 1, 37, CAST(N'2022-04-21T23:50:05.977' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.037' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (964, 2, 2, 37, CAST(N'2022-04-21T23:50:06.050' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.050' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (965, 2, 1, 43, CAST(N'2022-04-21T23:50:06.050' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.050' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (966, 2, 2, 43, CAST(N'2022-04-21T23:50:06.050' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.050' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (967, 2, 3, 43, CAST(N'2022-04-21T23:50:06.053' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.053' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (968, 2, 4, 43, CAST(N'2022-04-21T23:50:06.053' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.053' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (969, 2, 5, 43, CAST(N'2022-04-21T23:50:06.053' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.053' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (970, 2, 1, 44, CAST(N'2022-04-21T23:50:06.053' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.053' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (971, 2, 2, 44, CAST(N'2022-04-21T23:50:06.057' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.057' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (972, 2, 3, 44, CAST(N'2022-04-21T23:50:06.057' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.057' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (973, 2, 4, 44, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (974, 2, 5, 44, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (975, 2, 1, 47, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (976, 2, 3, 47, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (977, 2, 2, 47, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5, CAST(N'2022-04-21T23:50:06.060' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (978, 1, 1, 50, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (979, 1, 2, 50, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (980, 1, 3, 50, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (981, 1, 4, 50, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (982, 1, 5, 50, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5, CAST(N'2022-06-05T06:56:11.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (983, 1, 1, 51, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (984, 1, 2, 51, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (985, 1, 3, 51, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (986, 1, 4, 51, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (987, 1, 5, 51, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5, CAST(N'2022-06-05T07:00:33.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (988, 1, 1, 52, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (989, 1, 2, 52, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (990, 1, 3, 52, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (991, 1, 4, 52, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5)
GO
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (992, 1, 5, 52, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5, CAST(N'2022-06-05T07:01:58.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (993, 1, 1, 53, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (994, 1, 2, 53, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (995, 1, 3, 53, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (996, 1, 4, 53, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5)
INSERT [dbo].[RoleRights] ([RoleRightID], [RoleID], [RightID], [EntityID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (997, 1, 5, 53, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5, CAST(N'2022-06-12T11:49:46.000' AS DateTime), 5)
SET IDENTITY_INSERT [dbo].[RoleRights] OFF
GO
INSERT [dbo].[Roles] ([RoleID], [RoleName], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (1, N'Admin', 1, CAST(N'2020-12-03T19:55:35.000' AS DateTime), 1, CAST(N'2022-04-10T18:28:44.000' AS DateTime), 5)
INSERT [dbo].[Roles] ([RoleID], [RoleName], [IsActive], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (2, N'Vendor', 1, CAST(N'2020-12-02T03:08:43.000' AS DateTime), 1, CAST(N'2020-12-02T15:08:51.000' AS DateTime), NULL)
GO
INSERT [dbo].[Statuses] ([StatusID], [NameEn], [NameAr], [IsActive]) VALUES (1, N'Active', N'نشيط', 1)
INSERT [dbo].[Statuses] ([StatusID], [NameEn], [NameAr], [IsActive]) VALUES (2, N'Disabled', N'معاق', 1)
INSERT [dbo].[Statuses] ([StatusID], [NameEn], [NameAr], [IsActive]) VALUES (3, N'Terminated', N'تم إنهاؤه', 1)
GO
SET IDENTITY_INSERT [dbo].[UserRoles] ON 

INSERT [dbo].[UserRoles] ([UserRoleID], [UserID], [RoleID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (1, 3, 2, NULL, NULL, NULL, NULL)
INSERT [dbo].[UserRoles] ([UserRoleID], [UserID], [RoleID], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy]) VALUES (2, 5, 1, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[UserRoles] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([UserID], [FullName], [EmailAddress], [Password], [PhoneNo], [CountryID], [CityID], [ProfileUrl], [VerificationCode], [IsVerified], [StatusID], [IsTermOfUseAccepted], [IsPrivacyPolicyAccepted], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [BillingAddress], [ShippingAddress]) VALUES (3, N'Aisha', N'Aisha@gmail.com', N'dPH2Eo3qPHI=', N'+1215337299', NULL, NULL, N'http://localhost:19100/Uploads/104b8903-6376-4764-b8a6-71f06e1f31df.jpg', NULL, 1, 1, 1, 1, CAST(N'2022-04-19T08:42:15.000' AS DateTime), 3, CAST(N'2022-04-19T08:42:15.000' AS DateTime), 3, NULL, NULL)
INSERT [dbo].[Users] ([UserID], [FullName], [EmailAddress], [Password], [PhoneNo], [CountryID], [CityID], [ProfileUrl], [VerificationCode], [IsVerified], [StatusID], [IsTermOfUseAccepted], [IsPrivacyPolicyAccepted], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [BillingAddress], [ShippingAddress]) VALUES (5, N'Admin', N'admin@gmail.com', N'dPH2Eo3qPHI=', N'+964 (0) 783 000 3322', NULL, NULL, NULL, NULL, 1, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Users] ([UserID], [FullName], [EmailAddress], [Password], [PhoneNo], [CountryID], [CityID], [ProfileUrl], [VerificationCode], [IsVerified], [StatusID], [IsTermOfUseAccepted], [IsPrivacyPolicyAccepted], [CreatedOn], [CreatedBy], [ModifiedOn], [ModifiedBy], [BillingAddress], [ShippingAddress]) VALUES (7, N'Iman', N'iman@gmail.com', N'YVUlNtj9DUU=', N'+1215337299', NULL, NULL, NULL, NULL, 1, 1, 1, 1, NULL, NULL, NULL, NULL, N'Jamshed road no 1', N'Jamshed road no 1')
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
SET IDENTITY_INSERT [dbo].[Vendors] ON 

INSERT [dbo].[Vendors] ([VendorID], [Name], [Contact], [Email], [City], [Area], [Street], [HouseNo], [Notes], [CityID]) VALUES (1, N'Aisha', CAST(12153372 AS Numeric(18, 0)), N'Aisha@gmail.com', N'NewYork', N'Area1', N'street 40', N'House no 1', NULL, 8)
SET IDENTITY_INSERT [dbo].[Vendors] OFF
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [UQ__Resource__3B5BC9BE1A1E0FA6]    Script Date: 17/06/2022 7:03:54 am ******/
ALTER TABLE [dbo].[ResourceLocalizations] ADD UNIQUE NONCLUSTERED 
(
	[ResourceKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Blogs] ADD  CONSTRAINT [DF_Table_1_IsDeleted1]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Categories] ADD  CONSTRAINT [DF_Categories_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Categories] ADD  CONSTRAINT [DF_Categories_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Cities] ADD  CONSTRAINT [DF_Cities_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Cities] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Countries] ADD  CONSTRAINT [DF_Countries_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Currencies] ADD  CONSTRAINT [DF_Currencies_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[DynamicSetupScreens] ADD  CONSTRAINT [DF_DynamicSetupScreens_DS_AllowApprovals]  DEFAULT ((1)) FOR [DS_AllowApprovals]
GO
ALTER TABLE [dbo].[Entities] ADD  CONSTRAINT [DF__Entities__DataVe__0F975522]  DEFAULT ((0)) FOR [DataVersion]
GO
ALTER TABLE [dbo].[EntityDetails] ADD  CONSTRAINT [DF_EntityDetails_IsFileUpload]  DEFAULT ((0)) FOR [IsFileUpload]
GO
ALTER TABLE [dbo].[EntityDetails] ADD  CONSTRAINT [DF_EntityDetails_ShowGroupTitle]  DEFAULT ((0)) FOR [ShowGroupTitle]
GO
ALTER TABLE [dbo].[Languages] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[MenuNavigations] ADD  CONSTRAINT [DF_Menus_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[ProductCategories] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[ProductImages] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [Stock]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [TotalQuantity]
GO
ALTER TABLE [dbo].[Products] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Statuses] ADD  CONSTRAINT [DF_Statuses_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsTermOfUseAccepted]  DEFAULT ((1)) FOR [IsTermOfUseAccepted]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsPrivacyPolicyAccepted]  DEFAULT ((1)) FOR [IsPrivacyPolicyAccepted]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_CreatedOn]  DEFAULT (getdate()) FOR [CreatedOn]
GO
ALTER TABLE [dbo].[Variants] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [dbo].[Cities]  WITH CHECK ADD FOREIGN KEY([CountryID])
REFERENCES [dbo].[Countries] ([CountryID])
GO
ALTER TABLE [dbo].[DeviceRegistrations]  WITH CHECK ADD  CONSTRAINT [FK_DeviceRegistrations_DeviceTypes] FOREIGN KEY([DeviceTypeID])
REFERENCES [dbo].[DeviceTypes] ([DeviceID])
GO
ALTER TABLE [dbo].[DeviceRegistrations] CHECK CONSTRAINT [FK_DeviceRegistrations_DeviceTypes]
GO
ALTER TABLE [dbo].[EntityDetails]  WITH CHECK ADD  CONSTRAINT [FK_EntityDetails_EntityDetails] FOREIGN KEY([EntityID])
REFERENCES [dbo].[Entities] ([EntityID])
GO
ALTER TABLE [dbo].[EntityDetails] CHECK CONSTRAINT [FK_EntityDetails_EntityDetails]
GO
ALTER TABLE [dbo].[EntityDetails]  WITH CHECK ADD  CONSTRAINT [FK_EntityDetails_EntityDetails1] FOREIGN KEY([ParentSubGroupID])
REFERENCES [dbo].[EntityDetails] ([EntityDetailsID])
GO
ALTER TABLE [dbo].[EntityDetails] CHECK CONSTRAINT [FK_EntityDetails_EntityDetails1]
GO
ALTER TABLE [dbo].[MenuNavigations]  WITH CHECK ADD  CONSTRAINT [FK__MenuNavig__Entit__7E37BEF6] FOREIGN KEY([EntityID])
REFERENCES [dbo].[Entities] ([EntityID])
GO
ALTER TABLE [dbo].[MenuNavigations] CHECK CONSTRAINT [FK__MenuNavig__Entit__7E37BEF6]
GO
ALTER TABLE [dbo].[MenuNavigations]  WITH CHECK ADD  CONSTRAINT [FK_MenuNavigations_MenuNavigations] FOREIGN KEY([ParentMenuNavigationID])
REFERENCES [dbo].[MenuNavigations] ([MenuNavigationID])
GO
ALTER TABLE [dbo].[MenuNavigations] CHECK CONSTRAINT [FK_MenuNavigations_MenuNavigations]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Currencies] FOREIGN KEY([CurrencyID])
REFERENCES [dbo].[Currencies] ([CurrencyID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Currencies]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders] FOREIGN KEY([OrderID])
REFERENCES [dbo].[Orders] ([OrderID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Orders]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Products] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Products]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Vendors] FOREIGN KEY([VendorID])
REFERENCES [dbo].[Vendors] ([VendorID])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Vendors]
GO
ALTER TABLE [dbo].[ProductCategories]  WITH CHECK ADD FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Categories] ([CategoryID])
GO
ALTER TABLE [dbo].[ProductCategories]  WITH CHECK ADD FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[ProductImages]  WITH CHECK ADD FOREIGN KEY([ProductID])
REFERENCES [dbo].[Products] ([ProductID])
GO
ALTER TABLE [dbo].[RoleRights]  WITH CHECK ADD  CONSTRAINT [FK_RoleRights_Rights] FOREIGN KEY([RightID])
REFERENCES [dbo].[Rights] ([RightID])
GO
ALTER TABLE [dbo].[RoleRights] CHECK CONSTRAINT [FK_RoleRights_Rights]
GO
ALTER TABLE [dbo].[RoleRights]  WITH CHECK ADD  CONSTRAINT [FK_RoleRights_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[RoleRights] CHECK CONSTRAINT [FK_RoleRights_Roles]
GO
ALTER TABLE [dbo].[UserRoles]  WITH CHECK ADD  CONSTRAINT [FK_UserRoles_Roles] FOREIGN KEY([RoleID])
REFERENCES [dbo].[Roles] ([RoleID])
GO
ALTER TABLE [dbo].[UserRoles] CHECK CONSTRAINT [FK_UserRoles_Roles]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Cities] FOREIGN KEY([CityID])
REFERENCES [dbo].[Cities] ([CityID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Cities]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Countries] FOREIGN KEY([CountryID])
REFERENCES [dbo].[Countries] ([CountryID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Countries]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Statuses] FOREIGN KEY([StatusID])
REFERENCES [dbo].[Statuses] ([StatusID])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Statuses]
GO
ALTER TABLE [dbo].[VariantCategories]  WITH CHECK ADD FOREIGN KEY([CategoryID])
REFERENCES [dbo].[Categories] ([CategoryID])
GO
ALTER TABLE [dbo].[VariantCategories]  WITH CHECK ADD FOREIGN KEY([VariantID])
REFERENCES [dbo].[Variants] ([VariantID])
GO
ALTER TABLE [dbo].[Vendors]  WITH CHECK ADD FOREIGN KEY([CityID])
REFERENCES [dbo].[Cities] ([CityID])
GO
/****** Object:  StoredProcedure [dbo].[ChangePassword]    Script Date: 17/06/2022 7:03:54 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[ChangePassword]
(
	@UserID INT,
	@OldPassword NVARCHAR(50),
	@NewPassword NVARCHAR(50)
)
AS
DECLARE @Data NVARCHAR(20) = ''
BEGIN
	DECLARE @IsExist INT = 0
	SET @IsExist = (Select COUNT(0) From Users Where [Password] = @OldPassword AND UserID = @UserID)
	IF @IsExist > 0
		BEGIN
			Update Users Set [Password] = @NewPassword Where UserID = @UserID;
			SET @Data = 'Password Changed';
		END
	ELSE
		BEGIN
			SET @Data = 'Wrong Password';
		END
END
Select @Data Message FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
GO
/****** Object:  StoredProcedure [dbo].[GetLocationTracking]    Script Date: 17/06/2022 7:03:54 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetLocationTracking](@TeamMemberID INT, @TrackedOn NVARCHAR(15))
AS
DECLARE @JsonData NVARCHAR(MAX)
SET @JsonData = (
Select 
	LT.TeamMemberID,
	LT.ActivityID,
	A.ActivityName,
	LT.LatLng,
	LT.TrackedOn
From LocationTracking LT
Inner Join Activities A
ON LT.ActivityID = A.ActivityID
Where LT.TeamMemberID = @TeamMemberID AND CAST(LT.TrackedOn AS DATE) = CAST(@TrackedOn AS DATE)
FOR JSON PATH
)
Select @JsonData Data
GO
/****** Object:  StoredProcedure [dbo].[GetResources]    Script Date: 17/06/2022 7:03:54 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetResources] (@LanguageID INT)
AS
DECLARE @cols NVARCHAR(MAX), @sql NVARCHAR(MAX)
SET @cols = STUFF((SELECT DISTINCT ',' + QUOTENAME(ResourceKey)
            FROM Resources
			Where LanguageID = @LanguageID
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)'),1,1,'')
SET @sql = 'SELECT CAST((SELECT * From (SELECT ' + @cols + '
              FROM
            (
              SELECT ResourceValue, ResourceKey
                FROM Resources Where LanguageID = ' + CAST(@LanguageID AS NVARCHAR(2)) + '
            ) s
            PIVOT
            (
              MAX(ResourceValue) FOR ResourceKey IN (' + @cols + ')
            ) p) X FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) AS NVARCHAR(MAX)) Data'
EXECUTE(@sql)
GO
/****** Object:  StoredProcedure [dbo].[TrackLocation]    Script Date: 17/06/2022 7:03:54 am ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TrackLocation]
(
	@LatLng NVARCHAR(500), 
	@SalespersonID INT, 
	@BatteryPercentage INT,
	@ActivityID INT
)
AS
INSERT INTO LocationTracking(LatLng, TeamMemberID, BatteryPercentage, TrackedOn, ActivityID)
VALUES(@LatLng, (Select Top 1 TeamMemberID From TeamMembers Where SalesPersonID = @SalesPersonID), @BatteryPercentage, GETDATE(), @ActivityID)
Select (Select 'Success' [Message] FOR JSON PATH) AS Data
GO
USE [master]
GO
ALTER DATABASE [BloomingGarden] SET  READ_WRITE 
GO

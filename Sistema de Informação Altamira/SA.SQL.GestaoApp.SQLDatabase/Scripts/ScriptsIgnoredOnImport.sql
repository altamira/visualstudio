
USE [master]
GO
/****** Object:  Database [GestaoApp]    Script Date: 01/17/2012 12:44:38 ******/
CREATE DATABASE [GestaoApp] ON  PRIMARY 
( NAME = N'Gestao', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\GestaoApp.mdf' , SIZE = 199040KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Gestao_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL10_50.MSSQLSERVER\MSSQL\DATA\GestaoApp.ldf' , SIZE = 1129920KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [GestaoApp] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [GestaoApp].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [GestaoApp] SET ANSI_NULL_DEFAULT ON
GO
ALTER DATABASE [GestaoApp] SET ANSI_NULLS ON
GO
ALTER DATABASE [GestaoApp] SET ANSI_PADDING ON
GO
ALTER DATABASE [GestaoApp] SET ANSI_WARNINGS ON
GO
ALTER DATABASE [GestaoApp] SET ARITHABORT ON
GO
ALTER DATABASE [GestaoApp] SET AUTO_CLOSE OFF
GO
ALTER DATABASE [GestaoApp] SET AUTO_CREATE_STATISTICS ON
GO
ALTER DATABASE [GestaoApp] SET AUTO_SHRINK OFF
GO
ALTER DATABASE [GestaoApp] SET AUTO_UPDATE_STATISTICS ON
GO
ALTER DATABASE [GestaoApp] SET CURSOR_CLOSE_ON_COMMIT OFF
GO
ALTER DATABASE [GestaoApp] SET CURSOR_DEFAULT  LOCAL
GO
ALTER DATABASE [GestaoApp] SET CONCAT_NULL_YIELDS_NULL ON
GO
ALTER DATABASE [GestaoApp] SET NUMERIC_ROUNDABORT OFF
GO
ALTER DATABASE [GestaoApp] SET QUOTED_IDENTIFIER ON
GO
ALTER DATABASE [GestaoApp] SET RECURSIVE_TRIGGERS OFF
GO
ALTER DATABASE [GestaoApp] SET  DISABLE_BROKER
GO
ALTER DATABASE [GestaoApp] SET AUTO_UPDATE_STATISTICS_ASYNC OFF
GO
ALTER DATABASE [GestaoApp] SET DATE_CORRELATION_OPTIMIZATION OFF
GO
ALTER DATABASE [GestaoApp] SET TRUSTWORTHY ON
GO
ALTER DATABASE [GestaoApp] SET ALLOW_SNAPSHOT_ISOLATION OFF
GO
ALTER DATABASE [GestaoApp] SET PARAMETERIZATION SIMPLE
GO
ALTER DATABASE [GestaoApp] SET READ_COMMITTED_SNAPSHOT OFF
GO
ALTER DATABASE [GestaoApp] SET HONOR_BROKER_PRIORITY OFF
GO
ALTER DATABASE [GestaoApp] SET  READ_WRITE
GO
ALTER DATABASE [GestaoApp] SET RECOVERY FULL
GO
ALTER DATABASE [GestaoApp] SET  MULTI_USER
GO
ALTER DATABASE [GestaoApp] SET PAGE_VERIFY NONE
GO
ALTER DATABASE [GestaoApp] SET DB_CHAINING OFF
GO
EXEC sys.sp_db_vardecimal_storage_format N'GestaoApp', N'ON'
GO
USE [GestaoApp]
GO
/****** Object:  Table [Attendance].[Status.Group]    Script Date: 01/17/2012 12:44:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Attendance].[Type.Group]    Script Date: 01/17/2012 12:44:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  UserDefinedFunction [Security].[SESSION_TIMEOUT]    Script Date: 01/17/2012 12:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Security].[Session]    Script Date: 01/17/2012 12:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Sales].[Vendor]    Script Date: 01/17/2012 12:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [Security].[User]    Script Date: 01/17/2012 12:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Sales].[PurchaseType]    Script Date: 01/17/2012 12:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Attendance].[Product]    Script Date: 01/17/2012 12:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Contact].[Media]    Script Date: 01/17/2012 12:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Shipping].[PackingList]    Script Date: 01/17/2012 12:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Sales].[BidChangeLog]    Script Date: 01/17/2012 12:44:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Contact].[FoneType]    Script Date: 01/17/2012 12:44:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 01/17/2012 12:44:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  UserDefinedFunction [Sales].[Bid.Document.Path]    Script Date: 01/17/2012 12:44:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  UserDefinedFunction [Sales].[Bid.Project.Path]    Script Date: 01/17/2012 12:44:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Location].[Country]    Script Date: 01/17/2012 12:44:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [Sales].[Client]    Script Date: 01/17/2012 12:44:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Location].[City.Search]    Script Date: 01/17/2012 12:44:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Location].[City.List]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [dbo].[GPIMAC.TipoLogradouro]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [dbo].[GPIMAC.PreCliente]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [dbo].[GPIMAC.Contato]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [SMS].[Log]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Attendance].[Type.List]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Contact].[Media.List]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Sales].[Vendor.Search]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Sales].[Vendor.List]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Location].[State]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
SET ANSI_PADDING ON
GO
/****** Object:  Table [Attendance].[Type]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Attendance].[Status.List]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Attendance].[Status]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Location].[State.List]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Attendance].[Register]    Script Date: 01/17/2012 12:44:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [SMS].[Job]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [SMS].[ReportError]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Location].[City]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [dbo].[Gestao.Sales.Bid]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Location].[Country.List]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Sales].[Bid]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Sales].[Client.Search]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Sales].[Client.List]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Location].[Address.Search]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Sales].[Bid.Import]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Attendance].[Message.SMS.Send]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  Table [Attendance].[History]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  UserDefinedFunction [Security].[Session.Get]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Security].[Session.Active]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [SMS].[ReportErrorTest]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Attendance].[Register.Delete]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Security].[Session.Validate]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Security].[Session.Request]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [Attendance].[Product.List]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [dbo].[Gestao.Sales.Bid.Client]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [dbo].[DBALTAMIRA.VE_Recados]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [dbo].[DBALTAMIRA.PRE_Orcamentos]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Sales].[Bid.Search]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Sales].[Dashboard]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Attendance].[Dashboard]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Sales].[Client.CommitChanges]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Attendance].[Register.Search]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Shipping].[PackingList.Search]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Attendance].[Register.CommitChanges]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Shipping].[PackingList.CommitChanges]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  View [dbo].[GPIMAC.CodigoSequencial]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [Sales].[Bid.CommitChanges]    Script Date: 01/17/2012 12:44:46 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO

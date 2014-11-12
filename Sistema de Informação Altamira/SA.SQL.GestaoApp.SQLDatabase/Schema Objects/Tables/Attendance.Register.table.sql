CREATE TABLE [Attendance].[Register](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[DateTime] [datetime] NOT NULL,
	[Sales.Client.Id] [int] NOT NULL,
	[Sales.Vendor.Id] [int] NOT NULL,
	[Attendance.Type.Id] [int] NOT NULL,
	[Attendance.Status.Id] [int] NOT NULL,
	[ContactPerson] [xml] NULL,
	[LocationAddress] [xml] NULL,
	[Products] [xml] NULL,
	[Comments] [text] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateBy.Security.User.Id] [int] NOT NULL,
	[LastUpdateDate] [datetime] NULL,
	[LastUpdateBy.Security.User.Id] [int] NULL) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
















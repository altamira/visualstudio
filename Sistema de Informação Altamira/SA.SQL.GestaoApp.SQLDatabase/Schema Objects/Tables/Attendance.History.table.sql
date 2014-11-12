CREATE TABLE [Attendance].[History](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Attendance.Register.Id] [int] NOT NULL,
	[Attendance.Type.Id] [int] NOT NULL,
	[Attendance.Status.Id] [int] NOT NULL,
	[TimeStamp] [datetime] NOT NULL,
	[Comments] [text] NULL) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]











CREATE TABLE [System].[Parameters] (
    [Id]    INT           IDENTITY (1, 1) NOT NULL,
    [Name]  NVARCHAR (50) NOT NULL,
    [Value] XML           NOT NULL,
    CONSTRAINT [PK_Parameters] PRIMARY KEY CLUSTERED ([Id] ASC)
);


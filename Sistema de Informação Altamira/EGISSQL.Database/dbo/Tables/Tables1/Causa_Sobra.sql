CREATE TABLE [dbo].[Causa_Sobra] (
    [cd_causa_sobra] INT          NOT NULL,
    [nm_causa_sobra] VARCHAR (40) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Causa_Sobra] PRIMARY KEY CLUSTERED ([cd_causa_sobra] ASC) WITH (FILLFACTOR = 90)
);


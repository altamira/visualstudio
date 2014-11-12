CREATE TABLE [dbo].[Causa_Refugo] (
    [cd_causa_refugo] INT          NOT NULL,
    [nm_causa_refugo] VARCHAR (40) NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Causa_Refugo] PRIMARY KEY CLUSTERED ([cd_causa_refugo] ASC) WITH (FILLFACTOR = 90)
);


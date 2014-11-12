CREATE TABLE [dbo].[Causa_Falha] (
    [cd_causa_falha] INT          NOT NULL,
    [nm_causa_falha] VARCHAR (50) NULL,
    [ds_causa_falha] TEXT         NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Causa_Falha] PRIMARY KEY CLUSTERED ([cd_causa_falha] ASC) WITH (FILLFACTOR = 90)
);


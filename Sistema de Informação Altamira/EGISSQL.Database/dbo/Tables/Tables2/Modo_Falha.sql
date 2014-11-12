CREATE TABLE [dbo].[Modo_Falha] (
    [cd_modo_falha] INT          NOT NULL,
    [nm_modo_falha] VARCHAR (40) NULL,
    [ds_modo_falha] TEXT         NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Modo_Falha] PRIMARY KEY CLUSTERED ([cd_modo_falha] ASC) WITH (FILLFACTOR = 90)
);


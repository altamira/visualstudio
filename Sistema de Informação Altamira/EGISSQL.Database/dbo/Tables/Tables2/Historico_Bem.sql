CREATE TABLE [dbo].[Historico_Bem] (
    [cd_historico_bem] INT          NOT NULL,
    [nm_historico_bem] VARCHAR (30) NULL,
    [sg_historico_bem] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [pk_historico_bem] PRIMARY KEY CLUSTERED ([cd_historico_bem] ASC) WITH (FILLFACTOR = 90)
);


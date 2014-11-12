CREATE TABLE [dbo].[Relatorio] (
    [cd_relatorio]        INT           NOT NULL,
    [nm_relatorio]        VARCHAR (60)  NOT NULL,
    [sg_relatorio]        CHAR (10)     NULL,
    [cd_usuario_atualiza] INT           NULL,
    [dt_atualiza]         DATETIME      NULL,
    [cd_usuario]          INT           NULL,
    [dt_usuario]          DATETIME      NULL,
    [cd_tipo_relatorio]   INT           NULL,
    [ds_relatorio]        TEXT          NULL,
    [nm_titulo_relatorio] VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([cd_relatorio] ASC) WITH (FILLFACTOR = 90)
);


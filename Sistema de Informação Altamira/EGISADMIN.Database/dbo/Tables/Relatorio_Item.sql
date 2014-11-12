CREATE TABLE [dbo].[Relatorio_Item] (
    [cd_instrucao] INT          NOT NULL,
    [nm_instrucao] VARCHAR (80) NOT NULL,
    [sg_instrucao] CHAR (10)    NULL,
    [ds_instrucao] TEXT         NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL
);


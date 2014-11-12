CREATE TABLE [dbo].[Campanha_Mensagem] (
    [cd_campanha_mensagem] INT          NOT NULL,
    [nm_campanha_mensagem] VARCHAR (30) NOT NULL,
    [sg_campanha_mensagem] VARCHAR (10) NOT NULL,
    [ds_campanha_mensagem] CHAR (1)     NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL
);


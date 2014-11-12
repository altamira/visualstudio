CREATE TABLE [dbo].[Usuario_Config] (
    [cd_usuario]          INT           NOT NULL,
    [nm_origem]           VARCHAR (100) NOT NULL,
    [nm_destino]          VARCHAR (100) NOT NULL,
    [nm_arquivo]          VARCHAR (30)  NOT NULL,
    [sg_tipo]             CHAR (1)      NOT NULL,
    [cd_modulo]           INT           NOT NULL,
    [cd_usuario_atualiza] INT           NULL,
    [dt_atualiza]         DATETIME      NULL,
    [dt_usuario]          DATETIME      NULL
);


CREATE TABLE [dbo].[LogErroFerNet] (
    [cd_log]              INT           IDENTITY (1, 1) NOT NULL,
    [dt_log]              DATETIME      NULL,
    [cd_movimento]        INT           NULL,
    [cd_cone]             INT           NULL,
    [cd_grupo_ferramenta] INT           NULL,
    [cd_ferramenta]       INT           NULL,
    [cd_maquina]          INT           NULL,
    [nm_mensagem]         VARCHAR (120) NULL,
    [cd_usuario]          INT           NULL
);


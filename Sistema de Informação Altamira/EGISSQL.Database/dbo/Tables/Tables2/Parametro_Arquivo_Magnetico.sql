CREATE TABLE [dbo].[Parametro_Arquivo_Magnetico] (
    [cd_documento_magnetico] INT          NOT NULL,
    [cd_parametro]           INT          NOT NULL,
    [cd_sessao_documento]    INT          NOT NULL,
    [nm_tabela]              VARCHAR (40) NULL,
    [nm_campo]               VARCHAR (40) NULL,
    [nm_parametro]           VARCHAR (50) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [ic_tipo_operador]       CHAR (1)     NULL
);


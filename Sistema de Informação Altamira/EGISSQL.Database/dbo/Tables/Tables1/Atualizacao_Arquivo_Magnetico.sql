CREATE TABLE [dbo].[Atualizacao_Arquivo_Magnetico] (
    [cd_documento_magnetico]    INT           NOT NULL,
    [cd_parametro_atualizacao]  INT           NOT NULL,
    [nm_procedimento]           VARCHAR (100) NULL,
    [nm_parametro_procedimento] VARCHAR (60)  NULL,
    [cd_sessao_arquivo_magneti] INT           NULL,
    [cd_campo_magnetico]        INT           NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [ic_tipo_parametro]         CHAR (1)      NULL
);


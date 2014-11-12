CREATE TABLE [dbo].[Log_Arquivo_Magnetico] (
    [cd_log_arquivo_magnetico]  INT           NOT NULL,
    [cd_documento_magnetico]    INT           NOT NULL,
    [nm_local_arq_magnetico]    VARCHAR (300) NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_arquivo_magnetico]      VARCHAR (20)  NULL,
    [nm_log_reg_arq_magnetico]  VARCHAR (100) NULL,
    [cd_arquivo_magnetico]      INT           NULL,
    [qt_linha_detalhe_log]      INT           NULL,
    [nm_identificacao_registro] CHAR (10)     NULL
);


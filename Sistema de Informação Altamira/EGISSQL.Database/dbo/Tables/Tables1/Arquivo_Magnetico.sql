CREATE TABLE [dbo].[Arquivo_Magnetico] (
    [cd_arquivo_magnetico]    INT           NOT NULL,
    [cd_documento_magnetico]  INT           NOT NULL,
    [nm_local_arq_magnetico]  VARCHAR (300) NULL,
    [nm_arquivo_magnetico]    VARCHAR (20)  NULL,
    [ic_status_arq_magnetico] CHAR (1)      NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [dt_proc_arq_magnetico]   DATETIME      NULL
);


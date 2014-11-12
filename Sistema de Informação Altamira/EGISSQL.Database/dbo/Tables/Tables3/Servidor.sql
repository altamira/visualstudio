CREATE TABLE [dbo].[Servidor] (
    [cd_servidor]               INT           NOT NULL,
    [nm_servidor]               VARCHAR (30)  NOT NULL,
    [sg_servidor]               VARCHAR (10)  NOT NULL,
    [cd_status_servidor]        INT           NULL,
    [cd_local_servidor]         INT           NULL,
    [nm_caminho_unc_servidor]   VARCHAR (100) NOT NULL,
    [ic_liberado_processamento] CHAR (1)      NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [ic_tipo_checagem]          CHAR (1)      NULL,
    [nm_banco_dados_sql]        VARCHAR (30)  NULL,
    [ic_senha_usuario_sa]       CHAR (1)      NULL,
    CONSTRAINT [PK_Servidor] PRIMARY KEY NONCLUSTERED ([cd_servidor] ASC) WITH (FILLFACTOR = 90)
);


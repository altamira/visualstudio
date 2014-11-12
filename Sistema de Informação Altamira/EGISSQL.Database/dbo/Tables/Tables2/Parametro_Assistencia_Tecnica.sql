CREATE TABLE [dbo].[Parametro_Assistencia_Tecnica] (
    [cd_empresa]          INT      NOT NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    [ic_tipo_envio_email] CHAR (1) NULL,
    [ic_tipo_fechamento]  CHAR (1) NULL,
    [ic_tipo_geracao]     CHAR (1) NULL,
    [ic_modelo_os]        CHAR (1) NULL,
    [ic_gera_scr]         CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Assistencia_Tecnica] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);


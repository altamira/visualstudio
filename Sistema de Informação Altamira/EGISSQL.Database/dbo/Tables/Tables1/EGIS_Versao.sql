CREATE TABLE [dbo].[EGIS_Versao] (
    [cd_controle_versao] INT      NOT NULL,
    [dt_controle_versao] DATETIME NULL,
    [cd_ano]             INT      NULL,
    [cd_mes]             INT      NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    [ic_licenca]         CHAR (1) NULL,
    [ic_manutencao]      CHAR (1) NULL,
    CONSTRAINT [PK_EGIS_Versao] PRIMARY KEY CLUSTERED ([cd_controle_versao] ASC) WITH (FILLFACTOR = 90)
);


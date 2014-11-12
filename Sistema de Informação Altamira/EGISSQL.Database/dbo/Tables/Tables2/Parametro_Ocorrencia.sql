CREATE TABLE [dbo].[Parametro_Ocorrencia] (
    [cd_empresa]               INT      NOT NULL,
    [ic_tipo_ocorrencia]       CHAR (1) NULL,
    [ic_transporte_ocorrencia] CHAR (1) NULL,
    [ic_exclusao_ocorrencia]   CHAR (1) NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    CONSTRAINT [PK_Parametro_Ocorrencia] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);


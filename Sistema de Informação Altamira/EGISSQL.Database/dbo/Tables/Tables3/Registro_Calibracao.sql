CREATE TABLE [dbo].[Registro_Calibracao] (
    [cd_registro_calibracao]     INT          NOT NULL,
    [dt_registro_calibracao]     DATETIME     NULL,
    [nm_certificado_calibracao]  VARCHAR (40) NULL,
    [cd_fornecedor]              INT          NULL,
    [nm_laboratorio_calibracao]  VARCHAR (40) NULL,
    [cd_tipo_calibracao]         INT          NULL,
    [cd_frequencia_calibracao]   INT          NULL,
    [ds_registro_calibracao]     TEXT         NULL,
    [nm_obs_registro_calibracao] VARCHAR (40) NULL,
    [dt_vencimento_calibracao]   DATETIME     NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_tipo_registro]           INT          NULL,
    CONSTRAINT [PK_Registro_Calibracao] PRIMARY KEY CLUSTERED ([cd_registro_calibracao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Calibracao_Tipo_Calibracao] FOREIGN KEY ([cd_tipo_calibracao]) REFERENCES [dbo].[Tipo_Calibracao] ([cd_tipo_calibracao])
);


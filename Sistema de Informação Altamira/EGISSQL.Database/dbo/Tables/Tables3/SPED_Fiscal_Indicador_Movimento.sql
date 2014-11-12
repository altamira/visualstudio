CREATE TABLE [dbo].[SPED_Fiscal_Indicador_Movimento] (
    [cd_indicador_movimento] INT          NOT NULL,
    [nm_indicador_movimento] VARCHAR (40) NULL,
    [cd_sped_fiscal]         VARCHAR (15) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [qt_registro_indicador]  FLOAT (53)   NULL,
    CONSTRAINT [PK_SPED_Fiscal_Indicador_Movimento] PRIMARY KEY CLUSTERED ([cd_indicador_movimento] ASC) WITH (FILLFACTOR = 90)
);


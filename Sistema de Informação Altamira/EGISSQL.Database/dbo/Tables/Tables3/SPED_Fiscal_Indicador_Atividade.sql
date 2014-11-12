CREATE TABLE [dbo].[SPED_Fiscal_Indicador_Atividade] (
    [cd_indicador]   INT          NOT NULL,
    [nm_indicador]   VARCHAR (40) NULL,
    [cd_sped_fiscal] VARCHAR (15) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_SPED_Fiscal_Indicador_Atividade] PRIMARY KEY CLUSTERED ([cd_indicador] ASC) WITH (FILLFACTOR = 90)
);


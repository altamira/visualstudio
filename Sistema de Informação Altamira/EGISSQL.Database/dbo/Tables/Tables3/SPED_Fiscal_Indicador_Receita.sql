CREATE TABLE [dbo].[SPED_Fiscal_Indicador_Receita] (
    [cd_indicador_receita] INT          NOT NULL,
    [nm_indicador_receira] VARCHAR (60) NULL,
    [cd_sped_fiscal]       VARCHAR (15) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_SPED_Fiscal_Indicador_Receita] PRIMARY KEY CLUSTERED ([cd_indicador_receita] ASC) WITH (FILLFACTOR = 90)
);


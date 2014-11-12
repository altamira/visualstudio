CREATE TABLE [dbo].[Rateio_Padrao_Plano_Fin_Composicao] (
    [cd_rateio_padrao_plano_fin] INT        NOT NULL,
    [cd_plano_financeiro]        INT        NOT NULL,
    [pc_rateio]                  FLOAT (53) NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    CONSTRAINT [PK_Rateio_Padrao_Plano_Fin_Composicao] PRIMARY KEY CLUSTERED ([cd_rateio_padrao_plano_fin] ASC, [cd_plano_financeiro] ASC) WITH (FILLFACTOR = 90)
);


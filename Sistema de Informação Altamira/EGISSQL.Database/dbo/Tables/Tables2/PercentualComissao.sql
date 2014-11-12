CREATE TABLE [dbo].[PercentualComissao] (
    [cd_percentual_comissao]    INT        NOT NULL,
    [sg_percentual_comissao]    CHAR (10)  NULL,
    [qt_faixa_inicial_desconto] FLOAT (53) NULL,
    [qt_faixa_final_desconto]   FLOAT (53) NULL,
    [pc_comissao]               FLOAT (53) NULL,
    CONSTRAINT [PK_PercentualComissao] PRIMARY KEY CLUSTERED ([cd_percentual_comissao] ASC) WITH (FILLFACTOR = 90)
);


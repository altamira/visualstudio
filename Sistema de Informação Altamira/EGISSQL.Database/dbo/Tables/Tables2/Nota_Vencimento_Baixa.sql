CREATE TABLE [dbo].[Nota_Vencimento_Baixa] (
    [cd_nota_fiscal]          INT          NOT NULL,
    [cd_item_nota_vencimento] INT          NOT NULL,
    [cd_nota_entrada]         INT          NULL,
    [dt_nota_entrada]         DATETIME     NULL,
    [vl_nota_entrada]         FLOAT (53)   NULL,
    [cd_item_nota_entrada]    INT          NULL,
    [nm_obs_baixa_nota]       VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_fornecedor]           INT          NULL,
    [cd_serie_nota_fiscal]    INT          NULL,
    [cd_operacao_fiscal]      INT          NULL,
    [cd_nota_saida]           INT          NULL,
    CONSTRAINT [PK_Nota_Vencimento_Baixa] PRIMARY KEY CLUSTERED ([cd_nota_fiscal] ASC, [cd_item_nota_vencimento] ASC) WITH (FILLFACTOR = 90)
);


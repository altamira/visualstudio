CREATE TABLE [dbo].[Embarque_Financeiro] (
    [cd_pedido_venda]         INT          NOT NULL,
    [cd_embarque]             INT          NOT NULL,
    [cd_item_financeiro]      INT          NOT NULL,
    [ic_tipo_atualizacao]     CHAR (1)     NULL,
    [vl_financeiro_embarque]  FLOAT (53)   NULL,
    [dt_financeiro_embarque]  DATETIME     NULL,
    [cd_plano_financeiro]     INT          NULL,
    [ic_conversao_moeda]      CHAR (1)     NULL,
    [cd_moeda]                INT          NULL,
    [dt_conversao_moeda]      DATETIME     NULL,
    [cd_historico_financeiro] INT          NULL,
    [nm_compl_historico]      VARCHAR (40) NULL,
    [nm_obs_financeiro]       VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_movimento_financeiro] INT          NULL,
    CONSTRAINT [PK_Embarque_Financeiro] PRIMARY KEY CLUSTERED ([cd_pedido_venda] ASC, [cd_embarque] ASC, [cd_item_financeiro] ASC) WITH (FILLFACTOR = 90)
);


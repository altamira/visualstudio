CREATE TABLE [dbo].[Comissao_Pedido_Venda] (
    [cd_comissao_pedido]       INT          NOT NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [dt_base_calculo_comissao] DATETIME     NULL,
    [dt_inicial_calculo]       DATETIME     NULL,
    [dt_final_calculo]         DATETIME     NULL,
    [cd_pedido_venda]          INT          NULL,
    [cd_item_pedido_venda]     INT          NULL,
    [vl_base_calculo_comissao] FLOAT (53)   NULL,
    [pc_calculo_comissao]      FLOAT (53)   NULL,
    [nm_obs_calculo_comissao]  VARCHAR (40) NULL,
    [ic_manutencao_calculo]    CHAR (1)     NULL,
    [cd_nota_saida]            INT          NULL,
    [cd_item_nota_saida]       INT          NULL,
    [cd_controle]              INT          NULL,
    [vl_calculo_comissao]      FLOAT (53)   NULL,
    [ic_zera_calculo]          CHAR (1)     NULL,
    CONSTRAINT [PK_Comissao_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_comissao_pedido] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[Aplicacao_Produto] (
    [cd_aplicacao_produto]     INT          NOT NULL,
    [nm_aplicacao_produto]     VARCHAR (30) NULL,
    [sg_aplicacao_produto]     CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_destinacao_produto]    INT          NULL,
    [ic_pad_aplicacao_produto] CHAR (1)     NULL,
    [ic_compra_aplicacao_prod] CHAR (1)     NULL,
    [cd_plano_compra]          INT          NULL,
    [ic_pv_rc_obrig_aplicacao] CHAR (1)     NULL,
    [cd_plano_financeiro]      INT          NULL,
    CONSTRAINT [PK_Aplicacao_Produto] PRIMARY KEY CLUSTERED ([cd_aplicacao_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aplicacao_Produto_Plano_Compra] FOREIGN KEY ([cd_plano_compra]) REFERENCES [dbo].[Plano_Compra] ([cd_plano_compra])
);


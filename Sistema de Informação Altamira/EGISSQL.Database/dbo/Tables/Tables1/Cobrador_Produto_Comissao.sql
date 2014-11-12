CREATE TABLE [dbo].[Cobrador_Produto_Comissao] (
    [cd_cobrador]               INT          NOT NULL,
    [cd_tipo_produto_cemiterio] INT          NOT NULL,
    [pc_comissao_prod_cobrador] FLOAT (53)   NULL,
    [nm_obscomis_prod_cobrador] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Cobrador_Produto_Comissao] PRIMARY KEY CLUSTERED ([cd_cobrador] ASC, [cd_tipo_produto_cemiterio] ASC) WITH (FILLFACTOR = 90)
);


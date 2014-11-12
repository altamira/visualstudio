CREATE TABLE [dbo].[Cliente_Preco] (
    [cd_cliente]           INT          NOT NULL,
    [cd_tipo_tabela_preco] INT          NOT NULL,
    [cd_produto]           INT          NOT NULL,
    [vl_cliente_preco]     MONEY        NOT NULL,
    [dt_cliente_preco]     DATETIME     NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    [nm_obs_cliente_preco] VARCHAR (40) NULL,
    [cd_moeda]             INT          NULL
);


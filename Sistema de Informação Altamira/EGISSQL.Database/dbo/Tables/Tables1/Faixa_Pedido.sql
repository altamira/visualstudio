CREATE TABLE [dbo].[Faixa_Pedido] (
    [cd_faixa_pedido]     INT          NOT NULL,
    [cd_pedido_inicial]   INT          NOT NULL,
    [cd_pedido_final]     INT          NOT NULL,
    [ic_servico]          CHAR (1)     NULL,
    [nm_obs_faixa_pedido] VARCHAR (50) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Faixa_Pedido] PRIMARY KEY CLUSTERED ([cd_faixa_pedido] ASC)
);


CREATE TABLE [dbo].[Pedido_Venda_Atividade] (
    [cd_controle_atividade]   INT          NOT NULL,
    [cd_pedido_venda]         INT          NULL,
    [cd_item_pedido_venda]    INT          NULL,
    [cd_atividade]            INT          NULL,
    [nm_obs_pedido_atividade] VARCHAR (60) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [dt_prevista_atividade]   DATETIME     NULL,
    [dt_realizada_atividade]  DATETIME     NULL,
    CONSTRAINT [PK_Pedido_Venda_Atividade] PRIMARY KEY CLUSTERED ([cd_controle_atividade] ASC),
    CONSTRAINT [FK_Pedido_Venda_Atividade_Atividade_Servico] FOREIGN KEY ([cd_atividade]) REFERENCES [dbo].[Atividade_Servico] ([cd_atividade])
);


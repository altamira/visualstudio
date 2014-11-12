CREATE TABLE [dbo].[Atendimento_Pedido_Venda] (
    [cd_atendimento_pedido] INT          NOT NULL,
    [cd_pedido_venda]       INT          NULL,
    [cd_item_pedido_venda]  INT          NULL,
    [qt_atendimento]        FLOAT (53)   NULL,
    [cd_produto]            INT          NULL,
    [dt_atendimento]        DATETIME     NULL,
    [nm_forma]              VARCHAR (10) NULL,
    [cd_documento]          INT          NULL,
    [cd_item_documento]     INT          NULL,
    [nm_obs_atendimento]    VARCHAR (60) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Atendimento_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_atendimento_pedido] ASC) WITH (FILLFACTOR = 90)
);


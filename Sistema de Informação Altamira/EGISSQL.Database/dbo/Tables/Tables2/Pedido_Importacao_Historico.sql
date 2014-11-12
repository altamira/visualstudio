CREATE TABLE [dbo].[Pedido_Importacao_Historico] (
    [cd_pedido_importacao]    INT           NOT NULL,
    [cd_pedido_imp_historico] INT           NOT NULL,
    [dt_pedido_imp_historico] DATETIME      NULL,
    [cd_historico_pedido]     INT           NULL,
    [nm_pedido_imp_histor_1]  VARCHAR (100) NULL,
    [nm_pedido_imp_histor_2]  VARCHAR (100) NULL,
    [nm_pedido_imp_histor_3]  VARCHAR (100) NULL,
    [nm_pedido_imp_histor_4]  VARCHAR (100) NULL,
    [cd_tipo_status_pedido]   INT           NULL,
    [cd_item_ped_item]        INT           NOT NULL,
    [cd_modulo]               INT           NULL,
    [cd_departamento]         INT           NULL,
    [cd_processo]             INT           NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    CONSTRAINT [PK_Pedido_Importacao_Historico] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC, [cd_pedido_imp_historico] ASC, [cd_item_ped_item] ASC) WITH (FILLFACTOR = 90)
);


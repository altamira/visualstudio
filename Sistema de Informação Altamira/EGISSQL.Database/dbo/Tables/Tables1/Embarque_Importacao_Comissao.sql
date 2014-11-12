CREATE TABLE [dbo].[Embarque_Importacao_Comissao] (
    [cd_pedido_importacao]       INT          NOT NULL,
    [cd_embarque]                INT          NOT NULL,
    [cd_item_embarque_comissao]  INT          NOT NULL,
    [cd_representante_com_ext]   INT          NULL,
    [pc_embarque_comissao]       FLOAT (53)   NULL,
    [vl_embarque_comissao]       FLOAT (53)   NULL,
    [dt_prevista_comissao]       DATETIME     NULL,
    [nm_obs_embarque_comissao]   VARCHAR (40) NULL,
    [cd_tipo_pagamento_comissao] INT          NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Embarque_Importacao_Comissao] PRIMARY KEY CLUSTERED ([cd_pedido_importacao] ASC, [cd_embarque] ASC, [cd_item_embarque_comissao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Embarque_Importacao_Comissao_Tipo_Pagamento_Comissao] FOREIGN KEY ([cd_tipo_pagamento_comissao]) REFERENCES [dbo].[Tipo_Pagamento_Comissao] ([cd_tipo_pag_comissao])
);


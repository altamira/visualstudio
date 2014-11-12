CREATE TABLE [dbo].[Serie_Produto_Servico_Manual] (
    [cd_serie_produto]         INT          NOT NULL,
    [cd_placa]                 INT          NOT NULL,
    [cd_item_servico_manual]   INT          NOT NULL,
    [qt_hora_item_serv_manual] FLOAT (53)   NULL,
    [nm_item_servico_manual]   VARCHAR (40) NULL,
    [cd_tipo_mao_obra]         INT          NULL,
    [ic_tipo_mao_obra]         CHAR (1)     NULL,
    [ic_markup_serv_manual]    CHAR (1)     NULL,
    [cd_mao_obra]              INT          NULL,
    [cd_categoria_orcamento]   INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Serie_Produto_Servico_Manual] PRIMARY KEY CLUSTERED ([cd_serie_produto] ASC, [cd_placa] ASC, [cd_item_servico_manual] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Serie_Produto_Servico_Manual_Categoria_Orcamento] FOREIGN KEY ([cd_categoria_orcamento]) REFERENCES [dbo].[Categoria_Orcamento] ([cd_categoria_orcamento])
);


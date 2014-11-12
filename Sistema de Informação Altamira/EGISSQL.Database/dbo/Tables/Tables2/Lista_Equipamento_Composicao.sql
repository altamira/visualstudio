CREATE TABLE [dbo].[Lista_Equipamento_Composicao] (
    [cd_lista_equipamento]      INT          NOT NULL,
    [cd_item_lista_equipamento] INT          NOT NULL,
    [nm_item_lista_equipamento] VARCHAR (30) NULL,
    [cd_produto]                INT          NULL,
    [nm_fabricante]             VARCHAR (40) NULL,
    [cd_fabricante_produto]     VARCHAR (30) NULL,
    [cd_equivalente_smc]        VARCHAR (40) NULL,
    [qt_produto_lista]          FLOAT (53)   NULL,
    [vl_preco_lista]            FLOAT (53)   NULL,
    [nm_obs_lista]              VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_concorrente]            INT          NULL,
    [cd_produto_check_list]     INT          NULL,
    CONSTRAINT [PK_Lista_Equipamento_Composicao] PRIMARY KEY CLUSTERED ([cd_lista_equipamento] ASC, [cd_item_lista_equipamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Lista_Equipamento_Composicao_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);


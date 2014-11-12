CREATE TABLE [dbo].[Item_Orcamento_Cq] (
    [cd_consulta]               INT          NOT NULL,
    [cd_item_consulta]          INT          NOT NULL,
    [cd_item_orcamento_cq]      INT          NOT NULL,
    [cd_produto_orcamento_cq]   CHAR (15)    NOT NULL,
    [qt_produto_orcamento_cq]   FLOAT (53)   NOT NULL,
    [nm_produto_orcamento_cq]   VARCHAR (50) NULL,
    [ds_produto_orcamento_cq]   TEXT         NULL,
    [vl_lista_orcamento_cq]     FLOAT (53)   NULL,
    [vl_unitario_orcamento_cq]  FLOAT (53)   NULL,
    [pc_desconto_orcamento_cq]  FLOAT (53)   NULL,
    [ic_controle_projeto_cq]    CHAR (1)     NULL,
    [ic_acessorio_orcamento_cq] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_grupo_produto_cq]       INT          NULL,
    [ic_produto_especial_cq]    CHAR (1)     NULL,
    [ic_porta_molde_item_cq]    CHAR (1)     NULL,
    CONSTRAINT [PK_Item_Orcamento_Cq] PRIMARY KEY NONCLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_item_orcamento_cq] ASC) WITH (FILLFACTOR = 90)
);


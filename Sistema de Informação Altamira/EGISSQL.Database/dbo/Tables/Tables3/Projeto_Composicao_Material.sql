﻿CREATE TABLE [dbo].[Projeto_Composicao_Material] (
    [cd_projeto]                INT           NOT NULL,
    [cd_item_projeto]           INT           NOT NULL,
    [cd_projeto_material]       INT           NOT NULL,
    [cd_desenho_projeto]        INT           NULL,
    [cd_produto]                INT           NULL,
    [qt_projeto_material]       FLOAT (53)    NULL,
    [nm_esp_projeto_material]   VARCHAR (50)  NULL,
    [nm_obs_projeto_material]   VARCHAR (40)  NULL,
    [ds_projeto_material]       TEXT          NULL,
    [ic_fabricado_projeto]      CHAR (1)      NULL,
    [cd_fornecedor]             INT           NULL,
    [cd_requisicao_compra]      INT           NULL,
    [cd_materia_prima]          INT           NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_marca_material]         VARCHAR (30)  NULL,
    [cd_unidade_medida]         INT           NULL,
    [cd_tipo_produto_projeto]   INT           NULL,
    [cd_processo]               INT           NULL,
    [nm_fornec_prod_projeto]    VARCHAR (30)  NULL,
    [nm_desenho_material]       VARCHAR (50)  NULL,
    [nm_caminho_desenho]        VARCHAR (200) NULL,
    [cd_item_requisicao_compra] INT           NULL,
    [cd_projetista]             INT           NULL,
    [cd_item_req_interna]       INT           NULL,
    [cd_requisicao_interna]     INT           NULL,
    [ic_reposicao_material]     CHAR (1)      NULL,
    [cd_projetista_liberacao]   INT           NULL,
    [dt_liberacao_material]     DATETIME      NULL,
    [cd_selecionado]            INT           NULL,
    [ic_desgaste_material]      CHAR (1)      NULL,
    [qt_dia_desgaste_material]  INT           NULL,
    [dt_vencimento_desgaste]    DATETIME      NULL,
    [ic_compra_prod_material]   CHAR (1)      NULL,
    [qt_hora_desgaste_material] FLOAT (53)    NULL,
    [cd_ref_item_material]      INT           NULL,
    [ic_ativo_material]         CHAR (1)      NULL,
    CONSTRAINT [PK_Projeto_Composicao_Material] PRIMARY KEY CLUSTERED ([cd_projeto] ASC, [cd_item_projeto] ASC, [cd_projeto_material] ASC) WITH (FILLFACTOR = 90)
);


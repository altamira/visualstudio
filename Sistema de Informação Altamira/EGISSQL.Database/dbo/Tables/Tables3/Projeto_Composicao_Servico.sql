﻿CREATE TABLE [dbo].[Projeto_Composicao_Servico] (
    [cd_projeto]                INT           NOT NULL,
    [cd_item_projeto]           INT           NOT NULL,
    [cd_projeto_servico]        INT           NOT NULL,
    [cd_desenho_projeto]        INT           NULL,
    [cd_servico]                INT           NULL,
    [qt_projeto_servico]        FLOAT (53)    NULL,
    [nm_esp_projeto_servico]    VARCHAR (50)  NULL,
    [nm_obs_projeto_servico]    VARCHAR (40)  NULL,
    [ds_projeto_servico]        TEXT          NULL,
    [ic_fabricado_projeto]      CHAR (1)      NULL,
    [cd_fornecedor]             INT           NULL,
    [cd_requisicao_compra]      INT           NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_marca_servico]          VARCHAR (30)  NULL,
    [cd_unidade_medida]         INT           NULL,
    [cd_processo]               INT           NULL,
    [nm_fornec_prod_projeto]    VARCHAR (30)  NULL,
    [nm_desenho_material]       VARCHAR (50)  NULL,
    [nm_caminho_desenho]        VARCHAR (200) NULL,
    [cd_requisicao_interna]     INT           NULL,
    [cd_item_req_interna]       INT           NULL,
    [cd_item_requisicao_compra] INT           NULL,
    [cd_projetista_liberacao]   INT           NULL,
    [cd_projetista]             INT           NULL,
    [dt_liberacao_servico]      DATETIME      NULL,
    [cd_selecionado]            INT           NULL,
    CONSTRAINT [PK_Projeto_Composicao_Servico] PRIMARY KEY CLUSTERED ([cd_projeto] ASC, [cd_item_projeto] ASC, [cd_projeto_servico] ASC)
);


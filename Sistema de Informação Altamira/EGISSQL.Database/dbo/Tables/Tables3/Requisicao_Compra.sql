CREATE TABLE [dbo].[Requisicao_Compra] (
    [cd_requisicao_compra]      INT        NOT NULL,
    [dt_emissao_req_compra]     DATETIME   NULL,
    [dt_necessidade_req_compra] DATETIME   NULL,
    [cd_departamento]           INT        NULL,
    [cd_aplicacao_produto]      INT        NULL,
    [cd_plano_compra]           INT        NULL,
    [ds_requisicao_compra]      TEXT       NULL,
    [cd_centro_custo]           INT        NULL,
    [qt_cotacao_req_compra]     FLOAT (53) NULL,
    [cd_tipo_requisicao]        INT        NULL,
    [cd_processo_fabricacao]    INT        NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [cd_tipo_produto_espessura] INT        NULL,
    [cd_status_requisicao]      INT        NULL,
    [ic_tipo_requisicao]        CHAR (1)   NULL,
    [cd_pedido_compra]          INT        NULL,
    [qt_peso_req_compra]        FLOAT (53) NULL,
    [cd_item_pedido_compra]     INT        NULL,
    [ic_maquina]                CHAR (1)   NULL,
    [cd_destinacao_produto]     INT        NULL,
    [ds_obs_requisicao_compra]  TEXT       NULL,
    [ds_obs_proc_req_compra]    TEXT       NULL,
    [cd_plano_financeiro]       INT        NULL,
    [ic_aprovada_req_compra]    CHAR (1)   NULL,
    [ic_reprovada_req_compra]   CHAR (1)   NULL,
    [cd_motivo_requisicao]      INT        NULL,
    [cd_pais]                   INT        NULL,
    [cd_tipo_importacao]        INT        NULL,
    [ic_liberado_proc_compra]   CHAR (1)   NULL,
    [cd_requisitante]           INT        NULL,
    [dt_liberado_proc_compra]   DATETIME   NULL,
    [cd_destino_compra]         INT        NULL,
    [cd_loja]                   INT        NULL,
    [cd_tipo_mercado]           INT        NULL,
    [ic_custo_requisicao]       CHAR (1)   NULL,
    [ic_orcamento_requisicao]   CHAR (1)   NULL,
    [ds_obs_comprador]          TEXT       NULL,
    CONSTRAINT [PK_Requisicao_Compra] PRIMARY KEY CLUSTERED ([cd_requisicao_compra] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ix_dt_emissao_req_compra]
    ON [dbo].[Requisicao_Compra]([dt_emissao_req_compra] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_dt_necessidade_req_nota]
    ON [dbo].[Requisicao_Compra]([dt_necessidade_req_compra] ASC) WITH (FILLFACTOR = 90);


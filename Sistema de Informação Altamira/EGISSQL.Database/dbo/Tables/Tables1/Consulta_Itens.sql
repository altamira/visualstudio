CREATE TABLE [dbo].[Consulta_Itens] (
    [cd_consulta]                   INT          NOT NULL,
    [cd_item_consulta]              INT          NOT NULL,
    [dt_item_consulta]              DATETIME     NULL,
    [cd_grupo_produto]              INT          NULL,
    [nm_fantasia_produto]           VARCHAR (30) NULL,
    [cd_produto_concorrente]        VARCHAR (30) NULL,
    [nm_produto_consulta]           VARCHAR (50) NULL,
    [ds_produto_consulta]           TEXT         NULL,
    [qt_item_consulta]              FLOAT (53)   NULL,
    [vl_unitario_item_consulta]     FLOAT (53)   NULL,
    [vl_lista_item_consulta]        FLOAT (53)   NULL,
    [pc_desconto_item_consulta]     FLOAT (53)   NULL,
    [qt_dia_entrega_consulta]       INT          NULL,
    [dt_entrega_consulta]           DATETIME     NULL,
    [ic_orcamento_consulta]         CHAR (1)     NULL,
    [cd_consulta_matriz]            INT          NULL,
    [cd_item_consulta_matriz]       INT          NULL,
    [dt_fechamento_consulta]        DATETIME     NULL,
    [dt_orcamento_liberado_con]     DATETIME     NULL,
    [cd_consulta_representante]     INT          NULL,
    [cd_item_consulta_represe]      INT          NULL,
    [cd_pedido_compra_consulta]     VARCHAR (20) NULL,
    [cd_os_consulta]                VARCHAR (15) NULL,
    [cd_posicao_consulta]           VARCHAR (15) NULL,
    [ic_tipo_montagem_consulta]     CHAR (1)     NULL,
    [ic_montagem_g_consulta]        CHAR (1)     NULL,
    [ic_subs_tributaria_cons]       CHAR (1)     NULL,
    [ic_alt_obs_consulta]           CHAR (1)     NULL,
    [ic_transmitindo_base]          CHAR (1)     NULL,
    [ic_sel_fax_consulta]           CHAR (1)     NULL,
    [ic_sel_email_consulta]         CHAR (1)     NULL,
    [ic_email_rep_consulta]         CHAR (1)     NULL,
    [ic_email_ven_consulta]         CHAR (1)     NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    [pc_ipi]                        FLOAT (53)   NULL,
    [pc_icms]                       FLOAT (53)   NULL,
    [cd_item_pedido_venda]          INT          NULL,
    [cd_pedido_venda]               INT          NULL,
    [cd_motivo_perda]               INT          NULL,
    [ic_produto_especial]           CHAR (1)     NULL,
    [dt_perda_consulta_itens]       DATETIME     NULL,
    [ic_sel_fechamento]             CHAR (1)     NULL,
    [cd_serie_produto]              INT          NULL,
    [qt_peso_bruto]                 FLOAT (53)   NULL,
    [qt_peso_liquido]               FLOAT (53)   NULL,
    [cd_om]                         INT          NULL,
    [ic_item_perda_consulta]        CHAR (1)     NULL,
    [cd_servico]                    INT          NULL,
    [ic_consulta_item]              CHAR (1)     NULL,
    [ic_desconto_consulta_item]     CHAR (1)     NULL,
    [ds_observacao_fabrica]         TEXT         NULL,
    [cd_unidade_medida]             INT          NULL,
    [cd_produto]                    VARCHAR (30) NULL,
    [pc_reducao_icms]               FLOAT (53)   NULL,
    [pc_desconto_sobre_desc]        FLOAT (53)   NULL,
    [cd_grupo_categoria]            INT          NULL,
    [cd_categoria_produto]          INT          NULL,
    [nm_desconto_consulta_item]     VARCHAR (40) NULL,
    [cd_usuario_liberacao_orc]      INT          NULL,
    [nm_kardex_item_consulta]       VARCHAR (30) NULL,
    [ic_orcamento_comercial]        CHAR (1)     NULL,
    [ic_orcamento_status]           CHAR (1)     NULL,
    [ic_mp66_item_consulta]         CHAR (1)     NULL,
    [ic_montagem_item_consulta]     CHAR (1)     NULL,
    [cd_produto_padrao_orcam]       INT          NULL,
    [cd_tipo_serie_produto]         INT          NULL,
    [ic_ajuste_coord_proporc]       CHAR (1)     NULL,
    [ic_coordenada_especial]        CHAR (1)     NULL,
    [ic_grupo_maquina_especial]     CHAR (1)     NULL,
    [cd_tipo_montagem]              INT          NULL,
    [cd_montagem]                   INT          NULL,
    [ic_considera_mp_orcamento]     CHAR (1)     NULL,
    [vl_frete_item_consulta]        FLOAT (53)   NULL,
    [vl_orcado_item_consulta]       FLOAT (53)   NULL,
    [cd_serie_produto_padrao]       INT          NULL,
    [dt_moeda_cotacao]              DATETIME     NULL,
    [vl_moeda_cotacao]              FLOAT (53)   NULL,
    [cd_moeda_cotacao]              INT          NULL,
    [ic_ativo_item]                 CHAR (1)     NULL,
    [dt_validade_item_consulta]     DATETIME     NULL,
    [cd_usuario_lib_desconto]       INT          NULL,
    [dt_desconto_item_consulta]     DATETIME     NULL,
    [ic_desconto_item_consulta]     CHAR (1)     NULL,
    [vl_custo_financ_item]          FLOAT (53)   NULL,
    [vl_indice_item_consulta]       FLOAT (53)   NULL,
    [qt_dia_entrega_padrao]         INT          NULL,
    [cd_lote_item_consulta]         VARCHAR (25) NULL,
    [cd_idioma]                     INT          NULL,
    [ic_kit_grupo_produto]          CHAR (1)     NULL,
    [cd_sub_produto_especial]       INT          NULL,
    [ic_imediato_produto]           CHAR (1)     NULL,
    [cd_mascara_classificacao]      CHAR (10)    NULL,
    [cd_desenho_item_consulta]      VARCHAR (30) NULL,
    [cd_rev_des_item_consulta]      VARCHAR (5)  NULL,
    [qt_area_produto]               FLOAT (53)   NULL,
    [vl_digitado_item_desconto]     FLOAT (53)   NULL,
    [vl_custo_ferramenta]           FLOAT (53)   NULL,
    [cd_item_cliente]               INT          NULL,
    [cd_ref_item_cliente]           VARCHAR (30) NULL,
    [cd_projeto]                    INT          NULL,
    [ic_estoque_fatura]             CHAR (1)     NULL,
    [ic_estoque_venda]              CHAR (1)     NULL,
    [cd_fase_proposta]              INT          NULL,
    [ic_status_ativo_item_consulta] CHAR (1)     NULL,
    [cd_produto_servico]            INT          NULL,
    [ic_baixa_composicao_item]      CHAR (1)     NULL,
    [vl_bc_icms_st]                 FLOAT (53)   NULL,
    [vl_item_icms_st]               FLOAT (53)   NULL,
    [cd_requisicao_interna]         INT          NULL,
    CONSTRAINT [PK_Consulta_Itens] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Consulta_Itens_Consulta] FOREIGN KEY ([cd_consulta]) REFERENCES [dbo].[Consulta] ([cd_consulta]) ON DELETE CASCADE NOT FOR REPLICATION
);


GO

-------------------------------------------------------------------------------
--sp_helptext tr_produto_estampo_deleta_item_consulta
-------------------------------------------------------------------------------
--tr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Delete a Consulta/Item na Tabela de Produto Estampo
--Data             : 27/06/2007
--Alteração        : 
------------------------------------------------------------------------------
create trigger tr_produto_estampo_deleta_item_consulta
on consulta_itens
FOR DELETE
as

declare @cd_consulta      int
declare @cd_item_consulta int

select
  @cd_consulta      = cd_consulta,
  @cd_item_consulta = cd_item_consulta
from
  deleted

delete from produto_estampo 
where 
  @cd_consulta      = cd_consulta and 
  @cd_item_consulta = @cd_item_consulta



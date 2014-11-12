CREATE TABLE [dbo].[Grupo_Produto] (
    [cd_grupo_produto]               INT          NOT NULL,
    [nm_grupo_produto]               VARCHAR (40) NULL,
    [nm_fantasia_grupo_produto]      CHAR (15)    NULL,
    [sg_grupo_produto]               CHAR (10)    NULL,
    [cd_mascara_grupo_produto]       VARCHAR (20) NULL,
    [pc_desconto_max_grupo_produto]  FLOAT (53)   NULL,
    [pc_desconto_min_grupo_produto]  FLOAT (53)   NULL,
    [pc_acrescimo_max_grupo_produto] FLOAT (53)   NULL,
    [pc_acrescimo_min_grupo_produto] FLOAT (53)   NULL,
    [cd_tipo_embalagem]              INT          NULL,
    [cd_agrupamento_produto]         INT          NULL,
    [cd_unidade_medida]              INT          NULL,
    [cd_tipo_grupo_produto]          INT          NULL,
    [cd_imagem]                      INT          NULL,
    [cd_status_grupo_produto]        INT          NULL,
    [cd_categoria_produto]           INT          NULL,
    [cd_status_produto]              INT          NULL,
    [cd_usuario]                     INT          NULL,
    [dt_usuario]                     DATETIME     NULL,
    [ic_controle_pcp_grupo]          CHAR (1)     NULL,
    [ic_mapa_placa_grupo]            CHAR (1)     NULL,
    [cd_tipo_mercado]                INT          NULL,
    [qt_mes_consumo_grupo]           INT          NULL,
    [cd_departamento]                INT          NULL,
    [cd_aplicacao_produto]           INT          NULL,
    [cd_plano_compra]                INT          NULL,
    [cd_tipo_requisicao]             INT          NULL,
    [ds_req_compra_grupo]            TEXT         NULL,
    [ic_garantia_grupo_produto]      CHAR (1)     NULL,
    [ic_rast_grupo_pedido]           CHAR (1)     NULL,
    [ic_lote_grupo_produto]          CHAR (1)     NULL,
    [qt_dia_garantia_grupo_pro]      INT          NULL,
    [ic_serie_grupo_produto]         CHAR (1)     NULL,
    [ic_rastreabi_grupo_pedido]      CHAR (1)     NULL,
    [cd_termo_garantia]              INT          NULL,
    [ic_mapa_placa_grupo_produ]      CHAR (1)     NULL,
    [ds_reqcompra_grupo_produt]      TEXT         NULL,
    [ic_importacao_grupo_produ]      CHAR (1)     NULL,
    [pc_impostoximp_grupo_prod]      FLOAT (53)   NULL,
    [cd_grupo_categoria]             INT          NULL,
    [pc_comissao_grupo_produto]      FLOAT (53)   NULL,
    [ic_especial_grupo_produto]      CHAR (1)     NULL,
    [qt_dia_orc_grupo_produto]       INT          NULL,
    [ic_sob_encomenda_produto]       CHAR (1)     NULL,
    [ic_volume_grupo_produto]        CHAR (1)     NULL,
    [ic_export_grupo_produto]        CHAR (1)     NULL,
    [ic_repos_grupo_produto]         CHAR (1)     NULL,
    [ic_transf_cust_grupo_prod]      CHAR (1)     NULL,
    [ic_processo_grupo_produto]      CHAR (1)     NULL,
    [ic_etiq_pcp_grupo_produto]      CHAR (1)     NULL,
    [ic_inspecao_grupo_produto]      CHAR (1)     NULL,
    [ic_qualid_grupo_produto]        CHAR (1)     NULL,
    [cd_moeda]                       INT          NULL,
    [ic_cnc_grupo_produto]           CHAR (1)     NULL,
    [ic_cotacao_grupo_produto]       CHAR (1)     NULL,
    [cd_plano_financeiro]            INT          NULL,
    [ic_dadotec_grupo_produto]       CHAR (1)     NULL,
    [cd_classe]                      INT          NULL,
    [ic_baixa_composicao_grupo]      CHAR (1)     NULL,
    [ic_dev_composicao_grupo]        CHAR (1)     NULL,
    [ic_composicao_grupo_prod]       CHAR (1)     NULL,
    [nm_proposta_grupo_produto]      VARCHAR (30) NULL,
    [nm_obs_proposta_grupo]          VARCHAR (80) NULL,
    [nm_pedido_grupo_produto]        VARCHAR (30) NULL,
    [nm_nota_grupo_produto]          VARCHAR (30) NULL,
    [qt_evolucao_grupo_produto]      FLOAT (53)   NULL,
    [ic_montagem_venda_grupo]        CHAR (1)     NULL,
    [ic_guia_trafego_grupo]          CHAR (1)     NULL,
    [ic_revenda_grupo_produto]       CHAR (1)     NULL,
    [cd_tipo_produto_espessura]      INT          NULL,
    [cd_propaganda]                  INT          NULL,
    [ds_tecnica_grupo_produto]       TEXT         NULL,
    [cd_mensagem_proposta]           INT          NULL,
    [cd_categoria_produto_exp]       INT          NULL,
    [ic_prototipo_grupo_prod]        CHAR (1)     NULL,
    [ic_desenv_grupo_prod]           CHAR (1)     NULL,
    [cd_promocao]                    INT          NULL,
    [ic_calculo_peso_grupo]          CHAR (1)     NULL,
    [cd_grupo_estoque]               INT          NULL,
    [cd_tipo_retalho]                INT          NULL,
    [ic_pcp_grupo_produto]           CHAR (1)     NULL,
    [ic_analise_grupo_produto]       CHAR (1)     NULL,
    [cd_sequencial_grupo_produto]    INT          NULL,
    [ic_kit_grupo_produto]           CHAR (1)     NULL,
    [ic_entrada_estoque_fat]         CHAR (1)     NULL,
    [sg_projeto_grupo_produto]       CHAR (10)    NULL,
    [ic_compra_mp_nao_smo]           CHAR (1)     NULL,
    [ic_controlar_montagem_pv]       CHAR (1)     NULL,
    [ic_mensagem_proposta_prod]      CHAR (1)     NULL,
    CONSTRAINT [PK_Grupo_Produto] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Produto_Grupo_Estoque] FOREIGN KEY ([cd_grupo_estoque]) REFERENCES [dbo].[Grupo_Estoque] ([cd_grupo_estoque]),
    CONSTRAINT [FK_Grupo_Produto_Grupo_Produto] FOREIGN KEY ([cd_mensagem_proposta]) REFERENCES [dbo].[Grupo_Produto] ([cd_grupo_produto]),
    CONSTRAINT [FK_Grupo_Produto_Propaganda] FOREIGN KEY ([cd_propaganda]) REFERENCES [dbo].[Propaganda] ([cd_propaganda]),
    CONSTRAINT [FK_Grupo_Produto_Tipo_Retalho] FOREIGN KEY ([cd_tipo_retalho]) REFERENCES [dbo].[Tipo_Retalho] ([cd_tipo_retalho])
);


GO

create trigger tD_grupo_produto
on Grupo_Produto
for delete 

as

--tD_grupo_produto
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Trigger: Microsoft SQL Server                2000
--Autor(es): Elias P. Silva
--Banco de Dados: EgisSql
--Objetivo: Trigger para exclusão do Grupo de Produtos e tabelas vinculadas
--Data: 19/07/2002
--Atualizado: 
---------------------------------------------------

begin

  declare @cd_grupo_produto int

  select
    @cd_grupo_produto = cd_grupo_produto
  from
    Deleted

  -- Não Permitir exclusão de Grupo caso exista um Produto Vinculado
  if exists(select 
              cd_produto 
            from 
              produto
            where 
              cd_grupo_produto = @cd_grupo_produto)
    raiserror('Exclusão não permitida! Existem produtos vinculados ao Grupo.', 16,1)
  else
    -- Apagar os registros correspondentes ao grupo nas outras tabelas
    begin

      print (cast(@cd_grupo_produto as varchar(3)))    

      delete from 
        Grupo_Produto_Contabilizacao 
      where
        cd_grupo_produto = @cd_grupo_produto

      delete from 
        Grupo_Produto_Crescimento
      where
        cd_grupo_produto = @cd_grupo_produto
    
      delete from 
        Grupo_Produto_Custo
      where
        cd_grupo_produto = @cd_grupo_produto

      delete from 
        Grupo_Produto_Departamento
      where
        cd_grupo_produto = @cd_grupo_produto
  
      delete from 
        Grupo_Produto_Fiscal
      where
        cd_grupo_produto = @cd_grupo_produto

      delete from 
        Grupo_Produto_Garantia
      where
        cd_grupo_produto = @cd_grupo_produto
  
      delete from 
        Grupo_Produto_Servico
      where
        cd_grupo_produto = @cd_grupo_produto

      delete from 
        Grupo_Produto_Tecnica
      where
        cd_grupo_produto = @cd_grupo_produto

    end

end

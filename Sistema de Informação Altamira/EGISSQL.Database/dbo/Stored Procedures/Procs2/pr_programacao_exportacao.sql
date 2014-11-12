
create procedure pr_programacao_exportacao
------------------------------------------------------------------------
--pr_programacao_exportacao
------------------------------------------------------------------------
--GBS - Global Business Solution Ltda	                            2004
------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Igor Gama
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta para Programação de Exportação de Pedidos
--Data		        : 23.03.2004
--Atualizacao           : 13/10/2004 - Inclusão de novos campos - ELIAS
--                      : 28/12/2004 - Acerto do cabeçalho - Sérgio Cardoso
----------------------------------------------------------------------------
@dt_inicial  		 datetime,
@dt_final    		 datetime,
@cd_pedido_venda int
as

--Busca a Fase do Produto de Importação

  declare @cd_fase_produto int

  select 
    @cd_fase_produto = cd_fase_produto
  from
   Parametro_Exportacao
  where
   cd_empresa = dbo.fn_empresa()


  select
    --Status 
    case
      when iv.dt_entrega_vendas_pedido < getdate() then 'S' else 'N' end as 'Atraso',

    'N' as 'EmbarqueTotal',   	--Falta implementação
    'N' as 'EmbarqueParcial', 	--Falta implementação
    'N' as 'Restricao',		--Falta implementação
    'N' as 'Desembaraco',	--Falta implementação
    'N' as 'Entreposto',	--Falta implementação

    --Dados

    iv.dt_entrega_vendas_pedido as 'Embarque',
    c.nm_fantasia_cliente       as 'Cliente',
    pv.dt_pedido_venda          as 'Emissao',
    iv.cd_pedido_venda          as 'Pedido',
    iv.cd_item_pedido_venda     as 'Item',
    p.nm_fantasia_produto       as 'Produto',
    p.nm_produto 		            as 'NomeProduto',
    iv.qt_item_pedido_venda     as 'Qtd',
    iv.qt_saldo_pedido_venda    as 'Saldo',
    iv.vl_unitario_item_pedido  as 'Valor', 
    --Saldo Total para Embarcar
    iv.qt_saldo_pedido_venda * iv.vl_unitario_item_pedido  as 'Total', 
    ps.qt_saldo_reserva_produto as 'Estoque',
    pa.nm_pais                  as 'Origem',
    tc.sg_termo_comercial       as 'Incoterm',
    mo.sg_moeda                 as 'Moeda',
    iv.ds_produto_pedido_venda	as 'ObsItem',
    iv.ds_observacao_fabrica    as 'ObsFab',
    pve.dt_prev_emb_ped_venda   as 'PrevEmbarque',
    ex.nm_fantasia              as 'Exportador',
    pd.nm_pais                  as 'Destino',
    ti.nm_tipo_importacao       as 'MetodoEmbarque',
    i.nm_idioma			            as 'Idioma',
    pv.cd_identificacao_empresa as 'IdentificacaoPV'
  from
    Pedido_Venda_item iv
      Inner Join 
    Pedido_Venda pv
      on iv.cd_pedido_venda = pv.cd_pedido_venda 
      Inner Join
    Pedido_Venda_Exportacao pve
      on pv.cd_pedido_venda = pve.cd_pedido_venda
      Left Outer Join
    Cliente c   
      on pv.cd_cliente = c.cd_cliente
      Left Outer Join
    Produto p
      on iv.cd_produto = p.cd_produto 
      Left Outer Join
    Produto_Saldo ps
      on iv.cd_produto = ps.cd_produto and
         ps.cd_fase_produto = @cd_fase_produto 
      Left Outer Join
    Pais pa
      on pve.cd_origem_pais = pa.cd_pais 
      Left Outer Join
    Termo_comercial tc
      on pve.cd_termo_comercial = tc.cd_termo_comercial 
      Left Outer Join
    Moeda mo
      on pv.cd_moeda = mo.cd_moeda 
      Left Outer Join
    Exportador ex
      on ex.cd_exportador = pv.cd_exportador
      Left Outer Join 
    Pais pd
      on pd.cd_pais = pve.cd_destino_pais
      Left Outer Join
    Tipo_Importacao ti
      on ti.cd_tipo_importacao = pve.cd_tipo_importacao
      Left Outer Join
    Idioma i
      on i.cd_idioma = pve.cd_idioma
      
  Where
    iv.dt_entrega_vendas_pedido between @dt_inicial and @dt_final 	and
    iv.dt_cancelamento_item is null and --Data  do Cancelamento        
    iv.qt_saldo_pedido_venda > 0 and --Saldo do Pedido para Embarque 
    (pv.cd_pedido_venda = @cd_pedido_venda or @cd_pedido_venda = 0)

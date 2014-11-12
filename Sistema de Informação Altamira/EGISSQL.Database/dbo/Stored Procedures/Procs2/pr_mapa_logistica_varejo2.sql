
-------------------------------------------------------------------------------
--pr_mapa_logistica_varejo2
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consultar dados para a grid de mapa logística de varejo.
--Data             : 03/08/2005
--Alteração        : 15/02/2006 Inclusao das Colunas qt_item_pedido_venda e nm_produto - Dirceu
------------------------------------------------------------------------------
create procedure pr_mapa_logistica_varejo2
@dt_inicial      datetime,
@dt_final        datetime,
@cd_pedido_venda int = 0,
@ic_Aberto       Char(1)  = 'N',
@ic_Emissao      Char(1)  = 'N',
@ic_Entrega      Char(1)  = 'N',
@ic_Atraso       Char(1)  = 'N'
as

	select 
		cast(0 as integer) as 'sel',	
		pv.cd_pedido_venda,
		cast( GetDate() - pvi.dt_entrega_vendas_pedido as int ) as 'Atraso',
		pvi.dt_entrega_vendas_pedido,
		pvi.cd_item_pedido_venda,
                pvi.qt_item_pedido_venda,
		ls.nm_local_saida,
  		ls.cd_local_saida,
  		c.nm_fantasia_cliente,
		c.cd_telefone,
		c.nm_endereco_cliente,
		c.nm_bairro,
		te.nm_tipo_endereco,
		tg.nm_tipo_entrega,
		tg.cd_tipo_entrega,
		lv.nm_obs_entrega,
		lv.ic_status_entrega,
		lv.ic_entrega,
      pvi.qt_saldo_pedido_venda,
      pvi.dt_item_pedido_venda,
		p.ic_compra_produto,
      p.nm_produto as 'Descricao',
      pvi.nm_produto_pedido as 'nm_produto_pedido',
      c.nm_fantasia_cliente as cliente,
   	pv.dt_alteracao_pedido_venda, 
		pv.nm_alteracao_pedido_venda,
   	pv.ic_alteracao_pedido_venda,
		pv.dt_pedido_venda  
	Into
	#Mapa_Logistica_Varejo
	from pedido_venda pv
	left outer join	pedido_venda_item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda
	left outer join logistica_varejo  lv  on lv.cd_pedido_venda = pv.cd_pedido_venda
 					      and lv.cd_item_pedido_venda = pvi.cd_item_pedido_venda
        left outer join local_saida       ls  on ls.cd_local_saida = lv.cd_local_saida	
   	left outer join cliente           c   on c.cd_cliente = pv.cd_cliente	
	left outer join tipo_endereco     te  on te.cd_tipo_endereco = pv.cd_tipo_endereco
	left outer join tipo_entrega      tg  on tg.cd_tipo_entrega = lv.cd_tipo_entrega
	left outer join produto		  p   on p.cd_produto = pvi.cd_produto

   where
	pv.cd_pedido_venda = ( case when @cd_pedido_venda = 0 then pv.cd_pedido_venda else @cd_pedido_venda end ) and
	pvi.dt_cancelamento_item is null                     

--Verifica Aberto
  if @ic_aberto = 'S'
  begin  
       Print 'Aberto'
		 Delete #Mapa_Logistica_Varejo
       Where isnull(cast(qt_saldo_pedido_venda as int),0) <= 0        

  end

  if @ic_Emissao = 'S'
  begin
       Print 'Emissao'
 		 Delete #Mapa_Logistica_Varejo
 		 where dt_item_pedido_venda is null or
				 (dt_item_pedido_venda not between @dt_inicial and @dt_final )
			     
  end

  if @ic_Entrega = 'S'
  begin
       Print 'Entrega'
		 Delete #Mapa_Logistica_Varejo
		 where dt_entrega_vendas_pedido is null or 
				(dt_entrega_vendas_pedido not between @dt_inicial and @dt_final)
  end

  if @ic_Atraso = 'S'
  begin
       Print 'Atraso'
 		 Delete #Mapa_Logistica_Varejo
		 Where  not((isnull( cast(qt_saldo_pedido_venda as int) ,0) > 0) and (Atraso > 0))
              or dt_entrega_vendas_pedido is null
  end

  if not(@ic_Atraso = 'S'  or @ic_Entrega = 'S' or @ic_Emissao = 'S' or @ic_Aberto = 'S')
  begin  
       Print 'Data'
		 Delete #Mapa_Logistica_Varejo
		 where dt_pedido_venda is null or (dt_pedido_venda not between @dt_inicial and @dt_final )
  end

  Select * from #Mapa_Logistica_Varejo
  order by cd_pedido_venda



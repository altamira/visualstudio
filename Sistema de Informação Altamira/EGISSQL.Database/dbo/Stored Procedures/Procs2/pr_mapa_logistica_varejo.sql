
-------------------------------------------------------------------------------
--pr_mapa_logistica_varejo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes / Vagner do Amaral
--Banco de Dados   : EgisSQL
--Objetivo         : Mapa de Logística de Varejo
--
--Data             : 15/07/2005
--Atualizado       : 04/08/2005 - Apresentar composição quando for kit.
--                 : 28.03.2006 - Acertos diversos - Carlos Fernandes.
--                 : 30.03.2006 - Acertos diveros - Carlos Fernandes.
--                 : 28.04.2006 - Local de entrega Default do Pedido de Venda - Elias.
--
--------------------------------------------------------------------------------------------------
create procedure pr_mapa_logistica_varejo
@dt_inicial      datetime,
@dt_final        datetime,
@cd_pedido_venda int = 0,
@ic_Aberto       Char(1)  = 'N',
@ic_Emissao      Char(1)  = 'N',
@ic_Entrega      Char(1)  = 'N',
@ic_Atraso       Char(1)  = 'N'
as

  
--select * from pedido_venda
--select * from pedido_venda_item
--select * from pedido_venda_composicao
--select * from loja
--select * from movimento_caixa_item
--select * from movimento_caixa
--select * from Tipo_Local_Entrega
--select * from requisicao_compra_item
--select * from pedido_compra_item
--select * from nota_entrada_item
--select cd_fase_produto_baixa,* from produto

declare @cd_fase_produto int

--select * from pedido_compra_item
--select dt_entrega_item_ped_compr,* from Pedido_Venda_item
--Pedido_Compra_Item -- dt_entrega_item_ped_compr
--select  * from fornecedor


select @cd_fase_produto = cd_fase_produto
from
  Parametro_Comercial
where
  cd_empresa = dbo.fn_empresa()

--Gera uma tabela auxiliar com os dados da requisição de compra

-- select
--   rci.cd_pedido_venda,
--   rci.cd_item_pedido_venda,
--   rci.cd_requisicao_compra,
--   rci.cd_item_requisicao_compra,
--   rci.dt_item_nec_req_compra,
--   rci.cd_pedido_compra,
--   rci.cd_item_pedido_compra
-- into
--   #ItemRequisicao
-- from
--   Pedido_Venda pv
--   inner join Pedido_Venda_Item pvi on pvi.cd_pedido_venda = pv.cd_pedido_venda
--   left outer join Requisicao_Compra_Item rci  on rci.cd_pedido_venda       = pvi.cd_pedido_venda and
--                                                  rci.cd_item_pedido_venda  = pvi.cd_item_pedido_venda
-- 
-- where
--   pv.cd_pedido_venda = ( case when @cd_pedido_venda = 0 then pv.cd_pedido_venda else @cd_pedido_venda end ) and
--   pv.dt_pedido_venda between @dt_inicial and @dt_final and
--   pvi.dt_cancelamento_item is null                     and
--   isnull(pvi.qt_saldo_pedido_venda,0)>0 	       

-- select * from    #ItemRequisicao
-- order by
--   cd_pedido_venda,cd_item_pedido_venda



Select distinct
   case when isnull(pv.cd_modalidade,0)=0 then isnull(lv.cd_tipo_local_entrega,pv.cd_tipo_local_entrega) else pv.cd_modalidade end as cd_modalidade,  
   cast(tle.nm_tipo_local_entrega as varchar(60))                                as nm_modalidade,   
   IDENTITY ( int,1,1 )                                   as 'chave',
   cast(0 as integer)                                     as 'sel',
   l.nm_fantasia_loja,
   pv.dt_pedido_venda,
   pv.cd_pedido_venda,
   pvi.cd_item_pedido_venda,
   pvi.qt_item_pedido_venda,
   pvi.qt_saldo_pedido_venda,
   pvi.dt_item_pedido_venda,
   ps.qt_saldo_reserva_produto,
   fs.nm_fase_produto,
   pvi.dt_entrega_vendas_pedido,
   cast( GetDate() - pvi.dt_entrega_vendas_pedido as int ) as dtPrevista,
   dbo.fn_mascara_produto(p.cd_produto)                    as 'CodigoProduto',		
   p.nm_fantasia_produto                                   as 'Produto',
   --select * from Produto_Saldo
   isnull(ps.qt_saldo_atual_produto,0)                     as 'SaldoAtual',
   isnull(ps.qt_minimo_produto,0)                          as 'Minimo',
   isnull(ps.qt_maximo_produto,0)                          as 'Maximo', 
   p.nm_produto                                            as 'Descricao',

--   case when isnull(pvc.cd_produto,0) = 0 then 
--          (select pvi.nm_fantasia_produto from Produto where pvi.cd_produto = cd_produto)
--        else pro.nm_fantasia_produto 
--   end					                   as 'Produto',
--   case when isnull(pvc.cd_produto,0) = 0 then 
--          (select pvi.nm_produto_pedido from Produto where pvi.cd_produto = cd_produto)
--        else pro.nm_produto
--   end					            	   as 'Descricao',

   tle.nm_tipo_local_entrega,

    case when isnull(lv.cd_requisicao_compra,0) = 0 then
      rci.cd_requisicao_compra
    else 
      lv.cd_requisicao_compra
   end as cd_requisicao_compra,
   rci.cd_item_requisicao_compra,
   rci.dt_item_nec_req_compra,

   case when isnull(lv.cd_pedido_compra,0) = 0 then
      rci.cd_pedido_compra
    else 
      lv.cd_pedido_compra
   end as cd_pedido_compra,

   rci.cd_item_pedido_compra,
   pci.dt_entrega_item_ped_compr        as 'dt_entrega_item_ped_compr',
   f.nm_fantasia_fornecedor,
   nei.dt_item_receb_nota_entrad,
   nei.cd_nota_entrada,
   p.ic_compra_produto,
   p.cd_unidade_medida,
   um.nm_unidade_medida,
   p.cd_produto,
   p.cd_categoria_produto,
   tle.cd_tipo_local_entrega,
   pvc.cd_id_item_pedido_venda,                                                  
   pvi.nm_produto_pedido,
   c.nm_fantasia_cliente                as cliente,
   pv.dt_alteracao_pedido_venda, 
	pv.nm_alteracao_pedido_venda,
   pv.ic_alteracao_pedido_venda,
   nsi.cd_nota_saida,  
   nsi.cd_item_nota_saida,  
   nsi.dt_nota_saida,  
   nsi.qt_item_nota_saida   

into #tmp1                                                            

from
  Pedido_Venda pv
  left outer join Cliente  c                  on pv.cd_cliente             = c.cd_cliente
  inner join Pedido_Venda_Item pvi            on pvi.cd_pedido_venda       = pv.cd_pedido_venda
  left outer join Loja         l              on l.cd_loja                 = pv.cd_loja
  left outer join logistica_varejo      lv    on lv.cd_pedido_venda	   = pvi.cd_pedido_venda	and
						 lv.cd_item_pedido_venda   = pvi.cd_item_pedido_venda	
  left outer join Movimento_Caixa_Item   mci  on mci.cd_pedido_venda       = pvi.cd_pedido_venda and
                                                 mci.cd_item_pedido_venda  = pvi.cd_item_pedido_venda

  left outer join pedido_venda_composicao pvc on pvi.cd_pedido_venda       = pvc.cd_pedido_venda and pvi.cd_item_pedido_venda = pvc.cd_item_pedido_venda
  left outer join Produto      p              on p.cd_produto              = case 
                                                                            when (select count(*) from pedido_venda_composicao where cd_pedido_venda = pvi.cd_pedido_venda and cd_item_pedido_venda = pvi.cd_item_pedido_venda) > 0 then
                                                                              pvc.cd_produto 
                                                                            else
                                                                              pvi.cd_produto
                                                                            end  

  left outer join Requisicao_Compra_Item rci  on rci.cd_pedido_venda       = pvi.cd_pedido_venda      and
                                                 rci.cd_item_pedido_venda  = pvi.cd_item_pedido_venda and
                                                 rci.cd_produto            = case when (select count(*) from pedido_venda_composicao where cd_pedido_venda = pvi.cd_pedido_venda and cd_item_pedido_venda = pvi.cd_item_pedido_venda) > 0 then
                                                                              pvc.cd_produto 
                                                                            else
                                                                              pvi.cd_produto
                                                                            end  


  left outer join Pedido_Compra_Item     pci  on pci.cd_requisicao_compra  = case 
									     when isnull(lv.cd_requisicao_compra,0) = 0 then 
          	  								rci.cd_requisicao_compra
							                     else 
										lv.cd_requisicao_compra
									     end
 						                             and  
                                                                                pci.cd_requisicao_compra_item = rci.cd_item_requisicao_compra
  
  left outer join Pedido_Compra          pc   on pc.cd_pedido_compra      = case 
									     when isnull(lv.cd_pedido_compra,0) = 0 then 
          	  								pci.cd_pedido_compra
							                     else 
                                    					  lv.cd_pedido_compra
									     end

  left outer join Fornecedor             f    on f.cd_fornecedor           = pc.cd_fornecedor
  left outer join Nota_Entrada_Item     nei   on nei.cd_pedido_compra      = pc.cd_pedido_compra and
                                                 nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
  left outer join Produto_Saldo         ps    on ps.cd_produto             = pvi.cd_produto   and
                                                 ps.cd_fase_produto        = @cd_fase_produto --and
						 --ps.cd_loja		   = l.cd_loja
  left outer join Fase_Produto          fs    on fs.cd_fase_produto        = @cd_fase_produto

  left outer join Unidade_medida        um    on p.cd_unidade_medida       = um.cd_unidade_medida
  -- left outer join produto 		pro   on pro.cd_produto		   = pvc.cd_produto
  left outer join Tipo_Local_Entrega     tle  on tle.cd_tipo_local_entrega = case 
									     when isnull(lv.cd_tipo_local_entrega,0) = 0 then 
          	  								pv.cd_tipo_local_entrega
							                     else 
										  lv.cd_tipo_local_entrega
									     end	
  --Nota Fiscal  
  --Verificar se o item foi Faturado  
  left outer join Nota_Saida_Item       nsi  on nsi.cd_pedido_venda      = pv.cd_pedido_venda       and  
                                                nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda and  
                                                nsi.cd_produto           = pvi.cd_produto     
  
where
  pv.cd_pedido_venda = ( case when @cd_pedido_venda = 0 then pv.cd_pedido_venda else @cd_pedido_venda end ) and
  pvi.dt_cancelamento_item is null                     and
  isnull(p.ic_compra_produto,'N') = 'S'	

order by
  pv.dt_pedido_venda


  if @ic_aberto = 'S'
  begin  
       Print 'Aberto'
		 Delete #tmp1
       Where isnull(cast(qt_saldo_pedido_venda as int),0) <= 0        

  end

  if @ic_Emissao = 'S'
  begin
       Print 'Emissao'
 		 Delete #tmp1
 		 where dt_item_pedido_venda not between @dt_inicial and @dt_final 
			    or dt_item_pedido_venda is null

  end

  if @ic_Entrega = 'S'
  begin
       Print 'Entrega'
		 Delete #tmp1
		 where dt_entrega_vendas_pedido not between @dt_inicial and @dt_final 
	    or dt_entrega_vendas_pedido is null

  end

  if @ic_Atraso = 'S'
  begin
       Print 'Atraso'
 		 Delete #tmp1
		 Where  not((isnull( cast(qt_saldo_pedido_venda as int) ,0) > 0) and (dtPrevista > 0))
              or dt_entrega_vendas_pedido is null
  end

  if @ic_Atraso = 'N'  or @ic_Entrega = 'N' or @ic_Emissao = 'N' or @ic_Aberto = 'N'
  begin  
		 Delete #tmp1
		 where dt_pedido_venda not between @dt_inicial and @dt_final 
	    or dt_pedido_venda is null
  end

select * from #tmp1
order by cd_pedido_venda
--order by dt_item_pedido_venda
--chave

--select * from pedido_compra_item

update pedido_compra_item 
set 
 dt_entrega_item_ped_compr = ''
where dt_entrega_item_ped_compr =01-01-1900


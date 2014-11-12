
-------------------------------------------------------------------------------
--pr_analise_grupo_cliente_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 20/01/2005
--Atualizado       : 28/01/2005
--                 : 01.09.2005 - Conversão de Unidade - Carlos/Robson
--                 : 06/09/2005 - Qtd. Convertida - Carlos Fernandes
--                 : 27.11.2005 - Bairro do Cliente
--------------------------------------------------------------------------------------------------
create procedure pr_analise_grupo_cliente_produto
@cd_cliente_grupo int = 0,
@dt_inicial       datetime,
@dt_final         datetime,
@parametro	  int = 0
as

--select * from cliente_grupo
--select * from pedido_venda_item
--select * from Loja
--select * from produto_saldo
--select * from produto_unidade_medida
--select * from cliente

declare @cd_fase_produto int,
	@sql varchar(8000)

set @cd_fase_produto = 0

select @cd_fase_produto = cd_fase_produto 
from
  Parametro_Comercial
where
  cd_empresa = dbo.fn_empresa()


select
  gc.nm_cliente_grupo              		as Grupo,
  cast(pv.ds_observacao_pedido as varchar(8000))as Observacao,
  cast(gc.ds_cliente_grupo as varchar(8000))	as ObsGrupo,
  gc.cd_cliente_grupo		   		as CodGrupo,
  c.nm_fantasia_cliente            		as Cliente,
  c.nm_razao_social_cliente			as Razao,
  cd.nm_cidade					as Cidade,
  c.nm_bairro                                   as Bairro,
  --isnull(l.cd_numero_loja,sg_loja) as Numero, 
  pv.cd_pedido_venda		   		as Pedido,	
  pvi.cd_item_pedido_venda         		as Item,
  pvi.dt_entrega_vendas_pedido			as DataEntrega,
  p.cd_mascara_produto             		as CodigoProduto,
  p.nm_fantasia_produto            		as Fantasia,
  p.nm_produto                     		as Produto,
  p.cd_produto                     		as Codigo,
  case when dbo.fn_conversao_unidade_medida(p.cd_produto,p.cd_unidade_medida,pvi.qt_saldo_pedido_venda,0)>0
  then umc.sg_unidade_medida 
  else  
       um.sg_unidade_medida end    as Unidade,
  pvi.qt_saldo_pedido_venda        as Saldo,
  ps.qt_saldo_reserva_produto      as Estoque,
  dbo.fn_conversao_unidade_medida(p.cd_produto,p.cd_unidade_medida,pvi.qt_saldo_pedido_venda,0) as QtdConvertida,
  ' '                              as Caixa,
  ' '                              as Pacote
into #AnaliseGrupoCliente                           
from
  Pedido_Venda_Item pvi 
  inner join Pedido_Venda pv        on pv.cd_pedido_venda     = pvi.cd_pedido_venda
  left outer join cliente c         on c.cd_cliente           = pv.cd_cliente 
  left outer join cidade cd	    on cd.cd_cidade	      = c.cd_cidade
  left outer join cliente_grupo gc  on gc.cd_cliente_grupo    = c.cd_cliente_grupo
  left outer join loja l            on l.cd_loja              = c.cd_loja  
  left outer join produto p         on p.cd_produto           = pvi.cd_produto
  left outer join unidade_medida um on um.cd_unidade_medida   = p.cd_unidade_medida
  left outer join produto_saldo ps  on ps.cd_produto          = pvi.cd_produto and
                                       ps.cd_fase_produto     = @cd_fase_produto
  left outer join produto_unidade_medida pum on pum.cd_produto = p.cd_produto and
                                                pum.cd_unidade_origem = p.cd_unidade_medida
  left outer join unidade_medida umc on umc.cd_unidade_medida = pum.cd_unidade_destino

where
  gc.cd_cliente_grupo = case when isnull(@cd_cliente_grupo,0) = 0 then isnull(gc.cd_cliente_grupo,0) else @cd_cliente_grupo end and
  pvi.dt_entrega_vendas_pedido between @dt_inicial and @dt_final and
--  pv.dt_pedido_venda between @dt_inicial and @dt_final and
  isnull(pvi.qt_saldo_pedido_venda,0)>0                and
  pvi.dt_cancelamento_item is null                     and
  isnull(ic_ativo_cliente_grupo,'N') = 'S' 

declare @vl_total_produto float

set @vl_total_produto = 0 

--Valor Total por Cliente
select
  Cliente,
  sum( isnull(Saldo,0) ) as TotalCliente
into #TotalCliente
from
  #AnaliseGrupoCliente
group by
  Cliente

--Valor Total de Produto

select
  @vl_total_produto = sum( isnull(Saldo,0) )
from
  #AnaliseGrupoCliente

set @sql = 	'select
  			a.Grupo,
  			a.CodGrupo,
  			a.Codigo,
  			a.Observacao,	
  			--a.Numero,
  			a.Cliente,
			a.Razao,
                        max(a.Bairro) as Bairro,
			a.Cidade,
  			a.Pedido,
 			a.Fantasia,
  			a.Unidade,
			a.DataEntrega,
			a.ObsGrupo,
  			--sum( isnull(a.Saldo,0) )         as Saldo,
  			max( a.Estoque )                 as Estoque,
  			sum(tc.TotalCliente)             as TotalCliente,
  			sum( case when 	isnull(a.QtdConvertida,0)<>0 then 
					isnull(a.QtdConvertida,0) else 
					isnull(a.Saldo,0) end ) as Saldo,
  			max( a.Caixa )                   as Caixa,
  			max( a.Pacote )                  as Pacote
		from
  			#AnaliseGrupoCliente a
  			inner join #TotalCliente tc on tc.cliente = a.cliente

		group by a.Grupo, a.Codigo, a.Cliente, a.Observacao, a.Fantasia, a.Unidade, a.CodGrupo, a.Pedido, a.DataEntrega, a.ObsGrupo,a.Cidade,a.Razao'

set @sql = @sql + case when isnull(@parametro,0) = 0
			then
				' order by a.grupo, a.cliente, a.pedido '
			else
				' order by a.grupo, a.fantasia'
			end
	 	
exec(@sql)


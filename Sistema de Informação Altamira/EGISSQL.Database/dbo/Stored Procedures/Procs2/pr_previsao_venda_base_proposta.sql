
-------------------------------------------------------------------------------
--pr_previsao_venda_base_proposta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Forcast
--                   Mapa de Previsão de Vendas com Base nas Propostas Comerciais
--Data             : 28/01/2005
--Atualizado       : 28/01/2005
--                   01/02/2005 - Inclusão de Serviço / Produto - Daniel C. Neto.
--                   01/02/2005 - Acerto para mostrar os dados corretos - Carlos. 
--------------------------------------------------------------------------------------------------
create procedure pr_previsao_venda_base_proposta
@cd_categoria_produto int,
@dt_inicial           datetime,
@dt_final             datetime	

as

select distinct
  v.nm_fantasia_vendedor                             as Vendedor,
  c.nm_fantasia_cliente                              as Cliente,
  co.dt_consulta                                     as Emissao,
  case when ci.dt_entrega_consulta is null then co.dt_consulta else ci.dt_entrega_consulta end as DataPrevista,
  cp.nm_categoria_produto                            as Categoria, 
  cp.pc_desconto_categoria                           as MargemNegociacao,
  ci.qt_item_consulta * ci.vl_unitario_item_consulta as Valor,
  IsNull(s.nm_servico, p.nm_fantasia_produto)        as ServicoProduto
  
into
   #Previsao

from
  Consulta co
  left outer join Vendedor          v  on v.cd_vendedor           = co.cd_vendedor
  left outer join Cliente           c  on c.cd_cliente            = co.cd_cliente
  left outer join Consulta_Itens    ci on ci.cd_consulta          = co.cd_consulta 
  left outer join Categoria_produto cp on cp.cd_categoria_produto = ci.cd_categoria_produto
  left outer join Servico s            on s.cd_servico = ci.cd_servico
  left outer join Produto p            on p.cd_produto = ci.cd_produto 

where
  co.dt_consulta between @dt_inicial and @dt_final and
  ci.dt_fechamento_consulta is null                and
  isnull(ci.cd_pedido_venda,0) = 0                 and
  isnull(ci.ic_item_perda_consulta,'N')='N'        and
  isnull(cp.cd_categoria_produto,0) = case when isnull(@cd_categoria_produto,0) = 0 then isnull(cp.cd_categoria_produto,0) else isnull(@cd_categoria_produto,0) end

declare @vl_total_previsto float

set @vl_total_previsto = 0

select @vl_total_previsto = isnull(sum(valor),0) from #Previsao

--select @vl_total_previsto

select
  *,
  (Valor/@vl_total_previsto)*100                           as Percentual,
  --Meses conforme a Data Prevista
  case when month(DataPrevista) = 1  then Valor else 0 end as Janeiro,
  case when month(DataPrevista) = 2  then Valor else 0 end as Fevereiro,
  case when month(DataPrevista) = 3  then Valor else 0 end as Marco,
  case when month(DataPrevista) = 4  then Valor else 0 end as Abril,
  case when month(DataPrevista) = 5  then Valor else 0 end as Maio,
  case when month(DataPrevista) = 6  then Valor else 0 end as Junho,
  case when month(DataPrevista) = 7  then Valor else 0 end as Julho,
  case when month(DataPrevista) = 8  then Valor else 0 end as Agosto,
  case when month(DataPrevista) = 9  then Valor else 0 end as Setembro,
  case when month(DataPrevista) = 10 then Valor else 0 end as Outubro,
  case when month(DataPrevista) = 11 then Valor else 0 end as Novembro,
  case when month(DataPrevista) = 12 then Valor else 0 end as Dezembro

from
  #Previsao
order by
  Vendedor,
  DataPrevista,
  Valor desc
  
--select * from consulta
--select * from consulta_itens
--select * from categoria_produto
--update consulta_itens set cd_categoria_produto = 11
--update consulta_itens set dt_entrega_consulta      = '03/31/2005'

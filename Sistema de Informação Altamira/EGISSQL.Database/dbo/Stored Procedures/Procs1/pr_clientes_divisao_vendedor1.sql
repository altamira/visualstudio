

/****** Object:  Stored Procedure dbo.pr_clientes_divisao_vendedor1    Script Date: 13/12/2002 15:08:14 ******/
--pr_clientes_divisao_vendedor1
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Clientes por Mapa Geográfico Dividido por Vendedor
--Data       : 24.01.2001
--Atualizado : 23.09.2002 - Migração bco. EGIS - DUELA
-----------------------------------------------------------------------------------
CREATE procedure pr_clientes_divisao_vendedor1

@cd_vendedor      int,
@dt_inicial       datetime,
@dt_final         datetime

AS

--Monta uma tabela com todos os clientes das regiões divididas
select cli.nm_divisao_area      as 'Mapa',
       cli.nm_fantasia_cliente  as 'Cliente',
       r.nm_regiao              as 'Regiao',
       v.nm_fantasia_vendedor   as 'Setor',
       cli.dt_cadastro_cliente  as 'Cadastro',
       e.sg_estado              as 'Estado',
       c.nm_cidade              as 'Cidade'
into
   #Cliente_Vendedor
from
   Cliente cli
left outer join Regiao r
  on r.cd_regiao=cli.cd_regiao
left outer join Vendedor v
  on v.cd_vendedor=cli.cd_vendedor
left outer join Estado e
  on e.cd_estado=cli.cd_estado
left outer join Cidade c
  on c.cd_cidade=cli.cd_cidade
left outer join Divisao_Regiao dr
  on dr.nm_divisao_regiao=cli.nm_divisao_area
left outer join Divisao_Area_Vendedor dav
  on dav.cd_geomapa=dr.cd_grupo_div_regiao
where
--   dav.cd_vendedor = @cd_vendedor
   cli.cd_vendedor=@cd_vendedor                         
group by cli.nm_fantasia_cliente, cli.nm_divisao_area, r.nm_regiao, v.nm_fantasia_vendedor,
         cli.dt_cadastro_cliente, c.nm_cidade, e.sg_estado
order by 1

-- (%) de Expectativa de Crescimento  ( Futuramente um Tabela de Parâmetros no Cadastro Empresa )
declare @pc_crescimento float 
set @pc_crescimento = 1.20

-- Qtd. de Meses para Cálculo da Média conforme datas que o usuário informa
declare @qt_mes_media int 
set     @qt_mes_media = ( month(@dt_final) - month(@dt_inicial) ) + 1

select cli.nm_divisao_area                    as 'Mapa',
       cli.nm_fantasia_cliente                as 'Cliente',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)                   as 'TotalVendas',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)/@qt_mes_media     as 'MediaMensal',
       sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido) * @pc_crescimento as 'Crescimento',
      (sum(pvi.qt_item_pedido_venda*pvi.vl_unitario_item_pedido)*@pc_crescimento )/@qt_mes_media   
                                              as 'MediaMensalCrescimento'
into #RegClienteAux
from
   Cliente cli
left outer join Pedido_Venda pv
  on pv.cd_cliente=cli.cd_cliente
left outer join Pedido_Venda_Item pvi
  on pvi.cd_pedido_venda=pv.cd_pedido_venda
left outer join Divisao_Regiao dr
  on dr.nm_divisao_regiao=cli.nm_divisao_area
left outer join Divisao_Area_Vendedor dav
  on dav.cd_geomapa=dr.cd_grupo_div_regiao
where
--   dav.cd_vendedor=@cd_vendedor                           and
   cli.cd_vendedor=@cd_vendedor                           and
  (pv.dt_pedido_venda between @dt_inicial and @dt_final ) and
  (pv.dt_cancelamento_pedido is null )                    and
  (pvi.dt_cancelamento_item is null )                     and
   pvi.ic_smo_item_pedido_venda = 'N'   
Group by nm_divisao_area, cli.nm_fantasia_cliente
Order by 1

--Montagem da Tabela final com a posicao do Cliente com o Valor de Venda Maior

select a.regiao,
       a.cliente,
       a.setor, 
       a.cidade,
       a.estado,
       a.cadastro,
       b.totalvendas,
       b.mediamensal,
       b.crescimento,
       b.mediamensalcrescimento
into #RegCliente
from
   #Cliente_Vendedor a, #RegclienteAux b 
where a.cliente *= b.cliente
Order by 
    b.TotalVendas desc

select IDENTITY(int,1,1) as 'Posicao',
       a.* 
into #TabelaFinal
from #RegCliente a
--order by a.TotalVendas desc

-- Mostra a tabela final

select * from #TabelaFinal
order by
   posicao




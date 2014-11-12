
CREATE PROCEDURE pr_resumo_previsao_venda
@ic_parametro int = 0,
@dt_inicial   datetime,
@dt_final     datetime

as

--select * from previsao_venda

-------------------------------------------------------------------------------
--Cliente
-------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  select
     c.nm_fantasia_cliente                    as Cliente, 
     sum(isnull(pv.qt_programado_previsao,0)) as Programado,
     sum(isnull(pv.qt_potencial_previsao,0))  as Potencial,
     cast( 0 as float )                       as Realizado,
     cast( 0 as float )                       as PercAtingido
  into
    #AuxPrevCliente
  from
    Previsao_Venda pv
    left outer join Cliente c on c.cd_cliente = pv.cd_cliente
  group by
    c.nm_fantasia_cliente

  select
    *
  from
    #AuxPrevCliente
  order by
    Programado desc

end

-------------------------------------------------------------------------------
--Vendedor
-------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  select
     v.nm_fantasia_vendedor                   as Vendedor, 
     sum(isnull(pv.qt_programado_previsao,0)) as Programado,
     sum(isnull(pv.qt_potencial_previsao,0))  as Potencial,
     cast( 0 as float )                       as Realizado,
     cast( 0 as float )                       as PercAtingido
  into
    #AuxPrevVendedor
  from
    Previsao_Venda pv
    left outer join Vendedor v on v.cd_vendedor = pv.cd_vendedor
  group by
    v.nm_fantasia_vendedor

  select
    *
  from
    #AuxPrevVendedor
  order by
    Programado desc

end

-------------------------------------------------------------------------------
--Produto
-------------------------------------------------------------------------------

if @ic_parametro = 3
begin

  select
     p.cd_mascara_produto                     as Codigo,
     p.nm_fantasia_produto                    as Produto, 
     max(p.nm_produto)                        as Descricao,
     max(um.sg_unidade_medida)                as Sigla,
     sum(isnull(pv.qt_programado_previsao,0)) as Programado,
     sum(isnull(pv.qt_potencial_previsao,0))  as Potencial,
     cast( 0 as float )                       as Realizado,
     cast( 0 as float )                       as PercAtingido
  into
    #AuxPrevProduto
  from
    Previsao_Venda pv
    left outer join Produto p         on p.cd_produto = pv.cd_produto
    left outer join Unidade_Medida um on um.cd_unidade_medida = p.cd_unidade_medida
  group by
    p.cd_mascara_produto,
    p.nm_fantasia_produto
    

  select
    *
  from
    #AuxPrevProduto
  order by
    Programado desc

end




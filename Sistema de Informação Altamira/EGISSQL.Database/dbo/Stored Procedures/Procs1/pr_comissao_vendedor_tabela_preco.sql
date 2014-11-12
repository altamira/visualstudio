
-------------------------------------------------------------------------------
--sp_helptext pr_comissao_vendedor_tabela_preco
-------------------------------------------------------------------------------
--pr_comissao_vendedor_tabela_preco
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Comissão de Vendedores por Tabela de Preço
--
--Data             : 17.04.2009
--Alteração        : 28.04.2009 - Acertos diversos para cálculo correto - Carlos Fernandes
--
-- 06.05.2009 - Verificação - Carlos Fernandes
-------------------------------------------------------------------------------------------
create procedure pr_comissao_vendedor_tabela_preco
@ic_parametro int      = 0,
@cd_vendedor  int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@pc_comissao  float    = 0

as


--select * from vw_venda_bi
--select * from tabela_preco_produto

--set @ic_parametro = 1


--select * from nota_saida_item

-------------------------------------------------------------------------------------------
--Resumo
-------------------------------------------------------------------------------------------
if @ic_parametro = 0
begin
  print 'resumo'

  select
    identity(int,1,1)                        as cd_controle,
    vw.cd_vendedor,
    isnull(tpp.pc_comissao_tabela_produto,0) as pc_comissao,
  
    max(v.nm_vendedor)                  as nm_vendedor,
    max(v.nm_fantasia_vendedor)         as nm_fantasia_vendedor,
--  max(tpp.pc_comissao_tabela_produto) as pc_comissao,
    sum(vw.qt_item_pedido_venda)        as qt_produto,
    sum(vw.qt_item_pedido_venda *
        vw.vl_unitario_item_pedido)     as vl_total

  into
    #Tabela_Comissao_Resumo

  from 
    vw_venda_bi vw                            with (nolock) 
    left outer join vendedor v                with (nolock) on v.cd_vendedor       = vw.cd_vendedor
    left outer join tabela_preco_produto  tpp with (nolock) on tpp.cd_tabela_preco = vw.cd_tabela_preco and
                                                               tpp.cd_produto      = vw.cd_produto
    inner join nota_saida_item nsi            with (nolock) on nsi.cd_pedido_venda = vw.cd_pedido_venda and
                                                               nsi.cd_item_pedido_venda = vw.cd_item_pedido_venda
  where
    vw.cd_vendedor = case when @cd_vendedor = 0 then vw.cd_vendedor else @cd_vendedor end and
    vw.dt_pedido_venda between @dt_inicial and @dt_final and
    vw.ic_bonificacao_pedido_venda = 'N'
    and vw.dt_cancelamento_item    is null
    and nsi.dt_restricao_item_nota is null

--select * from vw_venda_bi

  group by
    vw.cd_vendedor,
    isnull(tpp.pc_comissao_tabela_produto,0)


  --Mostra a Tabela 

  select
    cd_vendedor,
    nm_fantasia_vendedor,
    nm_vendedor,
    sum(vl_total)                     as vl_total,    
    sum((pc_comissao/100) * vl_total) as vl_comissao
  into #Aux

  from 
    #Tabela_Comissao_Resumo
  group by
    cd_vendedor,
    nm_fantasia_vendedor,
    nm_vendedor

  select
    *
  from
    #Aux
  order by
    nm_fantasia_vendedor

end

-------------------------------------------------------------------------------------------
--Resumo
-------------------------------------------------------------------------------------------

if @ic_parametro = 1
begin

  select
    identity(int,1,1)                        as cd_controle,
    vw.cd_vendedor,
    isnull(tpp.pc_comissao_tabela_produto,0) as pc_comissao,
  
    max(v.nm_vendedor)                       as nm_vendedor,
    max(v.nm_fantasia_vendedor)              as nm_fantasia_vendedor,
--  max(tpp.pc_comissao_tabela_produto) as pc_comissao,
    sum(vw.qt_item_pedido_venda)             as qt_produto,
    sum(vw.qt_item_pedido_venda *
        vw.vl_unitario_item_pedido)          as vl_total

  into
    #Tabela_Comissao

  from 
    vw_venda_bi vw                            with (nolock) 
    left outer join vendedor v                with (nolock) on v.cd_vendedor       = vw.cd_vendedor
    left outer join tabela_preco_produto  tpp with (nolock) on tpp.cd_tabela_preco = vw.cd_tabela_preco and
                                                               tpp.cd_produto      = vw.cd_produto
    inner join nota_saida_item nsi            with (nolock) on nsi.cd_pedido_venda = vw.cd_pedido_venda and
                                                               nsi.cd_item_pedido_venda = vw.cd_item_pedido_venda
  where
    vw.cd_vendedor = case when @cd_vendedor = 0 then vw.cd_vendedor else @cd_vendedor end and
    vw.dt_pedido_venda between @dt_inicial and @dt_final and
    vw.ic_bonificacao_pedido_venda = 'N'
    and vw.dt_cancelamento_item    is null
    and nsi.dt_restricao_item_nota is null
--select * from vw_venda_bi

  group by
    vw.cd_vendedor,
    isnull(tpp.pc_comissao_tabela_produto,0)

  --Mostra a Tabela 

  select
    *,
    (pc_comissao/100) * vl_total as vl_comissao
  from 
    #Tabela_Comissao

end


-------------------------------------------------------------------------------------------
--Analítico por (%)
-------------------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  select
    identity(int,1,1)                   as cd_controle,
    vw.cd_vendedor,
    v.nm_vendedor                                            as nm_vendedor,
    v.nm_fantasia_vendedor                                   as nm_fantasia_vendedor,
 
    tp.nm_tabela_preco,
    tp.sg_tabela_preco,
    isnull(tpp.pc_comissao_tabela_produto,0.00)              as pc_comissao,
  
    vw.cd_pedido_venda,
    vw.dt_pedido_venda,
    vw.nm_fantasia_cliente,
    vw.cd_mascara_produto,
    vw.nm_fantasia_produto,
    vw.nm_produto,
    vw.qt_item_pedido_venda                                  as qt_produto,
    vw.vl_unitario_item_pedido,
                             
    vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido     as vl_total,

    --Cálculo da Comissão
    round((vw.qt_item_pedido_venda * vw.vl_unitario_item_pedido) *
    (isnull(tpp.pc_comissao_tabela_produto,0.00) / 100 ),2)  as vl_comissao

  into
    #Tabela_Comissao_Analitico

  from 
    vw_venda_bi vw                            with (nolock) 
    left outer join vendedor v                with (nolock) on v.cd_vendedor       = vw.cd_vendedor

    left outer join tabela_preco_produto  tpp with (nolock) on tpp.cd_tabela_preco = vw.cd_tabela_preco and
                                                               tpp.cd_produto      = vw.cd_produto

    left outer join tabela_preco          tp  with (nolock) on tp.cd_tabela_preco  = vw.cd_tabela_preco

    inner join nota_saida_item nsi            with (nolock) on nsi.cd_pedido_venda = vw.cd_pedido_venda and
                                                               nsi.cd_item_pedido_venda = vw.cd_item_pedido_venda
  where
    vw.cd_vendedor = case when @cd_vendedor = 0 then vw.cd_vendedor else @cd_vendedor end and
    vw.dt_pedido_venda between @dt_inicial and @dt_final                                  and
    isnull(tpp.pc_comissao_tabela_produto,0.00)  = @pc_comissao                           and
    vw.ic_bonificacao_pedido_venda = 'N'
    and vw.dt_cancelamento_item    is null
    and nsi.dt_restricao_item_nota is null


--select * from vw_venda_bi

  select
    *
  from
    #Tabela_Comissao_Analitico
  order by
    dt_pedido_venda     
  
end


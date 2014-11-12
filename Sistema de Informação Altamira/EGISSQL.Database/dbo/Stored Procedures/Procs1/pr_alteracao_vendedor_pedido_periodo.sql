
-------------------------------------------------------------------------------
--sp_helptext pr_alteracao_vendedor_pedido_periodo
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
--
-------------------------------------------------------------------------------------------
create procedure pr_alteracao_vendedor_pedido_periodo
@ic_parametro        int      = 0,
@cd_vendedor_origem  int      = 0,
@cd_vendedor_destino int      = 0,
@dt_inicial          datetime = '',
@dt_final            datetime = ''

as

-------------------------------------------------------------------------------------------
--Mostra os Pedidos de Venda
-------------------------------------------------------------------------------------------

if @ic_parametro = 1
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

  where
    vw.cd_vendedor = case when @cd_vendedor_origem = 0 then vw.cd_vendedor else @cd_vendedor_origem end and
    vw.dt_pedido_venda between @dt_inicial and @dt_final                                                and
    vw.ic_bonificacao_pedido_venda = 'N'
    
  select
    *
  from
    #Tabela_Comissao_Analitico
  order by
    dt_pedido_venda     
    

end

-------------------------------------------------------------------------------------------
--
-------------------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  update
    pedido_venda
  set
    cd_vendedor = @cd_vendedor_destino
  from
    pedido_venda 
  where
    cd_vendedor = @cd_vendedor_origem
end




CREATE PROCEDURE pr_produto_previsao_entrada

@cd_produto int       = 0,
@dt_inicial datetime  = '',
@dt_final   datetime  = ''

as
-------------------------------------------------------------------------------
--pr_produto_previsao_entrada
-------------------------------------------------------------------------------
--GBS - Global Business Sollution                                          2004
-------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000
--Autor(es)             : Daniel C. Neto.
--Banco de Dados        : EGISSQL
--Objetivo              : - Mostrar a previsão de entrada de pedidos de compra
--                          e de pedidos de importação por produto.
--Data                  : 03/10/2003
--Atualizado            : 16/03/2004 - Eduardo - Não estava trazendo os Pedidos previstos por
--                         causa de um erro no filtro   
--                       - Johnny - Correção para trazer pedidos de compra, importaçao e produção
--                      : 10/12/2004 - Acerto no Cabeçalho - Sérgio Cardoso
--                      : 17.06.2005 - Busca Especial das Previsões Lançadas manualmente - Carlos Fernandes
--                      : 13/04/2006 - Ajuste para Buscar TODOS os PCs em Aberto como Previsão e não
--                          somente os PCs até a data atual - ELIAS
--                      : 08.05.2006 - Apresentar informações de estoque da fase "Entreposto" caso configurada
-- 06.11.2008 - Ajustes Diversos - Carlos Fernandes
-- 16.03.2009 - Complemento / Verificação - Carlos Fernades
-- 05.05.2009 - Verificação dos pedidos que estão atendidos via alocação - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------

Declare @cd_fase_produto_entreposto int,
        @cd_fase_produto            int

--Define fases

  Select top 1
     @cd_fase_produto_entreposto  = isnull(cd_fase_produto_entreposto,0)
  from
    Parametro_Estoque with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()
  
  Select top 1
     @cd_fase_produto  = isnull(cd_fase_produto,0)
  from
    Parametro_Comercial with (nolock) 
  where
    cd_empresa = dbo.fn_empresa()

  --Pedido de Compra

  select
    IDENTITY(int,1,1) as 'Item',
    ped.cd_produto,
    ped.Data,
    ped.nm_tipo,
    ped.Saldo
  into
    #PrevisaoEntrada
  from
   (select
      cd_produto,
      dt_entrega_item_ped_compr as 'Data',
      'PC-' + cast(pci.cd_pedido_compra as varchar)+'-'+cast(pci.cd_item_pedido_compra as varchar) as nm_tipo,
      qt_saldo_item_ped_compra as Saldo
    from
      Pedido_Compra_Item pci               with (nolock)
      left outer join Requisicao_Compra rc with (nolock)
        on pci.cd_requisicao_compra = rc.cd_requisicao_compra
      left outer join Tipo_Requisicao tr   with (nolock)
        on tr.cd_tipo_requisicao = rc.cd_tipo_requisicao
    where
      cd_Produto = @cd_produto and
      IsNull(tr.cd_fase_produto,@cd_fase_produto) = @cd_fase_produto and
      dt_item_canc_ped_compra is null and
      qt_saldo_item_Ped_compra > 0 and
      dt_entrega_item_ped_compr is not null
      --dt_entrega_item_ped_compr >= getdate()
  
  union  

  --Pedido de Importação
  
  select 
    pii.cd_produto,
    pii.dt_entrega_ped_imp as 'Data',
    'PI-' 
    + cast(pii.cd_pedido_importacao as varchar) + '-' 
    + cast(pii.cd_item_ped_imp as varchar)      as nm_tipo,
    pii.qt_saldo_item_ped_imp  as Saldo
  from 
    Pedido_Importacao_Item 	pii      with (nolock) 
    left outer join Requisicao_Compra rc with (nolock) on pii.cd_requisicao_compra = rc.cd_requisicao_compra
    left outer join Tipo_Requisicao tr   with (nolock) on tr.cd_tipo_requisicao = rc.cd_tipo_requisicao
  where
    pii.cd_produto = @cd_produto and
    IsNull(tr.cd_fase_produto,@cd_fase_produto) = @cd_fase_produto and
    pii.dt_cancel_item_ped_imp is null and
    pii.qt_saldo_item_ped_imp > 0 and
    pii.dt_entrega_ped_imp is not null
    --pii.dt_entrega_ped_imp >= getdate()

  union

  --Processo de Produção

  select 
    pp.cd_produto,
    isnull(pp.dt_entrega_processo,pp.dt_processo) as 'Data',
    'OP-' + cast(pp.cd_processo as varchar)       as nm_tipo,
    pp.qt_planejada_processo                      as Saldo
  from 
    Processo_Producao pp with (nolock)
  where
    pp.cd_produto = @cd_produto and
    pp.cd_status_processo not in (5,6) and 
    isnull(pp.dt_entrega_processo,pp.dt_processo) is not null       
    --and
    --pp.dt_entrega_processo >= getdate()

  --Carlos 17.06.2005
  --Lançamento Manual Direto na Tabela de Produto
  
  union

  select
    p.cd_produto,
    p.dt_ped_comp_imp1   as 'Data',
    'Lanc. Manual'                     as nm_tipo,
    p.qt_ped_comp_imp1   as Saldo
  from
    Produto_Saldo p with (nolock)
  where
    p.cd_produto = @cd_produto and
    p.cd_fase_produto = @cd_fase_produto and
--    p.dt_ped_comp_imp1 >= getdate() and
    isnull(p.qt_ped_comp_imp1,0) > 0
  union

  select
    p.cd_produto,
    p.dt_ped_comp_imp2   as 'Data',
    'Lanc. Manual'                     as nm_tipo,
    p.qt_ped_comp_imp2   as Saldo
  from
    Produto_Saldo p with (nolock)
  where
    p.cd_produto      = @cd_produto and
    p.cd_fase_produto = @cd_fase_produto and
--    p.dt_ped_comp_imp2 >= getdate() and
    isnull(p.qt_ped_comp_imp2,0) > 0 

union

  select
    p.cd_produto,
    p.dt_ped_comp_imp3   as 'Data',
    'Lanc. Manual'                     as nm_tipo,
    p.qt_ped_comp_imp3   as Saldo
  from
    Produto_Saldo p with (nolock)
  where
    p.cd_produto = @cd_produto and
    p.cd_fase_produto = @cd_fase_produto and
--    p.dt_ped_comp_imp3 >= getdate() and
    isnull(p.qt_ped_comp_imp3,0) > 0 


  --Fabio Cesar 08.05.2006
  --Lançamento Na Produto_Saldo para Entreposto
  
  union

  select
    p.cd_produto,
    p.dt_ped_comp_imp1   as 'Data',
    'EE'                 as nm_tipo,
    p.qt_ped_comp_imp1   as Saldo
  from
    Produto_Saldo p with (nolock)
  where
    p.cd_produto = @cd_produto and
    p.cd_fase_produto = @cd_fase_produto_entreposto and
    isnull(p.qt_ped_comp_imp1,0) > 0
  union

  select
    p.cd_produto,
    p.dt_ped_comp_imp2   as 'Data',
    'EE'                     as nm_tipo,
    p.qt_ped_comp_imp2   as Saldo
  from
    Produto_Saldo p with (nolock)
  where
    p.cd_produto = @cd_produto and
    p.cd_fase_produto = @cd_fase_produto_entreposto and
    isnull(p.qt_ped_comp_imp2,0) > 0 

union

  select
    p.cd_produto,
    p.dt_ped_comp_imp3   as 'Data',
    'EE'                     as nm_tipo,
    p.qt_ped_comp_imp3   as Saldo
  from
    Produto_Saldo p with (nolock)
  where
    p.cd_produto      = @cd_produto and
    p.cd_fase_produto = @cd_fase_produto_entreposto and
    isnull(p.qt_ped_comp_imp3,0) > 0 
UNION
  select
      cd_produto,
      dt_entrega_item_ped_compr 'Data',
      '(Entreposto) PC -' + cast(pci.cd_pedido_compra as varchar)+'-'+cast(pci.cd_item_pedido_compra as varchar) as nm_tipo,
      qt_saldo_item_ped_compra as Saldo
    from
      Pedido_Compra_Item pci               with (nolock)
      left outer join Requisicao_Compra rc with (nolock)
        on pci.cd_requisicao_compra = rc.cd_requisicao_compra
      left outer join Tipo_Requisicao tr   with (nolock)
        on tr.cd_tipo_requisicao = rc.cd_tipo_requisicao
    where
      cd_Produto = @cd_produto and
      IsNull(tr.cd_fase_produto,@cd_fase_produto) = @cd_fase_produto_entreposto and
      dt_item_canc_ped_compra is null and
      qt_saldo_item_Ped_compra > 0 --and
) as ped

  select 
    * 
  from 
    #PrevisaoEntrada 
  order by 
    Data

  drop table 
    #PrevisaoEntrada


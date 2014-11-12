
CREATE PROCEDURE pr_ordem_recebimento_compra

@dt_inicial       datetime = 0 ,
@dt_final         datetime = 0,
@cd_pedido_compra int      = 0

AS

declare @loc         as varchar(25)
declare @cd_produto  as integer
declare @localizacao as varchar(25)

set @loc         = '' 
set @cd_produto  = 0
set @localizacao = ''


-------------------------------------------------------------------
--Consulta somente pedidos dentro do período, 
--não cancelados e com saldo do item do pedido maior que 0 (zero)
--Filtrado pelo Período
--que ainda não foram impressos
-------------------------------------------------------------------

--select * from fornecedor
--select * from pedido_compra_item
declare @cd_fase_produto int

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial with (nolock)
where
  cd_empresa = dbo.fn_empresa()

  select
    pci.cd_pedido_compra, 
    pc.dt_pedido_compra,
    pci.cd_item_pedido_compra, 
    isnull(pci.ic_ordrec_pedido_compra,'N')  as ic_ordrec_pedido_compra,
    case when 
      cast(pci.dt_entrega_item_ped_compr as int) - cast(pc.dt_pedido_compra as int)  <=
      (select distinct qt_dia_imediato_empresa from Parametro_Comercial) then 
      1 else 0 end as 'ic_imediato',
    pci.dt_entrega_item_ped_compr, 
    cast(pci.dt_entrega_item_ped_compr as int) - cast(getdate()as int) as 'qt_dias',
    tep.nm_tipo_entrega_produto,
    f.nm_razao_social,
    f.nm_fantasia_fornecedor, 
    f.cd_cep                                                           as 'cd_cep_fornecedor',
    pc.cd_transportadora,
    t.nm_fantasia                                                      as 'nm_fantasia_transportadora',
    pci.qt_item_pedido_compra, 
    pci.vl_item_unitario_ped_comp,
    p.cd_fase_produto_baixa,
    isnull(pci.vl_item_unitario_ped_comp, 0) * isnull(pci.qt_item_pedido_compra, 0) as vl_total_item,
    isnull(pci.qt_saldo_item_ped_compra,0) as qt_saldo_item_ped_compra,       
    case when isnull(pci.cd_produto,0)>0 and isnull(p.cd_fase_produto_baixa,0)>0 then
      case when isnull(p.cd_produto_baixa_estoque,0)>0 then
           isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps with (nolock) 
                   where ps.cd_produto=p.cd_produto_baixa_estoque and ps.cd_fase_produto = p.cd_fase_produto_baixa ),0) 
      else
          isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps with (nolock) 
          where ps.cd_produto=pci.cd_produto and ps.cd_fase_produto = p.cd_fase_produto_baixa ),0) 
      end
    else
      case when isnull(pci.cd_produto,0)>0 and isnull(p.cd_fase_produto_baixa,0)=0 then
           case when isnull(p.cd_produto_baixa_estoque,0)>0 then
              isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps with (nolock) 
                      where ps.cd_produto=p.cd_produto_baixa_estoque and ps.cd_fase_produto = @cd_fase_produto ),0) 
           else
              isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps with (nolock) 
              where ps.cd_produto=pci.cd_produto and ps.cd_fase_produto = @cd_fase_produto ),0) 
           end
      else
        0.00 end 
    end as 'qt_saldo_atual_produto',
    pci.nm_fantasia_produto, 
    pci.cd_produto, 
    dbo.fn_produto_localizacao(pci.cd_produto, case when isnull(p.cd_fase_produto_baixa,0)=0 then @cd_fase_produto
                                               else p.cd_fase_produto_baixa end ) as 'Localizacao',
    nei.cd_nota_entrada,
    nei.dt_item_receb_nota_entrad,
    nei.cd_item_nota_entrada,
    nei.qt_item_nota_entrada,
    ci.nm_fantasia_comprador,
    cp.nm_condicao_pagamento
  into 
    #SEPARACAO1
  from
    Pedido_compra_Item pci                    with (nolock) 
    right outer join Pedido_compra pc         with (nolock) on pc.cd_pedido_compra       = pci.cd_pedido_compra 
    left outer join  Produto p                with (nolock) on p.cd_produto              = pci.cd_produto 
    left outer join  Grupo_Produto gp         with (nolock) on gp.cd_grupo_produto       = p.cd_grupo_produto
    left outer join  Nota_Entrada_Item nei    with (nolock) on nei.cd_pedido_compra      = pci.cd_pedido_compra and
                                                               nei.cd_item_pedido_compra = pci.cd_item_pedido_compra and
                                                               nei.cd_fornecedor         = pc.cd_fornecedor

    left outer join  Transportadora t         with (nolock) on t.cd_transportadora        = pc.cd_transportadora
    left outer join  Tipo_Entrega_Produto tep with (nolock) on pc.cd_tipo_entrega_produto = tep.cd_tipo_entrega_produto
    left outer join  Fornecedor f             with (nolock) on f.cd_fornecedor            = pc.cd_fornecedor
    Left outer join  Comprador ci             with (nolock) On ci.cd_comprador            = pc.cd_comprador
    left outer join  Condicao_pagamento cp    with (nolock) On cp.cd_condicao_pagamento   = pc.cd_condicao_pagamento 
  where
    pci.cd_pedido_compra = case when @cd_pedido_compra = 0 then pci.cd_pedido_compra else @cd_pedido_compra end and
    (pci.dt_entrega_item_ped_compr BETWEEN @dt_inicial AND @dt_final) AND 
    (pc.dt_cancel_ped_compra     is null)  and 
     pci.dt_item_canc_ped_compra is null   and
    (pci.qt_saldo_item_ped_compra > 0) and
    isnull(pci.ic_ordrec_pedido_compra,'N')  <>'S' and
    --isnull(gp.ic_especial_grupo_produto,'N')<>'S' and --somente os grupos padronizados ( Especial não Entra )
    isnull(pc.ic_fechado_pedido_compra,'N')='S' -- and --somente pedidos fechados

  order by
    pc.cd_pedido_compra, pci.cd_item_pedido_compra

  --select * from pedido_compra
  --select * from pedido_compra_item
  --select * from nota_entrada_item

  -- Fim da Seleção Geral 
  Select * from #Separacao1 order by Localizacao, cd_pedido_compra, cd_item_pedido_compra

  --Limpando Tabela Temporária
  drop table #Separacao1




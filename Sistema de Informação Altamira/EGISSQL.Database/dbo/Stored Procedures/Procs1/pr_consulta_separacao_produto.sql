
CREATE PROCEDURE pr_consulta_separacao_produto

@dt_inicial      datetime,
@dt_final        datetime,
@cd_pedido_venda int      = 0

AS

if @cd_pedido_venda is null
   set @cd_pedido_venda = 0

--select * from parametro_estoque

declare @loc                    varchar(25)
declare @cd_produto             integer
declare @localizacao            varchar(25)
declare @ic_liberacao_separacao char(1) 

set @loc                    = '' 
set @cd_produto             = 0
set @localizacao            = ''
set @ic_liberacao_separacao = 'N'

select
  @ic_liberacao_separacao = isnull(ic_liberacao_separacao,'N')
from
  parametro_estoque with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

--select @cd_pedido_venda,@dt_inicial,@dt_final

--select * from pedido_venda_item_separacao

-------------------------------------------------------------------
--Consulta somente pedidos dentro do período, 
--não cancelados e com saldo do item do pedido maior que 0 (zero)
--Filtrado pelo Período
--que ainda não foram impressos
-------------------------------------------------------------------
--select ic_ordsep_pedido_venda,* from pedido_venda_item

  select
    pvi.cd_pedido_venda, 
    pv.dt_pedido_venda,
    pvi.cd_item_pedido_venda, 
    pvi.ic_ordsep_pedido_venda,
    ns.cd_status_nota,
    case when 
      cast(pvi.dt_entrega_vendas_pedido as int) - cast(pv.dt_pedido_venda as int)  <=
      (select distinct qt_dia_imediato_empresa from Parametro_Comercial) then 
      1 else 0 end as 'ic_imediato',
    pvi.dt_entrega_vendas_pedido, 
    cast(pvi.dt_entrega_vendas_pedido as int) - cast(getdate()as int) as 'qt_dias',
    tep.nm_tipo_entrega_produto,
    c.nm_razao_social_cliente,
    c.nm_fantasia_cliente, 
    c.cd_cep as 'cd_cep_cliente',
    pv.cd_transportadora,
    t.nm_fantasia as 'nm_fantasia_transportadora',
    pvi.qt_item_pedido_venda, 
    pvi.vl_unitario_item_pedido,
    isnull(pvi.vl_unitario_item_pedido, 0) * isnull(pvi.qt_item_pedido_venda, 0) as vl_total_item,
    pvi.qt_saldo_pedido_venda,       
    case when isnull(pvi.cd_produto,0)>0 and isnull(p.cd_fase_produto_baixa,0)>0 then
      case when isnull(p.cd_produto_baixa_estoque,0)>0 then
           isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps
                   where ps.cd_produto=p.cd_produto_baixa_estoque and ps.cd_fase_produto = p.cd_fase_produto_baixa ),0) 
      else
          isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps
          where ps.cd_produto=pvi.cd_produto and ps.cd_fase_produto = p.cd_fase_produto_baixa ),0) 
      end
    else
      case when isnull(pvi.cd_produto,0)>0 and isnull(p.cd_fase_produto_baixa,0)=0 then
           case when isnull(p.cd_produto_baixa_estoque,0)>0 then
              isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps
                      where ps.cd_produto=p.cd_produto_baixa_estoque and ps.cd_fase_produto = pc.cd_fase_produto ),0) 
           else
              isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps
              where ps.cd_produto=pvi.cd_produto and ps.cd_fase_produto = pc.cd_fase_produto ),0) 
           end
      else
        0.00 end 
    end                                                            as 'qt_saldo_atual_produto',
    pvi.nm_fantasia_produto, 
    pvi.dt_entrega_fabrica_pedido, 
    pvi.dt_reprog_item_pedido, 
    pvi.cd_produto, 
    dbo.fn_produto_localizacao(pvi.cd_produto, pc.cd_fase_produto) as 'Localizacao',
    pvi.nm_obs_restricao_pedido,
--    ns.cd_nota_saida,

    case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
    else
         ns.cd_nota_saida                  
    end                                                             as 'cd_nota_saida',

    ns.dt_nota_saida,
    nsi.cd_item_nota_saida,
    nsi.qt_item_nota_saida,
    ve.nm_fantasia_vendedor                                        as 'VendedorExterno',
    vi.nm_fantasia_vendedor                                        as 'VendedorInterno',
    cp.nm_condicao_pagamento,
    tp.sg_tipo_pedido,
    pvs.dt_liberacao_separacao
--    isnull(pvi.ic_ordsep_pedido_venda,'N')                         as ic_ordsep_pedido_venda
  into 
    #SEPARACAO1

  from
    Pedido_Venda_Item pvi                      with (nolock) 
    right outer join  Pedido_Venda pv          with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda 
    left outer join   Produto p                with (nolock) on p.cd_produto = pvi.cd_produto 
    left outer join   Grupo_Produto gp         with (nolock) on gp.cd_grupo_produto=pvi.cd_grupo_produto
    left outer join   Nota_Saida ns            with (nolock) on ns.cd_pedido_venda = pvi.cd_pedido_venda
    left outer join   Nota_Saida_Item nsi      with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida
    left outer join   Transportadora t         with (nolock) on t.cd_transportadora=pv.cd_transportadora
    left outer join   Tipo_Entrega_Produto tep with (nolock) on pv.cd_tipo_entrega_produto = tep.cd_tipo_entrega_produto
    left outer join   Cliente c                with (nolock) on pv.cd_cliente            = c.cd_cliente 
    left outer join   Parametro_Comercial pc   with (nolock) on pc.cd_empresa            = dbo.fn_empresa()
    Left outer join   Vendedor vi              with (nolock) On vi.cd_vendedor           = pv.cd_vendedor_interno
    Left outer join   Vendedor ve              with (nolock) On ve.cd_vendedor           = pv.cd_vendedor
    left outer join   Condicao_pagamento cp    with (nolock) On cp.cd_condicao_pagamento = pv.cd_condicao_pagamento 
    left outer join Tipo_Pedido tp                           on tp.cd_tipo_pedido        = pv.cd_tipo_pedido
    left outer join Pedido_Venda_Separacao pvs               on pvs.cd_pedido_venda      = pv.cd_pedido_venda and
                                                                pvs.cd_item_pedido_venda = pvi.cd_item_pedido_venda
--select * from tipo_pedido

  where
    pv.cd_pedido_venda = case when @cd_pedido_venda = 0 then pv.cd_pedido_venda else @cd_pedido_venda end and
    (pvi.dt_entrega_vendas_pedido BETWEEN case when @cd_pedido_venda = 0 then @dt_inicial else pvi.dt_entrega_vendas_pedido end and
                                          case when @cd_pedido_venda = 0 then @dt_final   else pvi.dt_entrega_vendas_pedido end ) AND 
    (pv.dt_cancelamento_pedido is null) and 
     pvi.dt_cancelamento_item  is null   and
    (pvi.qt_saldo_pedido_venda > 0) and
    isnull(pvi.ic_ordsep_pedido_venda,'N')   <> case when @cd_pedido_venda = 0 then 'S' else 'X' end and
    isnull(gp.ic_especial_grupo_produto,'N') <> 'S' and --somente os grupos padronizados ( Especial não Entra )
    isnull(pv.ic_fechado_pedido,'N')='S' -- and --somente pedidos fechados
    --Liberação de Crédito
    and pv.dt_credito_pedido_venda is not null
    and isnull(tp.ic_ordsep_tipo_pedido,'S')='S'

--select * from tipo_pedido
    
   --Carlos 05.06.2005
   --Trazer todos os registros independente de se estar faturado ( Nota Fiscal Emitida )
   -- and
   -- isnull(ns.cd_status_nota,1) not in (3,4,7)


  order by
    pv.cd_pedido_venda, 
    pvi.cd_item_pedido_venda


  --select * from #Separacao1

  -- Verifica se a Empresa opera com liberação

  if @ic_liberacao_separacao='S'
  begin
    --print 'separacao'
    --select * from pedido_venda_separacao
    --Deleta os pedidos de venda não Liberacao
    delete from #Separacao1 where dt_liberacao_separacao is null    
    
  end


  -- Fim da Seleção Geral 
  Select * from #Separacao1 order by Localizacao, cd_pedido_venda, cd_item_pedido_venda

  --Limpando Tabela Temporária
  drop table #Separacao1



-- --select * from pedido_venda
-- 
-- end
-- else
-- begin
-- 
--   select
--     pvi.cd_pedido_venda, 
--     pv.dt_pedido_venda,
--     pvi.cd_item_pedido_venda, 
--     pvi.ic_ordsep_pedido_venda,
--     ns.cd_status_nota,
--     case when 
--       cast(pvi.dt_entrega_vendas_pedido as int) - cast(pv.dt_pedido_venda as int)  <=
--       (select distinct qt_dia_imediato_empresa from Parametro_Comercial) then 
--       1 else 0 end as 'ic_imediato',
--     pvi.dt_entrega_vendas_pedido, 
--     cast(pvi.dt_entrega_vendas_pedido as int) - cast(getdate()as int) as 'qt_dias',
--     tep.nm_tipo_entrega_produto,
--     c.nm_razao_social_cliente,
--     c.nm_fantasia_cliente, 
--     c.cd_cep                                                 as 'cd_cep_cliente',
--     pv.cd_transportadora,
--     t.nm_fantasia                                                     as 'nm_fantasia_transportadora',
--     pvi.qt_item_pedido_venda, 
--     pvi.vl_unitario_item_pedido,
--     isnull(pvi.vl_unitario_item_pedido, 0) * isnull(pvi.qt_item_pedido_venda, 0) as vl_total_item,
--     pvi.qt_saldo_pedido_venda,       
--     case when isnull(pvi.cd_produto,0)>0 and isnull(p.cd_fase_produto_baixa,0)>0 then
--       case when isnull(p.cd_produto_baixa_estoque,0)>0 then
--            isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps
--                    where ps.cd_produto=p.cd_produto_baixa_estoque and ps.cd_fase_produto = p.cd_fase_produto_baixa ),0) 
--       else
--           isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps
--           where ps.cd_produto=pvi.cd_produto and ps.cd_fase_produto = p.cd_fase_produto_baixa ),0) 
--       end
--     else
--       case when isnull(pvi.cd_produto,0)>0 and isnull(p.cd_fase_produto_baixa,0)=0 then
--            case when isnull(p.cd_produto_baixa_estoque,0)>0 then
--               isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps
--                       where ps.cd_produto=p.cd_produto_baixa_estoque and ps.cd_fase_produto = pc.cd_fase_produto ),0) 
--            else
--               isnull((select ps.qt_saldo_atual_produto from Produto_Saldo ps
--               where ps.cd_produto=pvi.cd_produto and ps.cd_fase_produto = pc.cd_fase_produto ),0) 
--            end
--       else
--         0.00 end 
--     end as 'qt_saldo_atual_produto',
--     pvi.nm_fantasia_produto, 
--     pvi.dt_entrega_fabrica_pedido, 
--     pvi.dt_reprog_item_pedido, 
--     pvi.cd_produto, 
--     dbo.fn_produto_localizacao(pvi.cd_produto, pc.cd_fase_produto) as 'Localizacao',
--     pvi.nm_obs_restricao_pedido,
--     ns.cd_nota_saida,
--     ns.dt_nota_saida,
--     nsi.cd_item_nota_saida,
--     nsi.qt_item_nota_saida,
--     ve.nm_fantasia_vendedor as 'VendedorExterno',
--     vi.nm_fantasia_vendedor as 'VendedorInterno',
--     cp.nm_condicao_pagamento,
--     tp.sg_tipo_pedido
-- 
--   into 
--     #SEPARACAO2
--   from
--     Pedido_Venda_Item pvi with (nolock) 
--       right outer join 
--     Pedido_Venda pv       with (nolock) 
--       on pv.cd_pedido_venda = pvi.cd_pedido_venda 
--       left outer join 
--     Produto p             with (nolock) on p.cd_produto = pvi.cd_produto 
--       left outer join
--     Grupo_Produto gp      with (nolock) 
--       on gp.cd_grupo_produto=pvi.cd_grupo_produto
--       left outer join 
--     Nota_Saida ns         with (nolock)  
--       on ns.cd_pedido_venda = pvi.cd_pedido_venda
--       left outer join 
--     Nota_Saida_Item nsi 
--       on nsi.cd_nota_saida = ns.cd_nota_saida
--       left outer join 
--     Transportadora t
--       on t.cd_transportadora=pv.cd_transportadora
--       left outer join 
--     Tipo_Entrega_Produto tep 
--       on pv.cd_tipo_entrega_produto = tep.cd_tipo_entrega_produto
--       left outer join 
--     Cliente c 
--        on pv.cd_cliente = c.cd_cliente 
--        left outer join
--      Parametro_Comercial pc
--        on pc.cd_empresa = dbo.fn_empresa()
--        Left outer join 
--     Vendedor vi
--        On vi.cd_vendedor = pv.cd_vendedor_interno
--        Left outer join 
--     Vendedor ve
--        On ve.cd_vendedor = pv.cd_vendedor
--        left outer join
--     Condicao_pagamento cp
--        On cp.cd_condicao_pagamento = pv.cd_condicao_pagamento 
--     left outer join Tipo_Pedido tp on tp.cd_tipo_pedido = pv.cd_tipo_pedido
-- 
--   where
--     pv.cd_pedido_venda = case when @cd_pedido_venda = 0 then pv.cd_pedido_venda else @cd_pedido_venda end and
--     (pv.dt_cancelamento_pedido is null)    and 
--     pvi.dt_cancelamento_item is null       and
--     isnull(gp.ic_especial_grupo_produto,'N')<>'S' and --somente os grupos padronizados ( Especial não Entra )
--     isnull(pv.ic_fechado_pedido,'N') ='S'             -- and --somente pedidos fechados
--     
--     --Liberação de Crédito
--     and dt_credito_pedido_venda is not null
--     and isnull(tp.ic_ordsep_tipo_pedido,'S')='S'
-- 
--    --Carlos 05.06.2005
--    --Trazer todos os registros independente de se estar faturado ( Nota Fiscal Emitida )
--    -- and
--    -- isnull(ns.cd_status_nota,1) not in (3,4,7)
-- 
--   order by
--     pv.cd_pedido_venda, pvi.cd_item_pedido_venda
-- 
--   -- Fim da Seleção Geral 
--   Select * from #Separacao2 order by Localizacao, cd_pedido_venda, cd_item_pedido_venda
-- 
--   --Limpando Tabela Temporária
--   drop table #Separacao2
-- 
-- end

--mostra os pedidos de venda

--select * from pedido_venda_item where dt_entrega_vendas_pedido between '03/01/2009' and '03/31/2009'



CREATE PROCEDURE pr_nota_fiscal_sedex
@ic_parametro                   as int,
@cd_nota_saida                  as int,
@cd_sedex_nota_saida            as int,  -- ELIAS 17/06/2003
@cd_sedex_nota_saida_item       as int,
@qt_nota_saida                  as int,
@qt_peso_item_sedex_nota_saida  as float,
@nm_obs_item_sedex_nota_saida   as varchar(40), 
@cd_transportadora              as int,
@cd_estado                      as int,
@cd_usuario                     as int,
@dt_inicial                     as datetime,
@dt_final                       as datetime,
@vl_frete                       as float

AS

--declare @cd_sedex_nota_saida as int
declare @vl_frete_aux        as float
declare @cd_entregador       int  -- ELIAS 13/06/2003

  set @vl_frete_aux = 0

-------------------------------------------------------------------------------
if @ic_parametro = 1 -- Realiza a Consulta das Notas Fiscais habilitadas pra Envio via Sedex
-------------------------------------------------------------------------------
  begin
    select
      --ns.cd_nota_saida,
      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         ns.cd_nota_saida                  
      end                                   as 'cd_nota_saida',

      ns.dt_nota_saida,
      ns.qt_peso_bruto_nota_saida,
      ns.qt_peso_liq_nota_saida,
      cli.nm_fantasia_cliente,
      cli.nm_razao_social_cliente,
      vd.nm_fantasia_vendedor,
      case when Rtrim(IsNull(ns.nm_cidade_entrega,'')) = '' then ns.nm_cidade_nota_saida
      else ns.nm_cidade_entrega end as nm_cidade_entrega,
      e.cd_estado,
      case when LTRIM(IsNull(ns.sg_estado_entrega, '')) = '' then ns.sg_estado_nota_saida
      else ns.sg_estado_entrega end as sg_estado_entrega,
      ns.cd_transportadora,
      cast(isnull(tp.ic_sedex,'N') as char(1)) as 'ic_sedex',
      ns.vl_total,
      ns.cd_usuario,
      ns.dt_usuario,
      tp.nm_transportadora as 'nm_fantasia_transportadora',
      op.cd_mascara_operacao
    from Nota_Saida ns

    left outer join Cliente cli 
      on cli.cd_cliente=ns.cd_cliente
    left outer join Vendedor vd 
      on vd.cd_vendedor=ns.cd_vendedor
    left outer join Transportadora tp 
      on tp.cd_transportadora=ns.cd_transportadora
    left outer join Estado e
      on e.sg_estado = case when (isnull(ns.sg_estado_entrega,'') <> '') then
                         ns.sg_estado_entrega
                       else
                         ns.sg_estado_nota_saida
                       end and e.cd_pais = 1
    left outer join Sedex_Nota_Saida_Item snsi
      on snsi.cd_nota_saida=ns.cd_nota_saida 
    left outer join Operacao_Fiscal op
      on op.cd_operacao_fiscal = ns.cd_operacao_fiscal

    where
      (isnull(ns.ic_status_nota_saida,'Z') not in ('C', 'D')) and
      (ns.cd_nota_saida=@cd_nota_saida) or 
     ((@cd_nota_saida=0) and 
      (tp.ic_sedex='S') and          
      (isnull(ns.ic_sedex_nota_saida,'N') <> 'S') and
      (ns.dt_nota_saida between @dt_inicial and @dt_final ))
    order by
      /* ELIAS 16/06/2003 */
      ns.cd_nota_saida

  end

-------------------------------------------------------------------------------
if @ic_parametro = 2 -- Realiza a Consulta dos Item das Notas Fiscais habilitadas pra Envio via Sedex
-------------------------------------------------------------------------------
  begin

    select
--      nsi.cd_nota_saida,
      case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         ns.cd_nota_saida                  
      end                                   as 'cd_nota_saida',

      nsi.cd_item_nota_saida,
      nsi.qt_item_nota_saida,
      p.nm_fantasia_produto,
      p.nm_produto,
      pvi.cd_pedido_venda,
      pvi.cd_item_pedido_venda,
      pvi.qt_item_pedido_venda,
      pvi.qt_saldo_pedido_venda

    from 
      Nota_Saida_Item nsi
      inner join Nota_Saida ns      on ns.cd_nota_saida = nsi.cd_nota_saida  
      left outer join Produto p     on  p.cd_produto=nsi.cd_produto
--      left outer join Nota_Saida ns on ns.cd_nota_saida=nsi.cd_nota_saida  
      left outer join Pedido_Venda_Item pvi on pvi.cd_pedido_venda=nsi.cd_pedido_venda

    where nsi.cd_nota_saida=@cd_nota_saida
    order by 
     nsi.cd_nota_saida,
     nsi.cd_item_nota_saida
  end

-------------------------------------------------------------------------------
if @ic_parametro = 3 -- Geração de Remessa de Notas Fiscais para Entrega Via Sedex
-------------------------------------------------------------------------------
  begin
    -- Pega a ultima sequencia do movimento de estoque
    set @cd_sedex_nota_saida = 
        (select isnull(max(cd_sedex_nota_saida),0)
         from sedex_nota_saida)+1

    insert into Sedex_Nota_Saida
      (cd_sedex_nota_saida,
       dt_sedex_nota_saida,
       vl_total_sedex_nota_saida,
       ic_etiq_sedex_nota_saida,
       ic_lista_sedex_nota_saida,
       qt_peso_bruto_sedex_nota_saida,
       qt_peso_real_sedex_nota_saida,
       cd_usuario,
       dt_usuario,
       qt_nota_sedex_nota_saida,
       qt_pesobru_sedex_not_said,
       qt_peso_sedex_nota_sedex)
  values
    (@cd_sedex_nota_saida,
     getdate(),
     0,
     'S',
     'S',
     0,
     0,
     @cd_usuario,
     getdate(),
     @qt_nota_saida,
     0,
     0)
  end

-------------------------------------------------------------------------------
if @ic_parametro = 4 -- Geração de Remessa dos Itens das Notas Fiscais para Entrega Via Sedex
-------------------------------------------------------------------------------
  begin

    -- Pega a ultima sequencia do movimento de estoque

    set @cd_sedex_nota_saida = 
        (select isnull(max(cd_sedex_nota_saida),0)
         from sedex_nota_saida)

--   exec pr_calculo_valor_sedex 
--        @cd_transportadora, 
--        @cd_estado, 
--        @qt_peso_item_sedex_nota_saida,
--        @vl_frete=@vl_frete output

    insert into Sedex_Nota_Saida_Item
      (cd_sedex_nota_saida,
       cd_item_sedex_nota_saida,
       cd_nota_saida,
       qt_peso_item_sedex_nota_saida,
       vl_custo_sedex_nota_saida,
       nm_obs_item_sedex_nota_saida,
       cd_usuario,
       dt_usuario)
  values
    (@cd_sedex_nota_saida,
     @cd_sedex_nota_saida_item,
     @cd_nota_saida,
     @qt_peso_item_sedex_nota_saida,
     @vl_frete,
     @nm_obs_item_sedex_nota_saida, 
     @cd_usuario,
     getdate())

  -- Busca o código do entregador
  select
    @cd_entregador = cd_entregador
  from
    entregador
  where
    cd_transportadora = @cd_transportadora

  update 
    Nota_Saida 
  set 
    ic_sedex_nota_saida     = 'S',
    /* Atualiza também o Peso Real - ELIAS - 12/06/2003 */
    qt_peso_real_nota_saida = @qt_peso_item_sedex_nota_saida,
    /* Atualiza outros campos importantes de Saída - ELIAS 13/06/2003 */
    ic_entrega_nota_saida   = 'S',
    dt_entrega_nota_saida   = getDate(),	
    dt_saida_nota_saida     = getDate(),
    cd_entregador           = @cd_entregador,
    cd_usuario              = @cd_usuario,
    dt_usuario              = getDate()
  where 
    cd_nota_saida = @cd_nota_saida


  update Sedex_Nota_Saida 
  set vl_total_sedex_nota_saida=(select sum(vl_custo_sedex_nota_saida)
                                 from Sedex_Nota_Saida_Item
                                 where cd_sedex_nota_saida=@cd_sedex_nota_saida),
      qt_peso_real_sedex_nota_saida=(select sum(qt_peso_item_sedex_nota_saida) 
                                from Sedex_Nota_Saida_Item
                                where cd_sedex_nota_saida=@cd_sedex_nota_saida)
  where
    cd_sedex_nota_saida = @cd_sedex_nota_saida
  
  end

-------------------------------------------------------------------------------
if @ic_parametro = 5 -- Exclusão de NF de Remessa Gerada Anteriormente -- ELIAS 17/06/2003
-------------------------------------------------------------------------------
  begin

    delete from
      sedex_nota_saida_item
    where
      cd_sedex_nota_saida = @cd_sedex_nota_saida and
      cd_nota_saida       = @cd_nota_saida

    update 
      Nota_Saida 
    set 
      ic_sedex_nota_saida     = 'N',
      /* Atualiza também o Peso Real - ELIAS - 12/06/2003 */
      qt_peso_real_nota_saida = @qt_peso_item_sedex_nota_saida,
      /* Atualiza outros campos importantes de Saída - ELIAS 13/06/2003 */
      ic_entrega_nota_saida   = 'N',
      dt_entrega_nota_saida   = null,
      dt_saida_nota_saida     = null,
      cd_entregador           = null,
      cd_usuario              = @cd_usuario,
      dt_usuario              = getDate()
    where 
      cd_nota_saida = @cd_nota_saida


    update Sedex_Nota_Saida 
    set vl_total_sedex_nota_saida=(select sum(vl_custo_sedex_nota_saida)
                                   from Sedex_Nota_Saida_Item
                                   where cd_sedex_nota_saida=@cd_sedex_nota_saida),
        qt_peso_real_sedex_nota_saida=(select sum(qt_peso_item_sedex_nota_saida) 
                                  from Sedex_Nota_Saida_Item
                                  where cd_sedex_nota_saida=@cd_sedex_nota_saida),
        qt_sedex_nota_saida = (select count(cd_sedex_nota_saida)
                               from sedex_nota_saida_item
                               where cd_sedex_nota_saida = @cd_sedex_nota_saida),
        cd_usuario = @cd_usuario,
        dt_usuario = getDate()
    where
        cd_sedex_nota_saida = @cd_sedex_nota_saida

  
  end


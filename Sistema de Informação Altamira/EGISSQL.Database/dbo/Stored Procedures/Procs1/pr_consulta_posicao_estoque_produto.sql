CREATE PROCEDURE pr_consulta_posicao_estoque_produto
-------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Fabio Cesar
--Banco de Dados: Egissql
--Objetivo: Retorna informações sobre a posição de estoque do produto
--Data: 21.01.2003
--Alteração - 06/02/2003 - Inclusão de campos de valores(Custo Contábil, FOB e Fob Convertido) - Igor Gama-IT
--            22/04/2003 - Alteração da chamada a função fn_produto_localizacao que passa a 
--                         receber também a fase - ELIAS
--                         Formatação da máscara do produto utilizando a fn_formata_mascara - ELIAS
--            15/07/2003 - Incluído pesquisa pelo codigo do produto - Daniel C. Neto.
--            27/05/2004 - Otimização da SP - DANIEL DUELA
-- 18/08/2004 - Tratamento de IsNull no parâmetro de @nm_fantasia_produto - Daniel C. Neto.
-- 21.07.2005 - Grupo de Produto / Categoria do Produto - Carlos Fernandes
-- 13/04/2006 - Paulo Souza
--              Acrescentado à coluna Requisição de compras a quantidade de requisição
--              de importação e uma nova coluna para quantidade em pedido de importação
-- 25.09.2010 - Ajustes Diversos - Carlos Fernandes
-------------------------------------------------------------------------------
@cd_produto          int = 0,
@nm_fantasia_produto varchar(30) = '',
@cd_fase_produto     int,
@ic_tipo_pesquisa    char(1)

AS

--Monta Tabela com as previões de Entrada de Compra do Pedido
--select * from pedido_compra_item

select
  pci.cd_pedido_compra,
  pci.cd_produto,
  sum(pci.qt_saldo_item_ped_compra) as qt_saldo,
  --max(case when pci.dt_item_nec_ped_compra is null then pci.dt_item_pedido_compra else pci.dt_item_nec_ped_compra end )   as dt_entrega,
  max(pci.dt_item_nec_ped_compra)   as dt_entrega
into
  #PrevisaoCompraProdutoAux

from
  pedido_compra_item pci with (nolock)
where
  isnull(pci.qt_saldo_item_ped_compra,0)>0 and
  pci.cd_produto = case when @cd_produto = 0 then pci.cd_produto else @cd_produto end 
  and pci.dt_item_canc_ped_compra is null
  and pci.dt_item_nec_ped_compra  is not null

group by
  pci.cd_pedido_compra,
  pci.cd_produto

select
  identity(int,1,1)                 as cd_controle,
  *
into
  #PrevisaoCompraProduto
from
  #PrevisaoCompraProdutoAux
order by
  cd_produto,
  dt_entrega desc


--select * from   #PrevisaoCompraProduto

------------------------------------------------------------------------------------------
if @cd_produto <> 0 or @nm_fantasia_produto<>''    -- Consulta Saldo do Estoque do Produto Com Localização em estoque
------------------------------------------------------------------------------------------
begin

  select 
    p.cd_produto,
    rtrim(LTrim(dbo.fn_produto_localizacao(p.cd_produto,@cd_fase_produto)))  as 'Localizacao',  -- 22/04/2003
    case when IsNull(gp.cd_mascara_grupo_produto, '') = '' then 
      isnull(p.cd_mascara_produto, '')
    else 
      isnull(dbo.fn_mascara_produto(p.cd_produto),'') end as 'Mascara',
    p.nm_produto                              as 'Produto',
    p.nm_fantasia_produto                     as 'Produto_Fantasia', 
    p.nm_marca_produto                        as 'Marca', 
    gp.cd_mascara_grupo_produto,
    gp.nm_grupo_produto                       as 'Grupo',
    um.sg_unidade_medida                      as 'Medida',
    sp.nm_serie_produto                       as 'Serie',
    isnull(p.ic_controle_pcp_produto,'N')     as 'PCP_Produto',
    isnull(pc.ic_peps_produto,'N')            as 'PEPS_Produto',
    p.qt_dia_entrega_medio                    as 'Entrega_Medio',
    isnull(p.qt_peso_liquido,0.000)           as 'Peso_Bruto',
    isnull(p.qt_peso_bruto,0.000)             as 'Peso_Liquido',
    isnull(pc.vl_custo_produto,0.00)          as 'Unitario_Atual',
    isnull(pc.vl_custo_anterior_produto,0.00) as 'Unitario_Anterior',
    isnull(ps.qt_minimo_produto,0.00)         as 'Estoque_Min',
    isnull(ps.qt_maximo_produto,0.00)         as 'Estoque_Max',
    isnull(ps.qt_saldo_atual_produto,0.00)    as 'Saldo_Atual',
    isnull(ps.qt_saldo_reserva_produto,0.00)  as 'Saldo_Disponivel',
    isnull(ps.qt_implantacao_produto,0.00)    as 'Saldo_Implantacao',
    isnull(ps.qt_terceiro_produto,0.00)       as 'Saldo_Terceiro',
    isnull(ps.qt_consig_produto,0.00)         as 'Saldo_Consignacao',
    isnull(ps.qt_consumo_produto,0.00)        as 'Saldo_Consumo',
--    isnull(ps.qt_req_compra_produto,0.00)     as 'Saldo_Requisicao',
    isnull(ps.qt_pd_compra_produto,0.00)      as  'Saldo_Pedido_Compra',
    isnull(ps.qt_importacao_produto,0.00)     as 'Saldo_Importacao',
    isnull(ps.qt_minimo_imp_produto,0.00)     as 'Saldo_Min_Importacao',
    ps.dt_terceiro_produto                    as 'Data_Saldo_Terceiro',
    ps.dt_consig_produto                      as 'Data_Saldo_Consignacao',
    isnull(ps.qt_prev_ent1_produto,0.00)      as 'Qtd1_Prev_Entrada',
    isnull(ps.qt_prev_ent2_produto,0.00)      as 'Qtd2_Prev_Entrada',
    isnull(ps.qt_prev_ent3_produto,0.00)      as 'Qtd3_Prev_Entrada',
    ps.dt_prev_ent1_produto                   as 'Data1_Prev_Entrada',
    ps.dt_prev_ent2_produto                   as 'Data2_Prev_Entrada',
    ps.dt_prev_ent3_produto                   as 'Data3_Prev_Entrada',
    case when (sp.ic_import_serie_produto='S' or gp.ic_importacao_grupo_produ='S') then
      'S' 
    else 
      'N' end                                 as 'Importado_produto', --Indica se é importado ou não,
    ps.dt_ultima_entrada_produto              as 'Data_Ult_Entrada',
    ps.dt_ultima_saida_produto                as 'Data_Ult_Saida',
    ps.cd_ped_comp_imp1,
    ps.cd_ped_comp_imp2,
    ps.cd_ped_comp_imp3,
    ps.qt_ped_comp_imp1,
    ps.qt_ped_comp_imp2,
    ps.qt_ped_comp_imp3,
    ps.dt_ped_comp_imp1,
    ps.dt_ped_comp_imp2,
    ps.dt_ped_comp_imp3,
    ps.nm_di1,
    ps.nm_di2,
    ps.nm_di3,
    IsNull(ps.vl_fob_produto, 0.00)            as 'Valor_Fob',
    IsNull(ps.vl_custo_contabil_produto, 0.00) as 'Valor_Custo_Contabil',
    IsNull(ps.vl_fob_convertido, 0.00)         as 'Valor_Fob_Convertido',
    ps.qt_minimo_produto,
    ps.qt_maximo_produto,
    ps.qt_padrao_compra,
    ps.qt_padrao_lote_compra,
    ps.cd_usuario,
    ps.dt_usuario,
    cp.nm_categoria_produto,
    IsNull((select Sum(pii.qt_saldo_item_ped_imp)
            from pedido_importacao_item pii
            where pii.cd_produto = ps.cd_produto and
                  pii.qt_saldo_item_ped_imp > 0 and
                  pii.dt_cancel_item_ped_imp is null
            group by pii.cd_produto),0)            as 'PedidoImportacao',

    (isnull(ps.qt_req_compra_produto,0.00) +
     IsNull((select Sum(rci.qt_item_requisicao_compra)
             from requisicao_compra_item rci
                  left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and
                                                                rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and
                                                                pii.dt_cancel_item_ped_imp is null
             where rci.cd_produto = ps.cd_produto
             Group by rci.cd_produto),0))          as 'Saldo_Requisicao',


  cd_pedido_compra1 = ( select top 1 cd_pedido_compra
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 1 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  qt_pedido_compra1 = ( select top 1 qt_saldo
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 1 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  dt_pedido_compra1 = ( select top 1 dt_entrega
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 1 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  cd_pedido_compra2 = ( select top 1 cd_pedido_compra
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 2 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  qt_pedido_compra2 = ( select top 1 qt_saldo
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 2 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  dt_pedido_compra2 = ( select top 1 dt_entrega
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 2 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  cd_pedido_compra3 = ( select top 1 cd_pedido_compra
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 3 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  qt_pedido_compra3 = ( select top 1 qt_saldo
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 3 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  dt_pedido_compra3 = ( select top 1 dt_entrega
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 3 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc )



--select * from produto_saldo

  from 
    produto_saldo ps with (nolock) 
  left outer join  produto p           on p.cd_produto = ps.cd_produto
  left outer join unidade_medida um    on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join grupo_produto gp     on gp.cd_grupo_produto = p.cd_grupo_produto
  left outer join serie_produto sp     on sp.cd_serie_produto = p.cd_serie_produto
  left outer join produto_custo pc     on pc.cd_produto = p.cd_produto
  left outer join categoria_produto cp on cp.cd_categoria_produto = p.cd_categoria_produto
  
  where     
    --Filtra por fantasia
    p.nm_fantasia_produto = ( case @ic_tipo_pesquisa
                              when 'F' then 
                                @nm_fantasia_produto
                              else 
                                p.nm_fantasia_produto end) and
    p.cd_produto = (case @ic_tipo_pesquisa
                    when 'C' then 
                      @cd_produto
                    else p.cd_produto end) and

   ps.cd_fase_produto = @cd_fase_produto
  order by 
    p.nm_fantasia_produto
  end 

------------------------------------------------------------------------------------------
if @cd_produto = 0 and IsNull(@nm_fantasia_produto,'')=''   -- Consulta Saldo do Estoque do Produto Com Localização em estoque
------------------------------------------------------------------------------------------
begin
  select 
    p.cd_produto,
    rtrim(LTrim(dbo.fn_produto_localizacao(p.cd_produto,@cd_fase_produto)))  as 'Localizacao',  -- 22/04/2003
    case when IsNull(gp.cd_mascara_grupo_produto, '') = '' then 
      isnull(p.cd_mascara_produto, '')
    else 
      isnull(dbo.fn_mascara_produto(p.cd_produto),'') end as 'Mascara',
    p.nm_produto                              as 'Produto',
    p.nm_fantasia_produto                     as 'Produto_Fantasia', 
    p.nm_marca_produto                        as 'Marca', 
    gp.cd_mascara_grupo_produto,
    gp.nm_grupo_produto                       as 'Grupo',
    um.sg_unidade_medida                      as 'Medida',
    sp.nm_serie_produto                       as 'Serie',
    isnull(p.ic_controle_pcp_produto,'N')     as 'PCP_Produto',
    isnull(pc.ic_peps_produto,'N')            as 'PEPS_Produto',
    p.qt_dia_entrega_medio                    as 'Entrega_Medio',
    isnull(p.qt_peso_liquido,0.000)           as 'Peso_Bruto',
    isnull(p.qt_peso_bruto,0.000)             as 'Peso_Liquido',
    isnull(pc.vl_custo_produto,0.00)          as 'Unitario_Atual',
    isnull(pc.vl_custo_anterior_produto,0.00) as 'Unitario_Anterior',
    isnull(ps.qt_minimo_produto,0.00)         as 'Estoque_Min',
    isnull(ps.qt_maximo_produto,0.00)         as 'Estoque_Max',
    isnull(ps.qt_saldo_atual_produto,0.00)    as 'Saldo_Atual',
    isnull(ps.qt_saldo_reserva_produto,0.00)  as 'Saldo_Disponivel',
    isnull(ps.qt_implantacao_produto,0.00)    as 'Saldo_Implantacao',
    isnull(ps.qt_terceiro_produto,0.00)       as 'Saldo_Terceiro',
    isnull(ps.qt_consig_produto,0.00)         as 'Saldo_Consignacao',
    isnull(ps.qt_consumo_produto,0.00)        as 'Saldo_Consumo',
--    isnull(ps.qt_req_compra_produto,0.00)     as 'Saldo_Requisicao',
    isnull(ps.qt_pd_compra_produto,0.00)      as 'Saldo_Pedido_Compra',
    isnull(ps.qt_importacao_produto,0.00)     as 'Saldo_Importacao',
    isnull(ps.qt_minimo_imp_produto,0.00)     as 'Saldo_Min_Importacao',
    ps.dt_terceiro_produto                    as 'Data_Saldo_Terceiro',
    ps.dt_consig_produto                      as 'Data_Saldo_Consignacao',
    isnull(ps.qt_prev_ent1_produto,0.00)      as 'Qtd1_Prev_Entrada',
    isnull(ps.qt_prev_ent2_produto,0.00)      as 'Qtd2_Prev_Entrada',
    isnull(ps.qt_prev_ent3_produto,0.00)      as 'Qtd3_Prev_Entrada',
    ps.dt_prev_ent1_produto                   as 'Data1_Prev_Entrada',
    ps.dt_prev_ent2_produto                   as 'Data2_Prev_Entrada',
    ps.dt_prev_ent3_produto                   as 'Data3_Prev_Entrada',
    case when (sp.ic_import_serie_produto='S' or gp.ic_importacao_grupo_produ='S') then
      'S' 
    else 
      'N' end                                 as 'Importado_produto', --Indica se é importado ou não,
    ps.dt_ultima_entrada_produto              as 'Data_Ult_Entrada',
    ps.dt_ultima_saida_produto                as 'Data_Ult_Saida',
    ps.cd_ped_comp_imp1,
    ps.cd_ped_comp_imp2,
    ps.cd_ped_comp_imp3,
    ps.qt_ped_comp_imp1,
    ps.qt_ped_comp_imp2,
    ps.qt_ped_comp_imp3,
    ps.dt_ped_comp_imp1,
    ps.dt_ped_comp_imp2,
    ps.dt_ped_comp_imp3,
    ps.nm_di1,
    ps.nm_di2,
    ps.nm_di3,
    IsNull(ps.vl_fob_produto, 0.00)            as 'Valor_Fob',
    IsNull(ps.vl_custo_contabil_produto, 0.00) as 'Valor_Custo_Contabil',
    IsNull(ps.vl_fob_convertido, 0.00)         as 'Valor_Fob_Convertido',
    ps.qt_minimo_produto,
    ps.qt_maximo_produto,
    ps.qt_padrao_compra,
    ps.qt_padrao_lote_compra,
    ps.cd_usuario,
    ps.dt_usuario,
    IsNull((select Sum(pii.qt_saldo_item_ped_imp)
            from pedido_importacao_item pii
            where pii.cd_produto = ps.cd_produto and
                  pii.qt_saldo_item_ped_imp > 0 and
                  pii.dt_cancel_item_ped_imp is null
            group by pii.cd_produto),0) as 'PedidoImportacao',
    (isnull(ps.qt_req_compra_produto,0.00) +
     IsNull((select Sum(rci.qt_item_requisicao_compra)
             from requisicao_compra_item rci
                  left outer join pedido_importacao_item pii on rci.cd_requisicao_compra = pii.cd_requisicao_compra and
                                                                rci.cd_item_requisicao_compra = pii.cd_item_requisicao_compra and
                                                                pii.dt_cancel_item_ped_imp is null
             where rci.cd_produto = ps.cd_produto
             Group by rci.cd_produto),0)) as 'Saldo_Requisicao',

  cd_pedido_compra1 = ( select top 1 cd_pedido_compra
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          --pvc.cd_controle = 1 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  qt_pedido_compra1 = ( select top 1 qt_saldo
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  dt_pedido_compra1 = ( select top 1 dt_entrega
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),
  qt_pedido_compra2 = ( select top 1 qt_saldo
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 2 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  dt_pedido_compra2 = ( select top 1 dt_entrega
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 2 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  cd_pedido_compra3 = ( select top 1 cd_pedido_compra
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 3 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  qt_pedido_compra3 = ( select top 1 qt_saldo
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 3 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc ),

  dt_pedido_compra3 = ( select top 1 dt_entrega
                        from
                         #PrevisaoCompraProduto pvc 
                        where
                          pvc.cd_controle = 3 and 
                          p.cd_produto    = pvc.cd_produto
                        order by dt_entrega desc )




  from 
    produto_saldo ps                   with (nolock) 
    left outer join  produto p         with (nolock) on p.cd_produto = ps.cd_produto
    left outer join unidade_medida um  with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
    left outer join grupo_produto gp   with (nolock) on gp.cd_grupo_produto = p.cd_grupo_produto
    left outer join serie_produto sp   with (nolock) on sp.cd_serie_produto = p.cd_serie_produto
    left outer join produto_custo pc   with (nolock) on pc.cd_produto = p.cd_produto
  where     
   ps.cd_fase_produto = @cd_fase_produto
  order by 
    p.nm_fantasia_produto
  end 


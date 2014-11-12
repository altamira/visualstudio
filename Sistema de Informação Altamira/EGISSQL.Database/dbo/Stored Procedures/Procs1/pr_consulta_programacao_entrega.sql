
CREATE PROCEDURE pr_consulta_programacao_entrega
---------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel C. Neto
--Banco de Dados	: EGISSQL
--Objetivo		: Consultar Programação de Entrega através do Pedido de Compra
--Data			: 15/08/2002
--Alteração		: 19/08/2002 - Adicionado campo: ds_item_prodesp_ped_compr, 
--                                   - ds_item_pedido_compra e ds_obs_pedido_compra - Daniel C. Neto.
--                        03/07/2003 - Copiada rotina de Pedido não aprovado do SCP - Daniel C. Neto.
--                        24/07/2003 - Acertada Flags de Não Aprovação e de Liberado - Daniel C. Neto
--                        27.08.2003 - Adicionado o campo Mascara do Produto - Fabio
--                        16.09.2003 - Adicionado campos referentes a Matéria Prima, caso o produto tiver o mesmo. - Daniel Duela
-- 07/11/2003 - Tirado o -1 do campo de atraso: Data da Necessidade - Data de Hoje = Atraso
-- - Daniel C. Neto.
-- 20/12/2004 - Incluído parâmetro de Tipo de filtro de data 
--            - Incluído Data de Entrega - Daniel C. Neto.
--                        22.12.2006 - Mostrando produtos especiais e serviços.
------------------------------------------------------------------------------

@dt_inicial datetime,
@dt_final datetime,
@cd_pedido_compra int,
@cd_empresa int,
@ic_tipo_filtro int

AS
  SELECT
    pdi.dt_item_nec_ped_compra as dt_nec_pedido_compra,
    case 
      when IsNull(pd.cd_status_pedido,1) not in (9,7) then -- Pedido ainda não foi recebido, e não é cancelado.
      cast(
      (pdi.dt_item_nec_ped_compra - (getdate()) ) as Int)
      else 0
    end as 'Atraso',
    pd.cd_pedido_compra,
    pd.dt_pedido_compra,
    fo.nm_fantasia_fornecedor,
    pd.vl_total_pedido_compra,
    pdi.cd_item_pedido_compra,
    pdi.qt_item_pedido_compra,
    ps.qt_saldo_atual_produto,

    -- Anderson - Colocando pra mostrar os produtos especiais e os serviços
    case 
      when isnull(pdi.cd_produto,0)=0 and isnull(pdi.cd_servico,0)=0 then ''
      when isnull(pdi.cd_servico,0)>0 then s.sg_servico
      else pr.nm_fantasia_produto
    end as 'Produto',

    case 
      when isnull(pdi.cd_produto,0)=0 and isnull(pdi.cd_servico,0)=0 then ''
      when isnull(pdi.cd_servico,0)>0 then s.cd_mascara_servico
      else dbo.fn_mascara_produto(IsNull(pdi.cd_produto,0))
    end as 'Mascara',

    case 
      when isnull(pdi.cd_produto,0)=0 and isnull(pdi.cd_servico,0)=0 then Cast( isnull(pdi.nm_produto,'') + ' ' + isnull(pdi.nm_item_prodesp_ped_compr,'') as varchar )
      when isnull(pdi.cd_servico,0)>0 then s.nm_servico
      else pr.nm_produto
    end as 'Descricao',

-- Anderson - 22/12/2006
--     case when pdi.cd_produto is null then pdi.nm_item_prodesp_ped_compr else
--          pr.nm_fantasia_produto end as 'Produto',
--    dbo.fn_mascara_produto(IsNull(pdi.cd_produto,0)) as 'Mascara',
--     case when pdi.cd_produto is null then pdi.nm_item_prodesp_ped_compr else
--          pr.nm_produto end as 'Descricao',

    case when pdi.ds_item_prodesp_ped_compr is null then pdi.ds_item_pedido_compra else
         pdi.ds_item_prodesp_ped_compr end as 'Obs_Produto',
    'Não definido' as 'ds_obs_pedido_compra',
    case when pdi.cd_materia_prima is null then null else
         mp.nm_mat_prima end as 'Materia_Prima',
    pdi.nm_medbruta_mat_prima,
    pdi.nm_medacab_mat_prima,
    co.nm_fantasia_comprador,
    pdi.cd_pedido_venda,
    pdi.cd_item_pedido_venda,
    pdi.vl_item_unitario_ped_comp,
    pdi.vl_custo_item_ped_compra,
    pdi.dt_entrega_item_ped_compr,
    case when IsNull(pdi.cd_pedido_venda,0) = 0 then 'N' else
         'S' end as 'ic_pedido_venda',
    case when IsNull(ps.qt_saldo_atual_produto,0) < 0 then 'S' else
         'N' end as 'ic_est_negativo',
    case when IsNull(pdi.qt_saldo_item_ped_compra,0) <> pdi.qt_item_pedido_compra then 'S' else
         'N' end as 'ic_entrada_parcial',
    case when IsNull(pdi.dt_item_nec_ped_compra,'1800-01-01') < GetDate() then 'S' else
         'N' end as 'ic_atraso',
    case when exists(select * from pedido_compra_follow where cd_pedido_compra = @cd_pedido_compra) then 'S' else
         'N' end as 'FollowUp',
    IsNull(pd.ic_aprov_pedido_compra, 'N') as 'Aprovado', 
    IsNull(pd.ic_aprov_comprador_pedido,'N') as 'Liberado',
    pc.nm_plano_compra, 
    cc.nm_centro_custo
  FROM
    Pedido_Compra pd                                                     
  left outer join Pedido_Compra_Item pdi on pd.cd_pedido_compra = pdi.cd_pedido_compra 
  left outer join Fornecedor fo          on fo.cd_fornecedor = pd.cd_fornecedor                 
  left outer join Produto pr             on pr.cd_produto = pdi.cd_produto                        
  left outer join Materia_Prima mp       on mp.cd_mat_prima=pdi.cd_materia_prima
  left outer join Produto_Saldo ps       on ps.cd_produto = pr.cd_produto and
                                            ps.cd_fase_produto = ( 
                                              select cd_fase_produto 
                                              from Parametro_Comercial
                                              where cd_empresa = @cd_empresa ) 
  left outer join Comprador co           on co.cd_comprador = pd.cd_comprador
  left outer join Plano_Compra pc        on pc.cd_plano_compra = pdi.cd_plano_compra
  left outer join Centro_Custo cc        on cc.cd_centro_custo = pdi.cd_centro_custo
  left outer join Servico s              on s.cd_servico = pdi.cd_servico
  WHERE     
    ( case when @ic_tipo_filtro = 0 then pdi.dt_item_nec_ped_compra
           when @ic_tipo_filtro = 1 then pd.dt_pedido_compra            
           when @ic_tipo_filtro = 2 then pdi.dt_entrega_item_ped_compr end ) 
     BETWEEN @dt_inicial AND @dt_final
    AND (case @cd_pedido_compra 
         when 0 then pd.cd_pedido_compra 
         else @cd_pedido_compra end = pd.cd_pedido_compra)
    and pd.dt_cancel_ped_compra is null and 
    IsNull(pdi.qt_saldo_item_ped_compra,0) > 0
  ORDER BY 
    Atraso, pd.cd_pedido_compra desc, pdi.cd_item_pedido_compra

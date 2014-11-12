---------------------------------------------------------------------------------
--pr_atualiza_nota_entrada_pedido_compra
---------------------------------------------------------------------------------
--POLIMOLD INDUSTRIAL S/A          2006
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Elias P. Silva
--Banco de Dados: EGISSQL
--Objetivo: Ajusta o item da NFE das modificações de Preço do PC
--Data: 08/08/2006
--Atualizado: 
------------------------------------------------------------------------------------

create procedure pr_atualiza_nota_entrada_pedido_compra
@cd_pedido_compra int,
@cd_item_pedido_compra int
as
begin

  -- VARIÁVEIS AUXILIARES
  declare @vl_item_pedido_compra decimal(25,6)
  declare @pc_icms decimal(25,2)
  declare @pc_ipi decimal(25,2)

  -- DADOS ALTERADOS DO PC QUE DEVERÃO SER AJUSTADOS
  select @vl_item_pedido_compra = 
      cast(vl_item_unitario_ped_comp - ((vl_item_unitario_ped_comp * pc_item_descto_ped_compra)/100) as numeric(18,2)),
    @pc_icms = pc_icms,
    @pc_ipi = pc_ipi
  from Pedido_Compra_Item with(nolock)
  where cd_pedido_compra = @cd_pedido_compra and
    cd_item_pedido_compra = @cd_item_pedido_compra

  -- AJUSTE NO ITEM DA NOTA DE ENTRADA
  update Nota_Entrada_Item
  set vl_item_nota_entrada = @vl_item_pedido_compra,
    vl_total_nota_entr_item = @vl_item_pedido_compra * (case when um.ic_fator_conversao = 'K' 
                                                          then nei.qt_pesbru_nota_entrada
                                                          else nei.qt_item_nota_entrada end)
  from Nota_Entrada_Item nei with(nolock)
    inner join Unidade_Medida um on nei.cd_unidade_medida = um.cd_unidade_medida
  where nei.cd_pedido_compra = @cd_pedido_compra and
    nei.cd_item_pedido_compra = @cd_item_pedido_compra

  -- AJUSTE DOS IMPOSTOS NA NOTA DE ENTRADA  
  update Nota_Entrada_Item
  set pc_icms_nota_entrada = @pc_icms,
    pc_ipi_nota_entrada = @pc_ipi,

    vl_bicms_nota_entrada = case when @pc_icms = 0 then 0 else nei.vl_total_nota_entr_item end,

    vl_icms_nota_entrada = case when @pc_icms = 0 
                                then 0 
                                else nei.vl_total_nota_entr_item * (@pc_icms / 100) end,                                   
    vl_bipi_nota_entrada = case when @pc_ipi = 0 then 0 else nei.vl_total_nota_entr_item end,

    vl_ipi_nota_entrada = case when @pc_ipi = 0 
                                then 0 
                                else nei.vl_total_nota_entr_item * (@pc_ipi / 100) end,

    vl_cofins_item_nota = (nei.vl_total_nota_entr_item * ((select top 1 ia.pc_imposto 
                                                           from Imposto_Aliquota ia with(nolock)
                                                           where ia.cd_imposto = 5 and 
                                                             ia.dt_imposto_aliquota <= ne.dt_nota_entrada
                                                           order by ia.dt_imposto_aliquota desc)/100)
                          --Verifica se Deduz o ICMS
                          - case when isnull(pte.pc_reducao_bc_ipi,0) > 0 and isnull(nei.vl_ipi_nota_entrada,0) > 0 then nei.vl_ipi_nota_entrada * (pte.pc_reducao_bc_ipi / 100) else 0 end
                          - case when isnull(pte.pc_reducao_bc_ipi,0) > 0 and isnull(nei.vl_ipi_nota_entrada,0) = 0 then (cf.pc_ipi_classificacao / 100) * nei.vl_bicms_nota_entrada else 0 end),

    vl_pis_item_nota    = (nei.vl_total_nota_entr_item * ((select top 1 ia.pc_imposto 
                                                           from Imposto_Aliquota ia with(nolock)
                                                           where ia.cd_imposto = 4 and 
                                                             ia.dt_imposto_aliquota <= ne.dt_nota_entrada
                                                           order by ia.dt_imposto_aliquota desc)/100) 
                           --Verifica se Deduz o ICMS
                           - case when isnull(pte.pc_reducao_bc_ipi,0) > 0 and isnull(nei.vl_ipi_nota_entrada,0) > 0 then nei.vl_ipi_nota_entrada * (pte.pc_reducao_bc_ipi / 100) else 0 end
                           - case when isnull(pte.pc_reducao_bc_ipi,0) > 0 and isnull(nei.vl_ipi_nota_entrada,0) = 0 then (cf.pc_ipi_classificacao/100) * nei.vl_bicms_nota_entrada else 0 end),

    pc_cofins_item_nota = (select top 1 ia.pc_imposto 
                           from Imposto_Aliquota ia with(nolock)
                           where ia.cd_imposto = 5 and 
                             ia.dt_imposto_aliquota <= ne.dt_nota_entrada
                           order by ia.dt_imposto_aliquota desc),

    pc_pis_item_nota    = (select top 1 ia.pc_imposto 
                           from Imposto_Aliquota ia with(nolock)
                           where ia.cd_imposto = 4 and 
                             ia.dt_imposto_aliquota <= ne.dt_nota_entrada
                           order by ia.dt_imposto_aliquota desc),
 
    vl_contabil_nota_entrada = vl_total_nota_entr_item
  from Nota_Entrada_Item nei with(nolock)
    inner join Nota_Entrada ne on nei.cd_nota_entrada = ne.cd_nota_entrada and
                                  nei.cd_fornecedor = ne.cd_fornecedor and
                                  nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal and
                                  nei.cd_operacao_fiscal = ne.cd_operacao_fiscal
    left outer join Parametro_Tributacao_entrada pte on pte.cd_tributacao = nei.cd_tributacao
    left outer join Classificacao_Fiscal cf on cf.cd_classificacao_fiscal = nei.cd_classificacao_fiscal
  where nei.cd_pedido_compra = @cd_pedido_compra and
    nei.cd_item_pedido_compra = @cd_item_pedido_compra

  -- AJUSTE NO CABEÇALHO DA NOTA DE ENTRADA
  update Nota_Entrada
  set vl_total_nota_entrada = tot.vl_total_nota_entr_item,  
    vl_prod_nota_entrada = tot.vl_total_nota_entr_item, 
    vl_bicms_nota_entrada = tot.vl_bicms_nota_entrada,
    vl_bipi_nota_entrada = tot.vl_bipi_nota_entrada,
    vl_icms_nota_entrada = tot.vl_icms_nota_entrada,
    vl_ipi_nota_entrada = tot.vl_ipi_nota_entrada
  from Nota_Entrada ne with(nolock)
    inner join (select 
                  nei.cd_nota_entrada, 
                  nei.cd_fornecedor, 
                  nei.cd_operacao_fiscal, 
                  nei.cd_serie_nota_fiscal,
                  sum(nei.vl_total_nota_entr_item) as vl_total_nota_entr_item,  
                  sum(nei.vl_bicms_nota_entrada) as vl_bicms_nota_entrada,
                  sum(nei.vl_bipi_nota_entrada) as vl_bipi_nota_entrada,
                  sum(nei.vl_icms_nota_entrada) as vl_icms_nota_entrada,
                  sum(nei.vl_ipi_nota_entrada) vl_ipi_nota_entrada
                from Nota_Entrada_Item nei with(nolock)
                  inner join (select distinct
                                cd_nota_entrada, 
                                cd_fornecedor, 
                                cd_operacao_fiscal, 
                                cd_serie_nota_fiscal
                              from Nota_Entrada_Item with(nolock)
                              where cd_pedido_compra = @cd_pedido_compra and
                                cd_item_pedido_compra = @cd_item_pedido_compra) aux on aux.cd_nota_entrada = nei.cd_nota_entrada and
                                                                                       aux.cd_fornecedor = nei.cd_fornecedor and
                                                                                       aux.cd_operacao_fiscal = nei.cd_operacao_fiscal and
                                                                                       aux.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
                group by nei.cd_nota_entrada, nei.cd_fornecedor, 
                  nei.cd_operacao_fiscal, nei.cd_serie_nota_fiscal) tot on ne.cd_nota_entrada = tot.cd_nota_entrada and
                                                                           ne.cd_fornecedor = tot.cd_fornecedor and
                                                                           ne.cd_serie_nota_fiscal = tot.cd_serie_nota_fiscal and
                                                                           ne.cd_operacao_fiscal = tot.cd_operacao_fiscal 
  -- AJUSTE NO PEPS
  update Nota_Entrada_Peps
  set vl_preco_entrada_peps = case when pc.ic_ipi_custo_produto = 'S' then
                                case when op.ic_importacao_op_fiscal = 'S' 
                                  then ((nei.vl_total_nota_entr_item + nei.vl_ipi_nota_entrada) / 
                                         nei.qt_item_nota_entrada)
                                  else ((nei.vl_total_nota_entr_item + nei.vl_ipi_nota_entrada - nei.vl_icms_nota_entrada) / 
                                         nei.qt_item_nota_entrada)
                                  end
                              else
                                case when op.ic_importacao_op_fiscal = 'S' 
                                  then (nei.vl_total_nota_entr_item / nei.qt_item_nota_entrada)
                                  else ((nei.vl_total_nota_entr_item - nei.vl_icms_nota_entrada) / 
                                         nei.qt_item_nota_entrada) 
                                  end
                              end, 
                                   
      vl_custo_total_peps = case when pc.ic_ipi_custo_produto = 'S' then
                                case when op.ic_importacao_op_fiscal = 'S' 
                                  then (nei.vl_total_nota_entr_item + nei.vl_ipi_nota_entrada)
                                  else (nei.vl_total_nota_entr_item + nei.vl_ipi_nota_entrada - nei.vl_icms_nota_entrada) 
                                  end
                              else
                                case when op.ic_importacao_op_fiscal = 'S' 
                                  then nei.vl_total_nota_entr_item 
                                  else (nei.vl_total_nota_entr_item - nei.vl_icms_nota_entrada)
                                  end
                              end
  from Nota_Entrada_Peps peps with(nolock)
    inner join Movimento_Estoque me with(nolock) on peps.cd_movimento_estoque = me.cd_movimento_estoque
    inner join Nota_Entrada_Item nei with(nolock) on me.cd_fornecedor = nei.cd_fornecedor and
                                                     me.cd_documento_movimento = cast(nei.cd_nota_entrada as varchar) and
                                                     me.cd_operacao_fiscal = nei.cd_operacao_fiscal and
                                                     me.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                                     me.cd_item_documento = nei.cd_item_nota_entrada and                                       
                                                     me.cd_tipo_documento_estoque = 3
    inner join Operacao_Fiscal op with(nolock) on op.cd_operacao_fiscal = nei.cd_operacao_fiscal
    inner join Parametro_Custo pc with(nolock) on pc.cd_empresa = dbo.fn_empresa()
  where nei.cd_pedido_compra = @cd_pedido_compra and
    nei.cd_item_pedido_compra = @cd_item_pedido_compra

  -- AJUSTE NO CUSTO DO MOVIMENTO DE ESTOQUE
  update Movimento_Estoque
  set vl_custo_contabil_produto = peps.vl_preco_entrada_peps
  from Movimento_Estoque me with(nolock)
    inner join Nota_Entrada_Peps peps with(nolock) on me.cd_movimento_estoque = peps.cd_movimento_estoque
    inner join Nota_Entrada_Item nei with(nolock) on me.cd_fornecedor = nei.cd_fornecedor and
                                                     me.cd_documento_movimento = cast(nei.cd_nota_entrada as varchar) and
                                                     me.cd_operacao_fiscal = nei.cd_operacao_fiscal and
                                                     me.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal and
                                                     me.cd_item_documento = nei.cd_item_nota_entrada and                                       
                                                     me.cd_tipo_documento_estoque = 3
  where nei.cd_pedido_compra = @cd_pedido_compra and
    nei.cd_item_pedido_compra = @cd_item_pedido_compra

end


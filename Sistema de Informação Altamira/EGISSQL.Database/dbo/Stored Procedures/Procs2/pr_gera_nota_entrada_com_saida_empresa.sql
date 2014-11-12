
-------------------------------------------------------------------------------
--sp_helptext pr_gera_nota_entrada_com_saida_empresa
-------------------------------------------------------------------------------
--pr_gera_nota_entrada_com_saida_empresa
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Gera as Notas de Entrada com Notas de Saída
--Data             : 07.12.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_nota_entrada_com_saida_empresa
@cd_empresa            int      = 0,
@cd_nota_saida         int      = 0,
@cd_usuario            int      = 0,
@dt_receb_nota_entrada datetime = null,
@cd_operacao_fiscal    int      = 0
as

if @cd_nota_saida > 0 and @cd_empresa > 0
begin

  declare @sql1             varchar(8000)
  declare @nm_banco_empresa varchar(100)
  
  --select * from egisadmin.dbo.empresa

  select
    @nm_banco_empresa = isnull(e.nm_banco_empresa,'')
  from
    egisadmin.dbo.empresa e with (nolock) 
  where
    e.cd_empresa = @cd_empresa


--  set @sql1 = 'select * into #nota_saida from '+@nm_banco_empresa+'.dbo.nota_saida where cd_nota_saida = '+cast(@cd_nota_saida as varchar)

--  exec ( @sql1 )

  --select * from nota_entrada
  --select * from nota_saida
  --select * from operacao_fiscal

  --set @sql1 = 
  
  select
    ns.cd_cliente                  as cd_fornecedor,
    ns.cd_identificacao_nota_saida as cd_nota_entrada,
    ns.cd_serie_nota               as cd_serie_nota_fiscal,
    ns.cd_operacao_fiscal          as cd_operacao_fiscal,
 
    case when @dt_receb_nota_entrada is not null then
      @dt_receb_nota_entrada
    else
      ns.dt_nota_saida 
    end                            as dt_receb_nota_entrada,

    ns.dt_nota_saida               as dt_nota_entrada,

    sn.sg_serie_nota_fiscal        as nm_serie_nota_entrada,
    opf.cd_tributacao,
    opf.cd_tipo_destinatario,
    ns.cd_condicao_pagamento,
    'N'                            as ic_carta_cor_nota_entrada,
    ns.vl_total                    as vl_total_nota_entrada,
    ns.vl_produto                  as vl_prod_nota_entrada,
    ns.vl_bc_icms                  as vl_bicms_nota_entrada,
    ns.vl_bc_ipi                   as vl_bipi_nota_entrada,
    ns.vl_icms                     as vl_icms_nota_entrada,
    ns.vl_ipi                      as vl_ipi_nota_entrada,
    ns.vl_frete                    as vl_frete_nota_entrada,
    ns.vl_seguro                   as vl_seguro_nota_entrada,
    ns.vl_desp_acess               as vl_despac_nota_entrada,
    ns.vl_bc_subst_icms            as vl_bsticm_nota_entrada,
    ns.vl_icms_subst               as vl_sticm_nota_entrada,
    ns.vl_servico                  as vl_servico_nota_entrada,
    ns.vl_iss                      as vl_iss_nota_entrada,
    ns.vl_irrf_nota_saida          as vl_irrf_nota_entrada,
    ns.vl_inss_nota_saida          as vl_inss_nota_entrada,
    0.00                           as vl_biss_nota_entrada,
    0.00                           as pc_iss_nota_entrada,
    'N'                            as ic_conf_nota_entrada,
    ns.dt_nota_saida               as dt_atual_nota_entrada,
    'N'                            as ic_sco,
    'N'                            as ic_slf,
    'N'                            as ic_sce,
    'N'                            as ic_scu,
    'N'                            as ic_scp,
    'N'                            as ic_pcp,
    'N'                            as ic_sep,
    'N'                            as ic_simp,
    'N'                            as ic_sct,
    'N'                            as ic_diverg_nota_entrega,
    null                           as nm_obslivro_nota_entrada,
    @cd_usuario                    as cd_usuario,
    getdate()                      as dt_usuario,
    null                           as pc_inss_nota_entrada,
    'N'                            as ic_fiscal_nota_entrada,
    ns.nm_fantasia_nota_saida      as nm_fantasia_destinatario,
    ns.nm_razao_social_nota        as nm_razao_social,
    'N'                            as ic_emitida_nota_entrada,
    null                           as cd_operacao_origem,
    ns.cd_nota_saida,
    vw.cd_estado,
    ns.sg_estado_nota_saida        as sg_estado,
    --cast('' as varchar)            as ds_obs_compl_nota_entrada,
    ds_obs_compl_nota_saida        as ds_obs_compl_nota_entrada,
    ns.qt_peso_bruto_nota_saida    as qt_bruto_nota_entrada,
    ns.qt_peso_liq_nota_saida      as qt_liquido_nota_entrada,
    ns.qt_volume_nota_saida        as qt_volume_nota_entrada,
    ns.nm_especie_nota_saida       as nm_especie_nota_entrada,
    ns.nm_marca_nota_saida         as nm_marca_nota_entrada,
    ns.nm_numero_emb_nota_saida    as nm_num_emb_nota_entrada,
    ns.cd_transportadora,
    ns.cd_tipo_pagamento_frete,
    ns.cd_placa_nota_saida         as cd_placa_nota_saida,
    ns.sg_estado_placa             as sg_estado_placa,
    ns.cd_destinacao_produto,
    null                           as cd_rem,
    null                           as dt_rem,
    null                           as vl_bcinss_nota_entrada,
    null                           as cd_guia_trafego_nota_ent,
    null                           as vl_csll_nota_entrada,
    ns.vl_pis                      as vl_pis_nota_entrada,
    ns.vl_cofins                   as vl_cofins_nota_entrada,
    null                           as ic_reter_iss,
    'N'                            as ic_scp_retencao,
    'N'                            as ic_manutencao_fiscal,
    'N'                            as ic_manutencao_contabil,
    'N'                            as ic_lista_livro_saida,
    ns.cd_loja,
    ns.cd_moeda                    as cd_moeda,
    ns.dt_cambio_nota_saida        as dt_cambio_nota_entrada,
    ns.vl_cambio_nota_saida        as vl_cambio_nota_entrada,
    'N'                            as ic_provisao_nota_entrada,
    null                           as vl_icms_ciap_nota_entrada,
    null                           as cd_ciap,
    null                           as pc_csll_nota_entrada,
    null                           as pc_pis_nota_entrada,
    null                           as pc_irrf_nota_entrada,
    null                           as pc_cofins_nota_entrada,
    @cd_usuario                    as cd_usuario_inclusao,
    ns.cd_tipo_destinatario        as cd_tipo_destinatario_fatura,
    ns.cd_tipo_destinatario        as cd_destinatario_faturamento,
    null                           as cd_centro_custo,
    null                           as cd_plano_financeiro,
    null                           as cd_status_nota,
    null                           as dt_cancelamento_nota,
    null                           as vl_desconto_nota_entrada,
    null                           as vl_base_retencao_nota,
    'N'                            as ic_nfe_nota_entrada,
    null                           as ic_xml_nota_entrada

--select * from status_nota_entrada

into #Nota_Entrada
from
  nota_saida ns                         with (nolock)
  left outer join serie_nota_fiscal sn  on sn.cd_serie_nota_fiscal = ns.cd_serie_nota
  left outer join operacao_fiscal   opf on opf.cd_operacao_fiscal  = ns.cd_operacao_fiscal
  left outer join vw_destinatario   vw  on vw.cd_tipo_destinatario = ns.cd_tipo_destinatario and
                                           vw.cd_destinatario      = ns.cd_cliente

--select * from serie_nota_fiscal


where
  ns.cd_nota_saida = @cd_nota_saida

insert into nota_entrada
select * from #nota_entrada

--Itens da Nota de Entrada----------------------------------------------------------
--select * from nota_saida_item

select
  ns.cd_cliente                  as cd_fornecedor,
  ns.cd_identificacao_nota_saida as cd_nota_entrada,
  ns.cd_operacao_fiscal,
  ns.cd_serie_nota               as cd_serie_nota_fiscal,
  i.cd_item_nota_saida           as cd_item_nota_entrada,
  i.cd_classificacao_fiscal,
  i.cd_produto,
  i.nm_produto_item_nota         as nm_produto_nota_entrada,
  i.cd_unidade_medida,
  null                           as cd_pedido_compra,
  null                           as cd_item_pedido_compra,
  i.cd_procedencia_produto,
  i.cd_tributacao,
  i.qt_item_nota_saida           as qt_item_nota_entrada,
  i.vl_unitario_item_nota        as vl_item_nota_entrada,
  i.pc_desconto_item             as pc_desc_nota_entrada,
  i.qt_liquido_item_nota         as qt_pesliq_nota_entrada,
  i.qt_bruto_item_nota_saida     as qt_pesbru_nota_entrada,
  i.pc_icms                      as pc_icms_nota_entrada,
  i.vl_base_icms_item            as vl_bicms_nota_entrada,
  i.vl_icms_item                 as vl_icms_nota_entrada,
  i.vl_icms_isento_item          as vl_icmsisen_nota_entrada,
  i.vl_icms_outros_item          as vl_icmout_nota_entrada,
  i.vl_icms_obs_item             as vl_icmobs_nota_entrada,
  i.pc_ipi                       as pc_ipi_nota_entrada,
  i.vl_base_ipi_item             as vl_bipi_nota_entrada,
  i.vl_ipi                       as vl_ipi_nota_entrada,
  i.vl_ipi_isento_item           as vl_ipiisen_nota_entrada,
  i.vl_ipi_outros_item           as vl_ipiout_nota_entrada,
  i.vl_ipi_obs_item              as vl_ipiobs_nota_entrada,
  pc.vl_custo_produto            as vl_custo_nota_entrada,
  null                           as vl_contabil_nota_entrada,
  null                           as cd_plano_compra,
  pc.ic_peps_produto             as ic_peps_nota_entrada,
  @dt_receb_nota_entrada         as dt_item_receb_nota_entrad,
  i.cd_situacao_tributaria,
  null                           as ic_basered_nota_entrada,
  null                           as cd_dispositivo_legal_ipi,
  null                           as cd_dispositivo_legal_icm,
  null                           as cd_contabilizacao,
  @cd_usuario as cd_usuario,
  getdate()                      as dt_usuario,
  i.ic_tipo_nota_saida_item     as ic_tipo_nota_entrada_item,
  i.vl_total_item                as vl_total_nota_entr_item,
  null                           as cd_conta,
  null                           as ic_item_inspecao_nota,
  i.cd_servico,
  cast('' as varchar)            as ds_servico,
  null                           as vl_irrf_servico,
  null                           as pc_irrf_servico,
  null                           as vl_iss_servico,
  null                           as pc_iss_servico,
  null                           as cd_item_requisicao_compra,
  null                           as cd_requisicao_compra,
  cf.cd_mascara_classificacao,
  null                           as pc_icms_red_nota_entrada,
  null                           as ic_estocado_nota_entrada,
  null                           as ic_consig_nota_entrada,
  null                           as cd_lote_produto,
  null                           as cd_lote_item_nota_entrada,
  null                           as cd_num_serie_item_nota_ent,
  null                           as qt_destino_movimento,
  null                           as qt_fator_produto_unidade,
  null                           as cd_unidade_destino,
  null                           as vl_custo_conversao,
  null                           as vl_custo_net_nota_entrada,
  null                           as vl_confis_item_nota,
  null                           as vl_pis_item_nota,
  null                           as pc_confis_item_nota,
  null                           as pc_pis_item_nota,
  null                           as dt_item_inspecao_nota,
  null                           as cd_usuario_inspecao,
  null                           as ic_inventario,
  null                           as cd_bem,
  null                           as vl_icms_ciap_nota_entrada,
  null                           as vl_ipi_apura_nota_entrada,
  null                           as qt_mes_apura_nota_entrada,
  null                           as vl_cofins_item_nota,
  null                           as pc_cofins_item_nota,
  null                           as cd_veiculo,
  ns.cd_nota_saida,
  i.cd_item_nota_saida,
  pc.vl_custo_produto,

--  null                           as vl_custo_produto,

  null                           as cd_rnc,
  null                           as cd_centro_custo,
  null                           as qt_area_produto,
  i.cd_fase_produto,
  null                           as ic_controle_saldo,
  i.cd_operacao_fiscal           as cd_item_operacao_fiscal,
  null                           as cd_laudo,
  i.vl_unitario_ipi_produto      as vl_unitario_ipi_produto,
  i.vl_frete_item                as vl_frete_item_nota,
  null                           as ic_item_bonificacao,
  i.cd_pedido_venda,
  i.cd_item_pedido_venda,
  i.vl_bc_subst_icms_item     as vl_bc_subst_icms_item,
  i.vl_icms_subst_icms_item   as vl_icms_subst_icms_item

into
 #Nota_Entrada_Item

from
 nota_saida_item i         with (nolock) 
 inner join nota_saida ns  with (nolock)        on ns.cd_nota_saida = i.cd_nota_saida  
 left outer join produto p with (nolock)        on p.cd_produto     = i.cd_produto
 left outer join produto_custo pc with (nolock) on pc.cd_produto = i.cd_produto
 left outer join classificacao_fiscal cf        on cf.cd_classificacao_fiscal = i.cd_classificacao_fiscal

--select * from produto_custo

where
  i.cd_nota_saida = @cd_nota_saida

insert into
  Nota_Entrada_Item
select
  *
from
  #Nota_Entrada_item

drop table #Nota_Entrada
drop table #Nota_Entrada_item




end



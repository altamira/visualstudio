
-------------------------------------------------------------------------------
--sp_helptext pr_gera_nota_entrada_nota_saida
-------------------------------------------------------------------------------
--ppr_gera_nota_entrada_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 01.01.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_gera_nota_entrada_nota_saida
@cd_nota_saida int = 0,
@cd_usuario    int = 0

as

------------------------------------------------------------------------------

if @cd_nota_saida > 0
begin

  --select * from nota_saida
  --select * from serie_nota_fiscal
  --nota_entrada

  select
    ns.cd_cliente             as cd_fornecedor,
    ns.cd_nota_saida          as cd_nota_entrada,
    ns.cd_serie_nota          as cd_serie_nota_fiscal,
    ns.cd_operacao_fiscal,
    ns.dt_nota_saida          as dt_receb_nota_entrada,
    ns.dt_nota_saida          as dt_nota_entrada,
    sn.sg_serie_nota_fiscal   as nm_serie_nota_entrada,
    1                         as cd_tributacao,
    ns.cd_tipo_destinatario,
    ns.cd_condicao_pagamento,
    'N'                         as ic_carta_cor_nota_entrada, 
    ns.vl_total                 as vl_total_nota_entrada,
    ns.vl_produto               as vl_prod_nota_entrada,
    ns.vl_bc_icms               as vl_bicms_nota_entrada,
    ns.vl_bc_ipi                as vl_bipi_nota_entrada,
    ns.vl_icms                  as vl_icms_nota_entrada,
    ns.vl_ipi                   as vl_ipi_nota_entrada,
    ns.vl_frete                 as vl_frete_nota_entrada,
    ns.vl_seguro                as vl_seguro_nota_entrada,
    ns.vl_desp_acess            as vl_despac_nota_entrada,
    ns.vl_bc_subst_icms         as vl_bsticm_nota_entrada,
    ns.vl_icms_subst            as vl_sticm_nota_entrada,
    ns.vl_servico               as vl_servico_nota_entrada,
    ns.vl_iss                   as vl_iss_nota_entrada,
    ns.vl_irrf_nota_saida       as vl_irrf_nota_entrada,
    ns.vl_inss_nota_saida       as vl_inss_nota_entrada,
    ns.vl_servico               as vl_biss_nota_entrada,
    null                        as pc_iss_nota_entrada,
    null                        as ic_conf_nota_entrada,
    ns.dt_nota_saida            as dt_atual_nota_entrada,
    'N'                         as ic_sco,
    'N'                         as ic_slf,
    'N'                         as ic_sce,
    'N'                         as ic_scu,
    'N'                         as ic_scp,
    'N'                         as ic_pcp,
    'N'                         as ic_sep,
    'N'                         as ic_simp,
    'N'                         as ic_sct,
    'N'                         as ic_diverg_nota_entrega,
    null                        as nm_obslivro_nota_entrada,
    @cd_usuario                 as cd_usuario,
    getdate()                   as dt_usuario,
    null                        as pc_inss_nota_entrada,
    'S'                         as ic_fiscal_nota_entrada,
    ns.nm_fantasia_nota_saida   as nm_fantasia_destinatario,
    ns.nm_razao_social_nota     as nm_razao_social,
    'S'                         as ic_emitida_nota_entrada,
    null                        as cd_operacao_origem,
    ns.cd_nota_saida,
    e.cd_estado,
    ns.sg_estado_nota_saida     as sg_estado,
    cast('' as varchar)         as ds_obs_compl_nota_entrada,
    ns.qt_peso_bruto_nota_saida as qt_bruto_nota_entrada,
    ns.qt_peso_liq_nota_saida   as qt_liquido_nota_entrada,
    ns.qt_volume_nota_saida     as qt_volume_nota_entrada,
    --ns.nm_especie_nota_saida    as nm_especie_nota_entrada,
    sn.nm_especie_livro_saida   as nm_especie_nota_entrada,
    ns.nm_marca_nota_saida      as nm_marca_nota_entrada,
    ns.nm_numero_emb_nota_saida as nm_num_emb_nota_entrada,
    ns.cd_transportadora,
    ns.cd_tipo_pagamento_frete,
    ns.cd_placa_nota_saida,
    ns.sg_estado_placa,
    ns.cd_destinacao_produto,
    null                        as cd_rem,
    null                        as dt_rem,
    null                        as vl_bcinss_nota_entrada,
    null                        as cd_guia_trafego_nota_ent,
    null                        as vl_csll_nota_entrada,
    null                        as vl_pis_nota_entrada,
    null                        as vl_cofins_nota_entrada,
    null                        as ic_reter_iss,
    null                        as ic_scp_retencao,
    null                        as ic_manutencao_fiscal,
    null                        as ic_manutencao_contabil,
    null                        as ic_lista_livro_saida,
    null                        as cd_loja,
    ns.cd_moeda,
    ns.dt_cambio_nota_saida     as dt_cambio_nota_entrada,
    ns.vl_cambio_nota_saida     as vl_cambio_nota_entrada,
    null                        as ic_provisao_nota_entrada,
    null                        as vl_icms_ciap_nota_entrada,
    null                        as cd_ciap,
    null                        as pc_csll_nota_entrada,
    null                        as pc_pis_nota_entrada,
    ns.pc_irrf_serv_empresa     as pc_irrf_nota_entrada,
    null                        as pc_cofins_nota_entrada,
    null                        as cd_usuario_inclusao,
    null                        as cd_tipo_destinatario_fatura,
    null                        as cd_destinatario_faturamento,
    null                        as cd_centro_custo,
    null                        as cd_plano_financeiro,
    ns.cd_status_nota,
    null                        as dt_cancelamento_nota,
    null                        as vl_desconto_nota_entrada,
    null                        as vl_base_retencao_nota
into
  #nota_entrada
from
  nota_saida ns with (nolock) 
  left outer join serie_nota_fiscal sn on sn.cd_serie_nota_fiscal = ns.cd_serie_nota
  left outer join estado e             on e.sg_estado             = ns.sg_estado_nota_saida
where
  ns.cd_nota_saida = @cd_nota_saida 


insert into
  nota_entrada
select
  *
from
  #nota_entrada

select * from #nota_entrada    

--Itens da Nota Fiscal de Entrada

--select * from nota_saida_item
--select * from nota_entrada_item

select
  ns.cd_cliente                  as cd_fornecedor,
  ns.cd_nota_saida               as cd_nota_entrada,
  ns.cd_operacao_fiscal,
  ns.cd_serie_nota               as cd_serie_nota_fiscal,
  nsi.cd_item_nota_saida         as cd_item_nota_entrada,
  nsi.cd_classificacao_fiscal,
  nsi.cd_produto,
  cast(nsi.nm_produto_item_nota  as varchar(40)) as nm_produto_nota_entrada,
  nsi.cd_unidade_medida,
  null                                           as cd_pedido_compra,
  null                                           as cd_item_pedido_compra,
  nsi.cd_procedencia_produto,
  nsi.cd_tributacao,
  nsi.qt_item_nota_saida          as qt_item_nota_entrada,
  nsi.vl_unitario_item_nota       as vl_item_nota_entrada,
  nsi.pc_desconto_item            as pc_desc_nota_entrada,
  nsi.qt_liquido_item_nota        as qt_pesliq_nota_entrada,
  nsi.qt_bruto_item_nota_saida    as qt_pesbru_nota_entrada,
  nsi.pc_icms                     as pc_icms_nota_entrada,
  nsi.vl_base_icms_item           as vl_bicms_nota_entrada,
  nsi.vl_icms_item                as vl_icms_nota_entrada,
  nsi.vl_icms_isento_item         as vl_icmsisen_nota_entrada,
  nsi.vl_icms_outros_item         as vl_icmout_nota_entrada,
  nsi.vl_icms_obs_item            as vl_icmobs_nota_entrada,
  nsi.pc_ipi                      as pc_ipi_nota_entrada,
  nsi.vl_base_ipi_item            as vl_bipi_nota_entrada,
  nsi.vl_ipi                      as vl_ipi_nota_entrada,
  nsi.vl_ipi_isento_item          as vl_ipiisen_nota_entrada,
  nsi.vl_ipi_outros_item          as vl_ipiout_nota_entrada,
  nsi.vl_ipi_obs_item             as vl_ipiobs_nota_entrada,
  nsi.vl_unitario_item_nota       as vl_custo_nota_entrada,
  nsi.vl_total_item               as vl_contabil_nota_entrada,
  null                            as cd_plano_compra,
  'S'                             as ic_peps_nota_entrada,
  ns.dt_nota_saida                as dt_item_receb_nota_entrad,
  nsi.cd_situacao_tributaria      as cd_situacao_tributaria,
  'N'                             as ic_basered_nota_entrada,
  null                            as cd_dispositivo_legal_ipi,
  null                            as cd_dispositivo_legal_icm,
  null                            as cd_contabilizacao,
  @cd_usuario                     as cd_usuario,
  getdate()                       as dt_usuario,
  nsi.ic_tipo_nota_saida_item     as ic_tipo_nota_entrada_item,
  nsi.vl_total_item               as vl_total_nota_entr_item,
  nsi.cd_conta                    as cd_conta,
  'N'                             as ic_item_inspecao_nota,
  nsi.cd_servico,
  nsi.ds_servico,
  nsi.vl_irrf_nota_saida          as vl_irrf_servico,
  nsi.pc_irrf_serv_empresa        as pc_irrf_servico,
  nsi.vl_iss_servico              as vl_iss_servico,
  nsi.pc_iss_servico              as pc_iss_servico,
  null                            as cd_item_requisicao_compra,
  null                            as cd_requisicao_compra,
--select * from classificacao_fiscal
  cf.cd_mascara_classificacao     as cd_mascara_classificacao,
  nsi.pc_reducao_icms             as pc_icms_red_nota_entrada,
  nsi.ic_movimento_estoque        as ic_estocado_nota_entrada,
  null                            as ic_consig_nota_entrada,
  null                            as cd_lote_produto,
  nsi.cd_lote_item_nota_saida     as cd_lote_item_nota_entrada,
  nsi.cd_num_serie_item_nota      as cd_num_serie_item_nota_ent,
  null                            as qt_destino_movimento,
  null                            as qt_fator_produto_unidade,
  null                            as cd_unidade_destino,
  null                            as vl_custo_conversao,
  null                            as vl_custo_net_nota_entrada,
  nsi.vl_cofins                   as vl_confis_item_nota,
  nsi.vl_pis                      as vl_pis_item_nota,
  nsi.pc_cofins                   as pc_confis_item_nota,
  nsi.pc_pis                      as pc_pis_item_nota,
  null                            as dt_item_inspecao_nota,
  null                            as cd_usuario_inspecao,
  null                            as ic_inventario,
  null                            as cd_bem,
  null                            as vl_icms_ciap_nota_entrada,
  null                            as vl_ipi_apura_nota_entrada,
  null                            as qt_mes_apura_nota_entrada,
  nsi.vl_cofins                   as vl_cofins_item_nota,
  nsi.pc_cofins                   as pc_cofins_item_nota,
  null                            as cd_veiculo,
  nsi.cd_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.vl_unitario_item_nota        as vl_custo_produto,
  null                             as cd_rnc,
  null                             as cd_centro_custo,
  null                             as qt_area_produto,
  nsi.cd_fase_produto,
  null                             as ic_controle_saldo,
  null                             as cd_item_operacao_fiscal,
  null                             as cd_laudo
into
  #nota_entrada_item
from
  nota_saida_item nsi                     with (nolock)  
  left outer join nota_saida ns           on ns.cd_nota_saida = nsi.cd_nota_saida  
  left outer join classificacao_fiscal cf on cf.cd_classificacao_fiscal = nsi.cd_classificacao_fiscal
where
  nsi.cd_nota_saida = @cd_nota_saida

insert into
  nota_entrada_item
select
  *
from
  #nota_entrada_item

select * from #nota_entrada_item

drop table #nota_entrada
drop table #nota_entrada_item

--delete from nota_entrada      where cd_nota_entrada = 500790
--delete from nota_entrada_item where cd_nota_entrada = 500790

--select * from nota_saida_item 
--select * from serie_nota_fiscal
--sele

end

------------------------------------------------------------------------------



-------------------------------------------------------------------------------
--pr_altamira_migracao_nota_saida_2009
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Migração de Nota de Saída/Item
--Data             : 24.07.2009
--Alteração        : 
--David Becker      : 31.07.2009
--Descrição        : Verficação e inclusão dos Campos necessario para migração e emissão das nota fiscal de saida
------------------------------------------------------------------------------

Create procedure pr_altamira_migracao_nota_saida_2009
as

--Deleta os Registros da Tabela Destino
--delete from nota_saida_Item
-- where dt_nota_saida between '2009/01/01' and '2009/01/31'

--delete from nota_saida
-- where dt_nota_saida between '2009/01/01' and '2009/01/31'

--SELECT * FROM  migracao.dbo.NFSJAN2009
--select * from nota_saida_item

--Montagem da Tabela Temporária
select
  CAST(NOTAFISCAL AS INT )  as NOTAFISCAL,
  --CAST(GETDATE()) AS DATETIME)                AS EMISSAO,
  DTNOTA  AS EMISSAO,
  --GETDATE() AS EMISSAO,
  MAX([REPRESENTANTE])      as REPRESENTANTE,
  TRANSP,
  QTDEPGTO,
  CLD,
  CNPJ,
  ESTADO,
  REPLACE(CFOP,'x','.')    as CFOP,
--  CFOP                      as CFOP,
  SUM(QTDE * [VLRUNITARIO]) as TOTAL
  
into
  #NFS
from
  migracao.dbo.NFSMAR_ABR2009
group by
  NOTAFISCAL,
  DTNOTA,  
  QTDEPGTO,
  CLD,
  CNPJ,
  ESTADO,
  TRANSP,
  CFOP

select * from #NFS order by NOTAFISCAL

--Nota_Saida
-- SELECT * FROM NOTA_SAIDA
select
  --Atributos da tabela origem com o nome da tabela destino
   NOTAFISCAL                                   as cd_nota_saida,
   NOTAFISCAL                                   as cd_num_formulario_nota,
   EMISSAO                                      as dt_nota_saida,
   null                                         as cd_requisicao_faturamento,

  (select top 1 cd_operacao_fiscal from operacao_fiscal
  where
   cd_mascara_operacao = CFOP )                  as cd_operacao_fiscal,
   c.nm_fantasia_cliente                         as nm_fantasia_nota_saida,

  (select top 1 cd_transportadora from transportadora
    where
     cd_transportadora = TRANSP )                as cd_transportadora,
   2                                             as cd_destinacao_produto,
   null 					 as cd_obs_padrao_nf,
   2   						 as cd_tipo_pagamento_frete,
   cast(null as varchar)                         as ds_obs_compl_nota_saida,
   null 					 as qt_peso_liq_nota_saida,
   null 					 as qt_peso_bruto_nota_saida,
   null as                                       qt_volume_nota_saida,
   null as                                       cd_especie_embalagem,
   null as                                       nm_especie_nota_saida,
   null as                                       nm_marca_nota_saida,
   null as                                       cd_placa_nota_saida,
   null as                                       nm_numero_emb_nota_saida,
   'S'  as                                       ic_emitida_nota_saida,
   null as                                       nm_mot_cancel_nota_saida,
   null as                                       dt_cancel_nota_saida,
   null as                                       dt_saida_nota_saida,
   4    as                                       cd_usuario,
   GETDATE() as                                  dt_usuario,
   null as                                       vl_bc_icms,
   null as                                       vl_icms,
   null as                                       vl_bc_subst_icms,
   TOTAL as                                      vl_produto,
   null as                                       vl_frete,
   null as                                       vl_seguro,
   null as                                       vl_desp_acess,
   TOTAL as                                      vl_total,
   null as                                       vl_icms_subst,
   null as                                       vl_ipi,
   REPRESENTANTE as                              cd_vendedor,
   null as                                       cd_fornecedor,
   c.cd_cliente as                               cd_cliente,
   null as                                       cd_itinerario,
   null as                                       nm_obs_entrega_nota_saida,
   null as                                       nm_entregador_nota_saida,
   null as                                       cd_observacao_entrega,
   null as                                       cd_entregador,
   null as                                       ic_entrega_nota_saida,
   null as                                       sg_estado_placa,
   null as                                       cd_pedido_cliente,
   5    as                                       cd_status_nota,
   1    as                                       cd_tipo_calculo,
   null as            			         cd_num_formulario,
   CNPJ as                                       cd_cnpj_nota_saida,

--select * from cliente
     
   c.cd_inscestadual as                          cd_inscest_nota_saida,
   null as                                       cd_inscmunicipal_nota,
   null as                                       cd_cep_entrega,
   null as                                       nm_endereco_entrega,
   null as                                       cd_numero_endereco_ent,
   null as                                       nm_complemento_end_ent,
   null as                                       nm_bairro_entrega,
   c.cd_ddd as                                   cd_ddd_nota_saida,
   c.cd_telefone as 			         cd_telefone_nota_saida,
   c.cd_fax 	 as				 cd_fax_nota_saida,
   p.nm_pais     as                              nm_pais_nota_saida,
   e.sg_estado   as                              sg_estado_entrega,
   null as                                       nm_cidade_entrega,
   null as                                       hr_saida_nota_saida,
   null as                                       nm_endereco_cobranca,
   null as                                       nm_bairro_cobranca,
   null as                                       cd_cep_cobranca,
   null as                                       nm_cidade_cobranca,
   null as                                       sg_estado_cobranca,
   null as                                       cd_numero_endereco_cob,
   null as                                       nm_complemento_end_cob,
   null as                                       qt_item_nota_saida,
   null as                                       ic_outras_operacoes,
   null as                                       cd_pedido_venda,
   'E'  as                                       ic_status_nota_saida,
   CAST('' as varchar) as                        ds_descricao_servico,
   null as                                       vl_iss,
   null as                                       vl_servico,
   null as                                       ic_minuta_nota_saida,
   null as                                       dt_entrega_nota_saida,
   e.sg_estado   as                              sg_estado_nota_saida,
   cid.nm_cidade as                              nm_cidade_nota_saida,
   c.nm_bairro   as                              nm_bairro_nota_saida,
   c.cd_numero_endereco as                       nm_endereco_nota_saida,

--select * from cliente

   c.cd_numero_endereco as                       cd_numero_end_nota_saida,
   c.cd_cep             as                       cd_cep_nota_saida,
   c.nm_razao_social_cliente   as                nm_razao_social_nota,
   c.nm_razao_social_cliente_c as                nm_razao_social_c,
   CFOP                        as                cd_mascara_operacao,
   (select top 1 nm_operacao_fiscal from operacao_fiscal
    where
       cd_mascara_operacao = CFOP  )as           nm_operacao_fiscal,
   1    as                                       cd_tipo_destinatario,
   null as                                       cd_contrato_servico,

  (select top 1 cd_condicao_pagamento from condicao_pagamento
   where
   cd_condicao_pagamento = QTDEPGTO ) as         cd_condicao_pagamento,

   null as                                       vl_irrf_nota_saida,
   null as                                       pc_irrf_serv_empresa,
   c.nm_fantasia_cliente as                      nm_fantasia_destinatario,
   null as                                       nm_compl_endereco_nota,
   null as                                       ic_sedex_nota_saida,
   null as                                       ic_coleta_nota_saida,
   null as                                       dt_coleta_nota_saida,
   null as                                       nm_coleta_nota_saida,
   null as                                       cd_tipo_local_entrega,
   null as                                       ic_dev_nota_saida,
   null as                                       cd_nota_dev_nota_saida,
   null as                                       dt_nota_dev_nota_saida,
   c.nm_razao_social_cliente                  as nm_razao_social_cliente,
   c.nm_razao_social_cliente_c                as nm_razao_socila_cliente_c,

   --Tratar da tabela operacao_fioscal
   1    as                                       cd_tipo_operacao_fiscal,
   null as                                       vl_bc_ipi,
   null as                                       cd_mascara_operacao3,
   null as                                       cd_mascara_operacao2,
   null as                                       cd_operacao_fiscal3,
   null as                                       cd_operacao_fiscal2,
   null as                                       nm_operacao_fiscal2,
   null as                                       nm_operacao_fiscal3,
   null as                                       cd_tipo_operacao_fiscal2,
   null as                                       cd_tipo_operacao_fiscal3,
   null as                                       cd_tipo_operacao3,
   null as                                       cd_tipo_operacao2,
   'N'  as                                       ic_zona_franca,
   null as                                       cd_nota_fiscal_origem,
   'M'  as                                       ic_forma_nota_saida,
   1    as                                       cd_serie_nota,
   c.cd_vendedor as                              cd_vendedor_externo,
   null as                                       nm_local_entrega_nota,
   null as                                       cd_cnpj_entrega_nota,
   null as                                       cd_inscest_entrega_nota,
   null as                                       vl_base_icms_reduzida,
   null as                                       vl_bc_icms_reduzida,
   null as                                       cd_dde_nota_saida,
   null as                                       dt_dde_nota_saida,
   null as                                       nm_fat_com_nota_saida,
   null as                                       vl_icms_isento,
   null as                                       vl_icms_outros,
   null as                                       vl_icms_obs,
   null as                                       vl_ipi_isento,
   null as                                       vl_ipi_outros,
   null as                                       vl_ipi_obs,
   'N'  as                                       ic_mp66_item_nota_saida,
   'N'  as                                       ic_fiscal_nota_saida,
   1    as                                       cd_pais,
   1    as                                       cd_moeda,
   null as                                       dt_cambio_nota_saida,
   null as                                       vl_cambio_nota_saida,
   null as                                       qt_desconto_nota_saida,
   null as                                       vl_desconto_nota_saida,
   null as                                       qt_peso_real_nota_saida,
  cast(null as varchar) as                       ds_obs_usuario_nota_saida,
   null as                                       ic_obs_usuario_nota_saida,
   null as                                       cd_requisicao_fat_ant,
   null as                                       qt_ord_entrega_nota_saida,
   null as                                       ic_credito_icms_nota,
   null as                                       ic_locacao_cilindro_nota,
   null as                                       ic_smo_nota_saida,
   null as                                       cd_di,
   null as                                       cd_guia_trafego_nota_said,
   null as                                       dt_lancamento_entrega,
   null as                                       vl_iss_retido,
   null as                                       vl_cofins,
   null as                                       vl_pis,
   null as                                       vl_csll,
   null as                                       nm_mot_ativacao_nota_saida,
   null as                                       vl_desp_aduaneira,
   null as                                       ic_di_carregada,
   null as                                       vl_ii,
   null as                                       pc_ii,
   null as                                       ic_cupom_fiscal,
   null as                                       cd_cupom_fiscal,
   null as                                       cd_loja,
   null as                                       vl_simbolico,
   null as                                       cd_identificacao_nota_saida,
   null as                                       cd_coleta_nota_saida,
   null as                                       qt_ord_entregador_saida,
   null as                                       vl_inss_nota_saida,
   null as                                       pc_inss_servico,
   null as                                       cd_serie_nota_fiscal,
   null as                                       vl_icms_desconto,
   null as                                       ic_etiqueta_nota_saida,
   null as                                       ic_imposto_nota_saida,
   null as                                       qt_cubagem_nota_saida,
   null as                                       ic_peso_recalcular,
   null as                                       qt_formulario_nota_saida,
   null as                                       ic_reprocessar_dados_adic,
   null as                                       vl_mp_aplicada_nota,
   null as                                       vl_mo_aplicada_nota,
   null as                                       ic_reprocessar_parcela,
   null as                                       ic_sel_nota_saida,
   null as                                       cd_ordem_carga,
   null as                                       cd_veiculo,
   null as                                       cd_motorista,
   null as                                       cd_forma_pagamento,
   null as                                       ic_nfe_nota_saida,
   null as                                       cd_motivo_dev_nota
  
into
  #nota_saida

from
  --Tabela Origem
  #NFS x
  left outer join cliente c  on c.cd_cnpj_cliente = x.CNPJ
  left outer join pais p     on p.cd_pais  = c.cd_pais
  left outer join estado e   on e.cd_estado = c.cd_estado
  left outer join cidade cid on cid.cd_cidade = c.cd_cidade

where
  cast(NOTAFISCAL as int ) not in ( select cd_nota_saida from nota_saida )

--select * from migracao.dbo.NFSJAN2009

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  --Tabela Destino 
  nota_saida
select
  *
from
  #nota_saida


--Deleção da Tabela Temporária

drop table #nota_saida


--Mostra os registros migrados
select * from nota_saida

--Itens da Nota de Saída
--SELECT * FROM  migracao.dbo.NFSJAN2009

select
  ns.cd_nota_saida,
  x.ITEM                as cd_item_nota_saida,
  ns.cd_nota_saida      as cd_num_formulario_nota,
  'ESPECIAL'            as nm_fantasia_produto,
  cast(TEXTO as varchar) as ds_item_nota_saida,
  null                  as cd_pd_compra_item_nota,
  null                  as cd_posicao_item_nota,
  null                  as cd_os_item_nota_saida,
  [VLRUNITARIO]         as vl_unitario_item_nota,
  null                  as dt_restricao_item_nota,
  'E'                   as ic_status_item_nota_saida,
  cast(null as varchar) as nm_motivo_restricao_item,
  null                  as qt_devolucao_item_nota,
  null                  as cd_requisicao_faturamento,
  null                  as cd_item_requisicao,
  null                  as cd_produto,
  1                     as cd_procedencia_produto,
  1                     as cd_tributacao,
  qtde * [VLRUNITARIO]  AS vl_total_item,
  12                    as cd_unidade_medida,
  18                    as pc_icms,
  IPI                   as pc_ipi,
  qtde * [VLRUNITARIO] * (IPI/100) as vl_ipi,
  4                     as cd_usuario,
  getdate()             as dt_usuario,
  QTDE                  as qt_item_nota_saida,
  null                  as qt_liquido_item_nota,
  null                  as qt_bruto_item_nota_saida,
  null                  as cd_item_pedido_venda,
  PEDIDO                as cd_pedido_venda,
  null                  as cd_categoria_produto,

  (select top 1 cd_classificacao_fiscal from classificacao_fiscal
    where
     cd_mascara_classificacao = classificacao ) as cd_classificacao_fiscal,

 '000'                  as cd_situacao_tributaria,
  null                  as vl_frete_item,
  null                  as vl_seguro_item,
  null                  as vl_desp_acess_item,
  null                  as pc_icms_desc_item,
  null                  as dt_cancel_item_nota_saida,
  null                  as pc_desconto_item,
  null                  as cd_tipo_calculo,
  null                  as cd_lote_produto,
  null                  as cd_numero_serie_produto,
  5                     as cd_status_nota,
  cast(TEXTO AS VARCHAR(80)) as nm_produto_item_nota,
  null                  as qt_saldo_atual_produto,
  null                  as cd_servico,
  CAST('' AS VARCHAR)   as ds_servico,
  null                  as pc_iss_servico,
  null                  as vl_servico,
  null                  as pc_irrf_serv_empresa,
  null                  as vl_irrf_nota_saida,
  null                  as vl_iss_servico,
  null                  as pc_reducao_icms,
  null                  as cd_pdcompra_item_nota,
  null                  as cd_registro_exportacao,
  ns.cd_operacao_fiscal,
  'P'                   as ic_tipo_nota_saida_item,
  null                  as qt_saldo_estoque,
  null                  as cd_di,
  null                  as nm_di,
  null                  as nm_invoice,
  null                  as ic_movimento_estoque,
  null                  as qt_ant_item_nota_saida,
  null                  as nm_kardex_item_nota_saida,
  null                  as ic_dev_nota_saida,
  null                  as cd_nota_dev_nota_saida,
  null                  as cd_pedido_importacao,
  null                  as cd_item_ped_imp,
  ns.dt_nota_saida,
  null                  as cd_grupo_produto,
  null                  as vl_icms_item,
  null                  as vl_base_icms_item,
  null                  as vl_base_ipi_item,
  null                  as pc_subs_trib_item,
  null                  as cd_reg_exportacao_item,
  null                  as vl_icms_isento_item,
  null                  as vl_icms_outros_item,
  null                  as vl_icms_obs_item,
  null                  as vl_ipi_isento_item,
  null                  as vl_ipi_outros_item,
  null                  as vl_ipi_obs_item,
  3                     as cd_fase_produto,
  null                  as ic_mp66_item_nota_saida,
  null                  as cd_mascara_produto,
  null                  as cd_conta,
  null                  as cd_produto_smo,
  null                  as cd_grupo_produto_smo,
  null                  as vl_ipi_corpo_nota_saida,
  null                  as ic_icms_zerado_item,
  null                  as ic_ipi_zerado_item,
  null                  as vl_bc_subst_icms_item,
  null                  as cd_tributacao_anterior,
  null                  as cd_di_item,
  null                  as ic_iss_servico,
  null                  as vl_cofins,
  null                  as vl_pis,
  null                  as vl_csll,
  null                  as dt_ativacao_nota_saida,
  1                     as cd_moeda_cotacao,
  null                  as vl_moeda_cotacao,
  null                  as dt_moeda_cotacao,
  null                  as cd_lote_item_nota_saida,
  null                  as cd_num_serie_item_nota,
  null                  as vl_ii,
  null                  as pc_ii,
  null                  as vl_desp_aduaneira_item,
  null                  as pc_cofins,
  null                  as pc_pis,
  null                  as ic_cambio_fixado_pedido_venda,
  null                  as ic_perda_item_nota_saida,
  null                  as cd_lote_item_nota,
  null                  as vl_inss_nota_saida,
  null                  as pc_inss_servico,
  null                  as vl_icms_desc_item,
  null                  as vl_icms_subst_icms_item,
  null                  as qt_cubagem_item_nota,
  null                  as cd_rnc,
  null                  as cd_nota_entrada,
  null                  as cd_item_nota_entrada,
  null                  as ic_subst_tributaria_item,
  null                  as cd_nota_saida_origem,
  null                  as cd_item_nota_origem,
  null                  as vl_unitario_ipi_produto,
  null                  as qt_multiplo_embalagem,
  null                  as cd_motivo_dev_nota,
  null                  as pc_reducao_icms_st

into
  #nota_saida_item
from
  migracao.dbo.NFSMAR_ABR2009 x
  inner join nota_saida ns on ns.cd_nota_saida = cast(x.NOTAFISCAL as int )
 
insert into
  nota_saida_item
select
  * 
from 
  #nota_saida_item

drop table #nota_saida_item

select * from nota_saida_item


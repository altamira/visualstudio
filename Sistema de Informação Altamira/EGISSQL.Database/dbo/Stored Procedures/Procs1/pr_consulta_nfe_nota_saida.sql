
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_nfe_nota_saida
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta das Notas Fiscais Eletrônicas
--Data             : 14.11.2008
--Alteração        : 22.11.2008 - Ajustes Diversos - Carlos Fernandes
-- 04.12.2008 - Tabela de Nota de Recibo - Carlos Fernandes
-- 05.12.2008 - Ajustes - Carlos Fernandes
-- 18.07.2009 - Filtro apenas para Notas Fiscais ( Tipo de Pedido - filtrar )
-- 27.08.2009 - Identificar Nota Fiscal de Importação - Carlos Fernandes
-- 11.09.2009 - Nota Fiscal de Complemento de Preço - Carlos Fernandes
-- 29.09.2009 - Filtro por Tipo de Nota de Serviço - Carlos Fernandes 
-- 21.04.2010 - Novo Flag para mostrar se foi gerado e-mail - Carlos Fernandes
-- 08.06.2010 - Flag para Nota Cancelada - Carlos Fernandes
-- 27.09.2010 - Ajuste para novo lay-out v2.00 - Carlos Fernandes

------------------------------------------------------------------------------
create procedure pr_consulta_nfe_nota_saida  
@cd_nota_saida int      = 0,  
@dt_inicial    datetime = '',  
@dt_final      datetime = ''  
  
as  
  
declare @cd_nota_saida_v110 int
declare @sg_versao_nfe      char(10)

set @cd_nota_saida_v110 = 0

--select * from versao_nfe

select
  @cd_nota_saida_v110 = isnull(cd_nota_saida,0),
  @sg_versao_nfe      = isnull(sg_versao_nfe,'2.00')
from
  versao_nfe with (nolock)
where
  cd_empresa = dbo.fn_empresa()


select   
  0                                                                                                         as Selecionado,  
  '55'                                                                                                      as 'mod',  
  substring(cast(year(ns.dt_nota_saida) as varchar(4)),3,2)                                                 as 'Ano',   
  ltrim(rtrim(cast(isnull(sn.qt_serie_nota_fiscal,0) as varchar(3))))                                       as 'serie',  

  case when  ns.cd_identificacao_nota_saida <= @cd_nota_saida_v110 then
   '1.10'
  else
   @sg_versao_nfe
  end                                                                                                       as 'sg_versao_nfe',
        
  case when  ns.cd_identificacao_nota_saida <= @cd_nota_saida_v110 then
    substring(substring(vw110.chaveAcesso,4,len(vw110.chaveacesso)),1,1)       
  else
    substring(substring(vw.chaveAcesso,4,len(vw.chaveacesso)),1,1)       
  end                                                                                                       as 'PosicaoInicial',  

  case when  ns.cd_identificacao_nota_saida <= @cd_nota_saida_v110 then
    substring(substring(vw110.chaveAcesso,4,len(vw110.chaveacesso)),len(substring(vw110.chaveAcesso,4,len(vw110.chaveacesso))) - 1,2)
  else
    substring(substring(vw.chaveAcesso,4,len(vw.chaveacesso)),len(substring(vw.chaveAcesso,4,len(vw.chaveacesso))) - 1,2)
  end                                                                                                       as 'PosicaoFinal',  

  cast(dbo.fn_Formata_Mascara('00000000000000',e.cd_cgc_empresa) as varchar(14))                            as 'CNPJ',  
  
  ns.cd_nota_saida                                                                                          as cd_controle,

--   case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
--      ns.cd_identificacao_nota_saida 
--   else
--      ns.cd_nota_saida
--   end                                                                                                       as cd_nota_saida,

  ns.cd_nota_saida,

  --Identificacação da Nota de Saída------------------------------------------------------------------------------

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida
  else
    ns.cd_nota_saida
  end                as cd_identificacao_nota_saida,

  ns.cd_num_formulario_nota,  
  ns.dt_nota_saida,  
  ns.cd_requisicao_faturamento,  
  ns.cd_operacao_fiscal,  
  ns.nm_fantasia_nota_saida,  
  ns.cd_transportadora,  
  ns.cd_destinacao_produto,  
  ns.cd_obs_padrao_nf,  
  ns.cd_tipo_pagamento_frete,  
  ns.qt_peso_liq_nota_saida,  
  ns.qt_peso_bruto_nota_saida,  
  ns.qt_volume_nota_saida,  
  ns.cd_especie_embalagem,  
  ns.nm_especie_nota_saida,  
  ns.nm_marca_nota_saida,  
  ns.cd_placa_nota_saida,  
  ns.nm_numero_emb_nota_saida,  
  ns.ic_emitida_nota_saida,  
  ns.nm_mot_cancel_nota_saida,  
  ns.dt_cancel_nota_saida,  
  ns.dt_saida_nota_saida,  
  ns.cd_usuario,  
  ns.dt_usuario,  
  cast(round(ns.vl_bc_icms,2)       as decimal(25,2)) as vl_bc_icms,  
  cast(round(ns.vl_icms,2)          as decimal(25,2)) as vl_icms,  
  cast(round(ns.vl_bc_subst_icms,2) as decimal(25,2)) as vl_bc_subst_icms,  
  cast(round(ns.vl_produto,2) as decimal(25,2))       as vl_produto,  
  cast(round(ns.vl_frete,2) as decimal(25,2))         as vl_frete,  
  cast(round(ns.vl_seguro,2) as decimal(25,2))        as vl_seguro,  
  cast(round(ns.vl_desp_acess,2) as decimal(25,2))    as vl_desp_acess,  
  cast(round(ns.vl_total,2) as decimal(25,2))         as vl_total,  
  cast(round(ns.vl_icms_subst,2) as decimal(25,2))    as vl_icms_subst,  
  cast(round(ns.vl_ipi,2) as decimal(25,2))           as vl_ipi,  
  ns.cd_vendedor,  
  ns.cd_fornecedor,  
  ns.cd_cliente,  
  ns.cd_itinerario,  
  ns.nm_obs_entrega_nota_saida,  
  ns.nm_entregador_nota_saida,  
  ns.cd_observacao_entrega,  
  ns.cd_entregador,  
  ns.ic_entrega_nota_saida,  
  ns.sg_estado_placa,  
  ns.cd_pedido_cliente,  
  ns.cd_status_nota,  
  ns.cd_tipo_calculo,  
  ns.cd_num_formulario,  
  ns.cd_cnpj_nota_saida,  
  ns.cd_inscest_nota_saida,  
  ns.cd_inscmunicipal_nota,  
  ns.cd_cep_entrega,  
  ns.nm_endereco_entrega,  
  ns.cd_numero_endereco_ent,  
  ns.nm_complemento_end_ent,  
  ns.nm_bairro_entrega,  
  ns.cd_ddd_nota_saida,  
  ns.cd_telefone_nota_saida,  
  ns.cd_fax_nota_saida,  
  ns.nm_pais_nota_saida,  
  ns.sg_estado_entrega,  
  ns.nm_cidade_entrega,  
  ns.hr_saida_nota_saida,  
  ns.nm_endereco_cobranca,  
  ns.nm_bairro_cobranca,  
  ns.cd_cep_cobranca,  
  ns.nm_cidade_cobranca,  
  ns.sg_estado_cobranca,  
  ns.cd_numero_endereco_cob,  
  ns.nm_complemento_end_cob,  
  ns.qt_item_nota_saida,  
  ns.ic_outras_operacoes,  
  ns.cd_pedido_venda,  
  ns.ic_status_nota_saida,  
  cast(round(ns.vl_iss,2) as decimal(25,2))             as vl_iss,  
  cast(round(ns.vl_servico,2) as decimal(25,2))         as vl_servico,  
  cast(round(ns.vl_inss_nota_saida,2) as decimal(25,2)) as vl_inss,  
  cast(round(ns.vl_csll,2) as decimal(25,2))            as vl_csll,  
  ns.ic_minuta_nota_saida,  
  ns.dt_entrega_nota_saida,  
  ns.sg_estado_nota_saida,  
  ns.nm_cidade_nota_saida,  
  ns.nm_bairro_nota_saida,  
  ns.nm_endereco_nota_saida,  
  ns.cd_numero_end_nota_saida,  
  ns.cd_cep_nota_saida,  
  ns.nm_razao_social_nota,  
  ns.nm_razao_social_c,  
  ns.cd_mascara_operacao,  
  ns.nm_operacao_fiscal,  
  ns.cd_tipo_destinatario,  
  ns.cd_contrato_servico,  
  ns.cd_condicao_pagamento,  
  cast(round(ns.vl_irrf_nota_saida,2) as decimal(25,2)) as vl_irrf_nota_saida,  
  ns.pc_irrf_serv_empresa,  
  ns.nm_fantasia_destinatario,  
  ns.nm_compl_endereco_nota,  
  ns.ic_sedex_nota_saida,  
  ns.ic_coleta_nota_saida,  
  ns.dt_coleta_nota_saida,  
  ns.nm_coleta_nota_saida,  
  ns.cd_tipo_local_entrega,  
  ns.ic_dev_nota_saida,  
  ns.cd_nota_dev_nota_saida,  
  ns.dt_nota_dev_nota_saida,  
  ns.nm_razao_social_cliente,  
  ns.nm_razao_socila_cliente_c,  
  ns.cd_tipo_operacao_fiscal,  
  cast(round(ns.vl_bc_ipi,2) as decimal(25,2))  as vl_bc_ipi,  
  ns.cd_operacao_fiscal2,  
  ns.cd_operacao_fiscal3,  
  ns.cd_mascara_operacao2,  
  ns.cd_mascara_operacao3,  
  ns.nm_operacao_fiscal2,  
  ns.nm_operacao_fiscal3,  
  ns.cd_tipo_operacao_fiscal2,  
  ns.cd_tipo_operacao_fiscal3,  
  ns.cd_tipo_operacao2,  
  ns.cd_tipo_operacao3,  
  ns.ic_zona_franca,  
  ns.vl_cofins,  
  ns.vl_pis,  
  ns.vl_desp_aduaneira,  
  ns.vl_ii,  
  ns.vl_mo_aplicada_nota,  
  ns.vl_mp_aplicada_nota,  
  dp.nm_destinacao_produto,  
  ns.ic_forma_nota_saida,  
  cast(null as char(1)) as ic_editada_slf,  
--   IsNull(  
--     (Select top 1 IsNull(i.ic_fiscal_nota_saida_reg,'N')  
--      From Nota_Saida_Registro i with (nolock)   
--      where i.cd_nota_saida = ns.cd_nota_saida),'N'  
--   ) as ic_editada_slf,  
  cg.nm_cliente_grupo,  
  
--   cd_carta_correcao = isnull((select top 1 c.cd_carta_correcao   
--                               from Carta_Correcao c with (nolock)   
--                               where ns.cd_nota_saida = c.cd_nota_saida),0),  
  cast(0 as int ) as cd_carta_correcao,  
  
  isnull(ofp.ic_comercial_operacao,'N') as ic_comercial_operacao,  

  sn.qt_serie_nota_fiscal,
  sn.nm_serie_nota_fiscal,
  sn.sg_serie_nota_fiscal,  
  
--   ( select count(*)   
--     from  
--      Nota_saida_Item nsi (nolock)   
--     where    
--      nsi.cd_nota_saida = ns.cd_nota_saida ) as qtd_item,  
  
  0 as qtd_item,  
  
--   
--   ( select sum( isnull( qt_item_nota_saida,0) )   
--     from  
--      Nota_saida_Item nsi with (nolock)   
--     where   
--      nsi.cd_nota_saida = ns.cd_nota_saida )  as qtd_total_item,   
  
  0.00                                             as qtd_total_item,  
  
   isnull(cp.nm_condicao_pagamento,'')             as nm_condicao_pagamento,  
   isnull(u.nm_fantasia_usuario,'')                as nm_fantasia_usuario,  
   isnull(t.nm_fantasia,'')                        as nm_fantasia_transportadora,  
   isnull(tpf.nm_tipo_pagamento_frete,'')          as nm_tipo_pagamento_frete,  
   isnull(ns.ic_nfe_nota_saida,'N')                as ic_nfe_nota_saida,  

  case when  ns.cd_identificacao_nota_saida <= @cd_nota_saida_v110 then
     substring(vw110.chaveAcesso,4,len(vw110.chaveacesso)) 
   else
     substring(vw.chaveAcesso,4,len(vw.chaveacesso)) 
   end                                             as ChaveAcesso,  

   nsr.cd_recibo_nfe_nota_saida,  
   nsr.cd_recibo_backup,
   nsr.cd_protocolo_nfe,
   nsr.dt_autorizacao_nota,
   nsr.nm_arquivo_envio_xml,
   nsr.nm_arquivo_recibo,

   --select * from nota_saida_recibo
   --Nota Fiscal de Importação
   --select * from operacao_fiscal
   isnull(ofp.ic_importacao_op_fiscal,'N')  as ic_importacao,
   sno.nm_status_nota,
   isnull(ofp.ic_complemento_op_fiscal,'N') as ic_complemento_op_fiscal,
   isnull(nsr.ic_email_nota_saida,'N')      as ic_email_nota_saida,
   case when ns.cd_status_nota = 7 and isnull(nsr.ic_cancelada_nfe,'N') = 'N'
   then
     'S'
   else
      isnull(nsr.ic_cancelada_nfe,'N')   
   end                                      as ic_cancelada_nfe 

into
  #NFE
  
from  
  Nota_Saida ns                                 WITH (NOLOCK)  
  left outer join status_nota sno               WITH (NOLOCK) on sno.cd_status_nota           = ns.cd_status_nota
  left outer join egisadmin.dbo.empresa e       WITH (NOLOCK) on e.cd_empresa                 = dbo.fn_empresa()   
  left outer join Cliente cl                    WITH (NOLOCK) on ns.cd_cliente                = cl.cd_cliente   
  left outer join Cliente_Grupo cg              WITH (NOLOCK) on cl.cd_cliente_grupo          = cg.cd_cliente_grupo  
  left outer join Operacao_Fiscal ofp           WITH (NOLOCK) on ns.cd_operacao_fiscal        = ofp.cd_operacao_fiscal  
  left outer join Serie_Nota_Fiscal sn          WITH (NOLOCK) on sn.cd_serie_nota_fiscal      = ns.cd_serie_nota  
  left outer join Condicao_Pagamento cp         WITH (NOLOCK) on cp.cd_condicao_pagamento     = ns.cd_condicao_pagamento  
  left outer join egisadmin.dbo.usuario u       WITH (NOLOCK) on u.cd_usuario                 = ns.cd_usuario  
  left outer join Transportadora t              WITH (NOLOCK) on t.cd_transportadora          = ns.cd_transportadora  
  left outer join Tipo_Pagamento_Frete tpf      WITH (NOLOCK) on tpf.cd_tipo_pagamento_frete  = ns.cd_tipo_pagamento_frete  
  left outer join vw_nfe_chave_acesso  vw       with (nolock) on vw.cd_nota_saida             = ns.cd_nota_saida  
  left outer join Nota_Saida_Recibo   nsr       with (nolock) on nsr.cd_nota_saida            = ns.cd_nota_saida  
  left outer join Destinacao_Produto dp         with (nolock) on dp.cd_destinacao_produto     = ns.cd_destinacao_produto  
  left outer join Grupo_Operacao_Fiscal gof     with (nolock) on gof.cd_grupo_operacao_fiscal = ofp.cd_grupo_operacao_fiscal
  left outer join vw_nfe_chave_acesso_110 vw110 with (nolock) on vw110.cd_nota_saida          = ns.cd_nota_saida  


where  
  ns.cd_nota_saida                     = case when @cd_nota_saida = 0 then ns.cd_nota_saida else @cd_nota_saida end  
--  and isnull(ns.ic_nfe_nota_saida,'N') = case when @cd_nota_saida = 0 then 'N'              else isnull(ns.ic_nfe_nota_saida,'N') end  
  and ns.dt_nota_saida between           case when @cd_nota_saida = 0 then @dt_inicial      else ns.dt_nota_saida end   
                                     and case when @cd_nota_saida = 0 then @dt_final        else ns.dt_nota_saida end  
  and isnull(ic_nfe_grupo_operacao,'S') = 'S'
    
order by  
  ns.cd_nota_saida desc  

--Filtro de Notas c/ Pedido de Venda

select
  n.cd_nota_saida,
  ni.cd_pedido_venda,
  ni.cd_item_pedido_venda,
  pv.cd_tipo_pedido,
  tp.ic_imposto_tipo_pedido

into
  #NotaTipoPedido

from
  #NFE n
  inner join nota_saida_item ni on ni.cd_nota_saida   = n.cd_nota_saida
  inner join pedido_venda pv    on pv.cd_pedido_venda = ni.cd_pedido_venda
  inner join tipo_pedido tp     on tp.cd_tipo_pedido  = pv.cd_tipo_pedido

where
  isnull(tp.ic_imposto_tipo_pedido,'N')='N' and
  isnull(ni.cd_pedido_venda,0)>0
  

delete from
  #NFE
where
  cd_nota_saida in ( select cd_nota_saida from #NotaTipoPedido )


--select * from tipo_pedido

--Mostra a Tabela Final

select 
  * 
from
  #NFE
order by
  cd_nota_saida 
  
--select * from vw_nfe_chave_acesso  
  



CREATE  VIEW vw_exporta_nota_fiscal
--vw_exporta_nota_fiscal  
---------------------------------------------------------  
--GBS - Global Business Solution              2003  
--Stored Procedure : Microsoft SQL Server       2003  
--Autor(es)  : Alexandre Del Soldato  
--Banco de Dados : EGISSQL  
--Objetivo  : Exportação da Nota Fiscal de Saída  
--Data   : 15/12/2003  
---------------------------------------------------  
as  
  
  
select distinct  
  
  'NFS' + cast(ns.cd_nota_saida as varchar(10)) as 'IDENTIFICADOR_CONTROLE',  
  ns.cd_tipo_operacao_fiscal,  
  
  ns.cd_cliente as 'CODIGO',  
  
  Case  
    When isnull(vw.cd_pais,1) = 1 then  
      case when vw.cd_tipo_pessoa = 1 then  
        cast(dbo.fn_formata_mascara('00.000.000/0000-00',vw.cd_cnpj) as varchar(18))  
      else  
        cast(dbo.fn_formata_mascara('000.000.000-00',vw.cd_cnpj) as varchar(18))  
      end       
    else  
      case when vw.cd_tipo_pessoa = 1 then  
        cast( vw.cd_destinatario + 40000 as varchar(18) )  
      else  
        cast( vw.cd_destinatario + 50000 as varchar(18) )  
      end  
  end as 'CNPJ',  
  
  case when rtrim(ns.cd_mascara_operacao) = ''  
       then  
         null  
       else rtrim(ns.cd_mascara_operacao) + '.' +  
        (case when len(cast(ofi.cd_destinacao_produto as varchar)) > 1 then '' else '0' end) +  
        cast(ofi.cd_destinacao_produto as varchar)  
       end as 'NATUREZA',  
  
  ns.cd_nota_saida  as 'NUMERO_NF_INICO',  
  ns.cd_nota_saida  as 'NUMERO_NF_FINAL',  
  '1'           as 'MODELO',  
  'NF'    as 'ESPECIE_DOCUMENTO',  
--  ns.cd_serie_nota  as 'SERIE',  
  '1'                           as 'SERIE',   
  ns.dt_nota_saida  as 'DATA_ENTRADA',  
  ns.dt_nota_saida  as 'DATA_EMISSAO',  
  
  Case  
    when ( ofi.cd_tipo_movimento_estoque <> 1 ) -- Notas de Saída  
    then Case  
           When isnull(vw.cd_pais,1) = 1 then isnull(ns.sg_estado_entrega, estdest.sg_estado)  
           else 'EX'  
         end  
    else e.sg_estado  
  end as 'ESTADO_DESTINO',  
  
  Case  
    when ( ofi.cd_tipo_movimento_estoque <> 1 ) -- Notas de Saída  
    then e.sg_estado  
    else Case  
           When isnull(vw.cd_pais,1) = 1 then isnull(ns.sg_estado_entrega, estdest.sg_estado)  
           else 'EX'  
         end  
  end as 'ESTADO_ORIGEM',  
  
  ns.vl_total   as 'VALOR_TOTAL',  
  
  isnull(nsi.pc_icms,0) as 'ALIQUOTA',  
  sum(IsNull(nsi.vl_base_icms_item,0))  as 'BASE_CALCULO',  
  sum(IsNull(nsi.vl_icms_item,0))       as 'VALOR_ICMS',  
  
  ns.vl_icms_isento  as 'VALOR_ISENTAS_ICMS',  
  ns.vl_icms_outros  as 'VALOR_OUTROS_ICMS',    
  (isnull(ns.vl_total,0) - isnull(ns.vl_produto,0)) as 'VALOR_RELATIVO',  
  
  ns.vl_servico       as 'BASE_CALCULO_1',  
  ns.vl_irrf_nota_saida as 'VALOR_PRIMEIRO',  
  ns.vl_servico       as 'BASE_CALCULO_2',  
  ns.vl_iss             as 'VALOR_SEGUNDO',  
  
  0                     as 'ACRESCIMO',  
  ns.vl_bc_ipi          as 'BASE_IPI',  
  ns.vl_ipi             as 'VALOR_IPI',  
  ns.vl_ipi_isento      as 'VALOR_ISENTAS_IPI',  
  ns.vl_ipi_outros      as 'VALOR_OUTROS_IPI',  
  ns.vl_ipi_obs         as 'VALOR_REDUCAO_IPI',  
  case when ns.cd_tipo_destinatario = 1 then (Select top 1 isnull(ic_contrib_icms_cliente,'N') from Cliente where cd_cliente = ns.cd_cliente)  
  else 'N'  
  end    as 'INDICADOR_CONTRIBUI',  
  
  null  as 'CODIGO_FISCAL',  
  case when ns.dt_cancel_nota_saida is null then 'N' else 'S' end as 'INDICADOR_CANCELAMENTO',  
  
  '' as 'OBSERVACAO',  
--  CAST(ISNULL(ns.ds_obs_compl_nota_saida,'') AS VARCHAR(50)) as 'OBSERVACAO',  
  (Select top 1 nsp.dt_parcela_nota_saida   
    from Nota_Saida_Parcela nsp where nsp.cd_nota_saida = ns.cd_nota_saida) as 'DATA_VENCIMENTO',  
  null  as 'CONTA_DEVEDORA',  
  null as 'CONTA_CREDORA',  
  ''            as 'COMPLEMENTO_HISTORICO_DEBITO',  
  null as 'COMPLEMENTO_HISTORICO_CREDITO',  
  
  MAX( IsNull(cf.ic_base_reduzida,'N') ) as 'INDICADOR'  
  
from  
  Nota_Saida ns  
  
  inner join vw_Destinatario_Rapida vw  
        on vw.cd_destinatario = ns.cd_cliente and  
           vw.cd_tipo_destinatario = ns.cd_tipo_destinatario  
  
  inner join Operacao_Fiscal ofi  
        on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal   
  
  Left  Outer Join Estado estdest  
        on estdest.cd_estado = vw.cd_estado  
  
  Left Outer join Nota_Saida_Item nsi  
        on ns.cd_nota_saida = nsi.cd_nota_saida  
  
  Left outer join classificacao_fiscal cf  
 on nsi.cd_classificacao_fiscal = cf.cd_classificacao_fiscal  
  
  , egisadmin.dbo.empresa emp  
  , Estado E  
  
where  
  emp.cd_empresa = dbo.fn_empresa()  
  and  
  e.cd_estado = emp.cd_estado  
  and  
  isnull(nsi.pc_icms,0) = isnull( (Select MAX(pc_icms)  
                                   From Nota_Saida_Item  
                                   Where cd_nota_saida = ns.cd_nota_saida), 0 )  
group by  
  
  ns.cd_nota_saida,  
  ns.cd_tipo_operacao_fiscal,  
  
  ns.cd_cliente,  
  
  Case  
    When isnull(vw.cd_pais,1) = 1 then  
      case when vw.cd_tipo_pessoa = 1 then  
        cast(dbo.fn_formata_mascara('00.000.000/0000-00',vw.cd_cnpj) as varchar(18))  
      else  
        cast(dbo.fn_formata_mascara('000.000.000-00',vw.cd_cnpj) as varchar(18))  
      end       
    else  
      case when vw.cd_tipo_pessoa = 1 then  
        cast( vw.cd_destinatario + 40000 as varchar(18) )  
      else  
        cast( vw.cd_destinatario + 50000 as varchar(18) )  
      end  
  end,  
  
  ns.cd_mascara_operacao,  
  ofi.cd_destinacao_produto,  
  
  ns.cd_nota_saida,  
  ns.cd_nota_saida,  
  ns.cd_serie_nota,  
  ns.dt_nota_saida,  
  ns.dt_nota_saida,  
  
  Case  
    when ( ofi.cd_tipo_movimento_estoque <> 1 ) -- Notas de Saída  
    then Case  
           When isnull(vw.cd_pais,1) = 1 then isnull(ns.sg_estado_entrega, estdest.sg_estado)  
           else 'EX'  
         end  
    else e.sg_estado  
  end,  
  
  Case  
    when ( ofi.cd_tipo_movimento_estoque <> 1 ) -- Notas de Saída  
    then e.sg_estado  
    else Case  
           When isnull(vw.cd_pais,1) = 1 then isnull(ns.sg_estado_entrega, estdest.sg_estado)  
           else 'EX'  
         end  
  end,  
  
  ns.vl_total,  
  
  isnull(nsi.pc_icms,0),  
  
  ns.vl_icms_isento,  
  ns.vl_icms_outros,    
  isnull(ns.vl_total,0),  
  ns.vl_produto,  
  
  ns.vl_servico,  
  ns.vl_irrf_nota_saida,  
  ns.vl_iss,  
  
  ns.vl_bc_ipi,  
  ns.vl_ipi,  
  ns.vl_ipi_isento,  
  ns.vl_ipi_outros,  
  ns.vl_ipi_obs,  
  ns.cd_tipo_destinatario,  
  ns.cd_operacao_fiscal,  
  ns.dt_cancel_nota_saida  
--  , ns.ds_obs_compl_nota_saida  
--  isnull(ns.ds_obs_compl_nota_saida,'') as 'OBSERVACAO',  
-- , isnull(ns.ds_obs_compl_nota_saida,'')  
  
  

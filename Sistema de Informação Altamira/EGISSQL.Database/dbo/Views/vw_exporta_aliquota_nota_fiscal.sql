
CREATE VIEW vw_exporta_aliquota_nota_fiscal
--vw_exporta_aliquota_nota_fiscal  
---------------------------------------------------------  
--GBS - Global Business Solution              2003  
--Stored Procedure : Microsoft SQL Server       2003  
--Autor(es)  : Alexandre Del Soldato  
--Banco de Dados : EGISSQL  
--Objetivo  : Exportação de Aliquotas Adicionais da Nota Fiscal de Saída  
--Data   : 12/12/2003  
---------------------------------------------------  
as  
  
select distinct  
  
  'NFS' + cast(ns.cd_nota_saida as varchar(10)) as 'IDENTIFICADOR_CONTROLE',  
  ns.cd_tipo_operacao_fiscal,  
  
  ns.dt_nota_saida                    as 'DATA_EMISSAO',  
  IsNull(nsi.pc_icms,0)               as 'ALIQUOTA_ICMS',  
  sum(IsNull(nsi.vl_base_icms_item,0))  as 'BASE_ICMS',  
  sum(IsNull(nsi.vl_icms_item,0))       as 'VALOR_ICMS'  
  
from  
  Nota_Saida ns  
  
  Left Outer join Nota_Saida_Item nsi  
        on ns.cd_nota_saida = nsi.cd_nota_saida  
  
 where  
   isnull(nsi.pc_icms,0) <> ( Select isnull( MAX(pc_icms), 0 )  
                              From Nota_Saida_Item  
                              Where cd_nota_saida = ns.cd_nota_saida )  
group by  
  ns.cd_tipo_operacao_fiscal,  
  ns.cd_nota_saida,  
  ns.dt_nota_saida,  
  IsNull(nsi.pc_icms,0)  
  


CREATE PROCEDURE pr_apuracao_dipj
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias Pereira da Silva
--Banco de Dados: SQL 
--Objetivo      : Apuracao Saidas do DIPJ
--Data          : 11/07/2003
--Atualizado    : 
--           
----------------------------------------------------------------------

@cd_tipo_operacao_fiscal as Integer,
@cd_ano                  as Integer


as

SELECT 
       @cd_ano as 'cd_ano',       
       gd.nm_grupo_dipi                                                as 'Grupo',
       cd.nm_categoria_dipi                                            as 'Discriminacao',

       isnull(Sum (nsi.vl_base_ipi_item),0)                            as 'ComDebitos',

       isnull(sum (nsi.vl_ipi_isento_item + nsi.vl_ipi_outros_item),0) as 'SemDebitos',

       isnull(Sum (nsi.vl_ipi),0)                                      as 'IPIDebito'
FROM 
       Nota_Saida ns       
       LEFT OUTER JOIN
       Nota_Saida_Item nsi
       ON
       ns.cd_nota_saida = nsi.cd_nota_saida
       LEFT OUTER JOIN
       Operacao_Fiscal opf
       ON
       ns.cd_operacao_fiscal = opf.cd_operacao_fiscal
       LEFT OUTER JOIN
       Categoria_Dipi cd
       ON
       opf.cd_categoria_dipi = cd.cd_categoria_dipi
       LEFT OUTER JOIN  
       Grupo_Dipi gd
       ON
       cd.cd_grupo_dipi = gd.cd_grupo_dipi
       LEFT OUTER JOIN
       Grupo_Operacao_Fiscal gof
       ON
       opf.cd_grupo_operacao_fiscal = gof.cd_grupo_operacao_fiscal
WHERE
  gof.cd_tipo_operacao_fiscal = @cd_tipo_operacao_fiscal AND
  ns.cd_status_nota           <> 7                       AND
  year(ns.dt_nota_saida)      = @cd_ano

GROUP BY 
  gd.cd_grupo_dipi,
  gd.nm_grupo_dipi,
  cd.nm_categoria_dipi


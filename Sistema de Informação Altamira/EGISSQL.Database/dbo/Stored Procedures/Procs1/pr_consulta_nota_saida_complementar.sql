
CREATE PROCEDURE pr_consulta_nota_saida_complementar
--------------------------------------------------------------------
--pr_consulta_nota_saida_complementar
--------------------------------------------------------------------
--GBS - Global Business Solution Ltda 	                        2004
--------------------------------------------------------------------
--Stored Procedure         : Microsoft SQL Server 2000
--Autor(es)                : Daniel Duela
--Banco de Dados           : EGISSQL
--Objetivo                 : Consultar uma Nota Fiscal Complementar
--Data                     : 05/05/2003
--Atualizado               : 10.11.2003 - Rafael M. Santiago
--                                      - Alterado para se trazer os dados da nota saida e nao da nota saida complementar
--                                        e colocado para filtrar se a Nota é complementar pelo Flag da Operacao Fiscal
--                         : 28/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso

-- 12.10.2010 - Número da Nota Fiscal / Identificação - Carlos Fernandes
-------------------------------------------------------------------------------------------------

@ic_parametro  int,
@cd_nota_saida int,
@dt_inicial    datetime,
@dt_final      datetime

AS

------------------------------------------------------
if @ic_parametro = 1 -- Consultar Dados.
------------------------------------------------------
begin

SELECT     
--  ns.cd_nota_saida, 
  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
       ns.cd_identificacao_nota_saida
     else
       ns.cd_nota_saida
   end                                                  as 'cd_nota_saida',

  ns.dt_nota_saida                                      as dt_nota_complemento_nota,
  ns.cd_mascara_operacao + ' - '+ op.nm_operacao_fiscal as 'nota_saida_cfop',
  td.nm_tipo_destinatario,
  ns.vl_total,
  case when isnull(nsr.cd_nota_referencia,0)>0 then
    nsr.cd_nota_referencia
  else
    ns.cd_nota_fiscal_origem
  end                                                   as cd_nota_fiscal_origem

--select * from nota_saida_referenciada

FROM         
  Nota_Saida ns                    with (nolock)

  left outer join Operacao_Fiscal op   on op.cd_operacao_fiscal   = ns.cd_operacao_fiscal 
  left outer join Tipo_Destinatario td on td.cd_tipo_destinatario = ns.cd_tipo_destinatario
  left outer join Nota_Saida_Referenciada nsr on nsr.cd_nota_saida = ns.cd_nota_saida

WHERE
  (ns.cd_nota_saida = @cd_nota_saida) or
  ((@cd_nota_saida='0') and
  (ns.dt_nota_saida between @dt_inicial and @dt_final)) and
  isnull(op.ic_complemento_op_fiscal,'N') = 'S'
  order by ns.cd_nota_saida, ns.dt_nota_saida

end

--select * from nota_saida_complemento


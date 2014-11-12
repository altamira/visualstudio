
CREATE VIEW vw_identificacao_nota_saida_entrada
------------------------------------------------------------------------------------
--sp_helptext vw_identificacao_nota_saida_entrada
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Verifica se existe a mesma nota de saída lançada no Recebimento
--                        Como nota de Entrada
--
--Data                  : 08.11.2009
--Atualização           : 
--
------------------------------------------------------------------------------------
as
 

select
  ns.cd_nota_saida,
  ns.cd_cliente,
  ns.cd_operacao_fiscal,
  ns.cd_serie_nota
from
  nota_saida ns               with (nolock) 
  inner join nota_entrada ne  with (nolock) on ne.cd_nota_entrada    = ns.cd_nota_saida      and
                                               ne.cd_fornecedor      = ns.cd_cliente         and
                                               ne.cd_operacao_fiscal = ns.cd_operacao_fiscal and
                                               ne.cd_serie_nota_fiscal = ns.cd_serie_nota

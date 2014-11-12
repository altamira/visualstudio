
-------------------------------------------------------------------------------
--pr_comissao_ajuste_pis_cofins_zona_franca
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ajuste do Cálculo de PIS/COFINS para Zona Franca
--                   Levando em consideração a Bonificação ou (%) Desconto do 
--                   Cadastro do Cliente
--Data             : 13.07.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_comissao_ajuste_pis_cofins_zona_franca
@dt_inicial datetime = '',
@dt_final   datetime = '',
@sg_estado  char(2)  = '',
@cd_nota_saida int   = 0
as

select 
  ns.cd_nota_saida, 
  ns.vl_pis,
  ns.vl_cofins,
  nsi.cd_item_nota_saida,
  nsi.vl_pis,
  nsi.vl_cofins
from 
  nota_saida ns
  inner join nota_saida_item nsi on nsi.cd_nota_saida = ns.cd_nota_saida
where 
  ns.cd_nota_saida        = case when @cd_nota_saida = 0 then ns.cd_nota_saida else @cd_nota_saida end and
  ns.sg_estado_nota_saida = @sg_estado and 
  ns.dt_nota_saida between @dt_inicial and @dt_final


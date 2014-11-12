
CREATE VIEW vw_rateio_frete_comissao
------------------------------------------------------------------------------------
--sp_helptext vw_rateio_frete_comissao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL ou EGISADMIN
--
--Objetivo	        : Rateio do Frete para Cálculo da Comissão
--
--Data                  : 14.12.2010
--Atualização           : Rateio do Frete para Cálculo da Comissão
--
------------------------------------------------------------------------------------
as

--select * from comissao_frete
--select * from vw_faturamento

select
  
  vw.cd_nota_saida,
  vw.cd_item_nota_saida,
  vw.cd_identificacao_nota_saida,
  --Cálculo do Frete-------------------------
  case when isnull(vw.vl_total,0)>0 then
     round(( vw.vl_unitario_item_total/vw.vl_total ),2) * cf.vl_frete_nota_comissao
  else
    0.00
  end                                                  as vl_item_frete_comissao
from
  vw_faturamento vw
  inner join comissao_frete cf on cf.cd_identificacao_nota_saida = vw.cd_identificacao_nota_saida


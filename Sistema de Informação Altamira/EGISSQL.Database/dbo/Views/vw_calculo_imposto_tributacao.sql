
CREATE VIEW vw_calculo_imposto_tributacao
------------------------------------------------------------------------------------
--sp_helptext vw_calculo_imposto_tributacao
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Verifica se Para Tributação o Imposto é Calculado
--
--Data                  : 01.03.2010
--Atualização           : 
--
------------------------------------------------------------------------------------
as

-- select * from tributacao
-- select * from evento_tributacao
-- select ic_evento_tributacao from composicao_tributacao where cd_tributacao = 7 and cd_evento_tributacao = 1 and cd_imposto = 1
-- 
-- --select
--   
-- 

select
  i.cd_imposto,
  i.sg_imposto                     as Imposto, 
  ct.cd_tributacao,
  ct.ic_evento_tributacao          as Calculo_Imposto,
  et.cd_evento_tributacao,
  et.sg_evento_tributacao          as Evento
from 
  Imposto i                WITH(NOLOCK), 
  Composicao_tributacao ct WITH(NOLOCK),
  Evento_tributacao et     WITH(NOLOCK)
where
   isnull(i.ic_nota_imposto,'N') ='S' and
   --i.cd_imposto            = 1 and   --Imposto     (Variável)
   i.cd_imposto            = ct.cd_imposto and
   ct.cd_tributacao        = 7 and   --Tributacao  (Variável) 
   ct.cd_evento_tributacao = 1 and   --Evento      (Fixo)
   ct.cd_evento_tributacao *= et.cd_evento_tributacao

-- order by
--    i.cd_ordem_nota_imposto,
--   et.cd_ord_evento_tributacao

 

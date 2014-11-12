--------------------------------------------------------------
--GBS - Global Business Sollution              2002
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Francisco Leite Neto
--Banco de Dados   : EGISSQL
--Objetivo         : Traz os  dados do Movimento Caixa   
--Orçamentos       : Bases, Moldes e Placas
--Data             : 09/02/2004
--------------------------------------------------------------

CREATE PROCEDURE pr_consulta_creditos_devolucao
@dt_inicial         datetime,
@dt_final           datetime
as
Select 
   mc.cd_movimento_caixa    as 'Movimento' ,
   mc.dt_movimento_caixa    as 'Data'      ,
   c.nm_fantasia_cliente    as 'Cliente'   ,
   mc.vl_credito_devolucao  as 'VlrCredito',
   mc.vl_total_venda        as 'VlrTotal'  ,
   cp.nm_condicao_pagamento as 'CondPagto' 
From
  Movimento_Caixa mc
Left Outer Join	  
  Cliente c 
On 
  c.cd_cliente = mc.cd_cliente
Left Outer Join	  
  Condicao_Pagamento cp  
On 
  cp.cd_condicao_pagamento = mc.cd_condicao_pagamento
where
  mc.dt_movimento_caixa between @dt_inicial and @dt_final 
and
  Isnull(mc.vl_credito_devolucao,0)> 0 
  

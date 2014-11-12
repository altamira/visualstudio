

/****** Object:  Stored Procedure dbo.pr_total_proposta_comercial    Script Date: 13/12/2002 15:08:43 ******/

CREATE PROCEDURE pr_total_proposta_comercial

@dt_inicial  datetime,
@dt_final    datetime

AS

select 
  sum(b.vl_unitario_item_consulta * b.qt_item_consulta) as 'totalconsulta'
from
  Consulta a,Consulta_itens b
Where
  a.dt_consulta between @dt_inicial and @dt_final and
  a.cd_consulta = b.cd_consulta     and
  b.dt_perda_consulta_itens is null
 



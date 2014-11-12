
create procedure pr_rel_geracao_automatica_recibo2
@dt_inicial     datetime,
@dt_final       datetime

as


Select * from
 recibo
where 
(dt_recibo between @dt_inicial and @dt_final)and
(ic_impresso_recibo = 'S')and (dt_recibo = '03/24/2004')




/****** Object:  Stored Procedure dbo.pr_cliente_fax    Script Date: 13/12/2002 15:08:14 ******/
create procedure pr_cliente_fax
as
select   a.fan_cli,
         max(a.ddd_cli) as ddd_cli,
         max(a.fax_cli) as fax_cli,
         max(a.cid_cli) as cid_cli,
         max(a.est_cli) as est_cli,
         max(isnull(b.NOM_CO,'teste'))as Nom_co
into #Aux1 
from 
         Cadcli a,cadcon b
where 
         a.ctc_cli=b.ctc_cli and
         
         a.fax_cli<>'0'      and
         a.est_cli<>'EX'
group by a.fan_cli
select   a.fan_cli,
         max(a.ddd_cli) as ddd_cli,
         max(a.fax_cli) as fax_cli,
         max(a.cid_cli) as cid_cli,
         max(a.est_cli) as est_cli,
         max(isnull(b.NOM_CO,'teste'))as Nom_co
from 
         Cadcli a,cadcon b,#Aux1 c
where 
         a.fan_cli<>c.fan_cli and
         
         a.fax_cli<>'0'      and
         a.est_cli<>'EX'
group by a.fan_cli



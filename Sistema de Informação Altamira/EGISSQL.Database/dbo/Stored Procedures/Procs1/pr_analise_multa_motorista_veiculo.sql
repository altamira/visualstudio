
-------------------------------------------------------------------------------
--pr_analise_multa_motorista_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Multas por Motorista x Veículo
--Data             : 01/10/2003
--Atualizado       : 21.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_analise_multa_motorista_veiculo
@dt_inicial datetime,
@dt_final   datetime
as

--select * from veiculo_multa
--select * from veiculo
--select * from multa_transito
select
  m.nm_motorista                                       as Motorista,
  v.nm_veiculo                                         as Veiculo,
  v.cd_placa_veiculo                                   as Placa,
  mt.nm_multa_transito                                 as Multa,
  case when isnull(vm.vl_veiculo_multa,0)=0 
       then mt.vl_multa_transito
       else vm.vl_veiculo_multa end                    as ValorMulta,
  mt.qt_ponto_multa_transito                           as Ponto 
into #Multa
from
  Veiculo_Multa vm
  left outer join Motorista            m   on m.cd_motorista              = vm.cd_motorista
  left outer join Veiculo              v   on v.cd_veiculo                = vm.cd_veiculo
  left outer join Multa_Transito      mt   on mt.cd_multa_transito        = vm.cd_multa_transito
where
  vm.dt_veiculo_multa between @dt_inicial and @dt_final

select
  Motorista,
  Veiculo,
  Placa,
  Multa,
  count(Multa)                 as Qtd,
  sum( isnull(ValorMulta,0) )  as Valor,
  sum( isnull(Ponto,0) )       as Ponto  
from
 #Multa
group by
  Motorista,
  Veiculo,
  Placa,
  Multa


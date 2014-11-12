
-------------------------------------------------------------------------------
--pr_analise_quilometragem_motorista
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de quilometragem de  Veículos
--Data             : 01/10/2003
--Atualizado       : 20.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_analise_quilometragem_motorista
@dt_inicial datetime,
@dt_final   datetime
as

--select * from veiculo_operacao
--select * from veiculo
--select * from parametro_frota


--Busca o valor de Custo da Kilometragem
declare @vl_km_empresa float
set @vl_km_empresa = 0

select
  @vl_km_empresa = isnull(vl_km_empresa,0)
from
  Parametro_Frota
where
  cd_empresa = dbo.fn_empresa()

select
  m.nm_motorista                                       as Motorista,
  vo.qt_km_inicial_operacao                            as Kmi,
  vo.qt_km_final_operacao                              as Kmf,
  vo.qt_km_final_operacao - vo.qt_km_inicial_operacao  as Km,
  @vl_km_empresa                                       as CustoKm
into #Km
from
  Veiculo_Operacao vo
  left outer join Motorista            m   on m.cd_motorista              = vo.cd_motorista

where
  vo.dt_operacao between @dt_inicial and @dt_final

select
  Motorista,
  sum(isnull(Km,0))            as Quilometragem,
  max( CustoKm )               as CustoKm,
  sum(isnull(km,0) * CustoKm ) as Total  
from
 #Km
group by
 Motorista


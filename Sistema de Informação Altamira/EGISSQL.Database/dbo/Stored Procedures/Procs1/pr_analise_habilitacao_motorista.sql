
-------------------------------------------------------------------------------
--pr_analise_habilitacao_motorista
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta das Habilitações dos Motoristas
--Data             : 01/10/2003
--Atualizado       : 20.08.2005
--------------------------------------------------------------------------------------------------
create procedure pr_analise_habilitacao_motorista
@dt_inicial datetime,
@dt_final   datetime
as

--select * from motorista

select
  case when getdate()>m.dt_valid_cnh_motorista then 'Vencida' else 'Válida' end as Status,
  m.dt_valid_cnh_motorista                                                      as DataVencimento,
  cast ( getdate() - m.dt_valid_cnh_motorista as int )                          as Dias,
  m.nm_motorista                                                                as Motorista,
  m.cd_fone_motorista                                                           as Fone,
  m.cd_celular_motorista                                                        as Celular,
  m.cd_cnh_motorista                                                            as Habilitacao,
  m.sg_categ_cnh_motorista                                                      as Categoria,
  m.dt_habilitacao_motorista                                                    as DataHab,
  cast ( getdate() - m.dt_habilitacao_motorista as int )/365                    as AnoHab
from
  Motorista m
where
  isnull(ic_ativo_motorista,'N')='S' 

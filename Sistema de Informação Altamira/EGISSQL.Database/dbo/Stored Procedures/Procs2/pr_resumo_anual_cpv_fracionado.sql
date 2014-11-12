
-------------------------------------------------------------------------------
--pr_resumo_anual_cpv_fracionado
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 14.07.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_resumo_anual_cpv_fracionado
@cd_ano int = 0
as

select 
  cpv.cd_cpv_categoria      as Codigo,
  max(cpv.nm_cpv_categoria) as Categoria,
  sum ( isnull ( case when f.cd_mes = 1  then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Janeiro,
  sum ( isnull ( case when f.cd_mes = 2  then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Fevereiro,
  sum ( isnull ( case when f.cd_mes = 3  then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Marco,
  sum ( isnull ( case when f.cd_mes = 4  then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Abril,
  sum ( isnull ( case when f.cd_mes = 5  then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Maio,
  sum ( isnull ( case when f.cd_mes = 6  then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Junho,
  sum ( isnull ( case when f.cd_mes = 7  then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Julho,
  sum ( isnull ( case when f.cd_mes = 8  then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Agosto,
  sum ( isnull ( case when f.cd_mes = 9  then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Setembo,
  sum ( isnull ( case when f.cd_mes = 10 then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Outubro,
  sum ( isnull ( case when f.cd_mes = 11 then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Novembro,
  sum ( isnull ( case when f.cd_mes = 12 then isnull(f.vl_cpv_categoria,0) else 0.00 end,0) ) as Dezembro,
  sum ( isnull(f.vl_cpv_categoria,0) )                                                        as Total
into
  #AuxCategoriaCPV
from 
  cpv_categoria cpv
  left outer join cpv_fracionado f on f.cd_cpv_categoria = cpv.cd_cpv_categoria
-- where
--    f.cd_ano = case when @cd_ano = 0 then f.cd_ano else @cd_ano end
group by
  cpv.cd_cpv_categoria  

select
  *
from
  #AuxCategoriaCPV


--select * from cpv_categoria


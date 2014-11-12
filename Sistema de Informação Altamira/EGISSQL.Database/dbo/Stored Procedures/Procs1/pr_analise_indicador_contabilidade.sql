
-----------------------------------------------------------------------------------
--pr_analise_indicador_contabilidade
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Análise dos Indicadores da Contabilidade
--                
--Data             : 30.12.2004
--Atualizado       : 
--                 : 
-----------------------------------------------------------------------------------

create procedure pr_analise_indicador_contabilidade
@dt_inicial           datetime,      --Data Inicial
@dt_final             datetime       --Data Final
as

select 
  ic.nm_indicador             as Indicador,
  icr.vl_resultado_indicador  as Resultado
from 
  indicador_contabilidade           ic,
  indicador_contabilidade_resultado icr
where
  isnull(ic_ativo_indicador,'N') = 'S'  and
  ic.cd_indicador *= icr.cd_indicador


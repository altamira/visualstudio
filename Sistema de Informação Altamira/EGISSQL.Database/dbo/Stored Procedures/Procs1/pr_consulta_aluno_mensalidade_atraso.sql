
-------------------------------------------------------------------------------
--pr_consulta_aluno_mensalidade_atraso
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Alunos com Mensalidades em Atraso
--Data             : 19.02.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_aluno_mensalidade_atraso
@dt_inicial datetime,
@dt_final   datetime
as

declare @dt_dia      datetime  
declare @cd_dias     int  
declare @dt_dia_F    datetime  
  
set @cd_dias = 0  
set @dt_dia = GetDate()  
  
set @dt_dia   = isNull(@dt_inicial, GetDate() )  
set @dt_dia_F = isNull(@dt_final,   GetDate() )  


select
  a.cd_aluno                                                   as Codigo,
  a.nm_aluno                                                   as Aluno,
  cast( a.cd_ddd_celular + a.cd_celular_aluno as varchar(15) ) as Celular,
  sa.nm_status_aluno                                           as Status,
  pa.nm_plano                                                  as Plano,
  alp.dt_vencimento_parcela                                    as DataVencimento,
  alp.vl_parcela                                               as ValorParcela
from
  aluno a
  left outer join Aluno_Plano            ap on ap.cd_aluno           = a.cd_aluno
  left outer join Plano_Academia         pa on pa.cd_plano           = ap.cd_plano
  left outer join status_aluno           sa on sa.cd_status_aluno    = a.cd_status_aluno
  inner join Aluno_Parcela              alp on alp.cd_aluno          = a.cd_aluno
where
  alp.dt_pagamento_parcela is null and
  alp.dt_vencimento_parcela < getdate()
order by
  a.nm_aluno

--select * from aluno

--select * from Aluno_Parcela
--select * from aluno_acesso



-------------------------------------------------------------------------------
--pr_migracao_egisadmin_procedimento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernandes  /  Tiago Crize
--Banco de Dados   : EgisAdmin
--Objetivo         : Migração da Tabela de Procedimentos
--Data             : 04.11.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_egisadmin_procedimento
as

--select * from procedimento
--select * from procadmin

declare @cd_procedimento int

select @cd_procedimento = max(cd_procedimento) + 1
from
  Procedimento

--select * from modulo

select
  @cd_procedimento + cast(p.Item as int ) as  cd_procedimento,
  case when p.Descricao is null then cast(p.Nome as varchar(60))
                                else cast(p.Descricao as varchar(60)) end       as nm_procedimento,
  cast(p.Nome      as varchar(80))        as nm_sql_procedimento,
  cast(p.Descricao as varchar)            as ds_procedimento,
  p.Data                                  as dt_criacao_procedimento,
  p.Alteracao                             as dt_alteracao_procedimento,
  null                                    as cd_usuario_procedimento,
  221                                     as cd_usuario,
  getdate()                               as dt_usuario,
  null                                    as CD_USUARIO_ATUALIZA,
  null                                    as DT_ATUALIZA,
  null                                    as cd_autor,
  ( select top 1 cd_modulo
    from 
     Modulo
    where 
     sg_modulo = p.Modulo )                as  cd_modulo,
  cast(null as varchar )                   as nm_arquivo_procedimento,
  cast(null as varchar )                   as ic_sap_admin,
  cast(null as varchar )                   as ds_sql_procedimento,
  cast(null as varchar )                   as ic_padrao_procedimento,
  cast(null as varchar )                   as ic_filtrar_moeda,
  'N'                                      as ic_processo_procedimento,
  cast(null as varchar )                   as ds_processo_procedimento,
  null                                     as cd_classe,
  'N'                                      as ic_selecao_parametro
into
  #Procedimento
from
  ProcAdmin p
where
  p.Nome not in ( select nm_sql_procedimento from Procedimento )

select * from #Procedimento


insert into
  Procedimento
select
  *
from
  #Procedimento

drop table #Procedimento

select * from Procedimento


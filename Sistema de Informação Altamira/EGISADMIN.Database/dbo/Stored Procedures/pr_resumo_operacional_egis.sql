
-------------------------------------------------------------------------------
--sp_helptext  pr_resumo_operacional_egis
-------------------------------------------------------------------------------
-- pr_resumo_operacional_egis
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Resumo Operacional do EGIS
--
--                   Mostrar um resumo com a quantidade de Módulo, Menus, Tabelas, etc..
--Data             : 07.03.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure  pr_resumo_operacional_egis
as


declare @cd_chave  int
declare @qt_modulo int
declare @qt_tabela int
declare @qt_classe int
declare @qt_menu   int

select
  @qt_modulo = count(*)
from
  Modulo m with (nolock) 
where
  isnull(m.ic_liberado,'N')='S'

select 
  @qt_tabela = count(*)
from
  Tabela

select 
  @qt_menu = count(*)
from
  Menu

select 
  @qt_classe = count(*)
from
  Classe


--Mostrar os Dados

set
  @cd_chave = 1


select
  @cd_chave                  as cd_chave,
  'Total de Módulo Ativos '  as 'Descricao',
  @qt_modulo                 as 'Quantidade'
into
  #Resumo_Operacional

select 
  @cd_chave = (select max(cd_chave)+1 from #Resumo_Operacional)

insert into
  #Resumo_Operacional
select
  @cd_chave   as cd_chave,
  'Total de Tabelas '                                 as 'Descricao',
  @qt_Tabela                                          as 'Quantidade'

select 
  @cd_chave = (select max(cd_chave)+1 from #Resumo_Operacional)

insert into
  #Resumo_Operacional
select
  @cd_chave   as cd_chave,
  'Total de Classes '                                 as 'Descricao',
  @qt_classe                                          as 'Quantidade'


select 
  @cd_chave = (select max(cd_chave)+1 from #Resumo_Operacional)

insert into
  #Resumo_Operacional
select
  @cd_chave   as cd_chave,
  'Total de Menu '                                    as 'Descricao',
  @qt_menu                                            as 'Quantidade'


--Mostra a Tabela

select
  *
from
  #Resumo_Operacional 
order by
  cd_chave

drop table #resumo_operacional


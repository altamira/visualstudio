
create  PROCEDURE pr_descricao_modulos
@cd_modulo int
As

-- BI -> 47
-- SalesNet -> 118

-- select * from modulo where sg_modulo like 'SALES%'


-- Descrição do Atributo
select *
into #Temp_Strings
from
(
select distinct
  'ds_atributo' + cast( a.cd_tabela as varchar ) + '_' +
  cast( a.cd_atributo as varchar ) as 'Nome',
  a.nm_atributo_relatorio as 'Strings'
from atributo a inner join
     tabela t on t.cd_tabela = a.cd_tabela inner join
     menu_tabela mt on mt.cd_tabela = t.cd_tabela inner join
     modulo_funcao_menu mfm on mfm.cd_menu = mt.cd_menu
where
a.ds_atributo is not null
and
mfm.cd_modulo = @cd_modulo

union all

-- Descrição do Atributo nos Relatórios
select distinct
  'nm_atributo_relatorio' + cast( a.cd_tabela as varchar ) + '_' +
  cast( a.cd_atributo as varchar ) as 'Nome',
  a.nm_atributo_relatorio as 'Strings'
from atributo a inner join
     tabela t on t.cd_tabela = a.cd_tabela inner join
     menu_tabela mt on mt.cd_tabela = t.cd_tabela inner join
     modulo_funcao_menu mfm on mfm.cd_menu = mt.cd_menu
where
a.nm_atributo_relatorio is not null
and
mfm.cd_modulo = @cd_modulo

union all

-- Descrição do Atributo nas Consultas
select distinct
  'nm_atributo_consulta' + cast( a.cd_tabela as varchar ) + '_' +
  cast( a.cd_atributo as varchar ) as 'Nome',
  a.nm_atributo_relatorio as 'Strings'
from atributo a inner join
     tabela t on t.cd_tabela = a.cd_tabela inner join
     menu_tabela mt on mt.cd_tabela = t.cd_tabela inner join
     modulo_funcao_menu mfm on mfm.cd_menu = mt.cd_menu
where
a.nm_atributo_consulta is not null
and
mfm.cd_modulo = @cd_modulo
) as StringsdoBI
Order by 1

create table #Temp_StringsDFM
( Strings Varchar(1000) )

declare cr cursor for select * from #Temp_Strings
open cr

declare @Nome varchar(40)
declare @Strings varchar(1000)

FETCH NEXT FROM cr INTO @Nome, @Strings

while @@FETCH_STATUS = 0 begin

  insert into #Temp_StringsDFM (Strings)
    values ( '  object ' + @Nome + ': TLabel' )

  insert into #Temp_StringsDFM (Strings)
    values ( '    Caption = ''' + @Strings +'''' )

  insert into #Temp_StringsDFM (Strings)
    values ( '  end' )

  FETCH NEXT FROM cr INTO @Nome, @Strings
end

close cr
deallocate cr

select 'unit uStringsdosFormsPadraodoBI; ' union all
select 'interface ' union all
select 'uses ' union all
select '  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ' union all
select '  Dialogs, StdCtrls; ' union all
select 'type ' union all
select '  TfrmStringsdosFormsPadraodoBI = class(TForm) ' union all

select '  '+ Nome + ': TLabel;' from #Temp_Strings  union all

select '  private ' union all
select '  public ' union all
select '  end; ' union all
select 'var frmStringsdosFormsPadraodoBI: TfrmStringsdosFormsPadraodoBI; ' union all
select 'implementation ' union all
select '{$R *.dfm} ' union all
select 'end. ' union all
select '(*-------------------------- Fim do .pas ----------------------*)'

union all

select 'object frmStringsdosFormsPadraodoBI: TfrmStringsdosFormsPadraodoBI ' union all
select '  Left = 100 ' union all
select '  Top = 100 ' union all
select '  Width = 100 ' union all
select '  Height = 100 ' union all

select Strings from #Temp_StringsDFM  union all

select 'end '

drop table #Temp_Strings
drop table #Temp_StringsDFM



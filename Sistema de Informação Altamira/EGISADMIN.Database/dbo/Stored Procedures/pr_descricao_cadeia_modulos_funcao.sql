
CREATE  PROCEDURE pr_descricao_cadeia_modulos_funcao
As

select *
into #Temp_Strings
from
(

-- Cadeia de Valor
select distinct
  'nm_cadeia_valor' + cast( cv.cd_cadeia_valor as varchar ) as 'Nome',
  cv.nm_cadeia_valor as 'Strings'
from cadeia_valor cv

union all

/*
select distinct
  'ds_cadeia_valor' + cast( cv.cd_cadeia_valor as varchar ) as 'Nome',
  cast(cv.ds_cadeia_valor as varchar(1000)) as 'Strings'
from cadeia_valor cv
where isnull(cast(cv.ds_cadeia_valor as varchar(1000)),'') <> ''

union all
*/

-- Módulos
select distinct
  'nm_modulo' + cast( md.cd_modulo as varchar ) as 'Nome',
  md.nm_modulo as 'Strings'
from modulo md

union all

/*
select distinct
  'ds_modulo' + cast( md.cd_modulo as varchar ) as 'Nome',
  cast(md.ds_modulo as varchar(1000)) as 'Strings'
from modulo md
where isnull(cast(md.ds_modulo as varchar(1000)),'') <> ''

union all
*/

--Funções

select distinct
  'nm_funcao' + cast( f.cd_funcao as varchar ) as 'Nome',
  f.nm_funcao as 'Strings'
from funcao f

/*
union all

select distinct
  'ds_funcao' + cast( f.cd_funcao as varchar ) as 'Nome',
  cast(f.ds_funcao as varchar(1000)) as 'Strings'
from funcao f
where f.ds_funcao is not null
*/


) as Selecao order by 1
  
--drop table #Temp_StringsDFM

create table #Temp_StringsDFM
( Nome varchar(40), Strings Varchar(1000) )

declare cr cursor for select Nome, Strings from #Temp_Strings
open cr

declare @Nome varchar(40)
declare @Strings varchar(1000)

FETCH NEXT FROM cr INTO @Nome, @Strings

while @@FETCH_STATUS = 0 begin

  insert into #Temp_StringsDFM (Nome, Strings)
    values ( @Nome+'1', '  object ' + @Nome + ': TLabel' )

  insert into #Temp_StringsDFM (Nome, Strings)
    values ( @Nome+'2', '    Caption = ''' + isnull(@Strings,'') +'''' )

  insert into #Temp_StringsDFM (Nome, Strings)
    values ( @Nome+'3', '  end' )

  FETCH NEXT FROM cr INTO @Nome, @Strings
end

close cr
deallocate cr

select 'unit uStringsCadeiaValorModuloFuncao; ' union all
select 'interface ' union all
select 'uses ' union all
select '  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ' union all
select '  Dialogs, StdCtrls; ' union all
select 'type ' union all
select '  TfrmStringsCadeiaValorModuloFuncao = class(TForm) ' union all

select '  '+ Nome + ': TLabel;' from #Temp_Strings  union all

select '  private ' union all
select '  public ' union all
select '  end; ' union all
select 'var frmStringsCadeiaValorModuloFuncao: TfrmStringsCadeiaValorModuloFuncao; ' union all
select 'implementation ' union all
select '{$R *.dfm} ' union all
select 'end. ' union all
select '(*-------------------------- Fim do .pas ----------------------*)'

union all

select 'object frmStringsCadeiaValorModuloFuncao: TfrmStringsCadeiaValorModuloFuncao ' union all
select '  Left = 100 ' union all
select '  Top = 100 ' union all
select '  Width = 100 ' union all
select '  Height = 100 ' union all

select Strings from #Temp_StringsDFM union all

select 'end '

drop table #Temp_Strings
drop table #Temp_StringsDFM

--exec pr_descricao_cadeia_modulos_funcao


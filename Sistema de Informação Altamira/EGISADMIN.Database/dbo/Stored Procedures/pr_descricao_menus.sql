
CREATE  PROCEDURE pr_descricao_menus
@cd_modulo int,
@sg_modulo varchar(9)
As

set @sg_modulo = rtrim(ltrim(@sg_modulo))

-- Descrição do Atributo
select *
into #Temp_Strings
from
(
select distinct
  'nm_menu' + cast( m.cd_menu as varchar ) as 'Nome',
  m.nm_menu as 'Strings',
  mfm.cd_indice
from menu m inner join
  modulo_funcao_menu mfm on mfm.cd_menu = m.cd_menu
where
  mfm.cd_modulo = @cd_modulo

union all

select distinct
  'nm_mensagem_menu' + cast( m.cd_menu as varchar ) as 'Nome',
  m.nm_menu as 'Strings',
  mfm.cd_indice
from menu m inner join
  modulo_funcao_menu mfm on mfm.cd_menu = m.cd_menu
where
  mfm.cd_modulo = @cd_modulo

) as Selecao
Order by 3

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

select 'unit uStringsdosMenusdo' + @sg_modulo + '; ' union all
select 'interface ' union all
select 'uses ' union all
select '  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ' union all
select '  Dialogs, StdCtrls; ' union all
select 'type ' union all
select '  TfrmStringsdosMenusdo' + @sg_modulo + ' = class(TForm) ' union all

select '  '+ Nome + ': TLabel;' from #Temp_Strings  union all

select '  private ' union all
select '  public ' union all
select '  end; ' union all
select 'var frmStringsdosMenusdo' + @sg_modulo + ': TfrmStringsdosMenusdo' + @sg_modulo + '; ' union all
select 'implementation ' union all
select '{$R *.dfm} ' union all
select 'end. ' union all
select '(*-------------------------- Fim do .pas ----------------------*)'

union all

select 'object frmStringsdosMenusdo' + @sg_modulo + ': TfrmStringsdosMenusdo' + @sg_modulo + ' ' union all
select '  Left = 100 ' union all
select '  Top = 100 ' union all
select '  Width = 100 ' union all
select '  Height = 100 ' union all

select Strings from #Temp_StringsDFM union all

select 'end '

drop table #Temp_Strings
drop table #Temp_StringsDFM

--exec pr_descricao_menus 47, 'BI'
--exec pr_descricao_menus 118, 'SalesNet'
--exec pr_descricao_menus 41, 'SVD'
--exec pr_descricao_menus 54, 'SCG'
--exec pr_descricao_menus 12, 'SPE'


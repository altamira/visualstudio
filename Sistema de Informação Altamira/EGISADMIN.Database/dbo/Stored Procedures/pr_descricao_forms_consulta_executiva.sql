

create PROCEDURE pr_descricao_forms_consulta_executiva
As

--select cd_procedimento, nm_procedimento from PROCEDIMENTO

-- Descrição dos Procedimentos
select *
into #Temp_Strings
from
(

select distinct
  'nm_grupo_gerencial' + cast( cd_grupo_gerencial as varchar ) as 'Nome',
  nm_grupo_gerencial as 'Strings'
from 
  grupo_gerencial

union all

select distinct
  'nm_item_gerencial' + cast( cd_item_gerencial as varchar ) as 'Nome',
  nm_item_gerencial as 'Strings'
from 
  item_gerencial

union all

select distinct
  'nm_procedimento_grupo' + cast( p.cd_procedimento as varchar ) as 'Nome',
  p.nm_procedimento as 'Strings'
from 
  grupo_gerencial g, procedimento p
where
  g.cd_procedimento = p.cd_procedimento

union all

select distinct
  'nm_procedimento_item' + cast( p.cd_procedimento as varchar ) as 'Nome',
  p.nm_procedimento as 'Strings'
from 
  item_gerencial ig, procedimento p
where
  ig.cd_procedimento = p.cd_procedimento

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

select 'unit uStringsdaConsultaExecutiva; ' union all
select 'interface ' union all
select 'uses ' union all
select '  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, ' union all
select '  Dialogs, StdCtrls; ' union all
select 'type ' union all
select '  TfrmStringsdaConsultaExecutiva = class(TForm) ' union all

select '  '+ Nome + ': TLabel;' from #Temp_Strings  union all

select '  private ' union all
select '  public ' union all
select '  end; ' union all
select 'var frmStringsdaConsultaExecutiva: TfrmStringsdaConsultaExecutiva; ' union all
select 'implementation ' union all
select '{$R *.dfm} ' union all
select 'end. ' union all
select '(*-------------------------- Fim do .pas ----------------------*)'

union all

select 'object frmStringsdaConsultaExecutiva: TfrmStringsdaConsultaExecutiva ' union all
select '  Left = 100 ' union all
select '  Top = 100 ' union all
select '  Width = 100 ' union all
select '  Height = 100 ' union all

select Strings from #Temp_StringsDFM  union all

select 'end '

drop table #Temp_Strings
drop table #Temp_StringsDFM


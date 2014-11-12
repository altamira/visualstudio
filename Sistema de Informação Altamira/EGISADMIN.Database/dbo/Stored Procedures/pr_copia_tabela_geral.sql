
create procedure pr_copia_tabela_geral
@nm_campo_chave varchar(50), -- Nome do campo chave da tabela a ser copiada
@nm_tabela_copia varchar(50), -- Nome da tabela a ser copiada
@cd_campo_chave_old int,
@cd_campo_chave_new int,
@cd_usuario int,
@ic_so_considerar_principal char(1)

as

begin transaction

Declare @cd_empresa_new int
Declare @Tabela       varchar(50)  
declare @SQL          varchar(5000)

----------------------------------------------------------------------------------------
--COPIA As tabelas de Empresa que estão no EGISADMIN
----------------------------------------------------------------------------------------

declare @nm_name as varchar(50)


select t.name as nm_name
into #EmpresaEgis
from 
  sysobjects t left outer join
  ( select c.id, c.name
    from syscolumns c 
    where 
      ( case when c.name = 'cd_empresa' then 1
             when c.name = 'cd_usuario' then 1
             when c.name = 'dt_usuario' then 1
        else 0 end ) = 1 ) c on t.id = c.id
      
where
 t.xtype = 'U' and t.name like '%'+@nm_tabela_copia+'%' and
 ( case when (@ic_so_considerar_principal = 'S') and ( t.name = @nm_tabela_copia ) then 1 -- Já foi copiada anteriormente
        when (@ic_so_considerar_principal = 'N') and ( t.name <> @nm_tabela_copia ) then 1 -- Não foi copiada anteriormente
        else 0 end ) = 1

group by t.name
having count(c.name) = 3


while exists ( select top 1 'x' from #EmpresaEgis )
begin

  set @nm_name = ( select top 1 nm_name from #EmpresaEgis )

  set @SQL = 'Select * into #'+@nm_name+ ' from ' +@nm_name+ ' where ' + @nm_campo_chave + ' = ' + 
             cast(@cd_campo_chave_old as varchar(50)) 



  set @SQL = @SQL + ' Update #'+@nm_name+ 
             ' Set ' +
	      @nm_campo_chave + ' = ' + cast(@cd_campo_chave_new as varchar(50)) + ', ' +
              ' cd_usuario = ' + cast(@cd_usuario as varchar(2)) + ',' +
              ' dt_usuario = GetDate() ' 

  set @SQL = @SQL + ' insert into ' + @nm_name + ' select * from #'+@nm_name

 
  print(@SQL)
  exec(@SQL)

  if @@ERROR <> 0
  begin
    rollback transaction   
    return  
  end
             
  delete from #EmpresaEgis where nm_name = @nm_name

end

if @@ERROR = 0
  commit transaction


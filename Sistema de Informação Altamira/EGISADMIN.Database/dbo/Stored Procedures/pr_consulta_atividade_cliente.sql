
create procedure pr_consulta_atividade_cliente

@dt_inicial DateTime,
@dt_final DateTime,
@cd_cliente_sistema int,
@ic_conclusao_atividade char(1) -- (T) Todas (A) Aberto (C) Concluídas

as

declare @SQL_Select varchar(8000)
declare @SQL_From varchar(8000)
declare @SQL_Where_Todas varchar(8000)
declare @SQL_Where_Abertas varchar(8000)
declare @SQL_Where_Concluidas varchar(8000)
declare @SQL_Order varchar(8000)

set @SQL_Select = ''
set @SQL_From = ''
set @SQL_Where_Todas = ''
set @SQL_Where_Abertas = ''
set @SQL_Where_Concluidas = ''
set @SQL_Order = ''

set @SQL_Select = ' select 
									  cs.nm_cliente_sistema as Cliente,
									  rac.cd_registro_atividade as Item,
									  rac.dt_registro_atividade as Data,
									  ucs.nm_fantasia_usuario as Usuario,
									  mod.nm_modulo as Modulo,
									  rac.cd_atividade_cliente as Atividade,
									  rac.qt_hora_atividade as Hora,
									  con.nm_consultor as Consultor,  
									  rac.ds_registro_atividade as Descritivo,
									  rac.dt_conclusao_atividade as Conclusao'
  
set @SQL_From = ' from 
								  registro_atividade_cliente rac
               left outer join cliente_sistema cs
                 on cs.cd_cliente_sistema = rac.cd_cliente_sistema
							 left outer join usuario_cliente_sistema ucs
								 on ucs.cd_usuario_sistema = rac.cd_usuario_sistema
							 left outer join modulo mod
								 on mod.cd_modulo = rac.cd_modulo
							 left outer join consultor_implantacao con
								 on rac.cd_consultor = con.cd_consultor'

if (@ic_conclusao_atividade = 'T') 
  begin
    set @SQL_Where_Todas = ' where rac.dt_registro_atividade between ' + '''' + 
                           cast(@dt_inicial as varchar(40)) + '''' + 
                           ' and ' + '''' + 
                           cast(@dt_final as varchar(40)) + '''' +
                           ' and rac.cd_cliente_sistema  = ' + 
                           cast(@cd_cliente_sistema as varchar(40))
  end

if (@ic_conclusao_atividade = 'A') 
  begin
    set @SQL_Where_Abertas = ' where rac.dt_registro_atividade between ' + '''' + 
                             cast(@dt_inicial as varchar(40)) + '''' + 
                             ' and ' + '''' + 
                             cast(@dt_final as varchar(40)) + '''' +
                             ' and rac.cd_cliente_sistema  = ' + 
                             cast(@cd_cliente_sistema as varchar(40)) +    
                             ' and rac.dt_conclusao_atividade is Null'
  end

if (@ic_conclusao_atividade = 'C') 
  begin
    set @SQL_Where_Concluidas = ' where rac.dt_registro_atividade between ' + '''' + 
                                cast(@dt_inicial as varchar(40)) + '''' + 
                                ' and ' + '''' + 
                                cast(@dt_final as varchar(40)) + '''' +
                                ' and rac.cd_cliente_sistema  = ' + 
                                cast(@cd_cliente_sistema as varchar(40)) +
                                ' and rac.dt_conclusao_atividade is not Null'
  end

set @SQL_Order = ' order by rac.cd_registro_atividade, rac.dt_registro_atividade'

if (@ic_conclusao_atividade = 'T')
  exec(@SQL_Select + @SQL_From + @SQL_Where_Todas + @SQL_Order) 

if (@ic_conclusao_atividade = 'A') 
  exec(@SQL_Select + @SQL_From + @SQL_Where_Abertas + @SQL_Order) 

if (@ic_conclusao_atividade = 'C') 
  exec(@SQL_Select + @SQL_From + @SQL_Where_Concluidas + @SQL_Order) 


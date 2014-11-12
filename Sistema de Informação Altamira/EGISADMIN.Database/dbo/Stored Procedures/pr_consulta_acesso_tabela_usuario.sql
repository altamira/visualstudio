
-------------------------------------------------------------------------------
--pr_consulta_acesso_tabela_usuario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Márcio Rodrigues Adão
--Banco de Dados   : EgisAdmin
--Objetivo         : Consulta de acessos em Tabelas por Usuário
--Data             : 29/05/2006
--OBS              : Procedure executa muito trafego no banco, favor informar todos os para,etros para ela.Porem funciona sem a maioria dos parametros.
--Atualizado       :
 
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_acesso_tabela_usuario
@dt_inicial varchar(10),
@dt_final   varchar(10),
@cd_usuario int = 0,
@cd_tabela  int = 0,
@cd_empresa int = 0

as

   --CRIA TAELA TEMPORARIA
   CREATE TABLE #Tabela_Usuario(
       cd_usuario int,
       cd_tabela  varchar(50),
       cd_empresa varchar(15),
       Registros  int
   );

   CREATE TABLE #Tabela_Banco(
		nm_tabela varchar(100)
   );

   -- Cria a Tabela de Bancos que existem no sistema
   Select Distinct cd_empresa, nm_banco_empresa
   into #Bancos
 	from Empresa
   where  isnull(cd_empresa,0) = (case when @cd_empresa = 0 then isnull(cd_empresa,0) else @cd_empresa end)
          and   exists ( select name from master.dbo.sysdatabases where name = nm_banco_empresa )    
   order by nm_banco_empresa
   
 	Declare 	@nm_banco_empresa varchar(25)
 	Declare 	@codigo_empresa int
   Declare M_Tabela Cursor for 
	Select T.cd_Tabela, T.nm_tabela
 	from Tabela T
    where
        Exists(Select count(A.cd_atributo) from Atributo A where T.cd_tabela = A.cd_Tabela and Upper(A.nm_atributo)  in ('CD_USUARIO','DT_USUARIO')  having count(A.cd_atributo) >=2) and
        isnull(T.cd_tabela,0) = (case when @cd_tabela = 0 then isnull(T.cd_tabela,0) else @cd_tabela end) and
        cd_banco_dados = 2 and isNull(ic_inativa_tabela,'N') = 'N'
   group by 
      T.cd_Tabela, T.nm_tabela


   Declare @codigo_tabela int
   Declare @nm_tabela varchar(150)
   Declare @Existe varchar(15)
   declare @SQL as varchar(8000)
	--Laco da tabela dos bancos
	while exists ( select top 1 * from #Bancos )
	begin
        Select @codigo_empresa = cd_empresa,@nm_banco_empresa = nm_banco_empresa from #Bancos
        --inicio

	     Open M_Tabela
		  Fetch next from M_Tabela into @codigo_tabela, @nm_tabela
   	  while ( @@fetch_status = 0)
  		  begin
            delete from #Tabela_Banco
            exec('insert #Tabela_Banco SELECT name  FROM ' + @nm_banco_empresa +'.dbo.sysobjects WHERE name =''' + @nm_tabela +''' and type = ''U''')
			   if exists(Select * from #Tabela_Banco)
            begin 
						print @nm_tabela
           			Set @SQL =  'Insert #Tabela_Usuario ( cd_usuario, cd_tabela, cd_empresa, Registros) (' +
                		 			'Select cd_usuario, cast('+ cast( @codigo_tabela  as varchar(10)) + ' as int), cast(' + cast(@codigo_empresa  as varchar(10)) + ' as int),  Count(dt_usuario) as Registros from '+@nm_banco_empresa +'.dbo.' + @nm_tabela + ' ' +
				    		 			'Where isnull(cd_usuario,0) = (case when ' + cast(@cd_usuario as varchar(10)) +' = 0 then cd_usuario else ' +  cast(@cd_usuario as varchar(10)) +' end) ' +
                		 			'and dt_usuario between  ''' +   @dt_inicial + ''' and ''' +  @dt_final  + ''''+
							 			' group by cd_usuario)'
           			exec(@SQL)

				end
    		  Fetch next from M_Tabela into @codigo_tabela, @nm_tabela
  		  end

        Delete from #Bancos where nm_banco_empresa = @nm_banco_empresa
 		  Close M_Tabela	     			
   end
   Deallocate M_Tabela

   Drop Table #Bancos
   Drop Table #Tabela_Banco

   Select tu.* , t.nm_tabela, isNull(Cast(U.nm_fantasia_usuario as varchar(20)), 'Não identificado') as nm_usuario, E.nm_fantasia_empresa, E.nm_banco_empresa
   from #Tabela_Usuario tu
        left outer join Tabela  T on (T.cd_tabela  = tu.cd_tabela)
        left outer join Usuario U on (U.cd_Usuario = tu.cd_Usuario)
        left outer join Empresa E on (E.cd_Empresa = tu.cd_Empresa)   
   order by
	     tu.cd_usuario, nm_tabela

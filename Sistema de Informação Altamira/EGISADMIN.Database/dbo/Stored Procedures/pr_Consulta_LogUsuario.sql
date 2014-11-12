
CREATE PROCEDURE pr_Consulta_LogUsuario  
@cd_empresa int,  
@cd_usuario int,  
@cd_modulo int,  
@cd_funcao int,  
@cd_menu int,  
@ic_status char(1) /* A-Ativo I-Inativo*/  
AS 
BEGIN  
   Declare @SQL varchar(8000), @Where varchar(8000)  
  
   /*Define o comando de Select*/  
   set @SQL = 'Select               
                  case isNull(Usuario_Log.cd_modulo,0)  
                    when 0 then ''I''  
                    else ''A''  
                    end as ic_status,  
                  Usuario.nm_fantasia_usuario,  
                  Empresa.nm_empresa,   
                  Modulo.nm_modulo,  
                  Funcao.nm_funcao,  
                  Menu.nm_menu,  
    Usuario_Log.nm_Estacao  
                  from Usuario_Log  
                  left join Modulo on   
                  Usuario_Log.cd_modulo = Modulo.cd_modulo  
                  left join Funcao on   
                  Usuario_Log.cd_funcao = Funcao.cd_funcao  
                  left  join Menu on   
                  Usuario_Log.cd_menu = Menu.cd_menu  
                  left  join Empresa on   
                  Usuario_Log.cd_empresa = Empresa.cd_empresa  
                  Right join Usuario on   
                  Usuario_Log.cd_usuario = Usuario.cd_usuario'  
  
  
      set @Where = ''  
      /*Verifica se foi informada a empresa para filtragem*/  
      if @cd_empresa > 0  
         Set @Where = 'Usuario_Log.cd_empresa = ' + cast(@cd_empresa as varchar(5))  
      /*Verifica se foi informado o usuário para filtragem*/  
      if @cd_usuario > 0 begin  
         if @Where <> ''   
            Set @Where = @Where + ' and '  
			Set @Where = @Where + 'Usuario_Log.cd_usuario = ' + cast(@cd_usuario as varchar(5))  
      end  
      /*Verifica se foi informado o módulo para filtragem*/  
      if @cd_modulo > 0 begin  
         if @Where <> ''   
            Set @Where = @Where + ' and '  
  			Set @Where = @Where + 'Usuario_Log.cd_modulo = ' + cast(@cd_modulo as varchar(5))  
      end  
      /*Verifica se foi informada a funcao para filtragem*/  
      if @cd_funcao > 0 begin  
         if @Where <> ''   
            Set @Where = @Where + ' and '  
  			Set @Where = @Where + 'Usuario_Log.cd_funcao = ' + cast(@cd_funcao as varchar(5))  
      end  
      /*Verifica se foi informado o menu para filtragem*/  
      if @cd_menu > 0 begin  
         if @Where <> ''   
            Set @Where = @Where + ' and '  
  			Set @Where = @Where + 'Usuario_Log.cd_menu = ' + cast(@cd_menu as varchar(5))  
      end  
  
      /*Verifica se foi informado um status para filtragem*/  
      if (@ic_status = 'A') or (@ic_status = 'I') 
		begin  
         if @Where <> ''   
            Set @Where = @Where + ' and '  
  			if (@ic_status = 'A')  
     			Set @Where = @Where + 'Usuario_Log.cd_modulo > 0'  
  			if (@ic_status = 'I')  
     			Set @Where = @Where + 'IsNull(Usuario_Log.cd_modulo,0) = 0'  
      end  
  
      if @Where <> ''  
         set @SQL = @SQL + ' where ' + @Where  
  
    		/*ordena os dados pelo nome do usuário*/  
    	set @SQL = @SQL + ' order by ic_status , Usuario.nm_fantasia_usuario'  
    	/*Executa o Select*/         
    	print @SQL  
    	exec (@SQL)  
END  
  


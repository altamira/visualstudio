
-------------------------------------------------------------------------------
--pr_Copia_Meta_Vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 09/05/2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_copia_meta_vendedor
	@cd_vendedor int,
	@dt_inicial datetime,
	@dt_final datetime,
	@dt_inicial_validade datetime,
	@dt_final_validade   datetime
as
	select
  		cd_vendedor,
  		cd_categoria_produto,
  		vl_meta_categoria,
  		cd_usuario
   into
       #Temp
	from
  		Meta_Vendedor
	where
  		cd_vendedor = @cd_vendedor  and
  		dt_inicial_validade_meta >= dbo.fn_data(@dt_inicial) and
  		dt_final_validade_meta <=  dbo.fn_data(@dt_final)


   Declare M_Cursor Cursor for Select * from #Temp


	Open M_Cursor

	Declare 	@cd_meta_vendedor     int,
  				@cd_categoria_produto int,
  				@vl_meta_categoria    decimal(10,2),
  				@cd_usuario           int,
            @Table                varchar(100) 

				set @Table = db_name() + '.dbo.Meta_Vendedor'

	Fetch next from M_Cursor into @cd_vendedor,@cd_categoria_produto,@vl_meta_categoria,@cd_usuario

   while ( @@fetch_status = 0)
  	begin
	print'teste'		 
		exec egisadmin.dbo.sp_PegaCodigo @Table,cd_meta_vendedor,@codigo = @cd_meta_vendedor output      

   	insert meta_vendedor( 
			cd_meta_vendedor,
    		cd_vendedor,
    		cd_categoria_produto,
    		vl_meta_categoria,
    		dt_inicial_validade_meta,
    		dt_final_validade_meta,
    		cd_usuario,
    		dt_usuario )
		values(
			@cd_meta_vendedor,
			@cd_vendedor,
			@cd_categoria_produto,
			@vl_meta_categoria,
			@dt_inicial_validade, 
			@dt_final_validade,
			@cd_usuario,
			GetDate()
		)


		insert vendedor_meta (
				 	cd_vendedor,
         		cd_categoria_produto,
         		vl_meta_vendedor,
         		dt_inicio_meta_vendedor,
         		dt_final_meta_vendedor,
         		cd_usuario,
         		dt_usuario 
		)Values(
			@cd_vendedor,
			@cd_categoria_produto,
			@vl_meta_categoria,
			@dt_inicial_validade, 
			@dt_final_validade,
			@cd_usuario,
			GetDate()			
		)

 		Fetch next from M_Cursor into @cd_vendedor,@cd_categoria_produto,@vl_meta_categoria,@cd_usuario
  	end

	Close M_Cursor
	Deallocate M_Cursor

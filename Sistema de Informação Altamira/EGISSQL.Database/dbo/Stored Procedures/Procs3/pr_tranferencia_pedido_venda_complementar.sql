
CREATE PROCEDURE pr_tranferencia_pedido_venda_complementar
@cd_pedido_origem        int,  
@Destino        varchar(50),
@cd_pedido               int, --Código da novo Pedido
@cd_usuario              int
as
   declare @CMDDestino varchar(1000)

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_AGRUPAMENTO
--**********************************************************************************  
    select * 
    into #Pedido_Venda_Agrupamento 
    from Pedido_Venda_Agrupamento 
    where cd_pedido_venda = @cd_pedido_origem
   
   
   --Atualiza código da consulta
   update 
      #Pedido_Venda_Agrupamento
   set 
      cd_pedido_venda = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
      cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela

   Set @CMDDestino = 'insert into ' 
                     + @Destino + '.dbo.Pedido_Venda_Agrupamento 
                     select * from #Pedido_Venda_Agrupamento'

   Exec(@CMDDestino)   
--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_COMISSAO
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Comissao 
   from Pedido_Venda_Comissao 
   where cd_pedido_venda = @cd_pedido_origem
   
   --Atualiza código da consulta
   update
      #Pedido_Venda_Comissao
   set
      cd_pedido_venda   = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela  
   Set @CMDDestino = 'insert into ' 
                     + @Destino + '.dbo.Pedido_Venda_Comissao
                     select * from #Pedido_Venda_Comissao'
   Exec(@CMDDestino)   
--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_COMPOSIÇÃO
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Composicao
   from Pedido_Venda_Composicao
   where cd_pedido_venda = @cd_pedido_origem
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Composicao
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Composicao
                      select * from #Pedido_Venda_Composicao'
    Exec(@CMDDestino)
--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_COND_PAGTO
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Cond_Pagto
   from Pedido_Venda_Cond_Pagto
   where cd_pedido_venda = @cd_pedido_origem 
  

   --Atualiza código da consulta
   update
      #Pedido_Venda_Cond_Pagto
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
   Set @CMDDestino = 'insert into '  
                     + @Destino + '.dbo.Pedido_Venda_Cond_Pagto
                     select * from #Pedido_Venda_Cond_Pagto'
   Exec(@CMDDestino)   

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_DOCUMENTO	
--**********************************************************************************  
   select * into  #Pedido_Venda_Documento
   from Pedido_Venda_Documento
   where cd_pedido_venda = @cd_pedido_origem 
   

   --Atualiza código da consulta
   update
      #Pedido_Venda_Documento
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Documento
                     select * from #Pedido_Venda_Documento'
    Exec(@CMDDestino)

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_ESTRUTURA_VENDA
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Estrutura_Venda
   from Pedido_Venda_Estrutura_Venda
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Estrutura_Venda
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Estrutura_Venda
                      select * from #Pedido_Venda_Estrutura_Venda'
    Exec(@CMDDestino)

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_EXPORTACAO
--**********************************************************************************  
   select *  
   into #Pedido_Venda_Exportacao
   from Pedido_Venda_Exportacao
   where cd_pedido_venda = @cd_pedido_origem 
  

   --Atualiza código da consulta
   update
      #Pedido_Venda_Exportacao
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
   Set @CMDDestino = 'insert into ' 
                     + @Destino + '.dbo.Pedido_Venda_Exportacao
                     select  * from #Pedido_Venda_Exportacao'
  Exec(@CMDDestino)

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_SMO
--**********************************************************************************  
   select * 
   into #Pedido_Venda_SMO
   from Pedido_Venda_SMO
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_SMO
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
   Set @CMDDestino = 'insert into '
                    + @Destino + '.dbo.Pedido_Venda_SMO
                    select * from #Pedido_Venda_SMO'
   Exec(@CMDDestino) 

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_PROGRAMACAO
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Programacao
   from Pedido_Venda_Programacao
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Programacao
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                       + @Destino + '.dbo.Pedido_Venda_Programacao
                       select * from #Pedido_Venda_Programacao'
    Exec(@CMDDestino)      

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_ITEM_ACESSORIO
--**********************************************************************************  
   select * 
   into  #Pedido_Venda_Item_Acessorio
   from Pedido_Venda_Item_Acessorio
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Item_Acessorio
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Item_Acessorio
                      select * from #Pedido_Venda_Item_Acessorio'
    Exec(@CMDDestino) 

  --**********************************************************************************
  --Copia tabela: PEDIDO_VENDA_ITEM_DESCONTO
  --**********************************************************************************  
   select * 
   into  #Pedido_Venda_Item_Desconto
   from Pedido_Venda_Item_Desconto
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Item_Desconto
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Item_Desconto
                      select * from #Pedido_Venda_Item_Desconto'
    Exec(@CMDDestino)


--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_ITEM_EMBALAGEM
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Item_Embalagem
   from Pedido_Venda_Item_Embalagem
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Item_Embalagem
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                       + @Destino + '.dbo.Pedido_Venda_Item_Embalagem
                       select * from #Pedido_Venda_Item_Embalagem'
    Exec(@CMDDestino)

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_ITEM_ESPECIAL
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Item_Especial
   from Pedido_Venda_Item_Especial
   where cd_pedido_venda = @cd_pedido_origem 

  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Item_Especial
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Item_Especial
                      select * from #Pedido_Venda_Item_Especial'
    Exec(@CMDDestino)

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_ITEM_GRADE
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Item_Grade
   from Pedido_Venda_Item_Grade
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Item_Grade
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Item_Grade
                      select * from #Pedido_Venda_Item_Grade'
   Exec(@CMDDestino)

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_ITEM_LOTE
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Item_Lote
   from Pedido_Venda_Item_Lote
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Item_Lote
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Item_Lote
                      select * from #Pedido_Venda_Item_Lote'
   Exec(@CMDDestino)

--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_ITEM_OBSERVACAO
--**********************************************************************************  
   select *    
   into #Pedido_Venda_Item_Observacao
   from Pedido_Venda_Item_Observacao
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Item_Observacao
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Item_Observacao
                      select * from #Pedido_Venda_Item_Observacao'
   Exec(@CMDDestino)


--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_ITEM_SMO
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Item_SMO
   from Pedido_Venda_Item_SMO
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Item_SMO
   set

      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '
                      + @Destino + '.dbo.Pedido_Venda_Item_SMO
                      select * from #Pedido_Venda_Item_SMO'
    Exec(@CMDDestino)
  


--**********************************************************************************  
--Copia tabela: PEDIDO_VENDA_HISTORICO
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Historico
   from Pedido_Venda_Historico
   where cd_pedido_venda = @cd_pedido_origem 
  
   --Atualiza código da consulta
   update
      #Pedido_Venda_Historico
   set
      cd_pedido_venda  = @cd_pedido,
      cd_usuario  = @cd_usuario,
      dt_usuario  = getdate()
   where
     cd_pedido_venda = @cd_pedido_origem

-- atualiza codigo
	Declare M_Cursor Cursor for 
   	select cd_pedido_venda_historico from #Pedido_Venda_Historico

	Open M_Cursor

	Declare @cd_pedido_venda_historico int,
			  @cd_pedido_venda_historico_New int,
			  @tabela Varchar(200)

	set @tabela = @Destino + '.dbo.Pedido_Venda_Historico'

	Fetch from M_Cursor into @cd_pedido_venda_historico

   while ( @@Fetch_Status = 0 )
  	begin
		 
		exec egisadmin.dbo.sp_PegaCodigo @tabela,'cd_pedido_venda_historico',@codigo = @cd_pedido_venda_historico_New output      

   	update
      	#Pedido_Venda_Historico
   	set
   		cd_pedido_venda_historico = @cd_pedido_venda_historico_New
   	where
			cd_pedido_venda_historico = @cd_pedido_venda_historico

    	  Fetch Next from M_Cursor into @cd_pedido_venda_historico
  	end

	Close M_Cursor
	Deallocate M_Cursor

   -- Insere os registros na tabela
   
    Set @CMDDestino = 'insert into '   
                      + @Destino + '.dbo.Pedido_Venda_Historico
                      select * from #Pedido_Venda_Historico   '

    Exec(@CMDDestino)   
--**********************************************************************************
--Copia tabela: PEDIDO_VENDA_PARCELA
--**********************************************************************************  
   select * 
   into #Pedido_Venda_Parcela
   from Pedido_Venda_Parcela
   where cd_pedido_venda = @cd_pedido_origem 
   
    --Atualiza código da consulta
    update
       #Pedido_Venda_Parcela
    set
       cd_pedido_venda  = @cd_pedido,
       cd_usuario  = @cd_usuario,
       dt_usuario  = getdate()
    where
      cd_pedido_venda = @cd_pedido_origem
 
    -- Insere os registros na tabela
    
     Set @CMDDestino = 'insert into '
                       + @Destino + '.dbo.Pedido_Venda_Parcela
                       select * from #Pedido_Venda_Parcela' 
    Exec(@CMDDestino)   


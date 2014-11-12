
-------------------------------------------------------------------------------------------
--pr_Atualiza_Situacao_pedido_Compra
-------------------------------------------------------------------------------------------
-- GBS
-- Stored Procedure : SQL Server
-- Autor(es)        : Sandro Campos
-- Banco de Dados   : EGISSQL
-- Objetivo         : Consulta de Pedido de Compra Geral
-- Data             : 04/06/2002	
-- Atualizado       : 18/02/2004 - Alteração da rotina de geração de código
-- para evitar duplicações de chaves. - Daniel C. Neto.
-- 23.07.2010 - Carlos Fernandes
------------------------------------------------------------------------------

CREATE PROCEDURE pr_Atualiza_Situacao_pedido_Compra
@cd_modulo                  int,          
@cd_departamento            int,
@cd_pedido_compra           int,        
@cd_item_pedido_compra      int,
@dt_pedido_compra_historico datetime,
@cd_historico_pedido        int,
@nm_pedido_compra_histor_1  varchar(255),
@nm_pedido_compra_histor_2  varchar(255),
@nm_pedido_compra_histor_3  varchar(255),
@cd_usuario                 int,
@cd_tipo                    int  -- 1 - Inclusão
                                 -- 2 - Alteração
                                 -- 3 - Exclusão do Item
                                 -- 9 - Exclusão Total        

as



  begin transaction

-------------------------------------------------------------------------------
  if @cd_tipo = 1                -- 1 - Inclusão
-------------------------------------------------------------------------------
    begin

      declare @Tabela		          varchar(80)
      declare @cd_pedido_compra_historico int

      -- Nome da Tabela usada na geração e liberação de códigos
      set @Tabela = cast(DB_NAME()+'.dbo.Pedido_Compra_Historico' as varchar(80))

      exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_pedido_compra_histor', @codigo = @cd_pedido_compra_historico output
	
      while exists(Select top 1 'x' from Pedido_Compra_Historico where cd_pedido_compra_histor = @cd_pedido_compra_historico)
      begin
        exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_ap', @codigo = @cd_pedido_compra_historico output
        -- limpeza da tabela de código
        exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_compra_historico, 'D'
      end

--       set @cd_pedido_compra_historico = 
--        IsNull(( select 
--                   max(cd_pedido_compra_histor)
--                 from Pedido_Compra_Historico  with (nolock) 
--                 where cd_pedido_compra = @cd_pedido_compra and
--                 IsNull(cd_item_pedido_compra,0) = ( case when @cd_item_pedido_compra = 0 then
--                                                    IsNull(cd_item_pedido_compra,0)
--                                                     else @cd_item_pedido_compra end ) 
--                ),0) + 1
  

      insert into Pedido_Compra_Historico
        (cd_pedido_compra,
         cd_pedido_compra_histor,
         cd_item_pedido_compra,
         dt_pedido_compra,
         nm_pedido_compra_histor_1,
         nm_pedido_compra_histor_2,
         nm_pedido_compra_histor_3,
         cd_tipo_status_pedido,
         cd_departamento,
         cd_usuario,
         dt_usuario)
      values
        (@cd_pedido_compra,
         @cd_pedido_compra_historico,
         @cd_item_pedido_compra,
         @dt_pedido_compra_historico,
         @nm_pedido_compra_histor_1,
         @nm_pedido_compra_histor_2,
         @nm_pedido_compra_histor_3,
         null,   -- verificar qual o conteúdo
         @cd_departamento,
         @cd_usuario,
         getDate())

      exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_pedido_compra_historico, 'D'


    end


-------------------------------------------------------------------------------
  else if @cd_tipo = 2      -- Alterar
-------------------------------------------------------------------------------
    begin

      update
        Pedido_Compra_Historico
      set
        dt_pedido_compra          = @dt_pedido_compra_historico,
        cd_pedido_compra_histor   = @cd_historico_pedido,
        nm_pedido_compra_histor_1 = @nm_pedido_compra_histor_1,
        nm_pedido_compra_histor_2 = @nm_pedido_compra_histor_2,
        nm_pedido_compra_histor_3 = @nm_pedido_compra_histor_3,
        --cd_tipo_status_pedido     = 0,  verificar qual será o conteúdo do campo
        cd_departamento          = @cd_departamento,
        cd_usuario               = @cd_usuario,
        dt_usuario               = getDate()
      where
        cd_pedido_compra = @cd_pedido_compra and
        cd_pedido_compra_histor  = @cd_pedido_compra_historico and
        cd_item_pedido_compra = @cd_item_pedido_compra        
    end
-------------------------------------------------------------------------------
  else if @cd_tipo = 3 -- exclusão do item
-------------------------------------------------------------------------------
    begin
      
      delete
        Pedido_compra_Historico
      where
        cd_pedido_compra        = @cd_pedido_compra and
        cd_pedido_compra_histor = @cd_pedido_compra_historico and
        cd_item_pedido_compra   = @cd_item_pedido_compra        
  
    end
-------------------------------------------------------------------------------
  else if @cd_tipo = 9   -- deleta todos os itens
-------------------------------------------------------------------------------
    begin

      delete from
        Pedido_Compra_Historico
      where
        cd_pedido_Compra = @cd_pedido_Compra

    end 
 
  if @@error = 0
    commit transaction
  else
    rollback transaction   




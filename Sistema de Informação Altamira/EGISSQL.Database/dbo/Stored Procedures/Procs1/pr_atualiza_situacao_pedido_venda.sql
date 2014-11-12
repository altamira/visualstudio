-------------------------------------------------------------------------------
--pr_atualiza_situacao_pedido_venda
-------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                      2004
-------------------------------------------------------------------------------
--Stored Procedure       : Microsoft Sql Server 2000
--Autor(es)              : Carlos Cardoso Fernances
--Banco de Dados         : EgisSql ou EgisAdmin
--Objetivo               : 
--Data                   : 13/12/2004
--Atualização            : Acerto do Cabeçalho - Sérgio Cardoso
-------------------------------------------------------------------------------

CREATE PROCEDURE pr_atualiza_situacao_pedido_venda
@cd_modulo int,          
@cd_processo int,        
@cd_departamento int,
@cd_pedido_venda int,        
@cd_item_pedido_venda int,
@dt_pedido_venda_historico datetime,
@cd_historico_pedido int,
@nm_pedido_venda_histor_1 varchar(255),
@nm_pedido_venda_histor_2 varchar(255),
@nm_pedido_venda_histor_3 varchar(255),
@nm_pedido_venda_histor_4 varchar(255),
@cd_usuario int,
@cd_tipo int                     -- 1 - Inclusão
                                 -- 2 - Alteração
                                 -- 3 - Exclusão do Item
                                 -- 9 - Exclusão Total        

as

  declare @nm_tabela varchar(50)
  declare @cd_pedido_venda_historico int

  begin transaction

-------------------------------------------------------------------------------
  if @cd_tipo = 1                -- 1 - Inclusão
-------------------------------------------------------------------------------
    begin

      if @cd_pedido_venda <> 0 
      begin
        set @nm_tabela = cast(DB_NAME()+'.dbo.Pedido_Venda_Historico' as varchar(50))
  
        -- geração do código único do pedido_venda_historico
        exec EgisADMIN.dbo.sp_PegaCodigo @nm_tabela, 'cd_pedido_venda_historico', @codigo = @cd_pedido_venda_historico output

        insert into Pedido_Venda_Historico
          (cd_pedido_venda,
           cd_pedido_venda_historico,
           cd_item_pedido_venda,
           dt_pedido_venda_historico,
           cd_historico_pedido,
           nm_pedido_venda_histor_1,
           nm_pedido_venda_histor_2,
           nm_pedido_venda_histor_3,
           nm_pedido_venda_histor_4,
           cd_tipo_status_pedido,
           cd_modulo,
           cd_departamento,
           cd_processo,
           cd_usuario,
           dt_usuario)
        values
          (@cd_pedido_venda,
           @cd_pedido_venda_historico,
           @cd_item_pedido_venda,
           @dt_pedido_venda_historico,
           @cd_historico_pedido,
           @nm_pedido_venda_histor_1,
           @nm_pedido_venda_histor_2,
           @nm_pedido_venda_histor_3,
           @nm_pedido_venda_histor_4,
           null,   -- verificar qual o conteúdo
           @cd_modulo,          
           @cd_departamento,
           @cd_processo,
           @cd_usuario,
           getDate())

        -- liberação do código gerado p/ PegaCodigo
        exec EgisADMIN.dbo.sp_LiberaCodigo @nm_tabela, @cd_pedido_venda_historico, 'D'
     end
   end
-------------------------------------------------------------------------------
  else if @cd_tipo = 2      -- Alterar
-------------------------------------------------------------------------------
    begin

      -- verificar se existe o registro pedido p/ modificar, caso não exista, incluir
      if exists(select 
                  cd_historico_pedido 
                from
                  Pedido_Venda_Historico
                where
                  cd_pedido_venda           = @cd_pedido_venda and
                  cd_pedido_venda_historico = @cd_pedido_venda_historico and
                  cd_item_pedido_venda      = @cd_item_pedido_venda and
                  nm_pedido_venda_histor_1  = @nm_pedido_venda_histor_1)
        begin
          if @cd_pedido_venda <> 0 
          begin
            update
              Pedido_Venda_Historico
            set
              dt_pedido_venda_historico = @dt_pedido_venda_historico,
              cd_historico_pedido       = @cd_historico_pedido,
              nm_pedido_venda_histor_1  = @nm_pedido_venda_histor_1,
              nm_pedido_venda_histor_2  = @nm_pedido_venda_histor_2,
              nm_pedido_venda_histor_3  = @nm_pedido_venda_histor_3,
              nm_pedido_venda_histor_4  = @nm_pedido_venda_histor_4,
              --cd_tipo_status_pedido   = 0,  verificar qual será o conteúdo do campo
              cd_modulo                 = @cd_modulo,
              cd_departamento           = @cd_departamento,
              cd_processo               = @cd_processo,
              cd_usuario                = @cd_usuario,
              dt_usuario                = getDate()
            where
              cd_pedido_venda           = @cd_pedido_venda and
              cd_pedido_venda_historico = @cd_pedido_venda_historico and
              cd_item_pedido_venda      = @cd_item_pedido_venda        
          end
        end
      else
        begin

          if @cd_pedido_venda <> 0  
          begin
            set @nm_tabela = cast(DB_NAME()+'.dbo.Pedido_Venda_Historico' as varchar(50))
  
            -- geração do código único do pedido_venda_historico
            exec EgisADMIN.dbo.sp_PegaCodigo @nm_tabela, 'cd_pedido_venda_historico', @codigo = @cd_pedido_venda_historico output

            insert into Pedido_Venda_Historico
              (cd_pedido_venda,
               cd_pedido_venda_historico,
               cd_item_pedido_venda,
               dt_pedido_venda_historico,
               cd_historico_pedido,
               nm_pedido_venda_histor_1,
               nm_pedido_venda_histor_2,
               nm_pedido_venda_histor_3,
               nm_pedido_venda_histor_4,
               cd_tipo_status_pedido,
               cd_modulo,
               cd_departamento,
               cd_processo,
               cd_usuario,
               dt_usuario)
            values
              (@cd_pedido_venda,
               @cd_pedido_venda_historico,
               @cd_item_pedido_venda,
               @dt_pedido_venda_historico,
               @cd_historico_pedido,
               @nm_pedido_venda_histor_1,
               @nm_pedido_venda_histor_2,
               @nm_pedido_venda_histor_3,
               @nm_pedido_venda_histor_4,
               null,   -- verificar qual o conteúdo
               @cd_modulo,          
               @cd_departamento,
               @cd_processo,
               @cd_usuario,
               getDate())
          end

          -- liberação do código gerado p/ PegaCodigo
          exec EgisADMIN.dbo.sp_LiberaCodigo @nm_tabela, @cd_pedido_venda, 'D'
        end
    end
-------------------------------------------------------------------------------
  else if @cd_tipo = 3 -- exclusão do item
-------------------------------------------------------------------------------
    begin
      
      delete
        Pedido_Venda_Historico
      where
        cd_pedido_venda = @cd_pedido_venda and
        cd_pedido_venda_historico = @cd_pedido_venda_historico and
        cd_item_pedido_venda = @cd_item_pedido_venda        
  
    end
-------------------------------------------------------------------------------
  else if @cd_tipo = 9   -- deleta todos os itens
-------------------------------------------------------------------------------
    begin

      delete from
        Pedido_Venda_Historico
      where
        cd_pedido_venda = @cd_pedido_venda

    end 
 
  if @@error = 0
    commit transaction
  else
    rollback transaction   
-------------------------------------------------------------------------------
--Testando a Stored Procedure
-------------------------------------------------------------------------------

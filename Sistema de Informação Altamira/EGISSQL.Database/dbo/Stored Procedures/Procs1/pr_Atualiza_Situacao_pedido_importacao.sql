----------------------------------------------------------------
--pr_Atualiza_Situacao_pedido_importacao
----------------------------------------------------------------
-- GBS - Global Business Solution Ltda                      2004
----------------------------------------------------------------
-- Stored Procedure         : Microsoft  SQL Server
-- Autor(es)                : Daniel C. Neto.
-- Banco de Dados           : EGISSQL
-- Objetivo                 : Faz gravações de histórico no pedido de importação.
-- Data                     : 20/02/2004
-- Atualização              : 27/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
------------------------------------------------------------------------------

CREATE PROCEDURE pr_Atualiza_Situacao_pedido_importacao
@cd_departamento int,
@cd_pedido_importacao int,        
@cd_item_ped_imp int,
@dt_pedido_imp_historico datetime,
@cd_historico_pedido int,
@nm_pedido_imp_histor_1 varchar(255),
@nm_pedido_imp_histor_2 varchar(255),
@nm_pedido_imp_histor_3 varchar(255),
@nm_pedido_imp_histor_4 varchar(255),
@cd_usuario int,
@cd_tipo int                     -- 1 - Inclusão
                                 -- 2 - Alteração
                                 -- 3 - Exclusão do Item
                                 -- 9 - Exclusão Total        

as

  begin transaction

-------------------------------------------------------------------------------
  if @cd_tipo = 1                -- 1 - Inclusão
-------------------------------------------------------------------------------
    begin

      declare @cd_pedido_imp_historico int

      set @cd_pedido_imp_historico = 
       IsNull(( select max(cd_pedido_imp_historico)
                from pedido_importacao_Historico  
                where cd_pedido_importacao = @cd_pedido_importacao and
                IsNull(cd_item_ped_item,0) = ( case when @cd_item_ped_imp = 0 then
                                                   IsNull(cd_item_ped_item,0)
                                                    else @cd_item_ped_imp end ) 
               ),0) + 1
  

      insert into pedido_importacao_Historico
        (cd_pedido_importacao,
         cd_pedido_imp_historico,
         cd_item_ped_item,
         dt_pedido_imp_historico,
         nm_pedido_imp_histor_1,
         nm_pedido_imp_histor_2,
         nm_pedido_imp_histor_3,
         nm_pedido_imp_histor_4,
         cd_tipo_status_pedido,
         cd_departamento,
         cd_usuario,
         dt_usuario)
      values
        (@cd_pedido_importacao,
         @cd_pedido_imp_historico,
         @cd_item_ped_imp,
         @dt_pedido_imp_historico,
         @nm_pedido_imp_histor_1,
         @nm_pedido_imp_histor_2,
         @nm_pedido_imp_histor_3,
         @nm_pedido_imp_histor_4,
         null,   -- verificar qual o conteúdo
         @cd_departamento,
         @cd_usuario,
         getDate())

    end
-------------------------------------------------------------------------------
  else if @cd_tipo = 2      -- Alterar
-------------------------------------------------------------------------------
    begin

      update
        pedido_importacao_Historico
      set
        dt_pedido_imp_historico = @dt_pedido_imp_historico,
        nm_pedido_imp_histor_1 = @nm_pedido_imp_histor_1,
        nm_pedido_imp_histor_2 = @nm_pedido_imp_histor_2,
        nm_pedido_imp_histor_3 = @nm_pedido_imp_histor_3,
        nm_pedido_imp_histor_4 = @nm_pedido_imp_histor_4,
        --cd_tipo_status_pedido     = 0,  verificar qual será o conteúdo do campo
        cd_departamento          = @cd_departamento,
        cd_usuario               = @cd_usuario,
        dt_usuario               = getDate()
      where
        cd_pedido_importacao = @cd_pedido_importacao and
        cd_pedido_imp_historico  = @cd_historico_pedido and
        cd_item_ped_item = @cd_item_ped_imp        
    end
-------------------------------------------------------------------------------
  else if @cd_tipo = 3 -- exclusão do item
-------------------------------------------------------------------------------
    begin
      
      delete
        pedido_importacao_Historico
      where
        cd_pedido_importacao = @cd_pedido_importacao and
        cd_pedido_imp_historico = @cd_historico_pedido and
        IsNull(cd_item_ped_item,0) = ( case when @cd_item_ped_imp = 0 then
                                       IsNull(cd_item_ped_item,0)
                                       else @cd_item_ped_imp end ) 
  
    end
 
  if @@error = 0
    commit transaction
  else
    rollback transaction   




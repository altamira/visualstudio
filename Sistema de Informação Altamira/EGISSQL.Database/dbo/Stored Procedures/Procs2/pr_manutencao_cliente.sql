

/****** Object:  Stored Procedure dbo.pr_manutencao_cliente    Script Date: 13/12/2002 15:08:34 ******/

create procedure dbo.pr_manutencao_cliente
/*---------------------------------------------------------------------------  
  procedure      : pr_manutencao_cliente
  Autor(es)      : Paulo Noel 
  Banco de dados : EgisSql
  Objetivo       : Efetua manutenção na tabela de cliente
  Data           : 23/01/2001
  Atualizado     :    
---------------------------------------------------------------------------  */
( @Operacao                  varchar(1)   ,   @cd_apresentado            int           , --Código apresentado para o usuário
  @cd_cliente                int          ,   @nm_fantasia_cliente       char(15)     ,
  @nm_razao_social_cliente   varchar(40)  ,   @nm_dominio_cliente        varchar(100)  ,   
  @nm_email_cliente          varchar(100) ,   @ds_cliente                varchar(8000) ,
  @cd_status_cliente         int          ,   @cd_identifica_cep         int           ,
  @cd_cnpj_cliente           varchar(18)  ,   @cd_inscMunicipal          varchar(18)   ,
  @cd_cep                    char(9)      ,   @nm_endereco_cliente       varchar(60)   ,   
  @nm_bairro                 varchar(25)  ,   @cd_telefone               varchar(15)   ,   
  @cd_usuario                int          ,   @Mensagemerro              varchar(224) out
)
as 

   set nocount on 
   set xact_abort on

   declare @xcd_atualizado  int 

   --Verifica a operação
   if @operacao not in ('I','A','E') begin
      SET @mensagemErro='Parametro da operação inválido!'
      goto FIM
   end 


     --Efetua a inserção do registro  
      if @operacao='I' begin       

         begin transaction inserir
       
               insert into cliente 
                   ( cd_cliente                ,   dt_cadastro_cliente   ,
                     nm_fantasia_cliente       ,   nm_razao_social_cliente   ,   
                     nm_dominio_cliente    ,       nm_email_cliente          ,   
                     ds_cliente            ,       cd_status_cliente         ,   
                     cd_identifica_cep     ,       cd_cnpj_cliente           ,  
                     cd_inscMunicipal      ,       cd_cep                    , 
                     nm_endereco_cliente   ,       nm_bairro                 ,  
                     cd_telefone           ,       cd_usuario                , 
                     dt_usuario            )
               values
                   ( @cd_apresentado        ,   getdate()                  ,
                     @nm_fantasia_cliente   ,   @nm_razao_social_cliente   ,   
                     @nm_dominio_cliente    ,   @nm_email_cliente          ,  
                     @ds_cliente            ,   @cd_status_cliente         , 
                     @cd_identifica_cep     ,   @cd_cnpj_cliente           ,  
                     @cd_inscMunicipal      ,   @cd_cep                    , 
                     @nm_endereco_cliente   ,   @nm_bairro                 ,   
                     @cd_telefone           ,   @cd_usuario                ,   
                     getdate())

          --Libera o número 
            exec egisAdmin.dbo.sp_liberacodigo
                 'EGISSQL.DBO.cliente', 
                 cd_apresentado,
                 'L'            

            --Valida o processo
            if @@rowcount = 0 begin
               set @mensagemerro = 'Processo concluído com sucesso!!'
               commit tran inserir 
            end else 
            if @@rowcount > 0 begin
               set @mensagemerro = 'Erro na gravação do registro, por favor verifique com o departamento de informática!'
               rollback tran inserir   
            end
             
 
         goto FIM

      end else 

      --Efetua a alteração do registro 
      if @operacao='A' begin

         begin transaction alterar

               update cliente set cd_cliente              = @cd_cliente                ,   
                                  nm_fantasia_cliente     = @nm_fantasia_cliente       ,   
                                  nm_razao_social_cliente = @nm_razao_social_cliente   ,   
                                  nm_dominio_cliente      = @nm_dominio_cliente        ,       
                                  nm_email_cliente        = @nm_email_cliente          ,   
                                  ds_cliente              = @ds_cliente                ,  
                                  cd_status_cliente       = @cd_status_cliente         ,   
                                  cd_identifica_cep       = @cd_identifica_cep         ,       
                                  cd_cnpj_cliente         = @cd_cnpj_cliente           ,  
                                  cd_inscMunicipal        = @cd_inscMunicipal          ,       
                                  cd_cep                  = @cd_cep                    , 
                                  nm_endereco_cliente     = @nm_endereco_cliente       ,       
                                  nm_bairro               = @nm_bairro                 ,  
                                  cd_telefone             = @cd_telefone               ,
                                  cd_usuario              = @cd_usuario                ,
                                  dt_usuario              = getdate()       
               where cd_cliente = @cd_cliente

               --Valida o processo
               if @@rowcount = 0 begin
                  set @mensagemerro = 'Processo concluído com sucesso!!'
                  commit tran alterar
                  end else 

               if @@rowcount > 0 begin
                  set @mensagemerro = 'Erro na gravação do registro, por favor verifique com o departamento de informática!'
                  rollback tran alterar
               end          

         goto FIM

      end else 

      --Efetua a exclusão do registro
      if @operacao='E' begin

         begin transaction excluir 

         --Verificar nas outras tabelas onde o código está amarrado......
         --Melhor apenas cancelar o registro....
         --Verificar com o Carlos.... 
--         delete 
--         from cliente 
--         where cd_cliente=@cd_cliente

               --Valida o processo
               if @@rowcount = 0 begin
                  set @mensagemerro = 'Processo concluído com sucesso!!'
                  commit tran excluir
               end else 
 
               if @@rowcount > 0 begin
                  set @mensagemerro = 'Erro na exclusão do registro, por favor verifique com o departamento de informática!'
                  rollback tran excluir
               end          

 
        goto FIM

      end 

   FIM: 

   set nocount off 
   set xact_abort off

   return




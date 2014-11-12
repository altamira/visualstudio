

/****** Object:  Stored Procedure dbo.pr_manutencao_cliente_contato    Script Date: 13/12/2002 15:08:35 ******/

create procedure dbo.pr_manutencao_cliente_contato
/*---------------------------------------------------------------------------  
  procedure      : pr_manutencao_cliente_contato
  Autor(es)      : Paulo Noel 
  Banco de dados : EgisSql
  Objetivo       : Efetua manutenção na tabela de contato de cliente
  Data           : 25/01/2002
  Atualizado     :    
---------------------------------------------------------------------------  */
( @operacao                   varchar(1)   ,
  @cd_apresentado             int          ,
  @cd_cliente                 int          ,  
  @cd_contato                 int          ,
  @nm_contato_cliente         varchar(40)  ,
  @nm_fantasia_contato        varchar(15)  ,
  @cd_ddd_contato_cliente     char(4)      ,
  @cd_telefone_contato        varchar(15)  ,
  @cd_fax_contato             varchar(15)  ,
  @cd_celular                 varchar(15)  , 
  @cd_ramal                   varchar(10)  ,
  @cd_email_contato_cliente   varchar(100) ,
  @ds_observacao_contato      varchar(8000),
  @cd_cargo                   int          ,   
  @cd_departamento            int          ,
  @cd_usuario                 int          , 
  @mensagemerro               varchar(224) out )

as
  
  set nocount on 
  set xact_abort on


  --Verifica a operação
  if @operacao not in ('I','A','E') begin
     SET @mensagemErro='Parametro da operação inválido!'
     goto FIM
  end 

  --Efetua a inserção do registro  
  if @operacao='I' begin

     begin transaction inserir 

           insert into cliente_contato 
               ( cd_cliente                ,  
                 cd_contato                ,
                 nm_contato_cliente        ,
                 nm_fantasia_contato       ,
                 cd_ddd_contato_cliente    ,
                 cd_telefone_contato       ,
                 cd_fax_contato            ,
                 cd_celular                , 
                 cd_ramal                  ,
                 cd_email_contato_cliente  ,
                 ds_observacao_contato     ,
                 cd_cargo                  ,   
                 cd_departamento           ,
                 cd_usuario                , 
                 dt_usuario                )
           values 
               ( @cd_cliente                ,  
                 @cd_apresentado            ,
                 @nm_contato_cliente        ,
                 @nm_fantasia_contato       ,
                 @cd_ddd_contato_cliente    ,
                 @cd_telefone_contato       ,
                 @cd_fax_contato            ,
                 @cd_celular                , 
                 @cd_ramal                  ,
                 @cd_email_contato_cliente  ,
                 @ds_observacao_contato     ,
                 @cd_cargo                  ,   
                 @cd_departamento           ,
                 @cd_usuario                , 
                 getdate()                  )

          --Valida a transação
          if @@Rowcount = 1 begin
             set @mensagemerro = 'Processo concluído com sucesso!'
             commit tran inserir 
          end else 

          if @@Trancount > 0 begin
             set @mensagemerro = 'Erro na gravação do registro, por favor verifique com o departamento de informática!'
             rollback tran inserir   

             --Deixa o código aberto
             exec egisAdmin.dbo.sp_liberacodigo
                  'EGISSQL.DBO.cliente_contato', 
                  @cd_apresentado ,
                  'A'            

          end

 
     goto fim

  end else 

  --Efetua a alteração do registro  
  if @operacao='A' begin

     begin transaction alterar
        
          update cliente_contato set cd_contato                = @cd_contato                ,
                                     nm_contato_cliente        = @nm_contato_cliente        ,
                                     nm_fantasia_contato       = @nm_fantasia_contato       ,
                                     cd_ddd_contato_cliente    = @cd_ddd_contato_cliente    ,
                                     cd_telefone_contato       = @cd_telefone_contato       ,
                                     cd_fax_contato            = @cd_fax_contato            ,
                                     cd_celular                = @cd_celular                , 
                                     cd_ramal                  = @cd_ramal                  ,
                                     cd_email_contato_cliente  = @cd_email_contato_cliente  ,
                                     ds_observacao_contato     = @ds_observacao_contato     ,
                                     cd_cargo                  = @cd_cargo                  ,   
                                     cd_departamento           = @cd_departamento           ,
                                     cd_usuario                = @cd_usuario                , 
                                     dt_usuario                = getdate()
          where cd_cliente = @cd_cliente
          and   cd_contato = @cd_contato


          if @@rowcount = 1 begin
             set @mensagemerro = 'Processo concluído com sucesso!'
             commit tran alterar
          end else 

          if @@Trancount > 0 begin
             set @mensagemerro = 'Erro na gravação do registro, por favor verifique com o departamento de informática!'
             rollback tran alterar
          end          

     goto fim

  end else 

  --Efetua a exclusão do registro  
  if @operacao='E' begin
   
     begin transaction excluir

           delete 
           from cliente_contato 
           where cd_cliente = @cd_cliente
           and   cd_contato = @cd_contato


           if @@rowcount = 2 begin
              set @mensagemerro = 'Processo concluído com sucesso!'
              commit tran excluir
           end else 

           if @@Trancount > 0 begin
              set @mensagemerro = 'Erro na exclusão do registro, por favor verifique com o departamento de informática!'
              rollback tran excluir
           end          

     goto fim

  end 

  FIM:
  select @mensagemerro 

  set nocount off
  set xact_abort off
  

  return




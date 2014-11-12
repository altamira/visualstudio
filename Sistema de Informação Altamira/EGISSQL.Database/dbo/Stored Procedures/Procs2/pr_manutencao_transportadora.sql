

/****** Object:  Stored Procedure dbo.pr_manutencao_transportadora    Script Date: 13/12/2002 15:08:35 ******/

create procedure dbo.pr_manutencao_transportadora
/*---------------------------------------------------------------------------  
  procedure      : pr_manutencao_transportadora
  Autor(es)      : Paulo Noel 
  Banco de dados : EgisSql
  Objetivo       : Efetua manutenção na tabela de transportadora
  Data           : 07/02/2002
  Atualizado     :    
---------------------------------------------------------------------------  */
( @operacao                   varchar(1)   ,
  @cd_apresentado             int          ,
  @cd_transportadora          int          , 
  @nm_transportadora          varchar(40)  ,
  @nm_fantasia                varchar(30)  ,
  @nm_dominio                 varchar(100) ,
  @ic_frete_cobranca          char(1)      ,
  @ic_sedex                   char(1)      ,
  @ic_minuta                  char(1)      ,
  @ic_altera_pedido           char(1)      ,
  @ic_coleta                  char(1)      ,
  @ic_frete                   char(1)      ,
  @cd_tipo_pessoa             int          ,
  @cd_tipo_transporte         int          ,
  @ic_cobra_coleta            char(1)      ,
  @nm_area_atuacao            varchar(60)  ,
  @cd_tipo_pagamento_frete    int          ,
  @cd_tipo_frete              int          ,
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

           if exists ( select 1 
                       from   tranportadora
                       where  cd_transporadora = @cd_apresentado ) begin 

              set @mensagemerro = 'Registro já cadastrado, por favor verique com o departamento de informática!'
              goto FIM
           end 
           
           insert into transportadora 
               ( cd_transportadora         ,
                 nm_transportadora         ,
                 nm_fantasia               ,
                 nm_dominio                ,
                 ic_frete_cobranca         ,
                 ic_sedex                  ,
                 ic_minuta                 ,
                 ic_altera_pedido          ,
                 ic_coleta                 ,
                 ic_frete                  ,
                 cd_tipo_pessoa            ,
                 cd_tipo_transporte        ,
                 ic_cobra_coleta           ,
                 dt_cadastro               , 
                 nm_area_atuacao           ,
                 cd_tipo_pagamento_frete   ,
                 cd_tipo_frete             ,
                 cd_usuario                ,
                 dt_usuario                )
           values
               ( @cd_apresentado           ,
                 @nm_transportadora        ,
                 @nm_fantasia              ,
                 @nm_dominio               ,
                 @ic_frete_cobranca        ,
                 @ic_sedex                 ,
                 @ic_minuta                ,
                 @ic_altera_pedido         ,
                 @ic_coleta                ,
                 @ic_frete                 ,
                 @cd_tipo_pessoa           ,
                 @cd_tipo_transporte       ,
                 @ic_cobra_coleta          ,
                 getdate()                 ,
                 @nm_area_atuacao          ,
                 @cd_tipo_pagamento_frete  ,
                 @cd_tipo_frete            ,
                 @cd_usuario               ,
                 getdate()                 )

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
                  'EGISSQL.DBO.transportadora', 
                  @cd_apresentado ,
                  'A'            
          end

 
     goto FIM

  end else 

  --Efetua a alteração do registro  
  if @operacao='A' begin

     begin transaction alterar

          if not exists ( select 1 
                          from   transportadora 
                          where  cd_transportadora = @cd_transportadora ) begin

             set @mensagemerro='Registro não cadastrado, por favor verifique!'
             goto FIM
          end
         
          update transportadora set cd_transportadora         =  @cd_transportadora         ,
                                    nm_transportadora         =  @nm_transportadora         ,
                                    nm_fantasia               =  @nm_fantasia               ,
                                    nm_dominio                =  @nm_dominio                ,
                                    ic_frete_cobranca         =  @ic_frete_cobranca         ,
                                    ic_sedex                  =  @ic_sedex                  ,
                                    ic_minuta                 =  @ic_minuta                 ,
                                    ic_altera_pedido          =  @ic_altera_pedido          ,
                                    ic_coleta                 =  @ic_coleta                 ,
                                    ic_frete                  =  @ic_frete                  ,
                                    cd_tipo_pessoa            =  @cd_tipo_pessoa            ,
                                    cd_tipo_transporte        =  @cd_tipo_transporte        ,
                                    ic_cobra_coleta           =  @ic_cobra_coleta           , 
                                    nm_area_atuacao           =  @nm_area_atuacao           ,
                                    cd_tipo_pagamento_frete   =  @cd_tipo_pagamento_frete   ,
                                    cd_tipo_frete             =  @cd_tipo_frete             ,
                                    cd_usuario                =  @cd_usuario                ,
                                    dt_usuario                =  getdate()
          where cd_transportadora= @cd_transportadora

          if @@rowcount = 1 begin
             set @mensagemerro = 'Processo concluído com sucesso!'
             commit tran alterar
          end else 

          if @@Trancount > 0 begin
             set @mensagemerro = 'Erro na gravação do registro, por favor verifique com o departamento de informática!'
             rollback tran alterar
          end          

     goto FIM

  end else 

  --Efetua a exclusão do registro  
  if @operacao='E' begin
   
     begin transaction excluir
         
           if not exists ( select 1 
                           from   transportadora 
                           where  cd_transportadora = @cd_transportadora ) begin
 
              set @mensagemerro = 'Registro não cadastrado, por favor verifique!'            
              goto FIM

           end

           delete 
           from transportadora
           where cd_transportadora = @cd_transportadora


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




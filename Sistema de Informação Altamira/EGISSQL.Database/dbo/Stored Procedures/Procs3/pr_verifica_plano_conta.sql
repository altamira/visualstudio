

/****** Object:  Stored Procedure dbo.pr_verifica_plano_conta    Script Date: 13/12/2002 15:08:45 ******/
--pr_verifica_plano_conta
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                      2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Carlos Cardoso Fernandes         
--Verifica Plano de Contas Gerado
--Data         : 23.05.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
create procedure pr_verifica_plano_conta
@ic_parametro     int,
@cd_empresa       int,
@dt_movimento     datetime
as
  declare @qt_grupo_conta       int
  declare @qt_grupo_conta_plano int
  declare @ic_plano_gerado      char(1)
  set @qt_grupo_conta       = 0
  set @qt_grupo_conta_plano = 0
  set @ic_plano_gerado      = 'N'
  select @qt_grupo_conta = count(*)
  from
    Grupo_conta
  where
    ic_plano_conta='S' 
  -- Verifica as contas obrigatórias no Plano de Contas
  select a.cd_grupo_conta
  into #Aux_Grupo_Conta
  from
    Grupo_conta a, Plano_conta b
  where
    a.ic_plano_conta = 'S'              and
    a.cd_grupo_conta = b.cd_grupo_conta and
    b.cd_empresa     = @cd_empresa      
  group by
    a.cd_grupo_conta
 
  select @qt_grupo_conta_plano = count(*)
  from
    #Aux_Grupo_Conta
   if @qt_grupo_conta = @qt_grupo_conta_plano
      begin
        set @ic_plano_gerado = 'S' 
      end
    if @ic_parametro = 0
       begin
         select @ic_plano_gerado
       end
    else
       if @ic_parametro = 1
          begin
            begin tran
              update Parametro_contabil
              set ic_plano_gerado = @ic_plano_gerado
              where
                 cd_empresa = @cd_empresa and
                 @dt_movimento between dt_inicial_exercicio and dt_final_exercicio
                    
            if @@error = 0
               begin
                 commit tran
               end
            else
               begin
                 raiserror ('Atençao, Parâmetro contábil nao Atualizado !',16,1)
                 rollback tran
               end
          end
 



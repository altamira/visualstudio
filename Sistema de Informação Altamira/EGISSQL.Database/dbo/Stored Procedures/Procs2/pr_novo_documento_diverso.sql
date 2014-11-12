
CREATE PROCEDURE pr_novo_documento_diverso
  
  @cd_empresa 			int,
  @cd_documento_pagar_diverso 	int output

AS
  begin transaction
    --Pegando codigo atual e incrementando 1
    select @cd_documento_pagar_diverso = isnull(cd_documento_pagar_diverso,0) + 1
    from EgisAdmin.dbo.Parametro_Empresa
    where cd_empresa = @cd_empresa

    --Atualiza tabela Parametro_Empresa
    update EgisAdmin.dbo.Parametro_Empresa
    set cd_documento_pagar_diverso = @cd_documento_pagar_diverso
    where cd_empresa = @cd_empresa 

    if @cd_documento_pagar_diverso is null
    begin
       set @cd_documento_pagar_diverso = 0
    end

  if @@ERROR = 0
  begin
    commit transaction
    print(@cd_documento_pagar_diverso)
  end
  else
    rollback transaction


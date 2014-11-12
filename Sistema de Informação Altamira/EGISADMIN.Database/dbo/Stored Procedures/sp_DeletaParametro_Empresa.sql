
create procedure sp_DeletaParametro_Empresa
@cd_empresa int output,
@aa_exercicio_empresa int output,
@cd_nota_fiscal_saida int output,
@cd_nota_fiscal_entrada int output,
@cd_nota_fiscal_servico int output,
@vl_faturamento_minimo money output,
@vl_faturamento_maximo money output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Parametro_Empresa
     WHERE
         cd_empresa = @cd_empresa and 
         aa_exercicio_empresa = @aa_exercicio_empresa and 
         cd_nota_fiscal_saida = @cd_nota_fiscal_saida and 
         cd_nota_fiscal_entrada = @cd_nota_fiscal_entrada and 
         cd_nota_fiscal_servico = @cd_nota_fiscal_servico and 
         vl_faturamento_minimo = @vl_faturamento_minimo and 
         vl_faturamento_maximo = @vl_faturamento_maximo
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end


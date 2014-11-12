
create procedure sp_InsereParametro_Empresa
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
  INSERT INTO Parametro_Empresa( cd_empresa,aa_exercicio_empresa,cd_nota_fiscal_saida,cd_nota_fiscal_entrada,cd_nota_fiscal_servico,vl_faturamento_minimo,vl_faturamento_maximo)
     VALUES (@cd_empresa,@aa_exercicio_empresa,@cd_nota_fiscal_saida,@cd_nota_fiscal_entrada,@cd_nota_fiscal_servico,@vl_faturamento_minimo,@vl_faturamento_maximo)
  Select 
         @cd_empresa = cd_empresa,
         @aa_exercicio_empresa = aa_exercicio_empresa,
         @cd_nota_fiscal_saida = cd_nota_fiscal_saida,
         @cd_nota_fiscal_entrada = cd_nota_fiscal_entrada,
         @cd_nota_fiscal_servico = cd_nota_fiscal_servico,
         @vl_faturamento_minimo = vl_faturamento_minimo,
         @vl_faturamento_maximo = vl_faturamento_maximo
  From Parametro_Empresa
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end


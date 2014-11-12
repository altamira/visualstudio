
create procedure sp_AlteraParametro_Empresa
--dados depois da execuçao (novos)
@cd_empresa int ,
@aa_exercicio_empresa int ,
@cd_nota_fiscal_saida int ,
@cd_nota_fiscal_entrada int ,
@cd_nota_fiscal_servico int,
@vl_faturamento_minimo money,
@vl_faturamento_maximo money,
--dados antes da execuçao (antigos)
@cd_empresa_old int ,
@aa_exercicio_empresa_old int ,
@cd_nota_fiscal_saida_old int ,
@cd_nota_fiscal_entrada_old int ,
@cd_nota_fiscal_servico_old int,
@vl_faturamento_minimo_old money,
@vl_faturamento_maximo_old money
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  --gera código e executa travamento
  UPDATE Parametro_Empresa SET
         cd_empresa = @cd_empresa,
         aa_exercicio_empresa = @aa_exercicio_empresa,
         cd_nota_fiscal_saida = @cd_nota_fiscal_saida,
         cd_nota_fiscal_entrada = @cd_nota_fiscal_entrada,
         cd_nota_fiscal_servico = @cd_nota_fiscal_servico,
         vl_faturamento_minimo = @vl_faturamento_minimo,
         vl_faturamento_maximo = @vl_faturamento_maximo
     WHERE
         cd_empresa = @cd_empresa_old and 
         aa_exercicio_empresa = @aa_exercicio_empresa_old and 
         cd_nota_fiscal_saida = @cd_nota_fiscal_saida_old and 
         cd_nota_fiscal_entrada = @cd_nota_fiscal_entrada_old and 
         cd_nota_fiscal_servico = @cd_nota_fiscal_servico_old and 
         vl_faturamento_minimo = @vl_faturamento_minimo_old and 
         vl_faturamento_maximo = @vl_faturamento_maximo_old
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end


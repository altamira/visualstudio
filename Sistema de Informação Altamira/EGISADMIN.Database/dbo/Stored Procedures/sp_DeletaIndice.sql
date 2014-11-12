
CREATE procedure sp_DeletaIndice
@cd_tabela int output,
@cd_indice int output,
@nm_indice varchar (40) output,
@ic_clustered char (1) output,
@pc_fill_factor float (50) output,
@ic_unico char (1) output
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  DELETE FROM Indice
     WHERE
         cd_tabela = @cd_tabela and 
         cd_indice = @cd_indice
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON 


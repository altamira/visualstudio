
CREATE procedure sp_InsereModuloFuncao
@cd_modulo int,
@cd_funcao int,
@cd_indice int,
@posicao   char (1),
@cd_usuario int,
@dt_usuario datetime,
@ic_alteracao char(1)
-- O parâmetro @posicao indica o local onde será feita a inserçao.
-- Valores possíveis: 'F' - final / 'A' - posiçao atual
AS
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  if @posicao = 'A'
    UPDATE Modulo_Funcao_Menu SET cd_indice = cd_indice + 1 
       WHERE cd_modulo = @cd_modulo
         AND cd_indice >= @cd_indice
  else
    SELECT @cd_indice = IsNull(Max(cd_indice),0)+1 from Modulo_Funcao_Menu
      WHERE cd_modulo = @cd_modulo
  INSERT INTO Modulo_Funcao_Menu ( cd_modulo, cd_funcao, cd_menu, cd_indice, cd_usuario, dt_usuario, ic_alteracao )
     VALUES (@cd_modulo,@cd_funcao,0, @cd_indice, @cd_usuario, @dt_usuario, @ic_alteracao )
/*  INSERT INTO Modulo_Funcao_Menu ( cd_modulo, cd_funcao, cd_menu )
     VALUES (@cd_modulo,@cd_funcao,0)
*/
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON



CREATE procedure sp_InsereModuloFuncaoMenu
@cd_modulo int,
@cd_funcao int,
@cd_menu   int,
@cd_indice int,
@posicao   char (1),
@cd_usuario int,
@dt_usuario datetime,
@ic_alteracao char(1)
-- O parâmetro @posicao indica o local onde será feita a inserçao.
-- Valores possíveis: 'F' - final / 'A' - posiçao atual
AS
DECLARE @Temporarios int
BEGIN
  --inicia a transaçao
  BEGIN TRANSACTION
  SELECT @Temporarios = COUNT(*) FROM Modulo_Funcao_Menu
                          WHERE cd_modulo = @cd_modulo
                            AND cd_funcao = @cd_funcao
                            AND cd_menu   = 0
  IF @Temporarios > 0
  BEGIN
--    SELECT @cd_indice = IsNull(Max(cd_indice),0)+1 from Modulo_Funcao_Menu
--      WHERE cd_modulo = @cd_modulo
--        AND cd_funcao = @cd_funcao 
    UPDATE Modulo_Funcao_Menu set 
           cd_modulo = @cd_modulo,
           cd_funcao = @cd_funcao,
           cd_menu   = @cd_menu,
           cd_usuario = @cd_usuario,
           dt_usuario = @dt_usuario,
           ic_alteracao = @ic_alteracao
    WHERE    
           cd_modulo = @cd_modulo
       AND cd_funcao = @cd_funcao
       AND cd_menu   = 0
  END
  ELSE
  BEGIN
    if @posicao = 'A'
      UPDATE Modulo_Funcao_Menu SET cd_indice = cd_indice + 1 
         WHERE cd_modulo = @cd_modulo
           AND cd_indice >= @cd_indice
    else
    BEGIN  
      SELECT @cd_indice = IsNull(Max(cd_indice),0)+1 from Modulo_Funcao_Menu
        WHERE cd_modulo = @cd_modulo
          AND cd_funcao = @cd_funcao 
      UPDATE Modulo_Funcao_Menu SET cd_indice = cd_indice + 1 
         WHERE cd_modulo = @cd_modulo
           AND cd_indice >= @cd_indice
    END
    INSERT INTO Modulo_Funcao_Menu ( cd_modulo, cd_funcao, cd_menu, cd_indice, cd_usuario, dt_usuario, ic_alteracao)
       VALUES (@cd_modulo,@cd_funcao,@cd_menu, @cd_indice, @cd_usuario, @dt_usuario, @ic_alteracao)
  END
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end


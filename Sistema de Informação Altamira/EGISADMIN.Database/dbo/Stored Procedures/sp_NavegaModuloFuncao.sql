
CREATE  procedure sp_NavegaModuloFuncao
@cd_modulo int,
@cd_funcao int,
@cd_indice int,
@direcao   char (1)
-- O parâmetro @direcao indica se a funcao subirá ou descerá no módulo
-- Valores possíveis: 'S' - sobe / 'D' - desce
AS
BEGIN
  DECLARE @IND_TMP INT
  declare @func_tmp int
 
  --inicia a transaçao
  BEGIN TRANSACTION
  if @direcao = 'S'
  begin
    select @Func_tmp = cd_funcao
      from Modulo_Funcao_Menu
     where cd_modulo = @cd_modulo
       and cd_indice   =  @cd_indice-1
   
    print @func_tmp
    select @Ind_tmp = min(cd_indice) 
      from Modulo_Funcao_Menu
     where cd_modulo = @cd_modulo
       and cd_funcao = @func_tmp
    print @ind_tmp
    update Modulo_Funcao_Menu 
       set cd_indice = cd_indice + 1 
     where cd_modulo = @cd_modulo
         and cd_funcao = @func_tmp
        and cd_indice = @Ind_Tmp
    update Modulo_Funcao_Menu 
       set cd_indice = @Ind_Tmp
     where cd_modulo = @cd_modulo
       and cd_funcao = @cd_funcao
  end
  else
  begin
    select TOP 1 @Func_tmp = cd_funcao
      from Modulo_Funcao_Menu
     where cd_indice > @cd_indice
       and cd_modulo = @cd_modulo
       and cd_funcao <> @cd_funcao  
     order by cd_indice
    print @Func_Tmp
    print @cd_modulo
    print @cd_funcao         
    print @cd_indice         
    select @Ind_Tmp = min(cd_indice) 
      from Modulo_Funcao_Menu
     where cd_modulo = @cd_modulo
       and cd_funcao = @func_tmp
    print @Ind_Tmp
    update Modulo_Funcao_Menu 
       set cd_indice = @cd_indice
     where cd_modulo = @cd_modulo
       and cd_indice = @Ind_Tmp
    update Modulo_Funcao_Menu 
       set cd_indice = @Ind_Tmp
     where cd_modulo = @cd_modulo
       and cd_funcao = @cd_funcao
  end 
  declare @IndSeq int
  set @IndSeq = 0
  select * 
    into #TabTemp
    from Modulo_Funcao_Menu 
   where cd_modulo = @cd_modulo
   order by cd_indice
  declare @cd_funcao_tmp int
  declare @cd_menu_tmp int
  while exists(select * from #TabTemp)
  begin
    select top 1 @cd_funcao_tmp = cd_funcao,
                 @cd_menu_tmp   = cd_menu
      from #TabTemp 
    set @IndSeq = @IndSeq + 1
    print @Indseq
    update Modulo_Funcao_Menu 
       set cd_indice = @IndSeq
     where cd_modulo = @cd_modulo     and
           cd_funcao = @cd_funcao_tmp and
           cd_menu   = @cd_menu_tmp 
          
    delete from #TabTemp 
     where cd_funcao = @cd_funcao_tmp and
           cd_menu   = @cd_menu_tmp
    
  end
 
--  INSERT INTO Modulo_Funcao_Menu ( cd_modulo, cd_funcao, cd_menu, cd_indice )
--     VALUES (@cd_modulo,@cd_funcao,0, @cd_indice)
  if @@ERROR = 0
    COMMIT TRAN
  else
  begin
  --RAISERROR @@ERROR
    ROLLBACK TRAN
  end
end
SET QUOTED_IDENTIFIER  OFF    SET ANSI_NULLS  ON


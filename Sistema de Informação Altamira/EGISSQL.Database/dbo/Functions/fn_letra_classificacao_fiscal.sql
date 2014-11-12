
CREATE FUNCTION fn_letra_classificacao_fiscal
  (@cd_nota_saida int,
   @cd_ordem int)
RETURNS @Letra TABLE 
	(nm_letra char(1), 
	 cd_classificacao_fiscal int,
   cd_mascara_classificacao char(10))

AS
BEGIN

  -- criar a tabela temporária na memória
  declare @tmpLetra table 
  	(nm_letra char(1), 
	   cd_classificacao_fiscal int,
     cd_mascara_classificacao char(10))

  -- variáveis do loop
  declare @cd_item_nota_saida       int
  declare @cd_classificacao_fiscal  int
  declare @cd_mascara_classificacao char(10)

  -- letra 
  declare @cd_letra int
  declare @nm_letra char(1)

  set @cd_letra = 65  -- A

  -- cursor com a listagem dos itens e classificação da NF
  declare cCursor cursor for
  select max(nsi.cd_item_nota_saida) as cd_item_nota_saida, nsi.cd_classificacao_fiscal, cf.cd_mascara_classificacao
  from nota_saida_item nsi, classificacao_fiscal cf
  where nsi.cd_nota_saida = @cd_nota_saida and
        nsi.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
  group by nsi.cd_classificacao_fiscal, cf.cd_mascara_classificacao
  order by nsi.cd_item_nota_saida
        
  open cCursor

  fetch next from cCursor into @cd_item_nota_saida, @cd_classificacao_fiscal, @cd_mascara_classificacao

  while @@FETCH_STATUS = 0
  begin


    if not exists (select cd_classificacao_fiscal from @tmpLetra
               where cd_classificacao_fiscal = @cd_classificacao_fiscal) 
    begin

      insert into @tmpLetra values (char(@cd_letra),@cd_classificacao_fiscal,@cd_mascara_classificacao)
      set @cd_letra = @cd_letra + 1

    end

    fetch next from cCursor into @cd_item_nota_saida, @cd_classificacao_fiscal, @cd_mascara_classificacao
                                  
  end

  close cCursor
  deallocate cCursor 

  if isnull(@cd_ordem,0) <> 0
  begin
    set @cd_letra = 64 + @cd_ordem
     
    insert into @Letra select * from @tmpLetra where nm_letra = char(@cd_letra)

  end
  else
    insert into @Letra select * from @tmpLetra 
    
  RETURN

END

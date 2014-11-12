
CREATE FUNCTION fn_tira_espaco_duplo
(@Str_in varchar(500))        	-- String Recebida Para Conversao
RETURNS varchar(500)
AS
BEGIN
  declare @word varchar(500)	 -- Variavel para armazenar palavra 
  declare @i 	int          	 -- Variavel Contadora do Loop de Toda a String
  Set @word = ''
  
  --Inicializando Contador
  set @i = 1
  --Enquanto existir caracteres na string faca
  while (@i <= len(@Str_in))
  begin
    --Enquanto nao encontrar espaco leia proximo caractere e armazene em word
    if ((substring(@Str_in, @i, 1) = ' ') and 
          (substring(@Str_in, @i+1, 1) = ' '))
    begin
      set @word = (@word + substring(@Str_in, @i,1))
--      set @Str_in = @word
      set @i = @i + 2
    end else begin
      set @word = (@word + substring(@Str_in, @i, 1))
      set @i = @i + 1
    end
    
  end --1 While
  --Retorna String formatada
  RETURN (@word)
END


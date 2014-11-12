
CREATE FUNCTION fn_novo_padrao_string
(@Str_in varchar(500))        	-- String Recebida Para Conversao
RETURNS varchar(500)
AS
BEGIN
  declare @word varchar(500)	-- Variavel para armazenar palavra 
  declare @i 	int          	-- Variavel Contadora do Loop de Toda a String
  declare @Str_out varchar (500)--Variavel de retorno da funcao
  SET @Str_out = ''
  
  --Inicializando Contador
  set @i = 1
  --Enquanto existir caracteres na string faca
  while (@i <= len(@Str_in))
  begin
    --Limpa variavel que armazena a palavra
    set @word = ''
    --Enquanto nao encontrar espaco leia proximo caractere e armazene em word
    while (substring(@Str_in, @i, 1) <> ' ')
    begin
      set @word = (@word + substring(@Str_in, @i, 1))
      set @i = @i + 1
    end
    set @i = @i + 1   
   --Se a palavra for preposicao, converter para caixa baixa  
   if (@word = 'DE' or @word = 'DA' or @word = 'DAS' or @word = 'DO' or
        @word = 'DOS' or @word = 'COM' or @word = 'PARA' or @word = 'E' or
        @word = 'A' or @word = 'EM')
    begin
      if @Str_out = ''
        set @Str_out = @Str_out + lower(@word)
      else
        set @Str_out = @Str_out + ' ' + lower(@word)
    end
    else
    --Se nao for preposicao
    begin
      --Se variavel de saida '@Str_out' estiver vazia
      if @Str_out = ''
        --Converte primeiro caractere da palavra para caixa alta
        set @Str_out = @Str_out + Upper(substring(@word, 1, 1))
      else
        --Adiciona espaço e converte primeiro caractere para caixa alta
        set @Str_out = @Str_out + ' ' + Upper(substring(@word, 1, 1))
      --Se word tiver mais de um caractere
      if len(@word) > 1
        --Converte do segundo caractere ate o ultimo da palavra para caixa alta
        set @Str_out = @Str_out + lower(substring(@word, 2, len(@word)))
    end
  end
  --Retorna String formatada
  RETURN (@Str_out)
END


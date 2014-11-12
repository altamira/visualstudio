

/****** Object:  Stored Procedure dbo.pr_novo_padrao_string    Script Date: 13/12/2002 15:08:37 ******/
--pr_normaliza_string
------------------------------------------------------------------
--Polimold Industrial S/A                                     2001
--Stored Procedure : Microsoft SQL Server 2000
--Autor (es)       : Johnny Mendes de Souza/Elias Pereira da Silva
--Objetivo         : Normalizar String para Novo Padrao ( primeira 
--                   letra de cada palavra com caixa alta)
--Data             : 16/08/2001
--Atualizado       :
------------------------------------------------------------------
CREATE procedure pr_novo_padrao_string
@Str_in 	varchar(500),        	-- String Recebida Para Conversao
@Str_out 	varchar(500) output 	-- String Formatada no Novo Padrao
as
  declare @word varchar(500)	 	-- Palavra
  declare @i 	int          		-- Variavel Contadora do Loop de Toda a String
  set @i = 1
  while (@i <= len(@Str_in)) 
  begin
    set @word = ''
    while (substring(@Str_in, @i, 1) <> ' ')
    begin
      set @word = (@word + substring(@Str_in, @i, 1))
      set @i = @i + 1
    end
    set @i = @i + 1   
    if (@word = 'DE' or @word = 'DA' or @word = 'DAS' or @word = 'DO' or
      @word = 'DOS' or @word = 'COM' or @word = 'PARA' or @word = 'E' or @word = 'A')
    begin
      if @Str_out = ''
        set @Str_out = @Str_out + lower(@word)
      else
        set @Str_out = @Str_out + ' ' + lower(@word)
    end
    else
    begin
      if @Str_out = ''
        set @Str_out = @Str_out + Upper(substring(@word, 1, 1))
      else
        set @Str_out = @Str_out + ' ' + Upper(substring(@word, 1, 1))
      if len(@word) > 1
        set @Str_out = @Str_out + lower(substring(@word, 2, len(@word)))
    end
  end
print(@Str_out)



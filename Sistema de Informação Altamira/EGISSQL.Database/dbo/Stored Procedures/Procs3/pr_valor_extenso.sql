

CREATE  PROCEDURE pr_valor_extenso
@vl_monetario decimal(15,2),
@nm_saida varchar(500) OUTPUT
AS
  declare
  @Centavos	varchar(500),
  @Centena	varchar(500),
  @Milhar	varchar(500),
  @Milhao	varchar(500),
  @Texto	varchar(500),
  @Extenso	varchar(500),
  @Trio		char(3)

  --Verificando se valor passado esta dentro do intervalo permitido
  if (@vl_monetario > 999999999.99) or (@vl_monetario < 0)
    set @Extenso = 'O valor está fora do intervalo permitido.'
  else
    --Verificando se valor é zero
    if @vl_monetario = 0
      set @Extenso = 'Zero'
    else
    begin
      --Definie o tamanho de dígitos máximo para a transformação
      set @Texto = right('0000000000' + cast(@vl_monetario as varchar), 12)

      --Milhões      
      set @Trio = substring(@Texto,1,3)       
      execute pr_mini_extenso @Trio ,@Milhao output

      --Milhares
      set @Trio = substring(@Texto,4,3)       
      execute pr_mini_extenso @Trio ,@Milhar output

      --Centenas      
      set @Trio = substring(@Texto,7,3)       
      execute pr_mini_extenso @Trio ,@Centena output
      
      --Centavos
      set @Trio = '0' + substring(@Texto,11,2)       	
      execute pr_mini_extenso @Trio ,@Centavos output
     
      set @Extenso = @Milhao
       
      if @Milhao <> ''
        if substring(@Texto,4,6) = '000000'
	begin
          if substring(@Texto,1,3) = '001'
	     set @Extenso = @Extenso + ' Milhão de Reais'
	  else
 	     set @Extenso = @Extenso + ' Milhões de Reais'
	end
        else
	begin
           if substring(@Texto,1,3) = '001'
              set @Extenso = @Extenso + ' Milhão'
	   else
	      set @Extenso = @Extenso + ' Milhões'          
	end
      
      if (( @Milhar <> '' ) and ( @Milhao <> '' )) 
         or (( @Milhar <> '' ) and ( @Centena <> '' ))
        set @Extenso = @Extenso + ' e '          

      set @Extenso = @Extenso + @Milhar
      if @Milhar <> ''
        if substring(@Texto,7,3) = '000'
          set @Extenso = @Extenso + ' Mil Reais'
        else
          set @Extenso = @Extenso + ' Mil'
      
      if ( @Milhao + @Milhar ) <> '' and (@Centena <> '' )
         set @Extenso = @Extenso + ' e ' + @Centena
      else
         set @Extenso = @Extenso + @Centena
       
      if ( @Milhao = '' ) and ( @Milhar = '' ) and substring(@Texto,7,3) = '001'
        set @Extenso = @Extenso + ' Real'        
      else
        if substring(@Texto,7,3) <> '000'
          set @Extenso = @Extenso + ' Reais'        
      
      if @Centavos = ''
        set @Extenso = @Extenso
      else
      begin
        if (@Milhao + @Milhar + @Centena) = ''
          set @Extenso = @Centavos
        else
          set @Extenso = @Extenso + ' e ' + @Centavos
	
        if substring(@Texto,11,2) = '01' and @Centavos <> ''
          set @Extenso = @Extenso + ' Centavo'
        else
          set @Extenso = @Extenso + ' Centavos'
      end
    end

  --Ajuste quando o valor e somente centezimal e não tem casas decimais é necessário
  --Limpar o ' e ' do início
  if substring(@Extenso,1,3) = ' e '
    set @Extenso = right(@Extenso, len(@Extenso)-3)
  set @nm_saida = @Extenso

  print(@Extenso)



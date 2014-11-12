
Create Function fn_valida_CNPJ
(
	@Tipo	varchar(4) , 
	@valor	varchar(50)
)
RETURNS varchar(20)
AS
BEGIN
	-- @Tipo = 'CNPJ' 	para validação de CNPJ
	-- @Tipo = 'CPJ'    	para validação de CPF

	-- DECLARA VARIÁVEIS
	declare @variavel	varchar(100)
	declare @original	varchar(100)
	declare @variavelTMP    varchar(100)
	declare @tamanho	int
	declare @i		int
	declare @caracter	varchar(1)
	declare @soma		numeric(15)
	declare @flag		numeric(15)
	declare @resto		int
	declare @resto1		int
	declare @temp		int
	declare @retorno	varchar(20)

	-- REMOVE CARACTERES ESPECIAIS
	set @valor = RTRIM(LTRIM(@valor))
	set @variavel = @valor
	set @variavel = replace(@variavel ,'-','')
	set @variavel = replace(@variavel ,'/','')
	set @variavel = replace(@variavel ,'\','')
	set @variavel = replace(@variavel ,'.','')
	set @variavel = replace(@variavel ,',','')
	set @variavel = replace(@variavel ,'a','')
	set @variavel = replace(@variavel ,'b','')
	set @variavel = replace(@variavel ,'c','')
	set @variavel = replace(@variavel ,'d','')
	set @variavel = replace(@variavel ,'e','')
	set @variavel = replace(@variavel ,'f','')
	set @variavel = replace(@variavel ,'g','')
	set @variavel = replace(@variavel ,'h','')
	set @variavel = replace(@variavel ,'i','')
	set @variavel = replace(@variavel ,'j','')
	set @variavel = replace(@variavel ,'l','')
	set @variavel = replace(@variavel ,'m','')
	set @variavel = replace(@variavel ,'n','')
	set @variavel = replace(@variavel ,'o','')
	set @variavel = replace(@variavel ,'p','')
	set @variavel = replace(@variavel ,'q','')
	set @variavel = replace(@variavel ,'r','')
	set @variavel = replace(@variavel ,'s','')
	set @variavel = replace(@variavel ,'t','')
	set @variavel = replace(@variavel ,'u','')
	set @variavel = replace(@variavel ,'v','')
	set @variavel = replace(@variavel ,'x','')
	set @variavel = replace(@variavel ,'z','')
	set @variavel = replace(@variavel ,'y','')
	set @variavel = replace(@variavel ,'k','')
	
	
	-- COMPLETA COM ZEROS A ESQUERDA
	if @Tipo = 'CPF'
	begin
		set @variavel = '00000000000' + @variavel
		set @variavel = right( @variavel ,11)
	end
	if @Tipo = 'CNPJ'
	begin
		set @variavel = '00000000000000' + @variavel
		set @variavel = right( @variavel ,14)
	end
	
	-- GUARDA VALOR ORIGINAL TRATADO
	set @original = @variavel

	-- GERA VARIÁVEL INVERTIDA SEM OS DOIS ÚLTIMOS DIGITOS
	set @i 		= len( @variavel ) - 2
	set @variavelTMP 	= ''

	while @i > 0
	begin
		set @variavelTMP = @variavelTMP + substring( @variavel ,@i ,1)			
		set @i = @i -1
	end
	set @variavel = @variavelTMP


	-- CARREGA VARIÁVEL TAMANHO
	set @tamanho = len( @variavel )
	
	-- INICIALIZA VARIÁVEIS 
	set @i 	= 1
	set @soma 	= 0
	set @flag	= 2

	-- PRIMEIRA VERIFICAÇÃO (LOOP)
	while @i <= @tamanho
	begin
		set @caracter = substring( Left( @variavel , @tamanho) , @i , 1)
		if ( isnumeric( @caracter ) = 1 )
		begin
			set @soma = @soma + convert( int , @caracter ) * @flag
			if @tamanho = 12
			   begin
				if @flag = 9
				begin
					set @flag = 2
				end
				else
				begin
					set @flag = @flag + 1
				end
			   end
			else
			   begin
				if @flag = 0
				begin
					set @flag = 2
				end
				else
				begin
					set @flag = @flag + 1
				end
			    end
		end
		set @i = @i +1
	end

	
	--ERRO RNCONTRADO , VALOR INVÁLIDO
	if @soma = 0 
	begin
		set @retorno = 'INVALIDO'
    return @retorno
	end
	

	-- CALCULA RESTO
	set @temp = (@soma / 11)
	set @resto = ((@temp * 11) - @soma) * -1

	if @resto = 0 or @resto = 1
	begin
		set @resto = 0
	end
	else
	begin
		set @resto = ( 11 - @resto )
	end


	-- INICIALIZA VARIÁVEIS
	set @i 	= 1
	set @soma 	= 0
	set @flag	= 2

	
	-- ADICIONA 1 A VARIÁVEL @tamanho
	set @tamanho = @tamanho + 1
	

	-- SEGUNDA VERIFICAÇÃO (LOOP)
	while @i <= @tamanho
	begin

		set @caracter = substring( convert( varchar(10) , @resto ) + @variavel , @i , 1)
		set @soma = @soma + convert( int , @caracter ) * @flag
		
		if @tamanho = 13
		begin
			if @flag = 9
			begin
				set @flag = 2
			end
			else
			begin
				set @flag = @flag + 1
			end
		end
		
		if @tamanho = 10
		begin
			set @flag = @flag + 1
		end

		set @i = @i +1
	end

	-- CALCULA RESTO
	set @temp	= (@soma / 11)
	set @resto1 	= ((@temp * 11) - @soma) * -1

	if @resto1 = 0 or @resto1 = 1
	begin
		set @resto1 = 0
	end
	else
	begin
		set @resto1 = ( 11 - @resto1 )
	end


	-- REINVERTER VARIAVEL
	set @i 		= len( @variavel ) 
	set @variavelTMP 	= ''

	while @i > 0
	begin
		set @variavelTMP = @variavelTMP + substring( @variavel ,@i ,1)			
		set @i = @i -1
	end
	set @variavel = @variavelTMP

	set @variavel = @variavel + convert(varchar(1) , @resto ) + convert(varchar(1) , @resto1 )
	
	if LTRIM(RTRIM(@variavel)) = LTRIM(RTRIM(@original))
	begin
		 set @retorno =  'VALIDO'
	end
	else
	begin
		set  @retorno =  'INVALIDO'
	end

return @retorno

END




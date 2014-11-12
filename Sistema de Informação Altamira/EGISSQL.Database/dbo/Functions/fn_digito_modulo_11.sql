
---------------------------------------------------------------------------------------
--sp_helptext fn_digito_modulo_11
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2008
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernands
--Banco de Dados	: EGISSQL 
--Objetivo		: Cálculo do Dígito Verificado Módulo 11
--
--Data			: 04.11.2008
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_digito_modulo_11
(
  @valor	varchar(50),
  @tam          int
)

returns varchar(02)

as
begin

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
	set @valor    = RTRIM(LTRIM(@valor))
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

	
	set @variavel = replicate('0',@tam) + @variavel
	set @variavel = right( @variavel ,@tam)

--        select @variavel

--        print @variavel
		
	-- GUARDA VALOR ORIGINAL TRATADO
	set @original = @variavel

	-- GERA VARIÁVEL INVERTIDA SEM OS DOIS ÚLTIMOS DIGITOS
	set @i 		 = len( @variavel ) 
	set @variavelTMP = ''

	while @i > 0
	begin
		set @variavelTMP = @variavelTMP + substring( @variavel ,@i ,1)			
		set @i = @i - 1

          --select @variavelTMP

	end

	set @variavel = @variavelTMP


	-- CARREGA VARIÁVEL TAMANHO
	set @tamanho = len( @variavel )
	
	-- INICIALIZA VARIÁVEIS 

	set @i 	        = 1
	set @soma 	= 0
	set @flag	= 2

	-- PRIMEIRA VERIFICAÇÃO (LOOP)

	while @i <= @tamanho
	begin
          set @caracter = substring( Left( @variavel , @tamanho) , @i , 1)

		if ( isnumeric( @caracter ) = 1 )
		begin


                  set @soma = @soma + convert( int , @caracter ) * @flag

--                  select convert( int , @caracter ),@flag,convert( int , @caracter ) * @flag,@soma

                  if @flag = 9
                  begin
		    set @flag = 1
                  end

                  set @flag = @flag + 1
			
	          if @flag = 0
                  begin
                    set @flag = 2
 	          end
			
		end

		set @i = @i +1

	end

	
	--ERRO ENCONTRADO , VALOR INVÁLIDO

	if @soma = 0 
	begin
          set @retorno = ''
          return @retorno
	end
	

	-- CALCULA RESTO
--        select @soma

	set @temp  = (@soma / 11)
	set @resto = ((@temp * 11) - @soma) * -1

	if @resto = 0 or @resto = 1
	begin
          set @resto = 0
	end
	else
	begin
          set @resto = ( 11 - @resto )
	end

        set @retorno = @resto

return @retorno


end


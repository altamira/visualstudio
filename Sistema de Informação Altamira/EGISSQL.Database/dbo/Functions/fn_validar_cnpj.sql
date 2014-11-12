create function fn_validar_cnpj(@cnpj varchar(14))
returns char(1)

as

begin

  declare 
  @cnpj2 varchar(14), 
  @indice int, 
  @soma int, 
  @dig1 int, 
  @dig2 int, 
  @var1 int, 
  @var2 int, 
  @resultado char(1)

    set @soma = 0
    set @indice = 1
    set @resultado = 'N'

    /* algorítimo para o primeiro dígito 543298765432 */
    /* cálculo do 1º dígito */
    /* cálculo da 1ª parte do algorítiom 5432 */

    set @var1 = 5 /* 1a parte do algorítimo começando de "5" */

    while (@indice <= 4) 

    begin

      set @soma = @soma + convert(int,substring(@cnpj,@indice,1)) * @var1
      set @indice = @indice + 1 /* navegando um-a-um até < = 4, as quatro primeira posições */
      set @var1 = @var1 - 1       /* subtraindo o algorítimo de 5 até 2 */ 

    end

    /* cálculo da 2ª parte do algorítiom 98765432 */

    set @var2 = 9

    while (@indice <= 12) 

    begin

      set @soma = @soma + convert(int,substring(@cnpj,@indice,1)) * @var2
      set @indice = @indice + 1
      set @var2 = @var2 - 1             

    end

       set @dig1 = (@soma % 11)       

       /* se o resto da divisão for < 2, o digito = 0 */

       if @dig1 < 2

            set @dig1 = 0;

       else /* se o resto da divisão não for < 2*/ 

            set @dig1 = 11 - (@soma % 11);  

    /* cálculo do 2º dígito */

    /* zerando o indice e a soma para começar a calcular o 2º dígito*/    

    set @indice = 1
    set @soma = 0

    /* cálculo da 1ª parte do algorítiom 65432 */

    set @var1 = 6 /* 2a parte do algorítimo começando de "6" */
    set @resultado = 'N'

    while (@indice <= 5) 

    begin

      set @soma = @soma + convert(int,substring(@cnpj,@indice,1)) * @var1
      set @indice = @indice + 1 /* navegando um-a-um até < = 5, as quatro primeira posições */
      set @var1 = @var1 - 1       /* subtraindo o algorítimo de 6 até 2 */ 

    end

    /* cálculo da 2ª parte do algorítiom 98765432 */

    set @var2 = 9

    while (@indice <= 13) 

    begin

      set @soma = @soma + convert(int,substring(@cnpj,@indice,1)) * @var2
      set @indice = @indice + 1
      set @var2 = @var2 - 1             

    end

    set @dig2 = (@soma % 11)
       
    /* se o resto da divisão for < 2, o digito = 0 */

       if @dig2 < 2

           set @dig2 = 0;

       else /* se o resto da divisão não for < 2*/ 

           set @dig2 = 11 - (@soma % 11);

     -- validando

    if (@dig1 = substring(@cnpj,len(@cnpj)-1,1)) and (@dig2 = substring(@cnpj,len(@cnpj),1))

      set @resultado = 'S'

    else

      set @resultado = 'N'

    return (@resultado)

end

-- select dbo.fn_validar_cnpj(44663631000590)

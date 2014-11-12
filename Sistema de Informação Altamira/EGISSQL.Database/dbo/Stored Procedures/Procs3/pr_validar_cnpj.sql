
-------------------------------------------------------------------------------
--sp_helptext pr_validar_cnpj
-------------------------------------------------------------------------------
--pr_validar_cnpj
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 19.05.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_validar_cnpj
  @cnpj varchar(14)
as
begin

  declare @indice int, 
          @soma int, 
          @dig1 int, 
          @dig2 int, 
          @var1 int, 
          @var2 int, 
          @resultado char(1)

    set @soma = 0
    set @indice = 1
    set @resultado = 'N'

    set @var1 = 5 /* 1a parte do algorítimo começando de "5" */

    while (@indice <= 4) 

    begin

      set @soma = @soma + convert(int,substring(@cnpj,@indice,1)) * @var1

      print 'indice.: ' + convert(varchar(2),@indice)

      print 'digito-a-digito do cnpj.:' + substring(@cnpj,@indice,1)     

      print 'soma para o 1o digito, algoritimo 5432 .: ' + convert(varchar(5),@soma)

      set @indice = @indice + 1   /* navegando um-a-um até < = 4, as quatro primeira posições */

      set @var1 = @var1 - 1       /* subtraindo o algorítimo de 5 até 2 */ 

    end
    
    print '------------------------------------'

    set @var2 = 9

    while (@indice <= 12) 

    begin

      set @soma = @soma + convert(int,substring(@cnpj,@indice,1)) * @var2

      print 'indice.: ' + convert(varchar(2),@indice)

      print 'digito-a-digito do cnpj.: ' + substring(@cnpj,@indice,1)     

      print 'soma para o 1o digito, algoritimo 98765432 .: ' + convert(varchar(5),@soma)

      set @indice = @indice + 1

      set @var2 = @var2 - 1             

    end

       print 'soma total = ' + convert(varchar(5),@soma)

       set @dig1 = (@soma % 11)

    print 'dig1, resto da divisao .: ' + convert(varchar(3),(@soma % 11))


       if @dig1 < 2

            set @dig1 = 0;

       else /* se o resto da divisão não for < 2*/ 

            set @dig1 = 11 - (@soma % 11);

       print 'dig1 é.: ' + convert(varchar(3),@dig1)

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

      print 'indice.: ' + convert(varchar(2),@indice)

      print 'digito-a-digito do cnpj.: ' + substring(@cnpj,@indice,1)     

      print 'soma para o 2o digito, algoritimo 65432 .: ' + convert(varchar(5),@soma)

      set @indice = @indice + 1 /* navegando um-a-um até < = 5, as quatro primeira posições */

      set @var1 = @var1 - 1       /* subtraindo o algorítimo de 6 até 2 */ 

    end

    print '------------------------------------'

    /* cálculo da 2ª parte do algorítiom 98765432 */

    set @var2 = 9

    while (@indice <= 13) 

    begin

      set @soma = @soma + convert(int,substring(@cnpj,@indice,1)) * @var2

      print 'indice.: ' + convert(varchar(2),@indice)

      print 'digito-a-digito do cnpj.: ' + substring(@cnpj,@indice,1)     

      print 'soma para o 2o digito, algoritimo 98765432 .: ' + convert(varchar(5),@soma)

      set @indice = @indice + 1

      set @var2 = @var2 - 1             

    end

    print 'soma total = ' + convert(varchar(5),@soma)

       set @dig2 = (@soma % 11)

       print 'dig2, resto da divisao .: ' + convert(varchar(3),(@soma % 11))

       /* se o resto da divisão for < 2, o digito = 0 */

       if @dig2 < 2

           set @dig2 = 0;

       else /* se o resto da divisão não for < 2*/ 

           set @dig2 = 11 - (@soma % 11);

 

       print 'dig2 é.: ' + convert(varchar(3),@dig2)

       print '------------------------------------'

       print '------------------------------------'

       print 'dig1 é.: ' + convert(varchar(3),@dig1)

       print 'dig2 é.: ' + convert(varchar(3),@dig2)

       print substring(@cnpj,len(@cnpj)-1,1)

       print substring(@cnpj,len(@cnpj),1)

-- validando

    if (@dig1 = substring(@cnpj,len(@cnpj)-1,1)) and (@dig2 = substring(@cnpj,len(@cnpj),1))

      set @resultado = 'S'

    else

      set @resultado = 'N'

   print 'resultado .: ' + @resultado

   select @resultado as Validou 

end


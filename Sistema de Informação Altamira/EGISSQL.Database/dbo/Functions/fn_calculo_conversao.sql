
---------------------------------------------------------------------------------------
--sp_helptext fn_calculo_conversao
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Autor
--Banco de Dados	: EGISSQL ou EGISADMIN
--Objetivo		: 
--
--Data			: 13/04/2004
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_calculo_conversao
( 
@vl_conversao       float,
@qt_fator           float,
@ic_sinal_conversao char(1)

) returns float

as

begin

  declare @vl_convertido float

  set
    @vl_convertido = isnull(@vl_conversao,0)

   if isnull(@vl_conversao,0)<>0 and isnull(@qt_fator,0)<>0 and isnull(@ic_sinal_conversao,'')<>''
   begin
     --Multiplicação  
     if @ic_sinal_conversao='*' 
     begin
        set @vl_convertido = @vl_conversao * @qt_fator
     end

     --Divisão
     if @ic_sinal_conversao='/' 
     begin
        set @vl_convertido = @vl_conversao / @qt_fator
     end

     --Adição

     if @ic_sinal_conversao='+' 
     begin
        set @vl_convertido = @vl_conversao + @qt_fator
     end

     --Subtração

     if @ic_sinal_conversao='-' 
     begin
       set @vl_convertido = @vl_conversao - @qt_fator
     end  

  end

  return @vl_convertido

end


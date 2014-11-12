
---------------------------------------------------------------------------------------
--sp_helptext fn_arredondamento
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Autor
--Banco de Dados	: EGISSQL
--Objetivo		: Cálculo do Arredondamento de Valores
--                        Utilizado em Cálculos
--Data			: 17/06/2008
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_arredondamento
(@vl_principal float,
 @vl_arr       float)        	

RETURNS float
as
begin

  declare @x      float
  declare @y      float
  declare @s      float
  
  set @s = @vl_principal

  if @vl_arr > 0
  begin
    set
        @x = ((@s/@vl_arr) - cast( @s/@vl_arr as int ))

    if @x>0 
    begin
      set @y = @vl_arr - ( @x*@vl_arr)
      set @s = @s + @y
    end
  end

  return ( @s )

end



  
CREATE FUNCTION fn_indice_lucro
(@cd_tipo_lucro       int )
RETURNS decimal(25,4)

as begin


  declare @pc_lucro              decimal(25,4)
  declare @ic_formula_tipo_lucro char(1) 
  select 
    @pc_lucro              = isnull(pc_tipo_lucro,0),
    @ic_formula_tipo_lucro = isnull(ic_formula_tipo_lucro,'S') 

  from 
    Tipo_Lucro with (nolock) 

  where
    cd_tipo_lucro = @cd_tipo_lucro

  
  --Somar o Lucro no Final do Markup
  if @ic_formula_tipo_lucro = 'S'
     set @pc_lucro = 1

  --Somar o Lucro no Início
  if @ic_formula_tipo_lucro = 'N'
     set @pc_lucro = 1 + (@pc_lucro/100)


  return( @pc_lucro )

  --return( (@vl_base_markup-(isnull(@pc_markup,0)+isnull(@pc_lucro,0)))/100 )

  --return(isnull(@pc_markup,0)+isnull(@pc_lucro,0))

end



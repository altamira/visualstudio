
CREATE FUNCTION fn_agrega_imposto_venda
(@pc_icms int)
RETURNS decimal(25,4)

as 

begin

  declare @vl_indice decimal(25,4)
  declare @pc_cofins float
  declare @pc_pis    float
 
  set @pc_cofins = 7.6
  set @pc_pis    = 1.65  

  set @vl_indice = (100 - ( @pc_icms + @pc_cofins + @pc_pis ))/100
  


return @vl_indice


end



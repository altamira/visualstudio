
CREATE FUNCTION fn_indice_markup_icms
(@cd_aplicacao_markup int,
 @pc_icms decimal(25,2))
RETURNS decimal(25,4)

as begin

  declare @pc_markup decimal(25,4)

  select @pc_markup = sum(isnull(pc_formacao_markup,0)) from Formacao_Markup
  where cd_aplicacao_markup = @cd_aplicacao_markup

  return((100-(isnull(@pc_markup,0)+isnull(@pc_icms,0)))/100)

  --return(isnull(@pc_markup,0)+isnull(@pc_lucro,0))

end





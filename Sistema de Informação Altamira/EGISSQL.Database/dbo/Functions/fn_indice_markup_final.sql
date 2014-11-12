
CREATE FUNCTION fn_indice_markup_final
(@cd_aplicacao_markup int)
RETURNS decimal(25,4)

as begin

--select * from formacao_markup

  declare @pc_markup decimal(25,4)

  select 
    @pc_markup = sum(isnull(fm.pc_formacao_markup,0)) from Formacao_Markup fm
  inner join Tipo_Markup tm on tm.cd_tipo_markup = fm.cd_tipo_markup
  where 
     fm.cd_aplicacao_markup = @cd_aplicacao_markup and
     isnull(tm.ic_tipo_calculo_markup,'C')='F' -- Conjunto na FÓRMULA


  return( (1+ case when @pc_markup>0 then (isnull(@pc_markup,0)/100) else 0 end)  )

  --return(isnull(@pc_markup,0)+isnull(@pc_lucro,0))

end



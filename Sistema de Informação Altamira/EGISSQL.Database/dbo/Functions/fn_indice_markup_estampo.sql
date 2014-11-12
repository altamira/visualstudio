
CREATE FUNCTION fn_indice_markup_estampo
(@cd_aplicacao_markup int,
 @cd_tipo_lucro       int,
 @cd_produto_estampo  int )
RETURNS decimal(25,4)

as begin

--select * from formacao_markup

  declare @pc_markup         decimal(25,4)
  declare @pc_markup_estampo decimal(25,4)
  declare @pc_lucro          decimal(25,4)

  --(%) Markup Padrão

  set @pc_markup         = 0
  set @pc_markup_estampo = 0

  select 
    @pc_markup = sum(isnull(fm.pc_formacao_markup,0)) 
  from 
    Formacao_Markup fm
  inner join Tipo_Markup tm on tm.cd_tipo_markup = fm.cd_tipo_markup
  where 
     fm.cd_aplicacao_markup = @cd_aplicacao_markup and
     isnull(tm.ic_tipo_calculo_markup,'C')='C' -- Conjunto na FÓRMULA

  select 
    @pc_markup_estampo = sum(isnull(pem.pc_item_markup,0)) 
  from 
    Produto_Estampo_Markup pem    with (nolock)
    inner join formacao_markup fm with (nolock) on fm.cd_aplicacao_markup = pem.cd_aplicacao_markup and
                                                   fm.cd_tipo_markup      = pem.cd_tipo_markup                                                 
    inner join Tipo_Markup tm     with (nolock) on tm.cd_tipo_markup      = fm.cd_tipo_markup
  where 
     pem.cd_produto_estampo = @cd_produto_estampo  and
     fm.cd_aplicacao_markup = @cd_aplicacao_markup and
     isnull(tm.ic_tipo_calculo_markup,'C')='C' -- Conjunto na FÓRMULA

  if @pc_markup_estampo>0 and @pc_markup_estampo<>@pc_markup
  begin
    set @pc_markup = @pc_markup_estampo
  end

  --Tipo de Lucro

  select 
    @pc_lucro    = isnull(pc_tipo_lucro,0) from Tipo_Lucro
  where 
    cd_tipo_lucro = @cd_tipo_lucro

  return((100-(isnull(@pc_markup,0)+isnull(@pc_lucro,0)))/100)

  --return(isnull(@pc_markup,0)+isnull(@pc_lucro,0))

end	



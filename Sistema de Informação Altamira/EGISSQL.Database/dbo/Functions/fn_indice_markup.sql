  
CREATE FUNCTION fn_indice_markup
(@cd_aplicacao_markup int,
 @cd_tipo_lucro       int,
 @cd_produto          int = 0 )
RETURNS decimal(25,4)

as begin

  declare @pc_icms               float
  declare @vl_base_markup        float
  declare @vl_markup             decimal(25,4)
  declare @ic_formula_tipo_lucro char(1)

  set @pc_icms        = 0.00
  set @vl_base_markup = 100
  set @vl_markup      = 0.00

  --Produto / ICMS

  if @cd_produto>0
  begin
    select
      @pc_icms = case when isnull(cfe.pc_icms_classif_fiscal,0)>0 
                 then
                  isnull(cfe.pc_icms_classif_fiscal,0) * 
                    ( case when isnull(cfe.pc_redu_icms_class_fiscal,0)>0 
                      then    
                        isnull(cfe.pc_redu_icms_class_fiscal,0)/100
                      else
                        1
                      end
                    )
                 else  
                   isnull(pf.pc_aliquota_icms_produto,0)
                 end
    from
      produto p                                       with (nolock) 
      inner join produto_fiscal pf                    with (nolock) on pf.cd_produto = p.cd_produto
      left outer join classificacao_fiscal_estado cfe with (nolock) on cfe.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
  end

--select * from formacao_markup

  declare @pc_markup decimal(25,4)
  declare @pc_lucro  decimal(25,4)

  select 
    @pc_markup = sum( 
                      case when isnull(tm.ic_fiscal_tipo_markup,'N')='N' or isnull(@cd_produto,0)=0
                      then
                        isnull(fm.pc_formacao_markup,0)
                      else
                        case when @cd_produto>0 and isnull(@pc_icms,0)>0 then
                           isnull(@pc_icms,0)
                        else
                          isnull(fm.pc_formacao_markup,0)
                        end
                      end

                    ) 
  from 
    Formacao_Markup fm        with (nolock) 
    inner join Tipo_Markup tm with (nolock) on tm.cd_tipo_markup = fm.cd_tipo_markup
  where 
     fm.cd_aplicacao_markup = @cd_aplicacao_markup and
     isnull(tm.ic_tipo_calculo_markup,'C') = 'C' -- Conjunto na FÓRMULA

  select 
    @pc_lucro              = isnull(pc_tipo_lucro,0),
    @ic_formula_tipo_lucro = isnull(ic_formula_tipo_lucro,'S') 

  from 
    Tipo_Lucro with (nolock) 

  where
    cd_tipo_lucro = @cd_tipo_lucro

  --Tratamento da Base do Markup
  --Carlos - 20.08.2009

  if @pc_markup + @pc_lucro>100 
     set @vl_base_markup = 200  

  if @pc_markup + @pc_lucro>200 
     set @vl_base_markup = 300  



  --Somar o Lucro no Final do Markup
  if @ic_formula_tipo_lucro = 'S'
     set @vl_markup = (@vl_base_markup-(isnull(@pc_markup,0)+isnull(@pc_lucro,0)))/100

  --Somar o Lucro no Início
  if @ic_formula_tipo_lucro = 'N'
     set @vl_markup = (@vl_base_markup - isnull(@pc_markup,0))/100


  return( @vl_markup )

  --return( (@vl_base_markup-(isnull(@pc_markup,0)+isnull(@pc_lucro,0)))/100 )

  --return(isnull(@pc_markup,0)+isnull(@pc_lucro,0))

end



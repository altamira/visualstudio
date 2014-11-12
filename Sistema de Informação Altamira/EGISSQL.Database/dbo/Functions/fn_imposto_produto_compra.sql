
create function fn_imposto_produto_compra (
  @cd_produto    int, 
  @cd_estado     int,
  @cd_tributacao int)
returns @Imposto table (
  pc_icms                  decimal(25,2),
  pc_ipi                   decimal(25,2),
  pc_reducao_icms          decimal(25,2),
  cd_classificacao_fiscal  int,
  cd_mascara_classificacao char(10),
  cd_situacao_tributaria   char(3))
as

begin

  declare @pc_icms                  decimal(25,2)
  declare @pc_ipi                   decimal(25,2)
  declare @pc_reducao_icms          decimal(25,2)
  declare @cd_classificacao_fiscal  int
  declare @cd_mascara_classificacao char(10)
  declare @cd_situacao_tributaria   char(3)
  declare @pc_icms_estado           decimal(25,2)
  declare @cd_estado_empresa        int

  set @pc_reducao_icms = null
  set @pc_icms_estado  = null

  select 
    @cd_estado_empresa = cd_estado
  from 
    EGISADMIN.dbo.Empresa with (nolock) 
  where 
    cd_empresa = dbo.fn_empresa()

  select 
    @pc_icms_estado  = pc_aliquota_icms_estado,
    @pc_reducao_icms = 100 - isnull(qt_base_calculo_icms,0)
  from Estado_Parametro with(nolock)
  where cd_estado = case when isnull(@cd_estado,0) = 0 
                      then @cd_estado_empresa 
                      else @cd_estado 
                    end and
    cd_pais = 1 -- BRASIL   

  insert into @Imposto
  select 
    
    case when (isnull(@cd_produto,0) = 0) or (@cd_estado <> @cd_estado_empresa) then
      @pc_icms_estado
    else
      case when isnull(ces.pc_icms_classif_fiscal,0)<>0 then
         ces.pc_icms_classif_fiscal
      else
        case when (pfe.cd_produto is not null) and (isnull(p.ic_especial_produto,'N') = 'N') then 
          case when pfe.pc_aliquota_icms_produto < @pc_icms_estado then
             isnull(pfe.pc_aliquota_icms_produto,0)
          else
             @pc_icms_estado
          end 
        else 
          @pc_icms_estado 
        end
      end
    end,

    isnull(cfe.pc_ipi_classificacao, cfs.pc_ipi_classificacao),

    case when (isnull(@cd_produto,0) = 0) then
      0.00
    else
      case when isnull(cfe.cd_classificacao_fiscal,0) <> 0 then
        case when isnull(cfe.ic_base_reduzida,'N') = 'S' then
          case when isnull(ces.pc_redu_icms_class_fiscal,0)>0 then
             ces.pc_redu_icms_class_fiscal
          else
             @pc_reducao_icms   
          end
        else
          0.00
        end
      else
        case when isnull(cfs.ic_base_reduzida,'N') = 'S' then
          case when isnull(css.pc_redu_icms_class_fiscal,0)>0 then
             css.pc_redu_icms_class_fiscal
          else
             @pc_reducao_icms
          end
        else
          0.00
        end
      end
    end,
 
    isnull(cfe.cd_classificacao_fiscal, cfs.cd_classificacao_fiscal),
    isnull(cfe.cd_mascara_classificacao, cfs.cd_mascara_classificacao),   

    (select cast(isnull(pp.cd_digito_procedencia,0) as char(1)) + isnull(ti.cd_digito_tributacao_icms,'00') as cd_situacao_tributaria
     from Tributacao t 
       left outer join Tributacao_ICMS ti     on ti.cd_tributacao_icms = t.cd_tributacao_icms
       left outer join Procedencia_Produto pp on pp.cd_procedencia_produto = isnull(pfe.cd_procedencia_produto,isnull(pf.cd_procedencia_produto,1))
     where t.cd_tributacao = @cd_tributacao)

  from Produto p with(nolock)
    left outer join Produto_Fiscal_Entrada pfe      with(nolock) on p.cd_produto = pfe.cd_produto
    left outer join Produto_Fiscal pf               with(nolock) on p.cd_produto = pf.cd_produto
    left outer join Classificacao_Fiscal cfe        with(nolock) on cfe.cd_classificacao_fiscal = pfe.cd_classificacao_fiscal
    left outer join Classificacao_Fiscal cfs        with(nolock) on cfs.cd_classificacao_fiscal = pf.cd_classificacao_fiscal
    left outer join Classificacao_Fiscal_Estado ces with(nolock) on ces.cd_classificacao_fiscal = pfe.cd_classificacao_fiscal and
                                                                    ces.cd_estado               = @cd_estado

    left outer join Classificacao_Fiscal_Estado css with(nolock) on css.cd_classificacao_fiscal = pf.cd_classificacao_fiscal and
                                                                    css.cd_estado               = @cd_estado

--select * from classificacao_fiscal_estado

  where p.cd_produto = @cd_produto

  return

end


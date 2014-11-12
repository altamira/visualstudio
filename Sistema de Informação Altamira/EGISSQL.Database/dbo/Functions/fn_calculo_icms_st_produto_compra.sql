
---------------------------------------------------------------------------------------
--sp_helptext fn_calculo_icms_st_produto_compra
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2010
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL
--Objetivo		: Cálculo do ICMS Substituição Tributária por Produto
--
--
--Data			: 21.03.2010
--Atualização           : 28.10.2010 - Ajustes Diversos - Carlos Fernandes
-- 02.11.2010 - Verificação do Percentual específico para o fornecedor - Carlos Fernandes
-- 07.12.2010 - Ajuste para Compras - Carlos Fernandes
---------------------------------------------------------------------------------------

create FUNCTION fn_calculo_icms_st_produto_compra

(
 @cd_produto              int   = 0,
 @qt_produto              float = 0,
 @cd_fornecedor           int   = 0,
 @pc_icms                 float = 0,
 @cd_classificacao_fiscal int   = 0,
 @vl_produto              float = 0,
 @vl_ipi                  float = 0,
 @cd_destinacao_produto   int   = 0
)

returns float

as

begin

  --select * from destinacao_produto

  declare @vl_icms_st                decimal(25,2)
  declare @pc_icms_interna           decimal(25,4)
  declare @pc_st                     decimal(25,4)
  declare @ic_st                     char(1)
  declare @ic_ipi_base_st_fornecedor char(1)
  declare @BaseICMSSUBST             decimal(25,2)
  declare @sBaseFixaST               char(1)
  declare @ValorICMS                 decimal(25,2)
  declare @cd_estado                 int
  declare @sg_estado                 char(2)
  declare @ic_st_destinacao_produto  char(1)
  declare @pc_st_fornecedor          decimal(25,4)

  set @vl_icms_st       = 0.00
  set @ic_st            = 'N'
  set @sBaseFixaST      = 'N'
  set @BaseICMSSUBST    = @vl_produto
  set @ValorICMS        = 0
  set @pc_st            = 0.00
  set @pc_st_fornecedor = 0.00

  select
    @ic_st_destinacao_produto = isnull(ic_st_destinacao_produto,'N')   
  from
    destinacao_produto with (nolock)
  where
    cd_destinacao_produto = @cd_destinacao_produto


  --select * from classificacao_fiscal


  --select * from classificacao_fiscal

  if @cd_classificacao_fiscal = 0
  begin

    select
      @cd_classificacao_fiscal = isnull(cd_classificacao_fiscal,0)
    from
      produto_fiscal_entrada pf    with (nolock) 
      inner join produto p         with (nolock) on p.cd_produto = pf.cd_produto
    where
      pf.cd_produto = @cd_produto

  end

--  select @cd_classificacao_fiscal

  select
    @ic_st = isnull(ic_subst_tributaria,'N')
  from
    classificacao_fiscal cf with (nolock) 
  where
    cd_classificacao_fiscal = @cd_classificacao_fiscal
 

--  select @ic_st

  if @ic_st = 'S' and @ic_st_destinacao_produto = 'S'
  begin

    --set @vl_icms_st = 1

    SELECT     
      @pc_icms_interna           = isnull(ep.pc_aliquota_icms_interna,@pc_icms),
      @pc_st                     = isnull(ep.pc_icms_substrib_estado,0),
      @ic_ipi_base_st_fornecedor = isnull(f.ic_ipi_base_st_fornecedor,'S'),
      @sg_estado                 = isnull(e.sg_estado,'SP'),
      @cd_estado                 = f.cd_estado
    FROM         
      Fornecedor f                        WITH(NOLOCK) 
      LEFT OUTER JOIN Estado e            WITH(NOLOCK) on f.cd_estado = e.cd_estado AND f.cd_pais   = e.cd_pais 
      LEFT OUTER JOIN Estado_Parametro ep WITH(NOLOCK) on f.cd_pais   = ep.cd_pais  and f.cd_estado = ep.cd_estado

    WHERE     
      f.cd_fornecedor = @cd_fornecedor and
      isnull(f.ic_sub_tributaria_fornecedor,'N') = 'S' 


--    select  @pc_icms_interna, @pc_st, @ic_ipi_base_st_fornecedor, @sg_estado, @cd_estado

    --select * from fornecedor

    --(%) Subst. Tributária do Estado

    --select * from classificacao_fiscal_estado
      
     select
       @pc_st           = isnull(pc_icms_strib_clas_fiscal,@pc_st),
       @pc_icms_interna = isnull(pc_interna_icms_clas_fis,@pc_icms_interna),
       @pc_icms         = isnull(pc_icms_clas_fiscal,@pc_icms)
     from
       classificacao_fiscal_estado cfe with (nolock) 
     where
       cd_classificacao_fiscal = @cd_classificacao_fiscal and
       cd_estado               = @cd_estado 

     --(%) Subst. Tributária do fornecedor---------------------------------------------
     --select * from fornecedor_regime_st

     select
       @pc_st_fornecedor = isnull(crs.pc_icms_strib_fornecedor,0)
     from
       fornecedor_regime_st crs with (nolock)     
     where
       crs.cd_fornecedor           = @cd_fornecedor  and
       crs.cd_classificacao_fiscal = @cd_classificacao_fiscal and
       crs.cd_estado               = @cd_estado


     --Verifica o (%) ST do fornecedor e do Produto/Classificacação/Estado
     if @pc_st_fornecedor <> 0 and @pc_st<>0
        set @pc_st = @pc_st_fornecedor
    
     ----------------------------------------------------------------------------------     

--    select @pc_st,@pc_icms_interna,@pc_icms, @ic_ipi_base_st_fornecedor
 
    if @ic_ipi_base_st_fornecedor='S' 
    begin
      set @BaseICMSSUBST = @BaseICMSSUBST + @vl_ipi
    end

    set @BaseICMSSUBST = round(@BaseICMSSUBST * (1 + (@pc_st / 100)),2)

--    select @BaseICMSSUBST

    if ( @pc_icms_interna>0 ) and ( @pc_icms = 0 )
    begin

       set @vl_icms_st = round((@BaseICMSSUBST * (@pc_icms_interna / 100)),2)

       -- select @vl_icms_st

    end
    else
       if ( @pc_icms_interna>0 ) and ( @pc_icms <> @pc_icms_interna ) and
          ( @sg_estado<>'SP' )
       begin
          set @vl_icms_st = (@BaseICMSSUBST * (@pc_icms_interna / 100))

          --select @vl_icms_st
       end
       else
         begin 
           set @vl_icms_st = (@BaseICMSSUBST * (@pc_icms / 100))
--           select @vl_icms_st
         end

    set @ValorICMS  = @vl_produto       * (@pc_icms/100)

    --select @vl_icms_st
    --select @ValorICMS

    set @vl_icms_st = round(@vl_icms_st - @ValorICMS,2)

    --select @vl_icms_st
   
  end

  if @pc_st=0 
     set @vl_icms_st = 0.00

  return isnull(@vl_icms_st,0)

end


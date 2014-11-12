
---------------------------------------------------------------------------------------
--sp_helptext fn_calculo_icms_st_produto
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
-- 02.11.2010 - Verificação do Percentual específico para o Cliente - Carlos Fernandes
---------------------------------------------------------------------------------------

create FUNCTION fn_calculo_icms_st_produto

(
 @cd_produto              int   = 0,
 @qt_produto              float = 0,
 @cd_cliente              int   = 0,
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

  declare @vl_icms_st               decimal(25,2)
  declare @pc_icms_interna          decimal(25,4)
  declare @pc_st                    decimal(25,4)
  declare @ic_st                    char(1)
  declare @ic_ipi_base_st_cliente   char(1)
  declare @BaseICMSSUBST            decimal(25,2)
  declare @sBaseFixaST              char(1)
  declare @ValorICMS                decimal(25,2)
  declare @cd_estado                int
  declare @sg_estado                char(2)
  declare @ic_st_destinacao_produto char(1)
  declare @pc_st_cliente            decimal(25,4)

  set @vl_icms_st    = 0.00
  set @ic_st         = 'N'
  set @sBaseFixaST   = 'N'
  set @BaseICMSSUBST = @vl_produto
  set @ValorICMS     = 0
  set @pc_st         = 0.00
  set @pc_st_cliente = 0.00

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
      produto_fiscal pf    with (nolock) 
      inner join produto p with (nolock) on p.cd_produto = pf.cd_produto
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
      @pc_icms_interna        = isnull(ep.pc_aliquota_icms_interna,@pc_icms),
      @pc_st                  = isnull(ep.pc_icms_substrib_estado,0),
      @ic_ipi_base_st_cliente = isnull(c.ic_ipi_base_st_cliente,'S'),
      @sg_estado              = isnull(e.sg_estado,'SP'),
      @cd_estado              = c.cd_estado
    FROM         
      Cliente c                           WITH(NOLOCK) 
      LEFT OUTER JOIN Estado e            WITH(NOLOCK) on c.cd_estado = e.cd_estado AND c.cd_pais   = e.cd_pais 
      LEFT OUTER JOIN Estado_Parametro ep WITH(NOLOCK) on c.cd_pais   = ep.cd_pais  and c.cd_estado = ep.cd_estado

    WHERE     
      c.cd_cliente = @cd_cliente and
      isnull(c.ic_sub_tributaria_cliente,'N') = 'S' 


--    select  @pc_icms_interna, @pc_st, @ic_ipi_base_st_cliente, @sg_estado, @cd_estado

    --select * from cliente

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

     --(%) Subst. Tributária do Cliente---------------------------------------------
     --select * from cliente_regime_st

     select
       @pc_st_cliente = isnull(crs.pc_icms_strib_cliente,0)
     from
       cliente_regime_st crs with (nolock)     
     where
       crs.cd_cliente              = @cd_cliente  and
       crs.cd_classificacao_fiscal = @cd_classificacao_fiscal and
       crs.cd_estado               = @cd_estado


     --Verifica o (%) ST do cliente e do Produto/Classificacação/Estado
     if @pc_st_cliente <> 0 and @pc_st<>0
        set @pc_st = @pc_st_cliente
    
     ----------------------------------------------------------------------------------     

--    select @pc_st,@pc_icms_interna,@pc_icms, @ic_ipi_base_st_cliente
 
    if @ic_ipi_base_st_cliente='S' 
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


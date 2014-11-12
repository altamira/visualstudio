
CREATE FUNCTION fn_vl_venda_produto (
	@sg_estado             char(2) = '',
	@cd_destinacao_produto int     = 0,
	@cd_produto            int     = 0 )
RETURNS NUMERIC(18,2)
AS
Begin
	declare @vl_IPI       float, 
		@vl_ReducICMS float, 
		@vl_ICMS      float,
		@cd_estado    int,
		@pc_icms      float,
		@pc_ipi       float,
		@pc_icms_red  float,
		@ic_icms_proposta_empresa char(1),
		@ic_ipi_base_calculo_ICMS char(1),
		@pc_aliquota_icms_estado  float,
		@Preco           float,
		@vl_produto      float,
		@cd_fase_produto int
	
	--Define o estado
	select top 1 @cd_estado = cd_estado from estado where sg_estado = @sg_estado

	--Define a aliquota do estado
	select top 1 @pc_aliquota_icms_estado = pc_aliquota_icms_estado  from Estado_Parametro where cd_estado = @cd_estado
	
	--Define se irá utilizar o ICMS embutido
	select 
		@ic_icms_proposta_empresa = ic_icms_proposta_empresa,
		@cd_fase_produto	  = cd_fase_produto
	from 
		Parametro_Comercial 
	where 
		cd_empresa = dbo.fn_empresa()

	--Gera o resultado

	Select top 1
          @vl_produto  = CAST(ISNULL(p.vl_produto,0) AS SMALLMONEY),
	  @pc_ipi      = isnull(dbo.fn_get_IPI_Produto(p.cd_produto),0), --Descrição = IPI
	  @pc_icms     = isnull((Select top 1 IsNull(pc_icms_classif_fiscal,0)  from Classificacao_fiscal_Estado where cd_estado = @cd_estado and cd_classificacao_fiscal = (Select top 1 IsNull(cd_classificacao_fiscal,0) from Produto_Fiscal where cd_produto = p.cd_produto)),0),
	  @pc_icms_red = isnull((Select top 1 IsNull(pc_red_icms_clas_fiscal,0) from Classificacao_fiscal_Estado where cd_estado = @cd_estado and cd_classificacao_fiscal = (Select top 1 IsNull(cd_classificacao_fiscal,0) from Produto_Fiscal where cd_produto = p.cd_produto)),0)
	from 
          Produto p
	where 
          p.cd_produto = @cd_produto

	--Define as base de cálculo
	set @vl_IPI       = 1.00
	set @vl_ReducICMS = 1.00
	set @vl_ICMS      = 0.00
	
  select top 1 
     @ic_ipi_base_calculo_ICMS = IsNull(ic_ipi_base_icm_dest_prod,'N')
  from 
     Destinacao_Produto
  where
     cd_destinacao_produto = @cd_destinacao_produto

	--Verifica se o valor do ipi deve ser agregado ao preço do produto
	if IsNull(@ic_ipi_base_calculo_ICMS,'N') = 'S'
	begin
          set @vl_IPI = (1 + @pc_ipi /100)
	end
	
	--Preço de Lista, conforme parametro comercial
	if @pc_icms > 0
	begin
	     if @ic_icms_proposta_empresa = 'S' --Verifica se a empresa agrega ao valor o ICMS
	     begin
	        --Define a reduçaõ de base de ICMS
	        if @pc_icms_red > 0
	     	   set @vl_ReducICMS = (@pc_icms_red/100)
	        --Define o valor do ICMS
	        set @vl_ICMS = @pc_icms/100
	     end
	 end
	 else
	 begin
	     if @ic_icms_proposta_empresa = 'S'
	     begin
		--Define o valor do ICMS
		set @vl_ICMS = @pc_aliquota_icms_estado/100
             end
	 end
	
        --Preço de Lista
	set @Preco = cast((@vl_produto / (1 - ((isnull(@vl_ReducICMS,0) * isnull(@vl_ICMS,0)) * isnull(@vl_IPI,0)))) as Numeric(18,2))

	if @Preco is null
	   set @Preco = 0
	
	RETURN @Preco

end


-------------------------------------------------------------------------------------------
--Example to execute function
-------------------------------------------------------------------------------------------
--Select * from fn_vl_venda_produto 'SP',2,263
-------------------------------------------------------------------------------------------

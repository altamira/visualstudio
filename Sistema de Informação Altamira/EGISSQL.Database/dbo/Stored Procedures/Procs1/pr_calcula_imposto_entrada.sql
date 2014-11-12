
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)       : Elias P. Silva
--Banco de Dados  : EGISSQL
--Objetivo        : Faz o cálculo dos Impostos para o lançamento de Entrada
--Data            : 20/12/2002
--Atualizado      : 
-- 24/05/2004 - Incluído classificação fiscal de entrada, acerto na verificação
-- da variável FornSImples ( não estava verificando nulo.) - Daniel C. Neto.
--02.02.2008 - Ajustes Diversos - Carlos Fernandes
-----------------------------------------------------------------------------------------


create procedure pr_calcula_imposto_entrada
@ic_parametro            int,
@cd_fornecedor           int,
@cd_operacao_fiscal      int,
@cd_produto              int,
@cd_tributacao           int,
@cd_classificacao_fiscal int,
@pc_base_calc_icms       float output,
@pc_base_calc_ipi        float output,
@pc_icms                 float output,
@pc_ipi	                 float output,
@cd_sit_tributaria       char(3) output,
@cd_tributacao_new       int output

as


  -- Variáveis do Fornecedor

  declare @FornDestinacao 	char(1)
  declare @FornEquiparIndl 	char(1)
  declare @FornSimples 		char(1)
  declare @FornPessoa 		int
  declare @FornAplicProduto 	int
  declare @FornTipoMercado 	int
  declare @FornDestProduto 	int
  declare @FornISS 		char(1)
  declare @FornINSS 		char(1)
  declare @FornPais 		int
  declare @FornEstado 		int

  -- Variáveis do Estado Parametro

  declare @EstZonaFranca 	char(1)
  declare @EstDigitoEntrada 	int
  declare @EstAliqICMS 		float
  declare @EstAliqICMSInt 	float
  declare @EstBCICMS 		float
  declare @EstAliqICMSSubTrib 	float

  -- Variaveis da Operacao Fiscal

  declare @CFOPTributacao 	int
  declare @CFOPComercial 	char(1)
  declare @CFOPCredICMS 	char(1)
  declare @CFOPCredIPI 		char(1)
  declare @CFOPBCICMS 		float
  declare @CFOPContribICMS 	char(1)
  declare @CFOPEquiparIndl 	char(1)
  declare @CFOPInterest 	char(1)
  declare @CFOPZonaFranca 	char(1)
  declare @CFOPDestProduto 	int
  declare @CFOPPrestServico 	char(1)

  -- Variáveis da Tributação de ICMS
  declare @TribICMSDigito 	char(2)

  -- Variáveis do Produto
  declare @ProdDestinacao 	int
  declare @ProdTipo 		int
  declare @ProdProcedencia 	int
  declare @ProdClassFiscal 	int
  declare @ProdTributacao 	int
  declare @ProdAliqISS 		float
  declare @ProdAliqICMS 	float 
  declare @ProdSubTrib 		char(1)
  declare @ProdDigitoProcedencia int

  -- Variáveis da Classificação Fiscal
  declare @ClassAliqIPI 	float
  declare @ClassSubTrib 	char(1)
  declare @ClassBCIPIRed 	char(1)
  declare @ClassAliqII 		float

  -- Variáveis da Classificação Fiscal p/ Estado
  declare @ClassEstAliqICMS 	float
  declare @ClassEstRedBCICMS 	float
  declare @ClassEstAliqICMSSubTrib float

  -- Variáveis da Tributação
  declare @TribTribICMS 	int
  declare @TribCalcICMS 	char(1)
  declare @TribCalcIPI 		char(1)
  declare @TribRedBCICMS        float
  declare @TribRedBCIPI         float

  -- Variáveis do FornecedorxImpostoxProduto
  declare @FIPClassFiscal 	int
  declare @FIPAliqIPI 		float
  declare @FIPAliqICMS 		float
  declare @FIPCredIPI 		char(1)
  declare @FIPBCIPI 		float

  -- Variáveis do Parâmetro Fiscal
  declare @ParFiscBCIPIEquipIndl float

  -- Variáveis retornadas
--  declare @pc_base_calc_icms   	float
--  declare @pc_base_calc_ipi    	float
--  declare @pc_icms             	float
--  declare @pc_ipi              	float
--  declare @cd_sit_tributaria   	char(3)
--  declare @cd_tributacao_new  	int


-------------------------------------------------------------------------------
if @ic_parametro = 1         -- 
-------------------------------------------------------------------------------
  begin

    -- Selecionando os dados necessários do Fornecedor

    select
      @FornDestinacao 	= ic_destinacao_fornecedor,
      @FornEquiparIndl 	= ic_equiparado_industrial,
      @FornSimples 	= ic_simples_fornecedor,
      @FornPessoa 	= cd_tipo_pessoa,
      @FornAplicProduto = cd_aplicacao_produto,
      @FornTipoMercado 	= cd_tipo_mercado,
      @FornDestProduto 	= cd_destinacao_produto,
      @FornISS 		= ic_iss_fornecedor,
      @FornINSS 	= ic_inss_fornecedor,
      @FornPais 	= cd_pais,
      @FornEstado 	= cd_estado
    from
      Fornecedor
    where
      cd_fornecedor = @cd_fornecedor

    -- Selecionando dados necessários da Operação Fiscal

    select
      @CFOPTributacao 	= cd_tributacao,
      @CFOPComercial 	= ic_comercial_operacao,
      @CFOPCredICMS 	= ic_credito_icms_operacao,
      @CFOPCredIPI 	= ic_credito_ipi_operacao,
      @CFOPBCICMS 	= qt_baseicms_op_fiscal,
      @CFOPContribICMS 	= ic_contribicms_op_fiscal,
      @CFOPEquiparIndl 	= ic_equipind_op_fiscal,
      @CFOPInterest 	= ic_opinterestadual_op_fis,
      @CFOPZonaFranca 	= ic_zfm_operacao_fiscal,
      @CFOPDestProduto 	= cd_destinacao_produto,
      @CFOPPrestServico = ic_servico_operacao
    from
      Operacao_Fiscal
    where
      cd_operacao_fiscal = @cd_operacao_fiscal

    -- Selecionando dados necessários do Estado Fiscal
    select
      @EstZonaFranca 	  = ic_zona_franca,
      @EstDigitoEntrada   = cd_digito_fiscal_entrada,
      @EstAliqICMS 	  = pc_aliquota_icms_estado,
      @EstAliqICMSInt 	  = pc_aliquota_icms_interna,
      @EstBCICMS 	  = qt_base_calculo_icms,
      @EstAliqICMSSubTrib = pc_icms_substrib_estado    
    from
      Estado_Parametro
    where
      cd_pais = @FornPais and
      cd_estado = @FornEstado

    -- Selecionando dados necessários do Produto

    select 
      @ProdDestinacao 	= p.cd_destinacao_produto,
      @ProdTipo 	= p.cd_tipo_produto,
      @ProdProcedencia 	= p.cd_procedencia_produto,
      @ProdClassFiscal 	= p.cd_classificacao_fiscal,
      @ProdTributacao 	= p.cd_tributacao,
      @ProdAliqISS 	= p.pc_aliquota_iss_produto,
      @ProdAliqICMS 	= p.pc_aliquota_icms_produto,
      @ProdSubTrib 	= p.ic_substrib_produto,
      @ProdDigitoProcedencia = c.cd_digito_procedencia
    from 
      Produto_Fiscal p
    left outer join
      Procedencia_Produto c
    on
      c.cd_procedencia_produto = p.cd_procedencia_produto
    where
      p.cd_produto = @cd_produto

    -- Selecionando dados necessários no FornecedorxImpostoxProduto

    select
      @FIPClassFiscal 	= cd_classificacao_fiscal,
      @FIPAliqIPI	= pc_ipi_fornecedor_prod,
      @FIPAliqICMS 	= pc_icms_fornecedor_prod,
      @FIPCredIPI 	= ic_credipi_forne_prod,
      @FIPBCIPI 	= pc_credipi_forne_prod
    from
      Fornecedor_Imposto_Produto
    where
      cd_fornecedor = @cd_fornecedor and
      cd_produto = @cd_produto

    -- Selecionando dados necessários da Classificação Fiscal

    select
      @ClassAliqIPI 	= IsNull(pc_ipi_entrada_classif,pc_ipi_classificacao),
      @ClassSubTrib 	= ic_subst_tributaria,
      @ClassBCIPIRed 	= ic_base_reduzida,
      @ClassAliqII 	= pc_importacao
    from
      Classificacao_Fiscal
    where
      cd_classificacao_fiscal = case when isnull(@cd_classificacao_fiscal,0)=0 then
                                  case when (isnull(@FIPClassFiscal,0)=0) 
                                     then 
                                       @ProdClassFiscal
                                     else 
                                       @FIPClassFiscal
                                     end                                    
                                else
                                  @cd_classificacao_fiscal
                                end  

    -- Selecionando dados necessários da Classificação Fiscal do Estado

    select
      @ClassEstAliqICMS 	= pc_icms_classif_fiscal,
      @ClassEstRedBCICMS 	= pc_redu_icms_class_fiscal,
      @ClassEstAliqICMSSubTrib 	= pc_icms_strib_clas_fiscal
    from
      Classificacao_Fiscal_Estado
    where
      cd_classificacao_fiscal = isnull(@cd_classificacao_fiscal,@ProdClassFiscal) and
      cd_estado = @FornEstado

    -- Selecionando dados necessários da Tributação
    -- ELIAS 07/10/2003 - Carregando Parâmetros Defalult da Tributacao
    select 
      @TribTribICMS = t.cd_tributacao_icms,
      @TribCalcICMS = (select top 1
                         c.ic_evento_tributacao
                       from
                         Composicao_Tributacao c
                       where
                         c.cd_tributacao = t.cd_tributacao and
                         c.cd_imposto = 1),
      @TribCalcIPI  = (select top 1
                         c.ic_evento_tributacao
                       from
                         Composicao_Tributacao c
                       where
                         c.cd_tributacao = t.cd_tributacao and
                         c.cd_imposto = 2),
      @TribRedBCICMS = isnull(pte.pc_reducao_bc_icms,0),
      @TribRedBCIPI  = isnull(pte.pc_reducao_bc_ipi,0)
    from    
      Tributacao t
    left outer join
      Parametro_Tributacao_Entrada pte
    on
      pte.cd_tributacao = t.cd_tributacao
    where
      t.cd_tributacao = case when isnull(@cd_tributacao,0) = 0 then
                          case when (isnull(@ProdTributacao,0)=0) then 
                            @CFOPTributacao
                          else 
                            @ProdTributacao
                          end
                        else
                          @cd_tributacao
                        end

    -- Selecionando dados necessários da Tributação de ICMS

    select 
      top 1
      @TribICMSDigito = cd_digito_tributacao_icms
    from 
      Tributacao_ICMS
    where
      cd_tributacao_icms = @TribTribICMS

    -- Selecionando dados do Parâmetro Fiscal

    select
      @ParFiscBCIPIEquipIndl = pc_base_ipi_equip_indl
    from
      Parametro_Fiscal
    where
      cd_empresa = dbo.fn_empresa()

    -- 1 - Inicialização das variáveis

    set @pc_base_calc_icms = 100
    set @pc_base_calc_ipi  = 100
    set @pc_icms           = 0
    set @pc_ipi            = 0

    -- 2 - Cálculo da Base de Cálculo do ICMS
    -- Ordem: 1 - Redução Default do Parâmetro da Tributacao
    --        2 - Operação Fiscal
    --        3 - Estado Parâmetro
    --        4 - Classificação Fiscal p/ a UF  

    if isnull(@TribRedBCICMS,0)<>0
    begin
      set @pc_base_calc_icms = @TribRedBCICMS
    end

    if isnull(@CFOPBCICMS,0) <> 0
    begin
      set @pc_base_calc_icms = @CFOPBCICMS
    end

--    if isnull(@EstBCICMS,999) <> 999 
--    begin
--      set @pc_base_calc_icms = @EstBCICMS
--    end

    if isnull(@ClassEstRedBCICMS,999) <> 999
    begin
      set @pc_base_calc_icms = @ClassEstRedBCICMS
    end

    -- 3 - Cálculo da Base de Cálculo do IPI
    -- Ordem: 1 - Redução Default do Parâmetro da Tributacao
    --        2 - Classificação Fiscal
    --        3 - Fornecedor x Imposto x Produto
    --        4 - Equiparado Industrial

--    if isnull(@ClassBCIPIRed,999) <> 999
--      set @pc_base_calc_ipi = @ClassBCIPIRed

    if isnull(@TribRedBCIPI,0)<>0
      set @pc_base_calc_ipi = @TribRedBCIPI

    if isnull(@FIPBCIPI,999) <> 999
      set @pc_base_calc_ipi = @FIPBCIPI

    if ((@FornEquiparIndl = 'S') or (@CFOPEquiparIndl = 'S'))
      set @pc_base_calc_ipi = @pc_base_calc_ipi * ((@ParFiscBCIPIEquipIndl)/100)

    -- 4 - Cálculo da Alíquota do ICMS
    -- Ordem: 1 - Estado Parâmetro
    --        2 - Produto
    --        3 - Classificação Fiscal do Estado
    --        4 - Fornecedor x Imposto x Produto
    --if ((@CFOPCredICMS <> 'N') and (@TribCalcICMS <> 'N'))
    if (@TribCalcICMS <> 'N')
      begin
        
        if isnull(@EstAliqICMS,999) <> 999
          set @pc_icms = @EstAliqICMS

        if isnull(@ProdAliqICMS,999) <> 999
          set @pc_icms = @ProdAliqICMS

        if isnull(@ClassEstAliqICMS,999) <> 999
          set @pc_icms = @ClassEstAliqICMS

        if isnull(@FIPAliqICMS,999) <> 999
          set @pc_icms = @FIPAliqICMS
     
      end

    -- 5 - Cálculo da Alíquota do IPI
    -- Ordem: 1 - Classificação Fiscal
    --        2 - Fornecedor x Imposto x Produto
--     if ((@FornSimples <> 'S') and (@CFOPCredIPI <> 'N') 
--       and (@TribCalcIPI <> 'N') and (@FIPCredIPI <> 'N'))

    if (IsNull(@FornSimples,'N') <> 'S')
      begin

        if isnull(@ClassAliqIPI,999) <> 999
          set @pc_ipi = @ClassAliqIPI
                  
        if isnull(@FIPAliqIPI,999) <> 999
          set @pc_ipi = @FIPAliqIPI

     end

    --select @FornSimples, @ClassAliqIPI, @FIPAliqIPI, @TribCalcIPI

    -- 6 - Situação Tributária
    set @cd_sit_tributaria = @ProdDigitoProcedencia + @TribICMSDigito

    -- 7 - Tributação
    set @cd_tributacao_new = case when isnull(@cd_tributacao,0) = 0 then
                               case when (isnull(@ProdTributacao,0)=0) then 
                                 @CFOPTributacao
                               else 
                                 @ProdTributacao     
                               end		             
                             else
                               @cd_tributacao
                             end 

    -- Listando o resultado da procedure
--     select
--       @pc_base_calc_icms as 'pc_base_calc_icms',
--       @pc_base_calc_ipi  as 'pc_base_calc_ipi',
--       @pc_icms		 as 'pc_icms',
--       @pc_ipi		 as 'pc_ipi',
--       @cd_sit_tributaria as 'cd_sit_tributaria',
--       @cd_tributacao_new as 'cd_tributacao'
--       
  end


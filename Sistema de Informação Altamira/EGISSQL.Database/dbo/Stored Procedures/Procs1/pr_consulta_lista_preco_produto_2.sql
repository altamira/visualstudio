CREATE PROCEDURE pr_consulta_lista_preco_produto_2
@cd_estado int,
@cd_destinacao_produto int,
@nm_fantasia_produto varchar(30)
-- @ic_custo_financeiro char(1),
-- @vl_custo_financeiro float
AS
Begin

   --Declara as variáveis de controle de impostos e de valores
   Declare
     @cd_fase_produto as int,
     @vl_IPI          as float,
     @vl_ReducICMS    as float,
     @vl_ICMS         as numeric(18,2),
     @vl_Lista        as numeric(18,2),
     @vl_Venda        as numeric(18,2),
     @vl_unitario     as numeric(18,2),
     @vl_produto      as numeric(18,2),
     @vl_custo_financeiro as numeric(18,2),
     @pc_icms         as float,
     @pc_icms_red     as float,
     @pc_ali_icms_uf  as float,
     @ic_ipi_empresa  as char(1),
     @ic_icms_empresa as char(1),
     @ic_custo_financeiro char(1)

   --Estou passando valor para esta variável, pois no futuro poderá trabalhar para o cálculo do valor com o custo financeiro
   Set @ic_custo_financeiro = 'N'
   Set @vl_custo_financeiro = 0.00

   --Pega parametros comercial
   select
     @ic_ipi_empresa  = ic_ipi_proposta_empresa,
     @ic_icms_empresa = ic_icms_proposta_empresa,
     @cd_fase_produto = cd_fase_produto
   from
     Parametro_Comercial
   where
     cd_empresa = dbo.fn_empresa()

  --Pega os valores dos Impostos dee acordo com o estado selecionado
  select 
    @pc_ali_icms_uf = pc_aliquota_icms_estado
--     pc_aliquota_icms_interna,
--     cd_digito_fiscal_saida,	
--     ic_zona_franca
  from 
    Estado_Parametro
  where
    cd_estado = @cd_estado
  --Traz o resultado da consulta sem o valor do produto e dos impostos
	  Select 
      p.cd_produto,
      p.vl_produto,
	    p.nm_fantasia_produto as 'nm_fantasia_produto', 
	    p.nm_produto 'nm_descricao',
	    cf.cd_mascara_classificacao as 'nm_mascara_classificacao',
	    (Select top 1 IsNull(pc_icms_classif_fiscal,0) from Classificacao_fiscal_Estado where cd_estado = @cd_estado and cd_classificacao_fiscal = (Select top 1 IsNull(cd_classificacao_fiscal,0) from Produto_Fiscal where cd_produto = p.cd_produto)) as 'pc_icms',
	    Cast(0.00 as float) as 'vl_Lista',
	    Cast(0.00 as float) as 'vl_Venda',
    	(Select top 1 IsNull(pc_red_icms_clas_fiscal,0) from Classificacao_fiscal_Estado where cd_estado = @cd_estado and cd_classificacao_fiscal = (Select top 1 IsNull(cd_classificacao_fiscal,0) from Produto_Fiscal where cd_produto = p.cd_produto)) as 'pc_icms_red',
-- 	    (Select pc_aliquota_icms_estado From Estado_Parametro where cd_estado = @cd_estado) as 'AliqICMS',
	    (Select top 1 sg_unidade_medida from Unidade_Medida where cd_unidade_medida = p.cd_unidade_medida) as 'sg_unidade_medida',
	    dbo.fn_get_ipi_produto(p.cd_produto) as 'pc_ipi',
	    IsNull((select top 1 qt_minimo_produto
	            from produto_saldo 
	            where cd_produto = p.cd_produto and cd_fase_produto = @cd_fase_produto), 0) as 'qt_estoque_min',
	    p.qt_peso_liquido as 'qt_peso_liquido',
	    p.qt_peso_bruto   as 'qt_peso_bruto'
    Into
      #Lista
	  from 
	    Produto p
	      left outer join
	    Produto_Fiscal pf
	      on p.cd_produto = pf.cd_produto
	      Left Outer Join
	    Classificacao_Fiscal cf
	      on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
	  where p.nm_fantasia_produto like @nm_fantasia_produto + '%'
	  order by
	    p.nm_fantasia_produto


   --Procedimento para cálculo do valor do produto
   declare @codigo int

   --Declara o cursor para cálculo do valor do produto
   declare cProduto cursor for
     Select
       cd_produto
     From
       #Lista

   open cProduto
   fetch next from cProduto into @codigo
   while @@FETCH_STATUS = 0
   begin         

     --Preenche as váriáveis com os devidos impostos
     Select
       @pc_icms     = pc_icms,
       @pc_icms_red = pc_icms_red,
       @vl_produto  = vl_produto
     From
       #Lista
     Where 
       cd_produto = @codigo

	   --zera as variáveis para o Cálculo
	   Set @vl_IPI       = 1
	   Set @vl_ReducICMS = 1
	   set @vl_ICMS      = 0
	
	   --Verifica se o valor do ipi deve ser agregado ao preço do produto
	   if IsNull(@ic_ipi_empresa, 'N') = 'S'
	   begin
	      --Valida se o cliente está comprando o produto para uso próprio
	      if @cd_destinacao_produto = 2
	         Set @vl_IPI = (1 + (Select dbo.fn_get_IPI_Produto(@codigo)) /100)
	   end

	   --Preço de Lista, conforme parametro comercial
	   if IsNull(@pc_icms, 0) > 0
	   begin
	     if IsNull(@ic_ipi_empresa, 'N') = 'S'
	     begin
	       --Define a reduçaõ de base de ICMS
	       if IsNull(@pc_icms_red, 0) > 0
	         Set @vl_ReducICMS = (@pc_icms_red/100)
	       --Define o valor do ICMS
	       Set @vl_ICMS = (@pc_icms / 100)
	     end
	   end else
	   begin
	     if @ic_icms_empresa = 'S'
	     begin
	        --Define o valor do ICMS
	        Set @vl_ICMS = (@pc_ali_icms_uf / 100)
	     end
	   end
	
	   --Preço de Lista, conforme parametro comercial
	   Set @vl_Lista    = (@vl_produto / (1 - ((@vl_ReducICMS * @vl_ICMS) * @vl_IPI)))
     Set @vl_unitario = @vl_Lista
	
/*  Procedimento para acrescentar o custo financeiro ao produto
	   if IsNull(@ic_custo_financeiro, 'N') = 'S'
	     Set @vl_unitario = @vl_Lista * (1 + (@vl_custo_financeiro / 100))
	   else
	     Set @vl_unitario = @vl_Lista
*/	
	
	   if IsNull(@ic_custo_financeiro, 'N') = 'S'
	      --Define o valor de venda acrescido do custo financeiro
	     Set @vl_Venda = @Vl_Lista * (1 + @vl_custo_financeiro /100)
	   else
	      --Define o valor de Venda
	     Set @vl_Venda = @Vl_Lista
	
     Update #Lista
     Set vl_lista = @vl_lista,
         vl_venda = @vl_venda
     Where
       cd_produto = @codigo

     fetch next from cProduto into @codigo
   end
   close cProduto
   deallocate cProduto


  Select * From #Lista
  Drop Table #Lista

end

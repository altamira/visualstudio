
---------------------------------------------------
-- pr_gerar_custo_reposicao
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Elias Pereira da Silva
--Banco de Dados: EgisSQL
--Objetivo      : Carrega o Custo de Reposição no Produto Custo
--Data          : 01/09/2004
--Atualizado    : 
-- 1 - Verificar a forma de Cálculo do Custo, se com ou sem o IPI
-- 2 - Filtrar somente as NF c/ CFOP c/ Valor Comercial
-- 3 - Sempre a última entrada, ordem de recebimento
---------------------------------------------------
create procedure pr_gerar_custo_reposicao
@ic_parametro int,
@cd_produto int

as

----------------------------------------------------------------------------------
if @ic_parametro = 1    -- PREENCHE O CADASTRO DO PRODUTO COM O CUSTO DE REPOSIÇÃO
----------------------------------------------------------------------------------
begin

  -- variável que guardará o custo de reposição
  declare @vl_custo_unitario float

  declare @ic_ipi_custo_produto char(1)

  -- Verifica a Forma de Cálculo do Custo
  select @ic_ipi_custo_produto = ic_ipi_custo_produto
  from parametro_custo where cd_empresa = dbo.fn_empresa()

  -- encontra o custo do último recebimento
	select top 1 
    @vl_custo_unitario = case when (isnull(@ic_ipi_custo_produto,'N') = 'S') then
										   	  ((nei.vl_total_nota_entr_item + 
											      nei.vl_ipi_nota_entrada - 
											      nei.vl_icms_nota_entrada) / 
											      nei.qt_item_nota_entrada)
                         else
										   	  ((nei.vl_total_nota_entr_item - 
											      nei.vl_icms_nota_entrada) / 
											      nei.qt_item_nota_entrada)
                         end
	from nota_entrada_item nei
	inner join nota_entrada ne 
	on ne.cd_nota_entrada = nei.cd_nota_entrada and
	   ne.cd_fornecedor = nei.cd_fornecedor and
	   ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
	   ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
	inner join operacao_fiscal op
	on op.cd_operacao_fiscal = ne.cd_operacao_fiscal and
	   isnull(op.ic_comercial_operacao,'N') = 'S'
	where cd_produto = @cd_produto
	order by ne.dt_receb_nota_entrada desc

  -- altera o custo de reposição do produto
  update produto_custo set vl_custo_produto = @vl_custo_unitario
  where cd_produto = @cd_produto

end





CREATE PROCEDURE pr_consulta_lista_preco_produto
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
     @ic_custo_financeiro char(1),
		 @sg_estado varchar(2)

   --Estou passando valor para esta variável, pois no futuro poderá trabalhar para o cálculo do valor com o custo financeiro
   Set @ic_custo_financeiro = 'N'
   Set @vl_custo_financeiro = 0.00

   --Pega parametros comercial
   select top 1
     @cd_fase_produto = cd_fase_produto
   from
     Parametro_Comercial
   where
     cd_empresa = dbo.fn_empresa()

  --Pega os valores dos Impostos dee acordo com o estado selecionado
  select top 1
    @pc_ali_icms_uf = pc_aliquota_icms_estado
  from 
    Estado_Parametro
  where
    cd_estado = @cd_estado


  select top 1 
    @sg_estado = sg_estado
  from
    Estado
  where
    cd_estado = @cd_estado

  --Traz o resultado da consulta sem o valor do produto e dos impostos
  Select 
    p.cd_produto,
    p.vl_produto,
    p.nm_fantasia_produto as 'nm_fantasia_produto', 
    p.nm_produto 'nm_descricao',
    cf.cd_mascara_classificacao as 'nm_mascara_classificacao',
    (Select top 1 IsNull(pc_icms_classif_fiscal,0) 
       from Classificacao_fiscal_Estado 
       where cd_estado = @cd_estado and
         cd_classificacao_fiscal = (Select top 1 IsNull(cd_classificacao_fiscal,0)
                                      from Produto_Fiscal 
                                      where cd_produto = p.cd_produto)) as 'pc_icms',
    dbo.fn_vl_venda_produto(@sg_estado, @cd_destinacao_produto, p.cd_produto) as 'vl_Lista', --Por não estar trabalhando com custo financeiro não muda
    dbo.fn_vl_venda_produto(@sg_estado, @cd_destinacao_produto, p.cd_produto) as 'vl_Venda',
    (Select top 1 IsNull(pc_red_icms_clas_fiscal,0) 
       from Classificacao_fiscal_Estado 
       where cd_estado = @cd_estado and cd_classificacao_fiscal = 
          (Select top 1 IsNull(cd_classificacao_fiscal,0) 
             from Produto_Fiscal 
             where cd_produto = p.cd_produto)) as 'pc_icms_red',
    (Select top 1 sg_unidade_medida 
       from Unidade_Medida 
       where cd_unidade_medida = p.cd_unidade_medida) as 'sg_unidade_medida',
    dbo.fn_get_ipi_produto(p.cd_produto) as 'pc_ipi',
    IsNull((select top 1 qt_minimo_produto
            from produto_saldo 
            where cd_produto = p.cd_produto and cd_fase_produto = @cd_fase_produto), 0) as 'qt_estoque_min',
	    p.qt_peso_liquido as 'qt_peso_liquido',
	    p.qt_peso_bruto   as 'qt_peso_bruto'
  from 
    Produto p
    left outer join
      Produto_Fiscal pf
      on p.cd_produto = pf.cd_produto
    Left Outer Join
      Classificacao_Fiscal cf
      on pf.cd_classificacao_fiscal = cf.cd_classificacao_fiscal
    left outer join Produto_Custo pc
        on p.cd_produto = pc.cd_produto
  where 
    p.nm_fantasia_produto like @nm_fantasia_produto + '%' and
    isNull(p.cd_status_produto,0) = 1 and --Somente os produtos ativos
    isNull(pc.ic_lista_preco_produto,'S') <> 'N' --Desconsiderar os produto a não ser apresentados na lista
  order by
    p.nm_fantasia_produto

end


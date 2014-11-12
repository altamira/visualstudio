
CREATE PROCEDURE pr_consulta_produto_compra

------------------------------------------------------------------------------------------------------
--pr_consulta_produto_compra
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2003
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)      : Fabio Cesar
--Banco de Dados : EgisSql
--Criação        : 26.10.2005
--Objetivo       : Tornar a pesquisa utilizada por compra mais ágil
--Alteração      : 12.11.2005 - Cálculo do Preço de Custo com Impostos - Carlos Fernandes    
--                 18/01/2006 - Otimização - ELIAS            
--                 25.01.2006 - Não apresentar nenhum registro para os casos de Código do produto 
--                 pós busca ter sido retornado "0" - Fabio Cesar
--                 19.07.2007 - Verificação da busca do Preço do produto por fornecedor
-- 17.07.2008 - Busca do (%) do ICMS conforme o cadastro do fornecedor - Carlos Fernandes
-- 08.01.2009 - Fiscal de Saída quando Fiscal de Entrada estiver vazia - Carlos Fernandes
--------------------------------------------------------------------------------------------
@sg_estado           char(2)     = 'SP', 
@nm_fantasia_produto varchar(30) = '',
@ic_filtro_consulta  char(1)     = 'F',
@cd_fornecedor       int         = 0,
@cd_moeda            int         = 1
AS

declare @pc_icms                 float
declare @cd_estado               int
declare @ic_custo_pedido_imposto char(1) 
declare @cd_aplicacao_markup     int
declare @vl_fator_icms           float
declare @cd_produto              int
declare @vl_preco_fornecedor     decimal(25,2)

set @vl_preco_fornecedor     = 0.00
set @ic_custo_pedido_imposto = 'N'

if @nm_fantasia_produto is null 
  set @cd_produto = 0
else
begin
  if (@ic_filtro_consulta = 'P')
    select @cd_produto = cd_produto
    from Produto with (nolock) 
    where cd_produto = @nm_fantasia_produto
  else if (@ic_filtro_consulta = 'F')
    select @cd_produto = cd_produto
    from Produto with (nolock) 
    where nm_fantasia_produto = @nm_fantasia_produto
  else 
    select @cd_produto = cd_produto
    from Produto with (nolock) 
    where replace(replace(replace(cd_mascara_produto,'-',''),'.',''),'/','') = replace(replace(replace(@nm_fantasia_produto,'-',''),'.',''),'/','')  
end

if (IsNull(@cd_produto,0) > 0)
begin

  select
    @ic_custo_pedido_imposto = isnull(ic_custo_pedido_imposto,'N'),
    @cd_aplicacao_markup     = isnull(cd_aplicacao_markup,0)
  from 
    Parametro_Suprimento with(nolock)
  where 
    cd_empresa = dbo.fn_empresa()

  --Estado da Empresa

  select 
    top 1 @cd_estado = cd_estado
  from 
    Estado with(nolock)
  where 
    sg_estado = @sg_estado

--   --Icms do Estado do Empresa
--   select 
--     top 1 @pc_icms   = pc_aliquota_icms_estado 
--   from Estado_Parametro with(nolock)
--   where cd_estado = @cd_estado

  -- Cálculo do Fator do ICMS
  set @vl_fator_icms = 1

  if @ic_custo_pedido_imposto = 'S' 
  begin
    set @vl_fator_icms = ((100-@pc_icms)/100)
    set @vl_fator_icms = case when @vl_fator_icms > 0 then @vl_fator_icms else 1 end
  end

  --Busca o preço de custo do cadastro do fornecedor

  select 
    @vl_preco_fornecedor = isnull(vl_produto_moeda,0)/@vl_fator_icms
  from
    fornecedor_produto_preco with (nolock)
  where
    @cd_fornecedor = cd_fornecedor and
    @cd_produto    = cd_produto    and
    @cd_moeda      = cd_moeda      

  -- Produto

  select top 1
    p.cd_produto, 
    p.nm_fantasia_produto, 
    p.cd_mascara_produto,
    p.nm_produto,
    p.ds_produto,
    IsNull(p.qt_dias_entrega_medio,0) as qt_dias_entrega_medio,
    isnull(p.vl_produto,0)            as 'vl_produto',
    p.pc_desconto_max_produto,
    IsNull(cf.pc_ipi_entrada_classif, dbo.fn_get_IPI_Produto(p.cd_produto)) as pc_IPI,
    (Select top 1 nm_fantasia_produto from Produto pa with (nolock) where pa.cd_produto = p.cd_substituto_produto) as 'nm_fantasia_produto_substituto',
    p.cd_grupo_produto,
    p.cd_serie_produto,
    p.qt_peso_liquido,
    p.qt_peso_bruto,
    p.nm_marca_produto,
    (Select top 1 IsNull(pc_desconto_max_grupo_produto,0) from Grupo_Produto with(nolock) where cd_grupo_produto = p.cd_grupo_produto) as pc_desconto_max_grupo_produto,
    (Select top 1 IsNull(pc_desconto_serie_produto,0)     from Serie_Produto with(nolock) where cd_serie_produto = p.cd_serie_produto) as pc_desconto_serie_produto,
    IsNull((select top 1 cd_unidade_medida from Produto_Compra with(nolock) where cd_produto = p.cd_produto), p.cd_unidade_medida) as cd_unidade_medida,
    p.cd_categoria_produto,
    p.cd_grupo_categoria,

    --Carlos 11.11.2005
    --Valor Agregar ao Preço de Custo os Impostos ( ICMS/IPI/PIS/COFINS ), porque o valor abaixo está liquido
    --Desenvolver conforme parâmetro
    --????????

    --Valor de Custo do Produto
    case when @vl_preco_fornecedor>0 
    then
      @vl_preco_fornecedor
    else
      (Select top 1 (vl_custo_produto/@vl_fator_icms) from Produto_Custo pc with (nolock) where pc.cd_produto = p.cd_produto) 
    end                                                       as 'vl_custo_produto',

    --ICMS  
   dbo.fn_icms_produto_compra(p.cd_produto,'',@cd_estado,'N') as pc_icms,

    --(%) Redução do ICMS
   dbo.fn_icms_produto_compra(p.cd_produto,'',@cd_estado,'S') as pc_reducao,
   cast(p.qt_area_produto as float)                           as qt_area_produto,
   @cd_estado                                                 as cd_estado

/*    --ICMS  
    isnull(cfe.pc_icms_classif_fiscal,@pc_icms) as pc_icms,

    --(%) Redução do ICMS
    case 
    when cfe.pc_icms_classif_fiscal is null then 0
    else
      cfe.pc_redu_icms_class_fiscal
    end as pc_reducao
*/
  from Produto p                               with (nolock)

    left outer join Status_Produto sp          with (nolock) on sp.cd_status_produto = p.cd_status_produto and 
                                                                 IsNull(sp.ic_bloqueia_uso_produto,'N') <> 'S'
    left outer join Produto_Fiscal pf          with (nolock) on p.cd_produto = pf.cd_produto 
--  left outer join Produto_Fiscal_Entrada pfe with (nolock) on p.cd_produto = pfe.cd_produto 
    left outer join Classificacao_Fiscal cf    with (nolock) on cf.cd_classificacao_fiscal = pf.cd_classificacao_fiscal 
--  left outer join Classificacao_Fiscal cfe   with (nolock) on cf.cd_classificacao_fiscal = pfe.cd_classificacao_fiscal 

--    left outer join Classificacao_fiscal_estado cfe with (nolock) on pf.cd_classificacao_fiscal = cfe.cd_classificacao_fiscal and 
--                                                                     cfe.cd_estado = @cd_estado

  where 
    p.cd_produto = @cd_produto

end
else
  select 
    cast(null as int)     as cd_produto, 
    cast(null as varchar) as nm_fantasia_produto, 
    cast(null as varchar) as cd_mascara_produto,
    cast(null as varchar) as nm_produto,
    cast(null as text)    as ds_produto,
    cast(null as float)   as qt_dias_entrega_medio,
    cast(null as float)   as vl_produto,
    cast(null as float)   as pc_desconto_max_produto,
    cast(null as float)   as pc_IPI,
    cast(null as varchar) as nm_fantasia_produto_substituto,
    cast(null as int)     as cd_grupo_produto,
    cast(null as int)     as cd_serie_produto,
    cast(null as float)   as qt_peso_liquido,
    cast(null as float)   as qt_peso_bruto,
    cast(null as varchar) as nm_marca_produto,
    cast(null as float)   as pc_desconto_max_grupo_produto,
    cast(null as float)   as pc_desconto_serie_produto,
    cast(null as int)     as cd_unidade_medida,
    cast(null as int)     as cd_categoria_produto,
    cast(null as int)     as cd_grupo_categoria,
    cast(null as float)   as vl_custo_produto,
    cast(null as float)   as pc_icms,
    cast(null as float)   as pc_reducao,
    cast(null as float)   as qt_area_produto
  --Código implementado para não trazer nenhum registro, pois estava sendo apresentado um registro com todos os campos nulos
  from 
    Produto with (nolock)
  where
    1=2
  

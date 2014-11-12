
CREATE PROCEDURE pr_consulta_componente_manifold

@cd_consulta        int,
@cd_item_consulta   int,
@ic_hothalf         char(1)

as

declare @qt_largura       float
declare @qt_comprimento   float
declare @qt_perimetro     float
declare @qt_dist_anel     float
declare @qt_dist_canaleta float
declare @qt_anel          int

-- Calcula nro. de anéis 
select top 1 
       @qt_largura     = b.qt_largac_item_orcamento,
       @qt_comprimento = b.qt_compac_item_orcamento,
       @qt_perimetro   = a.qt_perimetro_perfil_externo
from consulta_caract_tecnica_cq a,
     consulta_item_orcamento b
where a.cd_consulta       = @cd_consulta and 
      a.cd_item_consulta  = @cd_item_consulta and
      a.cd_consulta      *= b.cd_consulta and 
      a.cd_item_consulta *= b.cd_item_consulta and
      b.cd_item_orcamento = 1 -- Manifold é apenas um item (uma placa)

set @qt_dist_anel       = (dbo.fn_extracao_parametro_orcamento('#DISTANEL-154'))
set @qt_dist_canaleta   = (dbo.fn_extracao_parametro_orcamento('#DISTPCAN-154'))
if isnull(@qt_perimetro,0) = 0 
   set @qt_perimetro    = (((@qt_largura-@qt_dist_canaleta) + (@qt_comprimento-@qt_dist_canaleta)) * 2) * 2
set @qt_anel            = round((@qt_perimetro / @qt_dist_anel),0)

declare @cd_moeda int
set @cd_moeda = (select top 1 cd_moeda_cotacao from consulta_itens 
                 where cd_consulta = @cd_consulta and cd_item_consulta = @cd_item_consulta)
if isnull(@cd_moeda,0) = 0 
   set @cd_moeda = 1                       

if @ic_hothalf = 'N'
begin
  -- É Manifold : pega a árvore do manifold usado como Padrão !

  Select
     b.cd_ordem_produto             as 'Ordem',
     b.cd_produto                   as 'CodProduto',
     c.nm_fantasia_produto          as 'Produto',
     c.nm_produto                   as 'NomeProduto',
     cast(null as int)              as 'CodProdutoEspacador',
     Qtde =
     case when c.nm_produto like 'bujao%'    then b.qt_produto_composicao * 2
          when c.nm_produto like 'termopar%' then 
             isnull(a.qt_zonas_controlador,b.qt_produto_composicao)
          when c.nm_produto like 'anel el%' then -- Anel Elástico 
             isnull(@qt_anel,b.qt_produto_composicao)
     else b.qt_produto_composicao end,
     c.cd_categoria_produto         as 'Categoria',
  -- Venda = case when tp.cd_produto is null then c.vl_produto else tp.vl_tabela_produto end,
  -- Venda agora vai pegar do "Custo + Markup" ...
     cast(0 as float) as Venda,
     DataPreco =
     isnull((select top 1 dt_produto_preco from Produto_Preco pp where pp.cd_produto = b.cd_produto),GetDate()),
     Custo = isnull(pc.vl_custo_exportacao,pc.vl_custo_produto),
     cast(null as datetime)         as 'DataCusto',
     b.cd_ordem_produto             as 'OrdemProduto',
     TemProdutoFilho =
     case when (select top 1 cd_produto_pai from produto_composicao a
                where b.cd_produto = a.cd_produto_pai) > 0 then 'S' else 'N' end,
     Exportacao = (case when cl.cd_tipo_mercado = 1 then 'N' else 'S' end)

  from
    Consulta_Caract_Tecnica_Cq a

  inner Join Consulta co with (nolock) on
  a.cd_consulta = co.cd_consulta 

  inner Join Cliente cl with (nolock) on
  co.cd_cliente = cl.cd_cliente

  inner Join Produto_Composicao b with (nolock) on 
  a.cd_produto_padrao_orcam = b.cd_produto_pai

  inner Join Produto p with (nolock) on 
  b.cd_produto_pai = p.cd_produto

  inner Join Produto c with (nolock) on 
  b.cd_produto = c.cd_produto

  inner Join Produto_Custo pc with (nolock) on 
  b.cd_produto = pc.cd_produto

  where a.cd_consulta      = @cd_consulta and
        a.cd_item_consulta = @cd_item_consulta and
        b.cd_versao_produto_comp = p.cd_versao_produto

  order by b.cd_ordem_produto
end
else
begin 

  -- É HOTHALF ...

  declare @cd_serie_produto int
  declare @cd_tipo_serie_produto int
  
  select @cd_serie_produto      = cd_serie_produto_padrao,
         @cd_tipo_serie_produto = cd_tipo_serie_produto
  --
  from consulta_itens with (nolock)
  --
  where cd_consulta = @cd_consulta and
        cd_item_consulta = @cd_item_consulta
  
  if isnull(@cd_tipo_serie_produto,0) = 0
     set @cd_tipo_serie_produto = 1 -- Normal
  
  if isnull(@cd_serie_produto,0) = 83 
     set @cd_serie_produto = 60
  
  Select
     a.cd_item_componente           as 'Ordem',
     a.cd_produto                   as 'CodProduto',
     p.nm_fantasia_produto          as 'Produto',
     p.nm_produto                   as 'NomeProduto',
     cast(null as int)              as 'CodProdutoEspacador',
     cast(a.qt_componente_hothalf as float) as 'Qtde',
     p.cd_categoria_produto         as 'Categoria',
     Venda = case when tp.cd_produto is null then p.vl_produto else tp.vl_tabela_produto end,  
     DataPreco =  
     isnull((select top 1 dt_produto_preco from Produto_Preco pp where pp.cd_produto = a.cd_produto),GetDate()),  
     Custo = case when tp.cd_produto is null then pc.vl_custo_produto else 0 end,  
     cast(null as datetime)         as 'DataCusto',
     a.cd_item_componente           as 'OrdemProduto',
     TemProdutoFilho =
     case when (select top 1 cd_produto_pai from produto_composicao a
                where a.cd_produto = a.cd_produto_pai) > 0 then 'S' else 'N' end,
     cast(null as char(1)) as Exportacao
  
  from
    Serie_Produto_Componente_HotHalf a
  
  inner Join Produto p with (nolock) on 
  a.cd_produto = p.cd_produto
  
  inner Join Produto_Custo pc with (nolock) on 
  a.cd_produto = pc.cd_produto

  left outer Join Tabela_Preco_Produto tp with (nolock) on
  a.cd_produto = tp.cd_produto and  
  tp.cd_moeda = @cd_moeda  
   
  where a.cd_serie_produto      = @cd_serie_produto and
        a.cd_tipo_serie_produto = @cd_tipo_serie_produto
  
  order by a.cd_item_componente
end


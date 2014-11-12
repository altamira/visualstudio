
CREATE PROCEDURE pr_consulta_preco_concorrente

@cd_concorrente                  int,
@nm_fantasia_produto             varchar(30),
@nm_fantasia_concorrente         varchar(30),
@nm_produto_codigo_concorrente   varchar(30)

AS

  set nocount on

  select
    isnull(p.nm_fantasia_produto,'.') 				as nm_fantasia_produto,
    isnull(pc.cd_produto_concorrente,'.')			as nm_fantasia_concorrente,
    isnull(pc.nm_fantasia_prod_concorre,'.')			as cd_codigo_concorrente,
    isnull(pc.vl_produto_concorrente,0)				as vl_venda_concorrente,
    case when isnull(pc.nm_marca_prod_concorre,'') = '' then '.' else isnull(pc.nm_marca_prod_concorre,'.') end as nm_marca,
    case when isnull(cast(pc.ds_produto_concorrente as varchar),'') = '' then '.' else isnull(cast(pc.ds_produto_concorrente as varchar),'.') end as nm_observacao
  from
    Produto_Concorrente pc 	left outer join 
    Produto		p  	on pc.cd_produto = p.cd_produto
  where
    pc.cd_concorrente = @cd_concorrente and
    isnull(p.nm_fantasia_produto,'')    like case when isnull(@nm_fantasia_produto,'') <> '' then @nm_fantasia_produto + '%' else isnull(p.nm_fantasia_produto,'') end and
    isnull(pc.cd_produto_concorrente,'') like case when isnull(@nm_fantasia_concorrente,'') <> '' then @nm_fantasia_concorrente + '%' else isnull(pc.cd_produto_concorrente,'') end and
    isnull(pc.nm_fantasia_prod_concorre,'') like case when isnull(@nm_produto_codigo_concorrente,'') <> '' then @nm_produto_codigo_concorrente + '%' else isnull(pc.nm_fantasia_prod_concorre,'') end 
  order by
    3


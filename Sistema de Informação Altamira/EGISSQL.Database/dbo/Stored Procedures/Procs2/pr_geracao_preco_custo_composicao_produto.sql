
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_preco_custo_composicao_produto
-------------------------------------------------------------------------------
--pr_geracao_preco_custo_composicao_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Geração do Preço de Custo da Composição
--Data             : 01/05/2007
--Alteração        : 22.08.2007
------------------------------------------------------------------------------
create procedure pr_geracao_preco_custo_composicao_produto
@ic_parametro int = 0,
@cd_produto   int = 0,
@cd_usuario   int = 0

as

------------------------------------------------------------------------------
--Geração do Preço de Custo do Produto Principal
------------------------------------------------------------------------------
if @ic_parametro=1
begin
  --drop table #aux
  --drop table #custocomposicao
  --select * from produto_composicao

  select
    c.cd_produto_pai,
    c.cd_produto,
    isnull(qt_produto_composicao,0) * isnull(pc.vl_custo_produto ,0)  as vl_custo_produto, 
    isnull(qt_produto_composicao,0) * isnull(pc.vl_custo_comissao ,0) as vl_custo_comissao
  into
    #aux
  from
    produto_composicao c        with (nolock)
    inner join produto_custo pc with (nolock) on pc.cd_produto = c.cd_produto
  where
   c.cd_produto_pai = case when @cd_produto = 0 then c.cd_produto_pai else @cd_produto end
  order by
   c.cd_produto_pai, 
   c.cd_produto

  --select * from #aux

  select
    cd_produto_pai                    as cd_produto,
    sum(isnull(vl_custo_produto,0))   as vl_custo_produto,
    sum(isnull(vl_custo_comissao,0))  as vl_custo_comissao
  into
    #custocomposicao
  from
    #aux 
  group by
    cd_produto_pai

  --select * from #custocomposicao

  update
    produto_custo
  set
    cd_usuario        = @cd_usuario,
    dt_usuario        = getdate(),
    vl_custo_produto  = a.vl_custo_produto,
    vl_custo_comissao = a.vl_custo_comissao
  from
    produto_custo p with (nolock)
    inner join #custocomposicao a on a.cd_produto = p.cd_produto

end

------------------------------------------------------------------------------
--Consulta
------------------------------------------------------------------------------
--select * from produto_composicao

if @ic_parametro = 2
begin

  select
    p.cd_produto,
    p.nm_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    pc.cd_produto_pai,
    pc.cd_produto                                as cd_produto_composicao,
    pc.cd_item_produto,
    pcc.cd_mascara_produto                       as codigoProduto,
    pcc.nm_fantasia_produto                      as fantasiaProduto,
    pcc.nm_produto                               as descricaoProduto,
    pc.qt_produto_composicao,
    pcu.vl_custo_produto,
    isnull(pc.qt_produto_composicao,0) * 
    isnull(pcu.vl_custo_produto,    0)           as vl_custo_total,
    pcu.vl_custo_comissao, 
    isnull(pc.qt_produto_composicao,0) * 
    isnull(pcu.vl_custo_comissao,   0)           as vl_custo_total_comissao

  from
   Produto p  with (nolock)
   inner join produto_composicao pc  on pc.cd_produto_pai = p.cd_produto
   inner join produto_custo      pcu on pcu.cd_produto    = p.cd_produto
   inner join produto            pcc on pcc.cd_produto    = pc.cd_produto
  where
    p.cd_produto = case when @cd_produto = 0 then p.cd_produto else @cd_produto end


end



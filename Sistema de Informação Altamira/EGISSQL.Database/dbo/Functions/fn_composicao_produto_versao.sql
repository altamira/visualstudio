CREATE FUNCTION fn_composicao_produto_versao (@cd_produto_parametro int, @cd_versao_produto_parametro int)
RETURNS @Composicao_Produto TABLE 
	(cd_produto_pai int, 
	 cd_produto int,
         qt_produto_composicao float,
         cd_fase_produto int,
         cd_ordem_produto_comp int,
         nm_fantasia_produto varchar(30))
AS
BEGIN

  declare @TmpArvorePai table
  (ProdutoPaiComp int null,
   IdProdutoComp int null,       
   CodigoProduto int null,
   NomeFantasia varchar(30) null,
   QtdeProdutoComp float null,
   NomeFantasiaComp varchar(30) null,
   DescricaoComp varchar(60) null,
   MascaraComp varchar(30) null,
   cd_fase_produto int null,
   cd_ordem_produto_comp int null,
   cd_versao_produto_comp int null,
   cd_unidade_medida int null,
   qt_leadtime float null,
   qt_leadtime_compra float null,
   cd_grupo_produto int null,
   cd_versao_produto int null)

  declare @TmpArvoreFinal table
  (ProdutoPaiComp int null,
   IdProdutoComp int null,       
   CodigoProduto int null,
   NomeFantasia varchar(30) null,
   QtdeProdutoComp float null,
   NomeFantasiaComp varchar(30) null,
   DescricaoComp varchar(60) null,
   MascaraComp varchar(30) null,
   cd_fase_produto int null,
   cd_ordem_produto_comp int null,
   cd_versao_produto_comp int null,
   cd_unidade_medida int null,
   qt_leadtime float null,
   qt_leadtime_compra float null,
   cd_grupo_produto int null,
   cd_versao_produto int null)

insert into @TmpArvorePai
select
  pc.cd_produto_pai                   as 'ProdutoPaiComp',
  pc.cd_item_produto                  as 'IdProdutoComp',       
  pc.cd_produto                       as 'CodigoProduto',
  p.nm_fantasia_produto               as 'NomeFantasia',
  pc.qt_produto_composicao            as 'QtdeProdutoComp',
  isnull(c.nm_fantasia_produto,' ')   as 'NomeFantasiaComp',
  isnull(c.nm_produto,' ')            as 'DescricaoComp',
  isnull(dbo.fn_mascara_produto(c.cd_produto),' ')    as 'MascaraComp',
  IsNull(pc.cd_fase_produto,0)        as 'cd_fase_produto',
  IsNull(pc.cd_ordem_produto_comp,0)  as 'cd_ordem_produto_comp',
  IsNull(pc.cd_versao_produto_comp,0) as 'cd_versao_produto_comp',
  p.cd_unidade_medida                 as 'cd_unidade_medida',
  p.qt_leadtime_produto               as 'qt_leadtime',
  p.qt_leadtime_compra                as 'qt_leadtime_compra',
  p.cd_grupo_produto                  as 'cd_grupo_produto',
  IsNull(pc.cd_versao_produto,0)      as 'cd_versao_produto'
from
  Produto p
left join Produto_Composicao pc on 
  p.cd_produto = pc.cd_produto_pai
left join Produto c on 
  pc.cd_produto = c.cd_produto
where
  (p.cd_produto = @cd_produto_parametro) and
  (pc.cd_versao_produto_comp = @cd_versao_produto_parametro)


insert into @TmpArvoreFinal
Select
  p.cd_produto                       as 'ProdutoPaiComp',
  0			             as 'IdProdutoComp',       
  p.cd_produto                       as 'CodigoProduto',
  p.nm_fantasia_produto              as 'NomeFantasia',
  cast(1.0 as float)	             as 'QtdeProdutoComp',
  isnull(p.nm_fantasia_produto,' ')  as 'NomeFantasiaComp',
  isnull(p.nm_produto,' ')           as 'DescricaoComp',
  isnull(dbo.fn_mascara_produto(p.cd_produto),' ')   as 'MascaraComp',
  0				     as 'cd_fase_produto',
  0                                  as 'cd_ordem_produto_comp',
  @cd_versao_produto_parametro	     as 'cd_versao_produto_comp',
  p.cd_unidade_medida                as 'cd_unidade_medida',
  p.qt_leadtime_produto              as 'qt_leadtime',
  p.qt_leadtime_compra               as 'qt_leadtime_compra',
  p.cd_grupo_produto                 as 'cd_grupo_produto',
  @cd_versao_produto_parametro	     as 'cd_versao_produto'
from
  Produto p 
where 
  p.cd_produto = @cd_produto_parametro

insert into @TmpArvoreFinal
select * from @TmpArvorePai


-- Variáveis auxiliares no loop para buscar todas as árvores abaixo da principal
declare @cd_produto int
declare @cd_produto_pai int
declare @cd_item_produto int
declare @nm_fantasia_filho char(30)
declare @cd_versao_produto int

while exists (Select codigoproduto from @TmpArvorePai)
begin
  select top 1 
    @cd_produto            = isnull(codigoproduto,0),
    @cd_item_produto       = isnull(idprodutocomp,0),
    @nm_fantasia_filho     = IsNull(nomefantasiacomp,''),
    @cd_versao_produto     = IsNull(cd_versao_produto_comp,0)
  from @TmpArvorePai

  insert into @TmpArvoreFinal
  select
    a.cd_produto_pai                   as ProdutoPaiComp,
    a.cd_item_produto                  as IdProdutoComp,
    a.cd_produto                       as CodigoProduto,
    b.nm_fantasia_produto              as NomeFantasia,
    isnull(a.qt_produto_composicao,0)  as QtdeProdutoComp,
    c.nm_fantasia_produto              as NomeFantasiaComp,
    c.nm_produto                       as DescricaoComp,
    IsNull(dbo.fn_mascara_produto(c.cd_produto),' ')   as MascaraComp,
    IsNull(a.cd_fase_produto,0)        as cd_fase_produto,
    IsNull(a.cd_ordem_produto_comp,0)  as cd_ordem_produto_comp,
    IsNull(a.cd_versao_produto_comp,0) as cd_versao_produto_comp,
    IsNull(b.cd_unidade_medida,0)      as cd_unidade_medida,
    isnull(c.qt_leadtime_produto,0)    as qt_leadtime,
    isnull(c.qt_leadtime_compra,0)     as qt_leadtime_compra,
    b.cd_grupo_produto                 as cd_grupo_produto,
    IsNull(a.cd_versao_produto,0)      as cd_versao_produto
  from Produto_Composicao a
  left join Produto b on 
    a.cd_produto_pai = b.cd_produto
  left join Produto c on 
    a.cd_produto = c.cd_produto
  where 
    (a.cd_produto_pai = @cd_produto) and
    ((a.cd_versao_produto_comp = @cd_Versao_produto) or
     (isnull(@cd_versao_produto,0) = 0))

  -- Significa que ele é pai.
  if exists (Select cd_produto 
             from produto_composicao 
             where 
               cd_produto_pai=@cd_produto and
               ((cd_versao_produto_comp = @cd_Versao_produto) or
                (isnull(@cd_versao_produto,0) = 0)))
  begin
    insert into @TmpArvorePai
    select
      a.cd_produto_pai                   as 'ProdutoPaiComp',
      a.cd_item_produto                  as 'IdProdutoComp',       
      a.cd_produto                       as 'CodigoProduto',
      b.nm_fantasia_produto              as 'NomeFantasia',
      isnull(a.qt_produto_composicao,0)  as 'QtdeProdutoComp',
      c.nm_fantasia_produto              as 'NomeFantasiaComp',
      c.nm_produto                       as 'DescricaoComp',
      IsNull(dbo.fn_mascara_produto(c.cd_produto),' ')   as 'MascaraComp',
      IsNull(a.cd_fase_produto,0)        as 'cd_fase_produto',
      IsNull(a.cd_ordem_produto_comp,0)  as 'cd_ordem_produto_comp',
      IsNull(a.cd_versao_produto_comp,0) as 'cd_versao_produto_comp',
      IsNull(b.cd_unidade_medida,0)      as 'cd_unidade_medida',
      isnull(c.qt_leadtime_produto,0)    as 'qt_leadtime',
      isnull(c.qt_leadtime_compra,0)     as 'qt_leadtime_compra',
      b.cd_grupo_produto                 as 'cd_grupo_produto',
      a.cd_versao_produto                as 'cd_versao_produto' 
    from Produto_Composicao a
    left join Produto b on 
      a.cd_produto_pai = b.cd_produto
    left join Produto c on 
      a.cd_produto = c.cd_produto
    where 
      (a.cd_produto_pai    = @cd_produto) and
      ((a.cd_versao_produto_comp = @cd_Versao_produto) or
       (isnull(@cd_versao_produto,0) = 0)) 
  end

  delete from @TmpArvorePai where CodigoProduto = @cd_produto      
end

insert into @Composicao_Produto
  select 
    ProdutoPaiComp, 
    codigoproduto,
    QtdeProdutoComp,
    cd_fase_produto,
    cd_ordem_produto_comp,
    NomeFantasiaComp
  from @TmpArvoreFinal f
  order by 
    ProdutoPaiComp,
    cd_ordem_produto_comp
  RETURN
END



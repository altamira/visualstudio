

CREATE PROCEDURE pr_consulta_produto_composicao_ti

@nm_fantasia_produto char(30)

as

Select
  b.cd_produto            as 'CodigoProduto',
--  a.cd_produto_composicao as 'CodigoProdutoComp',
  a.cd_item_produto       as 'IdProdutoComp',       
  a.cd_produto_pai        as 'ProdutoPaiComp',
  a.qt_produto_composicao as 'QtdeProdutoComp',
  isnull(c.nm_fantasia_produto,' ') as 'NomeFantasiaComp',
  isnull(c.nm_produto,' ')          as 'DescricaoComp',
  isnull(c.cd_mascara_produto,' ')  as 'MascaraComp',
  b.nm_fantasia_produto   as 'NomeFantasia',
  b.cd_unidade_medida     as 'CodUnidade'

-------
into #TmpArvorePai
-------
from
  Produto b

Left Join Produto_Composicao a
On b.cd_produto = a.cd_produto

Left Join Produto c
On a.cd_produto = c.cd_produto

where b.nm_fantasia_produto = @nm_fantasia_produto

-- Tabela auxiliar para guardar todas as árvores filho

Select
  b.cd_produto            as 'CodigoProduto',
--  a.cd_produto_composicao as 'CodigoProdutoComp',
  a.cd_item_produto       as 'IdProdutoComp',       
  a.cd_produto_pai        as 'ProdutoPaiComp',
  a.qt_produto_composicao as 'QtdeProdutoComp',
  isnull(b.nm_fantasia_produto,' ') as 'NomeFantasiaComp',
  isnull(b.nm_produto,' ')          as 'DescricaoComp',
  isnull(b.cd_mascara_produto,' ')  as 'MascaraComp',
  b.nm_fantasia_produto   as 'NomeFantasia',
  b.cd_unidade_medida     as 'CodUnidade'

into #TmpArvoreFinal
from
  Produto b

Left Join Produto_Composicao a
On b.cd_produto = a.cd_produto

-- Para não pegar nada mesmo...
where b.cd_produto = 0


insert into #TmpArvoreFinal
select * from #TmpArvorePai


-- Variáveis auxiliares no loop para buscar todas as árvores abaixo da principal

declare @cd_produto int
declare @cd_produto_composicao int
declare @cd_item_produto int
declare @nm_fantasia_filho char(30)

while Exists (Select codigoproduto from #TmpArvorePai)
begin

   select @cd_produto            = isnull(codigoproduto,0),
--          @cd_produto_composicao = isnull(codigoprodutocomp,0),
          @cd_item_produto       = isnull(idprodutocomp,0),
          @nm_fantasia_filho     = nomefantasiacomp

   from #TmpArvorePai

   if @cd_produto_composicao <> 0
   begin

     insert into #TmpArvoreFinal

     Select
       a.cd_produto            as 'CodigoProduto',
--       a.cd_produto_composicao as 'CodigoProdutoComp',
       a.cd_item_produto       as 'IdProdutoComp',       
       a.cd_produto_pai        as 'ProdutoPaiComp',
       a.qt_produto_composicao as 'QtdeProdutoComp',
       b.nm_fantasia_produto   as 'NomeFantasiaComp',
       b.nm_produto            as 'DescricaoComp',
       b.cd_mascara_produto    as 'MascaraComp',
       c.nm_fantasia_produto   as 'NomeFantasia',
       b.cd_unidade_medida     as 'CodUnidade'
     from
       Produto_Composicao a
     Left Join Produto b
     On a.cd_produto = b.cd_produto
     Left Join Produto c
     On a.cd_produto = c.cd_produto

     where c.nm_fantasia_produto = @nm_fantasia_filho

     if Exists (Select cd_produto from produto_composicao where cd_produto=@cd_produto_composicao)
     begin

       insert into #TmpArvorePai

       Select
         a.cd_produto            as 'CodigoProduto',
--         a.cd_produto_composicao as 'CodigoProdutoComp',
         a.cd_item_produto       as 'IdProdutoComp',       
         a.cd_produto_pai        as 'ProdutoPaiComp',
         a.qt_produto_composicao as 'QtdeProdutoComp',
         b.nm_fantasia_produto   as 'NomeFantasiaComp',
         b.nm_produto            as 'DescricaoComp',
         b.cd_mascara_produto    as 'MascaraComp',
         c.nm_fantasia_produto   as 'NomeFantasia',
         b.cd_unidade_medida     as 'CodUnidade'
       from
         Produto_Composicao a
       Left Join Produto b
       On a.cd_produto = b.cd_produto
       Left Join Produto c
       On a.cd_produto = c.cd_produto

       where c.nm_fantasia_produto = @nm_fantasia_filho

     end

   end

   -- Apaga Registro da Tabela Temporária    
   delete from 
     #TmpArvorePai
   where
     isnull(codigoproduto,0)     = @cd_produto and
--     isnull(codigoprodutocomp,0) = @cd_produto_composicao and
     isnull(idprodutocomp,0)     = @cd_item_produto

end

select a.*,
       b.sg_unidade_medida 
from #TmpArvoreFinal a,
     Unidade_Medida b
where a.CodUnidade *= b.cd_unidade_medida



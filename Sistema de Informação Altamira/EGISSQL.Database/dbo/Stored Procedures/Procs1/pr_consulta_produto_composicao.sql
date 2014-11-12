
CREATE PROCEDURE pr_consulta_produto_composicao
------------------------------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(s): Lucio Vanderlei
--Banco de Dados: SapSQL
--Objetivo: Consultar Produtos com Composição (e seus "filhos")
--Data       : 26/02/2002
--           :    06/2002 - Gbs
--Atualizado : 19/07/2002 - Sandro / Lucio
--           : 07/03/2003 - Daniel C. Neto / Johnny
--             03/06/2003 - Colocado função IsNull
--                          em todas as fases de produto - Daniel C. Neto.
--             07.05.2007 - Verificação - Carlos Fernandes
--             14.08.2007 - Novos Atributos - Carlos Fernandes.
-- 04.01.2007 - Processo Padrão - Carlos Fernandes 
-- 28.09.2009 - Multiplicação pela Quantidade - Carlos Fernandes
-- 15.04.2010 - Marca do Produto - Carlos Fernandes/Márcio
------------------------------------------------------------------------------------------------------
@nm_fantasia_produto char(30),
@Versao              int   = 0,
@qt_produto          float = 1

as

  if @versao = 0 or @versao is null
  begin
    --select * from produto
    select top 1
      @versao = isnull(p.cd_versao_produto,1)
    from
      produto p with (nolock) 
    where
      p.nm_fantasia_produto = @nm_fantasia_produto

  end

  --select * from produto_composicao

  --Seleciona o produto Pai

  Select
    pc.cd_produto_pai                                   as 'ProdutoPaiComp',
    pc.cd_item_produto                                  as 'IdProdutoComp',       
    pc.cd_produto                                       as 'CodigoProduto',
    p.nm_fantasia_produto                               as 'NomeFantasia',
    pc.qt_produto_composicao                            as 'QtdeProdutoComp',
    isnull(c.nm_fantasia_produto,' ')                   as 'NomeFantasiaComp',
    isnull(c.nm_produto,' ')                            as 'DescricaoComp',
    isnull(dbo.fn_mascara_produto(c.cd_produto),' ')    as 'MascaraComp',
    IsNull(pc.cd_fase_produto,0)        as 'cd_fase_produto',
    IsNull(pc.cd_ordem_produto_comp,0)  as 'cd_ordem_produto_comp',
    IsNull(pc.cd_versao_produto_comp,0) as 'cd_versao_produto_comp',
    c.cd_unidade_medida                 as 'cd_unidade_medida',
    p.qt_leadtime_produto               as 'qt_leadtime',
    p.qt_leadtime_compra                as 'qt_leadtime_compra',
    p.cd_grupo_produto                  as 'cd_grupo_produto',
    IsNull(pc.cd_versao_produto,0)      as 'cd_versao_produto',
    pc.qt_peso_liquido_produto,
    pc.qt_peso_bruto_produto
  into #TmpArvorePai
  from  
    Produto p                        with (nolock) 
    Left Join  Produto_Composicao pc with (nolock) On p.cd_produto = pc.cd_produto_pai  
    Left Join  Produto c             with (nolock) On pc.cd_produto = c.cd_produto  

  where (p.nm_fantasia_produto     = @nm_fantasia_produto) and
        (pc.cd_versao_produto_comp = @Versao)
  
  --select * from #TmpArvorePai
  -- Tabela auxiliar para guardar todas as árvores filho

  Select
    p.cd_produto                       as 'ProdutoPaiComp',
    0			               as 'IdProdutoComp',       
    p.cd_produto                       as 'CodigoProduto',
    p.nm_fantasia_produto              as 'NomeFantasia',
    cast(1.0 as float)	               as 'QtdeProdutoComp',
    isnull(p.nm_fantasia_produto,' ')  as 'NomeFantasiaComp',
    isnull(p.nm_produto,' ')           as 'DescricaoComp',
    isnull(dbo.fn_mascara_produto(p.cd_produto),' ') 
                                       as 'MascaraComp',
    0				       as 'cd_fase_produto',
    0                                  as 'cd_ordem_produto_comp',
    @Versao			       as 'cd_versao_produto_comp',
    p.cd_unidade_medida                as 'cd_unidade_medida',
    p.qt_leadtime_produto              as 'qt_leadtime',
    p.qt_leadtime_compra               as 'qt_leadtime_compra',
    p.cd_grupo_produto                 as 'cd_grupo_produto',
    @Versao			       as 'cd_versao_produto',
    p.qt_peso_liquido                  as 'qt_peso_liquido_produto',
    p.qt_peso_bruto                    as 'qt_peso_bruto_produto'

  into #TmpArvoreFinal
  from
    Produto p 
  where 
    p.nm_fantasia_produto = @nm_fantasia_produto
  
  --select * from produto
  --select * from #TmpArvoreFinal

  insert into #TmpArvoreFinal
    select * from #TmpArvorePai
  
  -- Variáveis auxiliares no loop para buscar todas as árvores abaixo da principal
  
  declare @cd_produto         int
  declare @cd_produto_pai     int
  declare @cd_item_produto    int
  declare @nm_fantasia_filho  char(30)
  declare @cd_versao_produto  int
  
  while Exists (Select codigoproduto from #TmpArvorePai)
  begin
  --select * from #tmparvorepai
    select top 1 
      @cd_produto            = isnull(codigoproduto,0),
      @cd_item_produto       = isnull(idprodutocomp,0),
      @nm_fantasia_filho     = IsNull(nomefantasiacomp,''),
      @cd_versao_produto     = IsNull(cd_versao_produto_comp,0)
    from #TmpArvorePai

    insert into #TmpArvoreFinal
    Select
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
      IsNull(a.cd_versao_produto,0)      as cd_versao_produto,
      a.qt_peso_liquido_produto,
      a.qt_peso_bruto_produto

    from 
      Produto_Composicao a  with (nolock)   
      Left Join Produto b   with (nolock) On a.cd_produto_pai = b.cd_produto
      Left Join Produto c   with (nolock) On a.cd_produto = c.cd_produto    
    where (a.cd_produto_pai = @cd_produto) and
         ( (a.cd_versao_produto_comp = @cd_Versao_produto) or
           (isnull(@cd_versao_produto,0) = 0)
         )
    

--    print('Passou!')
--    print('Código produto: ' + str(@cd_produto))
--    print('Item produto: ' + str(@cd_item_produto))
--    print('Fantasia produto: ' + @nm_fantasia_filho)
--    print('Versão: ' + str(@cd_versao_produto))

    -- Significa que ele é pai.
    if Exists (Select cd_produto 
              from produto_composicao with (nolock)   
              where cd_produto_pai=@cd_produto and
              ( (cd_versao_produto_comp = @cd_Versao_produto) or
                (isnull(@cd_versao_produto,0) = 0)
              ) 
             )
    begin
      insert into #TmpArvorePai
      Select
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
        a.cd_versao_produto                as 'cd_versao_produto',
        a.qt_peso_liquido_produto,
        a.qt_peso_bruto_produto
 
      from 
        Produto_Composicao a with (nolock) 
        Left Join 
        Produto b
          On a.cd_produto_pai = b.cd_produto
          Left Join 
        Produto c
          On a.cd_produto = c.cd_produto
      where (a.cd_produto_pai    = @cd_produto) and
             ( (a.cd_versao_produto_comp = @cd_Versao_produto) or
               (isnull(@cd_versao_produto,0) = 0)
             ) 
    end

    delete from #TmpArvorePai where CodigoProduto = @cd_produto
    -- Apaga Registro da Tabela Temporária    
     /*delete from 
       #TmpArvorePai
     where
       isnull(codigoproduto,0)  = @cd_produto and
       isnull(produtopaicomp,0) = @cd_produto_pai and
       isnull(idprodutocomp,0)  = @cd_item_produto */       
  end

  select
--       f.*, 
      f.ProdutoPaiComp,
      f.IdProdutoComp,
      f.CodigoProduto,
      f.NomeFantasia,
      f.QtdeProdutoComp * ( case when isnull(@qt_produto,0)=0 then 1 else @qt_produto end ) as QtdeProdutoComp,
      f.NomeFantasiaComp,
      f.DescricaoComp,
      f.MascaraComp,
      f.cd_fase_produto,
      f.cd_ordem_produto_comp,
      f.cd_versao_produto_comp,
      f.cd_unidade_medida,
      f.qt_leadtime,
      f.qt_leadtime_compra,
      f.cd_grupo_produto,
      f.cd_versao_produto,
      f.qt_peso_liquido_produto,
      f.qt_peso_bruto_produto,

       f.codigoproduto                  as 'Cd_Produto_Composicao',
       isnull (u.sg_unidade_medida,'')  as sg_unidade_medida,
       fase.sg_fase_produto             as nm_fase_produto,

       isnull(pop.cd_processo_padrao,0) as cd_processo_padrao,
       case when isnull(p.nm_marca_produto,'')<>'' then
         p.nm_marca_produto
       else
         mp.nm_marca_produto
       end                              as nm_marca_produto

  from 
    #TmpArvoreFinal f
      left join 
    Unidade_medida u
      on f.cd_unidade_medida = u.cd_unidade_medida
      Left Join 
    Fase_Produto fase
      On f.cd_Fase_produto = Fase.cd_fase_produto
      Left Join produto_producao pop with (nolock) on pop.cd_produto        = f.CodigoProduto
      Left Join Produto          p   with (nolock) on p.cd_produto          = f.codigoProduto
      Left Join Marca_Produto    mp  with (nolock) on mp.cd_marca_produto   = p.cd_marca_produto
--select * from produto_producao

  order by 
    f.ProdutoPaiComp,
    f.cd_ordem_produto_comp

  drop table #TmpArvoreFinal
  drop table #TmpArvorePai


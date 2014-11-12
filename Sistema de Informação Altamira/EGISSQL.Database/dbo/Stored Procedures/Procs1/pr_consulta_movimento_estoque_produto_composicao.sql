
CREATE PROCEDURE pr_consulta_movimento_estoque_produto_composicao
-----------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	             2001
-----------------------------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Eduardo
--Banco de Dados	: EgisSQL
--Objetivo		: Retornar os produtos que compõem outro produto
--Data			: 19/06/2003
--Alteração		: 04.07.2003 - Adicionado a Versão Padrão ao filtro para que não se traga informações a mais - DUELA
--                      : 04/08/2003 - Adicionado campos CD_FASE_PRODUTO e NM_FASE_PRODUTO
--                        08/08/2003 - Colocado possibilidade de campos nulos na tabela temporária - Daniel C. Neto.
--                        15/10/2003 - Inclusão do campo qt_produto_calc utilizado na baixa e reserva 
--                                     do Processo Produção SEP - Daniel Duela 
--Alteração             : 08.04.2004 - Foi criado um parametro na stored procedure para apresentar o produto pai
--                      : 26/01/2005 - Checagem da Fase do Produto - Carlos
--                      : 18/01/2006 - Inclusão do campo nm_produto_comp que é a placa correspondente : Lucio 
--                      : 08.07.2007 - Verificação da Ordem do Componente - Carlos Fernandes
--                      : 11.10.2007 - Mostrar somente os produtos Principais sem a Composição - Carlos Fernandes
-- 07.02.2008 - Travamento da composição completa - Carlos Fernandes
-- 04.08.2009 - Carlos Fernandes - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------------
@cd_produto               int     = 0,
@qt_produto               float   = 1,
@ic_apresenta_produto_pai char(1) ='N',
@cd_fase_produto_pai      int     = 0,
@ic_composicao_completa	  char(1) ='S',
@cd_versao_produto        int     = 0

as

  if isnull(@ic_composicao_completa,'') = ''
  begin
    set @ic_composicao_completa = 'S' 
  end

  --Define parametros default´s

  if ( @qt_produto is null )
     set @qt_produto =1 
  
  if ( @ic_apresenta_produto_pai is null )
     set @ic_apresenta_produto_pai = 'N' 
  
  if ( @cd_fase_produto_pai is null )
     set @cd_fase_produto_pai = 0

  if isNull(@cd_versao_produto,0) = 0
  begin
    Select 
      top 1 @cd_versao_produto = isnull(cd_versao_produto,0) 
    from 
      produto with (nolock, index(pk_produto)) 
    where cd_produto = @cd_produto
  end

  -- criar a tabela temporária na memória

  create table #tmpArvoreProdutoComposicao
  ( cd_produto_pai        int Null,
    cd_item_produto       int Null,
    cd_produto            int Null,
    cd_fase_produto       int Null,   
    qt_produto_composicao float Null, 
    qt_produto_calc       float Null,
    verificada            char(1) Null,
    cd_placa              int Null,
    nm_produto_comp       varchar(40) Null)

  -- declarar as variáveis
  declare @lsair_loop      char(1)

  declare @ncd_produto_pai int
  declare @ncd_produto     int
  declare @nqt_produto     float

  -- inserir o registro do produto principal
  insert into #tmpArvoreProdutoComposicao
  values ( @cd_produto, 0, @cd_produto, 0, 0, @qt_produto, 'S', 0, '' )

--  select * from #tmpArvoreProdutoComposicao

  -- carregar os filhos do produto pai-de-todos 

  insert into
     #tmpArvoreProdutoComposicao
  select
     pc.cd_produto_pai,
     isnull(pc.cd_ordem_produto,pc.cd_item_produto),
     pc.cd_produto,
     pc.cd_fase_produto,
     pc.qt_produto_composicao,
    (pc.qt_produto_composicao * @qt_produto),
     'N' as verificada,
     b.cd_placa,
     pc.nm_produto_comp
  from
     produto_composicao pc   with (nolock)
     inner join produto p    with (nolock) on p.cd_produto       = pc.cd_produto_pai
     left outer join placa b with (nolock) on pc.nm_produto_comp = b.sg_placa 
  where
     pc.cd_produto_pai         = @cd_produto          and
     pc.cd_versao_produto_comp = @cd_versao_produto   and
     p.cd_versao_produto       = pc.cd_versao_produto_comp

--select * from produto
     
  order by
     pc.cd_ordem_produto_comp

--  select * from #tmpArvoreProdutoComposicao


--select * from produto_composicao


  if isnull(@ic_composicao_completa,'S') <> 'N' 
  begin

    --select * from #tmpArvoreProdutoComposicao

    -- variável que controla o loop
    set @lsair_loop = 'N'
  
    -- rodar inserindo os filhos dos filhos e
    -- setando seu status como verificado
    while ( @lsair_loop = 'N' ) 
    begin
       declare crFilhos cursor for
          select cd_produto_pai, 
                 cd_produto, 
                 qt_produto_calc
          from 
                 #tmpArvoreProdutoComposicao
          where 
                 verificada = 'N'
  
       open crFilhos
  
       FETCH NEXT FROM crFilhos
          INTO @ncd_produto_pai,
               @ncd_produto,
               @nqt_produto
  
       set @cd_versao_produto=(select isnull(cd_versao_produto,0) as cd_versao_produto
                               from 
                                 produto 
                               where 
                                 cd_produto=@cd_produto)
  
       if @@FETCH_STATUS = 0 
       begin
  
          -- inserir na tabela temporária os filhos do produto atual
  
          insert into
             #tmpArvoreProdutoComposicao
          select
             a.cd_produto_pai,
             isnull(a.cd_ordem_produto,a.cd_item_produto),
             a.cd_produto,
             a.cd_fase_produto,
             a.qt_produto_composicao,
            (a.qt_produto_composicao * @nqt_produto),
             'N' as verificada,
             b.cd_placa,
             a.nm_produto_comp
          from
             produto_composicao a
             left outer join placa b on a.nm_produto_comp = b.sg_placa
             
          where
             a.cd_produto_pai   = @ncd_produto and
             a.cd_produto       not in ( select cd_produto from #tmpArvoreProdutoComposicao )
             --and a.verificada       = 'N'
             
          order by
             a.cd_ordem_produto_comp
  
          -- setar o status deste registro como verificado

          update #tmpArvoreProdutoComposicao
          set verificada = 'S'
          where cd_produto_pai = @ncd_produto_pai and
                cd_produto     = @ncd_produto
  
       end
       else begin
          set @lsair_loop = 'S'
       end
  
       close crFilhos
       deallocate crFilhos

    end

  end

  --Verifica se apresenta o produto pai

  if ( @ic_apresenta_produto_pai = 'S' )
  begin

    select
       0                           as cd_produto_pai,
       0                           as cd_item_produto,
       @cd_produto                 as cd_produto,
       @cd_fase_produto_pai        as cd_fase_produto,
       1                           as qt_produto_composicao,
       0                           as qt_produto_calc,
       0                           as cd_placa,
       ''                          as nm_produto_comp,
       p.nm_fantasia_produto,
       f.nm_fase_produto,
       f.sg_fase_produto
    from     
       produto p , 
       fase_produto f
    where
      ( p.cd_produto     = @cd_produto ) and
      (f.cd_fase_produto = @cd_fase_produto_pai)

    union

    select
       tapc.cd_produto_pai,
       tapc.cd_item_produto,
       tapc.cd_produto,
       tapc.cd_fase_produto,
       tapc.qt_produto_composicao,
       tapc.qt_produto_calc,
       tapc.cd_placa,
       tapc.nm_produto_comp,
       p.nm_fantasia_produto,
       f.nm_fase_produto,
       f.sg_fase_produto
    from     
       #tmpArvoreProdutoComposicao tapc,
       produto p, fase_produto f
    where
      ( p.cd_produto     = tapc.cd_produto ) and
      (f.cd_fase_produto = tapc.cd_fase_produto) 
    order by tapc.cd_item_produto
  end
  else
    select
       tapc.cd_produto_pai,
       tapc.cd_item_produto,
       tapc.cd_produto,
       tapc.cd_fase_produto,
       tapc.qt_produto_composicao,
       tapc.qt_produto_calc,
       tapc.cd_placa,
       tapc.nm_produto_comp,
       p.nm_fantasia_produto,
       f.nm_fase_produto,
       f.sg_fase_produto
    from     
       #tmpArvoreProdutoComposicao tapc,
       produto p, fase_produto f
    where
      ( p.cd_produto     = tapc.cd_produto ) and
      (f.cd_fase_produto = tapc.cd_fase_produto)
    order by tapc.cd_item_produto

  drop table #tmpArvoreProdutoComposicao


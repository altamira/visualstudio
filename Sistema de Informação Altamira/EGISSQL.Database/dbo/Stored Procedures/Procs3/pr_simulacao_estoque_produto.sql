
CREATE PROCEDURE pr_simulacao_estoque_produto
------------------------------------------------------------------------------------------------------
-- GBS - Global Business Sollution             2003
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto 
--Banco de Dados: EgisSql
--Objetivo   : Fazer simulação de venda de estoque do produto.
--Data       : 06/02/2004
--Atualizado : 23.10.2008
------------------------------------------------------------------------------------------------------

@cd_produto int   = 0,
@qt_produto float = 1

as

declare @cd_fase_produto   int
declare @cd_versao_produto int

--Versao e Fase do Produto
select 
  @cd_fase_produto = isnull(p.cd_fase_produto_baixa,0),
  @cd_versao_produto=isnull(cd_versao_produto,0) 
from
  Produto p with (nolock)
  
where
  p.cd_produto = @cd_produto


  -- criar a tabela temporária na memória

  create table #tmpArvoreProdutoComposicao
  ( cd_produto_pai        int Null,
    cd_item_produto       int Null,
    cd_produto            int Null,
    cd_fase_produto       int Null,   
    qt_produto_composicao float Null, 
    qt_produto_calc       float Null,
    verificada            char(1) Null,
    cd_ordem_produto_comp int )

  -- declarar as variáveis

  declare @lsair_loop char(1)

  declare @ncd_produto_pai int
  declare @ncd_produto     int
  declare @nqt_produto     float

  -- inserir o registro do produto principal
  insert into #tmpArvoreProdutoComposicao
  values ( @cd_produto, 0, @cd_produto, @cd_fase_produto, 0, @qt_produto, 'S',0 )

  -- carregar os filhos do produto pai-de-todos 

  insert into
     #tmpArvoreProdutoComposicao
  select
     cd_produto_pai,
     cd_item_produto,
     cd_produto,
     cd_fase_produto,
     qt_produto_composicao,
     (qt_produto_composicao*@qt_produto),
     'N' as verificada,
     cd_ordem_produto_comp
  from
     produto_composicao pc with (nolock) 
  where
     pc.cd_produto_pai         = @cd_produto and
     pc.cd_versao_produto_comp = @cd_versao_produto

  -- variável que controla o loop
  set @lsair_loop = 'N'

  -- rodar inserindo os filhos dos filhos e
  -- setando seu status como verificado

  while ( @lsair_loop = 'N' ) begin
     declare crFilhos cursor for
        select cd_produto_pai, cd_produto, qt_produto_calc
        from #tmpArvoreProdutoComposicao
        where verificada = 'N'

     open crFilhos

     FETCH NEXT FROM crFilhos
        INTO @ncd_produto_pai,
             @ncd_produto,
             @nqt_produto

     set @cd_versao_produto=(select cd_versao_produto from produto where cd_produto=@cd_produto)

     if @@FETCH_STATUS = 0 begin

        -- inserir na tabela temporária os filhos do produto atual
        insert into
           #tmpArvoreProdutoComposicao
        select
           cd_produto_pai,
           cd_item_produto,
           cd_produto,
           cd_fase_produto,
           qt_produto_composicao,
           (qt_produto_composicao*@nqt_produto),
           'N' as verificada,
           cd_ordem_produto_comp
        from
           produto_composicao with (nolock) 
        where
           cd_produto_pai = @ncd_produto

        -- setar o status deste registro como verificado
        update #tmpArvoreProdutoComposicao
        set verificada = 'S'
        where cd_produto_pai = @ncd_produto_pai and
              cd_produto     = @ncd_produto

     end
     else begin
        set @lsair_loop = 'S'
     end

     close      crFilhos
     deallocate crFilhos

  end

  select
     tapc.cd_produto_pai,
     tapc.cd_item_produto,
     tapc.cd_produto,
     tapc.cd_fase_produto,
     tapc.qt_produto_composicao,
     tapc.qt_produto_calc,
     dbo.fn_mascara_produto(p.cd_produto) as cd_mascara_produto, 
     p.nm_fantasia_produto,
     p.nm_produto,
     f.nm_fase_produto,
     um.sg_unidade_medida,
     ps.qt_saldo_reserva_produto,
     ps.qt_saldo_atual_produto,
     p.qt_peso_liquido, 
     p.qt_peso_bruto,
     ps.qt_req_compra_produto,
     ps.qt_importacao_produto,
     ( select sum(x.qt_planejada_processo) 
       from Processo_Producao x with (nolock) 
       where x.cd_produto = tapc.cd_produto and
             x.cd_status_processo <> 5 and
             x.dt_fimprod_processo is null )  as 'Producao',
     ( select sum(x.qt_comp_processo) 
       from Processo_Producao_Componente x with (nolock) 
       where IsNull(x.ic_estoque_processo,'N') = 'S' and  
             x.cd_produto = tapc.cd_produto )  as 'Processo',
     tapc.cd_ordem_produto_comp

  from
     #tmpArvoreProdutoComposicao tapc 
     left outer join produto p         on ( p.cd_produto      = tapc.cd_produto ) 
     left outer join fase_produto f    on (f.cd_fase_produto  = tapc.cd_fase_produto) 
     left outer JOIN Unidade_Medida um ON p.cd_unidade_medida = um.cd_unidade_medida 
     left outer JOIN Produto_Saldo ps  ON p.cd_produto        = ps.cd_produto and
                                          ps.cd_fase_produto  = tapc.cd_fase_produto 

  order by
    tapc.cd_ordem_produto_comp
 
  drop table #tmpArvoreProdutoComposicao



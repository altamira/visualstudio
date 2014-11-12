
create FUNCTION fn_composicao_produto_codigo
--------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2004
--Stored Procedure	: Microsoft SQL Server                                  2000
--Autor(es)		: Igor Gama
--Banco de Dados	: EGISSQL
--Objetivo		: Retornar os produtos que começam com o Nome código informado
--                        e suas respectivas composições. Não retornará mais de um
--                        registro para o mesmo produto.
--Data			: 10.05.2004
--------------------------------------------------------------------------------
  (@cd_produto int)

RETURNS @Composicao_Produto TABLE 
  ( cd_produto_pai int,
    cd_produto int,
--    cd_processo_padrao int,
--    verificada char(1),
    qt_produto_composicao float,
    cd_fase_produto int,
    ic_estoque char(1),
    nm_fantasia_produto varchar(30))
AS
BEGIN

  -- criar a tabela temporária na memória
  declare @tmpArvoreProdutoComposicao table 
  ( cd_produto_pai int,
    cd_produto int,
    cd_processo_padrao int,
    verificada char(1),
    qt_produto_composicao float,
    cd_fase_produto int,
    ic_estoque char(1) )

  -- declarar as variáveis
  declare @lsair_loop char(1)
  declare @cd_versao_produto int
  declare @ncd_produto_pai int
  declare @ncd_produto int
  declare @ncd_processo_padrao int

  -- Tabela auxiliar com os Processos Lidos
  declare @tmpProcessoLido table 
  ( cd_processo_producao int)

  -- inserir os registros dos produtos principais
  insert into @tmpArvoreProdutoComposicao
    select
      p.cd_produto,
      p.cd_produto,
      pp.cd_processo_padrao,
      'N',
      ppc.qt_comp_processo,
      ppc.cd_fase_produto,
      ppc.ic_estoque_processo
    from
      produto p
        left outer join 
      produto_producao pp
        on pp.cd_produto = p.cd_produto
        left outer join
      processo_producao ppd
        on pp.cd_processo_padrao = ppd.cd_processo_padrao
        left outer join         
      processo_producao_componente ppc
        on ppd.cd_processo = ppc.cd_processo
    where
      p.cd_produto = @cd_produto

  -- variável que controla o loop
  set @lsair_loop = 'N'

  -- rodar inserindo os filhos dos filhos e
  -- setando seu status como verificado
  while ( @lsair_loop = 'N' ) begin

     declare crFilhos cursor for
        select cd_produto_pai, cd_produto, cd_processo_padrao
        from @tmpArvoreProdutoComposicao
        where verificada = 'N'

     open crFilhos

     FETCH NEXT FROM crFilhos
        INTO @ncd_produto_pai,
             @ncd_produto,
             @ncd_processo_padrao

     select 
       @cd_versao_produto = cd_versao_produto 
     from 
       produto 
     where 
       cd_produto = @ncd_produto_pai

     if @@FETCH_STATUS = 0 begin

        -- inserir na tabela temporária os filhos do produto atual
        insert into
           @tmpArvoreProdutoComposicao
        select
           pc.cd_produto_pai,
           pc.cd_produto,         
           pp.cd_processo_padrao,
           'N' as verificada,
           ppc.qt_comp_processo,
           ppc.cd_fase_produto,
           ppc.ic_estoque_processo
        from
           produto_composicao pc
             left outer join 
           produto_producao pp
             on pp.cd_produto = pc.cd_produto
             left outer join
           processo_producao ppd
             on pp.cd_processo_padrao = ppd.cd_processo_padrao
             left outer join         
           processo_producao_componente ppc
             on ppd.cd_processo = ppc.cd_processo
        where
           pc.cd_produto_pai = @ncd_produto and
           pc.cd_versao_produto_comp = @cd_versao_produto

        -- setar o status deste registro como verificado
        update @tmpArvoreProdutoComposicao
        set verificada = 'S'
        where cd_produto_pai = @ncd_produto_pai and
              cd_produto = @ncd_produto

        -- Caso o Processo Padrão já tenha sido processado
        -- não utilizá-lo novamente - ELIAS 22/04/2004
        if (@ncd_processo_padrao not in (select isnull(cd_processo_producao,0) from @tmpProcessoLido))
        begin

          -- inserir na tabela temporária os componentes do Processo Padrão (PAI)
          insert into
             @tmpArvoreProdutoComposicao
          select
            @ncd_produto,
            ppp.cd_produto,
            ppp.cd_processo_padrao,
            'N',
            ppc.qt_comp_processo,
            ppc.cd_fase_produto,
            ppc.ic_estoque_processo
          from
            processo_padrao_produto ppp 
              left outer join    
            processo_producao ppd
              on ppp.cd_processo_padrao = ppd.cd_processo_padrao
              left outer join         
            processo_producao_componente ppc
              on ppd.cd_processo = ppc.cd_processo
          where
            ppp.cd_processo_padrao = @ncd_processo_padrao

          -- Inserindo o Processo Lido para não utilizá-lo
          -- novamente - ELIAS 22/04/2004
          insert into @tmpProcessoLido values (@ncd_processo_padrao)

          -- inserir na tabela temporária os componentes do processo padrão (FILHOS)
          insert into
             @tmpArvoreProdutoComposicao
          select
             @ncd_produto,
             ppp.cd_produto,
             isnull(pp.cd_processo_padrao, ppp.cd_processo_padrao),
             'N',
             ppc.qt_comp_processo,
             ppc.cd_fase_produto,
             ppc.ic_estoque_processo
          from
             processo_padrao_produto ppp
               left outer join
             produto_producao pp
               on ppp.cd_produto = pp.cd_produto
               left outer join
             processo_producao ppd
               on pp.cd_processo_padrao = ppd.cd_processo_padrao
               left outer join         
             processo_producao_componente ppc
               on ppd.cd_processo = ppc.cd_processo
          where
             ppp.cd_processo_padrao in (select 
                                           pp.cd_processo_padrao
                                        from
                                           processo_padrao_produto ppp,
                                           produto_producao pp
                                        where
                                           pp.cd_produto = ppp.cd_produto and
                                           ppp.cd_processo_padrao = @ncd_processo_padrao)

          -- Inserido os Processos Filhos - ELIAS 22/04/2004
          insert into @tmpProcessoLido
          select 
             pp.cd_processo_padrao
          from
             processo_padrao_produto ppp,
             produto_producao pp
          where
             pp.cd_produto = ppp.cd_produto and
             ppp.cd_processo_padrao = @ncd_processo_padrao        

          -- Limpando o Processo Atual Pesquisado - ELIAS 22/04/2004
          set @ncd_processo_padrao = null

        end

     end
     else begin
        set @lsair_loop = 'S'
     end

     close crFilhos
     deallocate crFilhos

  end

  insert into
    @Composicao_Produto    
  select distinct
    tapc.cd_produto_pai,
    tapc.cd_produto,
    tapc.qt_produto_composicao,
    tapc.cd_fase_produto,
    tapc.ic_estoque,
    p.nm_fantasia_produto
  from
     @tmpArvoreProdutoComposicao tapc,
     produto p     
  where
    ( p.cd_produto = tapc.cd_produto )
  group by
    tapc.cd_produto_pai,
    tapc.cd_produto,
    tapc.qt_produto_composicao,
    tapc.cd_fase_produto,
    tapc.ic_estoque,
    p.nm_fantasia_produto

  RETURN
END

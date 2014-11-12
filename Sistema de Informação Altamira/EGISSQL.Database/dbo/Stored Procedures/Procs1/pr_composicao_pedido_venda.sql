

create Procedure pr_composicao_pedido_venda
as

  -- criar a tabela temporária na memória
  declare @tmpComposicao table 
  ( cd_codigo int identity(1,1),
    cd_pedido_venda int, 
    cd_processo int,
    cd_produto_pai int,
    cd_produto int,
    qt_produto_composicao float,    
    qtde_original float,    
    cd_versao_produto int,
    cd_processo_padrao int,
    verificada char(1) )

  declare @tmpProcessoPadrao table
  ( cd_processo_padrao int,
    cd_processo int)

  -- declarar as variáveis
  declare @lsair_loop char(1)
  declare @cd_versao_produto int
  declare @ncd_produto_pai int
  declare @ncd_produto int
  declare @ncd_processo int
  declare @ncd_codigo int
  declare @ncd_pedido_venda int
  declare @ncd_processo_padrao int

  declare @cd_produto int
  declare @nqtd_pai float

  -----------------------------------------------------
  -- Selecionar os Produtos da Carteira de Pedidos
  -----------------------------------------------------

  insert into @tmpComposicao
    ( cd_pedido_venda, 
      cd_processo,
      cd_produto_pai,
      cd_produto,
      qt_produto_composicao,    
      qtde_original,
      cd_versao_produto,
      cd_processo_padrao,
      verificada )      
    select
      pvi.cd_pedido_venda,
      pp.cd_processo,
      0 as cd_produto_pai,
      pvi.cd_produto,
      isnull( pvi.qt_saldo_pedido_venda, 0 ) as 'Qtde',
      1,
      p.cd_versao_produto,
      ppr.cd_processo_padrao,
      'X'
    from
      pedido_venda_item pvi

      left outer join Processo_Producao pp
        on pp.cd_pedido_venda = pvi.cd_pedido_venda and
           pp.cd_item_pedido_venda = pvi.cd_item_pedido_venda

      left outer join Produto p
        on p.cd_produto = pvi.cd_produto

      left outer join produto_producao ppr
        on ppr.cd_produto = p.cd_produto
    where
      pvi.qt_saldo_pedido_venda > 0
      and
      pvi.dt_cancelamento_item is null
      and
      isnull(pvi.ic_sel_fechamento,'N') = 'S' 
      and
      isnull(pvi.cd_produto,0) > 0

      select * from @tmpComposicao

--      and
--      pvi.cd_produto = 24057
--      and
--      pvi.cd_produto = 24034

  -----------------------------------------------------
  -- Rodar colocando os Itens da Composição na lista
  -----------------------------------------------------

  -- variável que controla o loop
  set @lsair_loop = 'N'

  -- rodar inserindo os filhos dos filhos e
  -- setando seu status como verificado
  while ( @lsair_loop = 'N' ) begin

     declare crFilhos cursor for
        select top 1 cd_codigo,
               cd_processo, cd_produto_pai, cd_produto,
               cd_versao_produto, qt_produto_composicao,
               cd_pedido_venda, cd_processo_padrao
        from @tmpComposicao
        where verificada <> 'S'

     open crFilhos


     FETCH NEXT FROM crFilhos
        INTO @ncd_codigo,
             @ncd_processo,
             @ncd_produto_pai,
             @ncd_produto,
             @cd_versao_produto,
             @nqtd_pai,
             @ncd_pedido_venda,
             @ncd_processo_padrao

     if @@FETCH_STATUS = 0 begin

--         print('Produto: '+cast(@ncd_produto as varchar)) 
--         print('Pedido: '+cast(@ncd_pedido_venda as varchar))
--         print('Processo: '+cast(@ncd_processo as varchar))

--         print('Inserindo os Filhos do Produto '+cast(isnull(@ncd_produto,'') as varchar))
--           select
--             @ncd_pedido_venda,
--             @ncd_processo,
--             c.cd_produto_pai,
--             c.cd_produto,
-- 
--             -- Descontar os que já foram reservados pelo Processo 
--             (case when (isnull(pc.ic_estoque_processo,'N') = 'N') 
--                   then (c.qt_produto_composicao * @nqtd_pai)
--                   else 0
--              end), 
--             c.qt_produto_composicao,
-- 
--             c.cd_versao_produto_comp,
--             pp.cd_processo_padrao,
--             'N' as verificada
--           from
--             produto_composicao c
-- 
--             left outer join Processo_Producao_Componente pc
--               on pc.cd_processo = @ncd_processo and
--                  pc.cd_produto = c.cd_produto                 
-- 
--             left outer join produto_producao pp
--               on pp.cd_produto = c.cd_produto
--           where
--             c.cd_produto_pai = @ncd_produto and
--             c.cd_versao_produto_comp = @cd_versao_produto
-- 

        -- inserir na tabela temporária os filhos do produto atual
        insert into @tmpComposicao
          ( cd_pedido_venda,
            cd_processo,
            cd_produto_pai,
            cd_produto,
            qt_produto_composicao,    
            qtde_original,
            cd_versao_produto,
            cd_processo_padrao,
            verificada )      
          select
            @ncd_pedido_venda,
            @ncd_processo,
            c.cd_produto_pai,
            c.cd_produto,

            -- Descontar os que já foram reservados pelo Processo 
            (case when (isnull(pc.ic_estoque_processo,'N') = 'N') 
                  then (c.qt_produto_composicao * @nqtd_pai)
                  else 0
             end), 
            c.qt_produto_composicao,

            c.cd_versao_produto_comp,
            pp.cd_processo_padrao,
            'N' as verificada
          from
            produto_composicao c

            left outer join Processo_Producao_Componente pc
              on pc.cd_processo = @ncd_processo and
                 pc.cd_produto = c.cd_produto                 

            left outer join produto_producao pp
              on pp.cd_produto = c.cd_produto
          where
            c.cd_produto_pai = @ncd_produto and
            c.cd_versao_produto_comp = @cd_versao_produto


        -- inserir na tabela temporária os componentes do processo padrão
        if not exists(select 'x' from @tmpProcessoPadrao where isnull(cd_processo_padrao,0) = isnull(@ncd_processo_padrao,0) and
                                                               isnull(cd_processo,0) = isnull(@ncd_processo,0))
        begin

--         print('Inserindo os Componentes do Processo Padrao '+cast(isnull(@ncd_processo_padrao,'') as varchar)+
--               ' - Processo '+cast(isnull(@ncd_processo,'') as varchar))
-- 
--         select
--             @ncd_processo,
--             @ncd_produto,
--             ppp.cd_produto,
-- 
--             -- Descontar os que já foram reservados pelo Processo 
--             (case when (isnull(pc.ic_estoque_processo,'N') = 'N') 
--                   then (ppp.qt_produto_processo * @nqtd_pai)
--                   else 0
--              end), 
--             ppp.qt_produto_processo,
-- 
--             null,
--             pp.cd_processo_padrao,
--             'N' as verificada
--         from
--           processo_padrao_produto ppp
-- 
--           left outer join Processo_Producao_Componente pc
--             on pc.cd_processo = @ncd_processo and
--                pc.cd_produto = ppp.cd_produto
-- 
--           left outer join produto_producao pp
--              on pp.cd_produto = ppp.cd_produto
--         where
--           ppp.cd_processo_padrao = @ncd_processo_padrao

        insert into @tmpComposicao
          ( cd_processo,
            cd_produto_pai,
            cd_produto,
            qt_produto_composicao,    
            qtde_original,
            cd_versao_produto,
            cd_processo_padrao,
            verificada )
        select
            @ncd_processo,
            @ncd_produto,
            ppp.cd_produto,

            -- Descontar os que já foram reservados pelo Processo 
            (case when (isnull(pc.ic_estoque_processo,'N') = 'N') 
                  then (ppp.qt_produto_processo * @nqtd_pai)
                  else 0
             end), 
            ppp.qt_produto_processo,

            null,
            pp.cd_processo_padrao,
            'N' as verificada
        from
          processo_padrao_produto ppp

          left outer join Processo_Producao_Componente pc
            on pc.cd_processo = @ncd_processo and
               pc.cd_produto = ppp.cd_produto

          left outer join produto_producao pp
             on pp.cd_produto = ppp.cd_produto
        where
          ppp.cd_processo_padrao = @ncd_processo_padrao

        insert into @tmpProcessoPadrao values (@ncd_processo_padrao, @ncd_processo)

        end

        -- setar o status deste registro como verificado
--         print('Código Sequencial: '+cast(@ncd_codigo as varchar))

        update @tmpComposicao
        set qt_produto_composicao = (case when verificada = 'X' then 0 else qt_produto_composicao end),
            verificada = 'S'            
        where cd_codigo = @ncd_codigo


     end
     else begin
        set @lsair_loop = 'S'
     end

     close crFilhos
     deallocate crFilhos

  end

    select
       tapc.cd_produto,
       SUM( tapc.qt_produto_composicao ),
       MAX( tapc.qtde_original ),
       NULL,
       MAX( tapc.cd_processo_padrao )       
    from
       @tmpComposicao tapc
    group by
      tapc.cd_produto

--   insert into @Carteira    
--     select
--        tapc.cd_produto,
--        tapc.qt_produto_composicao,
--        tapc.qtde_original,
--        tapc.cd_pedido_venda,
--        tapc.cd_processo_padrao
--     from
--        @tmpComposicao tapc




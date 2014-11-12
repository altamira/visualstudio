-----------------------------------------------------------------------------------
--Polimold Industrial S/A                        2000                     
--Stored Procedure : SQL Server Microsoft 7.0    2002
--Carlos Cardoso Fernandes         
--Vendas por Categoria de Produtos Exportação
--Data       : 09.01.2000
--Atualizado : 06.06.2000
--           : 19.06.2001 - Consistência do campo CONSIG do pedido (Consignação)
--           : 22.08.2001 - Conversão para moeda escolhida - Elias
--           : 09.08.2002 - Migração p/ bco. EGIS - DUELA
-----------------------------------------------------------------------------------
Create procedure pr_venda_categoria_exp1
@dt_inicial dateTime,
@dt_final   dateTime,
@cd_moeda   int
as


declare @vl_total_categ float
set     @vl_total_categ = 0


if @cd_moeda <> 1 
  begin
    -- declaração das variáveis
    declare @dt_pedido          datetime    -- usada na varredura da tabela
    declare @dt_ultima_venda    datetime    -- data da última venda
    declare @vl_venda           float       -- valor das compras
    declare @qt_produto         int         -- quantidade de produtos
    declare @qt_pedido          int         -- quantidade de pedidos
    declare @cd_categoria       varchar(20) -- categoria
    declare @vl_cotacao         float       -- valor da cotação do dia, resultado da sp pr_indice_moeda
    declare @ic_inconsistencia  char(1)     -- indica se houve inconsistencias na conversão

    -- inicialização das variáveis
    set @dt_pedido         = 0
    set @dt_ultima_venda   = 0
    set @vl_venda          = 0
    set @qt_produto        = 0
    set @qt_pedido         = 0
    set @cd_categoria      = ''
    set @vl_cotacao        = 0
    set @ic_inconsistencia = 'N'   

    -- tabela de resultado final
    create table #VendaCategExpAuxConv (
      sgmapa       varchar(20), 
      quantidade   float,
      venda        float,
      UltimaVenda  datetime,
      pedidos      integer ) 

    -- tabela de resumo diário usada para a conversão
    select 
      a.dt_pedido_venda                                     as 'Dia',
      c.nm_categoria_produto                                as 'Categoria', 
      sum(b.qt_item_pedido_venda)                           as 'Qtde',
      sum(b.qt_item_pedido_venda*b.vl_unitario_item_pedido) as 'Venda',
      count(*)                                              as 'Pedidos'
    into 
      #ResumoDiario
    from
      Pedido_Venda a, Pedido_Venda_Item b, Categoria_Produto c
    left outer join Grupo_Categoria gc on
      gc.cd_grupo_categoria=c.cd_grupo_categoria
    where
      (a.dt_pedido_venda between @dt_inicial and @dt_final ) and
      isnull(a.ic_consignacao_pedido,'N') = 'N'              and
      a.cd_pedido_venda=b.cd_pedido_venda                    and     
      b.cd_item_pedido_venda < 80                            and     
      (b.qt_item_pedido_venda*b.vl_unitario_item_pedido)>0   and
      (b.dt_cancelamento_item is null)                       and
      b.cd_categoria_produto=c.cd_categoria_produto          and
      gc.ic_exportacao_grupo='S'
    group by
      a.dt_pedido_venda,
      c.nm_categoria_produto    

    -- varredura da tabela de resumo diário e conversão
    while exists(select * from #ResumoDiario)
      begin
        set @vl_cotacao = 0
        -- variáveis usadas dentro do loop        
        select 
          @dt_pedido    = Dia,
          @cd_categoria = Categoria,
          @qt_produto   = Qtde,
          @qt_pedido    = Pedidos,
          @vl_venda     = Venda
        from
          #ResumoDiario

        -- retorna a cotação do dia passado para a moeda escolhida
        exec pr_indice_moeda @cd_moeda, @dt_pedido, @vl_indice = @vl_cotacao output

        -- mostra mensagem caso o relatório/consulta não estejam consistentes quanto
        -- aos valores convertidos
        if @vl_cotacao = 0
          begin
            set @ic_inconsistencia = 'S'
            print('Índice de Conversão inexistente para a data: '+convert (char(10), @dt_pedido, 101))
          end
        else        
          if exists(select * from #VendaCategExpAuxConv where sgmapa = @cd_categoria)        
            begin
              -- atualiza valores da categoria
              update 
                #VendaCategExpAuxConv
              set 
                venda      = venda      + (@vl_venda / @vl_cotacao),
                quantidade = quantidade +  @qt_produto,
                pedidos    = pedidos    +  @qt_pedido
              where 
                sgmapa = @cd_categoria
            end
          else

            begin
              -- pesquisa data de última venda da categoria
              select 
                @dt_ultima_venda = max(b.dt_item_pedido_venda)
              from
                Pedido_Venda a, Pedido_Venda_Item b, Categoria_Produto c
              left outer join Grupo_Categoria gc on
                gc.cd_grupo_categoria=c.cd_grupo_categoria
              where
                (a.dt_pedido_venda between @dt_inicial and @dt_final ) and
	        isnull(a.ic_consignacao_pedido,'N') = 'N'              and
	        a.cd_pedido_venda=b.cd_pedido_venda                    and     
	        b.cd_item_pedido_venda < 80                            and     
	        (b.qt_item_pedido_venda*b.vl_unitario_item_pedido)>0   and
	        (b.dt_cancelamento_item is null)                       and
	        b.cd_categoria_produto=c.cd_categoria_produto          and
	        gc.ic_exportacao_grupo='S'
                     
              -- inclusão de nova categoria        
              insert into #VendaCategExpAuxConv (
                sgmapa, 
                quantidade,
                venda,
                UltimaVenda,
                pedidos ) 
              values (
                @cd_categoria,
                @qt_produto,
                @vl_venda/@vl_cotacao,
                @dt_ultima_venda,
                @qt_pedido )

            end  

          -- apagando registro da tabela auxiliar
          delete from 
            #ResumoDiario 
          where 
            Dia = @dt_pedido and
            Categoria = @cd_categoria
      end                                 
    
    -- acumulando total por categoria
    select
      @vl_total_categ = @vl_total_categ + venda
    from
      #VendaCategExpAuxConv

    -- incluindo colunas de posição e percentagem
    select 
      IDENTITY(int, 1,1)         as 'Posicao',
      sgmapa,
      venda, 
     (venda/@vl_total_categ)*100 as 'Perc',
      UltimaVenda,
      pedidos,
      quantidade
    into 
      #VendaCategExpConv
    from 
      #VendaCategExpAuxConv
    order by 
      quantidade desc
    
    --Mostra tabela ao usuário
    select * from 
      #VendaCategExpConv
    order by 
      Posicao
  end
else
  begin
    -- Geração da tabela auxiliar de Vendas por Categoria
    select 
      c.nm_categoria_produto                                as 'categoria', 
      sum(b.qt_item_pedido_venda)                           as 'Quantidade',
      sum(b.qt_item_pedido_venda*b.vl_unitario_item_pedido) as 'Venda',
      max(b.dt_item_pedido_venda)                           as 'UltimaVenda',
      count(*)          as 'pedidos'
    into 
      #VendaCategExpAux
    from
      Pedido_Venda a, Pedido_Venda_Item b, Categoria_Produto c    
    left outer join Grupo_Categoria gc on
      gc.cd_grupo_categoria=c.cd_grupo_categoria
    where
      (a.dt_pedido_venda between @dt_inicial and @dt_final )  and
       isnull(a.ic_consignacao_pedido,'N') = 'N'              and
       a.cd_pedido_venda=b.cd_pedido_venda                    and     
       b.cd_item_pedido_venda < 80                            and     
       (b.qt_item_pedido_venda*b.vl_unitario_item_pedido)>0   and
       (b.dt_cancelamento_item is null)                       and
       b.cd_categoria_produto=c.cd_categoria_produto          and
       gc.ic_exportacao_grupo='S'
    Group by 
      b.cd_grupo_produto, c.nm_categoria_produto
    Order by 
      2 desc

    -- Total de Vendas Geral por Categoria
    select 
      @vl_total_categ = @vl_total_categ + venda
    from
      #VendaCategExpAux

    --Cria a Tabela Final de Vendas por Setor
    select 
      IDENTITY(int, 1,1)           as 'Posicao',
      b.nm_categoria_produto       as 'sgmapa' ,
      a.venda, 
     (a.venda/@vl_total_categ)*100 as 'Perc',
      a.UltimaVenda,
      a.pedidos,
      a.quantidade
    Into 
     #VendaCategExp
    from 
      #VendaCategExpAux a, 
      Categoria_Produto b
    Where
      a.categoria = b.nm_categoria_produto
    Order by 
      a.venda desc

    --Mostra tabela ao usuário
    select * from 
      #VendaCategExp
    order by 
      posicao

  end

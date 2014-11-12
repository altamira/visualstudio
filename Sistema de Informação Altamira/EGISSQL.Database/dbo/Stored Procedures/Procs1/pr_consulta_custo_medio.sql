
create procedure pr_consulta_custo_medio
@ic_parametro int,   -- (1) - Por Produto, (2) - Por Grupo
@ic_tipo int,    -- (1) Sintético (2) Análitico
@dt_inicial datetime,
@dt_final datetime,
@cd_produto int,
@cd_grupo_inicial int,
@cd_grupo_final int,
@cd_fase_produto int
as

  declare @cd_produto_processado int
  declare @cd_movimento int
  declare @qt_entrada decimal(25,4) 
  declare @vl_preco_entrada decimal(25,2)
  declare @vl_total_entrada decimal(25,2)
  declare @qt_saida decimal(25,4)
  declare @vl_preco_saida decimal(25,2)
  declare @qt_saldo decimal(25,4)
  declare @vl_total_saldo decimal(25,2)
  declare @vl_total_saida decimal(25,2)
  declare @dt_movimento datetime
  
  declare @qt_saldo_anterior decimal(25,4)
  declare @vl_saldo_anterior decimal(25,2)
  declare @cd_produto_anterior int
  declare @dt_fechamento_anterior datetime  
  declare @ic_ipi_custo_produto char(1)

  -- VERIFICA SE O IPI ENTRA NO CUSTO DO PRODUTO
  select 
    top 1 @ic_ipi_custo_produto = IsNull(ic_ipi_custo_produto,'N') 
  from 
    Parametro_Custo 
  where   
    cd_empresa = dbo.fn_empresa()

  -- CASO TENHA ESCOLHIDO POR GRUPO E NÃO INFORMADO GRUPO INICIAL E FINAL
  if ((@ic_parametro = 2) and (@cd_grupo_inicial = 0) and (@cd_grupo_final = 0))
  begin
    set @cd_grupo_inicial = 1
    set @cd_grupo_final = 999
  end
  
  -- BUSCA O CUSTO ANTERIOR
  select 
    g.nm_grupo_produto,
    p.nm_fantasia_produto as nm_produto,
    p.cd_produto,
    998 as cd_tipo_movimento,
    'X' as cd_entrada_saida,
    9999999 as cd_movimento,
    pf.dt_produto_fechamento as dt_movimento,
    'Saldo '+cast(month(pf.dt_produto_fechamento) as varchar)+'/'+
             cast(year(pf.dt_produto_fechamento) as varchar) as nm_historico,
    cast(0 as decimal(25,4)) as qt_entrada,
    cast(0 as decimal(25,2)) as vl_preco_entrada,
    cast(0 as decimal(25,2)) as vl_total_entrada,
    cast(0 as decimal(25,4)) as qt_saida,
    cast(0 as decimal(25,2)) as vl_preco_saida,
    cast(0 as decimal(25,2)) as vl_total_saida,
    cast(pf.qt_atual_prod_fechamento as decimal(25,4)) as qt_saldo,
    cast(isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) / 
         case when (isnull(pf.qt_atual_prod_fechamento,0) = 0) then 1 
              else pf.qt_atual_prod_fechamento end as decimal(25,2)) as vl_preco_saldo,
    cast(isnull(pf.vl_custo_medio_fechamento,isnull(pf.vl_custo_prod_fechamento,0)) as decimal(25,2)) as vl_total_saldo
  into #SI
  from produto_fechamento pf, produto p, produto_custo pc, grupo_produto g
  where p.cd_produto = pf.cd_produto and 
        pc.cd_produto = pf.cd_produto and
        g.cd_grupo_produto = p.cd_grupo_produto and      
        isnull(pc.ic_peps_produto,'S') = 'S' and
        pf.cd_produto = case when @ic_parametro = 1 then @cd_produto 
                        else pf.cd_produto end and
        p.cd_grupo_produto between case when @ic_parametro = 2 then @cd_grupo_inicial
                                   else p.cd_grupo_produto end 
                               and case when @ic_parametro = 2 then @cd_grupo_final
                                   else p.cd_grupo_produto end and
        pf.cd_fase_produto = @cd_fase_produto and
        pf.dt_produto_fechamento between (@dt_inicial -1) and @dt_final   


  -- BUSCA A MOVIMENTAÇÃO DO PERÍODO  
  select
    g.nm_grupo_produto,
    p.nm_fantasia_produto as nm_produto,
    p.cd_produto,
    tme.cd_tipo_movimento_estoque as cd_tipo_movimento,
    tme.ic_mov_tipo_movimento as cd_entrada_saida,
    me.cd_movimento_estoque as cd_movimento,
    me.dt_movimento_estoque as dt_movimento,
    isnull(me.nm_historico_movimento,tme.nm_tipo_movimento_estoque) as nm_historico_movimento,
    case when tme.ic_mov_tipo_movimento = 'E' then 
      case when (nei.cd_nota_entrada is null) then cast(isnull(me.qt_movimento_estoque,0) as decimal(25,4))
      else cast(isnull(nei.qt_item_nota_entrada,0) as decimal(25,4)) 
      end 
    else 0 
    end as qt_entrada,
    case when tme.ic_mov_tipo_movimento = 'E' then 
      case when (nei.cd_nota_entrada is null) then cast(isnull(me.vl_custo_contabil_produto,0) as decimal(25,2))
      else cast(((case @ic_ipi_custo_produto when 'S' then
                    isnull(nei.vl_total_nota_entr_item,0)
                    + IsNull(nei.vl_ipi_nota_entrada,0)
                    - IsNull(nei.vl_icms_nota_entrada,0)
                  else
                    isnull(nei.vl_total_nota_entr_item,0)
                    - isnull(nei.vl_icms_nota_entrada,0)
                  end) / isnull(nei.qt_item_nota_entrada,1)) as decimal(25,2)) 
      end
    else 0 
    end as vl_preco_entrada, 
    case when tme.ic_mov_tipo_movimento = 'E' then 
      case when (nei.cd_nota_entrada is null) then cast(isnull((me.vl_custo_contabil_produto * me.qt_movimento_estoque),0) as decimal(25,2))
      else cast((case @ic_ipi_custo_produto 
             when 'S' then
               isnull(nei.vl_total_nota_entr_item,0)
               + IsNull(nei.vl_ipi_nota_entrada,0)
               - IsNull(nei.vl_icms_nota_entrada,0)
             else
               isnull(nei.vl_total_nota_entr_item,0)
               - isnull(nei.vl_icms_nota_entrada,0)
             end) as decimal(25,2)) 
      end
    else 0 
    end as vl_total_entrada,
    case when tme.ic_mov_tipo_movimento = 'S' then 
      cast(isnull(me.qt_movimento_estoque,0) as decimal(25,4)) else 0 end as qt_saida,
    cast(0 as decimal(25,2)) as vl_preco_saida,
    cast(0 as decimal(25,2)) as vl_total_saida,
    cast(0 as decimal(25,4)) as qt_saldo,
    cast(0 as decimal(25,2)) as vl_preco_saldo,
    cast(0 as decimal(25,2)) as vl_total_saldo
  into #M
  from movimento_estoque me
  left outer join nota_entrada_item nei
  on nei.cd_nota_entrada = me.cd_documento_movimento and
     nei.cd_item_nota_entrada = me.cd_item_documento and
     nei.cd_fornecedor = me.cd_fornecedor and
     nei.cd_operacao_fiscal = isnull(me.cd_operacao_fiscal, 
                                     nei.cd_operacao_fiscal)
  left outer join nota_entrada ne
  on ne.cd_nota_entrada = nei.cd_nota_entrada and
     ne.cd_fornecedor = nei.cd_fornecedor and
     ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
     ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
  inner join tipo_movimento_estoque tme
  on me.cd_tipo_movimento_estoque = tme.cd_tipo_movimento_estoque and
     tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto'
  inner join produto p 
  on me.cd_produto = p.cd_produto
  inner join produto_custo pc
  on pc.cd_produto = p.cd_produto and      
     isnull(pc.ic_peps_produto,'S') = 'S'
  inner join grupo_produto g
  on g.cd_grupo_produto = p.cd_grupo_produto
  where me.cd_produto = case when @ic_parametro = 1 then @cd_produto 
                        else me.cd_produto end and
        p.cd_grupo_produto >= case when @ic_parametro = 2 then @cd_grupo_inicial
                              else p.cd_grupo_produto end and
        p.cd_grupo_produto <= case when @ic_parametro = 2 then @cd_grupo_final
                              else p.cd_grupo_produto end and
        me.cd_fase_produto = @cd_fase_produto and
        me.dt_movimento_estoque between @dt_inicial and @dt_final
 
  -- CARREGA O CUSTO ANTERIOR E A MOVIMENTAÇÃO EM UMA SÓ TABELA TEMPORÁRIA 
  insert into #M select * from #SI 
 
  -- CURSOR ORDENADO COM TODA A MOVIMENTAÇÃO PARA A VALORAÇÃO
  declare cCursor cursor for
  select cd_produto,    
    cd_movimento,
    dt_movimento,
    qt_entrada,
    vl_preco_entrada,
    vl_total_entrada,
    qt_saida,
    qt_saldo,
    vl_total_saldo
  from #M order by nm_produto, dt_movimento, cd_entrada_saida, cd_movimento
  
  open cCursor
  
  fetch next from cCursor into @cd_produto_processado, @cd_movimento, @dt_movimento, @qt_entrada, @vl_preco_entrada,
                               @vl_total_entrada, @qt_saida, @qt_saldo, @vl_total_saldo

  -- PRIMEIRAS VARIÁVEIS, ANTES DO LOOP  
  set @qt_saldo_anterior = @qt_saldo
  set @vl_saldo_anterior = @vl_total_saldo
  set @cd_produto_anterior = @cd_produto_processado
  set @dt_fechamento_anterior = null  
  
  while @@FETCH_STATUS = 0
  begin

    -- CASO ESTEJA MUDANDO DE PRODUTO OU DE MÊS, INICIAR AS VARIÁVEIS
    if (@cd_produto_processado <> @cd_produto_anterior) or
      ((@dt_fechamento_anterior <> null) and
      (dbo.fn_ultimo_dia_mes(@dt_fechamento_anterior) <> dbo.fn_ultimo_dia_mes(@dt_movimento)))
    begin

      -- ATUALIZA AS VARIÁVEIS
      set @cd_produto_anterior = @cd_produto_processado
      set @dt_fechamento_anterior = @dt_movimento
      set @qt_saldo_anterior = @qt_saldo
      set @vl_saldo_anterior = @vl_total_saldo

    end
  
    -- LIMPA VARIÁVEL DE SAÍDAS
    set @vl_preco_saida = 0
    set @vl_total_saida = 0
  
    -- VERIFICA SE HOUVE ENTRADA, E CALCULA NOVO SALDO
    if (@qt_entrada <> 0)
    begin

      if (@vl_total_entrada = 0) 
        set @vl_total_entrada = @qt_entrada * @vl_preco_entrada
  
      set @vl_total_saldo = @vl_saldo_anterior + @vl_total_entrada 
      set @qt_saldo = @qt_saldo_anterior + @qt_entrada 
  
    end
    else
    -- VERIFICA SE HOUVE SAIDA, CALCULA CUSTO DA SAIDA E NOVO SALDO
    if (@qt_saida <> 0)
    begin      
      set @vl_preco_saida = @vl_saldo_anterior / case when @qt_saldo_anterior = 0 then 1 else @qt_saldo_anterior end
      set @vl_total_saida = @qt_saida * @vl_preco_saida
  
      set @vl_total_saldo = @vl_saldo_anterior - @vl_total_saida
      set @qt_saldo = @qt_saldo_anterior - @qt_saida    
    end
    else
    begin
      -- SE NÃO HOUVE ENTRADA E NEM SAÍDAS, ATUALIZA O SALDO 
      set @vl_total_saldo = @vl_saldo_anterior
      set @qt_saldo = @qt_saldo_anterior
    end
  
    -- ATUALIZANDO A TABELA COM A NOVA VALORAÇÃO
    update #M 
    set vl_preco_saida = @vl_preco_saida,
        vl_total_saida = @vl_total_saida,
        vl_total_entrada = @vl_total_entrada,
        qt_saldo = @qt_saldo,
        vl_preco_saldo = case when @qt_saldo <> 0 
                         then @vl_total_saldo / @qt_saldo
                         else 0 end,
        vl_total_saldo = case when @qt_saldo <> 0 
                         then @vl_total_saldo 
                         else 0 end
    where
      cd_produto = @cd_produto_processado and
      cd_movimento = @cd_movimento and
      @cd_movimento <> 9999999

    -- ATUALIZANDO SOMENTE OS REGISTROS DE SALDO DA TABELA
    update #M 
    set qt_saldo = @qt_saldo_anterior,
        vl_preco_saldo = case when @qt_saldo <> 0 
                         then @vl_total_saldo / @qt_saldo
                         else 0 end,
        vl_total_saldo = case when @qt_saldo <> 0 
                         then @vl_total_saldo
                         else 0 end
    where
      cd_produto = @cd_produto_processado and
      cd_movimento = @cd_movimento and
      dt_movimento = @dt_movimento and
      @cd_movimento = 9999999  

    -- ATUALIZANDO O SALDO ANTERIOR
    set @vl_saldo_anterior = @vl_total_saldo
    set @qt_saldo_anterior = @qt_saldo
    set @dt_fechamento_anterior = @dt_movimento
                   
    fetch next from cCursor into @cd_produto_processado, @cd_movimento, @dt_movimento, @qt_entrada, @vl_preco_entrada,
                                 @vl_total_entrada, @qt_saida, @qt_saldo, @vl_total_saldo
  
  end
  
  close cCursor
  deallocate cCursor
  
  -- ATUALIZA O PRODUTO FECHAMENTO
  update produto_fechamento set vl_custo_medio_fechamento = m.vl_preco_saldo * m.qt_saldo,
                                qt_medio_prod_fechamento = m.qt_saldo
  from produto_fechamento pf, #M m
  where pf.cd_produto = m.cd_produto and
        pf.cd_fase_produto = @cd_fase_produto and
        pf.dt_produto_fechamento = m.dt_movimento and
        m.cd_entrada_saida = 'X'

  -- ATUALIZA O PRODUTO CUSTO
  update produto_custo set vl_custo_contabil_produto = m.vl_preco_saldo
  from produto_custo pc, #M m
  where pc.cd_produto = m.cd_produto and
        m.dt_movimento = @dt_final and
        m.cd_entrada_saida = 'X'

  -- ATUALIZA O MOVIMENTO DE ESTOQUE
  update movimento_estoque set vl_custo_contabil_produto = m.vl_preco_saldo
  from movimento_estoque me, #M m
  where me.cd_movimento_estoque = me.cd_movimento_estoque and
        m.cd_entrada_saida = 'S'

  -- LISTA O SINTÉTICO OU ANALÍTICO
  if (@ic_tipo = 1)      
  begin

    select
      m.nm_grupo_produto,
      m.nm_produto,
      m.cd_produto,
      sum(m.qt_entrada) as qt_entrada,      
      sum(m.vl_total_entrada) as vl_total_entrada,
      sum(m.qt_saida) as qt_saida,
      sum(m.vl_total_saida) as vl_total_saida,
      cast(max(pf.qt_atual_prod_fechamento) as decimal(25,4)) as qt_saldo,
      cast(isnull(max(pf.vl_custo_medio_fechamento),0) / 
           case when (isnull(max(pf.qt_atual_prod_fechamento),0) = 0) then 1 
                else max(pf.qt_atual_prod_fechamento) end as decimal(25,2)) as vl_preco_saldo,
      cast(isnull(max(pf.vl_custo_medio_fechamento),0) as decimal(25,2)) as vl_total_saldo
    from #M m, Produto_Fechamento pf
    where m.cd_produto = pf.cd_produto and
          pf.cd_fase_produto = @cd_fase_produto and
          pf.dt_produto_fechamento = @dt_final and
          m.cd_entrada_saida in ('S','E')
    group by m.nm_grupo_produto, m.nm_produto, m.cd_produto            

  end
  else
    select * from #M 
    order by nm_grupo_produto, nm_produto, dt_movimento, cd_entrada_saida, cd_movimento
  
  drop table #SI
  drop table #M
      


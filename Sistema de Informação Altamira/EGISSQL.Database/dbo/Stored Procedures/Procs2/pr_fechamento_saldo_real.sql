
-------------------------------------------------------------------------------
create procedure pr_fechamento_saldo_real
-------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda            2002
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Elias Pereira da Silva
--Banco de Dados  : EgisSql
--Objetivo        : Cálculo do Saldo Real dos Produtos no Fechamento de Estoque
--Data            : 01/02/2005
--Atualização     : 28/02/2005 - Acertos Diversos Para Melhoria de Performace - ELIAS    
--                  28/07/2005 - Acerto para Buscar todos os Produtos na Geração
--                               do Produto_Fechamento e Produto_Saldo - ELIAS
--                  01/08/2005 - Otimização da Gravação do Produto_Fechamento - ELIAS
--                  10/08/2005 - Inclusão da Gravação do Peso - ELIAS
--                  01/11/2005 - Gravação dos Métodos de Valoração de Estoque no Produto_Fechamento - ELIAS
--                  30/11/2005 - Inclusão dos Filtros por Fase Configurado nos Grupos de Produto (Grupo_Produto_Fase) - ELIAS
--                  28/12/2005 - Ajuste para a gravação do preço de lista do produto em vigor no último dia do mês, conforme
--                               Histórico de Preço do Produto - ELIAS
--Parametros:
--  1 - FECHAMENTO DE TODOS OS GRUPOS DE PRODUTO
--  3 - FECHAMENTO POR GRUPO DE PRODUTO
--  5 - FECHAMENTO POR SÉRIE INDIVIDUAL
--  6 - FECHAMENTO POR PRODUTO
--  7 - ATUALIZAÇÃO DO CONTROLE DE FECHAMENTO

-------------------------------------------------------------------------------
@ic_parametro     int, 
@dt_inicial   	  DateTime,
@dt_final     	  DateTime,
@cd_produto       int = 0,
@cd_grupo_produto int = 0,
@cd_serie_produto int = 0,
@cd_usuario       int = 0
as

SET NOCOUNT ON

declare @ic_debug char(1)

set @ic_debug = 'N'

if @ic_debug = 'N'
  SET NOCOUNT ON
else
  SET NOCOUNT OFF

-------------------------------------------------------------------------------
-- PEGANDO FASE DE VENDA DEFAULT DOS PRODUTOS DO PARAMETRO COMERCIAL
-------------------------------------------------------------------------------
declare @cd_fase_produto int

select
  @cd_fase_produto = cd_fase_produto
from
  Parametro_Comercial  with (nolock) 
where 
  cd_empresa = dbo.fn_empresa()

-------------------------------------------------------------------------------
if (@ic_parametro = 1)   -- TODOS OS GRUPOS DE PRODUTO
-------------------------------------------------------------------------------
begin 

  -------------------------------------------------------------------------------
  -- ATUALIZAÇÃO DOS PESOS NA TABELA DE MOVIMENTO DE ESTOQUE
  -------------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Atualizando Pesos no Movimento de Estoque do Mês...')

  -- ATUALIZAÇÃO DO MOVIMENTO DE ESTOQUE DE ENTRADAS
  update Movimento_Estoque
  set qt_peso_movimento_estoque = peps.qt_peso_entrada_peps
  from Movimento_Estoque me, Nota_Entrada_Peps peps
  where me.cd_movimento_estoque = peps.cd_movimento_estoque and
        me.dt_movimento_estoque between @dt_inicial and @dt_final 

  -- ATUALIZAÇÃO DO MOVIMENTO DE ESTOQUE QUE NÃO CONTÊM PESO
  update Movimento_estoque
  set qt_peso_movimento_estoque = p.qt_peso_bruto * me.qt_movimento_estoque
  from Movimento_Estoque me, Produto p
  where me.cd_produto = p.cd_produto and
        me.dt_movimento_estoque between @dt_inicial and @dt_final and
        p.cd_grupo_produto in (select gpc.cd_grupo_produto 
                               from Grupo_Produto_Custo gpc, Unidade_Medida um
                               where gpc.cd_unidade_valoracao = um.cd_unidade_medida and
                                     um.ic_fator_conversao = 'K') and
        isnull(me.qt_peso_movimento_estoque,0) = 0

  if (@ic_debug = 'S') 
    print ('Pesos no Movimento de Estoque do Mês Atualizados')

  -----------------------------------------------------------------------------
  -- BUSCANDO OS MOVIMENTOS DE ESTOQUE DE TODOS OS PRODUTOS
  -----------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Buscando Movimentos de Estoque do Mês...')

  select isnull(me.cd_produto, p.cd_produto) as cd_produto, 
    isnull(me.cd_fase_produto, isnull(p.cd_fase_produto_baixa, @cd_fase_produto)) as cd_fase_produto, 
    isnull(me.qt_movimento_estoque,0) as qt_movimento_estoque,
    isnull(me.qt_peso_movimento_estoque,0) as qt_peso_movimento_estoque,
    isnull(me.cd_tipo_movimento_estoque,1) as cd_tipo_movimento_estoque,
    isnull(me.ic_tipo_lancto_movimento,'E') as ic_tipo_lancto_movimento,
    isnull(me.ic_consig_movimento,'N') as ic_consig_movimento,
    isnull(me.ic_terceiro_movimento,'N') as ic_terceiro_movimento
  into #MovimentoEstoque 
  from Movimento_Estoque me inner join 
    Produto p on me.cd_produto = p.cd_produto inner join 
    -- INCLUÍDO FILTRO POR FASE NOS GRUPOS DE PRODUTO
    Grupo_Produto_Fase gpf on gpf.cd_grupo_produto = p.cd_grupo_produto and
                              gpf.cd_fase_produto = isnull(me.cd_fase_produto, isnull(p.cd_fase_produto_baixa, @cd_fase_produto)) left outer join
    Grupo_Produto gp on gp.cd_grupo_produto = p.cd_grupo_produto left outer join 
    Grupo_Produto_Custo gpc on p.cd_grupo_produto = gpc.cd_grupo_produto
  where me.dt_movimento_estoque between @dt_inicial and @dt_final and
   (isnull(gpc.ic_fechamento_mensal,'S') = 'S' or isnull(gpc.ic_estoque_grupo_prod,'S' ) = 'S' or
    isnull(gp.ic_baixa_composicao_grupo,'S') = 'S')    

  create index Temp_IX_Movimento_Estoque on #MovimentoEstoque (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Criado Movimentos de Estoque do Mês...')

  ---------------------------------------------------------------------------
  -- MOVIMENTOS DE ENTRADAS/SAÍDAS
  ---------------------------------------------------------------------------
  -- SOMENTE OS LANCAMENTOS COM:
  -- TIPO DE MOVIMENTO, TEM DE SER DO TIPO 1 (ENTRADA DE NOTA FISCAL) OU QUALQUER
  -- OUTRO QUE ATUALIZE SEMPRE O SALDO REAL DO ESTOQUE DO PRODUTO, COMO É DEFINIDO
  -- PELO NM_ATRIBUTO_PRODUTO_SALDO

  if (@ic_debug = 'S') 
    print ('Calculando Entradas e Saidas do Mês...')

  select me.cd_produto, me.cd_fase_produto, 
    sum( case when tme.ic_mov_tipo_movimento =  'E'
	   then me.qt_movimento_estoque
         else 0
         end ) qt_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'E'
	   then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_movimento_estoque
         else 0
         end ) qt_saida,
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_saida
  into #EntradaSaidaGeral
  from #MovimentoEstoque me with (NOLOCK) inner join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
  where (me.cd_tipo_movimento_estoque in (select cd_tipo_movimento_estoque from tipo_movimento_estoque 
                                          where cd_tipo_movimento_estoque = 1 or 
                                                isnull(nm_atributo_produto_saldo,'qt_saldo_atual_produto') = 'qt_saldo_atual_produto') or
    me.ic_tipo_lancto_movimento = 'M') 
  group by me.cd_produto, me.cd_fase_produto

  create index Temp_IX_EntradaSaidaGeral on #EntradaSaidaGeral (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Entradas e Saidas do Mês Calculados')
		
  ---------------------------------------------------------------------------
  --  CONSIGNAÇÃO
  ---------------------------------------------------------------------------
  -- SOMENTE OS LANÇAMENTOS IDENTIFICADOS COMO CONSIGNAÇÃO ATRAVÉS DO
  -- FLAG IC_CONSIG_MOVIMENTO = 'SIM'

  if (@ic_debug = 'S') 
    print ('Calculando Entradas e Saidas do Mês (Consignacao)...')
	
  select me.cd_produto, me.cd_fase_produto,
    sum( case when tme.ic_mov_tipo_movimento =  'E'
           then me.qt_movimento_estoque
         else 0
         end ) qt_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_movimento_estoque
         else 0
         end ) qt_saida
  into #EntradaSaidaConsignacaoGeral
  from #MovimentoEstoque me with (NOLOCK) inner join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
  where me.ic_consig_movimento = 'S' 
  group By me.cd_produto, me.cd_fase_produto

  create index Temp_IX_EntradaSaidaConsignacaoGeral on #EntradaSaidaConsignacaoGeral (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Entradas e Saidas do Mês Calculados (Consignacao)')
		
  ---------------------------------------------------------------------------
  -- MOVIMENTO DE TERCEIROS
  ---------------------------------------------------------------------------
  -- SOMENTE OS LANÇAMENTOS IDENTIFICADOS COMO CONSIGNAÇÃO ATRAVÉS DO
  -- FLAG IC_TERCEIRO_MOVIMENTO = 'SIM'

  if (@ic_debug = 'S') 
    print ('Calculando Entradas e Saidas do Mês (Terceiros)...')
	
  select me.cd_produto, me.cd_fase_produto,
    sum( case when tme.ic_mov_tipo_movimento =  'E'
           then me.qt_movimento_estoque
         else 0
         end ) qt_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'E'
           then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_movimento_estoque
         else 0
         end ) qt_saida,
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_saida
  into #EntradaSaidaTerceirosGeral
  from #MovimentoEstoque me with (NOLOCK) inner join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
  where me.ic_terceiro_movimento = 'S' 
  group by me.cd_produto, me.cd_fase_produto

  create index Temp_IX_EntradaSaidaTerceirosGeral on #EntradaSaidaTerceirosGeral (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Entradas e Saidas do Mês Calculados (Terceiros)')

  ---------------------------------------------------------------------------
  -- MAIOR PREÇO DOS PRODUTOS (SEGUNDO A NOTA FISCAL DE SAÍDA)
  ---------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Calculando Maior Preço dos Produtos...')
	
  select nsi.cd_produto, max(nsi.vl_unitario_item_nota) as vl_maior_preco_produto
  into #MaiorPrecoProdutosGeral
  from Nota_Saida ns with (NOLOCK) inner join 
    Nota_Saida_Item nsi with (NOLOCK) on nsi.cd_nota_saida = ns.cd_nota_saida inner join 
    Operacao_Fiscal ofi on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where ns.cd_status_nota = 5 and nsi.cd_produto is not null and
    ofi.ic_comercial_operacao = 'S' and ns.dt_nota_saida between @dt_inicial and @dt_final
  group by nsi.cd_produto

  create index Temp_IX_MaiorPrecoProdutosGeral on #MaiorPrecoProdutosGeral (cd_produto)

  if (@ic_debug = 'S') 
    print ('Maior Preço dos Produtos Calculado')	

  ---------------------------------------------------------------------------
  -- MAIOR CUSTO DOS PRODUTOS (SEGUNDO A NOTA FISCAL DE ENTRADA)
  ---------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Calculando Maior Custo dos Produtos...')
	
  select nei.cd_produto, max(nei.vl_item_nota_entrada) as vl_maior_custo_produto
  into #MaiorCustoProdutosGeral
  from Nota_Entrada ne with (NOLOCK) inner join 
    Nota_Entrada_Item nei with (NOLOCK) on nei.cd_nota_entrada = ne.cd_nota_entrada and 																					 nei.cd_fornecedor = ne.cd_fornecedor and 
                                           nei.cd_operacao_fiscal = ne.cd_operacao_fiscal and 
                                           nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal inner join 
    Operacao_Fiscal ofi on ofi.cd_operacao_fiscal = ne.cd_operacao_fiscal 	
  where ne.dt_nota_entrada between @dt_inicial and @dt_final and
    nei.cd_produto is not null and ofi.ic_comercial_operacao = 'S'
  group by nei.cd_produto 

  create index Temp_IX_MaiorCustoProdutosGeral on #MaiorCustoProdutosGeral (cd_produto)

  if (@ic_debug = 'S') 
    print ('Maior Custo dos Produtos Calculado')	

  ---------------------------------------------------------------------------
  -- ******************* SALDO FINAL DOS PRODUTOS ***************************
  -- JUNÇÃO DAS TABELAS PREENCHIDAS ACIMA DE MOVIMENTOS, CONSIGNAÇÃO, TERCEIROS
  -- MELHOR PREÇO E MELHOR CUSTO.
  ---------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Unindo Entradas e Saidas, Maiores Custo e Preco...')
	
  select ps.cd_produto, ps.cd_fase_produto, 
    (isnull(pf.qt_atual_prod_fechamento,0) + (isnull(es.qt_entrada,0) - isnull(es.qt_saida,0))) as 'qt_saldo',
    isnull(es.qt_entrada, 0) as 'qt_entrada',
    isnull(es.qt_saida, 0) as 'qt_saida',	
    (isnull(pf.qt_consig_prod_fechamento,0) + (IsNull(c.qt_saida,0) - IsNull(c.qt_entrada,0))) as 'qt_consignacao',	
    (isnull(pf.qt_terc_prod_fechamento,0) + IsNull(t.qt_saida,0) - (IsNull(t.qt_entrada,0))) as 'qt_terceiro',	
    (isnull(pf.qt_peso_prod_fechamento,0) + (isnull(es.qt_peso_entrada,0) - isnull(es.qt_peso_saida,0))) as 'qt_peso_saldo',
    (isnull(pf.qt_peso_terc_fechamento,0) + (isnull(t.qt_peso_entrada,0) - isnull(t.qt_peso_saida,0))) as 'qt_peso_terc_saldo',    
    p.vl_produto as vl_maior_lista_produto, 
    mpp.vl_maior_preco_produto, mcp.vl_maior_custo_produto
  into #FinalGeral
  from Produto_Saldo ps inner join 
    Produto p on p.cd_produto = ps.cd_produto inner join 
    -- INCLUÍDO FILTRO POR FASE NOS GRUPOS DE PRODUTO
    Grupo_Produto_Fase gpf on gpf.cd_grupo_produto = p.cd_grupo_produto and
                              gpf.cd_fase_produto  = ps.cd_fase_produto left outer join 
    Produto_Fechamento pf on pf.cd_produto = ps.cd_produto and
                             pf.cd_fase_produto = ps.cd_fase_produto and
                             pf.dt_produto_fechamento = ( @dt_inicial -1 ) left outer join
    #EntradaSaidaGeral es on es.cd_produto = ps.cd_produto and
                        es.cd_fase_produto = ps.cd_fase_produto	left outer join 
    #EntradaSaidaConsignacaoGeral c on c.cd_produto = ps.cd_produto and
                                  c.cd_fase_produto = ps.cd_fase_produto left outer join 
    #EntradaSaidaTerceirosGeral t on t.cd_produto = ps.cd_produto and
                    	          t.cd_fase_produto = ps.cd_fase_produto left outer join 
    #MaiorPrecoProdutosGeral mpp on mpp.cd_produto = ps.cd_produto left outer join 
    #MaiorCustoProdutosGeral mcp on mcp.cd_produto = ps.cd_produto	

  create index Temp_IX_FinalGeral on #FinalGeral (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Ajustando Preços conforme Histórico...')

  -- Ajuste do Preço, caso tenha havido alguma atualização, conforme a tabela de Produto_Historico - ELIAS 28/12/2005
  update #FinalGeral
  set vl_maior_lista_produto = ph.vl_historico_produto
  from #FinalGeral pf
    inner join Produto_Historico ph on pf.cd_produto = ph.cd_produto 
  where ph.dt_historico_produto = (select top 1 aux.dt_historico_produto
                                   from Produto_Historico aux
                                   where aux.cd_produto = ph.cd_produto and
                                     aux.dt_historico_produto between @dt_final and getDate()
                                   order by 1) 

  if (@ic_debug = 'S') 
    print ('Uniao Calculado')	

  if (@ic_debug = 'S') 
    print ('Exclusao das Tabelas Temporarias...')

  -- EXCLUSÃO DAS TABELAS TEMPORÁRIAS
  drop table #MovimentoEstoque
  drop table #MaiorCustoProdutosGeral
  drop table #MaiorPrecoProdutosGeral
  drop table #EntradaSaidaTerceirosGeral
  drop table #EntradaSaidaConsignacaoGeral
  drop table #EntradaSaidaGeral

	
  ---------------------------------------------------------------------------
  -- ************* ATUALIZAÇÃO DA PRODUTO FECHAMENTO ************************
  ---------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Atualizacao do Produto Fechamento existente...')
	
  -- ATUALIZAR OS REGISTROS QUE JÁ EXISTEM

  update Produto_Fechamento
  set 
    qt_atual_prod_fechamento = f.qt_saldo,
    qt_entra_prod_fechamento = f.qt_entrada, 
    qt_saida_prod_fechamento = f.qt_saida, --qt_consig_prod_fechamento = f.qt_consignacao,
    qt_terc_prod_fechamento  = f.qt_terceiro, 
    vl_maior_lista_produto   = f.vl_maior_lista_produto,
    vl_maior_preco_produto   = f.vl_maior_preco_produto, 
    vl_maior_custo_produto   = f.vl_maior_custo_produto,
    qt_peso_prod_fechamento  = f.qt_peso_saldo,
    qt_peso_terc_fechamento  = f.qt_peso_terc_saldo,
    ic_peps_produto          = pc.ic_peps_produto,
    --cd_usuario = 1, 
    cd_usuario = @cd_usuario, 
    dt_usuario = GetDate()
  from 
    Produto_Fechamento pf    with (nolock) 
    inner join #FinalGeral f on pf.cd_produto = f.cd_produto and
    pf.cd_fase_produto = f.cd_fase_produto and pf.dt_produto_fechamento = @dt_final
    left outer join Produto_Custo pc on f.cd_produto = pc.cd_produto

  if (@ic_debug = 'S') 
    print ('Criacao do Produto Fechamento inexistente...')
	
  -- INSERIR OS REGISTROS QUE AINDA NÃO EXISTEM
  insert into Produto_Fechamento 
   (cd_produto, cd_fase_produto, dt_produto_fechamento, qt_atual_prod_fechamento,
    qt_entra_prod_fechamento, qt_saida_prod_fechamento, --qt_consig_prod_fechamento,
    qt_terc_prod_fechamento, vl_maior_lista_produto, vl_maior_preco_produto, vl_maior_custo_produto,
    qt_peso_prod_fechamento, qt_peso_terc_fechamento, ic_peps_produto, cd_usuario, dt_usuario)
  select f.cd_produto, f.cd_fase_produto, @dt_final, f.qt_saldo, f.qt_entrada, f.qt_saida, --f.qt_consignacao,
    f.qt_terceiro, f.vl_maior_lista_produto, f.vl_maior_preco_produto, f.vl_maior_custo_produto,
    f.qt_peso_saldo, f.qt_peso_terc_saldo, pc.ic_peps_produto, 1, GetDate()
  from #FinalGeral f left outer join Produto_Fechamento pf on pf.cd_produto = f.cd_produto and
    pf.cd_fase_produto = f.cd_fase_produto and pf.dt_produto_fechamento = @dt_final left outer join 
    Produto_Custo pc on f.cd_produto = pc.cd_produto
  where pf.cd_produto is null -- NÃO EXISTIR O REGISTRO NA TABELA

  -- ATUALIZAÇÃO DOS MÉTODOS DE VALORAÇÃO
  update Produto_Fechamento
  set cd_metodo_valoracao = case when (isnull(pv.cd_metodo_valoracao,0) = 0)
                            then gpv.cd_metodo_valoracao
                            else pv.cd_metodo_valoracao
                            end 
  from produto p
    inner join produto_fechamento pf on p.cd_produto = pf.cd_produto
    left outer join grupo_produto_valoracao gpv on p.cd_grupo_produto = gpv.cd_grupo_produto and
                                                   pf.cd_fase_produto = gpv.cd_fase_produto
    left outer join produto_valoracao pv on p.cd_produto = pv.cd_produto and
                                            pf.cd_fase_produto = pv.cd_fase_produto
  where pf.dt_produto_fechamento = @dt_final

	
  drop table #FinalGeral	

end
-------------------------------------------------------------------------------
else  if (@ic_parametro = 3)   -- GRUPO DE PRODUTO
-------------------------------------------------------------------------------
begin

  -------------------------------------------------------------------------------
  -- ATUALIZAÇÃO DOS PESOS NA TABELA DE MOVIMENTO DE ESTOQUE
  -------------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Atualizando Pesos no Movimento de Estoque do Mês...')

  -- ATUALIZAÇÃO DO MOVIMENTO DE ESTOQUE DE ENTRADAS
  update Movimento_Estoque
  set qt_peso_movimento_estoque = peps.qt_peso_entrada_peps
  from Movimento_Estoque me, Nota_Entrada_Peps peps, Produto p
  where me.cd_movimento_estoque = peps.cd_movimento_estoque and
        me.cd_produto = p.cd_produto and
        me.dt_movimento_estoque between @dt_inicial and @dt_final and
        p.cd_grupo_produto = @cd_grupo_produto

  -- ATUALIZAÇÃO DO MOVIMENTO DE ESTOQUE QUE NÃO CONTÊM PESO
  update Movimento_estoque
  set qt_peso_movimento_estoque = p.qt_peso_bruto * me.qt_movimento_estoque
  from Movimento_Estoque me, Produto p
  where me.cd_produto = p.cd_produto and
        p.cd_grupo_produto = @cd_grupo_produto and
        me.dt_movimento_estoque between @dt_inicial and @dt_final and
        p.cd_grupo_produto = (select gpc.cd_grupo_produto 
                              from Grupo_Produto_Custo gpc, Unidade_Medida um
                              where gpc.cd_unidade_valoracao = um.cd_unidade_medida and
                                    gpc.cd_grupo_produto = @cd_grupo_produto and
                                    um.ic_fator_conversao = 'K') and
        isnull(me.qt_peso_movimento_estoque,0) = 0

  if (@ic_debug = 'S') 
    print ('Pesos no Movimento de Estoque do Mês Atualizados')

  -----------------------------------------------------------------------------
  -- BUSCANDO OS MOVIMENTOS DE ESTOQUE DE TODOS OS PRODUTOS DO GRUPO
  -----------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Buscando Movimentos de Estoque do Mês...')

  select isnull(me.cd_produto, p.cd_produto) as cd_produto, 
    isnull(me.cd_fase_produto, isnull(p.cd_fase_produto_baixa, @cd_fase_produto)) as cd_fase_produto, 
    isnull(me.qt_movimento_estoque,0) as qt_movimento_estoque,
    isnull(me.qt_peso_movimento_estoque,0) as qt_peso_movimento_estoque,
    isnull(me.cd_tipo_movimento_estoque,1) as cd_tipo_movimento_estoque,
    isnull(me.ic_tipo_lancto_movimento,'E') as ic_tipo_lancto_movimento,
    isnull(me.ic_consig_movimento,'N') as ic_consig_movimento,
    isnull(me.ic_terceiro_movimento,'N') as ic_terceiro_movimento
  into #MovimentoEstoqueGrp 
  from Movimento_Estoque me inner join
    Produto p on me.cd_produto = p.cd_produto inner join 
    -- INCLUÍDO FILTRO POR FASE NOS GRUPOS DE PRODUTO
    Grupo_Produto_Fase gpf on gpf.cd_grupo_produto = p.cd_grupo_produto and
                              gpf.cd_fase_produto = isnull(me.cd_fase_produto, isnull(p.cd_fase_produto_baixa, @cd_fase_produto))
  where me.dt_movimento_estoque between @dt_inicial and @dt_final and
    p.cd_grupo_produto = @cd_grupo_produto

  create index Temp_IX_MovimentoEstoqueGrp on #MovimentoEstoqueGrp (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Criado Movimentos de Estoque do Mês...')

  ---------------------------------------------------------------------------
  -- MOVIMENTOS DE ENTRADAS/SAÍDAS
  ---------------------------------------------------------------------------
  -- SOMENTE OS LANCAMENTOS COM:
  -- TIPO DE MOVIMENTO, TEM DE SER DO TIPO 1 (ENTRADA DE NOTA FISCAL) OU QUALQUER
  -- OUTRO QUE ATUALIZE SEMPRE O SALDO REAL DO ESTOQUE DO PRODUTO, COMO É DEFINIDO
  -- PELO NM_ATRIBUTO_PRODUTO_SALDO

  if (@ic_debug = 'S') 
    print ('Calculando Entradas e Saidas do Mês...')

  select me.cd_produto, me.cd_fase_produto, 
    sum( case when tme.ic_mov_tipo_movimento =  'E'
	   then me.qt_movimento_estoque
	 else 0
	 end ) qt_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'E'
	   then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'S'
	   then me.qt_movimento_estoque
         else 0
         end ) qt_saida,
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_saida
  into #EntradaSaidaGrp
  from #MovimentoEstoqueGrp me inner join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
  where (me.cd_tipo_movimento_estoque in (select cd_tipo_movimento_estoque from tipo_movimento_estoque 
                                          where cd_tipo_movimento_estoque = 1 or 
                                            isnull(nm_atributo_produto_saldo,'qt_saldo_atual_produto') = 'qt_saldo_atual_produto') or
    me.ic_tipo_lancto_movimento = 'M')
  group by
    me.cd_produto,
    me.cd_fase_produto

  create index Temp_IX_EntradaSaidaGrp on #EntradaSaidaGrp (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Entradas e Saidas do Mês Calculados')

  ---------------------------------------------------------------------------
  --  CONSIGNAÇÃO
  ---------------------------------------------------------------------------
  -- SOMENTE OS LANÇAMENTOS IDENTIFICADOS COMO CONSIGNAÇÃO ATRAVÉS DO
  -- FLAG IC_CONSIG_MOVIMENTO = 'SIM'

  if (@ic_debug = 'S') 
    print ('Calculando Entradas e Saidas do Mês (Consignacao)...')

  select me.cd_produto, me.cd_fase_produto,
    sum( case when tme.ic_mov_tipo_movimento =  'E'
           then me.qt_movimento_estoque
         else 0
         end ) qt_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_movimento_estoque
         else 0
         end ) qt_saida
  into 
    #EntradaSaidaConsignacaoGrp
  from #MovimentoEstoqueGrp me inner join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
  where me.ic_consig_movimento = 'S'
  group by me.cd_produto, me.cd_fase_produto

  create index Temp_IX_EntradaSaidaConsignacaoGrp on #EntradaSaidaConsignacaoGrp (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Entradas e Saidas do Mês Calculados (Consignacao)')

  ---------------------------------------------------------------------------
  -- MOVIMENTO DE TERCEIROS
  ---------------------------------------------------------------------------
  -- SOMENTE OS LANÇAMENTOS IDENTIFICADOS COMO CONSIGNAÇÃO ATRAVÉS DO
  -- FLAG IC_TERCEIRO_MOVIMENTO = 'SIM'

  if (@ic_debug = 'S') 
    print ('Calculando Entradas e Saidas do Mês (Terceiros)...')
	
  select me.cd_produto, me.cd_fase_produto,
    sum( case when tme.ic_mov_tipo_movimento =  'E'
           then me.qt_movimento_estoque
         else 0
         end ) qt_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'E'
           then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_movimento_estoque
         else 0
         end ) qt_saida,
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_saida
  into 
    #EntradaSaidaTerceirosGrp
  from #MovimentoEstoqueGrp me inner join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
  where me.ic_terceiro_movimento = 'S' 
  group by me.cd_produto, me.cd_fase_produto

  create index Temp_IX_EntradaSaidaTerceirosGrp on #EntradaSaidaTerceirosGrp (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Entradas e Saidas do Mês Calculados (Terceiros)')

  ---------------------------------------------------------------------------
  -- MAIOR PREÇO DOS PRODUTOS (SEGUNDO A NOTA FISCAL DE SAÍDA)
  ---------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Calculando Maior Preço dos Produtos...')
	
  select nsi.cd_produto, max(nsi.vl_unitario_item_nota) as vl_maior_preco_produto
  into #MaiorPrecoProdutosGrp
  from Nota_Saida ns with (NOLOCK) inner join 
    Nota_Saida_Item nsi with (NOLOCK) on nsi.cd_nota_saida = ns.cd_nota_saida inner join 
    Produto p on p.cd_produto = nsi.cd_produto inner join
    Operacao_Fiscal ofi on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where p.cd_grupo_produto = @cd_grupo_produto and ns.cd_status_nota = 5 and
    ofi.ic_comercial_operacao = 'S' and ns.dt_nota_saida between @dt_inicial and @dt_final 
  group by nsi.cd_produto

  create index Temp_IX_MaiorPrecoProdutosGrp on #MaiorPrecoProdutosGrp (cd_produto)

  if (@ic_debug = 'S') 
    print ('Maior Preço dos Produtos Calculado')	

  ---------------------------------------------------------------------------
  -- MAIOR CUSTO DOS PRODUTOS (SEGUNDO A NOTA FISCAL DE ENTRADA)
  ---------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Calculando Maior Custo dos Produtos...')
	
  select nei.cd_produto, max(nei.vl_item_nota_entrada) as vl_maior_custo_produto
  into #MaiorCustoProdutosGrp
  from Nota_Entrada ne with (NOLOCK) inner join 
    Nota_Entrada_Item nei with (NOLOCK) on nei.cd_nota_entrada = ne.cd_nota_entrada and 																					 nei.cd_fornecedor = ne.cd_fornecedor and 
                                           nei.cd_operacao_fiscal = ne.cd_operacao_fiscal and 
                                           nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal inner join 
    Produto p on p.cd_produto = nei.cd_produto inner join
    Operacao_Fiscal ofi on ofi.cd_operacao_fiscal = ne.cd_operacao_fiscal 	
  where p.cd_grupo_produto = @cd_grupo_produto and ofi.ic_comercial_operacao = 'S' and
    ne.dt_nota_entrada between @dt_inicial and @dt_final
  group by nei.cd_produto 

  create index Temp_IX_MaiorCustoProdutosGrp on #MaiorCustoProdutosGrp (cd_produto)

  if (@ic_debug = 'S') 
    print ('Maior Custo dos Produtos Calculado')	

  ---------------------------------------------------------------------------
  -- ******************* SALDO FINAL DOS PRODUTOS ***************************
  -- JUNÇÃO DAS TABELAS PREENCHIDAS ACIMA DE MOVIMENTOS, CONSIGNAÇÃO, TERCEIROS
  -- MELHOR PREÇO E MELHOR CUSTO.
  ---------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Unindo Entradas e Saidas e Maiores Custo e Preco...')
	        
  select ps.cd_produto, ps.cd_fase_produto,	
    (isnull(pf.qt_atual_prod_fechamento,0) + (isnull(es.qt_entrada,0) - isnull(es.qt_saida,0))) as 'qt_saldo',
    isnull(es.qt_entrada, 0) as 'qt_entrada', 
    isnull(es.qt_saida, 0) as 'qt_saida',	
    (isnull(pf.qt_consig_prod_fechamento,0) + (isnull(c.qt_saida,0) - isnull(c.qt_entrada,0))) as 'qt_consignacao',	
    (isnull(pf.qt_terc_prod_fechamento,0) + isnull(t.qt_saida,0) - (isnull(t.qt_entrada,0))) as 'qt_terceiro',	
    (isnull(pf.qt_peso_prod_fechamento,0) + (isnull(es.qt_peso_entrada,0) - isnull(es.qt_peso_saida,0))) as 'qt_peso_saldo',
    (isnull(pf.qt_peso_terc_fechamento,0) + (isnull(t.qt_peso_entrada,0) - isnull(t.qt_peso_saida,0))) as 'qt_peso_terc_saldo',    
    p.vl_produto as vl_maior_lista_produto,
    mpp.vl_maior_preco_produto,
    mcp.vl_maior_custo_produto
  into #FinalGrp
  from Produto_Saldo ps inner join 
    Produto p on p.cd_produto = ps.cd_produto and
                 p.cd_grupo_produto = @cd_grupo_produto inner join
    -- INCLUÍDO FILTRO POR FASE NOS GRUPOS DE PRODUTO
    Grupo_Produto_Fase gpf on gpf.cd_grupo_produto = p.cd_grupo_produto and
                              gpf.cd_fase_produto = ps.cd_fase_produto left outer join 
    Produto_Fechamento pf on pf.cd_produto = ps.cd_produto and
                             pf.cd_fase_produto = ps.cd_fase_produto and
                             pf.dt_produto_fechamento = ( @dt_inicial -1 ) left outer join
    #EntradaSaidaGrp es on es.cd_produto = ps.cd_produto and
                es.cd_fase_produto = ps.cd_fase_produto	left outer join 
    #EntradaSaidaConsignacaoGrp c on c.cd_produto = ps.cd_produto and
                                  c.cd_fase_produto = ps.cd_fase_produto left outer join 
    #EntradaSaidaTerceirosGrp t on t.cd_produto = ps.cd_produto and
                    	          t.cd_fase_produto = ps.cd_fase_produto left outer join 
    #MaiorPrecoProdutosGrp mpp on mpp.cd_produto = ps.cd_produto left outer join 
    #MaiorCustoProdutosGrp mcp on mcp.cd_produto = ps.cd_produto	

  create index Temp_IX_FinalGRP on #FinalGrp (cd_produto, cd_fase_produto)

  if (@ic_debug = 'S') 
    print ('Ajustando Preços conforme Histórico...')

  -- Ajuste do Preço, caso tenha havido alguma atualização, conforme a tabela de Produto_Historico - ELIAS 28/12/2005
  update #FinalGrp
  set vl_maior_lista_produto = ph.vl_historico_produto
  from #FinalGrp pf
    inner join Produto_Historico ph on pf.cd_produto = ph.cd_produto 
  where ph.dt_historico_produto = (select top 1 aux.dt_historico_produto
                                   from Produto_Historico aux
                                   where aux.cd_produto = ph.cd_produto and
                                     aux.dt_historico_produto between @dt_final and getDate()
                                   order by 1) 

  if (@ic_debug = 'S') 
    print ('Uniao Calculado')	

  if (@ic_debug = 'S') 
    print ('Exclusao das Tabelas Temporarias...')

  -- EXCLUSÃO DAS TABELAS TEMPORÁRIAS
  drop table #MovimentoEstoqueGrp
  drop table #MaiorCustoProdutosGrp
  drop table #MaiorPrecoProdutosGrp
  drop table #EntradaSaidaTerceirosGrp
  drop table #EntradaSaidaConsignacaoGrp
  drop table #EntradaSaidaGrp
	
  ---------------------------------------------------------------------------
  -- ************* ATUALIZAÇÃO DA PRODUTO FECHAMENTO ************************
  ---------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Atualizacao do Produto Fechamento existente...')

  -- ATUALIZAR OS REGISTROS QUE JÁ EXISTEM
  update Produto_Fechamento
  set qt_atual_prod_fechamento = f.qt_saldo, qt_entra_prod_fechamento = f.qt_entrada, 
      qt_saida_prod_fechamento = f.qt_saida, --qt_consig_prod_fechamento = f.qt_consignacao,
      qt_terc_prod_fechamento = f.qt_terceiro, vl_maior_lista_produto = f.vl_maior_lista_produto,
      vl_maior_preco_produto = f.vl_maior_preco_produto, vl_maior_custo_produto = f.vl_maior_custo_produto,
      qt_peso_prod_fechamento = f.qt_peso_saldo, qt_peso_terc_fechamento = f.qt_peso_terc_saldo,
      ic_peps_produto = pc.ic_peps_produto, cd_usuario = 1,  dt_usuario = GetDate()
  from Produto_Fechamento pf inner join #FinalGrp f on pf.cd_produto = f.cd_produto and
    pf.cd_fase_produto = f.cd_fase_produto and pf.dt_produto_fechamento = @dt_final left outer join 
    Produto_Custo pc on f.cd_produto = pc.cd_produto


  if (@ic_debug = 'S') 
    print ('Criacao do Produto Fechamento inexistente...')

  -- INSERIR OS REGISTROS QUE AINDA NÃO EXISTEM
  insert into Produto_Fechamento (cd_produto, cd_fase_produto, dt_produto_fechamento, qt_atual_prod_fechamento,
    qt_entra_prod_fechamento, qt_saida_prod_fechamento, --qt_consig_prod_fechamento, 
    qt_terc_prod_fechamento, vl_maior_lista_produto, vl_maior_preco_produto, vl_maior_custo_produto, 
    qt_peso_prod_fechamento, qt_peso_terc_fechamento, ic_peps_produto, cd_usuario, dt_usuario)
  select f.cd_produto, f.cd_fase_produto, @dt_final, f.qt_saldo, f.qt_entrada, f.qt_saida, --f.qt_consignacao,
    f.qt_terceiro, f.vl_maior_lista_produto, f.vl_maior_preco_produto, f.vl_maior_custo_produto,
    f.qt_peso_saldo, f.qt_peso_terc_saldo, pc.ic_peps_produto, 1, GetDate()
  from #FinalGrp f left outer join Produto_Fechamento pf on pf.cd_produto = f.cd_produto and
    pf.cd_fase_produto = f.cd_fase_produto and pf.dt_produto_fechamento = @dt_final left outer join 
    Produto_Custo pc on f.cd_produto = pc.cd_produto
  where pf.cd_produto is null -- NÃO EXISTIR O REGISTRO NA TABELA

  -- ATUALIZAÇÃO DOS MÉTODOS DE VALORAÇÃO
  update Produto_Fechamento
  set cd_metodo_valoracao = case when (isnull(pv.cd_metodo_valoracao,0) = 0)
                            then gpv.cd_metodo_valoracao
                            else pv.cd_metodo_valoracao
                            end 
  from #FinalGrp f 
    inner join produto_fechamento pf on f.cd_produto = pf.cd_produto
    left outer join grupo_produto_valoracao gpv on @cd_grupo_produto = gpv.cd_grupo_produto and
                                                   pf.cd_fase_produto = gpv.cd_fase_produto
    left outer join produto_valoracao pv on f.cd_produto = pv.cd_produto and
                                            pf.cd_fase_produto = pv.cd_fase_produto
  where pf.dt_produto_fechamento = @dt_final
	
  drop table #FinalGrp

end 

-------------------------------------------------------------------------------
else if (@ic_parametro = 6)   -- PRODUTO INDIVIDUAL
-------------------------------------------------------------------------------
begin

  -------------------------------------------------------------------------------
  -- ATUALIZAÇÃO DOS PESOS NA TABELA DE MOVIMENTO DE ESTOQUE
  -------------------------------------------------------------------------------

  if (@ic_debug = 'S') 
    print ('Atualizando Pesos no Movimento de Estoque do Mês...')

  -- ATUALIZAÇÃO DO MOVIMENTO DE ESTOQUE DE ENTRADAS
  update Movimento_Estoque
  set qt_peso_movimento_estoque = peps.qt_peso_entrada_peps
  from Movimento_Estoque me, Nota_Entrada_Peps peps
  where me.cd_movimento_estoque = peps.cd_movimento_estoque and
        me.dt_movimento_estoque between @dt_inicial and @dt_final and
        me.cd_produto = @cd_produto

  -- ATUALIZAÇÃO DO MOVIMENTO DE ESTOQUE QUE NÃO CONTÊM PESO
  update Movimento_estoque
  set qt_peso_movimento_estoque = p.qt_peso_bruto * me.qt_movimento_estoque
  from Movimento_Estoque me, Produto p, Grupo_Produto_Custo gpc, Unidade_Medida um
  where p.cd_grupo_produto = gpc.cd_grupo_produto and
        gpc.cd_unidade_valoracao = um.cd_unidade_medida and
        me.cd_produto = p.cd_produto and
        p.cd_produto = @cd_produto and
        um.ic_fator_conversao = 'K' and
        me.dt_movimento_estoque between @dt_inicial and @dt_final and
        isnull(me.qt_peso_movimento_estoque,0) = 0

  if (@ic_debug = 'S') 
    print ('Pesos no Movimento de Estoque do Mês Atualizados')
  -----------------------------------------------------------------------------
  -- BUSCANDO OS MOVIMENTOS DE ESTOQUE DO PRODUTO ESPECÍFICO
  -----------------------------------------------------------------------------

  select isnull(me.cd_produto, p.cd_produto) as cd_produto, 
    isnull(me.cd_fase_produto, isnull(p.cd_fase_produto_baixa, @cd_fase_produto)) as cd_fase_produto, 
    isnull(me.qt_movimento_estoque,0) as qt_movimento_estoque,
    isnull(me.qt_peso_movimento_estoque,0) as qt_peso_movimento_estoque,
    isnull(me.cd_tipo_movimento_estoque,1) as cd_tipo_movimento_estoque,
    isnull(me.ic_tipo_lancto_movimento,'E') as ic_tipo_lancto_movimento,
    isnull(me.ic_consig_movimento,'N') as ic_consig_movimento,
    isnull(me.ic_terceiro_movimento,'N') as ic_terceiro_movimento
  into #MovimentoEstoquePrd 
  from Movimento_Estoque me inner join 
    Produto p on me.cd_produto = p.cd_produto inner join
    -- INCLUÍDO FILTRO POR FASE NOS GRUPOS DE PRODUTO
    Grupo_Produto_Fase gpf on gpf.cd_grupo_produto = p.cd_grupo_produto and
                              gpf.cd_fase_produto = isnull(me.cd_fase_produto, isnull(p.cd_fase_produto_baixa, @cd_fase_produto))
  where me.dt_movimento_estoque between @dt_inicial and @dt_final and
    p.cd_produto = @cd_produto

  ---------------------------------------------------------------------------
  -- MOVIMENTOS DE ENTRADAS/SAÍDAS
  ---------------------------------------------------------------------------
  -- SOMENTE OS LANCAMENTOS COM:
  -- TIPO DE MOVIMENTO, TEM DE SER DO TIPO 1 (ENTRADA DE NOTA FISCAL) OU QUALQUER
  -- OUTRO QUE ATUALIZE SEMPRE O SALDO REAL DO ESTOQUE DO PRODUTO, COMO É DEFINIDO
  -- PELO NM_ATRIBUTO_PRODUTO_SALDO
  select me.cd_produto, me.cd_fase_produto, 
    sum( case when tme.ic_mov_tipo_movimento =  'E'
	   then me.qt_movimento_estoque
         else 0
         end ) qt_entrada,
    sum( case when tme.ic_mov_tipo_movimento =  'E'
	   then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_movimento_estoque
         else 0
         end ) qt_saida,
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_saida
  into #EntradaSaidaPrd
  from #MovimentoEstoquePrd me with (NOLOCK) inner join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
  where (me.cd_tipo_movimento_estoque in (select cd_tipo_movimento_estoque from tipo_movimento_estoque 
                                          where cd_tipo_movimento_estoque = 1 or 
                                                isnull(nm_atributo_produto_saldo,'qt_saldo_atual_produto') = 'qt_saldo_atual_produto') or
         me.ic_tipo_lancto_movimento = 'M')
  group by me.cd_produto, me.cd_fase_produto
	
  ---------------------------------------------------------------------------
  --  CONSIGNAÇÃO
  ---------------------------------------------------------------------------
  -- SOMENTE OS LANÇAMENTOS IDENTIFICADOS COMO CONSIGNAÇÃO ATRAVÉS DO
  -- FLAG IC_CONSIG_MOVIMENTO = 'SIM'
	
  select me.cd_produto, me.cd_fase_produto, 
    sum( case when tme.ic_mov_tipo_movimento =  'E'
           then me.qt_movimento_estoque
	 else 0
	 end ) qt_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_movimento_estoque
         else 0
         end ) qt_saida
  into #EntradaSaidaConsignacaoPrd
  from #MovimentoEstoquePrd me with (NOLOCK) inner join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
  where me.ic_consig_movimento = 'S' 
  group by me.cd_produto, me.cd_fase_produto

  ---------------------------------------------------------------------------
  -- MOVIMENTO DE TERCEIROS
  ---------------------------------------------------------------------------
  -- SOMENTE OS LANÇAMENTOS IDENTIFICADOS COMO CONSIGNAÇÃO ATRAVÉS DO
  -- FLAG IC_TERCEIRO_MOVIMENTO = 'SIM'
	
  select me.cd_produto, me.cd_fase_produto,
    sum( case when tme.ic_mov_tipo_movimento =  'E'
           then me.qt_movimento_estoque
         else 0
         end ) qt_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'E'
           then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_entrada,	
    sum( case when tme.ic_mov_tipo_movimento =  'S'
	   then me.qt_movimento_estoque
         else 0
         end ) qt_saida,
    sum( case when tme.ic_mov_tipo_movimento =  'S'
           then me.qt_peso_movimento_estoque
         else 0
         end ) qt_peso_saida
  into #EntradaSaidaTerceirosPrd
  from #MovimentoEstoquePrd me with (NOLOCK) inner join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
  where me.ic_terceiro_movimento = 'S' 
  group by me.cd_produto, me.cd_fase_produto

  ---------------------------------------------------------------------------
  -- MAIOR PREÇO DOS PRODUTOS (SEGUNDO A NOTA FISCAL DE SAÍDA)
  ---------------------------------------------------------------------------
	
  select nsi.cd_produto, max(nsi.vl_unitario_item_nota) as vl_maior_preco_produto
  into #MaiorPrecoProdutosPrd
  from Nota_Saida ns with (NOLOCK) inner join 
    Nota_Saida_Item nsi with (NOLOCK) on nsi.cd_nota_saida = ns.cd_nota_saida inner join 
    Operacao_Fiscal ofi on ofi.cd_operacao_fiscal = ns.cd_operacao_fiscal
  where ns.dt_nota_saida between @dt_inicial and @dt_final and 
    nsi.cd_produto = @cd_produto and ns.cd_status_nota = 5 and
    ofi.ic_comercial_operacao = 'S'
  group by nsi.cd_produto

  ---------------------------------------------------------------------------
  -- MAIOR CUSTO DOS PRODUTOS (SEGUNDO A NOTA FISCAL DE ENTRADA)
  ---------------------------------------------------------------------------
	
  select nei.cd_produto, max(nei.vl_item_nota_entrada) as vl_maior_custo_produto
  into #MaiorCustoProdutosPrd
  from Nota_Entrada ne with (NOLOCK) inner join 
    Nota_Entrada_Item nei with (NOLOCK) on nei.cd_nota_entrada = ne.cd_nota_entrada and 																					 nei.cd_fornecedor = ne.cd_fornecedor and 
                                           nei.cd_operacao_fiscal = ne.cd_operacao_fiscal and 
                                           nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal inner join 
    Operacao_Fiscal ofi on ofi.cd_operacao_fiscal = ne.cd_operacao_fiscal 	
  where ne.dt_nota_entrada between @dt_inicial and @dt_final and
    nei.cd_produto = @cd_produto and ofi.ic_comercial_operacao = 'S'
  group by nei.cd_produto 

  ---------------------------------------------------------------------------
  -- ******************* SALDO FINAL DOS PRODUTOS ***************************
  -- JUNÇÃO DAS TABELAS PREENCHIDAS ACIMA DE MOVIMENTOS, CONSIGNAÇÃO, TERCEIROS
  -- MELHOR PREÇO E MELHOR CUSTO.
  ---------------------------------------------------------------------------
	
  select ps.cd_produto, ps.cd_fase_produto,	
    (isnull(pf.qt_atual_prod_fechamento,0) + (IsNull(es.qt_entrada,0) - IsNull(es.qt_saida,0))) as 'qt_saldo',
    isnull(es.qt_entrada, 0) as 'qt_entrada',
    isnull(es.qt_saida, 0) as 'qt_saida',	
    (isnull(pf.qt_consig_prod_fechamento,0) + (IsNull(c.qt_saida,0) - IsNull(c.qt_entrada,0))) as 'qt_consignacao',	
    (isnull(pf.qt_terc_prod_fechamento,0) + IsNull(t.qt_saida,0) - (IsNull(t.qt_entrada,0))) as 'qt_terceiro',	
    (isnull(pf.qt_peso_prod_fechamento,0) + (isnull(es.qt_peso_entrada,0) - isnull(es.qt_peso_saida,0))) as 'qt_peso_saldo',
    (isnull(pf.qt_peso_terc_fechamento,0) + (isnull(t.qt_peso_entrada,0) - isnull(t.qt_peso_saida,0))) as 'qt_peso_terc_saldo',    
    p.vl_produto as vl_maior_lista_produto,
    mpp.vl_maior_preco_produto, mcp.vl_maior_custo_produto
  into #FinalPrd 
  from Produto_Saldo ps inner join 
    Produto p on p.cd_produto = ps.cd_produto and
                 p.cd_produto = @cd_produto inner join
    -- INCLUÍDO FILTRO POR FASE NOS GRUPOS DE PRODUTO
    Grupo_Produto_Fase gpf on gpf.cd_grupo_produto = p.cd_grupo_produto and
                              gpf.cd_fase_produto = ps.cd_fase_produto left outer join 
    Produto_Fechamento pf on pf.cd_produto = ps.cd_produto and
                             pf.cd_fase_produto = ps.cd_fase_produto and
                             pf.dt_produto_fechamento = ( @dt_inicial -1 ) left outer join
    #EntradaSaidaPrd es on es.cd_produto = ps.cd_produto and
                        es.cd_fase_produto = ps.cd_fase_produto	left outer join 
    #EntradaSaidaConsignacaoPrd c on c.cd_produto = ps.cd_produto and
                                  c.cd_fase_produto = ps.cd_fase_produto left outer join 
    #EntradaSaidaTerceirosPrd t on t.cd_produto = ps.cd_produto and
                    	          t.cd_fase_produto = ps.cd_fase_produto left outer join 
    #MaiorPrecoProdutosPrd mpp on mpp.cd_produto = ps.cd_produto left outer join 
    #MaiorCustoProdutosPrd mcp on mcp.cd_produto = ps.cd_produto	

  if (@ic_debug = 'S') 
    print ('Ajustando Preços conforme Histórico...')

  -- Ajuste do Preço, caso tenha havido alguma atualização, conforme a tabela de Produto_Historico - ELIAS 28/12/2005
  update #FinalPrd
  set vl_maior_lista_produto = ph.vl_historico_produto
  from #FinalPrd pf
    inner join Produto_Historico ph on pf.cd_produto = ph.cd_produto 
  where ph.dt_historico_produto = (select top 1 aux.dt_historico_produto
                                   from Produto_Historico aux
                                   where aux.cd_produto = ph.cd_produto and
                                     aux.dt_historico_produto between @dt_final and getDate()
                                   order by 1) 


  -- EXCLUSÃO DAS TABELAS TEMPORÁRIAS
  drop table #MaiorCustoProdutosPrd
  drop table #MaiorPrecoProdutosPrd
  drop table #EntradaSaidaTerceirosPrd
  drop table #EntradaSaidaConsignacaoPrd
  drop table #EntradaSaidaPrd
	
  ---------------------------------------------------------------------------
  -- ************* ATUALIZAÇÃO DA PRODUTO FECHAMENTO ************************
  ---------------------------------------------------------------------------
	
  -- ATUALIZAR OS REGISTROS QUE JÁ EXISTEM
  update Produto_Fechamento
  set qt_atual_prod_fechamento = f.qt_saldo, qt_entra_prod_fechamento = f.qt_entrada, 
    qt_saida_prod_fechamento = f.qt_saida, --qt_consig_prod_fechamento = f.qt_consignacao,
    qt_terc_prod_fechamento = f.qt_terceiro, vl_maior_lista_produto = f.vl_maior_lista_produto,
    vl_maior_preco_produto = f.vl_maior_preco_produto, vl_maior_custo_produto = f.vl_maior_custo_produto,
    qt_peso_prod_fechamento = f.qt_peso_saldo, qt_peso_terc_fechamento = f.qt_peso_terc_saldo,
    ic_peps_produto = pc.ic_peps_produto, cd_usuario = 1, dt_usuario = GetDate()
  from Produto_Fechamento pf inner join #FinalPrd f on pf.cd_produto = f.cd_produto and
    pf.cd_fase_produto = f.cd_fase_produto and pf.dt_produto_fechamento = @dt_final left outer join 
    Produto_Custo pc on f.cd_produto = pc.cd_produto
	
  -- INSERIR OS REGISTROS QUE AINDA NÃO EXISTEM
  insert into Produto_Fechamento (cd_produto, cd_fase_produto, dt_produto_fechamento, qt_atual_prod_fechamento,
    qt_entra_prod_fechamento, qt_saida_prod_fechamento, --qt_consig_prod_fechamento,
    qt_terc_prod_fechamento, vl_maior_lista_produto, vl_maior_preco_produto, vl_maior_custo_produto,
    qt_peso_prod_fechamento, qt_peso_terc_fechamento, ic_peps_produto, cd_usuario, dt_usuario)
  select f.cd_produto, f.cd_fase_produto, @dt_final, f.qt_saldo, f.qt_entrada, f.qt_saida, --f.qt_consignacao,
    f.qt_terceiro, f.vl_maior_lista_produto, f.vl_maior_preco_produto, f.vl_maior_custo_produto,
    f.qt_peso_saldo, f.qt_peso_terc_saldo, pc.ic_peps_produto, 1, GetDate()
  from #FinalPrd f left outer join Produto_Fechamento pf on pf.cd_produto = f.cd_produto and
    pf.cd_fase_produto = f.cd_fase_produto and pf.dt_produto_fechamento = @dt_final left outer join 
    Produto_Custo pc on f.cd_produto = pc.cd_produto
  where pf.cd_produto is null -- NÃO EXISTIR O REGISTRO NA TABELA

  -- ATUALIZAÇÃO DOS MÉTODOS DE VALORAÇÃO
  update Produto_Fechamento
  set cd_metodo_valoracao = case when (isnull(pv.cd_metodo_valoracao,0) = 0)
                            then gpv.cd_metodo_valoracao
                            else pv.cd_metodo_valoracao
                            end 
  from produto p
    inner join produto_fechamento pf on p.cd_produto = pf.cd_produto
    left outer join grupo_produto_valoracao gpv on p.cd_grupo_produto = gpv.cd_grupo_produto and
                                                   pf.cd_fase_produto = gpv.cd_fase_produto
    left outer join produto_valoracao pv on p.cd_produto = pv.cd_produto and
                                            pf.cd_fase_produto = pv.cd_fase_produto
  where p.cd_produto = @cd_produto and pf.dt_produto_fechamento = @dt_final
	
  drop table #FinalPrd

end 


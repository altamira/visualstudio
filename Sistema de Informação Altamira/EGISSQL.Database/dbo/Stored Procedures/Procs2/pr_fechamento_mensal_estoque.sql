
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
create procedure pr_fechamento_mensal_estoque
-------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda            2002
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Daniel Duela
--Banco de Dados  : EgisSql
--Objetivo        : Fechamento de Estoque
--Data            : 26/04/2002
--Atualizado      : 04/07/2002
--                  30/08/2002
--                  22/02/2003 - Revisão Geral - Carlos/Igor
--                  24/04/2003 - Acertos Gerais - ELIAS
--	            03/04/2003 - Acertos Gerais - Johnny
--                               Concluído o fechamento de todos os grupos
--                  13/04/2003 - Eduardo - Opção de Fechamento por Produto
--                  25/08/2003 - Eduardo/Johnny - Acerto do Fechamento de
--                               produtos para Terceiros e Consignação
--                  15/09/2003 - Eduardo - Preenchimento dos Campos que armazenam
--                               as informações sobre o maior custo no período,
--                               maior preço de venda e maior preço de lista
--                  26/03/2004 - Eduardo - A pedido do Carlos não é mais atualizada a coluna "qt_consig_prod_fechamento"
--                  01/04/2004 - Eduardo - Incluída a opção de Fechamento por GRUPO.
--                  13/04/2004 - Eduardo - Alterações visando melhoria no desempenho.
--                  05/05/2004 - Alexandre - Atualiza a flag do Produto_Fechamento do Produto_Custo
--                  07.05.2004 - Igor - Inclusão de Cursor para reserva de requisição interna
--                  21/05/2004 - Elias acertos no cálculo da consignação e de terceiros.
--                  27/12/2004 - Acerto na Forma de Baixa da Composição que pode ser Multiplicada pela
--                               quantidade do PV ou não, de acordo com o Parametro_Faturamento. - ELIAS
--                  19/01/2005 - Acerto na Geração de Reserva através de OP que passa a considerar as OPs
--                               atreladas a PVs e que não foram reservados pelo PV e sim pela OP. - ELIAS
--                  31/01/2005 - Passa a considerar como Saldo do Pedido a Quantidade em Aberto até a Data
--                               do Fechamento considerando os Faturamento feitos após a Data de Fechamento
--                               e não simplemente o Saldo gravado no PVs. Isso para evitar que PV não sejam
--                               reservados adequadamente, somente porque seu saldo está zerado, mas no dia
--                               do fechamento ele ainda não havia sido faturado.
--                               Modificado rotina de gravação do Código do Movimento, otimizando o processo
--                               de fechamento. Agora estará executando somente uma vez a busca do código pela
--                               sp_pegacodigo tornando o processo muito mais rápido. - ELIAS
--                               Alterado local da atualização do Controle de Fechamento do Estoque, colocando
--                               dentro de um mesmo controle de transação. Incluído novo parâmetro (7) para 
--                               executar somente esta atualização. - ELIAS
--                  28/02/2005 - Modificado estrutura da procedure que continha vários loops que ocasionavam
--                               Grande Demora de Processamento. - ELIAS
--                  11/07/2005 - Não filtrar as Notas Fiscais que deverão ser utilizadas para encontrar o saldo
--                               em Aberto dos Pedidos de Venda. Antes estava filtrando pelos Flags de Estoque indevidamente - ELIAS
--                  12/07/2005 - Incluído Pedidos de Venda que foram cancelados somente após a data do fechamento - ELIAS
--                  10/08/2005 - Incluido rotina para limpeza da tabela de Pedido_Venda_Impressão - ELIAS
--                  21/07/2006 - Acertado para utilizar o Produto de Baixa, quando informado da Guia Logística do Produto - ELIAS
--                               Ajustado para limpar os Movimentos gerados por Fechamentos Anteriores - ELIAS
--
-- 20.07.2008 - Correção para Fechamento da Programação de Entrega 
--
--
--Parametros:
--
--  1 - FECHAMENTO DE TODOS OS GRUPOS DE PRODUTO
--  3 - FECHAMENTO POR GRUPO DE PRODUTO
--  5 - FECHAMENTO POR SÉRIE INDIVIDUAL
--  6 - FECHAMENTO POR PRODUTO
--  7 - ATUALIZAÇÃO DO CONTROLE DE FECHAMENTO
--
-- Atualizações : 
-- 21.09.2009 -> Pedidos de Vendas Faturados após a Data de fechamento Mensal - Carlos Fernandes
-- 18.12.2009 -> Fechamento de Pedidos de Kit precisam reservar a composição do Produto - Carlos Fernandes
-- 17.03.2010 -> Reserva dos Componentes da Op's - Carlos Fernandes/Luis
-- 02.10.2010 -> Saldo da reserva da Quantidade Planejada da OP - Qtd. Já apontada - Carlos Fernandes
----------------------------------------------------------------------------------------------------------
@ic_parametro     int = 0, 
@dt_inicial   	  DateTime,
@dt_final     	  DateTime,
@cd_produto       int = 0,
@cd_grupo_produto int = 0,
@cd_serie_produto int = 0,
@cd_departamento  int = 0,
@cd_modulo        int = 0,
@cd_usuario       int = 0,
@ic_mes_fechado   char(1) output,
@ic_fecha_mes     char(1) = 'S'
as

--   Begin Transaction

  SET LOCK_TIMEOUT 32000

  if NOT ( @ic_parametro in ( 1, 3, 5, 6, 7 ) )
  begin
    raiserror('A Rotina para este Parâmetro ainda não foi Implementada!', 16, 1)
  end

  declare @Tabela       	    varchar(100)
  declare @cd_movimento_estoque     int
  declare @cd_codigo_me             int
  declare @ic_fechamento_reserva    char(1)  -- 25/04/2003
  declare @dt_dia_util_mes_seguinte datetime 

  --Variáveis para pegar a composição dos produtos

  declare @cd_produto_composicao     int
  declare @qt_produto_composicao     float
  declare @dt_fechamento_pedido      datetime
  declare @cd_pedido_venda           int
  declare @cd_item_pedido_venda      int
  declare @dt_pedido_venda           datetime
  declare @cd_cliente		     int
  declare @nm_fantasia_produto       varchar(60)
  declare @cd_fase_produto           int
  declare @cd_produto_pai_reserva    int
  declare @cd_produto_reserva        int
  declare @qt_produto_reserva        float
  declare @cd_fase_produto_reserva   int

  declare @ic_gera_reserva_estrutura char(1)
  declare @ic_multiplica_componente  char(1)

  -- Necessário para Geração do Código Chave
  set @Tabela = Db_Name() + '.dbo.Movimento_Estoque'  

  -- NECESSÁRIO PARA DEBUGAÇÃO
  declare @ic_debug char(1)
  set @ic_debug = 'S'

  if @ic_debug = 'N'
    SET NOCOUNT ON
  else
    SET NOCOUNT OFF
 
------------------------------------------------------------------------------
-- VERIFICANDO FECHAMENTOS ANTERIORES
-------------------------------------------------------------------------------

--VERIFICA SE É PARA FECHAR O MÊS
if @ic_fecha_mes = 'S'
begin

  -- VERIFICAR SE JÁ FOI FECHADO COMPLETAMENTE, SE SIM IMPEDIR O 
  -- PROCESSAMENTO - ELIAS 25/04/2003
  if exists (select top 1 * 
             from fechamento_mensal
             where 
               cd_ano                     = year(@dt_inicial) and
               cd_mes                     = month(@dt_inicial)and
               isnull(ic_mes_fechado,'N') = 'S')
  begin
    set @ic_mes_fechado = 'S'
    if (@ic_parametro <> 7)
      raiserror('Atenção! Fechamento referente a esse período já efetuado, não será permitido continuar.', 16, 1)
  end
  else
    set @ic_mes_fechado = 'N'

end

-- VERIFICAR SE JÁ FOI FECHADO OS SALDOS DE RESERVA, SE SIM NÃO EFETUAR ESSE
-- FECHAMENTO NOVAMENTE

if exists (select top 1 * 
           from Fechamento_Mensal with (nolock) 
           where cd_ano = year(@dt_inicial) and
                 cd_mes = month(@dt_inicial)and
                 isnull(ic_mes_fechado_reserva,'N') = 'S')
  set @ic_fechamento_reserva = 'S'
else
  set @ic_fechamento_reserva = 'N'

-- PEGANDO FASE DE VENDA DEFAULT DOS PRODUTOS DO PARAMETRO COMERCIAL

select
  @cd_fase_produto           = isnull(cd_fase_produto,0),
  @ic_gera_reserva_estrutura = isnull(ic_gera_reserva_estrutura,'N')
from 
  Parametro_Comercial with (nolock) 
where 
  cd_empresa = dbo.fn_empresa()

-- FORMA DE BAIXA DOS COMPONENTES, SE MULTIPLICA PELO PV OU SE A
-- QUANTIDADE DA COMPOSIÇÃO É A QUE DEVE SER BAIXADA - ELIAS

select 
  @ic_multiplica_componente = isnull(ic_multiplic_comp_dev_cancel,'S')
from
  Parametro_Faturamento with (nolock) 
where 
  cd_empresa = dbo.fn_empresa()

-- PEGANDO PRIMEIRO DIA ÚTIL DO MES SEGUINTE

select top 1 @dt_dia_util_mes_seguinte = dt_agenda
from 
  Agenda with (nolock) 
where dt_agenda > @dt_final and
  isnull(ic_util,'N') = 'S'
order by 1

---------------------------------------------------------------------------------------------
-- LIMPEZA DA TABELA DE IMPRESSÃO DO PEDIDO DE VENDA
---------------------------------------------------------------------------------------------
truncate table Pedido_Venda_Impressao

---------------------------------------------------------------------------------------------
if (@ic_parametro = 1) or (@ic_parametro = 7) -- ATUALIZAÇÃO DO CONTROLE DE FECHAMENTO, 
--                                               SOMENTE QUANDO TODOS GRUPOS SÓ A EXECUÇÃO
--                                               DA ATUALIZAÇÃO DO CONTROLE DE FECHAMENTO
---------------------------------------------------------------------------------------------
begin  

  -- GRAVAR OS FLAGS NECESSÁRIOS PARA CONTROLE DE FECHAMENTO PARA EVITAR QUE
  -- ALGUÉM TENTE EFETUAR O FECHAMENTO AO MESMO TEMPO - ELIAS 25/04/2003
  if (@ic_fecha_mes = 'S')
  begin

    if exists(select top 1 *  from fechamento_mensal with (nolock) 
	      where cd_ano = year(@dt_inicial) and
	            cd_mes = month(@dt_inicial))
      update Fechamento_Mensal
        set ic_sce = 'S',
            ic_mes_fechado = 'S',
            ic_mes_fechado_reserva = @ic_fechamento_reserva
	where 
            cd_ano = year(@dt_inicial) and cd_mes = month(@dt_inicial)
    else
      insert into fechamento_mensal (cd_ano, cd_mes, ic_mes_fechado, ic_mes_fechado_reserva,
        ic_sce, ic_scp, ic_scr, cd_usuario, dt_usuario)
      values (year(@dt_inicial), month(@dt_inicial), 'S',
        @ic_fechamento_reserva, 'S', 'N', 'N', @cd_usuario, getdate())
  end

end

---------------------------------------------------------------------------
-- ********** PREENCHIMENTO DAS TABELAS DE PRODUTO  COM AS ************* --
--                 MOVIMENTAÇÕES DE ESTOQUE REAL                         --
---------------------------------------------------------------------------

if (@ic_debug = 'S') 
  print ('Gerando Produto_Fechamento')

-- ELIAS 01/02/2005
if ((@ic_parametro = 1) or (@ic_parametro = 3) or (@ic_parametro = 6)) 
  exec pr_fechamento_saldo_real @ic_parametro     = @ic_parametro, 
                                @dt_inicial       = @dt_inicial,
                                @dt_final         = @dt_final,
                                @cd_produto       = @cd_produto,
                                @cd_grupo_produto = @cd_grupo_produto,
                                @cd_serie_produto = @cd_serie_produto,
                                @cd_usuario       = @cd_usuario

if (@ic_debug = 'S') 
  print ('Produto_Fechamento Gerado')

-------------------------------------------------------------------------------
-- FECHAMENTO DOS SALDOS DA RESERVA
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- FLUXO DO FECHAMENTO DE ESTOQUE
-------------------------------------------------------------------------------

-- 
--   O FECHAMENTO DE ESTOQUE É DIVIDIDO NAS SEGUINTES FASES:
-- 
--   A) PEDIDO DE VENDA NORMAL 
--   B) PEDIDOS DE VENDA ESPECIAIS (PRODUTOS DA PEDIDO_VENDA_COMPOSICAO)
--   C) PEDIDOS DE VENDA COM OM (PRODUTO UTILIZADO NA OM)
--   D) REQUISIÇÃO INTERNA
--   E) OP SEM PEDIDO DE VENDA
--   F) OP COM PEDIDO DE VENDA
--   G) PROGRAMAÇÃO DE ENTREGA QUE NÃO FOI TRANSFORMADA EM PEDIDO DE VENDA
--   H) PEDIDOS DE KIT PRECISAM RESERVAR A COMPOSICAO ( PRODUTO_COMPOSICAO )
--
-- 
--   TODAS ESSAS FASES ALIMENTAM A TABELA TEMPORÁRIA #MOVIMENTO_RESERVA
--   E APÓS ESSE PROCESSO ESTA TABELA É LIDA PARA A GERAÇÃO DE RESERVA
--   DOS COMPONENTES DOS PRODUTOS NELA INDICADOS QUANDO O FLAG 
--   IC_MOVIMENTA_COMPOSICAO = S.
-- 

-- VERIFICANDO SE MOVIMENTO DE RESERVA JÁ FOI FECHADO
-- SE FOI NÃO EXECUTAR O FECHAMENTO
-- DOS MOVIMENTOS DE RESERVA

if @ic_fechamento_reserva = 'N'
begin

  --INDICANDO QUE RESERVA SERÁ FECHADA
  set @ic_fechamento_reserva = 'S'

  ---------------------------------------------------------------------------
  -- PRODUTOS CONSTANTES DE NOTA FISCAL DE PEDIDOS DO PERÍODO DE FECHAMENTO -
  -- MAS QUE PODEM TER SIDO FATURADOS APÓS O FECHAMENTO. CONSIDERAR ESSAS  --
  -- QUANTIDADES PARA GERAÇÃO DE RESERVA                                   --
  ---------------------------------------------------------------------------

  select 
    nsi.cd_pedido_venda, 
    nsi.cd_item_pedido_venda, 
    isnull(nsi.qt_item_nota_saida,0) as qt_item_nota_saida
  into #Nota_Saida
  from Nota_Saida_Item nsi           with (nolock) 
       inner join      Nota_Saida ns with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida
       left outer join Produto p     with (nolock) on p.cd_produto      = nsi.cd_produto 
  where
         ns.dt_nota_saida > @dt_final and
        ((@ic_parametro = 1) or 
         ((@ic_parametro = 3) and (isnull(p.cd_grupo_produto, nsi.cd_grupo_produto) = @cd_grupo_produto)) or
         ((@ic_parametro = 6) and (p.cd_produto = @cd_produto)))

  -- Index Temporário
  create INDEX Temp_PK_Nota_Saida on #Nota_Saida (cd_pedido_venda, cd_item_pedido_venda)

  ---------------------------------------------------------------------------
  -- PROCESSO DE ALIMENTAÇÃO DA TABELA TEMPORÁRIA #MOVIMENTO_RESERVA       --
  -- INÍCIO !!!                                                            --
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  --  *************** PEDIDOS DE VENDA   ********************************* --
  ---------------------------------------------------------------------------

  -- CRIAÇÃO DA TABELA COM OS MOVIMENTOS DE ESTOQUE DE RESERVA

  if (@ic_debug = 'S')
    print('Movimento_Reserva - Armazenando Pedidos de Venda')

  select 
    identity(int, 1, 1)         		as codigo,
    0                           		as cd_movimento_estoque, 
    --Se data de fechamento do pedido for maior que data final colocar no movimento
    --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
    @dt_dia_util_mes_seguinte                   as dt_movimento_estoque,
    2                           		as cd_tipo_movimento_estoque,
    cast(pv.cd_pedido_venda as varchar)         as cd_documento_movimento,
    cast(pvi.cd_item_pedido_venda as int) 	as cd_item_documento,
    7 		                                as cd_tipo_documento_estoque, 
    pv.dt_pedido_venda 		                as dt_documento_movimento,
    0      		                        as cd_centro_custo, 
    (IsNull(pvi.qt_saldo_pedido_venda, 0) + isnull(ns.qt_item_nota_saida,0)) as qt_movimento_estoque,
    pvi.vl_unitario_item_pedido 		as vl_unitario_movimento,
    (pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) as vl_total_movimento, 
    'S'                         		as ic_peps_movimento_estoque, 
    'N'                         		as ic_terceiro_movimento, 
    'PV ' + cast(pv.cd_pedido_venda as varchar) + ' It. ' + cast(pvi.cd_item_pedido_venda as varchar) + ' - Fechamento '+ cast(month(@dt_final) as varchar) + '/' + cast(year(@dt_final) as varchar) as nm_historico_movimento, 
    'S'                         		as ic_mov_movimento, 
    1                           		as cd_tipo_destinatario,
    pv.cd_cliente               		as cd_fornecedor,
    --cast(null as varchar(40))   		as nm_destinatario,
    cast(isnull(c.nm_fantasia_cliente,'') as varchar(40)) as nm_destinatario,
    0     		                                  as cd_origem_baixa_produto,
    isnull(bx.cd_produto, pvi.cd_produto)                 as cd_produto, 
    case when (isnull(bx.cd_produto,0) = 0) 
      then isnull(p.cd_fase_produto_baixa, @cd_fase_produto)
      else isnull(bx.cd_fase_produto_baixa, @cd_fase_produto)
    end                                                   as cd_fase_produto, 
    'N'                                		          as ic_fase_entrada_movimento, 
    0 		                                          as cd_fase_produto_entrada, 
    @cd_usuario                 		          as cd_usuario, 
    Getdate()                   	 	          as dt_usuario,
    @ic_gera_reserva_estrutura		                  as ic_movimenta_composicao      

  into
    #Movimento_Reserva

  from
    Pedido_Venda      pv  with (NOLOCK) inner join
    Pedido_Venda_Item pvi with (NOLOCK) on pv.cd_pedido_venda      = pvi.cd_pedido_venda left outer join
    #Nota_Saida       ns  with (NOLOCK) on ns.cd_pedido_venda      = pvi.cd_pedido_venda and
                                           ns.cd_item_pedido_venda = pvi.cd_item_pedido_venda left outer join
    Produto           p   with (NOLOCK) on pvi.cd_produto = p.cd_produto left outer join
    Produto           bx  with (NOLOCK) on bx.cd_produto = p.cd_produto_baixa_estoque left outer join
    Tipo_Pedido       tp  with (NOLOCK) on pv.cd_tipo_pedido = tp.cd_tipo_pedido      left outer join
    Cliente           c   with (NOLOCK) on c.cd_cliente      = pv.cd_cliente
    
  where
    --Pegando somente pedidos que foram fechados até a data final
    isnull(pv.dt_fechamento_pedido,pv.dt_pedido_venda)  <= @dt_final and
    pv.dt_pedido_venda                                  <= @dt_final and
    --Trazer somente pedidos que a data de fechamento não seja nula
    pv.dt_fechamento_pedido  is not null and
    --Trazer somente pedidos que tenham saldo a faturar
    ((IsNull(pvi.qt_saldo_pedido_venda, 0) + isnull(ns.qt_item_nota_saida,0)) > 0) and
    --Trazer somente pedidos que não foram cancelados
    -- ELIAS 12/07/2005 - Buscar os PVs que não estavam cancelados na Data do Fechamento
    ((pvi.dt_cancelamento_item is null) or (pvi.dt_cancelamento_item > @dt_final)) and
    --Somente produtos padronizados
    isnull(pvi.cd_produto,0) > 0 and
    --Trazer somente pedidos que o tipo movimenta o estoque
    isnull(tp.ic_sce_tipo_pedido,'N')    = 'S' and
    --Não trazer "KITS" gerados pelo módulo de gestão de Caixa - Eduardo 01/04/2004
    isnull(pvi.ic_montagem_item_pedido,'N') <> 'S' and
    ((@ic_parametro = 1) or 
     ((@ic_parametro = 3) and (isnull(p.cd_grupo_produto, pvi.cd_grupo_produto) = @cd_grupo_produto)) or
     ((@ic_parametro = 6) and (p.cd_produto = @cd_produto)))

  --select * from #movimento_reserva
  --select ic_montagem_item_pedido,* from pedido_venda_item where cd_pedido_venda = 40889

  -- Indexar para ficar mais rápido o UPDATE lá em baixo
  create INDEX Temp_PK_Movimento_Reserva on #Movimento_Reserva (codigo)

  if (@ic_debug = 'S')
    print('Movimento_Reserva - Pedidos Armazenados')

  ---------------------------------------------------------------------------
  -- **************  PEDIDOS DE VENDA ESPECIAIS       ******************** --
  ---------------------------------------------------------------------------

  --Buscando produtos utilizados na composição de itens especiais que possuem saldo a faturar
  if (@ic_debug = 'S')
    print('Pedidos Especial - Armazenando Registros')

  insert into #Movimento_Reserva (cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque,
    cd_documento_movimento, cd_item_documento, cd_tipo_documento_estoque, dt_documento_movimento,
    cd_centro_custo, qt_movimento_estoque, vl_unitario_movimento, vl_total_movimento, ic_peps_movimento_estoque, 
    ic_terceiro_movimento, nm_historico_movimento, ic_mov_movimento, cd_tipo_destinatario, cd_fornecedor,
    nm_destinatario, cd_origem_baixa_produto, cd_produto, cd_fase_produto, ic_fase_entrada_movimento, 
    cd_fase_produto_entrada, cd_usuario, dt_usuario, ic_movimenta_composicao )
  select
    0,
    --Se data de fechamento do pedido for maior que data final colocar no movimento
    --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
    @dt_dia_util_mes_seguinte,
    2,
    pv.cd_pedido_venda, 
    pvi.cd_item_pedido_venda,
    7,
    pv.dt_pedido_venda,
    0, 
    case when @ic_multiplica_componente = 'S' then
      ((IsNull(pvi.qt_saldo_pedido_venda, 0) + isnull(ns.qt_item_nota_saida,0)) * pvc.qt_item_produto_comp)
      --(IsNull(pvi.qt_saldo_pedido_venda, 0) * pvc.qt_item_produto_comp)
    else pvc.qt_item_produto_comp end,
    0, 0, 'S', 'N', 
    'PV ' + cast(pv.cd_pedido_venda as varchar(20)) + ' It. ' + cast(pvi.cd_item_pedido_venda as varchar) + ' - Fechamento '+ cast(month(@dt_final) as varchar) + '/' + cast(year(@dt_final) as varchar), 
    'S',
     1,
     pv.cd_cliente,
     c.nm_fantasia_cliente,
     0,
     isnull(bx.cd_produto, pvc.cd_produto), pvc.cd_fase_produto, 'N', 0, @cd_usuario, getdate(), 'S'
  from
    Pedido_Venda pv       with (NOLOCK) inner join
    Pedido_Venda_Item pvi with (NOLOCK)        on pv.cd_pedido_venda = pvi.cd_pedido_venda inner join
    Tipo_Pedido tp        with (NOLOCK)        on pv.cd_tipo_pedido = tp.cd_tipo_pedido inner join 
    Pedido_Venda_Composicao pvc with (NOLOCK)  on pv.cd_pedido_venda = pvc.cd_pedido_venda and 
                                                  pvi.cd_item_pedido_venda = pvc.cd_item_pedido_venda inner join
    Produto p      with (NOLOCK) on p.cd_produto = pvc.cd_produto left outer join
    Produto bx     with (NOLOCK) on p.cd_produto_baixa_estoque = bx.cd_produto left outer join
    #Nota_Saida ns with (NOLOCK) on ns.cd_pedido_venda = pvi.cd_pedido_venda and
                                    ns.cd_item_pedido_venda = pvi.cd_item_pedido_venda      
    left outer join cliente c on c.cd_cliente = pv.cd_cliente
  where
    --Trazer somente pedidos que tenham saldo a faturar, ou tinham saldo a 
    --Faturar no dia do Fechamento - ELIAS 31/01/05
    ((IsNull(pvi.qt_saldo_pedido_venda, 0) + isnull(ns.qt_item_nota_saida,0)) > 0) and
    --Trazer somente pedidos que não foram cancelados
    -- ELIAS 12/07/2005 - Buscar os PVs que não estavam cancelados na Data do Fechamento
    ((pvi.dt_cancelamento_item is null) or  
     (pvi.dt_cancelamento_item > @dt_final)) and
    --Trazer somente pedidos que o tipo movimenta o estoque
    isnull(tp.ic_sce_tipo_pedido, 'S') = 'S' and
    --Trazer somente pedidos que a data de fechamento não seja nula
    pv.dt_fechamento_pedido  is not null and
    --Somente produtos especiais ou "KITS" gerados pelo módulo de gestão de Caixa - Eduardo 01/04/2004
    ((isnull(pvi.cd_produto,0) = 0) or (isnull(pvi.ic_montagem_item_pedido,'N') = 'S')) and
    --Pegando somente pedidos que foram fechados até a data final
    pv.dt_fechamento_pedido  <= @dt_final and
    pv.dt_pedido_venda       <= @dt_final and
    ((@ic_parametro = 1) or 
     ((@ic_parametro = 3) and (isnull(isnull(bx.cd_grupo_produto, p.cd_grupo_produto), pvi.cd_grupo_produto) = @cd_grupo_produto)) or
     ((@ic_parametro = 6) and (isnull(bx.cd_produto, p.cd_produto) = @cd_produto)))
  order by
    1

  if (@ic_debug = 'S')
    print('Pedidos Especial - Registros Armazenandos')


  ---------------------------------------------------------------------------
  -- ************ PEDIDOS DE VENDA COM OM  ******************************* --
  ---------------------------------------------------------------------------

  --Buscando produtos em ordens de montagem para serem reservados
  if (@ic_debug = 'S')
    print('OM - Armazenando Registros')

  insert into #Movimento_Reserva (cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque,
    cd_documento_movimento, cd_item_documento, cd_tipo_documento_estoque, dt_documento_movimento,
    cd_centro_custo, qt_movimento_estoque, vl_unitario_movimento, vl_total_movimento, ic_peps_movimento_estoque, 
    ic_terceiro_movimento, nm_historico_movimento, ic_mov_movimento, cd_tipo_destinatario, cd_fornecedor,
    nm_destinatario, cd_origem_baixa_produto, cd_produto, cd_fase_produto, ic_fase_entrada_movimento, 
    cd_fase_produto_entrada, cd_usuario, dt_usuario, ic_movimenta_composicao )
  select 
    0,
    --Se data de fechamento do pedido for maior que data final colocar no movimento
    --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
    @dt_dia_util_mes_seguinte, 2, pv.cd_pedido_venda, pvi.cd_item_pedido_venda, 7, pv.dt_pedido_venda,
    0, omc.qt_item_om, 0, 0, 'S', 'N', 
    'PV ' + cast(pv.cd_pedido_venda as varchar(20)) + ' It. ' + cast(pvi.cd_item_pedido_venda as varchar) + ' - Fechamento '+ cast(month(@dt_final) as varchar) + '/' + cast(year(@dt_final) as varchar), 
    'S', 1, pv.cd_cliente,
    c.nm_fantasia_cliente,
    0,
    isnull(bx.cd_produto, omc.cd_produto),
    case when isnull(bx.cd_produto,0) = 0 
      then isnull(p.cd_fase_produto_baixa, @cd_fase_produto)
      else isnull(bx.cd_fase_produto_baixa, @cd_fase_produto)
    end,
    'N', 0, @cd_usuario, getdate(), 'N'
 from
    Pedido_Venda      pv  with (NOLOCK) inner join
    Pedido_Venda_Item pvi with (NOLOCK) on pv.cd_pedido_venda = pvi.cd_pedido_venda inner join       
    Tipo_Pedido       tp  with (NOLOCK) on pv.cd_tipo_pedido = tp.cd_tipo_pedido    inner join
    om                om  with (NOLOCK) on pv.cd_pedido_venda = om.cd_pedido_venda and pvi.cd_item_pedido_venda = om.cd_item_pedido_venda inner join
    om_composicao     omc with (NOLOCK) on om.cd_om = omc.cd_om left outer join
    Produto           p   with (NOLOCK) on p.cd_produto = omc.cd_produto left outer join
    Produto           bx  with (NOLOCK) on p.cd_produto_baixa_estoque = bx.cd_produto left outer join
    #Nota_Saida       ns  with (NOLOCK) on pvi.cd_pedido_venda = ns.cd_pedido_venda and
                                           pvi.cd_item_pedido_venda = ns.cd_item_pedido_venda
    left outer join cliente c on c.cd_cliente = pv.cd_cliente

  where
    --Trazer somente pedidos que tenham saldo a faturar
    ((isnull(pvi.qt_saldo_pedido_venda, 0) + isnull(ns.qt_item_nota_saida,0)) > 0) and
    --Trazer somente pedidos que não foram cancelados
    -- ELIAS 12/07/2005 - Buscar os PVs que não estavam cancelados na Data do Fechamento
    ((pvi.dt_cancelamento_item is null) or  
     (pvi.dt_cancelamento_item > @dt_final)) and
    --Trazer somente pedidos que o tipo movimenta o estoque
    isnull(tp.ic_sce_tipo_pedido, 'S') = 'S' and
    --Trazer somente pedidos que a data de fechamento não seja nula
    pv.dt_fechamento_pedido  is not null and
    --Pegando somente pedidos que foram fechados até a data final
    pv.dt_fechamento_pedido  <= @dt_final and
    pv.dt_pedido_venda       <= @dt_final and
    ((@ic_parametro = 1) or 
     ((@ic_parametro = 3) and (isnull(isnull(bx.cd_grupo_produto, p.cd_grupo_produto), pvi.cd_grupo_produto) = @cd_grupo_produto)) or
     ((@ic_parametro = 6) and (isnull(bx.cd_produto, p.cd_produto) = @cd_produto)))
  order by
    1    

  if (@ic_debug = 'S')
    print('OM - Registros Armazenados')
  
  ---------------------------------------------------------------------------
  --  ***************** REQUISIÇÃO INTERNA *****************************   --
  ---------------------------------------------------------------------------

  --Buscando produtos nas requisições internas para serem reservados

  if (@ic_debug = 'S')
    print('Requisicao Interna - Armazenando Registros')

  insert into #Movimento_Reserva (cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque,
    cd_documento_movimento, cd_item_documento, cd_tipo_documento_estoque, dt_documento_movimento,
    cd_centro_custo, qt_movimento_estoque, vl_unitario_movimento, vl_total_movimento, 
    ic_peps_movimento_estoque, ic_terceiro_movimento, nm_historico_movimento, ic_mov_movimento, 
    cd_tipo_destinatario, cd_fornecedor, nm_destinatario, cd_origem_baixa_produto, cd_produto, 
    cd_fase_produto, ic_fase_entrada_movimento, cd_fase_produto_entrada, cd_usuario, dt_usuario,
    ic_movimenta_composicao )
  select 
     0,
    --Se data de fechamento do pedido for maior que data final colocar no movimento
    --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
    @dt_dia_util_mes_seguinte, 2, cast(r.cd_requisicao_interna as varchar),
    ri.cd_item_req_interna,
    5, 
    r.dt_requisicao_interna, 0, IsNull(ri.qt_item_req_interna, isnull(ri.qt_item_requisicao,0)),
    0, 0, 'S', 'N', 
    'RI ' + cast(r.cd_requisicao_interna as varchar(20)) + ' It. ' + cast(cd_item_req_interna as varchar) + ' - Fechamento '+ cast(month(@dt_final) as varchar) + '/' + cast(year(@dt_final) as varchar), 
    'S', 7, r.cd_departamento, '', 0, isnull(bx.cd_produto, ri.cd_produto), ri.cd_fase_produto, 'N', 0, @cd_usuario, getdate(), 'N'       
  from
    Requisicao_Interna r                  with (NOLOCK)
    inner join Requisicao_Interna_Item ri with (NOLOCK) on r.cd_requisicao_interna    = ri.cd_requisicao_interna 
    inner join Produto p                  with (nolock) on p.cd_produto               = ri.cd_produto
    left outer join Produto bx            with (nolock) on p.cd_produto_baixa_estoque = bx.cd_produto
  where
    --Trazer somente requisições que não foram baixadas
    IsNull(ri.ic_estoque_req_interna,'N') = 'N' and
    --Pegando somente requisições que foram emitidas até a data final
    r.dt_requisicao_interna <= @dt_final and
    ((@ic_parametro = 1) or 
     ((@ic_parametro = 3) and (isnull(bx.cd_grupo_produto, p.cd_grupo_produto) = @cd_grupo_produto)) or
     ((@ic_parametro = 6) and (isnull(bx.cd_produto, p.cd_produto) = @cd_produto)))
  order by
    1    

  if (@ic_debug = 'S')
    print('Requisicao Interna - Registros Armazenados')
    
  ---------------------------------------------------------------------------
  -- *****     PROCESSOS DE FABRICAÇÃO SEM PEDIDOS DE VENDA   ***********  --
  ---------------------------------------------------------------------------

  --Buscando produtos nos processo de producao para serem reservados
  if (@ic_debug = 'S')
    print('Processos de Fabricação s/ Pedido de Venda - Armazenando Registros')

  insert into #Movimento_Reserva (cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque,
    cd_documento_movimento, cd_item_documento, cd_tipo_documento_estoque, dt_documento_movimento,
    cd_centro_custo, qt_movimento_estoque, vl_unitario_movimento, vl_total_movimento, ic_peps_movimento_estoque, 
    ic_terceiro_movimento, nm_historico_movimento, ic_mov_movimento, cd_tipo_destinatario,
    cd_fornecedor, nm_destinatario, cd_origem_baixa_produto, cd_produto, cd_fase_produto, 
    ic_fase_entrada_movimento, cd_fase_produto_entrada, cd_usuario, dt_usuario, ic_movimenta_composicao )
  select 
    0,
    --Se data de fechamento do pedido for maior que data final colocar no movimento
    --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
    @dt_dia_util_mes_seguinte, 2, pc.cd_processo, pc.cd_componente_processo, 12, pp.dt_processo,
    0,
--    pc.qt_comp_processo, 

      ((pp.qt_planejada_processo- (select
                                     sum( isnull(ppa.qt_peca_boa_apontamento,0) ) 
                                   from 
                                     processo_producao_apontamento ppa with (nolock) 
                                   where 
                                     isnull(ppa.ic_movimenta_estoque,'N') = 'S' and
                                     ppa.cd_processo = pp.cd_processo
                                     and ppa.dt_processo_apontamento<=@dt_final ) )
      *
      (pc.qt_comp_processo/pp.qt_planejada_processo)),

    0,
    0,
    'S',
    'N', 
    'Processo ' + cast(pc.cd_processo as varchar(20)) + ' It. ' + cast(pc.cd_componente_processo as varchar) + ' - Fechamento '+ cast(month(@dt_final) as varchar) + '/' + cast(year(@dt_final) as varchar), 
    'S', 7, 0, '', 0, isnull(bx.cd_produto, pc.cd_produto), pc.cd_fase_produto, 'N', 0, @cd_usuario, getdate(), 'N'

  from
    Processo_Producao_Componente pc with (NOLOCK) left outer join
    Processo_Producao pp            with (NOLOCK) on pc.cd_processo             = pp.cd_processo left outer join
    Produto p                       with (NOLOCK) on pc.cd_produto              = p.cd_produto left outer join
    Produto bx                      with (nolock) on p.cd_produto_baixa_estoque = bx.cd_produto

  where
    --Não pode estar Cancelada
    pp.dt_canc_processo is null     and  
    --Somente OP's que não estão Encerradas
    ( isnull(pp.cd_status_processo,0) <> 5 or ( pp.cd_status_processo = 5 and pp.dt_fimprod_processo > @dt_final )) and  
    --Trazer somente os processos que não foram baixados
    IsNull(pc.ic_estoque_processo,'N') = 'S' and
    --Se a flag estoque = S e a data fim = null - Produto reservado
    ( pp.dt_fimprod_processo is null or pp.dt_fimprod_processo > @dt_final ) and      
    --Processos que não façam parte de pedido de venda
    ( pp.cd_pedido_venda is null ) and
    --Verifica se o produto é de produção
    -- Comentado por não estar fazendo a mesma validação no processo de fabricação.
    --      ( IsNull(p.ic_producao_produto,'N') = 'S') and
    --Pegando somente requisições que foram emitidas até a data final
    ( pp.dt_processo <= @dt_final ) and
    ((@ic_parametro = 1) or 
     ((@ic_parametro = 3) and (isnull(bx.cd_grupo_produto, p.cd_grupo_produto) = @cd_grupo_produto)) or
     ((@ic_parametro = 6) and (isnull(bx.cd_produto, p.cd_produto) = @cd_produto)))
  order by
    1    

  if (@ic_debug = 'S')
    print('Processos de Fabricação s/ Pedido de Venda - Registros Armazenados')

  ---------------------------------------------------------------------------
  -- *****     PROGRAMAÇÃO DE ENTREGA SEM PEDIDO DE VENDA     ***********  --
  ---------------------------------------------------------------------------

  --Buscando produtos nos processo de producao para serem reservados
  if (@ic_debug = 'S')
    print('Programação de Entrega s/ Pedido de Venda - Armazenando Registros')

  insert into #Movimento_Reserva 
   (cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque,
    cd_documento_movimento, cd_item_documento, cd_tipo_documento_estoque, dt_documento_movimento,
    cd_centro_custo, qt_movimento_estoque, vl_unitario_movimento, vl_total_movimento, ic_peps_movimento_estoque, 
    ic_terceiro_movimento, nm_historico_movimento, ic_mov_movimento, cd_tipo_destinatario,
    cd_fornecedor, nm_destinatario, cd_origem_baixa_produto, cd_produto, cd_fase_produto, 
    ic_fase_entrada_movimento, cd_fase_produto_entrada, cd_usuario, dt_usuario, ic_movimenta_composicao )

  --select * from programacao_entrega

  select 
    0,
    --Se data de fechamento do pedido for maior que data final colocar no movimento
    --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
    @dt_dia_util_mes_seguinte, 
    2,
    pe.cd_programacao_entrega,
    1, 
    12,
    pe.dt_programacao_entrega,
    0, pe.qt_saldo_programacao, 0, 0, 'S', 'N', 
    'Prog.Entrega ' + cast(pe.cd_programacao_entrega as varchar(20)) + ' It.' + cast(p.nm_fantasia_produto as varchar(25)) + ' - Fechamento '+ cast(month(@dt_final) as varchar) + '/' + cast(year(@dt_final) as varchar), 
    'S', 1, c.cd_cliente, 
    c.nm_fantasia_cliente, 0, isnull(bx.cd_produto, pe.cd_produto), p.cd_fase_produto_baixa, 'N', 0, @cd_usuario,
    getdate(), 'N'
  from
    Programacao_Entrega pe               with (NOLOCK) 
    left outer join Produto p            with (NOLOCK) on p.cd_produto               = pe.cd_produto 
    left outer join Produto bx           with(nolock)  on p.cd_produto_baixa_estoque = bx.cd_produto
    left outer join cliente c                          on c.cd_cliente = pe.cd_cliente

  where
    --Trazer somente as programações com Saldo/ que não foram baixados
    isnull(pe.qt_saldo_programacao,0)>0   and
    pe.dt_cancelamento_programacao is null and
    isnull(pe.cd_processo,0) = 0          and
    --Processos que não façam parte de pedido de venda
    ( isnull(pe.cd_pedido_venda,0) = 0  ) and
    ( pe.dt_programacao_entrega <= @dt_final ) and
    ((@ic_parametro = 1) or 
     ((@ic_parametro = 3) and (isnull(bx.cd_grupo_produto, p.cd_grupo_produto) = @cd_grupo_produto)) or
     ((@ic_parametro = 6) and (isnull(bx.cd_produto, p.cd_produto) = @cd_produto)))
  order by
    1    

  --select * from programacao_entrega

  if (@ic_debug = 'S')
    print('Processos de Fabricação s/ Pedido de Venda - Registros Armazenados')

  ---------------------------------------------------------------------------
  -- *****     PROCESSOS DE FABRICAÇÃO COM PEDIDOS DE VENDA   ***********  --
  ---------------------------------------------------------------------------

  --Buscando produtos nos processo de producao para serem reservados
  if (@ic_debug = 'S')
    print('Processos de Producao c/ Pedido de Venda ')

  -- ESTE PROCESSO SOMENTE É NECESSÁRIO PARA OS CLIENTES QUE NÃO GERAM ESTRUTURA
  -- DIRETAMENTE PELO PEDIDO DE VENDA E SIM PELO PRODUTO - ELIAS 

  if (@ic_gera_reserva_estrutura = 'N')
  begin 

    insert into #Movimento_Reserva (cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque,
      cd_documento_movimento, cd_item_documento, cd_tipo_documento_estoque, dt_documento_movimento,
      cd_centro_custo, qt_movimento_estoque, vl_unitario_movimento, vl_total_movimento, ic_peps_movimento_estoque, 
      ic_terceiro_movimento, nm_historico_movimento, ic_mov_movimento, cd_tipo_destinatario, cd_fornecedor,
      nm_destinatario, cd_origem_baixa_produto, cd_produto, cd_fase_produto, ic_fase_entrada_movimento, 
      cd_fase_produto_entrada, cd_usuario, dt_usuario, ic_movimenta_composicao )
    select 
      0,
      --Se data de fechamento do pedido for maior que data final colocar no movimento
      --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
      @dt_dia_util_mes_seguinte, 2, pc.cd_processo, pc.cd_componente_processo,
      12, pp.dt_processo, 0, 
      ((pp.qt_planejada_processo- (select
                                     sum( isnull(ppa.qt_peca_boa_apontamento,0) ) 
                                   from 
                                     processo_producao_apontamento ppa with (nolock) 
                                   where 
                                     isnull(ppa.ic_movimenta_estoque,'N') = 'S' and
                                     ppa.cd_processo = pp.cd_processo
                                     and ppa.dt_processo_apontamento<=@dt_final ) )
      *
      (pc.qt_comp_processo/pp.qt_planejada_processo))
      
      , 

--Temos que fazer uma rotina para deduzir as quantidade no apontamento quando existir produção parcial
--(ppc.qt_comp_processo / pp.qt_planejada_processo) as 'QtdeProcessoPadrao'
--
--
-- select
--   sum( isnull(ppa.qt_peca_boa_apontamento,0) ) 
-- from 
--   processo_producao_apontamento ppa with (nolock) 
-- where 
--   isnull(ppa.ic_movimenta_estoque,'N') = 'S' and
--   ppa.cd_processo = pp.cd_processo
--   and ppa.dt_processo_apontamento<=@dt_final


      0,
      0, 'S', 'N', 
      'Processo ' + cast(pc.cd_processo as varchar(20)) + ' It. ' + cast(pc.cd_componente_processo as varchar) + ' - Fechamento '+ cast(month(@dt_final) as varchar) + '/' + cast(year(@dt_final) as varchar), 
      'S', 1,c.cd_cliente,
       c.nm_fantasia_cliente,
       0,	isnull(bx.cd_produto, pc.cd_produto), pc.cd_fase_produto, 'N', 0, @cd_usuario, getdate(), 'N'
    from
      Processo_Producao_Componente pc with(nolock) left outer join
      Processo_Producao pp            with(nolock) on pc.cd_processo             = pp.cd_processo left outer join
      Produto p                       with(nolock) on pc.cd_produto              = p.cd_produto   left outer join
      Produto bx                      with(nolock) on p.cd_produto_baixa_estoque = bx.cd_produto
      left outer join cliente c       with(nolock) on c.cd_cliente               = pp.cd_cliente

    where
      --Não pode estar Cancelada
      pp.dt_canc_processo is null     and  
      --Somente OP's que não estão Encerradas
      ( isnull(pp.cd_status_processo,0) <> 5 or ( pp.cd_status_processo = 5 and pp.dt_fimprod_processo > @dt_final )) and  

      --isnull(pp.cd_status_processo,0) <> 5 and

      --Trazer somente os processos que não foram baixados
      isNull(ic_estoque_processo,'N') = 'S' and
    	--Se a flag estoque = S e a data fim = null - Produto reservado
    	( ( pp.dt_fimprod_processo is null ) or ( pp.dt_fimprod_processo > @dt_final) ) and      
    	--Processos que façam parte de pedido de venda
    	( pp.cd_pedido_venda is not null ) and

    	--Verifica se o produto é de produção
    	-- Comentado por não estar fazendo a mesma validação no processo de fabricação.
        -- ( IsNull(p.ic_producao_produto,'N') = 'S') and
    	--Pegando somente requisições que foram emitidas até a data final
    	( pp.dt_processo <= @dt_final ) and
      ((@ic_parametro = 1) or 
       ((@ic_parametro = 3) and (isnull(bx.cd_grupo_produto, p.cd_grupo_produto) = @cd_grupo_produto)) or
       ((@ic_parametro = 6) and (isnull(bx.cd_produto, p.cd_produto) = @cd_produto)))
    order by
    	1    

    --select * from processo_producao
	
  end

  ---------------------------------------------------------------------------
  --  *******  RESERVA DE COMPONENTES DE PRODUTOS PRINCIPAIS       ********** 
  ---------------------------------------------------------------------------

  if (@ic_debug = 'S')
    print('Reserva dos Componentes de Produto Principal')

  declare cReserva_Composicao cursor for
  select m.cd_produto, m.qt_movimento_estoque, m.dt_movimento_estoque, m.cd_documento_movimento, 
    m.cd_item_documento, m.dt_documento_movimento, m.cd_fornecedor
  from #Movimento_Reserva m Left outer join
       Produto p on m.cd_produto = p.cd_produto
  where m.ic_movimenta_composicao = 'S'
   
  open cReserva_Composicao
  fetch next from cReserva_Composicao into @cd_produto_composicao, @qt_produto_composicao, @dt_fechamento_pedido, 
                                           @cd_pedido_venda, @cd_item_pedido_venda, @dt_pedido_venda, @cd_cliente

  while (@@FETCH_STATUS = 0)
  begin      
    if exists(select '1' from fn_composicao_produto(@cd_produto_composicao))
    begin
       
      --Declarando cursor para buscar a composição
      if (@ic_debug = 'S')
        print('cReserva_Comp_Movimento - Declarando cursor para buscar a composição')

      declare cReserva_Comp_Movimento cursor for
      select cd_produto_pai, isnull(bx.cd_produto, fn.cd_produto) as cd_produto, qt_produto_composicao,
        cd_fase_produto, isnull(bx.nm_fantasia_produto, fn.nm_fantasia_produto) as nm_fantasia_produto
      from fn_composicao_produto(@cd_produto_composicao) fn inner join
        Produto p on p.cd_produto = fn.cd_produto left outer join
        Produto bx on p.cd_produto_baixa_estoque = bx.cd_produto
   
      if (@ic_debug = 'S')
        print('cReserva_Comp_Movimento - Varrendo registros')

      open cReserva_Comp_Movimento
      fetch next from cReserva_Comp_Movimento into 
        @cd_produto_pai_reserva, @cd_produto_reserva, @qt_produto_reserva, 
        @cd_fase_produto_reserva, @nm_fantasia_produto

      while (@@FETCH_STATUS = 0)
      begin

        insert into #Movimento_Reserva
          (cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque,
          cd_documento_movimento, cd_item_documento, cd_tipo_documento_estoque, 
          dt_documento_movimento, cd_centro_custo, qt_movimento_estoque, vl_unitario_movimento,
          vl_total_movimento, ic_peps_movimento_estoque, ic_terceiro_movimento, 
          nm_historico_movimento, ic_mov_movimento, cd_tipo_destinatario, cd_fornecedor,
          nm_destinatario, cd_origem_baixa_produto, cd_produto, cd_fase_produto, 
          ic_fase_entrada_movimento, cd_fase_produto_entrada, cd_usuario, dt_usuario)
        values(
          0,
          --Se data de fechamento do pedido for maior que data final colocar no movimento
          --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
          @dt_dia_util_mes_seguinte, 2, cast(@cd_pedido_venda as varchar), @cd_item_pedido_venda,
          7, @dt_pedido_venda, 0, (@qt_produto_composicao * @qt_produto_reserva),
          0, 0, 'S', 'N', 
          'PV ' + cast(@cd_pedido_venda as varchar) + ' It. ' + cast(@cd_item_pedido_venda as varchar) + ' - Fechamento '+ cast(month(@dt_final) as varchar) + '/' + cast(year(@dt_final) as varchar), 
          'S', 1, @cd_cliente,
          '', 0, @cd_produto_reserva, @cd_fase_produto_reserva, 'N', 0, @cd_usuario, getdate())

        if (@ic_debug = 'S')
          print('cReserva_Comp_Movimento - '+cast(@cd_produto_pai_reserva as varchar))

        fetch next from cReserva_Comp_Movimento into @cd_produto_pai_reserva, @cd_produto_reserva, 
                                                     @qt_produto_reserva, @cd_fase_produto_reserva, @nm_fantasia_produto   
      end

      close cReserva_Comp_Movimento
      deallocate cReserva_Comp_Movimento

    end

    fetch next from cReserva_Composicao into @cd_produto_composicao, @qt_produto_composicao, 
                                             @dt_fechamento_pedido, @cd_pedido_venda, @cd_item_pedido_venda, 
                                             @dt_pedido_venda, @cd_cliente
  end        

  close cReserva_Composicao
  deallocate cReserva_Composicao

  -------------------------------------------------------------------------------
  --  *******  RESERVA DE COMPONENTES DE PRODUTOS PRINCIPAIS - KIT'S  ********** 
  -------------------------------------------------------------------------------

  if (@ic_debug = 'S')
    print('Reserva dos Componentes de Produto Principal - KITS')

  declare cReserva_Composicao cursor for
  select m.cd_produto, m.qt_movimento_estoque, m.dt_movimento_estoque, m.cd_documento_movimento, 
    m.cd_item_documento, m.dt_documento_movimento, m.cd_fornecedor
  from #Movimento_Reserva m 
       Left outer join Produto p   on m.cd_produto        = p.cd_produto
       inner join Grupo_Produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
  
  where 
        --m.ic_movimenta_composicao = 'S'
        --and
        isnull(gp.ic_kit_grupo_produto,'N')='S'

  --select * from #Movimento_Reserva

  --select * from grupo_produto
 
  open cReserva_Composicao
  fetch next from cReserva_Composicao into @cd_produto_composicao, @qt_produto_composicao, @dt_fechamento_pedido, 
                                           @cd_pedido_venda, @cd_item_pedido_venda, @dt_pedido_venda, @cd_cliente

  while (@@FETCH_STATUS = 0)
  begin      
    if exists(select '1' from fn_composicao_produto(@cd_produto_composicao))
    begin
       
      --Declarando cursor para buscar a composição
      if (@ic_debug = 'S')
        print('cReserva_Comp_Movimento - Declarando cursor para buscar a composição')

      declare cReserva_Comp_Movimento cursor for
      select  fn.cd_produto_pai, 
              isnull(bx.cd_produto, fn.cd_produto) as cd_produto, 
              fn.qt_produto_composicao,
              fn.cd_fase_produto, 
              isnull(bx.nm_fantasia_produto, p.nm_fantasia_produto) as nm_fantasia_produto
      from
          --fn_composicao_produto(@cd_produto_composicao) fn 
          produto_composicao fn      with (nolock)
          inner join Produto p       with (nolock, index(pk_produto)) on p.cd_produto    = fn.cd_produto_pai 
          inner join produto paux    with (nolock, index(pk_produto)) on paux.cd_produto = fn.cd_produto 
          left outer join Produto bx with (nolock, index(pk_produto)) on bx.cd_produto   = p.cd_produto_baixa_estoque
      where
        fn.cd_produto_pai = @cd_produto_composicao
        and fn.qt_produto_composicao>0 
        and fn.cd_versao_produto_comp = p.cd_versao_produto

        --and isnull(p.ic_baixa_composicao_prod,'N')='S' 

      if (@ic_debug = 'S')
        print('cReserva_Comp_Movimento - Varrendo registros')

      open cReserva_Comp_Movimento
      fetch next from cReserva_Comp_Movimento into 
        @cd_produto_pai_reserva, @cd_produto_reserva, @qt_produto_reserva, 
        @cd_fase_produto_reserva, @nm_fantasia_produto

      while (@@FETCH_STATUS = 0)
      begin

        insert into #Movimento_Reserva
          (cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque,
          cd_documento_movimento, cd_item_documento, cd_tipo_documento_estoque, 
          dt_documento_movimento, cd_centro_custo, qt_movimento_estoque, vl_unitario_movimento,
          vl_total_movimento, ic_peps_movimento_estoque, ic_terceiro_movimento, 
          nm_historico_movimento, ic_mov_movimento, cd_tipo_destinatario, cd_fornecedor,
          nm_destinatario, cd_origem_baixa_produto, cd_produto, cd_fase_produto, 
          ic_fase_entrada_movimento, cd_fase_produto_entrada, cd_usuario, dt_usuario)
        values(
          0,
          --Se data de fechamento do pedido for maior que data final colocar no movimento
          --a data do pedido de venda caso contrário colocar a data do 1º dia útil após a data final
          @dt_dia_util_mes_seguinte, 2, cast(@cd_pedido_venda as varchar), @cd_item_pedido_venda,
          7, @dt_pedido_venda, 0, (@qt_produto_composicao * @qt_produto_reserva),
          0, 0, 'S', 'N', 
          'PV ' + cast(@cd_pedido_venda as varchar) + ' It. ' + cast(@cd_item_pedido_venda as varchar) + ' - Fechamento '+ cast(month(@dt_final) as varchar) + '/' + cast(year(@dt_final) as varchar), 
          'S', 1, @cd_cliente, '', 0, @cd_produto_reserva, @cd_fase_produto_reserva, 'N', 0, @cd_usuario, getdate())

        if (@ic_debug = 'S')
          print('cReserva_Comp_Movimento - '+cast(@cd_produto_pai_reserva as varchar))

        fetch next from cReserva_Comp_Movimento into @cd_produto_pai_reserva, @cd_produto_reserva, 
                                                     @qt_produto_reserva, @cd_fase_produto_reserva, @nm_fantasia_produto   
      end

      close cReserva_Comp_Movimento
      deallocate cReserva_Comp_Movimento

    end

    fetch next from cReserva_Composicao into @cd_produto_composicao, @qt_produto_composicao, 
                                             @dt_fechamento_pedido, @cd_pedido_venda, @cd_item_pedido_venda, 
                                             @dt_pedido_venda, @cd_cliente
  end        

  close cReserva_Composicao
  deallocate cReserva_Composicao

  ---------------------------------------------------------------------------
  -- PROCESSO DE ALIMENTAÇÃO DA TABELA TEMPORÁRIA #MOVIMENTO_RESERVA       --
  -- FIM !!!                                                               --
  ---------------------------------------------------------------------------

  ---------------------------------------------------------------------------
  -- **************** DELEÇÃO DOS MOVIMENTOS DE RESERVA ****************** --
  ---------------------------------------------------------------------------
  -- APAGANDO RESERVAS ANTERIORES A DATA FINAL OU GERADOS POR UM FECHAMENTO
  -- ANTERIOR
  if (@ic_debug = 'S') 
    print ('Apagando Movimentos da Reserva 1')

  delete from Movimento_Estoque
  from 
    Movimento_Estoque me 
    inner join      Produto p                  on me.cd_produto                 = p.cd_produto 
    left outer join Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
  where 
      tme.nm_atributo_produto_saldo = 'qt_saldo_reserva_produto' and
    ((me.dt_movimento_estoque <= @dt_final) or
     (me.nm_historico_movimento like '%Fechamento%')) and
    ((@ic_parametro = 1) or ((@ic_parametro = 3) and (p.cd_grupo_produto = @cd_grupo_produto)) or
     ((@ic_parametro = 6) and (p.cd_produto = @cd_produto)) or
     (me.cd_produto in (select distinct cd_produto 
                        from #Movimento_Reserva)))

  if (@ic_debug = 'S') 
    print ('Apagados Movimentos de Reserva 2')  

  -----------------------------------------------------------------------------
  -- ******************* GRAVAÇÃO DOS NOVOS MOVIMENTOS DE RESERVA ********** --
  -----------------------------------------------------------------------------
  if exists(select 'x' from #Movimento_Reserva) 
  begin

    -- MUDANÇA NA ESTRATÉGIA DE BUSCA DE CÓDIGO DO MOVIMENTO DE ESTOQUE NESTE PROCESSO
    -- 1 - BUSCA-SE O CÓDIGO DE MOVIMENTO DE ESTOQUE UTILIZANDO A SP_PEGACODIGO
    -- 2 - GRAVA-SE NA TABELA EGISADMIN.DBO.CODIGO_ME UM CÓDIGO DE ÍNICIO DE QUALQUER
    --     MOVIMENTO EFETUADO PELO RESTANTE DAS ROTINAS DO SISTEMA, ATRAVÉS DA SEGUINTE
    --     FÓRMULA: CODIGO_GRAVAR = (CODIGO_ENCONTRADO + REGISTROS_FECHAMENTO) + 1
    -- 3 - ALTERAR O CAMPO CHAVE DA TABELA TEMPORÁRIA DE MOVIMENTOS DE RESERVA DE
    --     FECHAMENTO PARA A FÓRMULA: CHAVE = ID_TEMPORARIO + CODIGO_ENCONTRADO
    -- 4 - EFETUA A GRAVAÇÃO DOS MOVIMENTOS
    -- 5 - APAGA-SE O REGISTRO GERADO NA TABELA DE CÓDIGOS
    --     
    -- DESTA FORMA, UTILIZA-SE SOMENTE UMA VEZ A ROTINA DE GERAÇÃO DE CÓDIGO

    -- PASSO 1º
    exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_movimento_estoque', @codigo = @cd_movimento_estoque output
   
    -- PASSO 2º

    select @cd_codigo_me = @cd_movimento_estoque + count('x') + 1
    from #Movimento_Reserva

    insert into EgisAdmin.dbo.Codigo_ME values (null, @cd_codigo_me, 'A', null, null, null)

    -- PASSO 3º    
    update #Movimento_Reserva
    set cd_movimento_estoque = codigo + @cd_movimento_estoque

    if (@ic_debug = 'S')	  
      print('Gravando Movimentos de Reserva')

    -- PASSO 4º GRAVAÇÃO DOS MOVIMENTOS DE ESTOQUE
    Insert into Movimento_Estoque (cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque, 
      cd_documento_movimento, cd_item_documento, cd_tipo_documento_estoque, dt_documento_movimento, 
      cd_centro_custo, qt_movimento_estoque, vl_unitario_movimento, vl_total_movimento, ic_peps_movimento_estoque, 
      ic_terceiro_movimento, nm_historico_movimento, ic_mov_movimento, cd_tipo_destinatario, cd_fornecedor, 
      nm_destinatario, cd_origem_baixa_produto, cd_produto, cd_fase_produto, ic_fase_entrada_movimento, 
      cd_fase_produto_entrada, cd_usuario, dt_usuario)
    Select
      cd_movimento_estoque, dt_movimento_estoque, cd_tipo_movimento_estoque, cd_documento_movimento,
      cd_item_documento, cd_tipo_documento_estoque, dt_documento_movimento, cd_centro_custo, qt_movimento_estoque, 
      vl_unitario_movimento, vl_total_movimento, ic_peps_movimento_estoque, ic_terceiro_movimento, 
      nm_historico_movimento, ic_mov_movimento, cd_tipo_destinatario, cd_fornecedor, nm_destinatario, 
      cd_origem_baixa_produto, cd_produto, cd_fase_produto, ic_fase_entrada_movimento, cd_fase_produto_entrada, 
      cd_usuario, dt_usuario
    from
      #Movimento_Reserva

    if (@ic_debug = 'S')
      print('Movimentos Gravados!')

    -- PASSO 5º
    delete from EgisAdmin.dbo.Codigo_ME where cd_atual = @cd_codigo_me
    exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_movimento_estoque, 'D'	

  end

end

SET LOCK_TIMEOUT -1


-------------------------------------------------------------------------------
--  CONFIRMAÇÃO DAS GRAVAÇÕES OU CANCELAMENTO                                --
-------------------------------------------------------------------------------
-- if @@Error = 0
--   Commit Transaction
-- else
--   Rollback Transaction


 
CREATE  PROCEDURE pr_recomposicao_saldo

@ic_parametro          int, 
@dt_fechamento         datetime,
@dt_inicial            datetime,
@dt_final              datetime,        
@cd_produto            int = 0,
@cd_grupo_produto      int = 0,
@cd_serie_produto      int = 0,
@cd_fase_produto       int = 0,
@ic_atualizar_previsao char(1) = 'N'

AS

SET DATEFORMAT mdy

declare @cSQL varchar(4000)

--Pegando data inicial da data inicial passada no parâmetro
--set @dt_inicial = '01/' +cast(month(@dt_inicial) as varchar) + '/'+ cast(year(@dt_inicial) as varchar)
--Para executar pelo query analyser comente a linha acima e descomente a abaixo
--set @dt_inicial = cast(month(@dt_inicial) as varchar) + '/01/'+ cast(year(@dt_inicial) as varchar)

-------------------------------------------------------------------------------
-- MONTAR A SELECT COM os Produtos e seus SALDOS INICIAIS
-------------------------------------------------------------------------------
create table #Selecao_Inicial
( cd_produto int not null primary key,  -- ELIAS 14/09/2005
  qt_saldo_inicial float,
------  qt_consig_inicial float,
  qt_terc_inicial float,
	cd_fase_produto int  )  -- ELIAS 26/01/05

delete from #Selecao_Inicial

-- Criação de uma Chave - Comentado por Elias, a Criação ocorre juntamente com a Tabela
-- alter table #Selecao_Inicial
--   add constraint PK_Temp_Recomposicao_Selecao_Inicial
--   primary key (cd_produto)

--
--Fase do Parâmetro Comercial
--

declare @cd_fase int

select 
  @cd_fase = cd_fase_produto 
from 
  Parametro_Comercial with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

--
--Fase Default de Entrada - ELIAS 24/07/2006
--

declare @cd_fase_entrada int

select 
  @cd_fase_entrada = cd_fase_produto
from 
  Parametro_Suprimento with (nolock) 
where 
  cd_empresa = dbo.fn_empresa()

--
--Verifica se Opera com Alocação de Produtos
--
--select * from parametro_estoque

declare @ic_alocacao_estoque_reserva char(1)

select
  @ic_alocacao_estoque_reserva = isnull(ic_alocacao_estoque_reserva,'N')
from
  parametro_estoque with (nolock) 
where 
  cd_empresa = dbo.fn_empresa()

--
--Montagem do select para Recomposição
--

Set @cSQL =
'Insert into #Selecao_Inicial ' +
'select ' +
'  p.cd_produto,  ' +
'  isnull(pf.qt_atual_prod_fechamento,0) qt_saldo_inicial, ' +
------'  isnull(pf.qt_consig_prod_fechamento,0) qt_consig_inicial,  ' +
'  isnull(pf.qt_terc_prod_fechamento,0) qt_terc_inicial, ' +
'  case when isnull(pf.cd_fase_produto,0)<>0 then isnull(pf.cd_fase_produto,0) else '+cast(@cd_fase_produto as varchar)+
'  end as cd_fase_produto ' + -- ELIAS 26/01/05
'from  ' +
'  Produto p with (nolock) ' +
'  left outer join Produto_Fechamento pf with (nolock) ' +
'       on pf.cd_produto = p.cd_produto and ' +
'          pf.cd_fase_produto = '+ cast(@cd_fase_produto as varchar) +' and ' +
'          pf.dt_produto_fechamento = '''+ cast(@dt_fechamento as varchar) +''' ' +
'  left outer join Produto_Custo pc with (nolock) ' +
'       on pc.cd_produto = p.cd_produto and ' +
'          IsNull(pc.ic_estoque_produto, ''S'') = ''S'' ' +
--Checagem dos grupos que controlam estoque e fazem o fechamento mensal
--Carlos 26/01/2005
'  left outer join Grupo_Produto_Custo gpc with (nolock) ' +
'       on gpc.cd_grupo_produto = p.cd_grupo_produto ' + 
' where ' +
'       isnull(ic_fechamento_mensal,''S'') = ''S''  and '  +
'       isnull(ic_estoque_grupo_prod,''S'' ) = ''S'' '

if @ic_parametro in (1,2)
  set @cSQL = @cSQL +
    ' and (p.cd_grupo_produto = '+ cast(@cd_grupo_produto as varchar) +')' -- por grupo

if @ic_parametro in (3,4)
  set @cSQL = @cSQL +
    ' and (p.cd_serie_produto = '+ cast(@cd_serie_produto as varchar) +')' -- por série

if @ic_parametro in (5,6)
  set @cSQL = @cSQL +
    ' and (p.cd_produto = '+ cast(@cd_produto as varchar) +')'             -- por produto

--print @cSQL

Exec( @cSQL ) -- selecionar os produtos

--select * from #Selecao_Inicial

-------------------------------------------------------------------------------------
if @ic_parametro in (5,6) -- Se não houve saldo inicial por produto, gerar o registro
-------------------------------------------------------------------------------------
begin
  if not exists(select top 1 'X' from #Selecao_Inicial )
  begin

    insert into #Selecao_Inicial
    values (@cd_produto,
            0, -- qt_saldo_inicial
------            0, -- qt_consig_inicial
            0, -- qt_terc_inicial
            @cd_fase_produto) -- cd_fase_produto 

  end

end

-------------------------------------------------------------------------------
if @ic_atualizar_previsao = 'S' -- ATUALIZAÇÃO DAS DATAS E QUANTIDADES 
--                                 DE PREVISÃO DE ENTRADA  -- ELIAS 22/11/2005
-------------------------------------------------------------------------------
begin

  declare cPrevisaoEntrada cursor for
  select cd_produto from #Selecao_Inicial

  open cPrevisaoEntrada

  fetch next from cPrevisaoEntrada into @cd_produto

  while @@fetch_status = 0
  begin

    exec pr_atualizar_saldo_previsoes_entrada @cd_fase_produto, @cd_produto

    fetch next from cPrevisaoEntrada into @cd_produto
  end

  close cPrevisaoEntrada
  deallocate cPrevisaoEntrada

end

-------------------------------------------------------------------------------
if @ic_parametro in (1,3,5) -- RECOMPOSIÇÃO - REAL
-------------------------------------------------------------------------------
begin

  --Total do Movimento de Entrada/Saída

  select 
    me.cd_produto, 
    sum( case when tme.ic_mov_tipo_movimento =  'E'
              then me.qt_movimento_estoque
              else 0
         end ) qt_entrada,

    sum( case when tme.ic_mov_tipo_movimento =  'S'
              then me.qt_movimento_estoque
              else 0
         end ) qt_saida
  into 
    #EntradaSaida
  from 
    Movimento_Estoque                      me  with (nolock) 
    left outer join Tipo_Movimento_Estoque tme with (nolock) on  tme.cd_tipo_movimento_estoque=me.cd_tipo_movimento_estoque
    inner Join      #Selecao_Inicial       p   with (nolock) on me.cd_produto = p.cd_produto
  where 
    tme.nm_atributo_produto_saldo =  'qt_saldo_atual_produto' and
    me.cd_fase_produto            =  @cd_fase_produto         and
    me.dt_movimento_estoque       between @dt_inicial and @dt_final

  group by
    me.cd_produto

--  select * from #EntradaSaida

  -- CONSIGNAÇÃO - Entrada/Saída
/*
  select 
    me.cd_produto, 
    sum( case when tme.ic_mov_tipo_movimento =  'E'
              then me.qt_movimento_estoque
              else 0
         end ) qt_entrada,

    sum( case when tme.ic_mov_tipo_movimento =  'S'
              then me.qt_movimento_estoque
              else 0
         end ) qt_saida
  Into 
    #EntradaSaidaConsignacao
  from 
    Movimento_Estoque      me  left outer join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque inner join
    #Selecao_Inicial       p   on me.cd_produto = p.cd_produto
  where 
    me.ic_consig_movimento     = 'S' and 
    me.cd_fase_produto         =  @cd_fase_produto and
    me.dt_movimento_estoque    between @dt_inicial and @dt_final
  group By
    me.cd_produto
*/

--  select * from #EntradaSaidaConsignacao

  -- TERCEIROS - Entrada/Saída

  select 
    me.cd_produto, 
    sum( case when tme.ic_mov_tipo_movimento =  'E'
              then me.qt_movimento_estoque
              else 0
         end ) qt_entrada,

    sum( case when tme.ic_mov_tipo_movimento =  'S'
              then me.qt_movimento_estoque
              else 0
         end ) qt_saida
  into 
    #EntradaSaidaTerceiros

  from 
    Movimento_Estoque      me  with (nolock) 
    right outer join 
    Tipo_Movimento_Estoque tme with (nolock)  on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
    right outer join #Selecao_Inicial       p on me.cd_produto = p.cd_produto
  where 
    me.ic_terceiro_movimento     = 'S' and 
    me.dt_movimento_estoque      between @dt_inicial and @dt_final
  group By
    me.cd_produto,
    me.cd_fase_produto
  order by
    me.cd_produto,
    me.cd_fase_produto

  -- Quantidade em requisições de compra

  -- ELIAS 13/09/2005 - Não Filtrar por Status, pois temos de buscar as parcialmente em PC
  -- ELIAS 24/07/2006 - Na Ausência da Fase buscar a Fase Default de Entrada

  select
    pm.cd_produto,
    --Fabio Cesar - Desconsiderar o tipo de mercado que não realiza atualização do saldo
    sum( case IsNull(tp.ic_rc_evolucao_consumo,'S')
           when 'S' then
              isnull(rci.qt_item_requisicao_compra,0) 
           else
              0
         end
       ) as qt_requisicao_compra  
  into
    #RequisicaoCompra

  from
    #Selecao_Inicial              pm     
    inner join Requisicao_Compra_Item rci with (nolock) on pm.cd_produto           = rci.cd_produto 
    inner join Requisicao_Compra rc       with (nolock) on rc.cd_requisicao_compra = rci.cd_requisicao_compra 
    left outer join Tipo_Requisicao tr    with (nolock) on rc.cd_tipo_requisicao   = tr.cd_tipo_requisicao 
    left outer join Tipo_Mercado tp       with (nolock) on tp.cd_tipo_mercado      = IsNull(rc.cd_tipo_mercado,1) --Mercado Nacional
  where
    IsNull(rci.cd_pedido_compra,0)         = 0   and
    isnull(rc.ic_liberado_proc_compra,'N') = 'S' and
    rc.cd_status_requisicao    = 1               and  --Somente Requisição em Aberto
    isnull(tr.cd_fase_produto, @cd_fase_entrada) = pm.cd_fase_produto 
  group by
    pm.cd_produto

  --select * from requisicao_compra where cd_requisicao_compra = 6

  --Quantidades em pedidos de compra

  -- ELIAS 13/09/2005 - Não Filtrar por Status, pois temos de buscar as Parcialmente em NFE
  -- ELIAS 24/07/2006 - Buscar de acordo com a Fase, e na ausência desta, a fase default de entrada.

  select
    pm.cd_produto,
    sum( isnull(pci.qt_saldo_item_ped_compra,0) ) as qt_pedido_compra
  into
    #PedidoCompra

  from
    #Selecao_Inicial pm 
    inner join
    Pedido_Compra_Item  pci with (nolock) on pm.cd_produto            = pci.cd_produto inner join
    Pedido_Compra       pc  with (nolock) on pci.cd_pedido_compra     = pc.cd_pedido_compra left outer join 
    Requisicao_Compra   rc  with (nolock) on pci.cd_requisicao_compra = rc.cd_requisicao_compra left outer join 
    Tipo_Requisicao     tr  with (nolock) on rc.cd_tipo_requisicao    = tr.cd_tipo_requisicao 
  where
    pc.dt_cancel_ped_compra is null and
    isnull(pci.qt_saldo_item_ped_compra,0) > 0 and
    pci.dt_item_canc_ped_compra  is null and
    isnull(tr.cd_fase_produto, @cd_fase_entrada) = @cd_fase_produto --and 
--    pm.cd_fase_produto = @cd_fase_produto 
  group by
    pm.cd_produto

  --Quantidades em pedidos de importação
  --Carlos 02.09.2005

  select
    pm.cd_produto,
    sum( isnull(pii.qt_saldo_item_ped_imp,0) ) as qt_pedido_importacao
  into
    #PedidoImportacao
  from
    #Selecao_Inicial pm 
    inner join pedido_importacao_item  pii  with (nolock) on pm.cd_produto          = pii.cd_produto
    inner join pedido_importacao       p    with (nolock) on p.cd_pedido_importacao = pii.cd_pedido_importacao

  where
    pii.dt_cancel_item_ped_imp  is null     and 
    isnull(pii.qt_saldo_item_ped_imp,0) > 0 and
    pm.cd_fase_produto = @cd_fase_produto   and
    p.dt_canc_pedido_importacao is null     

  group by
    pm.cd_produto

--select cd_fase_produto,* from processo_producao

  --Quantidadades em Processos de Produção

  select
    pp.cd_produto,
    sum( isnull(pp.qt_planejada_processo,0) ) as qt_produto_producao
  into
    #OrdemProducao

  from
    #Selecao_Inicial   pm inner join
    processo_producao  pp with (nolock) on pm.cd_produto = pp.cd_produto
  where
    pp.dt_canc_processo     is null and 
    pp.qt_planejada_processo > 0 and
    pp.cd_fase_produto    = @cd_fase_produto     and
    pp.cd_status_processo = 4 --Liberada

  group by
    pp.cd_produto

  --Quantidade em Alocação de Pedidos 

  --select * from atendimento_pedido_venda

  select
    pm.cd_produto,
    sum( apv.qt_atendimento ) as qt_alocado_produto
  into
    #AtendimentoPedido
  from
    #Selecao_Inicial         pm   inner join
    Atendimento_Pedido_Venda apv  with (nolock) on pm.cd_produto  = apv.cd_produto
  where
    @cd_fase = pm.cd_fase_produto 
  group by
    pm.cd_produto

  --Quantidade das Previsões de Entrada ( Pedido de Compra + Pedido de Importação + OP )

  select
    pm.cd_produto,
    sum( isnull(vwe.quantidade,0) ) as qt_prev_entrada_produto
  into
    #PrevisaoEntrada

  from
    #Selecao_Inicial         pm   inner join
    vw_previsao_entrada vwe       with (nolock) on pm.cd_produto = vwe.CodigoProduto 
  where
--     vwe.Documento not in ( select apv.cd_documento from atendimento_pedido_venda apv
--                                      where vwe.ItemDocumento = apv.cd_item_documento )     
--    and 

    @cd_fase = pm.cd_fase_produto 

  group by
    pm.cd_produto

  --select * from status_processo

  -- Calcula o Consumo Médio

  declare @dt_consumo_inicial datetime

  set @dt_consumo_inicial = dateadd (month, -2, @dt_final)
  set @dt_consumo_inicial = cast( str(month( @dt_consumo_inicial )) + '/' +
                                  '01' + '/' + str(year( @dt_consumo_inicial )) as datetime )

--  select @dt_consumo_inicial

--  print 'Data Inicial p/ Consumo Médio'
--  print @dt_consumo_inicial
-- select * from tipo_movimento_estoque

  select
    me.cd_produto,
    (sum (
     case when tme.ic_mov_tipo_movimento='E'
     then
       -1
     else
         1 
     end * me.qt_movimento_estoque) / 3) as 'qt_consumo_medio'
  into
    #ConsumoMedio

  from
    #Selecao_Inicial p         inner join
    movimento_estoque me       with (nolock) on me.cd_produto                 = p.cd_produto inner join
    tipo_movimento_estoque tme with (nolock) on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
  where
    (me.dt_movimento_estoque  between @dt_consumo_inicial and @dt_final) and
    (me.cd_fase_produto = @cd_fase_produto)
    and
    (isnull(tme.ic_consumo_tipo_movimento,'N')='S')
  group by
    me.cd_produto

--  select * from #ConsumoMedio  

  --Cria a tabela com todos os saldos recompostos.

  select
    p.cd_produto,
    (IsNull(p.qt_saldo_inicial,0) + (IsNull(es.qt_entrada,0) - IsNull(es.qt_saida,0))) qt_saldo,
----    (IsNull(p.qt_consig_inicial,0) + (IsNull(c.qt_entrada,0) - IsNull(c.qt_saida,0))) qt_consignacao,
    (IsNull(p.qt_terc_inicial,0) + (IsNull(t.qt_entrada,0) - IsNull(t.qt_saida,0))) qt_terceiro,
    rc.qt_requisicao_compra,
    pc.qt_pedido_compra,
    cm.qt_consumo_medio,
    @cd_fase_produto            as cd_fase_produto,  -- ELIAS 26/01/05,
    pim.qt_pedido_importacao,
    pp.qt_produto_producao,
    apv.qt_alocado_produto,
    --07.04.2009
    --pe.qt_prev_entrada_produto - isnull(apv.qt_alocado_produto,0) as qt_prev_entrada_produto
    pe.qt_prev_entrada_produto                                      as qt_prev_entrada_produto

  into
    #Atual_Real

  from
    #Selecao_Inicial         p                                    Left Outer Join
    #EntradaSaida            es  on p.cd_produto = es.cd_produto  Left Outer Join
------    #EntradaSaidaConsignacao c  on p.cd_produto = c.cd_produto Left Outer Join
    #EntradaSaidaTerceiros   t   on p.cd_produto = t.cd_produto   Left Outer Join
    #RequisicaoCompra        rc  on p.cd_produto = rc.cd_produto  Left Outer Join
    #PedidoCompra            pc  on p.cd_produto = pc.cd_produto  Left Outer Join
    #ConsumoMedio            cm  on p.cd_produto = cm.cd_produto  Left Outer Join
    #PedidoImportacao        pim on p.cd_produto = pim.cd_produto Left Outer Join
    #OrdemProducao           pp  on p.cd_produto = pp.cd_produto  Left Outer Join
    #AtendimentoPedido      apv  on p.cd_produto = apv.cd_produto Left Outer Join
    #PrevisaoEntrada         pe  on p.cd_produto = pe.cd_produto  

  --Atualizando produto saldo
  --select * from produto_saldo

  update 
    Produto_Saldo
  set
    qt_saldo_atual_produto   = a.qt_saldo,
----    qt_consig_produto        = a.qt_consignacao,
    qt_terceiro_produto      = a.qt_terceiro,
    qt_req_compra_produto    = a.qt_requisicao_compra,
    qt_pd_compra_produto     = a.qt_pedido_compra,
    dt_atual_produto         = getdate(),
    qt_consumo_produto       = a.qt_consumo_medio,
    qt_producao_produto      = a.qt_produto_producao,--@cd_fase_produto, -- ELIAS 26/01/05,
    qt_importacao_produto    = a.qt_pedido_importacao,
    qt_alocado_produto       = a.qt_alocado_produto,
    qt_prev_entrada_produto  = a.qt_prev_entrada_produto

  from
    Produto_Saldo ps, 
    #Atual_Real a
  where 
    ps.cd_produto      = a.cd_produto      and 
    ps.cd_fase_produto = @cd_fase_produto  and
    a.cd_fase_produto  = ps.cd_fase_produto  -- ELIAS 26/01/05

  --Inserindo os produtos em produto saldo no caso dos produtos que não estão 
  --na tabela Produto_Saldo
   
  insert into 
    Produto_Saldo 
      (cd_produto, 
       cd_fase_produto, 
       qt_saldo_atual_produto, 
----       qt_consig_produto,
       qt_terceiro_produto,
       qt_req_compra_produto,
       qt_pd_compra_produto,
       dt_atual_produto, 
       qt_consumo_produto,
       qt_importacao_produto,
       qt_producao_produto,
       qt_alocado_produto,
       cd_usuario,  
       dt_usuario)
  select
    a.cd_produto, 
    @cd_fase_produto, 
    a.qt_saldo, 
----    a.qt_consignacao,
    a.qt_terceiro,
    a.qt_requisicao_compra,
    a.qt_pedido_compra,
    getdate(), 
    a.qt_consumo_medio,
    a.qt_pedido_importacao,
    a.qt_produto_producao,
    a.qt_alocado_produto,
    1, 
    getdate()
  from
    #Atual_Real a

  Where
    a.cd_produto not in (select 
                           cd_produto 
                         from produto_Saldo with (nolock)  
                         where  cd_fase_produto = @cd_fase_produto and
                                cd_produto      = a.cd_produto)

--  select * from #Atual_Real

	drop table #ENTRADASAIDA -- apagar a tabela temporária que foi criada Lá em cima
	drop table #ENTRADASAIDATERCEIROS -- apagar a tabela temporária que foi criada Lá em cima
	drop table #REQUISICAOCOMPRA -- apagar a tabela temporária que foi criada Lá em cima
	drop table #PEDIDOCOMPRA -- apagar a tabela temporária que foi criada Lá em cima
	drop table #CONSUMOMEDIO -- apagar a tabela temporária que foi criada Lá em cima
	drop table #ATUAL_REAL -- apagar a tabela temporária que foi criada Lá em cima

end
else
-------------------------------------------------------------------------------
if @ic_parametro in (2,4,6) -- RECOMPOSIÇÃO - RESERVA
-------------------------------------------------------------------------------
begin  

  --Buscando entradas dos produtos do grupo após a data inicial
  --select * from operacao_fiscal

  select 
    me.cd_produto, 
    sum( case when isnull(me.cd_operacao_fiscal,0)>0 and
         me.ic_mov_movimento = 'E' and isnull(opf.ic_estoque_reserva_op_fis,'N') = 'N'
         then
            0.00
         else
            isnull(me.qt_movimento_estoque,0)
         end 
        ) as qt_entrada
  into 
    #Entrada_Reserva

  from 
    Movimento_Estoque                      me  with (nolock) 
    left outer join Tipo_Movimento_Estoque tme with (nolock) on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
    inner Join #Selecao_Inicial            p   with (nolock) on me.cd_produto                 = p.cd_produto
    Left Outer Join Operacao_Fiscal opf        with (nolock) on opf.cd_operacao_fiscal        = me.cd_operacao_fiscal

  where 
    tme.ic_mov_tipo_movimento        =  'E' and 
    ((tme.cd_tipo_movimento_estoque  in  (1,5))  or 
     ((tme.nm_atributo_produto_saldo =  '') or (tme.nm_atributo_produto_saldo = 'qt_saldo_reserva_produto')) or
     ((tme.nm_atributo_produto_saldo =  'qt_saldo_atual_produto') and (me.ic_tipo_lancto_movimento='M'))) and
    me.cd_fase_produto               =  @cd_fase_produto and 
    me.dt_movimento_estoque          between @dt_inicial and @dt_final

  group By
    me.cd_produto

  --Buscando saídas de reserva dos produtos do grupo após a data inicial  

  select 
    me.cd_produto, 
    sum(isnull(me.qt_movimento_estoque,0)) as qt_saida
  into 
    #Saida_Reserva

  from 
    Movimento_Estoque                      me  with (nolock) 
    left outer join Tipo_Movimento_Estoque tme with (nolock) on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
    inner Join #Selecao_Inicial            p   with (nolock) on me.cd_produto                 = p.cd_produto

  where 
    ((tme.nm_atributo_produto_saldo =  'qt_saldo_reserva_produto') or 
     (me.ic_tipo_lancto_movimento   =  'M'))                         and
    tme.ic_mov_tipo_movimento       =  'S'                           and 
    me.cd_fase_produto              =  @cd_fase_produto              and 
    me.dt_movimento_estoque         between @dt_inicial and @dt_final

  group by
    me.cd_produto

  select
    me.cd_produto, 
    sum(isnull(me.qt_movimento_estoque,0)) as qt_saida
  into
    #Saida_ReservaMesSeguinte

  from
    Movimento_Estoque                      me  with (nolock) 
    left outer join Tipo_Movimento_Estoque tme with (nolock) on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque 
    inner Join #Selecao_Inicial            p   with (nolock) on me.cd_produto                 = p.cd_produto

    inner join pedido_venda_item i on i.cd_pedido_venda        = me.cd_documento_movimento and
                                      i.cd_item_pedido_venda   = me.cd_item_documento


    inner join vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = i.cd_pedido_venda        and
                                                      nsi.cd_item_pedido_venda = i.cd_item_pedido_venda   

--     inner join nota_saida_item nsi on nsi.cd_pedido_venda      = i.cd_pedido_venda        and
--                                       nsi.cd_item_pedido_venda = i.cd_item_pedido_venda   

    inner join nota_saida n        on n.cd_nota_saida          = nsi.cd_nota_saida
  where
    ( me.cd_tipo_movimento_estoque = 2 or me.cd_tipo_movimento_estoque = 3 ) 
    and   --Saída
    ((tme.nm_atributo_produto_saldo =  'qt_saldo_reserva_produto') or 
     (me.ic_tipo_lancto_movimento   =  'M'))                       and
    tme.ic_mov_tipo_movimento       =  'S'                         and 
    me.cd_fase_produto              =  @cd_fase_produto            and 
    n.dt_nota_saida > @dt_final                                    and
    me.dt_movimento_estoque > n.dt_nota_saida                      and
    me.dt_movimento_estoque         between @dt_inicial and @dt_final

  group by
    me.cd_produto

  ------------------------------------------------------------------------------------------
  --Cria a tabela com todos os saldos recompostos.
  ------------------------------------------------------------------------------------------

  select
    p.cd_produto,
    (IsNull(p.qt_saldo_inicial,0) + (IsNull(e.qt_entrada,0) - IsNull(s.qt_saida,0) + Isnull(srm.qt_saida,0))) as qt_saldo

  into
    #Atual_Reserva

  from
    #Selecao_Inicial  p                                          Left Outer Join
    #Entrada_Reserva  e           on p.cd_produto = e.cd_produto Left Outer Join
    #Saida_Reserva    s           on p.cd_produto = s.cd_produto Left Outer Join
    #Saida_ReservaMesSeguinte srm on p.cd_produto = srm.cd_produto

  --Atualizando saldo da reserva dos produtos do grupo

  update 
    Produto_Saldo
  set
    qt_saldo_reserva_produto = a.qt_saldo,
    dt_atual_produto         = getdate()
  from
    Produto_Saldo ps, 
    #Atual_Reserva a
  where 
    ps.cd_produto   = a.cd_produto and 
    cd_fase_produto = @cd_fase_produto

  --Inserindo saldo sa reserva dos produtos para produtos que não tem na tabela Produto_Saldo

  Insert into 
    Produto_Saldo 
      (cd_produto, 
       cd_fase_produto, 
       qt_saldo_reserva_produto, 
       dt_atual_produto, 
       cd_usuario, 
       dt_usuario)
  select
    a.cd_produto, 
    @cd_fase_produto, 
    a.qt_saldo, 
    getdate(), 
    1, 
    getdate()
  from
    #Atual_Reserva a

  where
    a.cd_produto not in(select cd_produto 
                        from 
                          produto_Saldo with (nolock) 
                        where 
                          cd_fase_produto = @cd_fase_produto and
                          cd_produto      = a.cd_produto)

--  select * from #Atual_Reserva

end

drop table #Selecao_Inicial -- apagar a tabela temporária que foi criada Lá em cima

-----------------------------------------------------------------------------------------------------------
--Carlos
--28.10.2005
--Verificar se a Empresa Opera com Controle de Lote
-----------------------------------------------------------------------------------------------------------
-- declare @ic_opera_controle_lote char(1)
-- 
-- select 
--   @ic_opera_controle_lote = isnull(ic_estoque_lote_empresa,'N')
-- from 
--   parametro_estoque
-- where
--   cd_empresa = dbo.fn_empresa()
-- 
-- if @ic_opera_controle_lote = 'S' 
-- begin
--   exec pr_recomposicao_saldo_lote_produto
-- end
-- 
-----------------------------------------------------------------------------------------------------------


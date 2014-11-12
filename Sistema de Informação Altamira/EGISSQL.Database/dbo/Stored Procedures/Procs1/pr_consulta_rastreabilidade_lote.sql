
-------------------------------------------------------------------------------
--pr_consulta_rastreabilidade_lote
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Rastreabilidade de Lote
--Data             : 25.11.2006
--Alteração        : 11.12.2006 - 
--                 : 02.07.2007 - Observações do Lote - Carlos Fernandes
--                 : 01.08.2007 
-- 17.01.2008 - Acertos Diversos na Consulta - Carlos Fernandes
-- 11.05.2010 - Novos Atributos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_consulta_rastreabilidade_lote
@ic_parametro    int         = 0,
@cd_lote_produto varchar(25) = '',
@cd_cliente      int         = 0,
@cd_pedido_venda int         = 0,
@cd_nota_saida   int         = 0,
@cd_produto      int         = 0,
@dt_inicial      datetime    = '',
@dt_final        datetime    = '',
@cd_fornecedor   int         = 0,
@cd_processo     int         = 0,
@ic_saldo_lote   char(1)     = 'S'

------------------------------------------------------------------------------
--Parâmetros
------------------------------------------------------------------------------
--0 : Todos
--1 : Compra
--2 : Entrada
--3 : Produção
--4 : Venda
--5 : Faturamento
------------------------------------------------------------------------------

as

--Montar todas as Tabelas Temporárias
--Fazer  um union pelo Lote,

--select * from lote_produto
--select * from lote_produto_item

declare @dt_hoje datetime

set @dt_hoje = convert(datetime,left(convert(varchar,getdate(),121),10)+' 00:00:00',121)


if @ic_parametro = 0
begin

select
  lp.cd_lote_produto,
  lp.nm_ref_lote_produto      as Lote,
  lp.nm_lote_produto,
  lpi.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,

  isnull(lpi.nm_obs_item_lote_produto,lp.nm_obs_lote_produto) as nm_obs_lote_produto,
  isnull(lps.qt_saldo_reserva_lote,0)                         as qt_saldo_reserva_lote,
  isnull(lps.qt_saldo_atual_lote,0)                           as qt_saldo_atual_lote

--select * from lote_produto_saldo

into
  #LoteProduto

from
  Lote_produto lp                        with (nolock) 
  inner join Lote_Produto_item lpi       with (nolock) on lpi.cd_lote_produto  = lp.cd_lote_produto
  inner join Produto           p         with (nolock) on p.cd_produto         = lpi.cd_produto
  left outer join Unidade_Medida um      with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida
  left outer join Lote_Produto_Saldo lps with (nolock) on lps.cd_lote_produto  = lp.cd_lote_produto

where
  lp.nm_ref_lote_produto = case when isnull(@cd_lote_produto,'')='' then lp.nm_ref_lote_produto else @cd_lote_produto end 

order by
  lp.nm_ref_lote_produto

if @ic_saldo_lote = 'S'
begin
  delete from #LoteProduto 
  where qt_saldo_atual_lote<=0

end

--Pedido de Venda

--select * from pedido_venda_item
--select * from nota_saida_item

select 
  pvi.cd_lote_item_pedido                    as LoteSaida,
  c.cd_cliente                               as cd_cliente,
  c.nm_fantasia_cliente                      as Cliente,
  pv.cd_pedido_venda                         as PedidoV,
  pvi.cd_item_pedido_venda                   as ItemV,
  pvi.qt_item_pedido_venda                   as QtdV,
  pv.dt_pedido_venda                         as EmissaoV,
  nsi.cd_nota_saida                          as NotaSaida,
  nsi.cd_item_nota_saida                     as ItemNotaSaida,
  nsi.qt_item_nota_saida                     as QtdNotaSaida,
  nsi.dt_nota_saida                          as DataNotaSaida,
  pp.cd_processo                             as Processo,
  pp.dt_processo                             as DataProcesso,
  pp.qt_planejada_processo                   as QtdPlanejada
into 
  #LotePedidoVenda

from
  Pedido_Venda pv                          with (nolock) 
  inner join pedido_venda_item        pvi  with (nolock) on pv.cd_pedido_venda       = pvi.cd_pedido_venda
  left outer join cliente             c    with (nolock) on c.cd_cliente             = pv.cd_cliente
  left outer join Nota_Saida_item     nsi  with (nolock) on nsi.cd_pedido_venda      = pvi.cd_pedido_venda  and
                                                            nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda and
                                                            nsi.dt_cancel_item_nota_saida is null
  left outer join Processo_Producao   pp   with (nolock) on pp.cd_pedido_venda       = pvi.cd_pedido_venda      and
                                                            pp.cd_item_pedido_venda  = pvi.cd_item_pedido_venda and
                                                            pp.cd_processo           = case when isnull(@cd_processo,0)=0       then pp.cd_processo            else @cd_processo     end
 
where
  pvi.cd_lote_item_pedido = case when isnull(@cd_lote_produto,'')='' then pvi.cd_lote_item_pedido else @cd_lote_produto end and
  pv.cd_cliente           = case when @cd_cliente=0       then pv.cd_cliente           else @cd_cliente      end and
  pv.cd_pedido_venda      = case when @cd_pedido_venda=0  then pv.cd_pedido_venda      else @cd_pedido_venda end and
  pvi.cd_produto          = case when @cd_produto     =0  then pvi.cd_produto          else @cd_produto      end and
--  pv.dt_pedido_venda between @dt_inicial and @dt_final    and
  pvi.dt_cancelamento_item is null 
  and isnull(pvi.cd_lote_item_pedido,'') <> ''

order by
  pvi.cd_lote_item_pedido

--select * from Processo_Producao
--select * from processo_producao_componente
  
-- Ordem de Produção

select 
  ppc.cd_lote_item_processo                  as LoteProcesso,
  pp.cd_processo                             as OP,
  pp.dt_processo                             as DataOP,
  pp.qt_planejada_processo                   as QtdOP,
  ppc.qt_comp_processo                       as QtdComponente,
  ppc.qt_real_processo                       as QtdReal
into 
  #LoteProducao
from
  Processo_Producao pp                        with (nolock) 
  inner join processo_producao_componente ppc with (nolock) on pp.cd_processo           = ppc.cd_processo
where
  ppc.cd_lote_item_processo = case when isnull(@cd_lote_produto,'')='' then ppc.cd_lote_item_processo else @cd_lote_produto end 
  and pp.cd_processo        = case when isnull(@cd_processo,0)=0       then pp.cd_processo            else @cd_processo     end
  and isnull(ppc.cd_lote_item_processo,'') <> ''

--select * from #LoteProducao

-- select * from pedido_compra_item
-- select * from nota_entrada_item
-- select * from nota_entrada

-- Pedido de Compra

select 
  ei.cd_lote_item_nota_entrada                    as LoteEntrada,
  f.nm_fantasia_fornecedor                        as Fornecedor,
  ei.cd_pedido_compra                             as PedidoE,
  ei.cd_item_pedido_compra                        as ItemE,
  e.dt_nota_entrada                               as EmissaoE,
  ei.cd_nota_entrada                              as NotaEntrada,
  ei.cd_item_nota_entrada                         as ItemNotaEntrada,
  ei.qt_item_nota_entrada                         as QtdNotaEntrada,
  e.dt_nota_entrada                               as DataNotaEntrada,
  e.dt_receb_nota_entrada                         as Recebimento,
  cast(@dt_hoje - e.dt_receb_nota_entrada as int) as DiasEstoque

into 
  #LotePedidoCompra
from
  Nota_Entrada_Item ei       with (nolock) 
  inner join Nota_Entrada e  with (nolock) on e.cd_fornecedor          = ei.cd_fornecedor        and
                                              e.cd_nota_entrada        = ei.cd_nota_entrada      and
                                              e.cd_operacao_fiscal     = ei.cd_operacao_fiscal   and
                                              e.cd_serie_nota_fiscal   = ei.cd_serie_nota_fiscal 

  left outer join Fornecedor f with (nolock) on f.cd_fornecedor          = ei.cd_fornecedor

where
  ei.cd_lote_item_nota_entrada   = case when isnull(@cd_lote_produto,'')='' then ei.cd_lote_item_nota_entrada else @cd_lote_produto end and
  ei.cd_fornecedor               = case when @cd_fornecedor=0    then ei.cd_fornecedor             else @cd_fornecedor   end and
  ei.cd_produto                  = case when @cd_produto     =0  then ei.cd_produto                else @cd_produto      end and
  --e.dt_nota_entrada between @dt_inicial and @dt_final    and
  isnull(ei.cd_lote_item_nota_entrada,'') <> ''

order by
  ei.cd_lote_item_nota_entrada

--select * from #LotePedidoCompra

-------------------------------------------------------------------------------------------
--Deleta os registros em função dos Parâmetros
-------------------------------------------------------------------------------------------

-- if @cd_cliente>0
-- begin
-- end
-- 
-- 
-- if @cd_pedido_venda>0
-- begin
-- end
-- 
-- if @cd_processo>0
-- begin
-- end
-- 
-- if @cd_nota_saida>0
-- begin
-- end
-- 
-- if @cd_fornecedor>0
-- begin
-- end
-- 
-- if @cd_produto>0
-- begin
-- end


--Junta as Tabelas de Lote

select 
  lp.*,
  lpv.*,
  lpc.*,
  lpp.*
into
  #LoteRastreabilidade

from 
  #LoteProduto lp 
  left outer join #LotePedidoVenda  lpv on lpv.LoteSaida    = lp.Lote
  left outer join #LotePedidoCompra lpc on lpc.LoteEntrada  = lp.Lote
  left outer join #LoteProducao     lpp on lpp.LoteProcesso = lp.Lote
where
  lp.Lote        = case when isnull(@cd_lote_produto,'')='' then lp.Lote else @cd_lote_produto end


-- Apresenta a Tabela Final

select
  *
from
  #LoteRastreabilidade
Where
  Lote                 = case when isnull(@cd_lote_produto,'')='' then Lote       else @cd_lote_produto end and
  cd_produto           = case when isnull(@cd_produto,0)=0        then cd_produto else @cd_produto end and
  isnull(cd_cliente,0) = case when isnull(@cd_cliente,0)=0        then isnull(cd_cliente,0) else @cd_cliente end
order by
  nm_fantasia_produto,
  Lote
  
-- select 
--   *
-- from
--   #LotePedidoVenda
-- order by
--   Lote
 
-- select 
--   *
-- from
--   #LotePedidoCompra
-- order by
--   LoteEntrada

end

--1 : Compra

if @ic_parametro = 1 
begin
  print ''
end

--2 : Entrada

if @ic_parametro = 2
begin
  print ''
end

--3 : Produção

if @ic_parametro = 3
begin
  print ''
end

--4 : Venda

if @ic_parametro = 4
begin
  print ''
end

--5 : Faturamento

if @ic_parametro = 5
begin
  print ''
end





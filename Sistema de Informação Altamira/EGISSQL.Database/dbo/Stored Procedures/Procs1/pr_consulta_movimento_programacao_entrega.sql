
-------------------------------------------------------------------------------
--pr_consulta_movimento_programacao_entrega
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta da Movimentação de Entrada da Programação de Entrega
--Data             : 08.11.2006
--Alteração        : 10/11/2006 - Refeito a procedure para melhor ligação com a tela
-- 
--                 : 11.09.2007 - Verificação - Carlos Fernandes
--                 : 14.09.2007 - Complemento das Informações - Carlos Fernandes
--                 : 18.09.2007 - Mostrar somente a Programação com Saldos - Carlos Fernandes
--                   01.10.2007 - Cancelamento da Programação - Carlos Fernandes
-- 04.02.2008 - Complemento de campos - Carlos Fernandes
-- 30.05.2008 - Consulta de Programação em Atraso - Carlos Fernandes
-- 09.06.2008 - Ajuste Geral - Carlos Fernandes
-- 20.07.2008 - Programação de Entrega com OP Cancelada - Carlos Fernandes
------------------------------------------------------------------------------------------------
create procedure pr_consulta_movimento_programacao_entrega
@dt_inicial               datetime = '',
@dt_final                 datetime = '',
@nm_fantasia_cliente      varchar(50),
@nm_filtro_produto        varchar(100),
@ic_tipo_pesq_prod        char(1)  = 'C',
@cd_contrato_fornecimento int      = 0,
@ic_tipo_consulta         char(1)  = 'T', --Todos / Aberto
@dt_base                  datetime = null
as

--Verifica se foi passado o parâmetro Data Base

if @dt_base is null
   set @dt_base = getdate()


--select * from programacao_entrega

declare @cd_fase_produto int

select
  @cd_fase_produto = isnull(cd_fase_produto,0)
from
  parametro_comercial 
where
  cd_empresa = dbo.fn_empresa()

select

  isnull(pe.ic_selecao_programacao,'N')     as ic_selecao_programacao,
  case when isnull(pe.cd_pedido_venda,0) = 0 
  then 
    0
  else
    1
  end                                        as ic_selecao_pedido,

  case when isnull(pe.cd_processo,0) = 0 
  then 
    0
  else
    1
  end                                        as ic_selecao_processo,

  pe.cd_programacao_entrega,
  pe.dt_programacao_entrega,
  pe.dt_necessidade_entrega,
  pe.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  p.cd_unidade_medida,
  um.sg_unidade_medida ,
  pe.qt_programacao_entrega,
  case when pe.dt_cancelamento_programacao is null 
  then
  isnull(pe.qt_programacao_entrega,0)-
  isnull(pe.qt_remessa_programacao,0) 
  else
    0.00
  end                                       as qt_saldo_programacao,

  isnull(( select sum( isnull(qt_remessa_produto,0)) from programacao_entrega_remessa x
    where
      x.cd_programacao_entrega = pe.cd_programacao_entrega ),0) as qt_remessa_programacao,

  pe.qt_selecao_programacao,
  pe.nm_obs_programacao_entrega,
  pe.cd_contrato_fornecimento,
  pe.cd_ano,
  pe.cd_mes,
  m.nm_mes,
  Semana = ( datepart(week,pe.dt_necessidade_entrega) ),
  c.nm_fantasia_cliente,
  isnull(pe.cd_pedido_venda,0)        as cd_pedido_venda,
  isnull(pe.cd_item_pedido_venda,0)   as cd_item_pedido_venda,
  isnull(pe.cd_processo,0)            as cd_processo,
  case when isnull(pe.cd_movimento_estoque,0)=0
  then
   'N' 
  else 
   'S' end                              as ic_estoque,
  isnull(ps.qt_saldo_reserva_produto,0) as Disponivel,
  ps.cd_fase_produto                    as cd_fase_produto,
  isnull(pe.cd_movimento_estoque,0)     as cd_movimento_estoque,
  isnull(pe.cd_previa_faturamento,0)    as cd_previa_faturamento,
  isnull(pe.cd_requisicao_interna,0)    as cd_requisicao_interna,
  isnull(pe.cd_requisicao_compra,0)     as cd_requisicao_compra,
  fp.nm_fase_produto,
  sp.nm_status_processo,
  case when isnull(xp.cd_processo_padrao,0)>0 
  then
    xp.cd_processo_padrao
  else
      prod.cd_processo_padrao
  end                                as cd_processo_padrao,
  pe.dt_cancelamento_programacao,
  pe.qt_cancelamento_programacao,
  nsi.cd_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.dt_nota_saida
from
  Programacao_Entrega pe               with (nolock)
  left outer join Cliente c            with (nolock) on c.cd_cliente              = pe.cd_cliente
  left outer join Produto p            with (nolock) on p.cd_produto              = pe.cd_produto
  left outer join Unidade_Medida um    with (nolock) on um.cd_unidade_medida      = p.cd_unidade_medida
  left outer join Mes            m     with (nolock) on m.cd_mes                  = pe.cd_mes
  left outer join Produto_Saldo  ps    with (nolock) on ps.cd_produto             = p.cd_produto and
                                                        ps.cd_fase_produto        = case when isnull(p.cd_fase_produto_baixa,0)=0 then @cd_fase_produto else p.cd_fase_produto_baixa end 
  left outer join Fase_Produto fp      with (nolock) on fp.cd_fase_produto        = case when isnull(p.cd_fase_produto_baixa,0)=0 then @cd_fase_produto else p.cd_fase_produto_baixa end 
  left outer join Processo_Producao pp with (nolock) on pp.cd_processo            = pe.cd_processo and
                                                        pp.dt_canc_processo is null

  left outer join Status_Processo   sp with (nolock) on sp.cd_status_processo     = pp.cd_status_processo

  left outer join Produto_Producao ppp with (nolock) on ppp.cd_produto            = pe.cd_produto

  left outer join Processo_Padrao  xp  with (nolock) on xp.cd_processo_padrao     = ppp.cd_processo_padrao

  left outer join Nota_Saida_Item nsi  with (nolock) on nsi.cd_pedido_venda       = pe.cd_pedido_venda      and
                                                        nsi.cd_item_pedido_venda  = pe.cd_item_pedido_venda and
                                                        nsi.dt_restricao_item_nota is null                  and
                                                        nsi.dt_cancel_item_nota_saida is null               

  left outer join Produto_Producao prod with (nolock) on prod.cd_produto          = p.cd_produto

--select * from nota_saida_item
--select * from produto_processo
--select * from produto_producao
--select * from processo_producao
--select * from programacao_entrega

where
  --Data de Entrega
  pe.dt_necessidade_entrega between @dt_inicial and @dt_final      and

  --Data de Cadastro
  --pe.dt_programacao_entrega between @dt_inicial and @dt_final      and

  c.nm_fantasia_cliente like @nm_fantasia_cliente + '%' and  
  (case when @ic_tipo_pesq_prod = 'F' and p.nm_fantasia_produto like @nm_filtro_produto + '%'  then 1
        when @ic_tipo_pesq_prod = 'C' and p.cd_mascara_produto  like @nm_filtro_produto + '%'  then 1
        when @ic_tipo_pesq_prod = 'D' and p.nm_produto          like @nm_filtro_produto + '%'  then 1
   end ) = 1 and
  IsNull(pe.cd_contrato_fornecimento,0) = (case when @cd_contrato_fornecimento = 0 then	
						IsNull(pe.cd_contrato_fornecimento,'')
					   else @cd_contrato_fornecimento end ) and
  --Saldo da Programação

  @ic_tipo_consulta = case when @ic_tipo_consulta = 'A' and
                           ( isnull(pe.qt_saldo_programacao,0)>0 or ( isnull(pe.qt_programacao_entrega,0)-
                                                                      isnull(pe.qt_remessa_programacao,0)>0 and 
                                                                      pe.dt_cancelamento_programacao is null) )
                      then 'A'
                      else 
                        case when @ic_tipo_consulta = 'C' and pe.dt_cancelamento_programacao is not null 
                        then 'C' 
                        else 
                          case when @ic_tipo_consulta = 'D' and
                                    pe.dt_necessidade_entrega<@dt_base-1 and 
                                    isnull(pe.qt_saldo_programacao,0)>0
                               then 'D'
                               else 'T'
                          end

                        end 
                      end

order by
  pe.cd_ano,pe.cd_mes,
  c.nm_fantasia_cliente,
  pe.dt_programacao_entrega


--select * from produto_saldo	
--select * from programacao_entrega
--select cd_fase_produto_baixa,* from produto
--select * from fase_produto
--select * from produto
--select * from grupo_produto


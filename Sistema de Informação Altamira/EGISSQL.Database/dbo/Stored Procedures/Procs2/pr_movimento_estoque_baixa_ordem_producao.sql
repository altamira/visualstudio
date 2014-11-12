
-------------------------------------------------------------------------------
--sp_helptext pr_movimento_estoque_baixa_ordem_producao
-------------------------------------------------------------------------------
--pr_movimento_estoque_baixa_ordem_producao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Verifica as ordens de produção de um periodo se foram 
--                   BAIXADAS no estoque e realiza o movimento de estoque 
--
--Data             : 31.08.2010
--Alteração        : 09.09.2010 - Finalização - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_movimento_estoque_baixa_ordem_producao
@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_usuario int = 0

as

--select * from processo_producao
--select * from status_processo

select
  cd_processo,
  dt_processo,
  qt_planejada_processo,
  dt_fimprod_processo,
  cd_produto,
  cd_fase_produto,
  cd_pedido_venda,
  cd_item_pedido_venda

into
  #baixaprocesso
  
from
  processo_producao  with (nolock) 

where
  dt_fimprod_processo is not null and
  dt_fimprod_processo between @dt_inicial and @dt_final
  and isnull(cd_status_processo,0)=5

--select * from processo_producao_componente

---------------------------------------------------------------------------
--Composição
---------------------------------------------------------------------------

select
  ppc.cd_processo,
  ppc.cd_componente_processo,
  ppc.cd_produto,
  ppc.qt_comp_processo,
  ppc.cd_fase_produto,
  ppc.ic_estoque_processo,
  ppc.cd_movimento_estoque,
  pp.dt_fimprod_processo,
  pp.cd_pedido_venda,
  pp.cd_item_pedido_venda

into
  #baixa_composicao

--from

from
  processo_producao_componente ppc with (nolock) 
  inner join processo_producao pp  with (nolock) on pp.cd_processo = ppc.cd_processo
where
  pp.dt_fimprod_processo is not null and
  pp.dt_fimprod_processo between @dt_inicial and @dt_final
  and isnull(pp.cd_status_processo,0)=5

--select * from #baixaprocesso
--select * from #baixa_composicao


--Entrada no Principal

declare @cd_processo            int
declare @cd_componente_processo int
declare @cd_produto             int
declare @cd_fase_produto        int
declare @qt_planejada_processo  float
declare @dt_documento_movimento datetime
declare @cd_pedido_venda        int
declare @cd_item_pedido_venda   int
declare @nm_historico_movimento varchar(40)
declare @dt_hoje                datetime
declare @p1                     int

set @cd_processo = 0
set @dt_hoje = getdate()

while exists( select top 1 cd_processo from #baixaprocesso)
begin
  
  select
    top 1
    @cd_processo            = isnull(cd_processo,0),
    @cd_fase_produto        = cd_fase_produto,
    @qt_planejada_processo  = qt_planejada_processo,
    @dt_documento_movimento = dt_fimprod_processo,
    @cd_pedido_venda        = cd_pedido_venda,
    @cd_item_pedido_venda   = cd_item_pedido_venda,
    @nm_historico_movimento = 'Proc.: '+cast(@cd_processo as varchar)+'/'+ 'Pv.: '+cast(@cd_pedido_venda as varchar),
    @cd_produto             = cd_produto

  from
    #baixaprocesso

--  select @cd_processo,@cd_fase_produto,@qt_planejada_processo

--   exec dbo.pr_Movimenta_estoque 
--  @ic_parametro = 1, @cd_tipo_movimento_estoque = 5, @cd_tipo_movimento_estoque_old = 0, @cd_produto = 263, 
-- @cd_fase_produto = 3, 
-- @qt_produto_atualizacao = 1,
-- @qt_produto_atualizacao_old = 0,
--  @dt_movimento_estoque = @dt_hoje,
--  @cd_documento_movimento = 512, 
-- @cd_item_documento = 0,
--  @cd_tipo_documento_estoque = 12,
--  @dt_documento_movimento = @dt_hoje,
--  @cd_centro_custo = 0, 
-- @vl_unitario_movimento = 0,
-- @vl_total_movimento = 0,
-- @ic_peps_movimento_estoque = 'N',
--  @ic_terceiro_movimento = 'N',
--  @nm_historico_movimento = 'Proc.: 512 / Pv.:  -', @ic_mov_movimento = 'E', @cd_fornecedor = 0, @ic_fase_entrada_movimento = 'S', 
-- @cd_fase_produto_entrada = 0, @cd_usuario = 4, @dt_usuario = @dt_hoje, @cd_tipo_destinatario = 1, 
-- @nm_destinatario = NULL, @vl_fob_produto = NULL, @vl_custo_contabil_produto = NULL, @vl_fob_convertido = NULL, 
-- @cd_produto_old = 0, @cd_fase_produto_old = 0, @ic_consig_movimento = NULL, 
-- @ic_amostra_movimento = NULL, @ic_tipo_lancto_movimento = NULL, @cd_item_composicao = NULL,
--  @cd_movimento_estoque = @P1 output,
--  @cd_lote_produto = NULL, 
-- @ic_atualiza_saldo_lote = 'S'


-- declare @P1 int
-- set @P1=294
-- exec dbo.pr_Movimenta_estoque  @ic_parametro = 1, @cd_tipo_movimento_estoque = 5, @cd_tipo_movimento_estoque_old = 0, @cd_produto = 263, @cd_fase_produto = 3, @qt_produto_atualizacao = 1.000000000000000e+000, @qt_produto_atualizacao_old = 0.000000000000000e+000, @dt_movimento_estoque = 'ago 31 2010 12:00:00:000AM', @cd_documento_movimento = 512, @cd_item_documento = 0, @cd_tipo_documento_estoque = 12, @dt_documento_movimento = 'ago 31 2010 12:00:00:000AM', @cd_centro_custo = 0, @vl_unitario_movimento = 0.000000000000000e+000, @vl_total_movimento = 0.000000000000000e+000, @ic_peps_movimento_estoque = 'N', @ic_terceiro_movimento = 'N', @nm_historico_movimento = 'Proc.: 512 / Pv.:  -', @ic_mov_movimento = 'E', @cd_fornecedor = 0, @ic_fase_entrada_movimento = 'S', @cd_fase_produto_entrada = 0, @cd_usuario = 4, @dt_usuario = 'ago 31 2010 12:00:00:000AM', @cd_tipo_destinatario = 1, @nm_destinatario = NULL, @vl_fob_produto = NULL, @vl_custo_contabil_produto = NULL, @vl_fob_convertido = NULL, @cd_produto_old = 0, @cd_fase_produto_old = 0, @ic_consig_movimento = NULL, @ic_amostra_movimento = NULL, @ic_tipo_lancto_movimento = NULL, @cd_item_composicao = NULL, @cd_movimento_estoque = @P1 output, @cd_lote_produto = NULL, @ic_atualiza_saldo_lote = 'S'
-- select @P1

  --select * from movimento_estoque where cd_movimento_estoque = 289
  --select * from tipo_documento_estoque

  --Baixa o Estoque

      exec pr_Movimenta_estoque  
        1,                       --Acerto do Saldo do Produto
        1,                       --Tipo de Movimentação de Estoque ( Real )
        0,                       --Tipo de Movimentação de Estoque (OLD)
        @cd_produto,             --Produto
        @cd_fase_produto,        --Fase de Produto
        @qt_planejada_processo,  --Quantidade
        0.00,                    --Quantidade Antiga
        @dt_documento_movimento, --Data do Movimento de Estoque
        @cd_processo,             --Pedido de Venda
        @cd_item_pedido_venda,   --Item do Pedido
        12,                       --Tipo de Documento
        null,                    --Data do Pedido
        NULL,                    --Centro de Custo
        null                  ,  --Valor Unitário
        null,                    --Valor Total
        'N',                     --Peps Não
        'N',                     --Mov. Terceiro
        @nm_historico_movimento,                    --Histórico
        'E',                     --Mov. Saída
        null,                    --Cliente
        'S',                    --Fase de Entrada ?
        '0',                     --Fase de Entrada
        @cd_usuario,
        @dt_hoje,                    --Data do Usuário
        1,                       --Tipo de Destinatário = Cliente
        null, 
        0.00,                    --Valor Fob
        0.00,                    --Custo Contábil,
        0.00,                    --Valor Fob Convertido,
        0,                       --Produto Anterior
        0,                       --Fase Anterior
        'N',                     --Consignação, 
        'N',                     --Amostra         
        'A',                     --Tipo de Lançamento = 'A'=Automático 
        0,                       --Item da Composição
        0,                       --Histórico
        NULL,                    --Operação Fiscal,
        NULL,                    --Série da Nota
        null,                    --Código do Movimento de Estoque   
        NULL,                    --Lote 
        NULL,                    --Tipo de Movimento Transferência
        NULL,                    --Unidade
        NULL,                    --Unidade Origem
        NULL,                    --Fator
        NULL,                    --Qtd. Original
        'N',                     --Atualiza Saldo Lote
        NULL,                    --Lote Anterior
        NULL                     --Custo da Comissão,
--        @cd_movimento_estoque = @P1 output
--        null                     

--   select @p1

   delete from #baixaprocesso
   where
     cd_processo = @cd_processo

end
 
---------------------------------------------------------------------------------
--Saídas dos componentes
---------------------------------------------------------------------------------

while exists( select top 1 cd_processo from #baixa_composicao)
begin
  
  select
    top 1
    @cd_processo            = isnull(cd_processo,0),
    @cd_componente_processo = isnull(cd_componente_processo,0),
    @cd_fase_produto        = cd_fase_produto,
    @qt_planejada_processo  = qt_comp_processo,
    @dt_documento_movimento = dt_fimprod_processo,
    @cd_pedido_venda        = cd_pedido_venda,
    @cd_item_pedido_venda   = cd_item_pedido_venda,
    @nm_historico_movimento = 'Proc.: '+cast(@cd_processo as varchar)+'/'+ 'Pv.: '+cast(@cd_pedido_venda as varchar),
    @cd_produto             = cd_produto

  from
    #baixa_composicao


  --Baixa o Estoque

      exec pr_Movimenta_estoque  
        1,                       --Acerto do Saldo do Produto
        11,                      --Tipo de Movimentação de Estoque ( Real )
        0,                       --Tipo de Movimentação de Estoque (OLD)
        @cd_produto,             --Produto
        @cd_fase_produto,        --Fase de Produto
        @qt_planejada_processo,  --Quantidade
        0.00,                    --Quantidade Antiga
        @dt_documento_movimento, --Data do Movimento de Estoque
        @cd_processo,             --Pedido de Venda
        @cd_item_pedido_venda,   --Item do Pedido
        12,                       --Tipo de Documento
        null,                    --Data do Pedido
        NULL,                    --Centro de Custo
        null                  ,  --Valor Unitário
        null,                    --Valor Total
        'N',                     --Peps Não
        'N',                     --Mov. Terceiro
        @nm_historico_movimento,                    --Histórico
        'S',                     --Mov. Saída
        null,                    --Cliente
        'S',                    --Fase de Entrada ?
        '0',                     --Fase de Entrada
        @cd_usuario,
        @dt_hoje,                    --Data do Usuário
        1,                       --Tipo de Destinatário = Cliente
        null, 
        0.00,                    --Valor Fob
        0.00,                    --Custo Contábil,
        0.00,                    --Valor Fob Convertido,
        0,                       --Produto Anterior
        0,                       --Fase Anterior
        'N',                     --Consignação, 
        'N',                     --Amostra         
        'A',                     --Tipo de Lançamento = 'A'=Automático 
        0,                       --Item da Composição
        0,                       --Histórico
        NULL,                    --Operação Fiscal,
        NULL,                    --Série da Nota
        null,                    --Código do Movimento de Estoque   
        NULL,                    --Lote 
        NULL,                    --Tipo de Movimento Transferência
        NULL,                    --Unidade
        NULL,                    --Unidade Origem
        NULL,                    --Fator
        NULL,                    --Qtd. Original
        'N',                     --Atualiza Saldo Lote
        NULL,                    --Lote Anterior
        NULL                     --Custo da Comissão,
--        @cd_movimento_estoque = @P1 output
--        null                     

--   select @p1

   delete from #baixa_composicao
   where
     cd_processo = @cd_processo
     and
     cd_componente_processo =  @cd_componente_processo

end
 
--select * from movimento_estoque



-------------------------------------------------------------------------------
--sp_helptext pr_analise_conferencia_entrada_estoque
-------------------------------------------------------------------------------
--pr_analise_conferencia_entrada_estoque
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Conferência de Entrada do Estoque
--Data             : 28.04.2010 - Carlos Fernandes/Márcio
--Alteração        : 09.09.2010 - Ajustes Diversos - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_analise_conferencia_entrada_estoque
@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_usuario int      = 0

as

--select * from nota_entrada

select 
  ne.cd_nota_entrada,
  ne.dt_nota_entrada,
  ne.dt_receb_nota_entrada,
  vw.nm_fantasia,
  ne.vl_total_nota_entrada

from
  nota_entrada ne                    with (nolock) 
  left outer join vw_destinatario vw on vw.cd_destinatario = ne.cd_fornecedor and
                                        vw.cd_tipo_destinatario = ne.cd_tipo_destinatario
where
  dt_nota_entrada between @dt_inicial and @dt_final
  and
  cd_nota_entrada not in ( select cd_documento_movimento from movimento_estoque 
                           where
                             cd_tipo_movimento_estoque = 1 and
                             ic_mov_movimento = 'E' )

select 
  ne.cd_nota_entrada,
  ne.dt_nota_entrada,
  ne.dt_receb_nota_entrada,
  vw.nm_fantasia,
  ne.vl_total_nota_entrada,
  ne.cd_operacao_fiscal,
  ne.cd_serie_nota_fiscal,
  nei.cd_item_nota_entrada,
  nei.cd_produto,
  nei.qt_item_nota_entrada,
  nei.cd_fase_produto,
  vw.cd_tipo_destinatario,
  ne.cd_fornecedor

into
  #Entrada_Estoque
  
from
  nota_entrada ne                       with (nolock) 

  left outer join vw_destinatario vw    with (nolock) on vw.cd_destinatario      = ne.cd_fornecedor and
                                                         vw.cd_tipo_destinatario = ne.cd_tipo_destinatario

  left outer join nota_entrada_item nei with (nolock) on nei.cd_nota_entrada      = ne.cd_nota_entrada and
                                                         nei.cd_operacao_fiscal   = ne.cd_operacao_fiscal and
                                                         nei.cd_fornecedor        = ne.cd_fornecedor      and
                                                         nei.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal

  left outer join operacao_fiscal opf   with (nolock) on opf.cd_operacao_fiscal   = ne.cd_operacao_fiscal

where
  ne.dt_nota_entrada between @dt_inicial and @dt_final
  and
  ne.cd_nota_entrada not in ( select cd_documento_movimento from movimento_estoque 
                              where
                                cd_tipo_movimento_estoque = 1 and
                                ic_mov_movimento = 'E' )

  and isnull(opf.ic_estoque_op_fiscal,'N')='S'
  and isnull(nei.cd_produto,0)>0
  
--operacao_fiscal

--select * from #Entrada_Estoque


--select * from movimento_estoque

------------------------------------------------------------------------------------------------
--Gerando a Entrada no Estoque
------------------------------------------------------------------------------------------------
declare @cd_produto             int
declare @cd_fase_produto        int
declare @qt_entrada             float
declare @dt_documento_movimento datetime
declare @nm_historico_movimento varchar(40)
declare @dt_hoje                datetime
declare @p1                     int
declare @cd_operacao_fiscal     int
declare @cd_fornecedor          int
declare @cd_nota_entrada        int
declare @cd_item_nota_entrada   int
declare @cd_tipo_destinatario   int

set @cd_nota_entrada = 0
set @dt_hoje = getdate()

while exists( select top 1 cd_produto from #Entrada_Estoque)
begin
  
  select
    top 1
    @cd_nota_entrada        = isnull(cd_nota_entrada,0),
    @cd_fase_produto        = cd_fase_produto,
    @qt_entrada             = qt_item_nota_entrada,
    @dt_documento_movimento = dt_receb_nota_entrada,
    @nm_historico_movimento = 'NFE : '+cast(@cd_nota_entrada as varchar)+'-'+ nm_fantasia,
    @cd_produto             = cd_produto,
    @cd_item_nota_entrada   = cd_item_nota_entrada,
    @cd_operacao_fiscal     = cd_operacao_fiscal,
    @cd_fornecedor          = cd_fornecedor,
    @cd_tipo_destinatario   = cd_tipo_destinatario

  from
    #Entrada_Estoque

--  select @cd_nota_entrada,@cd_produto,@qt_entrada

  delete from #entrada_estoque
   where
     cd_nota_entrada      = @cd_nota_entrada        and
     cd_operacao_fiscal   = @cd_operacao_fiscal     and
     cd_item_nota_entrada = @cd_item_nota_entrada   and
     cd_produto           = @cd_produto             and
     cd_fase_produto      = @cd_fase_produto        and
     cd_fornecedor        = @cd_fornecedor 

  --Entrada no Estoque
  --select * from tipo_documento_estoque

      exec pr_Movimenta_estoque  
        1,                       --Acerto do Saldo do Produto
        1,                       --Tipo de Movimentação de Estoque ( Real )
        0,                       --Tipo de Movimentação de Estoque (OLD)
        @cd_produto,             --Produto
        @cd_fase_produto,        --Fase de Produto
        @qt_entrada,             --Quantidade
        0.00,                    --Quantidade Antiga
        @dt_documento_movimento, --Data do Movimento de Estoque
        @cd_nota_entrada,        --Pedido de Venda
        @cd_item_nota_entrada,   --Item do Pedido
        3,                       --Tipo de Documento
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
        @cd_tipo_destinatario,                       --Tipo de Destinatário = Cliente
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

end


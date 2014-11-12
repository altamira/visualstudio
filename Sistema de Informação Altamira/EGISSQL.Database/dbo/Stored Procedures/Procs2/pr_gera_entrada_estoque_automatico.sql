
-------------------------------------------------------------------------------
--pr_gera_entrada_estoque_automatico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração de Entrada de Estoque Automaticamente
--                   Através de uma Tabela Temporária
--Data             : 31.10.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_entrada_estoque_automatico
@cd_usuario                int         = 0,
@dt_movimento_estoque      datetime    = '',
@cd_tipo_movimento_estoque int         = 1,
@cd_tipo_documento_estoque int         = 1,
@cd_documento_estoque      varchar(20) = '',
@cd_historico_estoque      int         = 0,
@nm_historico_estoque      varchar(255)= '',
@ic_zera_movimento         char(1)     = 'N'

as

-- campo chave utilizando a tabela de códigos
-- exec EgisADMIN.dbo.sp_PegaCodigo @Tabela, 'cd_documento_receber', @codigo = @cd_documento_receber output
---exec EgisADMIN.dbo.sp_LiberaCodigo @Tabela, @cd_documento_receber, 'D'
--select * from movimento_estoque
--declare @Tabela		     varchar(50)

-- Nome da Tabela usada na geração e liberação de códigos
--    set @Tabela = cast(DB_NAME()+'.dbo.Documento_Receber' as varchar(50))

if @ic_zera_movimento = 'S' 
   delete from Movimento_Estoque

--Busca do último código disponível

declare @cd_movimento_estoque int

select 
  @cd_movimento_estoque = isnull( max(cd_movimento_estoque)+1, 1 )
from
  Movimento_Estoque


if @cd_movimento_estoque = 0
   set @cd_movimento_estoque = 1

select
  identity(int,1,1)                     as cd_movimento_estoque,
  @dt_movimento_estoque                 as dt_movimento_estoque,
  @cd_tipo_movimento_estoque            as cd_tipo_movimento_estoque,
  @cd_documento_estoque                 as cd_documento_movimento,
  1                                     as cd_item_documento,
  @cd_tipo_documento_estoque            as cd_tipo_documento_estoque,
  @dt_movimento_estoque                 as dt_documento_movimento,
  null                                  as cd_centro_custo,
  m.qt_inventario                       as qt_movimento_estoque,
  null                                  as vl_unitario_movimento,
  null                                  as vl_total_movimento,
  pc.ic_peps_produto                    as ic_peps_movimento_estoque,
  null                                  as ic_terceiro_movimento,
  null                                  as ic_consig_movimento,
  @nm_historico_estoque                 as nm_historico_movimento,
  'E'                                   as ic_mov_movimento,
  null                                  as cd_fornecedor,
  p.cd_produto                          as cd_produto,
  isNull(m.cd_fase_produto,3)           as cd_fase_produto,
  null                                  as ic_fase_entrada_movimento,
  null                                  as cd_fase_produto_entrada,
  null                                  as ds_observacao_movimento,
  null                                  as vl_fob_produto,
  null                                  as cd_lote_produto,
  null                                  as vl_custo_contabil_produto,
  null                                  as nm_referencia_movimento,
  @cd_usuario                           as cd_usuario,
  getdate()                             as dt_usuario,
  null                                  as cd_origem_baixa_produto,
  null                                  as cd_item_movimento,
  null                                  as ic_consig_mov_estoque,
  p.cd_unidade_medida                   as cd_unidade_medida,
  null                                  as cd_historico_estoque,
  null                                  as cd_tipo_destinatario,
  null                                  as nm_destinatario,
  null                                  as nm_invoice,
  null                                  as nm_di,
  null                                  as vl_fob_convertido,
  'A'                                   as ic_tipo_lancto_movimento,
  null                                  as ic_amostra_movimento,
  null                                  as cd_item_composicao,
  null                                  as ic_canc_movimento_estoque,
  null                                  as cd_movimento_estoque_origem,
  null                                  as cd_movimento_saida_original,
  null                                  as cd_aplicacao_produto,
  null                                  as cd_serie_nota_fiscal,
  null                                  as cd_operacao_fiscal,
  null                                  as ic_tipo_terc_movimento,
  null                                  as ic_tipo_consig_movimento,
  null                                  as cd_unidade_origem,
  null                                  as qt_fator_produto_unidade,
  null                                  as qt_origem_movimento,
  null                                  as cd_loja,
  null                                  as qt_peso_movimento_estoque

into
  #Movimento_Estoque
from
  Produto_Inventario m
  left outer join Produto p        on p.cd_produto  = m.cd_produto
  left outer join Produto_Custo pc on pc.cd_produto = p.cd_produto
where
  isnull(m.qt_inventario,0)>0

--select * from produto_custo

-- update
--   #Movimento_Estoque
--  set
--   cd_movimento_estoque = cd_movimento_estoque + @cd_movimento_estoque

--select * from #Movimento_Estoque

insert into
  Movimento_Estoque
(
cd_movimento_estoque,
dt_movimento_estoque,
cd_tipo_movimento_estoque,
cd_documento_movimento,
cd_item_documento,
cd_tipo_documento_estoque,
dt_documento_movimento,
cd_centro_custo,
qt_movimento_estoque,
vl_unitario_movimento,
vl_total_movimento,
ic_peps_movimento_estoque,
ic_terceiro_movimento,
ic_consig_movimento,
nm_historico_movimento,
ic_mov_movimento,
cd_fornecedor,
cd_produto,
cd_fase_produto,
ic_fase_entrada_movimento,
cd_fase_produto_entrada,
ds_observacao_movimento,
vl_fob_produto,
cd_lote_produto,
vl_custo_contabil_produto,
nm_referencia_movimento,
cd_usuario,
dt_usuario,
cd_origem_baixa_produto,
cd_item_movimento,
ic_consig_mov_estoque,
cd_unidade_medida,
cd_historico_estoque,
cd_tipo_destinatario,
nm_destinatario,
nm_invoice,
nm_di,
vl_fob_convertido,
ic_tipo_lancto_movimento,
ic_amostra_movimento,
cd_item_composicao,
ic_canc_movimento_estoque,
cd_movimento_estoque_origem,
cd_movimento_saida_original,
cd_aplicacao_produto,
cd_serie_nota_fiscal,
cd_operacao_fiscal,
ic_tipo_terc_movimento,
ic_tipo_consig_movimento,
cd_unidade_origem,
qt_fator_produto_unidade,
qt_origem_movimento,
cd_loja,
qt_peso_movimento_estoque)

select
cd_movimento_estoque + @cd_movimento_estoque,
dt_movimento_estoque,
cd_tipo_movimento_estoque,
cd_documento_movimento,
cd_item_documento,
cd_tipo_documento_estoque,
dt_documento_movimento,
cd_centro_custo,
qt_movimento_estoque,
vl_unitario_movimento,
vl_total_movimento,
ic_peps_movimento_estoque,
ic_terceiro_movimento,
ic_consig_movimento,
nm_historico_movimento,
ic_mov_movimento,
cd_fornecedor,
cd_produto,
cd_fase_produto,
ic_fase_entrada_movimento,
cd_fase_produto_entrada,
ds_observacao_movimento,
vl_fob_produto,
cd_lote_produto,
vl_custo_contabil_produto,
nm_referencia_movimento,
cd_usuario,
dt_usuario,
cd_origem_baixa_produto,
cd_item_movimento,
ic_consig_mov_estoque,
cd_unidade_medida,
cd_historico_estoque,
cd_tipo_destinatario,
nm_destinatario,
nm_invoice,
nm_di,
vl_fob_convertido,
ic_tipo_lancto_movimento,
ic_amostra_movimento,
cd_item_composicao,
ic_canc_movimento_estoque,
cd_movimento_estoque_origem,
cd_movimento_saida_original,
cd_aplicacao_produto,
cd_serie_nota_fiscal,
cd_operacao_fiscal,
ic_tipo_terc_movimento,
ic_tipo_consig_movimento,
cd_unidade_origem,
qt_fator_produto_unidade,
qt_origem_movimento,
cd_loja,
qt_peso_movimento_estoque
from 
  #Movimento_Estoque


drop table #Movimento_Estoque
--delete from produto_inventario

--select * from Movimento_Estoque



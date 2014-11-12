
-------------------------------------------------------------------------------
--sp_helptext pr_gera_movimento_estoque_nota_custo_importacao
-------------------------------------------------------------------------------
--pr_gera_movimento_estoque_nota_custo_importacao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Gera Movimento de Estoque com as Notas de Importação
--                   Despesas/Custos de Importação
--                   Para Geração da Valoração de Estoque
--
--Data             : 04.08.2009
--Alteração        : 04.12.2009 - Chamada externa de dentro da importação
--17.12.2009
--
------------------------------------------------------------------------------
create procedure pr_gera_movimento_estoque_nota_custo_importacao
@dt_inicial datetime = '',
@dt_final   datetime = '',
@cd_usuario int      = 0

as


--select * from operacao_fiscal

select
  ns.cd_nota_saida,
  ns.dt_nota_saida,
  ns.cd_cliente,
  ns.nm_fantasia_nota_saida,
  ns.cd_serie_nota,
  ns.cd_operacao_fiscal

into
  #Nota_Custo
     
from
  nota_saida NS                  with (nolock) 
  inner join operacao_fiscal opf with (nolock) on opf.cd_operacao_fiscal = ns.cd_operacao_fiscal

where
  ns.dt_nota_saida between @dt_inicial and @dt_final
  and (isnull(opf.ic_imp_operacao_fiscal,'N') = 'S' or isnull(opf.ic_importacao_op_fiscal,'N')='S' )
  and isnull(opf.ic_complemento_op_fiscal,'N')= 'S'
  and ns.dt_cancel_nota_saida is null  
  and ns.cd_status_nota <> 7  --Nota Fechada não pode estar Cancelada

--select * from status_nota   

--SELECT * FROM #Nota_Custo order by cd_nota_saida
  
--movimento_estoque
declare @cd_movimento_estoque int 

select
  @cd_movimento_estoque = isnull(max(cd_movimento_estoque),0) + 1
from
  Movimento_Estoque with (nolock) 

if @cd_movimento_estoque = 0
begin
   set @cd_movimento_estoque = 1
end

--select * from nota_saida_item

select
  @cd_movimento_estoque                     as cd_movimento_estoque,
  ns.dt_nota_saida                          as dt_movimento_estoque,
  1                                         as cd_tipo_movimento_estoque,
  cast(ns.cd_nota_saida as varchar(20))     as cd_documento_movimento,
  i.cd_item_nota_saida                      as cd_item_documento,
  3                                         as cd_tipo_documento_estoque,
  ns.dt_nota_saida                          as dt_documento_movimento,
  null                                      as cd_centro_custo,
  0.00                                      as qt_movimento_estoque,
  0.00                                      as vl_unitario_movimento,
  0.00                                      as vl_total_movimento,
  'S' as ic_peps_movimento_estoque,
  'N' as ic_terceiro_movimento,
  'N' as ic_consig_movimento,
  'NF COMPL./DESP. IMPORTACAO'              as  nm_historico_movimento,
  'E'                                       as ic_mov_movimento,
  ns.cd_cliente                             as cd_fornecedor,
  i.cd_produto,
  i.cd_fase_produto,
  null                                      as ic_fase_entrada_movimento,
  null                                      as cd_fase_produto_entrada,
  null                                      as ds_observacao_movimento,
  null                                      as vl_fob_produto,
  null                                      as cd_lote_produto,
  i.vl_total_item                           as vl_custo_contabil_produto,
  null                                      as nm_referencia_movimento,
  @cd_usuario                               as cd_usuario,
  getdate()                                 as dt_usuario,
  null                                      as cd_origem_baixa_produto,
  null                                      as cd_item_movimento,
  'N'                                       as ic_consig_mov_estoque,
  i.cd_unidade_medida,
  null as cd_historico_estoque,
  2    as cd_tipo_destinatario,
  ns.nm_fantasia_nota_saida                 as nm_destinatario,
  null                                      as nm_invoice,
  null                                      as nm_di,
  null                                      as vl_fob_convertido,
  null                                      as ic_tipo_lancto_movimento,
  null                                      as ic_amostra_movimento,
  null                                      as cd_item_composicao,
  null                                      as ic_canc_movimento_estoque,
  null                                      as cd_movimento_estoque_origem,
  null                                      as cd_movimento_saida_original,
  null                                      as cd_aplicacao_produto,
  ns.cd_serie_nota                          as cd_serie_nota_fiscal,
  ns.cd_operacao_fiscal,
  null                                      as ic_tipo_terc_movimento,
  null                                      as ic_tipo_consig_movimento,
  null                                      as cd_unidade_origem,
  null                                      as qt_fator_produto_unidade,
  null                                      as qt_origem_movimento,
  identity(int,1,1)                         as cd_loja,
  null                                      as qt_peso_movimento_estoque,
  null                                      as vl_custo_comissao,
  'S'                                       as ic_nf_complemento

into
  #movimento_estoque

from
  #Nota_Custo ns
  inner join nota_saida_item i on i.cd_nota_saida = ns.cd_nota_saida

update
  #movimento_estoque
set
  cd_movimento_estoque = cd_movimento_estoque + cd_loja
 
--select * from #movimento_estoque

--Insere o Movimento

insert into
  movimento_estoque
select
  x.*
from
  #movimento_estoque x

where
  x.cd_documento_movimento not in ( select cd_documento_movimento
                                    from movimento_estoque me
                                    where
                                      me.cd_documento_movimento = x.cd_documento_movimento and  
                                      me.cd_item_documento      = x.cd_item_documento and 
                                      me.ic_nf_complemento      = 'S' )


  
 drop table #movimento_estoque
 drop table #Nota_Custo
    
--select * from movimento_estoque where cd_documento_movimento = '14940'
--select * from movimento_estoque where cd_tipo_destinatario is null

-- update
--   movimento_estoque
-- set
--   cd_tipo_destinatario = 2
-- where
--  nm_historico_movimento = 'NF COMPL./DESP. IMPORTACAO'

--select * from movimento_estoque

--delete from movimento_estoque where cd_movimento_estoque > 4347
--delete from movimento_estoque where cd_movimento_estoque = 6237


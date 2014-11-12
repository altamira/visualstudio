
-------------------------------------------------------------------------------
--pr_geracao_programacao_entrada_contrato
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração da Atualização da Programação no Contrato de Fornecimento
--                   para Fechamento do Pedido de Venda
--Data             : 08.11.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_geracao_programacao_entrada_contrato
@ic_parametro int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = '',
@cd_cliente   int      = 0,
@cd_produto   int      = 0,
@cd_usuario   int      = 0
as

select
  pe.cd_programacao_entrega,
  pe.dt_programacao_entrega,
  pe.dt_necessidade_entrega,
  pe.qt_programacao_entrega,
  pe.nm_obs_programacao_entrega,
  pe.cd_contrato_fornecimento,
  pe.cd_ano,
  pe.cd_mes
into
  #ProgramacaoAtualizacao
 
from
  Programacao_Entrega pe

where
  pe.dt_programacao_entrega between @dt_inicial and @dt_final      and
  pe.cd_cliente = case when @cd_cliente = 0 then pe.cd_cliente else @cd_cliente end and  
  pe.cd_produto = case when @cd_produto = 0 then pe.cd_produto else @cd_produto end

order by
  pe.cd_ano,pe.cd_mes, pe.cd_contrato_fornecimento


select * from #ProgramacaoAtualizacao


-- update
--   Contrato_Fornecimento_Item_Mes
-- set
--   qt_liberacao         = 
--   dt_liberacao         =
--   cd_usuario_liberacao = 
-- from
--   Contrato_Fornecimento_Item_Mes cfim
-- 
--   inner join Contrato_Fornecimento_Item on cfi on cfi.cd_contrato_fornecimento = p.cd_contrato_fornecimento and
--                                                   cfi.cd_produto               = p.cd_produto
-- 
--   inner join #ProgramacaoAtualizacao p     on p.cd_contrato_fornecimento = 
-- 


--select * from programacao_entrega
--select * from contrato_fornecimento_item_mes
--select * from contrato_forn_it_mes_liberacao
--qt_liberacao
--dt_liberacao
--cd_usuario_liberacao


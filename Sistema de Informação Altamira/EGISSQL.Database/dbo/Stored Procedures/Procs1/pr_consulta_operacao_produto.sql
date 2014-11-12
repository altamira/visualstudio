
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_operacao_produto
-------------------------------------------------------------------------------
--pr_consulta_operacao_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta das Operação do Processo Padrão
--Data             : 27.08.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_operacao_produto
@cd_produto int
as

select 
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  um.sg_unidade_medida,
  pp.cd_processo_padrao,
  ppc.cd_composicao_proc_padrao,
  o.nm_fantasia_operacao,
  o.nm_operacao, 
  m.nm_maquina,
  ppc.qt_hora_setup,
  ppc.qt_hora_operacao
  
  --select * from processo_padrao
  --select * from processo_padrao_produto
  --select * from processo_padrao_composicao
  --select * from operacao
  --select * from produto_processo
  --select * from produto_producao

from
  Produto p                                      with (nolock)
  left outer join produto_producao ppo           with (nolock) on ppo.cd_produto         = p.cd_produto
  left outer join processo_padrao pp             with (nolock) on pp.cd_processo_padrao  = ppo.cd_processo_padrao
  left outer join processo_padrao_composicao ppc with (nolock) on ppc.cd_processo_padrao = pp.cd_processo_padrao
  left outer join operacao o                     with (nolock) on o.cd_operacao          = ppc.cd_operacao  
  left outer join maquina  m                     with (nolock) on m.cd_maquina           = ppc.cd_maquina
  left outer join unidade_medida um              with (nolock) on um.cd_unidade_medida   = p.cd_unidade_medida
where
  p.cd_produto = case when @cd_produto = 0 then p.cd_produto else @cd_produto end
  and
  isnull(pp.cd_processo_padrao,0)<>0

order by
  p.nm_fantasia_produto
  



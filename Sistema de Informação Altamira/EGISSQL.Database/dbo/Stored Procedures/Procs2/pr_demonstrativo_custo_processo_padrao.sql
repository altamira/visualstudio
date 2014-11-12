
-------------------------------------------------------------------------------
--pr_demonstrativo_custo_processo_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta de Custos de Processo Padrão
--
--Data             : 21/02/2005
--Atualizado       : 21.12.2007 - Acerto do Valor do Custo da Embalagem - Carlos Fernandes
--------------------------------------------------------------------------------------------------
create procedure pr_demonstrativo_custo_processo_padrao
@cd_processo_padrao int = 0

as

--select * from processo_padrao

  select
    pp.cd_processo_padrao,
    pp.nm_processo_padrao,
    pp.dt_processo_padrao,
    pp.nm_identificacao_processo,
    pp.vl_custo_operacao,
    pp.vl_custo_componente,
    pp.vl_custo_servico,
    pp.vl_custo_maquina,
    pp.vl_total_custo_processo,

    case when isnull(pp.vl_custo_embalagem,0)>0
    then
     pp.vl_custo_embalagem
    else
     ( select sum( isnull(vl_custo_proc_embalagem,0) )
     from
       Processo_Padrao_Embalagem ppe
     where
       ppe.cd_processo_padrao = pp.cd_processo_padrao )
    end                      as vl_custo_embalagem,

    pp.pc_perda_processo,
    pp.qt_densidade_processo

    --Falta Criar o custo da embalagem com o Volume--

  from 
   processo_padrao pp with (nolock)
  where
   pp.cd_processo_padrao = case when @cd_processo_padrao = 0 then pp.cd_processo_padrao else @cd_processo_padrao end and
   isnull(vl_total_custo_processo,0)>0
  order by
    pp.nm_identificacao_processo
  


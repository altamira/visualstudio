
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_tempo_processo_padrao_ordem
-------------------------------------------------------------------------------
--pr_geracao_tempo_processo_padrao_ordem
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração dos Tempos do Processo de Produção conforme
--                   Apontamento no Processo Padrão
--Data             : 17.01.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_geracao_tempo_processo_padrao_ordem
@cd_processo        int = 0,
@cd_processo_padrao int = 0
as


--Verifica se foi passado o Processo de Produção

if @cd_processo>0
begin

  --select * from processo_producao

  if @cd_processo_padrao = 0
  begin
    select 
      @cd_processo_padrao = isnull(cd_processo_padrao,0)
    from
      processo_producao
    where
      cd_processo = @cd_processo
   
  end

  select @cd_processo_padrao

end

--Verifica se Existe o processo Padrão

if @cd_processo_padrao > 0
begin

  --select * from processo_producao_composicao
  --select * from processo_producao_apontamento

  select
    pp.cd_processo,
    ppc.cd_item_processo,
    ppc.cd_operacao,
    ppc.qt_hora_estimado_processo,
    ppc.qt_hora_real_processo,
    ppc.qt_hora_setup_processo
  into
    #ProcessoComposicao
  from
    processo_producao pp with (nolock)
    inner join processo_producao_composicao ppc with (nolock) on ppc.cd_processo = pp.cd_processo   
  where
    pp.cd_processo = @cd_processo


  select
    pp.cd_processo,
    ppa.cd_item_processo,
    ppa.cd_operacao,
    sum( isnull(ppa.qt_processo_apontamento,0)) as qt_processo_apontamento,
    sum( isnull(ppa.qt_setup_apontamento,0))    as qt_setup_apontamento
  into
    #ProcessoApontamento
  from
    processo_producao pp with (nolock)
    inner join processo_producao_apontamento ppa with (nolock) on ppa.cd_processo = pp.cd_processo   
    inner join operacao                      o   with (nolock) on o.cd_operacao   = ppa.cd_operacao
  where
    pp.cd_processo = @cd_processo and
    isnull(o.ic_analise_apontamento,'N') = 'S'

  group by
    pp.cd_processo,
    ppa.cd_item_processo,
    ppa.cd_operacao

--select * from operacao

  select
    *
  from
    #ProcessoComposicao

  select
    *
  from
    #ProcessoApontamento


  --select * from #ProcessoComposicao
  

end



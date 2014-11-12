
-------------------------------------------------------------------------------
--pr_agenda_visita_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin
--Objetivo         : Consulta da Agenda de Visita do Vendedor
--Data             : 15/01/2005
--Atualizado       : 18/01/2005
--Alteração        : 01/02/2005 - Psantos - Inserido parâmetro @ic_retorno_visita
--20.03.2008 - Acerto da Data de Pesquisa - Carlos Fernandes
--09.05.2008 - Data da Baixa da Visita/Motivo - Carlos Fernandes
--------------------------------------------------------------------------------------------------
create procedure pr_agenda_visita_vendedor

@cd_vendedor       int,           --Vendedor
@dt_inicial        datetime,      --Data Inicial
@dt_final          datetime,      --Data Final
@ic_retorno_visita char(1)  = 'N' -- Retorno Visita - (S)im ou (N)ão

as

select
  ve.nm_fantasia_vendedor        as Vendedor,
  ve.cd_telefone_vendedor        as Telefone,
  ve.cd_celular                  as Celular,
  ve.qt_visita_diaria_vendedor   as VisitaDiaria,
  vi.cd_visita,
  vi.dt_visita                   as DataVisita,
  vi.hr_inicio_visita            as Inicio,
  vi.hr_fim_visita               as Fim,
  vi.nm_assunto_visita           as Assunto,
  cp.nm_fantasia_cliente         as Cliente,
  ccp.nm_fantasia_contato        as Contato,
  tv.nm_tipo_visita              as Tipo,
  mv.nm_motivo_visita            as Motivo,
  rac.nm_ramo_atividade          as Segmento,
  vi.dt_retorno_visita           as Retorno,
  vi.ds_visita                   as Historico,
  ot.nm_operador_telemarketing   as Operador,
  vi.nm_obs_visita               as Observacao,
  vi.ic_particular_visita        as Particular,
  vb.dt_baixa_visita,
  vb.nm_baixa_visita

from 
  Vendedor ve with (nolock) 
left outer join Visita vi
  on vi.cd_vendedor = ve.cd_vendedor
left outer join Cliente_Prospeccao cp
  on vi.cd_cliente_prospeccao = cp.cd_cliente_prospeccao
left outer join Cliente_Prospeccao_Contato ccp 
  on cp.cd_cliente_prospeccao = ccp.cd_cliente_prospeccao
left outer join Motivo_visita mv
  on vi.cd_motivo_visita = mv.cd_motivo_visita
left outer join Tipo_visita tv
  on vi.cd_tipo_visita = mv.cd_motivo_visita            
left outer join Operador_Telemarketing ot
  on vi.cd_operador_telemarketing = ot.cd_operador_telemarketing
left outer join Ramo_atividade rac
  on cp.cd_ramo_atividade = rac.cd_ramo_atividade  
left outer join Visita_Baixa vb on vb.cd_visita = vi.cd_visita
where
  ve.cd_vendedor = case when @cd_vendedor = 0 then 
                     ve.cd_vendedor 
                   else 
                     @cd_vendedor 
                   end 
and isnull(ve.ic_ativo,'N') = 'S'    
and vi.dt_visita between @dt_inicial and @dt_final
and isnull(vi.ic_retorno_visita, '') = case when isnull(@ic_retorno_visita,'') = '' then
                             isnull(vi.ic_retorno_visita, '')
                           else
                             isnull(@ic_retorno_visita, '')
                           end



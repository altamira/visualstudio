
-------------------------------------------------------------------------------
--pr_lancamento_visita_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Lançamento Manual de Visitas por Vendedor
--Data             : 15/01/2005
--Atualizado       : 21.04.2006 
--                   30/08/2006 - Incluído consistencia no campo de cliente para trazer o código
-- do cliente prospecção neste mesmo campo pra facilitar programação - Daniel Carrasco. 
-- 09.05.2008 - Mostrar a Data da Baixa da Visita - Carlos Fernandes
--------------------------------------------------------------------------------------------------
create procedure pr_lancamento_visita_vendedor
@cd_vendedor  int,       --Vendedor
@dt_inicial   datetime,  --Data Inicial
@dt_final     datetime,   --Data Final
@ic_parametro int = 0    --Data Final

as
	if @ic_parametro = 0
	begin
	select 
          ve.nm_fantasia_vendedor        as Vendedor,
          ve.cd_telefone_vendedor        as Telefone,
          ve.cd_celular                  as Celular,
          ve.qt_visita_diaria_vendedor   as VisitaDiaria,
          vi.cd_visita                   as Codigo,
          vi.dt_visita                   as DataVisita,
          vi.hr_inicio_visita            as Inicio,
          vi.hr_fim_visita               as Fim,
          vi.nm_assunto_visita           as Assunto,

          case when isnull(vi.cd_cliente,0) > 0
            then c.nm_fantasia_cliente
            else cp.nm_fantasia_cliente end as Cliente,

          case when isnull(vi.cd_contato,0) > 0
            then cc.nm_contato_cliente
            else ccp.nm_fantasia_contato  end as Contato,

          case when isnull(vi.cd_contato,0) > 0
            then 'Cliente'
            else 'Prospect'  end as TipoContato,

          tv.nm_tipo_visita              as Tipo,
          mv.nm_motivo_visita            as Motivo,

          case when isnull(c.cd_ramo_atividade,0)>0
            then  ra.nm_ramo_atividade
            else rac.nm_ramo_atividade end as Segmento,

          vi.dt_retorno_visita           as Retorno,
          vi.ds_visita                   as Historico,
          ot.nm_operador_telemarketing   as Operador,
          vi.nm_obs_visita               as Observacao,
          vi.ic_particular_visita        as Particular,
          vi.cd_cancelamento_visita,
          IsNull(vi.cd_cliente, vi.cd_cliente_prospeccao) as  cd_cliente,
          vi.cd_contato,
          vi.cd_motivo_visita,
          vi.cd_operador_telemarketing,
          vi.cd_prospeccao,
          vi.cd_prospeccao_contato,
          vi.cd_tipo_horario_visita,
          vi.cd_tipo_visita,
          vi.cd_usuario,
          vi.cd_vendedor,
          vi.cd_visita,
          vi.ds_visita_retorno,
          vi.dt_agenda_visita,
          vi.dt_cancelamento_visita,
          vi.dt_usuario,
          vi.dt_visita,
          vi.hr_fim_visita,
          vi.hr_inicio_visita,
          vi.ic_lembrete_visita,
          vi.ic_retorno_visita,
          vi.nm_assunto_visita,
          vi.qt_dia_lembrete_visita,
          vb.dt_baixa_visita,
          vb.nm_baixa_visita
        from
          Vendedor ve                           with (nolock) 
          left outer join Visita  vi            with (nolock) on vi.cd_vendedor            = ve.cd_vendedor
          left outer join Cliente c             with (nolock) on vi.cd_cliente             = c.cd_cliente
          left outer join Cliente_Prospeccao cp with (nolock) on vi.cd_cliente_prospeccao  = cp.cd_cliente_prospeccao
          left outer join Cliente_Contato cc    with (nolock) on (vi.cd_cliente            = cc.cd_cliente   and vi.cd_contato = cc.cd_contato )
          left outer join Cliente_Prospeccao_Contato ccp  with (nolock) on vi.cd_cliente_prospeccao = cp.cd_cliente_prospeccao and
                                                                           vi.cd_prospeccao_contato = ccp.cd_prospeccao_contato
          left outer join Motivo_visita mv          with (nolock) on vi.cd_motivo_visita  = mv.cd_motivo_visita
          left outer join Tipo_visita tv            with (nolock) on tv.cd_tipo_visita    = mv.cd_motivo_visita
          left outer join Operador_Telemarketing ot with (nolock) on vi.cd_operador_telemarketing = ot.cd_operador_telemarketing
          left outer join Ramo_atividade ra         with (nolock) on c.cd_ramo_atividade  = ra.cd_ramo_atividade
          left outer join Ramo_atividade rac        with (nolock) on cp.cd_ramo_atividade = rac.cd_ramo_atividade
          left outer join Visita_Baixa vb           with (nolock) on vb.cd_visita         = vi.cd_visita
        where
          ve.cd_vendedor = case when @cd_vendedor = 0 then ve.cd_vendedor  else @cd_vendedor end
          and isnull(ve.ic_ativo,'N') = 'S'
          and vi.dt_visita between @dt_inicial and @dt_final
	end

	else if @ic_parametro = 1 
	begin
		  select
          ve.cd_vendedor,
		    ve.nm_vendedor
        from
          Vendedor ve with (nolock) 
          left outer join Visita  vi            on vi.cd_vendedor           = ve.cd_vendedor
        where
          ve.cd_vendedor = case when @cd_vendedor = 0 then ve.cd_vendedor  else @cd_vendedor end
          and isnull(ve.ic_ativo,'N') = 'S'
          and vi.dt_visita between @dt_inicial and @dt_final
		  group by
			 ve.cd_vendedor ,
			 ve.nm_vendedor
	end


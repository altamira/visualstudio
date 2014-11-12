
CREATE PROCEDURE pr_movimento_plano_financeiro_diaro
@cd_plano_financeiro      int,
@cd_tipo_lancamento_fluxo int,
@dt_inicial               datetime,
@dt_final                 datetime,
@ic_parametro             int = 0

AS

--delete from plano_financeiro_movimento

declare @cd_empresa int

set @cd_empresa = dbo.fn_empresa()

if not exists( select top 1 pfm.cd_plano_financeiro from plano_financeiro_movimento pfm
           where
             pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final )

begin

  exec pr_atualiza_fluxo_caixa 
      @cd_empresa, 
      @cd_tipo_lancamento_fluxo, 
      @dt_inicial,
      @dt_final

end


    -- Fazendo somatória dos dias agrupados por plano e pelo dia do movimento.

      select pfm.cd_plano_financeiro,
             pfm.dt_movto_plano_financeiro as 'dt_movto_inicial_plano',
             sum(pfm.vl_plano_financeiro)  as 'vl_plano_financeiro',
             tof.nm_tipo_operacao
      into #Temp_Movto             
      from Plano_Financeiro_Movimento pfm with (nolock)                            inner join
           Plano_Financeiro pf          on pf.cd_plano_financeiro = pfm.cd_plano_financeiro left outer join
           Grupo_Financeiro gf          on gf.cd_grupo_financeiro = pf.cd_grupo_financeiro  left outer join
           tipo_operacao_financeira tof on tof.cd_tipo_operacao = gf.cd_tipo_operacao
      where
           pfm.dt_movto_plano_financeiro between @dt_inicial and @dt_final and
           ( ( pfm.cd_plano_financeiro = @cd_plano_financeiro ) or
           ( @cd_plano_financeiro = 0 ) ) and
           pfm.cd_tipo_lancamento_fluxo = @cd_tipo_lancamento_fluxo
      group by 
           pfm.cd_plano_financeiro, pfm.dt_movto_plano_financeiro, tof.nm_tipo_operacao

  select * from #Temp_Movto order by cd_plano_financeiro, dt_movto_inicial_plano, nm_tipo_operacao


  --Seria buscar diretamente do contas a Pagar / Receber





-------------------------------------------------------------------------------
--pr_troca_oleo_frota_veiculo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Frotas de Veículo por Cliente
--Data             : 06.05.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_troca_oleo_frota_veiculo
@cd_frota         int = 0,
@cd_veiculo       int = 0,
@dt_inicial       datetime = '',
@dt_final         datetime = ''

as

declare @qt_km_aviso_troca_oleo float

        select
          @qt_km_aviso_troca_oleo = isnull(qt_km_aviso_troca_oleo,3000)
        from
          Parametro_Frota
        where
          cd_empresa = dbo.fn_empresa()


        select
          v.cd_veiculo,
          v.nm_veiculo               as Veiculo,
          v.cd_placa_veiculo         as Placa,
          v.aa_veiculo               as Ano,
          gv.nm_grupo_veiculo        as GrupoVeiculo,
          tc.nm_tipo_combustivel     as Combustivel,

          rv.dt_previsao_saida as dt_remessa_viagem,
          rv.cd_viagem as cd_remessa_viagem,

          rv.qt_km_inicial as KmVeiculo,
          isnull(rv.qt_km_final,0) as qt_km_real_chegada,
          isnull(rv.qt_km_final,0) - isnull(rv.qt_km_inicial,0)         as KmRodado,
          isnull(rv.qt_km_final,0) - isnull(mv.qt_km_inicial_veiculo,0) as KmRodadoTroca,
          (isnull(qt_km_real_chegada,0) - isnull(QT_KM_INICIAL,0)) / isnull(qt_consumo_combustivel,1)          as MediaConsumo,
(isnull(mv.qt_km_inicial_veiculo,0) + isnull(mv.qt_km_validade_veiculo,0)) - (isnull(rv.qt_km_final,0) - isnull(mv.qt_km_inicial_veiculo,0)) as Teste,
          case when
            (isnull(mv.qt_km_inicial_veiculo,0) + isnull(mv.qt_km_validade_veiculo,0)) - (isnull(rv.qt_km_final,0) - isnull(mv.qt_km_inicial_veiculo,0)) < @qt_km_aviso_troca_oleo
          then
            'Sim'
          else
            'Não' end                                      as Troca,


          mv.dt_movimento_veiculo    as DataTroca,
          mv.qt_km_inicial_veiculo   as KmTroca,
          isnull(mv.qt_km_inicial_veiculo,0) + isnull(mv.qt_km_validade_veiculo,0)  as KmProximaTroca,
          isnull(mv.qt_km_validade_veiculo,0)  as qt_km_proximo_servico


        from
            Veiculo v
          left outer join Remessa_Viagem rv        on v.cd_veiculo  = rv.cd_veiculo
          left outer join Movimento_Veiculo    mv  on mv.cd_veiculo = v.cd_veiculo
          left outer join Veiculo_Servico      vs  on v.cd_veiculo  = vs.cd_veiculo and vs.cd_tipo_servico_veiculo = mv.cd_tipo_servico_veiculo
          left outer join Tipo_Servico_Veiculo tsv on tsv.cd_tipo_servico_veiculo = mv.cd_tipo_servico_veiculo
          left outer join Grupo_Veiculo gv         on gv.cd_grupo_veiculo    = v.cd_grupo_veiculo
          left outer join Tipo_Combustivel tc      on tc.cd_tipo_combustivel = v.cd_tipo_combustivel
        where
          isnull(tsv.ic_oleo_tipo_servico,'N') = 'S'                and
          mv.dt_movimento_veiculo between @dt_inicial and @dt_final and
--          rv.dt_previsao_saida    between @dt_inicial and @dt_final and
          rv.dt_previsao_saida > mv.dt_movimento_veiculo and 
          rv.cd_frota  = case when @cd_frota   = 0 then rv.cd_frota  else @cd_frota   end and
          rv.cd_veiculo = case when @cd_veiculo = 0 then rv.cd_veiculo else @cd_veiculo end
       order by 
         v.nm_veiculo,
         mv.dt_movimento_veiculo,
         rv.dt_remessa_viagem

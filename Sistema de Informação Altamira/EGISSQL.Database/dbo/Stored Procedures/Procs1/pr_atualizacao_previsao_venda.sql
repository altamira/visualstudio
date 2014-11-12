
CREATE PROCEDURE pr_atualizacao_previsao_venda

AS

--
--Atualização Potencial / Programado
--

update
  Previsao_Venda
set
  qt_potencial_previsao  = ( select sum ( isnull(qt_potencial,0) ) from previsao_venda_composicao apvc where apvc.cd_previsao_venda = pv.cd_previsao_venda ),
  qt_programado_previsao = ( select 
                               sum( isnull(qt_jan_previsao,0) +
                                    isnull(qt_fev_previsao,0) +
                                    isnull(qt_mar_previsao,0) +
                                    isnull(qt_abr_previsao,0) +
                                    isnull(qt_mai_previsao,0) +
                                    isnull(qt_jun_previsao,0) +
                                    isnull(qt_jul_previsao,0) +
                                    isnull(qt_ago_previsao,0) +
                                    isnull(qt_set_previsao,0) +
                                    isnull(qt_out_previsao,0) +
                                    isnull(qt_nov_previsao,0) +
                                    isnull(qt_dez_previsao,0) 
                                    ) 
                            from Previsao_Venda_Composicao apvc where apvc.cd_previsao_venda = pv.cd_previsao_venda )

from
  Previsao_Venda pv, Previsao_Venda_Composicao pvc
where
  pv.cd_previsao_venda = pvc.cd_previsao_venda

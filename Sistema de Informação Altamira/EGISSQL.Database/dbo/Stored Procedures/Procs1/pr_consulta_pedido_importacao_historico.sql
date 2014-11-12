
CREATE  procedure pr_consulta_pedido_importacao_historico
@cd_pedido_importacao int 
as
select 
        pih.cd_pedido_importacao
       ,pih.cd_pedido_imp_historico
       ,pih.dt_pedido_imp_historico
       ,pih.cd_historico_pedido
       ,pih.nm_pedido_imp_histor_1
       ,pih.nm_pedido_imp_histor_2 
       ,pih.nm_pedido_imp_histor_3
       ,pih.nm_pedido_imp_histor_4
       ,pih.cd_tipo_status_pedido
       ,tsp.nm_tipo_status_pedido
       ,pih.cd_item_ped_item
       ,pih.cd_modulo
       ,pih.cd_departamento
       ,pih.cd_processo
       ,pih.cd_usuario
       ,pih.dt_usuario
       ,pim.dt_pedido_importacao
       ,pim.cd_usuario as cd_usuario_pedido
       ,pim.cd_status_pedido
       ,spd.nm_status_pedido
       ,spd.sg_status_pedido
       ,pim.dt_canc_pedido_importacao
       ,pim.nm_canc_pedido_importacao
       ,pim.cd_motivo_canc_mot_ped_imp
       ,pim.pc_desconto_imp_ped
       ,pim.cd_tipo_pedido
       ,tpd.nm_tipo_pedido
       ,tpd.sg_tipo_pedido
       ,pim.dt_alteracao_pedido_imp
       ,pim.nm_alteracao_pedido_imp
       ,pim.ic_fechado_ped_importacao
       ,pim.dt_fechado_ped_importacao
      
from ((Pedido_Importacao_Historico pih
     left join tipo_status_pedido tsp
     on pih.cd_tipo_status_pedido = tsp.cd_tipo_status_pedido)
     join
     ((Pedido_Importacao pim
     left join status_pedido spd
     on pim.cd_status_pedido = spd.cd_status_pedido)
     left join tipo_pedido tpd
     on pim.cd_tipo_pedido = tpd.cd_tipo_pedido) 
     on pim.cd_pedido_importacao = pih.cd_pedido_importacao)

where pih.cd_pedido_importacao = @cd_pedido_importacao


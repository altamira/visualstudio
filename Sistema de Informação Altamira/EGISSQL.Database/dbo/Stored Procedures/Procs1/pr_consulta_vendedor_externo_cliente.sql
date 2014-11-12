
create procedure pr_consulta_vendedor_externo_cliente
@cd_cliente int,
@cd_tipo_vendedor int

as

select ve.cd_vendedor as codigo_vendedor, 
       ve.nm_vendedor as nome_vendedor,
       tp.nm_tipo_vendedor as tipo_vendedor

from Cliente cl, cliente_vendedor cv, 
     vendedor ve, tipo_vendedor tp

where cl.cd_cliente = cv.cd_cliente
  and cv.cd_vendedor = ve.cd_vendedor
  and ve.cd_tipo_vendedor = tp.cd_tipo_vendedor
  and cl.cd_cliente = @cd_cliente
  and ve.cd_tipo_vendedor = @cd_tipo_vendedor

order by ve.nm_vendedor


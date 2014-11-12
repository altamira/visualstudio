
create procedure pr_verifica_liberacao_pedido

@cd_pedido_compra          int

as

select distinct
  pc.cd_pedido_compra,
  pc.vl_total_pedido_ipi,
  da.cd_tipo_aprovacao,
  ta.nm_tipo_aprovacao,
  IsNull(pc.ic_aprov_comprador_pedido,'N') as 'ic_aprov_comprador_pedido',

  case when ((isnull(ta.ic_teto_tipo_aprovacao,'N')='S') and
             ((pc.vl_total_pedido_ipi)<=
              (select isnull(vl_pedido_compra_empresa,0) 
               from 
                 Parametro_suprimento with (nolock) 
               where cd_empresa = dbo.fn_empresa()))) then
    'S'
  when exists ( select x.cd_pedido_compra 
                from Pedido_Compra_Aprovacao x
                where x.cd_pedido_compra = pc.cd_pedido_compra and
                x.cd_tipo_aprovacao = da.cd_tipo_aprovacao) then 'S'
  else 'N' end as 'Aprovado',

  vl_teto_aprovacao = (select isnull(vl_pedido_compra_empresa,0)
                       from Parametro_suprimento with (nolock) 
                       where cd_empresa = dbo.fn_empresa())
	     
from
  Pedido_Compra pc                           with (nolock) 
  --Departamento_Aprovacao da 
  left outer join Departamento_Aprovacao da  with (nolock) on da.cd_departamento   = pc.cd_departamento
  left outer join Tipo_Aprovacao ta          with (nolock) on ta.cd_tipo_aprovacao = da.cd_tipo_aprovacao
where 
   pc.cd_pedido_compra = @cd_pedido_compra


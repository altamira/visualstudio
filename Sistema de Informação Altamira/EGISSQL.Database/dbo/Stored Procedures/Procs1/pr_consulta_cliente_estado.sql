
CREATE  PROCEDURE pr_consulta_cliente_estado
@ic_parametro integer,
@cd_estado    integer,
@cd_usuario   integer = 0

AS
-------------------------------------------------------------------------------------------
  if @ic_parametro = 1 ----Consulta Somente de acordo com Estado informado
-------------------------------------------------------------------------------------------
  begin
    Select
      ci.nm_cidade,
      e.sg_estado, 
      c.cd_cliente, 
      c.nm_fantasia_cliente,
      c.nm_razao_social_cliente, 
      c.cd_ddd, 
      c.cd_telefone,
      (select  max(pv.dt_pedido_venda) from Pedido_Venda pv
       where 
         pv.cd_cliente=c.cd_cliente) as 'UltimaCompra',
      (select max(ns.dt_nota_saida) from Nota_Saida ns
       where 
         ns.cd_cliente=c.cd_cliente) as 'UltimaFatura',
      (select count(pv.cd_pedido_venda) from Pedido_Venda pv
       left outer join Status_Pedido sp 
         on sp.cd_status_pedido=pv.cd_status_pedido
       where 
         sp.sg_status_pedido<>'PC' and
         pv.cd_cliente=c.cd_cliente) as 'Volume_total',
      (select count(pv.cd_pedido_venda) from Pedido_Venda pv
       left outer join Status_Pedido sp 
         on sp.cd_status_pedido=pv.cd_status_pedido
       where 
         sp.sg_status_pedido<>'PC' and
         pv.cd_cliente=c.cd_cliente and
         year(pv.dt_pedido_venda)=year(getdate())) as 'Volume_Ano' 
    from
      Cliente c
    Left Join Cidade ci On 
      c.cd_cidade = ci.cd_cidade
    Left Join Estado e On 
      ci.cd_estado = e.cd_estado
    where 
      (c.cd_estado=@cd_estado) and 
    	cd_vendedor = (Case dbo.fn_vendedor(@cd_usuario) When 0 then cd_vendedor else dbo.fn_vendedor(@cd_usuario) END)     
    order by ci.nm_cidade, c.nm_fantasia_cliente
  end


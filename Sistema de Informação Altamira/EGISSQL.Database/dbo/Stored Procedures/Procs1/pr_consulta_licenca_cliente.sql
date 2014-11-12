
CREATE PROCEDURE pr_consulta_licenca_cliente
  
  @ic_parametro int,
  @nm_fantasia_cliente varchar(40),
  @ic_tipo_consulta char(1)

---------------------------------------------------
--GBS - Global Business Solution	       2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto.	
--Banco de Dados: EgisSql
--Objetivo: Consultar Clientes e suas devidas Licença.
--Data: 18/07/2003
--Atualizado: 
---------------------------------------------------

AS

--------------------------------------------------------------
if @ic_parametro = 1 -- Consulta Clientes e suas Licenças Federais.
--------------------------------------------------------------
begin

  SELECT     c.nm_fantasia_cliente, 
	     c.cd_telefone, 
	     c.cd_ddd, 
	     c.dt_cadastro_cliente, 
   	     cd.cd_licenca_policia_fed, 
	     cd.dt_vcto_licenca,
             cast(cd.dt_vcto_licenca - GetDate() as Integer) as 'Dias',
             ( select max(x.dt_pedido_venda) 
	       from Pedido_Venda x 
	       where x.cd_cliente = c.cd_cliente and 
                     (x.dt_cancelamento_pedido is null) ) as 'Ultima_Compra',
             ( select sum(vl_total_pedido_venda)
               from Pedido_Venda x
	       where x.cd_cliente = c.cd_cliente and
                     year(x.dt_pedido_venda) = year(GetDate()) and
                     (x.dt_cancelamento_pedido is null) ) as 'Volume_Compra'

  FROM       Cliente c left outer join
             Cliente_Diversos cd ON c.cd_cliente = cd.cd_cliente 

  Where
    ( c.nm_fantasia_cliente like @nm_fantasia_cliente + '%' ) and
    ( ( cd.dt_vcto_licenca is null  and @ic_tipo_consulta = 'S') or
      ( cd.dt_vcto_licenca < GetDate() and @ic_tipo_consulta = 'V' and IsNull(ic_ativo_licenca,'N') = 'S' ) or
      ( cast(cd.dt_vcto_licenca - GetDate() as Integer) >= 0 and @ic_tipo_consulta = 'A' and
        IsNull(ic_ativo_licenca,'N') = 'S' ) or 
      ( @ic_tipo_consulta = 'T') )

  Order By
    c.nm_fantasia_cliente,
    cd.dt_vcto_licenca desc

end



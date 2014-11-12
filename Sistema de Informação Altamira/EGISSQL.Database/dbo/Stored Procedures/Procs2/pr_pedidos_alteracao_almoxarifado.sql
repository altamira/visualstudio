

/****** Object:  Stored Procedure dbo.pr_pedidos_alteracao_almoxarifado    Script Date: 13/12/2002 15:08:38 ******/

CREATE PROCEDURE pr_pedidos_alteracao_almoxarifado

@ic_parametro int,
@dt_inicial datetime,
@dt_final datetime,
@cd_cliente int,
@cd_pedido int

 
AS

--------------------------------------------------------------------------------------------
 if @ic_parametro = 1 -- Realiza a Consulta dos Pedidos com Alteração no Período
--------------------------------------------------------------------------------------------  

Begin

  SELECT     
  
  p.dt_cambio_pedido_venda,
  t.sg_tipo_pedido,
  p.cd_pedido_venda,
  p.dt_pedido_venda,
  c.nm_fantasia_cliente,
  u.nm_fantasia_usuario,
  p.nm_alteracao_pedido_venda

  from
    Pedido_Venda p
  left outer join
    Tipo_Pedido t
  on
    p.cd_tipo_pedido = t.cd_tipo_Pedido
  left outer join
    Cliente c
  on
    p.cd_cliente = c.cd_cliente
  left outer join
    Usuario u
  on
    p.cd_usuario = u.cd_usuario

  where
     p.dt_cambio_pedido_venda between @dt_inicial and @dt_final
  order by
     p.dt_usuario

end

--------------------------------------------------------------------------------------------
-- if @ic_parametro = 2 -- Realiza a consulta do item pelo pedido selecionado ( Pendente)
--------------------------------------------------------------------------------------------  

   

 

  
  
  




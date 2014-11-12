
CREATE PROCEDURE pr_consulta_pedido_compra_ativado
--pr_consulta_pedido_compra_ativado
---------------------------------------------------
--GBS - Global Business Sollution              2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Rafael M. Santiago 
--Banco de Dados: EgisSQl
--Objetivo: Mostrar os pedido compra com Ativacao
--Data: 26/05/2002
--Atualizado: 
---------------------------------------------------

@dt_inicial datetime,
@dt_final datetime,
@ic_tipo_filtro char(1) 
AS


  SELECT     
  
  p.dt_ativacao_pedido_compra,
  t.sg_tipo_pedido,
  p.cd_pedido_compra,
  p.dt_pedido_compra,
  f.nm_fantasia_fornecedor,
  f.nm_razao_social,
  u.nm_fantasia_usuario,
  p.ds_ativacao_pedido_compra,
  s.nm_status_pedido,
  s.sg_status_pedido

  from
    Pedido_Compra p
  left outer join
    Tipo_Pedido t
  on
    p.cd_tipo_pedido = t.cd_tipo_Pedido
  left outer join
    Fornecedor f
  on
    p.cd_fornecedor = f.cd_fornecedor
  left outer join
    Usuario u
  on
    p.cd_usuario = u.cd_usuario
  left outer join
    Status_Pedido s
  on
    p.cd_status_pedido = s.cd_status_pedido

  where
    (IsNull(p.dt_pedido_compra,getdate()) between 
      (case @ic_tipo_filtro when 'E' then @dt_inicial else IsNull(p.dt_pedido_compra,getdate()) end ) and 
      (case @ic_tipo_filtro when 'E' then @dt_final else IsNull(p.dt_pedido_compra,getdate()) end )
    )
    and
    (IsNull(p.dt_ativacao_pedido_compra, getdate()) between 
      (case @ic_tipo_filtro when 'A' then @dt_inicial else IsNull(p.dt_ativacao_pedido_compra, getdate()) end ) and 
      (case @ic_tipo_filtro when 'A' then @dt_final else IsNull(p.dt_ativacao_pedido_compra, getdate()) end )
    )
    and
    p.dt_ativacao_pedido_compra is not null
  order by
     p.dt_ativacao_pedido_compra



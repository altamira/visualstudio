
CREATE PROCEDURE pr_consulta_pedido_compra_alteracao
--pr_consulta_pedido_compra_alteracao
---------------------------------------------------
--GBS - Global Business Sollution              2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor 
--Banco de Dados: EgisSQl
--Objetivo: Mostrar os pedido compra com alteração
--Data: 31/05/2002
--Atualizado: 
---------------------------------------------------
@dt_inicial datetime,
@dt_final datetime 
AS


  SELECT     
  
  p.dt_alteracao_ped_compra,
  t.sg_tipo_pedido,
  p.cd_pedido_compra,
  p.dt_pedido_compra,
  f.nm_fantasia_fornecedor,
  f.nm_razao_social,
  u.nm_fantasia_usuario,
  p.ds_alteracao_ped_compra,
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
    EGISADMIN.dbo.Usuario u
  on
    p.cd_usuario = u.cd_usuario
  left outer join
    Status_Pedido s
  on
    p.cd_status_pedido = s.cd_status_pedido

  where
     p.dt_pedido_compra between @dt_inicial and @dt_final and
     p.dt_alteracao_ped_compra is not null
  order by
     p.dt_alteracao_ped_compra



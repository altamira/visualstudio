
CREATE    PROCEDURE pr_situacao_pedido_compra_consulta
--pr_situacao_pedido_compra_consulta
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Realizar uma consulta de Situação do Pedido_Compra
--Data: 29/06/2002
--Atualizado: 21/01/2004 - Incluído campo de hora.
--Atualizado: 16/09/2005 - Correção nos campos departamento e usuário.
--Atualizado: 24.10.2005 - FCM - Atualização na forma da pesquisa para tornar o processo de pesquisa mais rápido
---------------------------------------------------
@cd_pedido_compra as int
AS

    SELECT     
      ped.cd_pedido_Compra,
      ped.dt_pedido_Compra,
      ped.cd_comprador,
      (Select nm_comprador From Comprador Where cd_comprador = ped.cd_comprador) as 'nm_comprador',
      ped.dt_cancel_ped_compra,
      ped.ds_cancel_ped_compra,
      CAST(ped.vl_total_pedido_compra as numeric(25,2)) as 'vl_total_pedido_compra', 
      ped.qt_pesoliq_pedido_compra, 
      ped.qt_pesobruto_pedido_compra, 
      ped.dt_alteracao_ped_compra,
      ped.ds_alteracao_ped_compra,
      sp.cd_status_pedido,
      sp.nm_status_pedido,
      t.nm_transportadora,
      t.nm_fantasia,
      f.cd_fornecedor, 
      f.nm_fantasia_fornecedor, 
      f.nm_razao_social,
--       ped.cd_tipo_restricao_pedido, 
      ped.cd_tipo_pedido, 
      (Select nm_tipo_pedido From Tipo_pedido Where cd_tipo_pedido = ped.cd_tipo_pedido) as 'nm_tipo_pedido',
      ped.cd_contato_fornecedor, 
      (Select nm_fantasia_contato_forne From Fornecedor_Contato Where cd_contato_fornecedor = ped.cd_contato_fornecedor and cd_fornecedor = ped.cd_fornecedor) as 'nm_fantasia_contato',
      cop.nm_condicao_pagamento,
      cop.sg_condicao_pagamento,
      cop.qt_parcela_condicao_pgto,
      pch.dt_pedido_compra 'dt_pedido_historico',
      pch.dt_pedido_compra 'dt_hora_historico',
      pch.cd_departamento,
      pch.nm_pedido_compra_histor_1,
      CAST(IsNull(pch.nm_pedido_compra_histor_2,' ') +
      '   '+ 
      IsNull(pch.nm_pedido_compra_histor_3,' ') as text) as 'nm_historico',
      d.sg_departamento,
      d.nm_departamento,
      u.nm_fantasia_usuario as 'nm_usuario_historico'
    from 
      Pedido_Compra_Historico pch --Força o pedido ter um Histórico definido (foi mudado de left para inner para tornar o processo de consulta mais rápido: FCM)
    inner join Pedido_Compra ped 
      on pch.cd_pedido_compra = ped.cd_pedido_compra
    inner join Status_Pedido sp	--Força o pedido ter um status definido (foi mudado de left para inner para tornar o processo de consulta mais rápido: FCM)
      on ped.cd_status_pedido = sp.cd_status_pedido
    inner join Fornecedor f --Força o pedido ter um Fornecedor definido (foi mudado de left para inner para tornar o processo de consulta mais rápido: FCM)
      on ped.cd_fornecedor = f.cd_fornecedor
    Left Outer Join Condicao_Pagamento cop
      on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento
    Left Outer Join Transportadora t 		
      on ped.cd_transportadora = t.cd_transportadora
    Left Outer Join Departamento d 		
      on d.cd_departamento = pch.cd_departamento
    Inner Join EGISAdmin.dbo.Usuario u	--Força o pedido ter um Usuário do Histórico definido (foi mudado de left para inner para tornar o processo de consulta mais rápido: FCM)
      on u.cd_usuario = pch.cd_usuario
    WHERE     
      ped.cd_pedido_compra = @cd_pedido_compra

    ORDER BY
      pch.dt_pedido_compra desc,
      ped.cd_pedido_compra


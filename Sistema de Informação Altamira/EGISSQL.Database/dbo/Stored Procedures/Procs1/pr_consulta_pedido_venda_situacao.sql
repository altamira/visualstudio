--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- 
CREATE PROCEDURE pr_consulta_pedido_venda_situacao
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Realizar uma consulta de Situação do Pedido_Venda
--Data: 14/03/2002
--Atualizado: 15/03/2002 - Igor Gama
--            15.03.2003 - Fabio Cesar
--            13.01.2006 - Realiza a filtragem pelo vendedor para os casos de acesso por um usuário remoto/internet (representante) - Fabio Cesar
-- 27.09.2008 - Ajuste do Usuário - Carlos Fernandes
------------------------------------------------------------------------------------------------------
@ic_parametro    int = 0,
@cd_pedido_venda int = 0,
@cd_usuario      int = 0
AS


	declare @cd_vendedor int

	--Define o vendedor para o cliente
	Select
		@cd_vendedor = dbo.fn_vendedor_internet(@cd_usuario)

--------------------------------------------------------------------------------------------
--  ic_parametro = 1 - Realiza a Consulta do Pedido
--------------------------------------------------------------------------------------------  

  If @ic_parametro = 1
  Begin

    SELECT     
      ped.cd_pedido_venda,
      ped.dt_pedido_venda,
      ped.cd_vendedor_pedido,
      (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor) as 'nm_vendedor_externo',
      ped.cd_vendedor_interno,
      (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor_interno) as 'nm_vendedor_interno',
      ped.dt_cancelamento_pedido,
      ped.ds_cancelamento_pedido,
      IsNull(ped.ic_fatsmo_pedido,'N') as 'ic_fatsmo_pedido',
      CAST(ped.vl_total_pedido_venda as numeric(25,2)) as 'vl_total_pedido_venda', 
      ped.qt_liquido_pedido_venda, 
      ped.qt_bruto_pedido_venda, 
      ped.nm_alteracao_pedido_venda,
      Convert(char(10),ped.dt_alteracao_pedido_venda, 103) as 'dt_ult_alteracao',
      cli.cd_cliente, 
      cli.nm_fantasia_cliente, 
      cli.nm_razao_social_cliente,
      ped.cd_tipo_restricao_pedido, 
      ped.cd_tipo_pedido, 
      (Select top 1 nm_tipo_pedido From Tipo_pedido Where cd_tipo_pedido = ped.cd_tipo_pedido) as 'nm_tipo_pedido',
      ped.cd_vendedor, 
      ped.cd_contato, 
      (Select top 1 nm_fantasia_contato From Cliente_Contato Where cd_contato = ped.cd_contato and cd_cliente = ped.cd_cliente) as 'nm_fantasia_contato',
      cop.nm_condicao_pagamento,
      cop.sg_condicao_pagamento,
      cop.qt_parcela_condicao_pgto,
      Convert(char(10), pvh.dt_pedido_venda_historico, 103) as 'dt_pedido_historico',
      Convert(char(08), pvh.dt_pedido_venda_historico, 108) as 'hr_pedido_historico',
      pvh.cd_departamento,
      pvh.nm_pedido_venda_histor_1,
      CAST(IsNull(pvh.nm_pedido_venda_histor_2,' ') +
      '   '+ 
      IsNull(pvh.nm_pedido_venda_histor_3,' ') + 
      '   '+ 
      IsNull(pvh.nm_pedido_venda_histor_4,' ') as text) as 'nm_historico',
      (Select top 1 sg_departamento From Departamento where cd_departamento = isnull(pvh.cd_departamento,d.cd_departamento)) as 'sg_departamento',
      (Select top 1 nm_departamento From Departamento where cd_departamento = isnull(pvh.cd_departamento,d.cd_departamento)) as 'nm_departamento',
      u.nm_fantasia_usuario as 'nm_usuario_historico',
      stpv.nm_status_pedido

    FROM
      Pedido_venda ped                      with (nolock)
      Inner Join Pedido_Venda_Historico pvh with (nolock) on pvh.cd_pedido_venda = ped.cd_pedido_venda
      Left outer Join Cliente cli             on ped.cd_cliente = cli.cd_cliente 
      Left Outer Join Condicao_Pagamento cop  on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento
      left outer join Status_Pedido stpv      on stpv.cd_status_pedido=ped.cd_status_pedido
      left outer join egisadmin.dbo.usuario u on u.cd_usuario      = pvh.cd_usuario
      left outer join departamento d          on d.cd_departamento = u.cd_departamento
    WHERE     
      ped.cd_pedido_venda = @cd_pedido_venda
      --13.01.2006 Realiza a filtragem pelo vendedor para os casos de acesso por um usuário remoto/internet (representante) - Fabio Cesar
      and IsNull(ped.cd_vendedor,0) = ( case @cd_vendedor
                                          when 0 then IsNull(ped.cd_vendedor,0)
                                          else @cd_vendedor
                                        end )

    ORDER BY
      pvh.dt_pedido_venda_historico desc


  End Else

  --Relatório
  If @ic_parametro = 2
  Begin


    SELECT     
      ped.cd_pedido_venda,
      ped.dt_pedido_venda,
      ped.cd_vendedor_pedido,
      (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor) as 'nm_vendedor_externo',
      ped.cd_vendedor_interno,
      (Select top 1 nm_vendedor From Vendedor Where cd_vendedor = ped.cd_vendedor_interno) as 'nm_vendedor_interno',
      ped.dt_cancelamento_pedido,
      ped.ds_cancelamento_pedido,
      IsNull(ped.ic_fatsmo_pedido,'N') as 'ic_fatsmo_pedido',
      CAST(ped.vl_total_pedido_venda as numeric(25,2)) as 'vl_total_pedido_venda', 
      ped.qt_liquido_pedido_venda, 
      ped.qt_bruto_pedido_venda, 
      ped.nm_alteracao_pedido_venda,
      Convert(char(10),ped.dt_alteracao_pedido_venda, 103) as 'dt_ult_alteracao',
      cli.cd_cliente, 
      cli.nm_fantasia_cliente, 
      cli.nm_razao_social_cliente,
      ped.cd_tipo_restricao_pedido, 
      ped.cd_tipo_pedido, 
      (Select top 1 nm_tipo_pedido From Tipo_pedido Where cd_tipo_pedido = ped.cd_tipo_pedido) as 'nm_tipo_pedido',
      ped.cd_vendedor, 
      ped.cd_contato, 
      (Select top 1 nm_fantasia_contato From Cliente_Contato Where cd_contato = ped.cd_contato and cd_cliente = ped.cd_cliente) as 'nm_fantasia_contato',
      cop.nm_condicao_pagamento,
      cop.sg_condicao_pagamento,
      cop.qt_parcela_condicao_pgto,
      Convert(char(10), pvh.dt_pedido_venda_historico, 103) as 'dt_pedido_historico',
      Convert(char(08), pvh.dt_pedido_venda_historico, 108) as 'hr_pedido_historico',
      pvh.cd_departamento,
      pvh.nm_pedido_venda_histor_1,
      CAST(IsNull(pvh.nm_pedido_venda_histor_1,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_2,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_3,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_4,' ') as text) as 'nm_historico',
      (Select top 1 sg_departamento From Departamento where cd_departamento = isnull(pvh.cd_departamento,d.cd_departamento)) as 'sg_departamento',
      (Select top 1 nm_departamento From Departamento where cd_departamento = isnull(pvh.cd_departamento,d.cd_departamento)) as 'nm_departamento',
      u.nm_fantasia_usuario as 'nm_usuario_historico'

    FROM
      Pedido_venda ped with (nolock) 
      Inner Join Pedido_Venda_Historico pvh with (nolock) 
        on pvh.cd_pedido_venda = ped.cd_pedido_venda Left outer Join 
      Cliente cli 
        on ped.cd_cliente = cli.cd_cliente Left Outer Join
      Condicao_Pagamento cop on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento
      left outer join egisadmin.dbo.usuario u on u.cd_usuario = pvh.cd_usuario
      left outer join departamento d          on d.cd_departamento = u.cd_departamento

    WHERE     
      ped.cd_pedido_venda = @cd_pedido_venda
      --13.01.2006 Realiza a filtragem pelo vendedor para os casos de acesso por um usuário remoto/internet (representante) - Fabio Cesar
      and IsNull(ped.cd_vendedor,0) = ( case @cd_vendedor
                                          when 0 then IsNull(ped.cd_vendedor,0)
                                          else @cd_vendedor
                                        end )

    ORDER BY
      pvh.dt_pedido_venda_historico desc


  End


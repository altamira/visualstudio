


CREATE  PROCEDURE pr_repnet_situacao_pedido
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Realizar uma consulta de Situação do Pedido_Venda
--Data: 14/03/2002
--Atualizado: 15/03/2002 - Igor Gama
---------------------------------------------------
@ic_tipo_usuario as varchar(10),
@cd_tipo_usuario as int,
@ic_parametro as int,
@cd_pedido_venda as int
AS
if @ic_tipo_usuario='Vendedor'
begin
    SELECT     
      ped.cd_pedido_venda as 'Pedido',
      cli.nm_fantasia_cliente as 'Cliente', 
      Convert(char(10), pvh.dt_pedido_venda_historico, 103) as 'Datahistorico',
      Convert(char(08), pvh.dt_pedido_venda_historico, 108) as 'horahistorico',
      CAST(IsNull(pvh.nm_pedido_venda_histor_1,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_2,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_3,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_4,' ') as text) as 'historico'
    FROM
      Pedido_venda ped Inner Join
      Pedido_Venda_Historico pvh 
        on pvh.cd_pedido_venda = ped.cd_pedido_venda Left outer Join 
      Cliente cli 
        on ped.cd_cliente = cli.cd_cliente Left Outer Join
      Condicao_Pagamento cop 
        on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento
    WHERE     
      ped.cd_pedido_venda = @cd_pedido_venda and
      ped.cd_vendedor=@cd_tipo_usuario
    ORDER BY
      Datahistorico,
      Horahistorico
end

if @ic_tipo_usuario='Cliente'
begin
    SELECT     
      ped.cd_pedido_venda as 'Pedido',
      cli.nm_fantasia_cliente as 'Cliente', 
      Convert(char(10), pvh.dt_pedido_venda_historico, 103) as 'Datahistorico',
      Convert(char(08), pvh.dt_pedido_venda_historico, 108) as 'horahistorico',
      CAST(IsNull(pvh.nm_pedido_venda_histor_1,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_2,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_3,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_4,' ') as text) as 'historico'
    FROM
      Pedido_venda ped Inner Join
      Pedido_Venda_Historico pvh 
        on pvh.cd_pedido_venda = ped.cd_pedido_venda Left outer Join 
      Cliente cli 
        on ped.cd_cliente = cli.cd_cliente Left Outer Join
      Condicao_Pagamento cop 
        on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento
    WHERE     
      ped.cd_pedido_venda = @cd_pedido_venda and
      ped.cd_cliente=@cd_tipo_usuario
    ORDER BY
      Datahistorico,
      Horahistorico
end

if @ic_tipo_usuario='Supervisor'
begin
    SELECT     
      ped.cd_pedido_venda as 'Pedido',
      cli.nm_fantasia_cliente as 'Cliente', 
      Convert(char(10), pvh.dt_pedido_venda_historico, 103) as 'Datahistorico',
      Convert(char(08), pvh.dt_pedido_venda_historico, 108) as 'horahistorico',
      CAST(IsNull(pvh.nm_pedido_venda_histor_1,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_2,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_3,' ') + ' - '+
      IsNull(pvh.nm_pedido_venda_histor_4,' ') as text) as 'historico'
    FROM
      Pedido_venda ped Inner Join
      Pedido_Venda_Historico pvh 
        on pvh.cd_pedido_venda = ped.cd_pedido_venda Left outer Join 
      Cliente cli 
        on ped.cd_cliente = cli.cd_cliente Left Outer Join
      Condicao_Pagamento cop 
        on ped.cd_condicao_pagamento = cop.cd_condicao_pagamento
    WHERE     
      ped.cd_pedido_venda = @cd_pedido_venda 
    ORDER BY
      Datahistorico,
      Horahistorico
end




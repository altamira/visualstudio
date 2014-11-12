

CREATE PROCEDURE pr_libera_restricao_pedido
-------------------------------------------------------------------------------
--pr_libera_restricao_pedido
-------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                    	           2004
-------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Daniel Duela
--Banco de Dados	: EGISSQL
--Objetivo		: Listar Pedidos para liberação de alguma restrição.
--Data			: 25/09/2003
--Alteração		: 14/12/2004
--Desc. Alteração	: Acerto do Cabeçalho - Sérgio Cardoso
--                      : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
-------------------------------------------------------------------------------
@ic_parametro as int, --1 liberados, 2 não liberados
@cd_pedido_venda as int,
@dt_inicial as DateTime,
@dt_final   as DateTime

AS

--------------------------------------------------------------------------------------------
  If @ic_parametro = 1 -- Somente os Liberados
--------------------------------------------------------------------------------------------  

begin

  select
    0 as ic_restricao, 
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pv.cd_pedido_venda,
    pv.dt_pedido_venda,
    pv.vl_total_pedido_venda,
    pv.cd_usuario,
    pv.dt_usuario, 
    pv.dt_lib_restricao_pedido,
    pv.cd_usu_restricao_pedido,
    pv.nm_obs_restricao_pedido,
    mr.sg_tipo_restricao,
    pv.cd_tipo_restricao_pedido,
    u.nm_fantasia_usuario

  from
    Pedido_Venda pv left outer join
    Cliente cli  on pv.cd_cliente = cli.cd_cliente left outer join
    Vendedor vi  on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve  on pv.cd_vendedor = ve.cd_vendedor left outer join
    Tipo_Restricao_Pedido mr on mr.cd_tipo_restricao_pedido = pv.cd_tipo_restricao_pedido Left outer join
    EgisAdmin.dbo.Usuario u on pv.cd_usu_restricao_pedido = u.cd_usuario

  where
    (( @cd_pedido_venda = 0 and 
      pv.dt_pedido_venda between @dt_inicial and @dt_final ) or
    (pv.cd_pedido_venda = @cd_pedido_venda)) and
    pv.dt_cancelamento_pedido is null and
    IsNull(pv.cd_tipo_restricao_pedido,0) = 0
    
    
  order by 
    pv.dt_lib_restricao_pedido,
    pv.dt_pedido_venda,
    pv.cd_pedido_venda

end
------------------------------------------
else  -- Pedidos Aguardando Liberação.
If @ic_parametro = 2 
------------------------------------------
begin

  select
    0 as ic_restricao, 
    pv.cd_vendedor,
    ve.nm_fantasia_vendedor as 'nm_vendedor_externo',
    pv.cd_vendedor_interno,
    vi.nm_fantasia_vendedor as 'nm_vendedor_interno',
    cli.nm_fantasia_cliente,
    pv.cd_pedido_venda,
    pv.dt_pedido_venda,
    pv.vl_total_pedido_venda,
    pv.cd_usuario,
    pv.dt_usuario,
    pv.dt_lib_restricao_pedido,
    pv.cd_usu_restricao_pedido,
    pv.nm_obs_restricao_pedido,
    mr.sg_tipo_restricao,
    pv.cd_tipo_restricao_pedido,
    u.nm_fantasia_usuario


  from
    Pedido_Venda pv left outer join
    Cliente cli  on pv.cd_cliente = cli.cd_cliente Left outer join
    Vendedor vi  on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve  on pv.cd_vendedor = ve.cd_vendedor left outer join
    Tipo_Restricao_Pedido mr on mr.cd_tipo_restricao_pedido = pv.cd_tipo_restricao_pedido Left outer join
    EgisAdmin.dbo.Usuario u on pv.cd_usu_restricao_pedido = u.cd_usuario
  where
    (( @cd_pedido_venda = 0 and 
      pv.dt_pedido_venda between @dt_inicial and @dt_final ) or
    (pv.cd_pedido_venda = @cd_pedido_venda)) and
    pv.dt_cancelamento_pedido is null and
    IsNull(pv.cd_tipo_restricao_pedido,0) <> 0 
    
  order by 
    pv.dt_pedido_venda,
    pv.cd_pedido_venda


end
-------------------------------------------------------------------------------
--Testando a Stored Procedure
-------------------------------------------------------------------------------
--exec pr_libera_restricao_pedido

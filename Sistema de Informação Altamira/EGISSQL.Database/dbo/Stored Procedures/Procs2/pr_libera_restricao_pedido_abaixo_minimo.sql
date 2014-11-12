
CREATE PROCEDURE pr_libera_restricao_pedido_abaixo_minimo
---------------------------------------------------------
--GBS - Global Business Solution	             2002
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel Duela
--Banco de Dados	: EGISSQL
--Objetivo		: Listar Pedidos que estejam com valor de Faturamento abaixo do mínimo.
--Data			: 25/09/2003
--Alteração		: 
--Desc. Alteração	: 
---------------------------------------------------

@ic_parametro as int, --1 liberados, 2 não liberados
@cd_pedido_venda as int,
@dt_inicial as DateTime,
@dt_final   as DateTime
AS

declare @vl_min_faturamento float

select @vl_min_faturamento = isnull(vl_fat_minimo_empresa,0)
from Parametro_Faturamento
where
  cd_empresa=dbo.fn_empresa() and
  ic_fat_minimo_empresa='S'


--------------------------------------------------------------------------------------------
if @ic_parametro = 1 -- Somente os Liberados
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
    pv.dt_lib_fat_min_pedido,
    pv.cd_usu_lib_fat_min_pedido,
    pv.nm_obs_restricao_pedido,
    mr.sg_tipo_restricao,
    pv.cd_tipo_restricao_pedido
  from
    Pedido_Venda pv left outer join
    Cliente cli  on pv.cd_cliente = cli.cd_cliente left outer join
    Vendedor vi  on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve  on pv.cd_vendedor = ve.cd_vendedor left outer join
    Tipo_Restricao_Pedido mr on mr.cd_tipo_restricao_pedido = pv.cd_tipo_restricao_pedido
  where
    (( @cd_pedido_venda = 0 and pv.dt_pedido_venda between @dt_inicial and @dt_final ) or
     (pv.cd_pedido_venda = @cd_pedido_venda)) and 
      pv.dt_cancelamento_pedido is null and
      pv.dt_lib_fat_min_pedido is not null
  order by 
    pv.dt_lib_restricao_pedido,
    pv.dt_pedido_venda,
    pv.cd_pedido_venda
end

------------------------------------------
else if @ic_parametro = 2 -- Pedidos Aguardando Liberação.
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
    pv.dt_lib_fat_min_pedido,
    pv.cd_usu_lib_fat_min_pedido,
    pv.nm_obs_restricao_pedido,
    mr.sg_tipo_restricao,
    pv.cd_tipo_restricao_pedido
  from
    Pedido_Venda pv left outer join
    Cliente cli  on pv.cd_cliente = cli.cd_cliente Left outer join
    Vendedor vi  on pv.cd_vendedor_interno = vi.cd_vendedor Left Outer Join
    Vendedor ve  on pv.cd_vendedor = ve.cd_vendedor left outer join
    Tipo_Restricao_Pedido mr on mr.cd_tipo_restricao_pedido = pv.cd_tipo_restricao_pedido
  where
    (( @cd_pedido_venda = 0 and pv.dt_pedido_venda between @dt_inicial and @dt_final ) or
     (pv.cd_pedido_venda = @cd_pedido_venda)) and 
      pv.dt_cancelamento_pedido is null and
      pv.dt_lib_fat_min_pedido is null and     
      pv.vl_total_pedido_venda<@vl_min_faturamento     
  order by 
    pv.dt_pedido_venda,
    pv.cd_pedido_venda
end



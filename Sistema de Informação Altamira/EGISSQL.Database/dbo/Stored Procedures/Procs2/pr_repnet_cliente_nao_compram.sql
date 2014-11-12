

CREATE  procedure pr_repnet_cliente_nao_compram
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta de Clientes que não compram por Período
--Data          : 07.04.2002
--Atualizado    : 
---------------------------------------------------------------------------------------

@ic_tipo_usuario  char(10),
@cd_tipo_usuario  int,
@qt_mes           int,  
@ic_parametro     int,
@vl_volume_compra float
as

declare @dt_processamento int

set @dt_processamento = @qt_mes * 30 

select 
  cast('' as varchar(15))        as 'Cliente', 
  cast('' as varchar(4))      	 as 'ddd',
  cast('' as varchar(15))        as 'fone',
  cast(null as datetime)         as 'UltimaCompra',
  cast(0 as decimal(18,2))       as 'Volume', 
  cast('' as varchar(40))        as 'Contato'
into
	#Cliente_N_Compra


if @ic_tipo_usuario = 'Vendedor'
begin
if @vl_volume_compra > 0
begin

Insert into 
  #Cliente_N_Compra  
select 
  cli.nm_fantasia_cliente        as 'Cliente', 
  cli.cd_ddd      as 'ddd',
  cli.cd_telefone as 'fone',
  max(ped.dt_pedido_venda)       as 'UltimaCompra',
  sum(ped.vl_total_pedido_venda) as 'Volume', 
  max(con.nm_contato_cliente )   as 'Contato'
from
  Cliente cli,Pedido_Venda ped,Cliente_Contato con
Where
  cli.cd_vendedor=@cd_tipo_usuario   and
  cli.cd_cliente =ped.cd_cliente and
  ped.cd_vendedor=@cd_tipo_usuario   and
  cli.cd_cliente =con.cd_cliente and
  con.cd_contato =ped.cd_contato and
  ped.vl_total_pedido_venda > 0  and
  ped.dt_cancelamento_pedido is  null 
Group by
  cli.nm_fantasia_cliente,
  cli.cd_ddd,
  cli.cd_telefone
having datediff(day,max(ped.dt_pedido_venda),getdate()) >  @dt_processamento and
       sum(ped.vl_total_pedido_venda) < @vl_volume_compra
-- order by 
--   cli.nm_fantasia_cliente
end

if @vl_volume_compra <= 0
begin
Insert into 
  #Cliente_N_Compra  
select 
  cli.nm_fantasia_cliente        as 'Cliente', 
  cli.cd_ddd      as 'ddd',
  cli.cd_telefone as 'fone',
  max(ped.dt_pedido_venda)       as 'UltimaCompra',
  sum(ped.vl_total_pedido_venda) as 'Volume', 
  max(con.nm_contato_cliente )   as 'Contato'
from
  Cliente cli,Pedido_Venda ped,Cliente_Contato con
Where
  cli.cd_vendedor=@cd_tipo_usuario   and
  cli.cd_cliente =ped.cd_cliente and
  ped.cd_vendedor=@cd_tipo_usuario   and
  cli.cd_cliente =con.cd_cliente and
  con.cd_contato =ped.cd_contato and
  ped.vl_total_pedido_venda > 0  and
  ped.dt_cancelamento_pedido is  null 
Group by
  cli.nm_fantasia_cliente,
  cli.cd_ddd,
  cli.cd_telefone
having datediff(day,max(ped.dt_pedido_venda),getdate()) >  @dt_processamento
-- order by 
--   cli.nm_fantasia_cliente
end
end

if @ic_tipo_usuario = 'Cliente'
begin
if @vl_volume_compra > 0
begin
Insert into 
  #Cliente_N_Compra  
select 
  cli.nm_fantasia_cliente        as 'Cliente', 
  cli.cd_ddd      as 'ddd',
  cli.cd_telefone as 'fone',
  max(ped.dt_pedido_venda)       as 'UltimaCompra',
  sum(ped.vl_total_pedido_venda) as 'Volume', 
  max(con.nm_contato_cliente )   as 'Contato'
from
  Cliente cli,Pedido_Venda ped,Cliente_Contato con
Where
  cli.cd_cliente=@cd_tipo_usuario   and
  cli.cd_cliente =ped.cd_cliente and
  ped.cd_cliente=@cd_tipo_usuario   and
  cli.cd_cliente =con.cd_cliente and
  con.cd_contato =ped.cd_contato and
  ped.vl_total_pedido_venda > 0  and
  ped.dt_cancelamento_pedido is  null 
Group by
  cli.nm_fantasia_cliente,
  cli.cd_ddd,
  cli.cd_telefone
having datediff(day,max(ped.dt_pedido_venda),getdate()) >  @dt_processamento and
       sum(ped.vl_total_pedido_venda) < @vl_volume_compra
-- order by 
--   cli.nm_fantasia_cliente
end

if @vl_volume_compra <= 0
begin
Insert into 
  #Cliente_N_Compra  
select 
  cli.nm_fantasia_cliente        as 'Cliente', 
  cli.cd_ddd      as 'ddd',
  cli.cd_telefone as 'fone',
  max(ped.dt_pedido_venda)       as 'UltimaCompra',
  sum(ped.vl_total_pedido_venda) as 'Volume', 
  max(con.nm_contato_cliente )   as 'Contato'
from
  Cliente cli,Pedido_Venda ped,Cliente_Contato con
Where
  cli.cd_cliente=@cd_tipo_usuario   and
  cli.cd_cliente =ped.cd_cliente and
  ped.cd_cliente=@cd_tipo_usuario   and
  cli.cd_cliente =con.cd_cliente and
  con.cd_contato =ped.cd_contato and
  ped.vl_total_pedido_venda > 0  and
  ped.dt_cancelamento_pedido is  null 
Group by
  cli.nm_fantasia_cliente,
  cli.cd_ddd,
  cli.cd_telefone
having datediff(day,max(ped.dt_pedido_venda),getdate()) >  @dt_processamento
-- order by 
--   cli.nm_fantasia_cliente
end
end

if @ic_tipo_usuario = 'Supervisor'
begin
if @vl_volume_compra > 0
begin
Insert into 
  #Cliente_N_Compra  
select 
  cli.nm_fantasia_cliente        as 'Cliente', 
  cli.cd_ddd      as 'ddd',
  cli.cd_telefone as 'fone',
  max(ped.dt_pedido_venda)       as 'UltimaCompra',
  sum(ped.vl_total_pedido_venda) as 'Volume', 
  max(con.nm_contato_cliente )   as 'Contato'
from
  Cliente cli,Pedido_Venda ped,Cliente_Contato con
Where
  cli.cd_cliente =ped.cd_cliente and
  cli.cd_cliente =con.cd_cliente and
  con.cd_contato =ped.cd_contato and
  ped.vl_total_pedido_venda > 0  and
  ped.dt_cancelamento_pedido is  null 
Group by
  cli.nm_fantasia_cliente,
  cli.cd_ddd,
  cli.cd_telefone
having datediff(day,max(ped.dt_pedido_venda),getdate()) >  @dt_processamento and
       sum(ped.vl_total_pedido_venda) < @vl_volume_compra
-- order by 
--   cli.nm_fantasia_cliente
end

if @vl_volume_compra <= 0
begin
Insert into 
  #Cliente_N_Compra  
select 
  cli.nm_fantasia_cliente        as 'Cliente', 
  cli.cd_ddd      as 'ddd',
  cli.cd_telefone as 'fone',
  max(ped.dt_pedido_venda)       as 'UltimaCompra',
  sum(ped.vl_total_pedido_venda) as 'Volume', 
  max(con.nm_contato_cliente )   as 'Contato'
from
  Cliente cli,Pedido_Venda ped,Cliente_Contato con
Where
  cli.cd_cliente =ped.cd_cliente and
  cli.cd_cliente =con.cd_cliente and
  con.cd_contato =ped.cd_contato and
  ped.vl_total_pedido_venda > 0  and
  ped.dt_cancelamento_pedido is  null 
Group by
  cli.nm_fantasia_cliente,
  cli.cd_ddd,
  cli.cd_telefone
having datediff(day,max(ped.dt_pedido_venda),getdate()) >  @dt_processamento
-- order by 
--   cli.nm_fantasia_cliente
end
end

delete from #Cliente_N_Compra where len(Cliente) = 0

--Realiza a ordenação do campo de acordo com o parametro
if (@ic_parametro = 0)
	select * from
		#Cliente_N_Compra
	order by Volume
else if (@ic_parametro = 1)
	select * from
		#Cliente_N_Compra
	order by Cliente
else
	select * from
		#Cliente_N_Compra
	order by UltimaCompra




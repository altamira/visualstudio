






--pr_repnet_consulta_cliente_novos
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta de Clientes Novos por Vendedor
--Data          : 07.04.2002
--Atualizado    : 
----------------- ---------------------------------------------------------------------
CREATE    procedure pr_repnet_consulta_cliente_novos
@dt_inicial  as datetime,
@dt_final   as  datetime,
@ic_tipo_usuario as char(10),
@cd_tipo_usuario as int
as

if @ic_tipo_usuario = 'Vendedor'
begin
select 
   cli.cd_cliente          as 'Codigo',
   cli.dt_cadastro_cliente as 'Cadastro',
   cli.nm_fantasia_cliente as 'Cliente',
   est.sg_estado           as 'UF',
   cid.nm_cidade           as 'Cidade',
   cli.cd_ddd              as 'DDD',
   cli.cd_telefone         as 'Fone',
   cli.nm_razao_social_cliente as 'Razao'
  from
     Cliente cli,Cidade cid,Estado est
  where
     cli.cd_vendedor = @cd_tipo_usuario      and
     cli.dt_cadastro_cliente between @dt_inicial and @dt_final and
     cli.cd_cidade   = cid.cd_cidade     and
     cli.cd_estado   = est.cd_estado     
  order by 
     cli.dt_cadastro_cliente desc,
     cli.nm_fantasia_cliente
end

if @ic_tipo_usuario = 'Cliente'
begin
select 
   cli.cd_cliente          as 'Codigo',
   cli.dt_cadastro_cliente as 'Cadastro',
   cli.nm_fantasia_cliente as 'Cliente',
   est.sg_estado           as 'UF',
   cid.nm_cidade           as 'Cidade',
   cli.cd_ddd              as 'DDD',
   cli.cd_telefone         as 'Fone',
   cli.nm_razao_social_cliente as 'Razao'
  from
     Cliente cli,Cidade cid,Estado est
  where
     cli.cd_cliente = @cd_tipo_usuario      and
     cli.dt_cadastro_cliente between @dt_inicial and @dt_final and
     cli.cd_cidade   = cid.cd_cidade     and
     cli.cd_estado   = est.cd_estado     
  order by 
     cli.dt_cadastro_cliente desc,
     cli.nm_fantasia_cliente
end

if @ic_tipo_usuario = 'Supervisor'
begin
select 
   cli.cd_cliente          as 'Codigo',
   cli.dt_cadastro_cliente as 'Cadastro',
   cli.nm_fantasia_cliente as 'Cliente',
   est.sg_estado           as 'UF',
   cid.nm_cidade           as 'Cidade',
   cli.cd_ddd              as 'DDD',
   cli.cd_telefone         as 'Fone',
   cli.nm_razao_social_cliente as 'Razao'
  from
     Cliente cli,Cidade cid,Estado est
  where
     cli.dt_cadastro_cliente between @dt_inicial and @dt_final and
     cli.cd_cidade   = cid.cd_cidade     and
     cli.cd_estado   = est.cd_estado     
  order by 
     cli.dt_cadastro_cliente desc,
     cli.nm_fantasia_cliente
end
    








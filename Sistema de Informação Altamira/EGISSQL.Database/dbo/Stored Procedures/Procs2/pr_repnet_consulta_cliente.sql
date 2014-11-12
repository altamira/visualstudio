




--pr_repnet_consulta_cliente
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta de Clientes
--Data          : 07.04.2002
--Atualizado    : 
----------------- ---------------------------------------------------------------------
CREATE     procedure pr_repnet_consulta_cliente
@ic_parametro int,
@ic_tipo_usuario varchar(10),
@cd_tipo_usuario  int,
@nm_cliente   varchar(40)
as
declare @SQL varchar(8000)

--Nome Fantasia
if @ic_parametro = 1
begin
  set @SQL =       'Select '
  set @SQL = @SQL + 'cli.cd_cliente as Codigo, '
  set @SQL = @SQL + 'cli.nm_fantasia_cliente as Cliente, '
  set @SQL = @SQL + 'est.sg_estado as UF, '
  set @SQL = @SQL + 'cid.nm_cidade as Cidade, '
  set @SQL = @SQL + 'cli.cd_ddd as DDD, '
  set @SQL = @SQL + 'cli.cd_telefone as Fone, '
  set @SQL = @SQL + 'cli.nm_razao_social_cliente as Razao '
  set @SQL = @SQL + 'from '
  set @SQL = @SQL + 'Cliente cli,Cidade cid,Estado est '
  set @SQL = @SQL + 'where '
  if @ic_tipo_usuario='Vendedor'
     set @SQL = @SQL + 'cli.cd_vendedor = '+str(@cd_tipo_usuario)+' and '
  if @ic_tipo_usuario='Cliente'
     set @SQL = @SQL + 'cli.cd_cliente = '+str(@cd_tipo_usuario)+' and '

  set @SQL = @SQL + 'cli.cd_cidade = cid.cd_cidade and '
  set @SQL = @SQL + 'cli.cd_estado = est.cd_estado and '
  set @SQL = @SQL + 'cli.nm_fantasia_cliente like '''+@nm_cliente+'%'''
  set @SQL = @SQL + ' order by '
  set @SQL = @SQL + 'cli.nm_fantasia_cliente '
  exec (@SQL)
end

-- Razão Social

if @ic_parametro = 2
begin
  set @SQL =       'Select '
  set @SQL = @SQL + 'cli.cd_cliente              as Codigo, '
  set @SQL = @SQL + 'cli.nm_fantasia_cliente     as Cliente, '
  set @SQL = @SQL + 'est.sg_estado               as UF, '
  set @SQL = @SQL + 'cid.nm_cidade               as Cidade, '
  set @SQL = @SQL + 'cli.cd_ddd                  as DDD, '
  set @SQL = @SQL + 'cli.cd_telefone             as Fone, '
  set @SQL = @SQL + 'cli.nm_razao_social_cliente as Razao '
  set @SQL = @SQL + 'from '
  set @SQL = @SQL + 'Cliente cli,Cidade cid,Estado est '
  set @SQL = @SQL + 'where '
  if @ic_tipo_usuario='Vendedor'
     set @SQL = @SQL + 'cli.cd_vendedor = '+str(@cd_tipo_usuario)+' and '
  if @ic_tipo_usuario='Cliente'
     set @SQL = @SQL + 'cli.cd_cliente = '+str(@cd_tipo_usuario)+' and '

  set @SQL = @SQL + 'cli.cd_cidade   = cid.cd_cidade     and '
  set @SQL = @SQL + 'cli.cd_estado   = est.cd_estado     and '
  set @SQL = @SQL + 'cli.nm_razao_social_cliente like '''+@nm_cliente+'%'''
  set @SQL = @SQL + ' order by cli.nm_razao_social_cliente '
  exec (@SQL)
end






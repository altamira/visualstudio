
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_roteiro_entrada_pedido
-------------------------------------------------------------------------------
--pr_consulta_roteiro_entrada_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 23.09.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_consulta_roteiro_entrada_pedido
@dt_entrada        datetime = '',
@finalizados       int = 0,
@cd_vendedor       int = 0 
as

select 
  rep.cd_roteiro_entrada,
  rep.dt_roteiro_entrada,
  convert(char,dt_roteiro_entrada,103) as data,
  v.nm_fantasia_vendedor,
  rep.cd_vendedor,
  rep.dt_download_roteiro,
  case when not rep.dt_download_roteiro is null then
    substring(substring(rep.dt_download_roteiro,9,6),1,2) + ':' + 
    substring(substring(rep.dt_download_roteiro,9,6),3,2) + ':' +
    substring(substring(rep.dt_download_roteiro,9,6),5,2) 
  end as HoraDownload,
  rep.dt_fim_roteiro,
  case when not rep.dt_fim_roteiro is null then
    substring(substring(rep.dt_fim_roteiro,9,6),1,2) + ':' + 
    substring(substring(rep.dt_fim_roteiro,9,6),3,2) + ':' +
    substring(substring(rep.dt_fim_roteiro,9,6),5,2) 
  end as HoraFinalizacao,
  rep.nm_obs_roteiro,
  us.nm_usuario,
  us.nm_fantasia_usuario
into
  #roteiro
from
  roteiro_entrada_pedido                rep with(nolock)
  left outer join vendedor              v   with(nolock) on v.cd_vendedor = rep.cd_vendedor
  left outer join egisadmin.dbo.usuario us  with(nolock) on us.cd_usuario = rep.cd_usuario
where
  CONVERT(CHAR,rep.dt_roteiro_entrada,101 ) = CONVERT(CHAR,cast(@dt_entrada as datetime),101 )

--cast(CONVERT(CHAR,rep.dt_roteiro_entrada,101 ) as datetime ) = @dt_entrada
--  rep.dt_roteiro_entrada between  @dt_entrada and @dt_entrada


order by
  HoraDownload,
  nm_fantasia_vendedor

--select * from  #roteiro


if @finalizados = 0
  begin
    if @cd_vendedor = 0
      begin
        select * from #roteiro where dt_fim_roteiro is null order by nm_fantasia_vendedor, cd_vendedor
      end
    else
      select * from #roteiro where dt_fim_roteiro is null and cd_vendedor = @cd_vendedor order by nm_fantasia_vendedor, cd_vendedor
  end
else
  if @cd_vendedor = 0
    begin 
      select * from #roteiro where not dt_fim_roteiro is null order by nm_fantasia_vendedor, cd_vendedor
    end
  else
    select * from #roteiro where not dt_fim_roteiro is null and cd_vendedor = @cd_vendedor order by nm_fantasia_vendedor, cd_vendedor



-------------------------------------------------------------------------------
--pr_mudanca_status_os_engenharia
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin 
--Objetivo         : Modificação do status da OS - Engenharia - GBS
--Data             : 02.08.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_mudanca_status_os_engenharia
@nm_empresa     varchar(50) = '',
@ic_status_menu char(1)     = '',
@ic_status_novo char(1)     = '',
@ic_parametro   int         = 0,
@cd_ano         int         = 0
as


if @ic_parametro = 1 and @nm_empresa<>''
begin
  --Mostra as OS
  select
    *
  from
    menu_historico
  where
    nm_empresa     = case when @nm_empresa='' then nm_empresa else @nm_empresa end     and
    ic_status_menu = @ic_status_menu and
    dt_homologacao is null           and 
    dt_fim_desenvolvimento is null


  update
    menu_historico
  set
    ic_status_menu = @ic_status_novo
  where
    nm_empresa     = @nm_empresa     and
    ic_status_menu = @ic_status_menu and
    dt_homologacao is null           and 
    dt_fim_desenvolvimento is null

end

--select * from menu_historico where nm_empresa = 'SMC' AND dt_homologacao is null and dt_fim_desenvolvimento is null and ic_status_menu='N'
--select * from menu_historico where nm_os = '0-SVD-050506-1700'
--select * from menu_historico where nm_os = '0-SCE-261004-1800'

if @ic_parametro = 2 
begin

  --Mostra as OS

  select
    *
  from
    menu_historico
  where
    year(dt_usuario) = @cd_ano       and
    ic_status_menu = @ic_status_menu and
    dt_homologacao is null           and 
    dt_fim_desenvolvimento is null

  update
    menu_historico
  set
    ic_status_menu = @ic_status_novo
  where
    year(dt_usuario)       = @cd_ano         and
    ic_status_menu         = @ic_status_menu and
    dt_homologacao         is null   and 
    dt_fim_desenvolvimento is null

end



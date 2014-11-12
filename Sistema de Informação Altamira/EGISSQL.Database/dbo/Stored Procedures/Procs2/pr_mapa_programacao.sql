
CREATE PROCEDURE pr_mapa_programacao
-------------------------------------------------------------------------------------------------------------------------------------
--pr_mapa_programacao
-------------------------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                             2004
-------------------------------------------------------------------------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000
--Autor(es)            : Daniel Carrasco Neto
--Banco de Dados       : EgisSQL
--Objetivo             : Fazer um mapa programação de máquinas.
--Data                 : 12/12/2002
--Atualizado           : 30/04/2004 - Modificação para aparecer todas as máquinas com flag ic_mapa_producao = 'S' - Daniel C. Neto.
--                     : 17/05/2004 - Modificação referente ao campo 'qt_dia_prog_carga_maquina' - DANIEL DUELA
--                     : 03.06.2004 - Colocado um left outer join na query e tirar o parametro de data. Carlos/Igor
--                     : 09/06/2004 - Colocado cd_maquina - Daniel C. Neto,.
--                     : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--                       05/09/2006 - Mudado de Tipo_maquina para Maquina_Tipo - Daniel C. Neto.
--                       05.09.2007 - Grupo de Máquina - Carlos Fernandes
--                       21.09.2007 - Ordem Alfabética de Máquina, conforme parâmetro - Carlos Fernandes
-- 15.03.2010 - Ordem de Produção que estão Canceladas e Encerradas não pode entrar - Carlos Fernandes
-- 06.09.2010 - Descrição da Máquina - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------------------------

@ic_parametro  int,
@dt_inicial    datetime,
@dt_final      datetime

AS

declare @ic_alfa_maquina_programacao char(1) 

select
  @ic_alfa_maquina_programacao = isnull(ic_alfa_maquina_programacao,'N')
from
  parametro_programacao with (nolock) 
where
  cd_empresa = dbo.fn_empresa()

---------------------------------------------------------------
if @ic_parametro = 1 -- Mapa de programaçao no período
---------------------------------------------------------------
begin
  select
    m.cd_maquina,
    m.qt_ordem_mapa,
    m.nm_fantasia_maquina, 
    m.ic_prog_cnc,	  
    tm.nm_tipo_maquina, 
    cm.qt_carga_maquina, 
    cm.nm_obs_carga_maquina,
    cm.qt_disp_carga_maquina,
    cm.qt_atraso_carga_maquina, 
    cm.dt_atraso_carga_maquina, 
    cm.qt_dia_atraso_carga_maq,
    cm.dt_disp_carga_maquina, 
    cm.qt_dia_prog_carga_maquina,
    cm.dt_prog_carga_maquina as 'Dt_Prog',
    cm.qt_prog_carga_maquina as 'Prog',
    gm.nm_grupo_maquina,
    m.nm_maquina
  from
    Maquina m                        with (nolock)
    left outer join Carga_Maquina cm  with (nolock) on cm.cd_maquina = m.cd_maquina 
--         and cm.dt_disp_carga_maquina between @dt_inicial and @dt_final
    Left Outer join Maquina_Tipo tm   with (nolock) on m.cd_tipo_maquina = tm.cd_tipo_maquina
    left outer join Grupo_Maquina gm  with (nolock) on gm.cd_grupo_maquina = m.cd_grupo_maquina
  where
     isnull(m.ic_mapa_producao,'N') = 'S'
  order by
    case when @ic_alfa_maquina_programacao='S' then 0 else qt_ordem_mapa end,
    m.nm_fantasia_maquina

end


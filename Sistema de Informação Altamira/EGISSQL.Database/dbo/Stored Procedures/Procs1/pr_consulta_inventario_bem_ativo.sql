
-------------------------------------------------------------------------------
--pr_consulta_inventario_bem_ativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Bem do Ativo Fixo para inventário
--Data             : 04/11/2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_inventario_bem_ativo
  @cd_planta           int = 0,
  @cd_localizacao_bem  int = 0,
  @cd_departamento     int = 0,
  @cd_area_risco       int = 0,
  @cd_centro_custo     int = 0,
  @cd_seguradora       int = 0
as
Select
  b.cd_bem,
  isnull( b.nm_mascara_bem     , '' ) as nm_mascara_bem,
  isnull( b.cd_patrimonio_bem  , '' ) as cd_patrimonio_bem,
  isnull( b.nm_bem             , '' ) as nm_bem,
  isnull( b.nm_marca_bem       , '' ) as nm_marca_bem,
  isnull( b.nm_modelo_bem      , '' ) as nm_modelo_bem,
  isnull( b.nm_serie_bem       , '' ) as nm_serie_bem,
  isnull( gb.nm_grupo_bem      , '' ) as nm_grupo_bem, 
  isnull( sb.nm_status_bem     , '' ) as nm_status_bem,
  b.dt_aquisicao_bem,
  isnull( pl.nm_planta         , '' ) as nm_planta,
  isnull( lb.nm_localizacao_bem, '' ) as nm_localizacao_bem,
  isnull( d.sg_departamento    , '' ) as nm_departamento,
  isnull( cc.nm_centro_custo   , '' ) as nm_centro_custo,
  isnull( s.nm_seguradora      , '' ) as nm_seguradora,
  isnull( ar.nm_area_risco     , '' ) as nm_area_risco,
  isnull( b.qt_bem             , 0 )  as qt_bem
From
  Bem b
  Left Outer Join Grupo_Bem gb on gb.cd_grupo_bem = b.cd_grupo_bem
  Left Outer Join Status_Bem sb on sb.cd_status_bem = b.cd_status_bem
  Left Outer Join Planta pl on pl.cd_planta = b.cd_planta
  Left Outer Join Localizacao_Bem lb on lb.cd_localizacao_bem = b.cd_localizacao_bem
  Left Outer Join Departamento d on d.cd_departamento = b.cd_departamento
  Left Outer Join Centro_Custo cc on cc.cd_centro_custo = b.cd_centro_custo
  Left Outer Join Seguradora s on s.cd_seguradora = b.cd_seguradora
  Left Outer Join Area_Risco ar on ar.cd_area_risco = b.cd_area_risco
Where
  isnull( b.cd_planta, 0 ) = case @cd_planta when 0 then isnull( b.cd_planta, 0 ) else @cd_planta end and
  isnull( b.cd_localizacao_bem, 0 ) = case @cd_localizacao_bem when 0 then isnull( b.cd_localizacao_bem, 0 ) else @cd_localizacao_bem end and
  isnull( b.cd_area_risco, 0 ) = case @cd_area_risco when 0 then isnull( b.cd_area_risco, 0 ) else @cd_area_risco end and
  isnull( b.cd_departamento, 0 ) = case @cd_departamento when 0 then isnull( b.cd_departamento, 0 ) else @cd_departamento end and
  isnull( b.cd_centro_custo, 0 ) = case @cd_centro_custo when 0 then isnull( b.cd_centro_custo, 0 ) else @cd_centro_custo end and
  isnull( b.cd_seguradora, 0 ) = case @cd_seguradora when 0 then isnull( b.cd_seguradora, 0 ) else @cd_seguradora end and
  b.ic_inventario_bem = 'S'

Order by
  b.cd_planta,
  b.cd_localizacao_bem,
  b.cd_departamento,
  b.cd_area_risco,
  b.cd_centro_custo,
  b.cd_seguradora,
  b.cd_bem

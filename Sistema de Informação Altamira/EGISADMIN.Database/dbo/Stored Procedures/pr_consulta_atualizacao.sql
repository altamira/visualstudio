
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : ELIAS PEREIRA DA SILVA
--Banco de Dados: EGISADMIN 
--Objetivo      : Listagem das OS
--Data          : 03/09/2004
--Atualizado    : 09/09/2004 - Acerto para filtrar a empresa ou pela fantasia ou pela razão social - ELIAS
--           
----------------------------------------------------------------------
create procedure pr_consulta_atualizacao
@ic_parametro int,
@cd_empresa int,
@dt_inicial datetime,
@ic_pendencia char(1) = 'S',
@ic_empresa char(1) = 'S',
@ic_outra_empresa char(1) = 'S',
@cd_modulo int = null,
@cd_menu int = null

as

  set dateformat dmy

  declare @nm_empresa varchar(50)
  declare @nm_fantasia_empresa varchar(50)

	select @nm_empresa = nm_empresa,
         @nm_fantasia_empresa = nm_fantasia_empresa
	from egisadmin.dbo.empresa
	where cd_empresa = @cd_empresa

-------------------------------------------------------------------------------
if @ic_parametro = 1   -- Lista o Relatório Completo
-------------------------------------------------------------------------------
begin
	
	-- DESENVOLVIDOS NA EMPRESA
	select 
    'ACERTOS/IMPLEMENTAÇÕES' as 'Tipo',
    h.nm_empresa as 'Empresa',
	  'A' as 'Status',
	  m.sg_modulo as 'SiglaModulo',
	  m.nm_modulo as 'Modulo',
	  m.cd_versao_modulo as 'Versao',
	  m.dt_ult_versao_modulo as 'DataVersao',
	  h.nm_os as 'OS',
	  h.nm_atividade_processo as 'Processo',
	  h.dt_fim_desenvolvimento as 'DesenvEntrada',
	  h.ds_problema_os as 'Problema',
	  h.ds_menu_historico as 'Correcao',
	  h.nm_analista as 'Analista',
	  case when h.dt_homologacao is null then 'N' else 'S' end as 'Homologado',
	  h.dt_prevista_os as 'Previsao',
    isnull(h.cd_modulo,0) as cd_modulo,
    mhp.nm_procedure,
    h.cd_menu_historico

	from menu_historico h
	left outer join modulo m
	on h.cd_modulo = m.cd_modulo left outer join
  Menu_Historico_Procedure mhp on mhp.cd_menu_historico = h.cd_menu_historico
	where ((isnull(@cd_empresa,0) = 0) or (@cd_empresa <> 0) and (
    (h.nm_empresa = @nm_empresa or
    h.nm_empresa = @nm_fantasia_empresa))) and
	  cast(convert(varchar,dt_fim_desenvolvimento,103) as datetime) >=  cast(convert(varchar,@dt_inicial,103) as datetime) and 
    @ic_empresa = 'S' and
    isnull(h.cd_modulo,0) = case when (isnull(@cd_modulo,0)<>0) 
                              then @cd_modulo 
                              else isnull(h.cd_modulo,0) end and
    isnull(h.cd_menu,0) = case when (isnull(@cd_menu,0)<>0)
                            then @cd_menu
                            else isnull(h.cd_menu,0) end
	union all
	-- DESENVOLVIDOS DE OUTRAS EMPRESAS
	select 
    'OUTROS ACERTOS' as 'Tipo',
    h.nm_empresa as 'Empresa',
	  'B' as 'Status',
	  m.sg_modulo as 'SiglaModulo',
	  m.nm_modulo as 'Modulo',
	  m.cd_versao_modulo as 'Versao',
	  m.dt_ult_versao_modulo as 'DataVersao',
	  h.nm_os as 'OS',
	  h.nm_atividade_processo as 'Processo',
	  h.dt_fim_desenvolvimento as 'DesenvEntrada',
	  h.ds_problema_os as 'Problema',
	  h.ds_menu_historico as 'Correcao',
	  h.nm_analista as 'Analista',
	  case when h.dt_homologacao is null then 'N' else 'S' end as 'Homologado',
	  h.dt_prevista_os as 'Previsao',
    isnull(h.cd_modulo,0) as cd_modulo,
    mhp.nm_procedure,
    h.cd_menu_historico

	from menu_historico h
	left outer join modulo m
	on h.cd_modulo = m.cd_modulo left outer join
  Menu_Historico_Procedure mhp on mhp.cd_menu_historico = h.cd_menu_historico

	where not (h.nm_empresa = @nm_empresa or
    h.nm_empresa = @nm_fantasia_empresa) and
	  cast(convert(varchar,dt_fim_desenvolvimento,103) as datetime) >= 
	  cast(convert(varchar,@dt_inicial,103) as datetime) and 
    @ic_outra_empresa = 'S' and
    isnull(h.cd_modulo,0) = case when (isnull(@cd_modulo,0)<>0) 
                              then @cd_modulo 
                              else isnull(h.cd_modulo,0) end and
    isnull(h.cd_menu,0) = case when (isnull(@cd_menu,0)<>0)
                            then @cd_menu
                            else isnull(h.cd_menu,0) end
	union all
	-- PENDENCIAS  
	select 
    'PENDÊNCIAS' as 'Tipo',
    h.nm_empresa as 'Empresa',
	  'C' as 'Status',
	  m.sg_modulo as 'SiglaModulo',
	  m.nm_modulo as 'Modulo',
	  m.cd_versao_modulo as 'Versao',
	  m.dt_ult_versao_modulo as 'DataVersao',
	  h.nm_os as 'OS',
	  h.nm_atividade_processo as 'Processo',
	  h.dt_usuario as 'DesenvEntrada',
	  h.ds_problema_os as 'Problema',
	  h.ds_menu_historico as 'Correcao',
	  h.nm_analista as 'Analista',
	  case when h.dt_homologacao is null then 'N' else 'S' end as 'Homologado',
	  h.dt_prevista_os as 'Previsao',
    isnull(h.cd_modulo,0) as cd_modulo,
    mhp.nm_procedure,
    h.cd_menu_historico


	from menu_historico h
	left outer join modulo m
	on h.cd_modulo = m.cd_modulo left outer join
  Menu_Historico_Procedure mhp on mhp.cd_menu_historico = h.cd_menu_historico

	where ((isnull(@cd_empresa,0) = 0) or (@cd_empresa <> 0) and (
    (h.nm_empresa = @nm_empresa or
    h.nm_empresa = @nm_fantasia_empresa))) and
	  h.ic_status_menu = 'N' and 
    @ic_pendencia = 'S' and
    isnull(h.cd_modulo,0) = case when (isnull(@cd_modulo,0)<>0) 
                              then @cd_modulo 
                              else isnull(h.cd_modulo,0) end and
    isnull(h.cd_menu,0) = case when (isnull(@cd_menu,0)<>0)
                            then @cd_menu
                            else isnull(h.cd_menu,0) end
	order by Status, SiglaModulo, nm_procedure, h.cd_menu_historico 

end
-------------------------------------------------------------
else if @ic_parametro = 2  -- Lista somente Pendências
--------------------------------------------------------------
begin

	select 
    'PENDÊNCIAS' as 'Empresa',
	  'C' as 'Status',
	  m.sg_modulo as 'SiglaModulo',
	  m.nm_modulo as 'Modulo',
	  m.cd_versao_modulo as 'Versao',
	  m.dt_ult_versao_modulo as 'DataVersao',
	  h.nm_os as 'OS',
	  h.nm_atividade_processo as 'Processo',
	  h.dt_usuario as 'DesenvEntrada',
	  h.ds_problema_os as 'Problema',
	  h.ds_menu_historico as 'Correcao',
	  h.nm_analista as 'Analista',
	  case when h.dt_homologacao is null then 'N' else 'S' end as 'Homologado',
	  h.dt_prevista_os as 'Previsao',
    isnull(h.cd_modulo,0) as cd_modulo

	from menu_historico h
	left outer join modulo m
	on h.cd_modulo = m.cd_modulo
	where (h.nm_empresa = @nm_empresa or
    h.nm_empresa = @nm_fantasia_empresa) and
	  h.ic_status_menu = 'N'
	order by 3,14

end

------------------------------------------------------------------
else if @ic_parametro = 3 -- Lista somente as Procedures
------------------------------------------------------------------
begin

	-- DESENVOLVIDOS NA EMPRESA
	select 
	  mhp.nm_procedure
	from 
    menu_historico h left outer join 
    Menu_Historico_Procedure mhp on mhp.cd_menu_historico = h.cd_menu_historico
	where 
    ((isnull(@cd_empresa,0) = 0) or (@cd_empresa <> 0) and 
    ((h.nm_empresa = @nm_empresa or
    h.nm_empresa = @nm_fantasia_empresa))) and
	  convert(varchar,dt_fim_desenvolvimento,103) >= @dt_inicial and 
    @ic_empresa = 'S' and
    isnull(h.cd_modulo,0) = @cd_modulo and
    IsNull(mhp.nm_procedure,'') <> '' and
    isnull(h.cd_menu,0) = case when (isnull(@cd_menu,0)<>0)
                            then @cd_menu
                            else isnull(h.cd_menu,0) end

 	union all
	-- DESENVOLVIDOS DE OUTRAS EMPRESAS
	select 
    mhp.nm_procedure
	from 
    menu_historico h left outer join 
    Menu_Historico_Procedure mhp on mhp.cd_menu_historico = h.cd_menu_historico
	where not 
    (h.nm_empresa = @nm_empresa or
    h.nm_empresa = @nm_fantasia_empresa) and
	  convert(varchar,dt_fim_desenvolvimento,103) >= @dt_inicial and
    @ic_outra_empresa = 'S' and
    isnull(h.cd_modulo,0) = @cd_modulo and
    IsNull(mhp.nm_procedure,'') <> '' and
    isnull(h.cd_menu,0) = case when (isnull(@cd_menu,0)<>0)
                            then @cd_menu
                            else isnull(h.cd_menu,0) end

	order by 1

end




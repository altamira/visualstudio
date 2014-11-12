

CREATE PROCEDURE pr_rel_requisicao_interna
@ic_parametro          int, 
@cd_requisicao_interna int,
@dt_inicial            datetime,
@dt_final              datetime,
@cd_usuario            int,
@dt_usuario            datetime

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta de Requisição Interna (Todos)
-------------------------------------------------------------------------------
begin
  select 
    ri.cd_requisicao_interna,
    ri.dt_requisicao_interna,
    ri.dt_necessidade,
    ri.cd_departamento,
    dp.nm_departamento,
    ri.cd_centro_custo,
    cc.nm_centro_custo,
    ri.cd_aplicacao_produto,
    ap.nm_aplicacao_produto,
    ri.ds_requisicao_interna,
    ri.cd_usuario,
    ri.dt_usuario,
    ri.cd_usuario_requisicao ,
    u.nm_fantasia_usuario,
    ri.dt_estoque_req_interna
  from Requisicao_Interna ri
  left outer join Departamento dp on dp.cd_departamento=ri.cd_departamento
  left outer join Centro_Custo cc on cc.cd_centro_custo=ri.cd_centro_custo
  left outer join Aplicacao_Produto ap on ap.cd_aplicacao_produto=ri.cd_aplicacao_produto
  left outer join EgisAdmin.dbo.Usuario u on u.cd_usuario=ri.cd_usuario
  order by ap.nm_aplicacao_produto, dp.nm_departamento, ri.dt_requisicao_interna desc, ri.cd_requisicao_interna desc
end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta de Requisição Interna (Filtrada por Usuário)
-------------------------------------------------------------------------------
begin

  select 
    ri.cd_requisicao_interna,
    ri.dt_requisicao_interna,
    ri.dt_necessidade,
    ri.cd_departamento,
    dp.nm_departamento,
    ri.cd_centro_custo,
    cc.nm_centro_custo,
    ri.cd_aplicacao_produto,
    ap.nm_aplicacao_produto,
    ri.ds_requisicao_interna,
    ri.cd_usuario,
    ri.dt_usuario,
    ri.cd_usuario_requisicao,
    u.nm_fantasia_usuario,
    ri.dt_estoque_req_interna
  from Requisicao_Interna ri
  left outer join Departamento dp on dp.cd_departamento=ri.cd_departamento
  left outer join Centro_Custo cc on cc.cd_centro_custo=ri.cd_centro_custo
  left outer join Aplicacao_Produto ap on ap.cd_aplicacao_produto=ri.cd_aplicacao_produto  
  left outer join EgisAdmin.dbo.Usuario u on u.cd_usuario=ri.cd_usuario
  where ri.cd_usuario_requisicao=@cd_usuario
  order by ap.nm_aplicacao_produto, dp.nm_departamento, ri.dt_requisicao_interna desc, ri.cd_requisicao_interna desc
end


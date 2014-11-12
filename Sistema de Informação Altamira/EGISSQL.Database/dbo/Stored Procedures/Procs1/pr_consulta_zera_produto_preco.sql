﻿
CREATE PROCEDURE pr_consulta_zera_produto_preco
@ic_parametro          int

as

-------------------------------------------------------------------
if @ic_parametro = 1 --Consulta filtrada por Grupo de Produto
-------------------------------------------------------------------
begin
  select
    pp.cd_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    p.vl_produto,
    u.sg_unidade_medida,
    pp.dt_produto_preco,
    pp.vl_atual_produto_preco,
    pp.vl_temp_produto_preco,
    pp.qt_indice_produto_preco,
    pp.nm_obs_produto_preco,
    pp.cd_grupo_preco_produto,
    pp.cd_moeda,
    pp.cd_tipo_reajuste,
    pp.cd_motivo_reajuste,
    mr.nm_motivo_reajuste,
    pp.cd_tipo_tabela_preco,
    pp.cd_usuario,
    pp.dt_usuario,
    gpp.nm_grupo_preco_produto,
    gpp.sg_grupo_preco_produto
  from Produto_Preco pp
  left outer join Produto p
    on p.cd_produto=pp.cd_produto
  left outer join Motivo_Reajuste mr
    on mr.cd_motivo_reajuste=pp.cd_motivo_reajuste
  left outer join Unidade_Medida u
    on u.cd_unidade_medida=p.cd_unidade_medida
  left outer join Produto_Custo pc
    on p.cd_produto = pc.cd_produto 
  left outer join Grupo_Preco_Produto gpp
    on pc.cd_grupo_preco_produto = gpp.cd_grupo_preco_produto
end

-------------------------------------------------------------------
if @ic_parametro = 2 --Consulta filtrada por Série de Produto
-------------------------------------------------------------------
begin
  truncate table Produto_Preco
end



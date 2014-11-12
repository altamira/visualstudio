CREATE PROCEDURE pr_selecao_produto_lista_preco
-------------------------------------------------------------------------
--pr_selecao_produto_lista_preco
-------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                 	             2004
-------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Daniel Duela
--Banco de Dados	: EGISSQL
--Objetivo		: Consulta de Produtos para Lista de Preço
--Data			: 17/07/2002
--   		        : 14/08/2003 - Reestruturação da SP pra funcionamento correto - DUELA
--Atualização           : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--			: 01.04.2005 - Novos parametros para a consulta - Clelson Camargo
--			:            - Campo nm_mat_prima e filtro por ele - Clelson Camargo
----------------------------------------------------------------------------------------------

@ic_parametro     int,
@cd_grupo_produto int,
@cd_serie_produto int,
@cd_produto       int,
@cd_mascara_produto varchar(40) = '',
@nm_fantasia_produto varchar(40) = '',
@nm_produto varchar(40) = '',
@nm_materia_prima varchar(40) = ''

as

-------------------------------------------------------------------
if @ic_parametro = 1 --Consulta filtrada por Grupo, Serie ou Produto
-------------------------------------------------------------------
begin
  select
    pc.cd_produto,
    isnull(pc.ic_lista_preco_produto,'N') as 'ic_lista_preco_produto',
    isnull(pc.ic_lista_rep_produto,'N') as 'ic_lista_rep_produto',    
--    case when ( pc.ic_lista_preco_produto = 'S' ) then 1 else 0  end as 'intic_lista_preco_produto', 
--    case when ( pc.ic_lista_rep_produto = 'S' ) then 1 else 0  end as 'intic_lista_rep_produto', 
    dbo.fn_mascara_produto(p.cd_produto) as 'cd_mascara_produto',
    p.nm_fantasia_produto,
    p.nm_produto,
    u.sg_unidade_medida,
    p.vl_produto,
    gp.sg_grupo_produto,
    sp.sg_serie_produto,
    mp.nm_mat_prima
  from
    produto p
  left outer join Produto_Custo pc on pc.cd_produto = p.cd_produto
  left outer join Unidade_Medida u on u.cd_unidade_medida = p.cd_unidade_medida
  left outer join grupo_produto gp on gp.cd_grupo_produto = p.cd_grupo_produto
  left outer join serie_produto sp on sp.cd_serie_produto = p.cd_serie_produto
  left outer join materia_prima mp on mp.cd_mat_prima = p.cd_materia_prima
  where 
    ((@cd_grupo_produto = 0) or (p.cd_grupo_produto = @cd_grupo_produto)) and
    ((@cd_serie_produto = 0) or (p.cd_serie_produto = @cd_serie_produto)) and
    ((@cd_produto = 0) or (p.cd_produto = @cd_produto)) and
    ((IsNull(@cd_mascara_produto,'') = '') or (p.cd_mascara_produto like @cd_mascara_produto)) and
    ((IsNull(@nm_fantasia_produto,'') = '') or (p.nm_fantasia_produto like @nm_fantasia_produto)) and
    ((IsNull(@nm_produto,'') = '') or (p.nm_produto like @nm_produto)) and
    ((IsNull(@nm_materia_prima,'') = '') or (mp.nm_mat_prima like @nm_materia_prima))
end


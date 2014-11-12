
CREATE PROCEDURE pr_consulta_reajuste_individual
--------------------------------------------------------------------
--pr_consulta_reajuste_individual
--------------------------------------------------------------------
--GBS - Global Business Solution Ltda                           2004
--------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		      : Daniel Duela
--Banco de Dados	  : EGISSQL
--Objetivo		      : Consulta de Produtos para Alteração Definitiva do Preço
--Data			        : 18/07/2002
-- 			            : 28/08/2003 - Reestruturação da SP pra funcionamento correto - DUELA
--Atualização       : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--Atualização       : 11/11/2006 - Acrescentar serviços. - Anderson
----------------------------------------------------------------------------------------------
@ic_parametro char(1),
@nm_filtro varchar(40),
@cd_serie_produto int,
@cd_grupo_produto int,
@ic_grupo_servico varchar(1) = 'N'
AS

if isnull(@ic_grupo_servico,'') <> 'S'
begin
  select
    p.cd_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    u.sg_unidade_medida,
    p.vl_produto,
    pp.vl_temp_produto_preco,
    pp.qt_indice_produto_preco
  from Produto p
  left outer join Produto_Custo pc
    on pc.cd_produto=p.cd_produto
  left outer join Unidade_Medida u
    on u.cd_unidade_medida=p.cd_unidade_medida
  left outer join Produto_Preco pp
    on pp.cd_produto=p.cd_produto
  where 
    ((p.cd_grupo_produto=@cd_grupo_produto) or ( @cd_grupo_produto = 0 ))
    and 
    ((p.cd_serie_produto=@cd_serie_produto) or  ( @cd_serie_produto = 0 ))
    and
    ((@ic_parametro = 'T') or
     (@ic_parametro = 'F' and p.nm_fantasia_produto like @nm_filtro+'%' ) or
     (@ic_parametro = 'C' and p.cd_mascara_produto like @nm_filtro+'%' ))
  order by
    p.nm_fantasia_produto
end
else
begin
  select
    s.cd_servico                        as cd_produto,
    s.cd_mascara_servico                as cd_mascara_produto,
    cast( s.nm_servico as varchar(15) ) as nm_fantasia_produto,
    s.nm_servico                        as nm_produto,
    u.sg_unidade_medida,
    s.vl_servico                        as vl_produto,
    pp.vl_temp_produto_preco,
    pp.qt_indice_produto_preco
  from servico s
  left outer join Unidade_Medida u on u.cd_unidade_medida=s.cd_unidade_medida
  left outer join produto_Preco pp on pp.cd_produto=s.cd_servico
  where 
    ((s.cd_grupo_produto=@cd_grupo_produto) or ( @cd_grupo_produto = 0 )) and
    ((s.cd_servico = isnull(@nm_filtro,'')) or ( isnull(@nm_filtro,'') = '' ))
  order by
    s.nm_servico
end


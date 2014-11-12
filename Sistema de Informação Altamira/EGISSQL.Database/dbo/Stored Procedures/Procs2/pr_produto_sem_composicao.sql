
CREATE PROCEDURE pr_produto_sem_composicao
@cd_grupo int,
@cd_tipo int,
@cd_produto varchar(100)
AS

declare @cd_produto_comp as varchar(100)
 set @cd_produto_comp = '%' + @cd_produto + '%'

----------------------------------------
if @cd_tipo = 0 --por Código
----------------------------------------
  SELECT 
    c.sg_grupo_produto, a.cd_mascara_produto,
    a.nm_fantasia_produto, a.nm_produto,
    b.sg_unidade_medida
  FROM 
    produto a,
    unidade_medida b,
    grupo_produto c
  WHERE 
    (@cd_grupo = 0 OR a.cd_grupo_produto = @cd_grupo) and
    (@cd_produto = '' OR a.cd_mascara_produto LIKE @cd_produto_comp) and
    a.cd_produto NOT IN (SELECT cd_produto_pai FROM produto_composicao) and
    a.cd_unidade_medida *= b.cd_unidade_medida and
    a.cd_grupo_produto *= c.cd_grupo_produto

----------------------------------------
if @cd_tipo = 1 --por Fantasia
----------------------------------------
  SELECT 
    c.sg_grupo_produto, a.cd_mascara_produto,
    a.nm_fantasia_produto, a.nm_produto,
    b.sg_unidade_medida
  FROM 
    produto a,
    unidade_medida b,
    grupo_produto c
  WHERE 
    (@cd_grupo = 0 OR a.cd_grupo_produto = @cd_grupo) and
    (@cd_produto = '' OR a.nm_fantasia_produto LIKE @cd_produto_comp) and
    a.cd_produto NOT IN (SELECT cd_produto_pai FROM produto_composicao) and
    a.cd_unidade_medida *= b.cd_unidade_medida and
    a.cd_grupo_produto *= c.cd_grupo_produto

----------------------------------------
if @cd_tipo = 2 --por Descrição
----------------------------------------
  SELECT 
    c.sg_grupo_produto, a.cd_mascara_produto,
    a.nm_fantasia_produto, a.nm_produto,
    b.sg_unidade_medida
  FROM 
    produto a,
    unidade_medida b,
    grupo_produto c
  WHERE 
    (@cd_grupo = 0 OR a.cd_grupo_produto = @cd_grupo) and
    (@cd_produto = '' OR a.nm_produto LIKE @cd_produto_comp) and
    a.cd_produto NOT IN (SELECT cd_produto_pai FROM produto_composicao) and
    a.cd_unidade_medida *= b.cd_unidade_medida and
    a.cd_grupo_produto *= c.cd_grupo_produto


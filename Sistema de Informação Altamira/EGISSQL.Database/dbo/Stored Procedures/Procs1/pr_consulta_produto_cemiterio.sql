

/****** Object:  Stored Procedure dbo.pr_consulta_produto_cemiterio    Script Date: 13/12/2002 15:08:23 ******/

CREATE PROCEDURE pr_consulta_produto_cemiterio
@ic_parametro integer,
@nm_produto varchar(15)

AS

-------------------------------------------------------------------------------------------
if @ic_parametro = 1 --Consulta Todos os Produtos
-------------------------------------------------------------------------------------------
begin
  select
    p.*,
    pc.*,
    e.nm_fantasia_empresa,
    gc.ds_grupo_composicao
  from Produto p
  left outer join Produto_Cemiterio pc on
    pc.cd_produto=p.cd_produto
  left outer join EgisAdmin.dbo.Empresa e on
    e.cd_empresa=pc.cd_empresa
  left outer join Grupo_Composicao gc on
    gc.cd_grupo_composicao=pc.cd_grupo_composicao
  order by p.nm_produto
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 2 --Consulta Somente o Produto que começa com o nome informado
-------------------------------------------------------------------------------------------
begin
  select
    p.*,
    pc.*,
    e.nm_fantasia_empresa,
    gc.ds_grupo_composicao
  from Produto p
  left outer join Produto_Cemiterio pc on
    pc.cd_produto=p.cd_produto
  left outer join EgisAdmin.dbo.Empresa e on
    e.cd_empresa=pc.cd_empresa
  left outer join Grupo_Composicao gc on
    gc.cd_grupo_composicao=pc.cd_grupo_composicao
  where 
   p.nm_produto like @nm_produto + '%'
  order by p.nm_produto
end

-------------------------------------------------------------------------------------------
else if @ic_parametro = 3 --Abre a consulta mas não traz nenhum Produto
-------------------------------------------------------------------------------------------
begin
  select
    p.*,
    pc.*,
    e.nm_fantasia_empresa,
    gc.ds_grupo_composicao
  from (select top 1 * from Produto where 1=2) as p
  left outer join Produto_Cemiterio pc on
    pc.cd_produto=p.cd_produto
  left outer join EgisAdmin.dbo.Empresa e on
    e.cd_empresa=pc.cd_empresa
  left outer join Grupo_Composicao gc on
    gc.cd_grupo_composicao=pc.cd_grupo_composicao
end




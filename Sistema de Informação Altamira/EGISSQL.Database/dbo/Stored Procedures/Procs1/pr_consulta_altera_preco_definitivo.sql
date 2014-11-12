
CREATE PROCEDURE pr_consulta_altera_preco_definitivo
@ic_parametro char(1),
@nm_filtro varchar(40),
@cd_serie_produto int,
@cd_grupo_produto int,
@ic_grupo_servico varchar(1) = 'N'

as

if @ic_grupo_servico <> 'S'
begin 
  select
    p.cd_produto,
    dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as cd_mascara_produto,
    p.nm_fantasia_produto,
    p.nm_produto,
    u.sg_unidade_medida,
    p.vl_produto
  from Produto p
  left outer join Produto_Custo pc
    on pc.cd_produto=p.cd_produto
  left outer join Unidade_Medida u
    on u.cd_unidade_medida=p.cd_unidade_medida
  left outer join Grupo_Produto gp on
    gp.cd_grupo_produto=p.cd_grupo_produto
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
    s.cd_servico         as cd_produto,
    s.cd_mascara_servico as cd_mascara_produto,
    s.sg_servico         as nm_fantasia_produto,
    s.nm_servico         as nm_produto,
    u.sg_unidade_medida,
    s.vl_servico         as vl_produto,
    s.cd_grupo_produto
  from servico s
  left outer join servico_Custo sc on sc.cd_servico       = s.cd_servico
  left outer join Unidade_Medida u on u.cd_unidade_medida = s.cd_unidade_medida
  left outer join Grupo_Produto gp on gp.cd_grupo_produto = s.cd_grupo_produto
  where 
    ((isnull(@cd_grupo_produto,0) = 0)      or (s.cd_grupo_produto = @cd_grupo_produto)) and
    ((s.cd_servico = isnull(@nm_filtro,'')) or ( isnull(@nm_filtro,'') = '' ))
  order by
    s.sg_servico
end


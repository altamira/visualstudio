
CREATE VIEW vw_fechamento_estoque_selecao_inicial

--------------------------------------------------------------------------
--GBS - Global Business Solution	                              2004
--------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server           2003
--Autor(es)             : Eduardo Baião
--Banco de Dados	: EGISSQL
--Objetivo		: Buscar os Produtos que serão utilizados
--                        no Fechamento Mensal dos Estoques
--Data                  : 13/04/2004
--Atualizado            : 26.01.2005 - Carlos Fernandes
--------------------------------------------------------------------------
as

  select
    p.cd_produto,
    f.cd_fase_produto,   
    p.cd_grupo_produto,
    p.vl_produto as vl_maior_lista_produto 
  from
    Produto p with (NOLOCK)

    left outer join Grupo_Produto gp with (NOLOCK)
      on gp.cd_grupo_produto = p.cd_grupo_produto   

    left outer join Grupo_Produto_Custo gpc with (NOLOCK)
      on gpc.cd_grupo_produto = p.cd_grupo_produto, 

    Fase_produto f with (NOLOCK)

  Where   
    isnull(gp.ic_especial_grupo_produto, 'N') = 'N' and   
    isnull(gpc.ic_fechamento_mensal,'S')      = 'S' and
    isnull(gpc.ic_estoque_grupo_prod,'S')     = 'S' 


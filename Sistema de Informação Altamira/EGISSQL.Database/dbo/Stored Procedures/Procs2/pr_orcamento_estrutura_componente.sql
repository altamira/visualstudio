
CREATE PROCEDURE pr_orcamento_estrutura_componente

@cd_serie_produto      int,
@cd_tipo_serie_produto int,
@cd_parametro          int, -- 0 = Todos os componentes (Independente da quantidade)
                            -- 1 = Somente com quantidade > 0
@cd_placa              int

as
 
  Select
    identity(int,1,1)           as 'Ordem',
    a.cd_serie_produto,
    a.cd_tipo_serie_produto, 
    a.cd_item_serie_prod_comp   as 'Item',
    a.cd_placa                  as 'CodPlaca',  
    c.sg_placa                  as 'Placa',
    a.cd_produto                as 'CodProduto',
    b.nm_fantasia_produto       as 'Produto', 
    b.qt_espessura_produto      as 'ProdutoEspessura',
    b.qt_largura_produto        as 'ProdutoLargura',
    b.qt_comprimento_produto    as 'ProdutoComprimento',
    a.qt_furo_serie_produto     as 'Furos',
    a.qt_bc_serie_produto       as 'Buchas',
    a.qt_bc_serie_produto       as 'QTBC',  -- Cleiton incluiu anteriormente
    a.qt_diambc_serie_produto   as 'DiametroBucha',
    a.qt_diambc_serie_produto   as 'DimBC', -- Cleiton incluiu anteriormente 
    a.ic_procfab_serie_produto  as 'Processo', 
    a.ic_orcamento_serie_prod   as 'Orcamento',
    a.ic_progcnc_serie_produto  as 'CNC',
    a.qt_espessura_serie_prod   as 'Espessura',
    a.qt_largura_serie_produto  as 'Largura',
    a.qt_comprimento_serie_prod as 'Comprimento',
    a.qt_profrasgo_serie_prod   as 'ProfRasgo',
    a.qt_comprasgo_serie_prod   as 'CompRasgo',
    a.qt_larrasgo_serie_produto as 'LargRasgo',
    a.cd_grupo_esquadro         as 'GrupoEsquadro',
    a.qt_componente_serie_prod  as 'Qtde',
    a.nm_obs_serie_produto      as 'Obs',
    a.ic_curso_serie_produto    as 'Curso',
    a.ic_base_serie_produto     as 'Base',
    a.ic_molde_serie_produto    as 'Molde',
    a.ic_cpc_serie_produto      as 'CPC'
  --
  into #TmpOrdenado
  --
  from
    Serie_Produto_Componente a

  Left Join Produto b
  On a.cd_produto = b.cd_produto

  Left Join Placa c
  On a.cd_placa = c.cd_placa

  where a.cd_serie_produto = @cd_serie_produto and
        a.cd_tipo_serie_produto = @cd_tipo_serie_produto and
       (@cd_placa = 0 or
        a.cd_placa = @cd_placa) and
       (@cd_parametro = 0 or
       (a.qt_componente_serie_prod >= @cd_parametro and
        a.ic_progcnc_serie_produto = 'S')) 

  order by cd_item_serie_prod_comp

  select * from #TmpOrdenado
  order by Ordem


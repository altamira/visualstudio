
CREATE PROCEDURE pr_consulta_saldo_atual_mes
------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2001
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Daniel Duela
--Banco de Dados: EgisSQL
--Objetivo      : Consulta Saldo de Estoque por Mes
--Data          : 25/03/2002
--Atualizado    : 18/04/2002
--              : 25/08/2003 - Se não houver fechamento, trazer da tabela Produto_Saldo - Daniel C. Neto.
--              : 12/09/2003 - Adição de 4 novos campos 
--                            (vl_custo_prod_fechamento, vl_maior_custo_produto, 
--                             vl_maior_preco_produto, vl_maior_lista_produto) - DANIEL DUELA
--                08/03/2004 - Inclusão dos campos 'Saldo_Inicial' e 'Saldo_Final' - DANIEL DUELA
-- 24.05.2004   : Inclusão de campos de quantidade - Peps, Ueps e Qtd Média - Igor Gama
--              : 15.11.2006 - Método de Valoração - Carlos Fernandes
-- 20.05.2008 - Marca do Produto - Carlos Fernandes
------------------------------------------------------------------------------------------------------
@ic_parametro        int, 
@cd_produto          int,
@cd_fase_produto     int,
@ano_base            int

AS

--------------------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Saldo Geral do Produto de Acordo com a Ano e o Mês
--------------------------------------------------------------------------------------------
begin
  select 
    pf.cd_produto,
    p.nm_fantasia_produto             as 'Produto',
    p.cd_mascara_produto              as 'Mascara',
    gp.nm_grupo_produto               as 'Grupo',
    um.nm_unidade_medida              as 'Medida',
    pf.dt_produto_fechamento          as 'Data_Fechamento',
    year(pf.dt_produto_fechamento)    as 'Ano',
    month(pf.dt_produto_fechamento)   as 'cd_mes',
    (select nm_mes from Mes 
    where cd_mes=month(pf.dt_produto_fechamento))                       as 'Mes',
    isnull(sum(pf.qt_atual_prod_fechamento), ps.qt_saldo_atual_produto) as 'Saldo_Estoque_Atual',
    (select qt_atual_prod_fechamento
     from Produto_Fechamento pf
	   where pf.cd_produto= @cd_produto and
           pf.cd_fase_produto = @cd_fase_produto and
           month(dt_produto_fechamento)=12 and
           year(dt_produto_fechamento)=(@ano_base)-1) as 'Saldo_Inicial',
    (select qt_atual_prod_fechamento
     from Produto_Fechamento pf
     where pf.cd_produto= @cd_produto and
           pf.cd_fase_produto = @cd_fase_produto and
           month(dt_produto_fechamento)=12 and
           year(dt_produto_fechamento)=@ano_base) as 'Saldo_Final',
    isnull(sum(pf.qt_entra_prod_fechamento), ps.qt_entrada_produto)     as 'Saldo_Estoque_Entra',
    isnull(sum(pf.qt_saida_prod_fechamento), ps.qt_saida_produto)       as 'Saldo_Estoque_Saida',
    isnull(sum(pf.qt_consig_prod_fechamento), ps.qt_consig_produto)     as 'Saldo_Estoque_Consig',
    isnull(sum(pf.qt_terc_prod_fechamento), ps.qt_terceiro_produto)     as 'Saldo_Estoque_Terc',
    isnull(sum(pf.vl_custo_prod_fechamento),0)                          as vl_custo_prod_fechamento,
    isnull(sum(pf.vl_maior_custo_produto),0)                            as vl_maior_custo_produto,
    isnull(sum(pf.vl_maior_preco_produto),0)                            as vl_maior_preco_produto,
    isnull(sum(pf.vl_maior_lista_produto),0)                            as vl_maior_lista_produto,
    isnull(sum(pf.qt_peps_prod_fechamento),0)                           as qt_peps_prod_fechamento,
    isnull(sum(pf.qt_medio_prod_fechamento),0)                          as qt_medio_prod_fechamento,
    isnull(sum(pf.qt_ueps_prod_fechamento),0)                           as qt_ueps_prod_fechamento,
    max(mv.nm_metodo_valoracao)                                         as nm_metodo_valoracao,
    max(isnull(mp.nm_marca_produto,p.nm_marca_produto))                 as nm_marca_produto
  from 
    Produto p with (nolock) 
      left outer join 
    Produto_Fechamento pf with (nolock) 
      on p.cd_produto = pf.cd_produto
      left outer join 
    Unidade_Medida um 
      on um.cd_unidade_medida = p.cd_unidade_medida
      left outer join 
    Grupo_Produto gp 
      on gp.cd_grupo_produto = p.cd_grupo_produto
      left outer join 
    Produto_Saldo ps 
      on ps.cd_produto = p.cd_produto and
         ps.cd_fase_produto = @cd_fase_produto
    left outer join Metodo_Valoracao mv on mv.cd_metodo_valoracao = pf.cd_metodo_valoracao
    left outer join Marca_Produto    mp on mp.cd_marca_produto    = p.cd_marca_produto
  where 
    ((@cd_produto = 0) or (pf.cd_produto = @cd_produto) ) and 
    pf.cd_fase_produto = @cd_fase_produto and
    year(pf.dt_produto_fechamento) = @ano_base
  group by 
    pf.cd_produto, p.cd_mascara_produto, p.nm_fantasia_produto, 
    ps.qt_entrada_produto, ps.qt_saida_produto,
    ps.qt_consig_produto, ps.qt_terceiro_produto, ps.qt_saldo_atual_produto,
    gp.nm_grupo_produto, um.nm_unidade_medida, pf.dt_produto_fechamento,
    month(pf.dt_produto_fechamento)
  order by 
    pf.dt_produto_fechamento

end
  
-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Zera Procedure
-------------------------------------------------------------------------------
  begin
    select 
       0         as 'cd_produto',
       ''        as 'Produto',
       ''        as 'Mascara',
       ''        as 'Grupo',
       ''        as 'Medida',
       getdate() as 'Data_Fechamento',
       0         as 'Ano',
       0         as 'cd_mes',
       ''        as 'Mes',
       0.00      as 'Saldo_Estoque_Atual',
       0.00      as 'Saldo_Inicial',
       0.00      as 'Saldo_Final',
       0.00      as 'Saldo_Estoque_Entra',
       0.00      as 'Saldo_Estoque_Saida',
       0.00      as 'Saldo_Estoque_Consig',
       0.00      as 'Saldo_Estoque_Terc',
       0.00      as vl_custo_prod_fechamento, 
       0.00      as vl_maior_custo_produto, 
       0.00      as vl_maior_preco_produto, 
       0.00      as vl_maior_lista_produto,
       0.00      as qt_peps_prod_fechamento,
       0.00      as qt_medio_prod_fechamento,
       0.00      as qt_ueps_prod_fechamento,
       ''        as nm_metodo_valoracao,
       ''        as nm_marca_produto
    where 1=2
end


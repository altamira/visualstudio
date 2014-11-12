
CREATE PROCEDURE pr_fechamento_rapida

@dt_inicial datetime,
@dt_final   datetime,
@cd_produto int

AS

if @cd_produto is null
  set @cd_produto = 0

--Apagando fechamento do período
delete
  Produto_Fechamento
where
  dt_produto_fechamento = @dt_final and
  ((@cd_produto = 0) or (cd_produto = @cd_produto))

--Pegando saldo de fechamento do mês anterior
select
  p.cd_produto,
  fp.cd_fase_produto,
  isnull(pf.qt_atual_prod_fechamento,0) as qt_atual_prod_fechamento
into
  #Saldo_Inicial
from
  Produto 		p,
  Fase_Produto 		fp,
  Produto_Fechamento	pf
where
  p.cd_produto       		*= pf.cd_produto      and
  fp.cd_fase_produto 		*= pf.cd_fase_produto and
  pf.dt_produto_fechamento 	 = @dt_inicial - 1    and
  ((@cd_produto = 0) or (p.cd_produto = @cd_produto))

--Inserindo Fechamentos 
insert into
  Produto_Fechamento
select
  distinct
  p.cd_produto,
  fp.cd_fase_produto,
  @dt_final as dt_produto_fechamento,

  --Entradas
  isnull((select
    sum(eme.qt_movimento_estoque) as qt_entrada
  from
    Movimento_Estoque eme,
    Tipo_Movimento_Estoque etme
  where
    eme.cd_tipo_movimento_estoque  =  etme.cd_tipo_movimento_estoque and
    etme.ic_mov_tipo_movimento     =  'E' and
    etme.nm_atributo_produto_saldo =  'qt_saldo_atual_produto' and
    eme.dt_movimento_estoque       between @dt_inicial and @dt_final and
    eme.cd_produto                 = p.cd_produto and
    eme.cd_fase_produto = fp.cd_fase_produto),0) + 
    isnull(si.qt_atual_prod_fechamento,0)        -

  --Saídas

  isnull((select
    sum(eme.qt_movimento_estoque)
  from
    Movimento_Estoque eme,
    Tipo_Movimento_Estoque etme
  where
    eme.cd_tipo_movimento_estoque  =  etme.cd_tipo_movimento_estoque and
    etme.ic_mov_tipo_movimento     =  'S' and
    etme.nm_atributo_produto_saldo =  'qt_saldo_atual_produto' and
    eme.dt_movimento_estoque       between @dt_inicial and @dt_final and
    eme.cd_produto                 = p.cd_produto and
    eme.cd_fase_produto = fp.cd_fase_produto),0) as qt_atual_prod_fechamento,

  --Entradas
  isnull((select
    sum(eme.qt_movimento_estoque) as qt_entrada
  from
    Movimento_Estoque eme,
    Tipo_Movimento_Estoque etme
  where
    eme.cd_tipo_movimento_estoque  =  etme.cd_tipo_movimento_estoque and
    etme.ic_mov_tipo_movimento     =  'E' and
    etme.nm_atributo_produto_saldo =  'qt_saldo_atual_produto' and
    eme.dt_movimento_estoque       between @dt_inicial and @dt_final and
    eme.cd_produto                 = p.cd_produto and
    eme.cd_fase_produto = fp.cd_fase_produto),0) as qt_entra_prod_fechamento,

  --Saídas
  isnull((select
    sum(eme.qt_movimento_estoque)
  from
    Movimento_Estoque eme,
    Tipo_Movimento_Estoque etme
  where
    eme.cd_tipo_movimento_estoque  =  etme.cd_tipo_movimento_estoque and
    etme.ic_mov_tipo_movimento     =  'S' and
    etme.nm_atributo_produto_saldo =  'qt_saldo_atual_produto' and
    eme.dt_movimento_estoque       between @dt_inicial and @dt_final and
    eme.cd_produto                 = p.cd_produto and
    eme.cd_fase_produto = fp.cd_fase_produto),0) as qt_saida_prod_fechamento,
  
  0 as qt_consig_prod_fechamento,
  0 as qt_terc_prod_fechamento,
  1 as cd_usuario,
  @dt_final as dt_usuario,
  0 as vl_custo_prod_fechamento,
  0 as vl_maior_custo_produto,
  0 as vl_maior_preco_produto,
  0 as vl_maior_lista_produto,
  0 as vl_custo_medio_fechamento,
  0 as vl_custo_peps_fechamento,
  0 as vl_custo_ueps_fechamento
from
  Produto		p,
  Movimento_Estoque 	me,
  Fase_Produto 		fp,
  #Saldo_Inicial	si
where
  p.cd_produto 		  *= me.cd_produto and
  me.dt_movimento_estoque between @dt_inicial and @dt_final and
  p.cd_produto		  *= si.cd_produto and
  fp.cd_fase_produto      *= si.cd_fase_produto and
  ((@cd_produto = 0) or (cd_produto = @cd_produto))
order by 
  1,2


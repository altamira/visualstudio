
-----------------------------------------------------------------------------------
--pr_atualiza_custo_inventario_fechamento
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Atualização dos Valores de Lista, Custo e Venda do Produto
--                   para Cálculo do Inventário de Gestão
--Data             : 10.09.2003
-----------------------------------------------------------------------------------
create procedure pr_atualiza_custo_inventario_fechamento
@dt_inicial datetime,
@dt_final   datetime
as

--Atualização do preço de Lista do Produto

select
  cd_produto,
  vl_produto
into 
  #Produto_Preco
from
  Produto
order by
  cd_produto

update
  Produto_Fechamento
set
  vl_maior_lista_produto = p.vl_produto
from
  #Produto_Preco     p, 
  Produto_Fechamento pf
where
  pf.dt_produto_fechamento between @dt_inicial and @dt_final and
  pf.cd_produto = p.cd_produto 


--Atualização do Maior Preço de Venda conforme o item da Nota Fiscal

select
  nsi.cd_produto,
  max(nsi.vl_unitario_item_nota) as vl_maior_preco_produto
into
  #Maior_Preco_Venda
from
  Nota_Saida      ns, 
  Nota_Saida_Item nsi, 
  Operacao_Fiscal ofi
where
  ns.dt_nota_saida between @dt_inicial           and @dt_final and
  ns.cd_status_nota = 5                          and               --Nota Emitida 
  ns.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
  ofi.ic_comercial_operacao = 'S'                and
  ns.cd_nota_saida  = nsi.cd_nota_saida          
group by
  nsi.cd_produto

update
  Produto_Fechamento
set
  vl_maior_preco_produto = p.vl_maior_preco_produto
from
  #Maior_Preco_Venda p, 
  Produto_Fechamento pf
where
  pf.dt_produto_fechamento between @dt_inicial and @dt_final and
  pf.cd_produto = p.cd_produto 

--Atualização do Maior Custo do Período

select
  nei.cd_produto,
  max(nei.vl_item_nota_entrada) as vl_maior_custo_produto
into
  #Maior_Custo_Periodo
from
  Nota_Entrada ne, 
  Nota_Entrada_Item nei, 
  Operacao_Fiscal ofi
where
  ne.dt_nota_entrada between @dt_inicial         and @dt_final and
  ne.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
  ofi.ic_comercial_operacao = 'S'                and
  ne.cd_nota_entrada    = nei.cd_nota_entrada   
group by
  nei.cd_produto

update
  Produto_Fechamento
set
  vl_maior_custo_produto = p.vl_maior_custo_produto
from
  #Maior_Custo_Produto p, 
  Produto_Fechamento pf
where
  pf.dt_produto_fechamento between @dt_inicial and @dt_final and
  pf.cd_produto = p.cd_produto 



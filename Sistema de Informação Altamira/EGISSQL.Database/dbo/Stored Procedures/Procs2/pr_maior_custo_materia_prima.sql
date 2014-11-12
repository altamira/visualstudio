
-----------------------------------------------------------------------------------
--pr_maior_custo_materia_prima
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes         
--Banco Dados      : EGISSQL
--Objetivo         : Consulta do Maior Custo da Matéria-Prima
--Data             : 15.09.2003
--Alteração        : 18/09/2003 Francisco Leite Neto
--                   19/09/2003 - Colocado uso para @cd_mat_prima - Daniel C. Neto.
--Inclusão do Campo nm_mat
-----------------------------------------------------------------------------------
create procedure pr_maior_custo_materia_prima
@cd_mat_prima int,
@dt_inicial   datetime,
@dt_final     datetime


as

select
  p.cd_grupo_produto,
  pc.cd_mat_prima,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  p.cd_produto,
  mp.nm_mat_prima
  
into
  #Produto_Maior_Custo
from
  Grupo_Produto_Custo gpc,
  Produto p,
  Produto_Custo pc,
  Materia_Prima mp
where
  isnull(gpc.ic_mat_prima_grupo,'N')='S'     and
  gpc.cd_grupo_produto = p.cd_grupo_produto  and
  p.cd_produto         = pc.cd_produto       and
  mp.cd_mat_prima      =* pc.cd_mat_prima and
  ( ( @cd_mat_prima = 0 ) or 
    ( pc.cd_mat_prima = @cd_mat_prima ) )
order by
  p.cd_mascara_produto


--  Nota_Entrada_Item nei,
--  Pedido_Compra_Item pci

--Atualização do Maior Custo do Período

select
  nei.cd_produto                     as cd_produto_movimento,
  max(nei.vl_item_nota_entrada)      as vl_maior_custo_produto,
  max(nei.cd_fornecedor)             as cd_fornecedor,
  max(nei.cd_nota_entrada)           as cd_nota_entrada,
  max(nei.cd_item_nota_entrada)      as cd_item_nota_entrada,
  max(nei.dt_item_receb_nota_entrad) as dt_item_entrada

into
  #Maior_Custo_Periodo
from
  #Produto_Maior_Custo pmc,
  Nota_Entrada         ne, 
  Nota_Entrada_Item    nei, 
  Operacao_Fiscal      ofi
where
  pmc.cd_produto = nei.cd_produto                and
  nei.cd_nota_entrada = ne.cd_nota_entrada       and
  ne.dt_nota_entrada between @dt_inicial         and @dt_final and
  ne.cd_operacao_fiscal = ofi.cd_operacao_fiscal and
  ofi.ic_comercial_operacao = 'S'                
group by
  nei.cd_produto


--Tabela Final

select pmc.*,
       mcp.*,
       f.nm_fantasia_fornecedor
from
  #Produto_Maior_Custo pmc,
  #Maior_Custo_Periodo mcp,
  Fornecedor f
where
  pmc.cd_produto    = mcp.cd_produto_movimento and
  mcp.cd_fornecedor = f.cd_fornecedor



-------------------------------------------------------------------------------
--pr_consulta_nota_entrada_nao_gerou_ativo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Notas Fiscais de Entrada com CFOP para Ativo 
--                   Fixo e não gerou o bem no Controle de Ativo Fixo
--                   
--Data             : 25.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_nota_entrada_nao_gerou_ativo
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select ic_ativo_operacao_fiscal,* from operacao_fiscal

select
  f.nm_fantasia_fornecedor      as Fornecedor,
  ne.cd_fornecedor,           
  ne.cd_nota_entrada            as Nota,      
  ne.cd_serie_nota_fiscal,
  sn.sg_serie_nota_fiscal       as Serie,
  ne.cd_operacao_fiscal         as CodigoCFOP,
  opf.cd_mascara_operacao       as CFOP,
  ne.vl_total_nota_entrada      as Total,
  ne.dt_nota_entrada            as Entrada,          
  ne.dt_receb_nota_entrada      as Recebimento,
  ine.cd_item_nota_entrada      as Item,
  ine.nm_produto_nota_entrada   as Produto,
  ine.qt_item_nota_entrada      as Qtd,
  um.sg_unidade_medida          as Unidade,
  ine.cd_pedido_compra          as PedidoCompra,
  ine.cd_item_pedido_compra     as ItemPed
  
from
  Nota_Entrada ne
  inner join operacao_fiscal opf      on opf.cd_operacao_fiscal   = ne.cd_operacao_fiscal
  inner join nota_entrada_item ine    on ine.cd_fornecedor        = ne.cd_fornecedor   and
                                         ine.cd_nota_entrada      = ne.cd_nota_entrada and
                                         ine.cd_operacao_fiscal   = ne.cd_operacao_fiscal and 
                                         ine.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
  left outer join Fornecedor   f       on f.cd_fornecedor          = ne.cd_fornecedor
  left outer join Unidade_medida um    on um.cd_unidade_medida    = ine.cd_unidade_medida
  left outer join Serie_Nota_Fiscal sn on sn.cd_serie_nota_fiscal = ne.cd_serie_nota_fiscal
where
  isnull(opf.ic_ativo_operacao_fiscal,'N')='S' 
  and ne.dt_nota_entrada between @dt_inicial and @dt_final
  and isnull(cd_bem,0) = 0

--select * from nota_entrada
--select * from nota_entrada_item



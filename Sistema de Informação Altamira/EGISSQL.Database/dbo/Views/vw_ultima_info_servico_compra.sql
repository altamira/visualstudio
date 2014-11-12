
CREATE VIEW vw_ultima_info_servico_compra

AS 

select
  p.cd_servico,
  fp.cd_fornecedor,
  --Buscando numero da ultima cotacao para o serviço e fornecedor
/*  (select 
     top 1 c.cd_cotacao 
   from 
     cotacao      c  inner join 
     cotacao_Item ci on c.cd_cotacao = ci.cd_cotacao
   where
     c.cd_fornecedor = fp.cd_fornecedor and
     ci.cd_servico   = p.cd_servico
   order by 
     c.cd_cotacao desc) as cd_ultima_cotacao,

  --Buscando data da ultima cotacao para o serviço e fornecedor
  (select 
     top 1 c.dt_cotacao 
   from 
     cotacao      c  inner join 
     cotacao_Item ci on c.cd_cotacao = ci.cd_cotacao
   where
     c.cd_fornecedor = fp.cd_fornecedor and
     ci.cd_servico   = p.cd_servico
   order by 
     c.cd_cotacao desc) as dt_ultima_cotacao,

  --Buscando valor unitario do servico da ultima cotacao para o fornecedor
  (select 
     top 1 ci.vl_item_cotacao 
   from 
     cotacao      c  inner join 
     cotacao_Item ci on c.cd_cotacao = ci.cd_cotacao
   where
     c.cd_fornecedor = fp.cd_fornecedor and
     ci.cd_servico   = p.cd_servico
   order by 1 desc) as vl_unit_ultima_cotacao,

  --Buscando quantidade do serviço da ultima cotacao para o fornecedor
  (select 
     top 1 ci.qt_item_cotacao 
   from 
     cotacao      c  inner join 
     cotacao_Item ci on c.cd_cotacao = ci.cd_cotacao
   where
     c.cd_fornecedor = fp.cd_fornecedor and
     ci.cd_servico   = p.cd_servico
   order by 1 desc) as qt_servico_ultima_cotacao,
*/

  --Buscando numero do ultimo pedido de compra para o serviço e fornecedor
  (select 
     top 1 pc.cd_pedido_compra
   from 
     pedido_compra      pc inner join 
     pedido_compra_item pci on pc.cd_pedido_compra = pci.cd_pedido_compra
   where
     pc.cd_fornecedor = fp.cd_fornecedor and
     pci.cd_servico   = p.cd_servico
   order by 
     pc.cd_pedido_compra desc) as cd_ultimo_pedido_compra,

  --Buscando data do ultimo pedido de compra para o servico e fornecedor
  (select 
     top 1 pc.dt_pedido_compra
   from 
     pedido_compra      pc inner join 
     pedido_compra_item pci on pc.cd_pedido_compra = pci.cd_pedido_compra
   where
     pc.cd_fornecedor = fp.cd_fornecedor and
     pci.cd_servico   = p.cd_servico
   order by 
     pc.cd_pedido_compra desc) as dt_ultimo_pedido_compra,

  --Buscando valor unitário do servico do ultimo pedido de compra para o fornecedor
  (select 
     top 1 pci.vl_item_unitario_ped_comp
   from 
     pedido_compra      pc inner join 
     pedido_compra_item pci on pc.cd_pedido_compra = pci.cd_pedido_compra
   where
     pc.cd_fornecedor = fp.cd_fornecedor and
     pci.cd_servico   = p.cd_servico
   order by 
     pc.cd_pedido_compra desc) as vl_unit_ultimo_pedido_compra,

  --Buscando quantidade do servico do ultimo pedido de compra para o fornecedor
  (select 
     top 1 pci.qt_item_pedido_compra
   from 
     pedido_compra      pc inner join 
     pedido_compra_item pci on pc.cd_pedido_compra = pci.cd_pedido_compra
   where
     pc.cd_fornecedor = fp.cd_fornecedor and
     pci.cd_servico   = p.cd_servico
   order by 
     pc.cd_pedido_compra desc) as qt_servico_ult_pedido_compra,

  --Buscando numero da ultima nota de entrada para o servico e fornecedor
  (select 
     top 1 ne.cd_nota_entrada
   from 
     nota_entrada      ne inner join 
     nota_entrada_item nei on ne.cd_nota_entrada = nei.cd_nota_entrada
   where
     ne.cd_fornecedor = fp.cd_fornecedor and
     nei.cd_servico   = p.cd_servico
   order by 
     ne.cd_nota_entrada desc) as cd_ultima_nota,

  --Buscando data da ultima nota de entrada para o servico e fornecedor
  (select 
     top 1 ne.dt_nota_entrada
   from 
     nota_entrada      ne inner join 
     nota_entrada_item nei on ne.cd_nota_entrada = nei.cd_nota_entrada
   where
     ne.cd_fornecedor = fp.cd_fornecedor and
     nei.cd_servico   = p.cd_servico
   order by 
     ne.cd_nota_entrada desc) as dt_ultima_nota,

  --Buscando valor unitario do servico na ultima nota de entrada
  (select 
     top 1 nei.vl_item_nota_entrada
   from 
     nota_entrada      ne inner join 
     nota_entrada_item nei on ne.cd_nota_entrada = nei.cd_nota_entrada
   where
     ne.cd_fornecedor = fp.cd_fornecedor and
     nei.cd_servico   = p.cd_servico
   order by 
     ne.cd_nota_entrada desc) as vl_unit_ultima_nota,

  --Buscando quantidade do servico na ultima nota de entrada
  (select 
     top 1 nei.qt_item_nota_entrada
   from 
     nota_entrada      ne inner join 
     nota_entrada_item nei on ne.cd_nota_entrada = nei.cd_nota_entrada
   where
     ne.cd_fornecedor = fp.cd_fornecedor and
     nei.cd_servico   = p.cd_servico
   order by 
     ne.cd_nota_entrada desc) as qt_servico_ultima_nota

from
  fornecedor_servico fp left outer join
  servico p on fp.cd_servico = p.cd_servico



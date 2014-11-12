
CREATE PROCEDURE pr_consulta_nota_entrada

@dt_inicial 			datetime,
@dt_final 			datetime

AS
  select     
    ne.cd_nota_entrada, 
    ne.nm_fantasia_destinatario as nm_fantasia_fornecedor,
--    f.nm_fantasia_fornecedor, 
    ne.dt_nota_entrada, 
    ne.dt_receb_nota_entrada, 
    ne.vl_total_nota_entrada, 
    ne.vl_prod_nota_entrada, 
    ne.vl_icms_nota_entrada, 
    ne.vl_ipi_nota_entrada,
    (select 
       top 1 cd_pedido_compra
     from          
       nota_entrada_item
     where      
        cd_nota_entrada = ne.cd_nota_entrada and 
        cd_fornecedor = ne.cd_fornecedor) as cd_pedido_compra,
    (select
       top 1 plc.nm_plano_compra
     from
       nota_entrada_item nei,
       pedido_compra pc,
       plano_compra plc 
     where
       nei.cd_nota_entrada = ne.cd_nota_entrada and 
       nei.cd_fornecedor = ne.cd_fornecedor and
       pc.cd_pedido_compra = nei.cd_pedido_compra and
       pc.cd_plano_compra = plc.cd_plano_compra) as nm_plano_compra
  from
    nota_entrada ne with (nolock) 
    left outer join fornecedor f on ne.cd_fornecedor = f.cd_fornecedor
  where
    ne.dt_nota_entrada between @dt_inicial and @dt_final
  order by
    ne.dt_nota_entrada


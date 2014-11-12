
CREATE PROCEDURE pr_controle_laudo
@dt_inicial as DateTime,
@dt_final as DateTime

as

  Select 
       l.*,
       ol.nm_origem_laudo,
       case when isnull(f.nm_fantasia_fornecedor,'')<>'' then f.nm_fantasia_fornecedor else c.nm_fantasia_cliente end as nm_fantasia_fornecedor,
       t.nm_tecnico,
       p.nm_produto,
       p.nm_fantasia_produto,
       um.nm_unidade_medida,
       c.nm_fantasia_cliente
 
    From 
      Laudo l left outer join
      Origem_laudo ol on (l.cd_origem_laudo = ol.cd_origem_laudo) left outer join
      Fornecedor f on (l.cd_fornecedor = f.cd_fornecedor) left outer join
      Tecnico t on (l.cd_tecnico = t.cd_tecnico) left outer join
      Produto p on (l.cd_produto = p.cd_produto) left outer join
      unidade_medida um on (l.cd_unidade_medida = um.cd_unidade_medida) left outer join
      cliente c on c.cd_cliente = l.cd_cliente
  Where l.dt_laudo between @dt_inicial and @dt_final
  order by
    l.dt_laudo desc


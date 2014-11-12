
CREATE PROCEDURE pr_consulta_compra_produto_periodo
  @cd_fornecedor int,
  @cd_produto int,
  @dt_inicial datetime,
  @dt_final   datetime
AS

  select
    f.cd_fornecedor,
    f.nm_fantasia_fornecedor,
    ne.dt_nota_entrada,
    ne.cd_nota_entrada,
    nei.cd_item_nota_entrada,
    nei.qt_item_nota_entrada,
    um.sg_unidade_medida,
    nei.vl_item_nota_entrada,
    cp.nm_condicao_pagamento
  from
    nota_entrada       ne  inner join
    nota_entrada_item  nei on ne.cd_fornecedor         = nei.cd_fornecedor   and 
                              ne.cd_nota_entrada       = nei.cd_nota_entrada and 
                              ne.cd_serie_nota_fiscal  = nei.cd_serie_nota_fiscal left outer join
    fornecedor         f   on ne.cd_fornecedor = f.cd_fornecedor left outer join
    unidade_medida     um  on nei.cd_unidade_medida    = um.cd_unidade_medida left outer join
    condicao_pagamento cp  on ne.cd_condicao_pagamento = cp.cd_condicao_pagamento
  where
    nei.cd_produto = @cd_produto and
    ne.cd_fornecedor = @cd_fornecedor and
    ne.dt_nota_entrada between @dt_inicial and @dt_final
  order by
    ne.dt_nota_entrada desc, ne.cd_nota_entrada, nei.cd_item_nota_entrada



CREATE PROCEDURE pr_consulta_fornecedor_produto
  @cd_produto int
AS

  select
    f.cd_fornecedor,
    f.nm_fantasia_fornecedor,
    m.sg_moeda,
    --Buscando valor unitario da ultima cotacao
    (select 
       top 1 ci.vl_item_cotacao 
     from 
       cotacao      c  inner join 
       cotacao_Item ci on c.cd_cotacao = ci.cd_cotacao
     where
       c.cd_fornecedor = fp.cd_fornecedor and
       ci.cd_produto   = @cd_produto
     order by 1 desc) as vl_unit_ultima_cotacao,
    --Buscando dados do contato
    (select 
       top 1 nm_contato_fornecedor
     from 
       fornecedor_contato 
     where 
       cd_fornecedor = f.cd_fornecedor) as  nm_contato_fornecedor,

    isnull(case when 
      exists(select 
               top 1 'x' 
             from 
               fornecedor_contato 
             where 
               cd_fornecedor = f.cd_fornecedor) then
               (select 
                  top 1 cd_telefone_contato_forne
                from 
                  fornecedor_contato 
                where 
                  cd_fornecedor = f.cd_fornecedor) end, f.cd_telefone) as cd_telefone_contato,
    cp.nm_condicao_pagamento,
    fp.qt_dia_entrega_fornecedor
  from
    fornecedor_produto fp inner join
    fornecedor f on fp.cd_fornecedor = f.cd_fornecedor left outer join
    condicao_pagamento cp on fp.cd_condicao_pagamento = cp.cd_condicao_pagamento left outer join
    moeda m on fp.cd_moeda = m.cd_moeda
  where
    fp.cd_produto = @cd_produto
  order by
    f.nm_fantasia_fornecedor


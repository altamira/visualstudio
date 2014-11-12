
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_devolucao_produto_vendedor
-------------------------------------------------------------------------------
--pr_consulta_devolucao_produto_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Vendas de Produto por Vendedor
--Data             : 21.11.2008
--Alteração        : 
-- 
--
------------------------------------------------------------------------------
create procedure pr_consulta_devolucao_produto_vendedor
@cd_cliente_regiao int      = 0,
@cd_vendedor       int      = 0,
@dt_inicial        datetime = '',
@dt_final          datetime = ''

as

--select * from vw_venda_bi

select
  vw.cd_vendedor,
  max(v.nm_fantasia_vendedor)                                    as nm_fantasia_vendedor,
  max(v.sg_vendedor)                                             as sg_vendedor,
  vw.cd_produto,
  max(vw.cd_mascara_produto)                                     as Codigo,
  max(vw.nm_fantasia_produto)                                    as Fantasia,
  max(vw.nm_produto_item_nota)                                   as Produto,
  --max(vw.sg_unidade_medida)                                      as Unidade,
  sum( vw.qt_devolucao_item_nota )                               as Quantidade,
  sum( vw.qt_devolucao_item_nota * vw.vl_unitario_item_nota )    as Total,

  case when isnull(max(fcp.ic_avista_forma_condicao),'N')='N'  then 
    sum( vw.qt_devolucao_item_nota * vw.vl_unitario_item_nota )
  else
     0.00
  end                                                            as Total_Prazo,
  case when isnull(max(fcp.ic_avista_forma_condicao),'N')='S' then 
     sum( vw.qt_devolucao_item_nota * vw.vl_unitario_item_nota )
  else
     0.00
  end                                                            as Total_Vista,
  max(nm_cliente_regiao)                                         as Regiao

from
  vw_faturamento_devolucao vw                  with (nolock)
  inner join vendedor v                        with (nolock) on v.cd_vendedor             = vw.cd_vendedor
  inner join produto  p                        with (nolock) on p.cd_produto              = vw.cd_produto
  left outer join condicao_pagamento cp        with (nolock) on cp.cd_condicao_pagamento  = vw.cd_condicao_pagamento
  left outer join forma_condicao_pagamento fcp with (nolock) on fcp.cd_forma_condicao     = cp.cd_forma_condicao
where
  vw.cd_cliente_regiao = case when @cd_cliente_regiao = 0 then vw.cd_cliente_regiao else @cd_cliente_regiao end and
  vw.cd_vendedor       = case when @cd_vendedor = 0       then vw.cd_vendedor       else @cd_vendedor       end and
  vw.dt_restricao_item_nota between @dt_inicial and @dt_final
group by
  vw.cd_vendedor,
  vw.cd_produto

order by
  vw.cd_vendedor

 
--select * from condicao_pagamento
--select * from forma_condicao_pagamento
--select * from vw_faturamento_devolucao


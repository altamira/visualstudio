
-------------------------------------------------------------------------------
--sp_helptext pr_consulta_proposta_projeto_mercado
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Propostas por Projeto
--Data             : 15.07.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_proposta_projeto_mercado
@ic_parametro       int      = 0,
@cd_projeto_mercado int      = 0,
@dt_inicial         datetime = '',
@dt_final           datetime = ''
as

--select * from consulta
--select * from consulta_itens

select
  pm.nm_projeto_mercado,
  cli.nm_fantasia_cliente,
  c.dt_consulta,
  c.cd_consulta,
  ci.cd_item_consulta,
  ci.qt_item_consulta,
  ci.vl_unitario_item_consulta,
  ci.qt_item_consulta * ci.vl_unitario_item_consulta as Total,
  ci.vl_lista_item_consulta,
  ci.pc_desconto_item_consulta,
  ci.nm_fantasia_produto,
  ci.nm_produto_consulta,
  um.sg_unidade_medida,
  ci.dt_entrega_consulta,
  ci.cd_item_cliente,
  ci.cd_ref_item_cliente,
  ci.cd_pedido_compra_consulta,
  ci.cd_desenho_item_consulta,
  ci.cd_rev_des_item_consulta,
  ci.cd_pedido_venda,
  ci.cd_item_pedido_venda,
  vi.nm_fantasia_vendedor    as VendedorInterno,
  ve.nm_fantasia_vendedor    as VendedorExterno,
  cp.nm_condicao_pagamento,
  m.sg_moeda
into
  #ProjetoMercado
from
  Consulta c
  left outer join consulta_itens  ci    on ci.cd_consulta           = c.cd_consulta
  left outer join projeto_mercado pm    on pm.cd_projeto_mercado    = c.cd_projeto_mercado
  left outer join cliente cli           on cli.cd_cliente           = c.cd_cliente
  left outer join vendedor vi           on vi.cd_vendedor           = c.cd_vendedor_interno
  left outer join vendedor ve           on ve.cd_vendedor           = c.cd_vendedor
  left outer join condicao_pagamento cp on cp.cd_condicao_pagamento = c.cd_condicao_pagamento
  left outer join moeda m               on m.cd_moeda               = c.cd_moeda
  left outer join unidade_medida um     on um.cd_unidade_medida     = ci.cd_unidade_medida
where
  isnull(c.cd_projeto_mercado,0) = case when @cd_projeto_mercado=0 then isnull(c.cd_projeto_mercado,0) else @cd_projeto_mercado end and
  c.dt_consulta between @dt_inicial and @dt_final
order by
  1

------------------------------------------------------------------------------
--Resumo
------------------------------------------------------------------------------
if @ic_parametro = 1
begin

  declare @vl_total decimal(25,2)

  select
    @vl_total = sum( isnull(total,0))
  from
    #ProjetoMercado

  select
    nm_projeto_mercado as Projeto,
    count(*)           as Qtd,
    sum(Total)         as Total
  into
    #ResumoProjeto
  from
    #ProjetoMercado
  group by
    nm_projeto_mercado
  
  select
    *,
    ((Total/@vl_total)*100) as Perc
  from
    #ResumoProjeto
     
end

------------------------------------------------------------------------------
--Consulta
------------------------------------------------------------------------------
if @ic_parametro = 2
begin
  select
    *
  from
    #ProjetoMercado
  order by
    1

end



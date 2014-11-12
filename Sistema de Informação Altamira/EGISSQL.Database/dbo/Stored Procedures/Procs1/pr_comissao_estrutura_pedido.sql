

CREATE PROCEDURE pr_comissao_estrutura_pedido
-----------------------------------------------------------------------------------------
--GBS Global Business Solution                 2004
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Johnny Mendes de Souza
--Banco de Dados: <Database>
--Objetivo: Consultar notas de faturamento que não possuem pedido
--Data: 20/01/04
--Atualizado: 
-----------------------------------------------------------------------------------------
@cd_pedido_venda int,
@cd_vendedor int

AS

declare @cd_estrutura_venda int
declare @ic_repassa_comissao char(1)

select
  ev.cd_estrutura_venda,
  ev.cd_mascara_estrutura_vend,
  ev.nm_estrutura_venda,
  ev.ic_repassa_comissao
into
  #Comissao_Estrutura
from
  vendedor v
  inner join estrutura_venda ev
    on.ev.cd_estrutura_venda = v.cd_estrutura_venda
where
  v.cd_vendedor = @cd_vendedor
  and
  ev.ic_recebe_comissao = 'S'

select
  @cd_estrutura_venda = cd_estrutura_venda,
  @ic_repassa_comissao = ic_repassa_comissao
from
  #Comissao_Estrutura

if ( @ic_repassa_comissao = 'S' )
begin

  insert into
    #Comissao_Estrutura
  select
    ev.cd_estrutura_venda,
    ev.cd_mascara_estrutura_vend,
    ev.nm_estrutura_venda,
    ev.ic_repassa_comissao
  from
    estrutura_venda_comissao evc
    inner join
    estrutura_venda ev
      on.ev.cd_estrutura_venda = evc.cd_estrutura_comissao
  
  where
    evc.cd_estrutura_venda = @cd_estrutura_venda

end

select
  ce.cd_estrutura_venda as cd_estrutura_venda_comissao,
  ce.cd_mascara_estrutura_vend,
  ce.nm_estrutura_venda,
  pvev.cd_pedido_venda,
  case when ( isnull(pvev.ic_pagamento_comissao,'S') = 'S' ) then 1 else 0 end as 'int_ic_pagamento_comissao',
  pvev.pc_comissao_estrutura,
  case when ( isnull(pvev.pc_comissao_estrutura,0) > 0 ) then 1 else 0 end as 'int_ic_comissao_especifica'

from
  #Comissao_Estrutura ce

  left outer join
  pedido_venda_estrutura_venda pvev
    on pvev.cd_pedido_venda = @cd_pedido_venda and
       pvev.cd_estrutura_venda = ce.cd_estrutura_venda
order by
  ce.cd_mascara_estrutura_vend

drop table #Comissao_Estrutura

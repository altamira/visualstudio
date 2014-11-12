-------------------------------------------------------------------------------  
--sp_helptext pr_pedido_venda_pendencia_financeira  
-------------------------------------------------------------------------------  
--pr_pedido_venda_pendencia_financeira  
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2008  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Douglas de Paula Lopes  
--Banco de Dados   : Egissql  
--Objetivo         : Consulta das Pendências Financeiras do Pedido de Venda
--                   Geradas automaticamente pela Entrada de Pedido via EDI
--  
--Data             : 19.09.2008  
--Alteração        : 03.12.2008 - Ajustes Diversos - Carlos Fernandes  
------------------------------------------------------------------------------  
create procedure pr_pedido_venda_pendencia_financeira  
@dt_inicial      datetime = '',    
@dt_final        datetime = '',  
@cd_vendedor     int      = 0   

as  

select   
  pv.cd_pedido_venda,  
  tpf.nm_tipo_pendencia,  
  pv.dt_pedido_venda,  
  pv.cd_vendedor,  
  v.nm_fantasia_vendedor,  
  c.nm_fantasia_cliente,  
  pv.vl_total_pedido_venda,  
  
  (select   
     count(*)   
   from   
     pedido_venda_item   with (nolock) 
   where   
     cd_pedido_venda = pv.cd_pedido_venda) as QtdItens,  
  
  (select   
     sum(qt_item_pedido_venda)   
   from   
     pedido_venda_item   with (nolock) 
   where   
     cd_pedido_venda = pv.cd_pedido_venda) as QtdProdutos,  
  
  cic.vl_limite_credito_cliente,  
  cic.vl_saldo_credito_cliente,  
  sp.nm_status_pedido,  
  fp.nm_forma_pagamento,  
  pvp.nm_obs_tipo_pendencia,
  pv.cd_pdcompra_pedido_venda,
  pv.nm_referencia_consulta,
  rtrim(c.nm_endereco_cliente)+'-'+rtrim(c.cd_numero_endereco) as nm_endereco_cliente,
  c.nm_complemento_endereco,
  c.nm_bairro,
  cid.nm_cidade,
  e.sg_estado  

--select * from pedido_venda

into   
  #pedido_venda  
from  
  pedido_venda                               pv  with(nolock)  
  inner join pedido_venda_pendencia          pvp with(nolock) on pvp.cd_pedido_venda   = pv.cd_pedido_venda   
  left outer join cliente                    c   with(nolock) on c.cd_cliente          = pv.cd_cliente  
  left outer join cliente_informacao_credito cic with(nolock) on cic.cd_cliente        = pv.cd_cliente  
  left outer join vendedor                   v   with(nolock) on v.cd_vendedor         = pv.cd_vendedor  
  left outer join forma_pagamento            fp  with(nolock) on fp.cd_forma_pagamento = cic.cd_forma_pagamento   
  left outer join tipo_pendencia_financeira  tpf with(nolock) on tpf.cd_tipo_pendencia = pvp.cd_tipo_pendencia   
  left outer join status_pedido              sp  with(nolock) on sp.cd_status_pedido   = pv.cd_status_pedido  
  left outer join Cidade                    cid  with(nolock) on cid.cd_cidade         = c.cd_cidade
  left outer join Estado                     e   with(nolock) on e.cd_estado           = c.cd_estado                 
where 
  pv.dt_pedido_venda between @dt_inicial and  
                             @dt_final   and
  pv.dt_cancelamento_pedido is null      and  
  pv.cd_status_pedido = 1
   
  
if @cd_vendedor > 0  
  begin  
    select   
      *  
    from  
      #pedido_venda pv  
    where  
      pv.cd_vendedor = @cd_vendedor  
  end   
else  
  select   
    *   
  from  
    #pedido_venda   

------------------------------------------------------------------------------
--Testando a Stored Procedure
------------------------------------------------------------------------------
--exec pr_pedido_venda_pendencia_financeira
------------------------------------------------------------------------------

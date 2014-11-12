
-------------------------------------------------------------------------------
--pr_nota_saida_coleta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Retorno do Reajuste Definitivo, caso tenha sido processado indevidamente 
--                   pelo usuário
--Data             : 21/02/2005
--Atualizado       : 23.06.2005 - Acerto do código do Reajuste de preço
--------------------------------------------------------------------------------------------------
create procedure pr_nota_saida_coleta
@dt_inicial datetime,
@dt_final   datetime
as

select
  t.nm_fantasia           as Transportadora,
  n.cd_coleta_nota_saida  as NumeroColeta,
  n.dt_coleta_nota_saida  as DataColeta,
  co.nm_contato_cliente   as Contato,
  n.cd_nota_saida         as NotaSaida,
  n.dt_nota_saida         as Emissao,
  n.vl_total              as Valor,
  n.dt_saida_nota_saida   as Saida,
  n.dt_entrega_nota_saida as Entrega,
  c.nm_fantasia_cliente   as Cliente,
  op.nm_operacao_fiscal   as Cfop,
n.cd_pedido_venda
from
  Nota_Saida n
  left outer join Transportadora  t  on t.cd_transportadora = n.cd_transportadora
  left outer join Cliente         c  on c.cd_cliente = n.cd_cliente
  left outer join Operacao_Fiscal op on op.cd_operacao_fiscal = n.cd_operacao_fiscal 
  left outer join Pedido_Venda    pv on pv.cd_pedido_venda = n.cd_pedido_venda
  left outer join Cliente_Contato co on pv.cd_contato = co.cd_contato and pv.cd_cliente = co.cd_cliente	
where
  isnull(n.cd_coleta_nota_saida,'')<>'' and n.ic_coleta_nota_saida='S'


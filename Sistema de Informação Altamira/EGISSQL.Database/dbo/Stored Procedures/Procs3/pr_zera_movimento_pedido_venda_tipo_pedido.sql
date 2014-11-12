
--sp_helptext pr_zera_movimento_pedido_venda_tipo_pedido
-------------------------------------------------------------------------------
--pr_zera_movimento_pedido_venda_tipo_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 16.02.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_zera_movimento_pedido_venda_tipo_pedido
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--Montagem da Tabela Temporária

select
  cd_tipo_pedido
into
  #TipoPedido
from
  Tipo_Pedido
where
  isnull(ic_imposto_tipo_pedido,'S')='N'

declare @cd_tipo_pedido int

while exists ( select top 1 cd_tipo_pedido from #TipoPedido )
begin
  select top 1
    @cd_tipo_pedido = isnull(cd_tipo_pedido,0)
  from 
    #TipoPedido

  --Documento_Receber_Pagamento
  delete documento_receber_pagamento 
  from documento_receber_pagamento drp
  inner join documento_receber dr on dr.cd_documento_receber = drp.cd_documento_receber 
  inner join pedido_venda pv      on pv.cd_pedido_venda      = dr.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido



  --Documento_Receber
  --select * from documento_receber

  delete documento_receber
  from documento_receber dr
  inner join pedido_venda pv      on pv.cd_pedido_venda      = dr.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido


  --Movimento de Estoque
  --select * from movimento_estoque
  delete movimento_estoque
  from movimento_estoque m
  inner join pedido_venda pv      on pv.cd_pedido_venda      = m.cd_documento_movimento
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido

  --Processo Produção

  delete processo_producao_composicao
  from processo_producao_composicao c
  inner join processo_producao pp on pp.cd_processo          = c.cd_processo
  inner join pedido_venda pv      on pv.cd_pedido_venda      = pp.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido

  delete processo_producao_Componente
  from processo_producao_componente c
  inner join processo_producao pp on pp.cd_processo          = c.cd_processo
  inner join pedido_venda pv      on pv.cd_pedido_venda      = pp.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido

  delete processo_producao_apontamento
  from processo_producao_apontamento c
  inner join processo_producao pp on pp.cd_processo          = c.cd_processo
  inner join pedido_venda pv      on pv.cd_pedido_venda      = pp.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido

  delete processo_producao
  from processo_producao pp
  inner join pedido_venda pv      on pv.cd_pedido_venda      = pp.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido


  --Prévia de Faturamento
  --select * from previa_faturamento_composicao
  delete previa_faturamento_composicao
  from previa_faturamento_composicao pf
  inner join pedido_venda pv      on pv.cd_pedido_venda      = pf.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido


  --Histórico do Pedido de Venda

  delete from pedido_venda_historico
  from pedido_venda_historico ph
  inner join pedido_venda pv      on pv.cd_pedido_venda      = ph.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido

  --Item do Pedido de Venda

  delete pedido_venda_item
  from pedido_venda_item i
  inner join pedido_venda pv      on pv.cd_pedido_venda      = i.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido

  --Pedido de Venda

  delete pedido_venda
  from pedido_venda pv
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido


  --Nota_Saida
  delete nota_saida
  from nota_saida n
  inner join nota_saida_item i    on i.cd_nota_saida        = n.cd_nota_saida
  inner join pedido_venda pv      on pv.cd_pedido_venda      = i.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido

  --Nota_Saida_Item
  delete nota_saida_item 
  from nota_saida_item i
  inner join pedido_venda pv      on pv.cd_pedido_venda      = i.cd_pedido_venda
  inner join tipo_pedido tp       on tp.cd_tipo_pedido       = pv.cd_tipo_pedido
  where
    @cd_tipo_pedido = tp.cd_tipo_pedido


  --Deleta o Tipo de Pedido

  delete from #TipoPedido where cd_tipo_pedido = @cd_tipo_pedido
 

end




-------------------------------------------------------------------------------
--sp_helptext pr_ajuste_saldo_requisicao_faturamento
-------------------------------------------------------------------------------
--pr_ajuste_saldo_requisicao_faturamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ajuste do Saldo da Requisição de Faturamento
--Data             : 07.08.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_ajuste_saldo_requisicao_faturamento
as


select
  p.cd_produto as cd_produto,
  x.saldo,
  x.custo
into
  #Atualiza_Saldo_Requisicao
from
  migracao.dbo.produto_mudanca_saldo x
  inner join produto p on p.cd_mascara_produto = x.CODIGO

update
  requisicao_faturamento_item
set
  vl_unitario_requisicao_fa = i.custo,
  qt_requisicao_faturamento = i.saldo
from
  requisicao_faturamento_item i
  inner join #Atualiza_Saldo_Requisicao a on a.cd_produto = i.cd_produto
  

--Deleta os Saldos igual a Zero

delete from requisicao_faturamento_item
where
  qt_requisicao_faturamento = 0


--select * from requisicao_faturamento_item


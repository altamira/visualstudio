
-------------------------------------------------------------------------------
--pr_consulta_ordem_servico_status
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Vagner do Amaral
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Consultar OS Classificada por Status
--Data             : 26/07/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_ordem_servico_status
@cd_os varchar(100),
@dt_inicial datetime,
@dt_final datetime

as

if isnull(@cd_os,0) = '0' 
begin
	select
		sos.nm_status_ordem_servico,
		os.cd_ordem_servico,
		os.dt_ordem_servico,
		os.vl_total_ordem_servico,
		osi.nm_fantasia_produto_item,
		c.nm_razao_social_cliente,
		nsi.cd_nota_saida,
		s.nm_servico,
		pv.cd_pedido_venda,
		pv.cd_consulta

	from
		ordem_servico os left outer join
		status_ordem_servico sos on sos.cd_status_ordem_servico = os.cd_status_ordem_servico left outer join
		cliente c on c.cd_cliente = os.cd_cliente left outer join
		nota_saida_item nsi on nsi.cd_os_item_nota_saida = os.cd_ordem_servico left outer join
		pedido_venda pv on pv.cd_pedido_venda = nsi.cd_pedido_venda left outer join
		servico s on s.cd_servico = nsi.cd_servico left outer join
		ordem_servico_item osi on osi.cd_ordem_servico = os.cd_ordem_servico

	where cd_os_item_nota_saida > 0

end
else begin

	select
		sos.nm_status_ordem_servico,
		os.cd_ordem_servico,
		os.dt_ordem_servico,
		os.vl_total_ordem_servico,
		osi.nm_fantasia_produto_item,
		c.nm_razao_social_cliente,
		nsi.cd_nota_saida,
		s.nm_servico,
		pv.cd_pedido_venda,
		pv.cd_consulta

	from
		ordem_servico os left outer join
		status_ordem_servico sos on sos.cd_status_ordem_servico = os.cd_status_ordem_servico left outer join
		cliente c on c.cd_cliente = os.cd_cliente left outer join
		nota_saida_item nsi on nsi.cd_os_item_nota_saida = os.cd_ordem_servico left outer join
		pedido_venda pv on pv.cd_pedido_venda = nsi.cd_pedido_venda left outer join
		servico s on s.cd_servico = nsi.cd_servico left outer join
		ordem_servico_item osi on osi.cd_ordem_servico = os.cd_ordem_servico
	where
		(os.cd_ordem_servico = @cd_os)

end


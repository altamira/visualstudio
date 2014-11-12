
CREATE PROCEDURE pr_comissao_exportacao

--pr_analise_cliente_sem_compra
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : Rafael M. Santiago
--Banco de Dados: EgisSQL
--Objetivo      : Comissão para os Representantes de Exportação
--Data          : 19/10/2004
--Atualizado    : 
---------------------------------------------------

@dt_inicial dateTime,
@dt_final dateTime,
@cd_representante_com_ext Integer = 0
as
SELECT 
rce.nm_fantasia,
ec.cd_pedido_venda,
c.nm_fantasia_cliente,
ec.cd_embarque,
e.dt_embarque, 
m.sg_moeda as nm_moeda,
tpc.nm_tipo_pag_comissao,
tc.nm_termo_comercial,
ec.pc_embaque_comissao,
ec.vl_embarque_comissao,
ec.dt_prevista_comissao,
ec.nm_obs_embarque_comissao

FROM
Embarque_Comissao ec
LEFT OUTER JOIN
Embarque e ON ec.cd_embarque = e.cd_embarque AND
              ec.cd_pedido_venda = e.cd_pedido_venda 
LEFT OUTER JOIN
Representante_Com_Exterior rce ON ec.cd_representante_com_ext = rce.cd_representante_com_ext
LEFT OUTER JOIN 
Pedido_Venda pv ON ec.cd_pedido_venda = pv.cd_pedido_venda
Left OUTER JOIN 
Cliente c ON pv.cd_cliente = c.cd_cliente
Left Outer JOIN 
Moeda m ON e.cd_moeda = m.cd_moeda
LEFT OUTER JOIN
Termo_Comercial tc ON e.cd_termo_comercial = tc.cd_termo_comercial
LEFT OUTER JOIN
Pedido_Venda_Exportacao pve ON ec.cd_pedido_venda = pve.cd_pedido_venda
LEFT OUTER JOIN
Tipo_Pagamento_Comissao tpc ON tpc.cd_tipo_pag_comissao = pve.cd_tipo_pag_comissao
WHERE
e.dt_embarque between @dt_inicial AND @dt_final AND
((@cd_representante_com_ext = 0) OR (ec.cd_representante_com_ext = @cd_representante_com_ext))

/*

exec pr_comissao_exportacao '10/01/2004', '10/31/2004', 0

select * from embarque

*/



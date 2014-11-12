
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
-----------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es)      : Rafael M. Santiago
--               : Carlos Cardoso Fernandes
--Banco de Dados : EGISSQL
--Objetivo       : Consulta de Itinerario por Entrega
--Data           : 12/07/2004
--Atualizado     : 
-----------------------------------------------------------------------------------------

CREATE PROCEDURE pr_consulta_entrega_itinerario


@cd_itinerario int


AS

Select 
				ns.cd_itinerario ,
			  it.nm_itinerario ,				
				ns.dt_saida_nota_saida ,
				ns.dt_nota_saida  ,
				ns.cd_nota_saida ,
				ns.cd_tipo_destinatario ,
        tpd.nm_tipo_destinatario ,
				ns.nm_fantasia_destinatario,
				ns.cd_vendedor ,
        vend.nm_vendedor ,
				ns.nm_entregador_nota_saida ,
				ns.nm_obs_entrega_nota_saida ,
				ns.cd_transportadora,
        transp.nm_transportadora ,
				ns.cd_operacao_fiscal ,
	 			cfop.cd_mascara_operacao,        
				ns.vl_total ,
				ns.nm_cidade_entrega,
				ns.qt_peso_liq_nota_saida,
				ns.qt_peso_bruto_nota_saida
From Nota_Saida ns
		 left outer join Itinerario it
		 on
		 it.cd_itinerario = ns.cd_itinerario
		 left outer join tipo_destinatario tpd
		 on
		 tpd.cd_tipo_destinatario = ns.cd_tipo_destinatario
		 left outer join	vendedor vend
     on
		 vend.cd_vendedor = ns.cd_vendedor
		 left outer join transportadora transp
		 on
		 transp.cd_transportadora = ns.cd_transportadora
		 left outer join operacao_fiscal cfop
     on 
		 cfop.cd_operacao_fiscal = ns.cd_operacao_fiscal
where 
			ns.cd_itinerario = case when @cd_itinerario = 0 then ns.cd_itinerario else @cd_itinerario end 



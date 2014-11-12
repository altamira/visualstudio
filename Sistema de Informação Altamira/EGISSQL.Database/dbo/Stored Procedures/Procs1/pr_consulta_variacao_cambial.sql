
create procedure pr_consulta_variacao_cambial

@dt_base as datetime

as

SELECT     
	   d.nm_fantasia, 
           dr.cd_identificacao, 
           dr.cd_nota_saida, 
           dr.dt_emissao_documento, 
           dr.dt_vencimento_documento, 
           dr.vl_saldo_documento, 
           dr.vl_documento_receber, 
           m.sg_moeda, 
           p.nm_pais, 
           case when IsNull(ns.vl_cambio_nota_saida,0) = 0 then 0
           else ( dr.vl_documento_receber / ns.vl_cambio_nota_saida ) end
           as 'ValorMoeda', 
           ns.dt_cambio_nota_saida, 
           ns.vl_cambio_nota_saida, 
           vm.vl_moeda,
           @dt_base as 'Data_Base',
           case when IsNull(ns.vl_cambio_nota_saida,0) = 0 then 0
           else ( dr.vl_documento_receber / ns.vl_cambio_nota_saida ) * vm.vl_moeda end
           as 'ValorBase',
           case when IsNull(ns.vl_cambio_nota_saida,0) = 0 then 0
           else ( ( dr.vl_documento_receber / ns.vl_cambio_nota_saida ) * vm.vl_moeda ) 
		- dr.vl_documento_receber end
           as 'VariacaoCambial'
       
           
FROM       Documento_Receber dr INNER JOIN
           Nota_Saida ns ON dr.cd_nota_saida = ns.cd_nota_saida INNER JOIN
           Moeda m ON ns.cd_moeda = m.cd_moeda INNER JOIN
           Pais p ON ns.cd_pais = p.cd_pais left outer join
           Valor_Moeda vm ON ns.cd_moeda = vm.cd_moeda left outer join
           EGISADMIN.dbo.Empresa e on e.cd_empresa = dbo.fn_empresa() left outer join
           vw_Destinatario d on d.cd_destinatario = ns.cd_cliente and 
				d.cd_tipo_destinatario = ns.cd_tipo_destinatario left outer join
           Tipo_Mercado tm on tm.cd_tipo_mercado = d.cd_tipo_mercado

where
   ( e.cd_Pais <> ns.cd_pais or IsNUll(tm.ic_end_esp_tipo_mercado,'N') = 'S') and
   (dr.dt_emissao_documento >= @dt_base) and
   (dr.dt_cancelamento_documento is null ) and
   vm.dt_moeda = @dt_base   
     


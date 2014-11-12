
CREATE VIEW vw_escrita_fiscal_brasil_informatica
------------------------------------------------------------------------------------
--vw_escrita_fiscal_brasil_informatica
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes / Diego Borba / Diego Santiago
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Escrita Fiscal para Exportação ao
--                        sistema da Brasil Informática
--Data                  : 12.12.2005
--Atualização           : 
------------------------------------------------------------------------------------
as

--select top 10 * from fornecedor

select
  	'LCT'                   				as IDENTIFICADOR,
	null							as NUM_LANCAMENTO,
	ne.cd_nota_entrada					as NUM_NF,
	null							as NUM_NF_XY,				
	null							as ESPECIE_NF,
	ne.nm_serie_nota_entrada				as SERIE_NF,
	null							as DT_EMISSAO,
	ne.dt_nota_entrada					as DT_ENTRADA,
	ne.cd_operacao_fiscal					as NAT_OPERA,
	null							as SUBST_TRIBUTARIA,
	null							as COD_FOR_CLI,
	null							as VENDA_CONSUMIDOR,
	null 							as CNPJ_FOR_CLI,
	null							as CONTA_DEBITO,
	null							as CONTA_CREDITO,
	null							as C_CUSTO_DEBITO,
	null							as C_CUSTO_CREDITO,
	null							as SETOR_DEBITO,
	null							as SETOR_CREDITO,
	ne.vl_total_nota_entrada				as VL_TOTAL_NF,
	null							as VL_CONTABIL,
	ne.sg_estado						as UF,
	null							as CODIGO_SERVICO,
	null							as VL_MATERIAIS,
	null							as VL_SUB_EMPREITADA,
	null							as ROTINA_CALCULO1,
	ne.vl_bicms_nota_entrada				as BS_ICMS1,
	null							as ALIQ_ICMS1,
	ne.vl_icms_nota_entrada					as VL_ICMS1,
	null							as VL_ISENTA_ICM1,
	null							as VL_OUTRAS_ICM1,
	null							as ROTINA_CALCULO2,
	null							as BS_ICMS2,
	null							as ALIQ_ICMS2,
	null							as VL_ICMS2,
	null							as VL_ISENTA_ICM2,
	null							as VL_OUTRAS_ICM2,
	null							as ROTINA_CALCULO3,
	null							as BS_ICMS3,
	null							as ALIQ_ICMS3,
	null							as VL_ICMS3,
	null							as VL_ISENTA_ICM3,
	null							as VL_OUTRAS_ICM3,
	null							as ROTINA_CALCULO4,
	null							as BS_ICMS4,
	null							as ALIQ_ICMS4,
	null							as VL_ICMS4,
	null							as VL_ISENTA_ICM4,
	null							as VL_OUTRAS_ICM4,
	null							as ROTINA_CALCULO5,
	null							as BS_ICMS5,
	null							as ALIQ_ICMS5,
	null							as VL_ICMS5,
	null							as VL_ISENTA_ICM5,
	null							as VL_OUTRAS_ICM5,
	null							as VL_TOTAL_BS_IPI,
	null							as PERC_IPI,
	ne.vl_ipi_nota_entrada					as VL_IPI,
	null							as VL_ISENTA_IPI,
	null							as VL_OUTRAS_IPI,
	null							as PERC_IR_S_SERVICO,
	null							as ICMS_RETIDO_FONTE,
	null							as OBS_IPI,
	ne.vl_bcinss_nota_entrada				as BS_CALCULO_INSS,
	ne.pc_inss_nota_entrada					as PERC_INSS,
	ne.vl_inss_nota_entrada					as VL_INSS,
	null							as BS_CALC_S_TRIB,
	null							as VL_S_TRIBUTARIA,
	null							as CODIGO_ZFM,
	null							as OBS_NECESSARIAS,
	null							as FLAG_ATUALIZACAO,
	null							as NUM_ESTACAO,
	null							as OBS2,
	null							as OBS3,
	null							as CIF_FOB,
	null							as SIT_NOTA,
	ne.vl_biss_nota_entrada					as BSCISSRET,	
	ne.vl_iss_nota_entrada					as VLRISSRET,
	ne.pc_iss_nota_entrada					as ALQISSRET
from
	Nota_Entrada ne
	left outer join
	Nota_Entrada_Item nei on nei.cd_nota_entrada = ne.cd_nota_entrada
	left outer join
	Nota_Entrada_Item_Registro neir on neir.cd_nota_entrada = ne.cd_nota_entrada


-- select top 20 * from Nota_Saida 

-- select * from Operacao_Fiscal

-- select top 20 * from Nota_Saida_Item_Registro 

-- select top 20 * from Nota_Saida_Item 


 	

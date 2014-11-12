
CREATE VIEW vw_escrita_fiscal_saida_br_informatica
------------------------------------------------------------------------------------
--vw_escrita_fiscal_saida_br_informatica
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes / Diego Borba / Diego Santiago
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Escrita Fiscal para Exportação ao
--                        sistema da Brasil Informática
--Data                  : 12.12.2005
--Atualização           : 14.07.2010 - Ajustes e novos campos - conforme lay-out - Carlos Fernandes
---------------------------------------------------------------------------------------------------
as

--select top 10 * from fornecedor
--select * from nota_saida

select

        ns.dt_nota_saida,

  	'LCT'                   				   as IDENTIFICADOR,
	'00000'							   as NUM_LANCAMENTO,
	ns.cd_nota_saida					   as NUM_NF,
	cast('' as varchar(10))					   as NUM_NF_XY,				
	snf.nm_especie_livro_saida				   as ESPECIE_NF,
	snf.sg_serie_nota_fiscal				   as SERIE_NF,
	ns.dt_nota_saida				   	   as DT_EMISSAO,
	ns.dt_nota_saida					   as DT_ENTRADA,
	cast(replace(ns.cd_mascara_operacao,'.','') as varchar(5)) 
        +'00'                                                      as NAT_OPERA,
	'F'                                                        as SUBST_TRIBUTARIA,
	CAST(' ' AS CHAR(5))+CAST(vw.cd_interface as char(7))	   as COD_FOR_CLI,
        --Tratar a venda a consumidor
	CAST(' ' as CHAR(1)) 				  	   as VENDA_CONSUMIDOR,
    
	ns.cd_cnpj_nota_saida				   	   as CNPJ_FOR_CLI,
	0    	                                                   as CONTA_DEBITO,
	0						  	   as CONTA_CREDITO,
	0                                                          as C_CUSTO_DEBITO,
	0                                                          as C_CUSTO_CREDITO,
	0					 		   as SETOR_DEBITO,
	0                                                          as SETOR_CREDITO,
	ns.vl_total						   as VL_TOTAL_NF,
	ns.vl_produto						   as VL_CONTABIL,
	ns.sg_estado_nota_saida                                    as UF,
	
        --Código CCM --> Caso for prestadora de serviço
        0						  	   as CODIGO_SERVICO,
	isnull(ns.vl_produto,0)				  	   as VL_MATERIAIS,
	0.00 							   as VL_SUB_EMPREITADA,
	'00000'  						   as ROTINA_CALCULO1,
	ns.vl_bc_icms						   as BS_ICMS1,

        --select * from nota_saida_item

	isnull(( select top 1 nsi.pc_icms
                 from
                   nota_saida_item nsi with (nolock)
                 where
                   nsi.cd_nota_saida = ns.cd_nota_saida
        ),0)							as ALIQ_ICMS1,

	ns.vl_icms						as VL_ICMS1,

	isnull(ns.vl_icms_isento,0)				as VL_ISENTA_ICM1,
	isnull(ns.vl_icms_outros,0)				as VL_OUTRAS_ICM1,

	'00000'							as ROTINA_CALCULO2,

	0.00							as BS_ICMS2,
	0.00							as ALIQ_ICMS2,
	0.00							as VL_ICMS2,
	0.00							as VL_ISENTA_ICM2,
	0.00							as VL_OUTRAS_ICM2,

	'00000'							as ROTINA_CALCULO3,

	0.00							as BS_ICMS3,
	0.00							as ALIQ_ICMS3,
	0.00							as VL_ICMS3,
	0.00							as VL_ISENTA_ICM3,
	0.00							as VL_OUTRAS_ICM3,

	'00000'							as ROTINA_CALCULO4,

	0.00							as BS_ICMS4,
	0.00							as ALIQ_ICMS4,
	0.00							as VL_ICMS4,
	0.00							as VL_ISENTA_ICM4,
	0.00							as VL_OUTRAS_ICM4,

	'00000'							as ROTINA_CALCULO5,
	0.00							as BS_ICMS5,
	0.00							as ALIQ_ICMS5,
	0.00							as VL_ICMS5,
	0.00							as VL_ISENTA_ICM5,
	0.00							as VL_OUTRAS_ICM5,
	isnull(ns.vl_bc_ipi,0.00)				as VL_TOTAL_BS_IPI,

	0.00							as PERC_IPI,
	ns.vl_ipi						as VL_IPI,
	ns.vl_ipi_isento					as VL_ISENTA_IPI,
	ns.vl_ipi_outros					as VL_OUTRAS_IPI,
	isnull(ns.pc_irrf_serv_empresa,0)			as PERC_IR_S_SERVICO,
	isnull(ns.vl_irrf_nota_saida,0)				as ICMS_RETIDO_FONTE,
	vl_ipi_obs						as OBS_IPI,
	0.00							as BS_CALCULO_INSS,
	ns.pc_inss_servico					as PERC_INSS,
	ns.vl_inss_nota_saida					as VL_INSS,
	isnull(ns.vl_bc_subst_icms,0)				as BS_CALC_S_TRIB,
 	isnull(ns.vl_icms_subst,0)				as VL_S_TRIBUTARIA,

        case when isnull(ns.ic_zona_franca,'N')='S' then
         --buscar da tabela
         '00000'
        else
         '00000' 
        end                                                     as CODIGO_ZFM,

	cast('' as varchar(40))					as OBS_NECESSARIAS,
	'F'							as FLAG_ATUALIZACAO,
	'001'							as NUM_ESTACAO,
	cast('' as varchar(40))					as OBS2,
	cast('' as varchar(40))					as OBS3,
	'2'							as CIF_FOB,
	'T'							as SIT_NOTA,
	ns.vl_iss						as BSCISSRET,	
	ns.vl_iss_retido					as VLRISSRET,
	0.00							as ALQISSRET,

      
        ns.vl_frete                                             as VALOR_FRETE,
        ns.vl_seguro                                            as VALOR_SEGURO,
        ns.vl_desp_acess                                        as VALOR_DESPESA,
        ns.vl_desconto_nota_saida                               as VALOR_DESCONTO,


        --select * from tipo_pessoa
 
        case when vw.cd_tipo_pessoa = 2 then
    	  CAST(' ' AS CHAR(5))+CAST(isnull(vw.cd_interface,'') as char(7))	    
        else
         cast('' as varchar(10))
        end                                                     as CLIPF_COD,


        case when vw.cd_tipo_pessoa = 2 then
          ns.cd_cnpj_nota_saida
        else
          cast('' as varchar(14))        
        end                                                     as CLIPF_CPF
 
        

from
  nota_Saida ns                         with (nolock) 
  left outer join serie_nota_fiscal snf with (nolock)           on snf.cd_serie_nota_fiscal = ns.cd_serie_nota
  left outer join vw_destinatario   vw  with (nolock)           on vw.cd_tipo_destinatario  = ns.cd_tipo_destinatario and
                                                                   vw.cd_destinatario       = ns.cd_cliente
  
--select * from serie_nota_fiscal
--select * from vw_destinatario



-- select top 20 * from Nota_Saida 

-- select * from Operacao_Fiscal

-- select top 20 * from Nota_Saida_Item_Registro 

-- select top 20 * from Nota_Saida_Item 


 	

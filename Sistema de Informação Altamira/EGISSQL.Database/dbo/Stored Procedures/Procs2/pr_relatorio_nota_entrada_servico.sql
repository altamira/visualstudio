
--pr_relatorio_nota_entrada_servico
---------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Rafael M. Santiago
--Banco de Dados	: EGISSQL
--Objetivo		: Relatório de Notas Fiscais de Entrada de serviço
--Data			: 12/09/03
--Alteração		: 24/10/03 - Modificação no Filtro p/ CFOP - ELIAS
--              01/07/04 - Ordenado por Data de Recebimento - ELIAS
--Desc. Alteração	: <Descrição da Alteração>
---------------------------------------------------



CREATE PROCEDURE pr_relatorio_nota_entrada_servico
@ic_comercial char(1),
@dt_inicial datetime,
@dt_final   datetime

AS


SELECT
	ne.cd_nota_entrada,
	f.nm_fantasia_fornecedor,
	ne.dt_nota_entrada,
	ne.dt_receb_nota_entrada,
	isnull(nr.cd_rem,ne.cd_rem)                as cd_rem,
	isnull(ne.vl_total_nota_entrada,0) as vl_total_nota_entrada,
	isnull(ne.vl_irrf_nota_entrada,0)  as vl_irrf_nota_entrada,
	isnull(ne.vl_inss_nota_entrada,0)  as vl_inss_nota_entrada,
        isnull(ne.vl_pis_nota_entrada,0)   as vl_pis_nota_entrada,
        isnull(ne.vl_cofins_nota_entrada,0) as vl_cofins_nota_entrada,
        isnull(ne.vl_csll_nota_entrada,0)   as vl_csll_nota_entrada,
        isnull(ne.vl_iss_nota_entrada,0)    as vl_iss_nota_entrada
		
	
FROM 
	Nota_Entrada ne

        left outer join 
        Nota_Entrada_Registro nr on ne.cd_nota_entrada      = nr.cd_nota_entrada and
                                    ne.cd_fornecedor        = nr.cd_fornecedor   and
                                    ne.cd_operacao_fiscal   = nr.cd_operacao_fiscal and
                                    ne.cd_serie_nota_fiscal = nr.cd_serie_nota_fiscal 
	LEFT OUTER JOIN
	Fornecedor f
	ON
	ne.cd_fornecedor = f.cd_fornecedor
	LEFT OUTER JOIN
	Operacao_Fiscal opf
	ON
	ne.cd_operacao_fiscal = opf.cd_operacao_fiscal
WHERE 
	opf.ic_servico_operacao = 'S' AND
	opf.ic_comercial_operacao = @ic_comercial AND
	ne.dt_receb_nota_entrada between @dt_inicial and @dt_final
order by
  ne.dt_receb_nota_entrada  


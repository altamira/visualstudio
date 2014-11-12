
CREATE PROCEDURE pr_relatorio_operacao_interestadual
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)     : 
--Banco de Dados: EgisSQL
--Objetivo      : Relatório de Operações Interestaduais
--Data          : 


-- NÃO USAR ESTA PROCEDURE - USAR A PR_OPERACAO_INTERESTADUAL
-- Eduardo - 17/07/2003

---------------------------------------------------

@sg_estado   char(2),
@dt_inicial  datetime,
@dt_final    datetime  

as

 select
   ns.sg_estado_nota_saida        as 'Estado',
   ns.cd_nota_saida               as 'NotaSaida',
   'Un.'                          as 'Serie',
   ns.dt_nota_saida               as 'Emissao',
   ns.nm_razao_social_cliente     as 'RazaoSocial',
	 ns.nm_endereco_nota_saida			as 'Endereco',
	 ns.nm_cidade_nota_saida				as 'Cidade',
   ns.cd_numero_end_nota_saida		as 'NumeroEnd',
   ns.cd_cep_nota_saida						as 'CEP',
   ns.cd_cnpj_nota_saida					as 'CGC',
	 ns.cd_inscest_nota_saida       as 'IE',
	 nsr.vl_contabil_nota_saida     as 'ValorContabil',
   nsr.vl_base_ipi_nota_saida     as 'BaseCalculoIPI',
   nsr.vl_ipi_nota_saida          as 'IPI',
   nsr.vl_ipi_isento_nota_saida   as 'IsentasIPI',
   nsr.vl_base_ipi_nota_saida     as 'BaseCalculoICMS',
   nsr.vl_icms_nota_saida         as 'ICMS'
   
  
 from
   Nota_Saida ns, 
   Nota_Saida_Registro nsr

 where
   ((ns.sg_estado_nota_saida = @sg_estado) or (@sg_estado = ''))   and
   ns.dt_nota_saida between @dt_inicial and @dt_final              and
   ns.dt_cancel_nota_saida is null                                 and
   ns.cd_nota_saida = nsr.cd_nota_saida


order by 
  1,2


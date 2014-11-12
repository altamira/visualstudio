

CREATE PROCEDURE pr_consulta_fornecedor_classificacao
---------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		    : Rodolpho
--Banco de Dados	: EGISSQL
--Objetivo		    : Consultar Classificação do Fornecedor 
--Data			    : 04/08/2004 
---------------------------------------------------
@ic_parametro         int,
@cd_classif_For integer

AS

-------------------------------------------------------------------------------  
if @ic_parametro = 1    -- Consulta de Fornededores por Classificação (Traz na consulta uma Classificação Especifica )
-------------------------------------------------------------------------------  
begin


	Select  
		fornec.cd_classif_fornecedor ,
		fornec.cd_fornecedor ,
		class.nm_classif_fornecedor,
		fornec.nm_fantasia_fornecedor ,
		fornec.dt_iso_fornecedor,
		fornec.dt_valid_iso_fornecedor,
		fornec.dt_vcto_avaliacao_fornec,
		'Dias' = datediff (dd,getdate(), fornec.dt_vcto_avaliacao_fornec),
		fornec.cd_ddd ,
		fornec.cd_telefone,
		fornec.cd_estado,
		fornec.cd_cidade
	from 	fornecedor fornec ,
		classificacao_fornecedor class
	where	fornec.cd_classif_fornecedor = class.cd_classif_fornecedor
	and 	class.cd_classif_fornecedor = @cd_classif_For
end 


-------------------------------------------------------------------------------  
if @ic_parametro = 2    -- Consulta de Fornededores por Classificação (Retorna para a consulta todos os Fornecedores com suas devidas Classificação )
-------------------------------------------------------------------------------  
begin


	Select  
		fornec.cd_classif_fornecedor ,
		fornec.cd_fornecedor ,
		class.nm_classif_fornecedor,
		fornec.nm_fantasia_fornecedor ,
		fornec.dt_iso_fornecedor,
		fornec.dt_valid_iso_fornecedor,
		fornec.dt_vcto_avaliacao_fornec,
		'Dias' = datediff (dd,getdate(), fornec.dt_vcto_avaliacao_fornec),
		fornec.cd_ddd ,
		fornec.cd_telefone,
		fornec.cd_estado,
		fornec.cd_cidade
	from 	fornecedor fornec ,
		classificacao_fornecedor class
	where	fornec.cd_classif_fornecedor = class.cd_classif_fornecedor
end 




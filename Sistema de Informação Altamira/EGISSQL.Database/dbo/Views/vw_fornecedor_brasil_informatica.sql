
CREATE VIEW vw_fornecedor_brasil_informatica
------------------------------------------------------------------------------------
--vw_fornecedor_brasil_informatica
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes / Diego Borba / Diego Santiago
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Fornecedores para Exportação ao
--                        sistema da Brasil Informática
--Data                  : 12.12.2005
--Atualização           : 
------------------------------------------------------------------------------------
as

--select top 10 * from fornecedor

select
  	forn.cd_fornecedor            				as CODFOR,
	null							as CDAFOR,
	forn.nm_razao_social					as NOMFOR,
	forn.nm_endereco_fornecedor				as ENDFOR,
	forn.nm_bairro						as BAIFOR,
	cid.nm_cidade						as MUNFOR,
	est.sg_estado						as ESTFOR,
	forn.cd_cep						as CEPFOR,
	forn.cd_telefone					as TELFOR,
	dbo.fn_formata_cnpj(forn.cd_cnpj_fornecedor)		as CGCFOR,
	forn.cd_inscEstadual					as INSFOR,
	null							as ENDPAG,
	null							as MUNPAG,
	null							as ESTPAG,
	null							as ENDRET,
	null							as PRVENT,
	null							as CONTAT,
	null							as CODCON,
	null							as NOMCON,
	null							as ANASINFOR,
	null							as FAXFOR,
	null							as TELEXFOR,
	null							as TEL2FOR,
	null							as SINFOR,
	forn.dt_cadastro_fornecedor				as DCADFOR
	
from
  	Fornecedor forn
	left outer join
	Cidade	   cid on forn.cd_cidade = cid.cd_cidade
	left outer join
	Estado	   est on forn.cd_estado = est.cd_estado
/*select
  	'F'                   				as TIPOXX,
  	forn.cd_fornecedor         			as CODIGO,
  	0                     				as DIGITO,
  	'F'                   				as TIPO2X,
  	forn.cd_cnpj_fornecedor    			as CGCXXX,
	'F'	 					as TIPO3X,
	forn.nm_fantasia_fornecedor			as ACESSX,
	substring(rtrim(ltrim(forn.nm_razao_social)),1,40)	as EMPR1X,
	substring(rtrim(ltrim(forn.nm_razao_social)),41,40)	as EMPR2X,
	forn.cd_inscEstadual				as INSCRX,
	forn.nm_endereco_fornecedor			as END1XX,
	forn.nm_complemento_endereco 			as END2XX,
	cid.nm_cidade					as CIDXXX,
	est.nm_estado					as ESTXXX,
  	substring(replace(forn.cd_cep,'-',''),1,5)	as CEP1XX,
	substring(replace(forn.cd_cep,'-',''),6,3)	as CEP2XX,
	forn.cd_telefone				as TELE1X,
	null						as TELE2X,
	null						as TELE3X,
	null						as CONTAX,
        null						as FAXXXX,
        null						as TLXXXX,
        null						as NVCTXX,
        null						as DENFXX,
        null						as DIAS1X,
        null						as DIAS2X,
        null						as DIAS3X,
        null						as DIAS4X,
        null						as DIAS5X,
        null						as DIAS6X,
        null						as TAXAFN,
        null						as TAXAFM,
        null						as OBSXXX,
        null						as FAMIXX,
        null						as IQSXXX,
        'N'						as APLICX,
        null						as PRZSER,
        null						as APROPX,
        forn.cd_tipo_pessoa				as PESSOA	
	
from
  	Fornecedor forn
	left outer join
	Cidade	   cid on forn.cd_cidade = cid.cd_cidade
	left outer join
	Estado	   est on forn.cd_estado = est.cd_estado
*/
--select * from tipo_pessoa


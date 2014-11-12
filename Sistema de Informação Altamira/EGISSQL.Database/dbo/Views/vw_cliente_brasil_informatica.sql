
CREATE VIEW vw_cliente_brasil_informatica
------------------------------------------------------------------------------------
--vw_cliente_brasil_informatica
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes / Diego Borba / Diego Santiago
--Banco de Dados	: EGISSQL 
--Objetivo	        : Montagem do Arquivo Texto de Clientes para Exportação ao
--                        sistema da Brasil Informática
--Data                  : 12.12.2005
--Atualização           : 
------------------------------------------------------------------------------------
as

--select top 1 * from Cliente
select 
	cli.cd_cliente		      					as CODCLI,
	null								as CDACLI,
	cli.nm_razao_social_cliente					as NOMCLI,
	cli.nm_fantasia_cliente						as NOMACE,
	cli.nm_endereco_cliente						as ENDCLI,
	cli.nm_bairro							as BAICLI,
	cid.nm_cidade							as MUNCLI,
	est.nm_estado							as ESTCLI,
	replace(cli.cd_cep,'-','')					as CEPCLI,
	cli.cd_telefone							as TELCLI,
	dbo.fn_formata_cnpj(cli.cd_cnpj_cliente)			as CGCCLI,
	cli.cd_inscestadual						as INSCLI,
	null								as CCMCLI,
	null								as ENDCOB,
	null								as BAICOB,
	null								as MUNCOB,
	null								as ESTCOB,
	null								as CEPCOB,
	null								as ENDENT,
	null								as PRVENT,
	null								as FAX24H,
	null								as CONTAT,
	null								as CARCLI,
	null								as CODQUA,
	'N'								as RETEN,
	null								as LIMRETEN,
	'N'								as NF,
	cli.nm_email_cliente						as EMAIL,
	null								as SENBRA,
	null								as SENDELTA,
	null								as SEED,
	null								as INDICA,
	null								as CODVEN,
	null								as ANASINCLI,
	null								as FAXCLI,
	null								as TELEXCLI,
	null								as TEL2CLI,
	null								as SINCLI,
	cli.dt_cadastro_cliente						as DCADCLI									
from
	Cliente cli 
	left outer join 
	Cidade  cid on cli.cd_cidade = cid.cd_cidade 
	left outer join
	Estado  est on cli.cd_estado = est.cd_estado 


/*select 
	'C'                           					as TIPOXX,
	cli.cd_cliente		      					as CODIGO,
	0                             					as DIGITO,
    	'C'			      					as TIPO2X,
	cli.cd_cnpj_cliente               				as CGCXXX,
 	'C'			      					as TIPO3X,
	cast(rtrim(ltrim(cli.nm_fantasia_cliente)) as varchar (30))    	as ACESSX,
	substring(cast(rtrim(ltrim(cli.nm_razao_social_cliente)) as varchar (40)),1,40) as EMPR1X,
	substring(cast(rtrim(ltrim(cli.nm_razao_social_cliente)) as varchar (40)),41,40) as EMPR2X,
	cast(rtrim(ltrim(cli.cd_inscestadual)) as varchar (18))  	as INSCRX,
	cast(rtrim(ltrim(cli.nm_endereco_cliente)) as varchar (40))	as END1XX,
	cast(rtrim(ltrim(cli.nm_complemento_endereco)) as varchar (20))	as END2XX,
	cast(rtrim(ltrim(cli.nm_bairro)) as varchar (20))		as BAIXXX,
	cast(rtrim(ltrim(cid.nm_cidade)) as varchar (20))		as CIDXXX,
	cast(rtrim(ltrim(est.nm_estado)) as varchar (20))		as ESTXXX,
	substring(replace(cli.cd_cep,'-',''),1,5)			as CEP1XX,
	substring(replace(cli.cd_cep,'-',''),6,3)			as CEP2XX,
	null								as REGXXX,
	null								as END1CX,
	null								as END2CX,
	null								as CIDCXX,
	null 								as ESTCXX,
	null 								as CEP1CX,
	null 								as CEP2CX,
	null								as CGCCXX,
	null 								as INSCRC,
	null 								as END1EX,
	null 								as END2EX,
	null								as CIDEXX,
	null 								as ESTEXX,
	null 								as CEP1EX,
	null 								as CEP2EX,
	null 								as CGCEXX,
	null 								as INSCRE,
	null 								as TELE1X,	
	null 								as TELE2X,
	null								as TELE3X,
	null 								as CONTAX,
	null								as FAXXXX,
	null 								as TLXXXX,
	null 								as VENDXX,
	null 								as DTCADX,
	null 								as CONCXX,
	null 								as OBSXXX,
	null 								as LIMCXX,
	null 								as MOEDAX,
	null 								as TRANSP,
	null 								as VEND2X,
	null 								as VEND3X,
	null 								as SITXXX,
	null 								as FILGER,
	null 								as VPPXXX,
	null 								as PERCOM,
	null 								as NVCTXX,
	null 								as DENFXX,
	null 								as DIAS1X,
	null 								as DIAS2X,
	null 								as DIAS3X,
	null 								as DIAS4X,
	null 								as DIAS5X,
	null 								as DIAS6X,
	null 								as SEGXXX,	
	null								as TERXXX,
	null 								as QUAXXX,
	null 								as QUIXXX,
	null 								as SEXXXX,
	null 								as CCMXXX,
	null 								as OBSNF1,
	null 								as OBSNF2,
	null 								as OBSNF3,
	null 								as TRANS2,
	null 								as PESSOA,
	null 								as PERCO2,
	null								as PERCO3,
	null 								as ACTRAN,
	null 								as BOLETO,
	null 								as BANCOB

from

	Cliente cli 
	left outer join 
	Cidade  cid on cli.cd_cidade = cid.cd_cidade 
	left outer join
	Estado  est on cli.cd_estado = est.cd_estado 
*/	

	
 

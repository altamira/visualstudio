

CREATE PROCEDURE pr_emitir_contrato_locacao
--------------------------------------------------------------------------------------------------------------- 
--GBS - Global Business Solution              2003
--Stored Procedure : Microsoft SQL Server       2000 
--Autor(es) : Daniel C. Neto 
--Banco de Dados : EGISSQL 
--Objetivo : Selecionar dados para a emissão do Contrato de Locação
--Data :       29/07/2003
--Alterações : 08/01/2004 - Inclusão do campo 'cd_cliente' para acerto do Formulário de Impressão
----------------------------------------------------------------------------------------------------------------- 
-- Obs : Colocado campo ultimo por causa de um defeito do relatório não conseguir ajustar
-- o primeiro campo. Sendo assim, o primeiro campo a sair será o de nome ultimo e assim
-- posso configurar o campo NContrato na tabela de Formulario_Layout
------------------------------------------------------------------------------------------------------------------

@cd_nota_saida int

AS 

SELECT     
           ns.cd_cliente,
           cast(ns.cd_nota_saida as varchar(20)) + '/' + cast(Year(GetDate()) as varchar(20)) as 'NContrato', 
           cli.cd_cnpj,
           cli.nm_razao_social,                
           '' as 'ultimo',
           cli.nm_endereco + ' ' + 
	   IsNull(cli.cd_numero_endereco,'') + 
           IsNull('-' + cli.nm_complemento_endereco,'') as 'nm_endereco_cliente1', 
           dbo.fn_formata_mascara('99999-999', cli.cd_cep) + '-' + IsNull(cid.nm_cidade,'') + '-' + IsNull(es.sg_estado,'')
           as 'nm_endereco_cliente2',
           pf.nm_cilindros as 'Cilindros',
           ns.cd_nota_saida,
           ns.dt_nota_saida,
           snf.sg_serie_nota_fiscal,
           GetDate() as 'Data',
           pf.qt_diaria_cilindro_empres          

FROM       Nota_Saida ns left outer join
           vw_Destinatario cli on cli.cd_destinatario = ns.cd_cliente and 
				  cli.cd_tipo_destinatario = ns.cd_tipo_destinatario left outer join
           Cidade cid          on cid.cd_cidade = cli.cd_cidade and 
                                  cid.cd_estado = cli.cd_estado and
                                  cid.cd_pais   = cli.cd_pais left outer join
           Estado es           ON cli.cd_pais = es.cd_pais       and
                                  cli.cd_estado = es.cd_estado   LEFT OUTER JOIN
           Serie_Nota_Fiscal snf on snf.cd_serie_nota_fiscal = ns.cd_serie_nota left outer join
           Parametro_Faturamento pf on pf.cd_empresa = dbo.fn_empresa()
WHERE
  ns.cd_nota_saida = @cd_nota_saida


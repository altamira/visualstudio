
-------------------------------------------------------------------------------
--pr_gera_cadastro_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio
--Banco de Dados   : Egissql
--Objetivo         : Gera o Cadastro do cliente, a partir do cadastro do Fornecedor
--Data             : 18.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_cadastro_cliente
	@cd_fornecedor int = 0,
   @cd_usuario    int = 0
as

Declare @cd_cliente int

-- Pega o Código do Cliente.
exec EgisADMIN.dbo.sp_PegaCodigo 'Egissql.dbo.cliente', 'cd_cliente', @codigo = @cd_cliente output


-- Inicia Transação
Begin transaction


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cria o Registro na Tabela Cliente
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Insert Into Cliente (cd_cliente,nm_fantasia_cliente, nm_razao_social_cliente, nm_razao_social_cliente_c, nm_dominio_cliente, nm_email_cliente,
								ic_destinacao_cliente, cd_suframa_cliente, cd_reparticao_origem, dt_cadastro_cliente, ds_cliente, cd_tipo_pessoa,
								cd_ramo_atividade, cd_transportadora, cd_usuario, dt_usuario, cd_tipo_mercado, cd_idioma, cd_identifica_cep, cd_cnpj_cliente,
								cd_inscMunicipal, cd_inscestadual, cd_cep, nm_endereco_cliente, cd_numero_endereco, nm_complemento_endereco, nm_bairro, cd_pais,
								cd_cidade, cd_estado, cd_ddd, cd_fax, cd_telefone, ic_wapnet_cliente, cd_abablz_cliente, cd_swift_cliente, cd_condicao_pagamento,
								cd_destinacao_produto, ic_inss_cliente, nm_ponto_ref_cliente, cd_conta, ic_isento_insc_cliente, cd_pag_guia_cliente, ic_inscestadual_valida,
								ds_cliente_endereco, dt_exportacao_registro, cd_moeda, cd_porto, cd_idioma_produto_exp, cd_barra_cliente, ic_fmea_cliente, ic_analise_cliente)

					  Select @cd_cliente, nm_fantasia_fornecedor, nm_razao_social, nm_razao_social_comple, nm_dominio_fornecedor, nm_email_fornecedor,
							   ic_destinacao_fornecedor, cd_suframa_fornecedor, cd_reparticao_origem, dt_cadastro_fornecedor, ds_fornecedor, cd_tipo_pessoa,
								cd_ramo_atividade, cd_transportadora, @cd_usuario, getdate(), cd_tipo_mercado, cd_idioma, cd_identifica_cep, cd_cnpj_fornecedor,
							   cd_inscMunicipal, cd_inscestadual, cd_cep, nm_endereco_fornecedor, cd_numero_endereco, nm_complemento_endereco, nm_bairro, cd_pais,
								cd_cidade, cd_estado,cd_ddd, cd_fax, cd_telefone, ic_wapnet_fornecedor, cd_abablz_fornecedor, cd_swift_fornecedor, cd_condicao_pagamento,
								cd_destinacao_produto, ic_inss_fornecedor, nm_ponto_ref_fornecedor, cd_conta, ic_isento_insc_fornecedor, cd_pag_guia_fornecedor, ic_inscestadual_valida,
								ds_endereco_fornecedor, dt_exportacao_registro, cd_moeda, cd_porto, cd_idioma_produto, cd_barra_fornecedor, ic_fmea_fornecedor, ic_analise_fornecedor
						from Fornecedor where cd_fornecedor = @cd_fornecedor

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cria o Registro na Tabela Cliente Endereço
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Insert Into Cliente_Endereco (cd_cliente, cd_tipo_endereco, dt_cadastro_endereco, cd_cnpj_cliente, cd_inscestadual,
										cd_inscmunicipal_cliente, cd_cep_cliente, nm_endereco_cliente, cd_numero_endereco, nm_complemento_endereco,
										nm_bairro_cliente, cd_ddd_cliente, cd_telefone_cliente, cd_fax_cliente, cd_identifica_cep, cd_pais,
										cd_estado, cd_cidade, cd_usuario, dt_usuario, nm_ponto_ref_cli_endereco)
							  select @cd_Cliente, cd_tipo_endereco, dt_cadastro_fornecedor, cd_cnpj_fornecedor, cd_inscestadual_fornecedo,
         							cd_inscmunicipal_forneced, cd_cep_fornecedor, nm_endereco_fornecedor, cd_numero_endereco, nm_complemento_endereco,
										nm_bairro_fornecedor, cd_ddd_fornecedor, cd_telefone_fornecedor, cd_fax_fornecedor, cd_identifica_cep, cd_pais,
										cd_estado, cd_cidade, @cd_usuario, getdate(), nm_ponto_ref_forn_ender 
										from Fornecedor_Endereco  where cd_fornecedor = @cd_fornecedor

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cria o Registro na Tabela Cliente Perfil
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Insert Into Cliente_Perfil(cd_cliente, ds_perfil_cliente, cd_usuario,dt_usuario)
				       Select @cd_cliente,ds_perfil_fornecedor, @cd_usuario, getdate()
						 		  From Fornecedor_Perfil where cd_fornecedor = @cd_fornecedor

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cria o Registro na Tabela Cliente Contato
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Insert Into Cliente_Contato(cd_cliente, cd_contato, nm_contato_cliente, nm_fantasia_contato, cd_ddd_contato_cliente, cd_telefone_contato,
									 cd_fax_contato, cd_celular, cd_ramal, cd_email_contato_cliente, ds_observacao_contato, cd_tipo_endereco,
 									 cd_cargo, cd_usuario, dt_usuario, dt_nascimento, ic_status_contato,   
									 cd_departamento, cd_tratamento_pessoa, cd_nivel_decisao, dt_status_contato, cd_ddd_celular)
						   Select @cd_cliente, cd_contato_fornecedor, nm_contato_fornecedor, nm_fantasia_contato_forne, cd_ddd_contato_fornecedor, cd_telefone_contato_forne,
									 cd_fax_contato_fornecedor, cd_celular_contato_fornec, cd_ramal_contato_forneced, cd_email_contato_forneced, ds_observacao_contato_for, cd_tipo_endereco,
					     	       cd_cargo, @cd_usuario, getdate(), dt_nascimento_contato, ic_status_contato, 
									 cd_departamento, cd_tratamento,cd_nivel_decisao, dt_status_contato, cd_ddd_celular
									From Fornecedor_Contato where cd_fornecedor = @cd_fornecedor

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cria o Registro na Tabela Cliente Logotipo
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
insert Into Cliente_Logotipo(cd_cliente, nm_logotipo_cliente, cd_usuario, dt_usuario)
                      Select @cd_cliente, nm_fornecedor_logotipo, @cd_usuario,getDate()
							 From Fornecedor_Logotipo where cd_fornecedor = @cd_fornecedor	 			


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RETORNO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if @@ERROR = 0 
		Commit transaction
   else
	begin
		  Rollback Transaction
		  set @cd_cliente = 0
	end

Select @cd_cliente as cd_cliente



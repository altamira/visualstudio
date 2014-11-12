
-------------------------------------------------------------------------------
--pr_gera_cadastro_transportadora
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio
--Banco de Dados   : Egissql
--Objetivo         : Gera o Cadastro do cliente, a partir do cadastro da Transportadora
--Data             : 18.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_cadastro_transportadora
	@cd_fornecedor int = 0,
   @cd_usuario    int = 0
as

Declare @cd_transportadora int

-- Pega o Código do Cliente.
exec EgisADMIN.dbo.sp_PegaCodigo 'Egissql.dbo.transportadora', 'cd_transportadora', @codigo = @cd_transportadora output


-- Inicia Transação
   Begin transaction

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cria o Registro na Tabela Transportadora
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Insert into transportadora(cd_transportadora, nm_fantasia, nm_transportadora, nm_dominio,nm_email_transportadora,
                        dt_cadastro, cd_tipo_pessoa, cd_usuario, dt_usuario, cd_tipo_mercado,
								cd_identifica_cep, cd_cnpj_transportadora, cd_insc_estadual, cd_insc_municipal,
								cd_cep, nm_endereco, cd_numero_endereco, nm_bairro, cd_pais,
								cd_cidade, cd_estado,cd_ddd, cd_fax, cd_telefone, ic_wapnet_transportadora,   
								ds_end_transportadora, ic_ativo_transportadora) 
					  Select @cd_transportadora, nm_fantasia_fornecedor, nm_razao_social, nm_dominio_fornecedor, nm_email_fornecedor,
							   GetDate(), cd_tipo_pessoa, @cd_usuario, getdate(), cd_tipo_mercado, 
								cd_identifica_cep, cd_cnpj_fornecedor, cd_inscestadual, cd_inscMunicipal, 
								cd_cep, nm_endereco_fornecedor, cd_numero_endereco,  nm_bairro, cd_pais,
								cd_cidade, cd_estado,cd_ddd, cd_fax, cd_telefone, ic_wapnet_fornecedor,
								ds_endereco_fornecedor, 'S' 
						from Fornecedor where cd_fornecedor = @cd_fornecedor
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cria o Registro na Tabela Transportadora Endereço
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Insert Into Transportadora_Endereco(cd_transportadora, cd_tipo_endereco, cd_cnpj, cd_insc_estadual,
										      cd_insc_municipal, cd_cep, nm_endereco, cd_numero_endereco, nm_complemento_endereco,
												nm_bairro, cd_ddd, cd_telefone, cd_fax, cd_identifica_cep, cd_pais,
												cd_estado, cd_cidade, cd_usuario, dt_usuario)
							  		  select @cd_transportadora, cd_tipo_endereco,  cd_cnpj_fornecedor, cd_inscestadual_fornecedo,
         									cd_inscmunicipal_forneced, cd_cep_fornecedor, nm_endereco_fornecedor, cd_numero_endereco, nm_complemento_endereco,
												nm_bairro_fornecedor, cd_ddd_fornecedor, cd_telefone_fornecedor, cd_fax_fornecedor, cd_identifica_cep, cd_pais,
												cd_estado, cd_cidade, @cd_usuario, getdate() 
										from Fornecedor_Endereco  where cd_fornecedor = @cd_fornecedor
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Cria o Registro na Tabela Transportadora Contato
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Insert Into Transportadora_Contato (cd_transportadora, cd_transportadora_contato, nm_contato, nm_fantasia, cd_ddd_contato, cd_telefone_contato,
									         cd_fax_contato, cd_celular_contato, cd_ramal_contato, nm_email_contato, nm_obs_contato, 
 									 			cd_cargo, cd_usuario, dt_usuario, dt_nascimento_contato,	cd_departamento) 
						           Select @cd_transportadora, cd_contato_fornecedor, nm_contato_fornecedor, nm_fantasia_contato_forne, cd_ddd_contato_fornecedor, cd_telefone_contato_forne,
									 			cd_fax_contato_fornecedor, cd_celular_contato_fornec, cd_ramal_contato_forneced, cd_email_contato_forneced, ds_observacao_contato_for, 
					     	       			cd_cargo, @cd_usuario, getdate(), dt_nascimento_contato, cd_departamento
									  From   Fornecedor_Contato where cd_fornecedor = @cd_fornecedor

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RETORNO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	if @@ERROR = 0 
		Commit transaction
   else
	begin
		  Rollback Transaction
		  set @cd_transportadora = 0
	end

  Select @cd_transportadora as cd_transportadora



create procedure pr_consulta_receita_federal
@cd_receita_federal int, 
@nm_fantasia_receita_fed varchar

as
select  cd_receita_federal
       ,nm_fantasia_receita_fed
       ,cd_identificacao_agencia
       ,ds_receita_federal
       ,nm_contato_receita_fed
       ,nm_email_contato_receita
       ,cd_inscestadual
       ,cd_cnpj
       ,cd_siscomex
       ,nm_site_receita_federal
       ,nm_email_receita_federal
       ,nm_observacao_receita_fed
       ,dt_cadastro_receita_fed
       ,nm_endereco_receita_fed
       ,cd_numero_endereco
       ,nm_complemento_endereco
       ,nm_bairro_receita_federal
       ,cd_pais
       ,cd_estado
       ,cd_cidade
       ,cd_identifica_cep
       ,cd_cep
       ,cd_ddd_receita_federal
       ,cd_fone_receita_federal
       ,cd_fax_receita_federal
 from receita_federal
where 
   case @cd_receita_federal
    when 0 then cd_receita_federal
    else @cd_receita_federal end = cd_receita_federal
   and 
   case @nm_fantasia_receita_fed
    when '' then @nm_fantasia_receita_fed
    else nm_fantasia_receita_fed end like @nm_fantasia_receita_fed + '%'

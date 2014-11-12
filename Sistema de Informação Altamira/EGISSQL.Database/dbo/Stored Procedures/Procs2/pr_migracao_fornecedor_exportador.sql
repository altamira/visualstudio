
create procedure pr_migracao_fornecedor_exportador
-----------------------------------------------------------------
--pr_migracao_fornecedor_exportador
-----------------------------------------------------------------
--Global Business Solution Ltda                              2004
-----------------------------------------------------------------                     
--Stored Procedure       : SQL Server Microsoft 2000
--Autor (es)             : Carlos Cardoso Fernandes         
--Banco Dados            : EGISSQL
--Módulo                 : SEXP
--Objetivo               : Migração dos Fornecedores para o Cadastro de Exportador
--                       : Mellon/Sopar
--Data                   : 29.11.2004
--Alteração              : 28/12/2004  
--                       : Acerto do Cabeçalho - Sérgio Cardoso
-----------------------------------------------------------------------------------

as

--sp_help fornecedor

--apaga todos os registros da tabela exportador

delete from pedido_venda_historico
delete from pedido_venda_parcela
delete from pedido_venda_smo
delete from pedido_venda_item_smo
delete from pedido_venda_item_lote
delete from pedido_venda_item_grade
delete from pedido_venda_item_especial
delete from pedido_venda_item_embalagem
delete from pedido_venda_item
delete from pedido_venda_item_observacao
delete from pedido_venda_item_desconto
delete from pedido_venda_programacao
delete from pedido_venda
delete from pedido_venda_agrupamento
delete from pedido_venda_comissao
delete from pedido_venda_composicao
delete from pedido_venda_cond_pagto
delete from pedido_venda_documento
delete from pedido_venda_item_acessorio
delete from pedido_venda_exportacao
delete from pedido_venda_estrutura_venda

delete from embarque
delete from embarque_item
delete from embarque_parcela
delete from embarque_financeiro
delete from embarque_comissao
delete from embarque_contabil
delete from embarque_despesa

delete from exportador

--Insere os registros do Fornecedor para o Exportador

insert exportador 
(
cd_exportador,
nm_fantasia,
nm_razao_social,
nm_dominio,
dt_cadastro,
ds_prestador_servico,
cd_banco,
cd_agencia_banco,
cd_conta_banco,
cd_tipo_pessoa,
cd_fax,
cd_telefone,
cd_ddd,
cd_pais,
nm_bairro,
nm_complemento_endereco,
cd_numero_endereco,
nm_endereco,
cd_cep,
cd_inscmunicipal,
cd_inscestadual,
cd_cnpj,
cd_identifica_cep,
cd_siscomex,
cd_usuario,
dt_usuario,
cd_cidade,
cd_estado,
nm_contato,
nm_logotipo,
ds_perfil,
ds_exportador,
ic_pad_exportador,
cd_porto,
cd_moeda
 )
select 
 cd_fornecedor, -- cd_exportador
 nm_fantasia_fornecedor, -- nm_fantasia
 nm_razao_social, -- nm_razao_social
 nm_dominio_fornecedor, -- nm_dominio
 dt_cadastro_fornecedor, -- dt_cadastro
 '', -- ds_prestador_servico
 cd_banco,-- cd_banco
 cd_agencia_banco, -- cd_agencia_banco
 cd_conta_banco,-- cd_conta_banco
 cd_tipo_pessoa,-- cd_tipo_pessoa
 cd_fax,-- cd_fax
 cd_telefone,-- cd_telefone
 cd_ddd,-- cd_ddd
 cd_pais, -- cd_pais
 nm_bairro,-- nm_bairro
 nm_complemento_endereco, -- nm_complemento_endereco
 cd_numero_endereco,-- cd_numero_endereco
 nm_endereco_fornecedor,-- nm_endereco
 cd_cep,-- cd_cep
 cd_inscMunicipal,-- cd_inscmunicipal
 cd_inscEstadual,-- cd_inscestadual
 cd_cnpj_fornecedor, -- cd_cnpj
 cd_identifica_cep,-- cd_identifica_cep
 '',-- cd_siscomex
 cd_usuario,-- cd_usuario
 dt_usuario, -- dt_usuario
 cd_cidade,-- cd_cidade
 cd_estado,-- cd_estado
 '',-- nm_contato
 '',-- nm_logotipo
 ds_perfil_fornecedor,-- ds_perfil
 ds_fornecedor,-- ds_exportador
 'N', -- ic_pad_exportador
 cd_porto,-- cd_porto
 cd_moeda-- cd_moeda
from 
 fornecedor


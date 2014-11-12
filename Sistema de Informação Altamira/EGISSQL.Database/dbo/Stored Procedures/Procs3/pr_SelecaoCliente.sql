

/****** Object:  Stored Procedure dbo.pr_SelecaoCliente    Script Date: 13/12/2002 15:08:10 ******/

CREATE  PROCEDURE pr_SelecaoCliente (@cd_tipo_vendedor integer)
as
Select cli.cd_cliente, 
UPPER(cli.nm_fantasia_cliente) nm_fantasia_cliente, 
cv.nm_vendedor, 
ende.cd_ddd_cliente, 
ende.cd_telefone_cliente, 
cli.nm_razao_social_cliente, 
ende.nm_endereco_cliente, 
ende.nm_bairro_cliente, 
ende.nm_Pais, 
ende.nm_estado, 
ende.cd_cep_cliente,
ende.nm_Cidade,
cliInfoCre.vl_limite_credito_cliente,
ende.cd_tipo_endereco
from cliente cli
left join 
(Select top 1 
    clivend.cd_cliente, clivend.cd_vendedor, clivend.cd_cliente_vendedor,
    clivend.cd_usuario, clivend.dt_usuario, clivend.cd_celular, clivend.vl_meta,
    clivend.ic_ativo, clivend.cd_tipo_vendedor, clivend.cd_tipo_pessoa, 
    clivend.cd_cidade, clivend.cd_estado, clivend.cd_pais, clivend.cd_banco, 
    clivend.cd_cep, clivend.cd_conta_corrente, clivend.cd_agencia_banco_vendedor,
    clivend.qt_visita_diaria_vendedor, clivend.nm_contato_vendedor, clivend.pc_comissao_vendedor,
    clivend.pc_aliquota_irpj, clivend.nm_email_particular, clivend.nm_email_vendedor,
    clivend.nm_dominio_vendedor, clivend.cd_insmunicipal_vendedor, clivend.cd_inscestadual_vendedor,
    clivend.cd_cnpj_vendedor, clivend.cd_fax_vendedor, clivend.cd_telefone_vendedor,
    clivend.cd_ddd_vendedor, clivend.nm_bairro_vendedor, clivend.nm_complemento_endereco,
    clivend.cd_numero_endereco, clivend.nm_endereco_vendedor, clivend.sg_vendedor,
    clivend.nm_fantasia_vendedor, clivend.cd_inscmunicipal_vendedor, 
    vend.nm_vendedor 
from cliente_vendedor clivend 
left join vendedor vend
on vend.cd_vendedor = clivend.cd_vendedor 
/* Define que os vendedores filtrados serao somente os do tipo externo*/
and vend.cd_tipo_vendedor = 1 --@cd_tipo_vendedor
)cv
on cv.cd_cliente = cli.cd_cliente
left join 
(Select top 1 cliente_endereco.*, 
pais.nm_pais, 
Estado.nm_estado,
Cidade.nm_Cidade 
from cliente_endereco
left join pais
on pais.cd_pais = cliente_endereco.cd_pais
left join Estado
on Estado.cd_Estado = cliente_endereco.cd_Estado
left join Cidade
on Cidade.cd_Cidade = cliente_endereco.cd_cidade
) ende
on ende.cd_cliente = cli.cd_cliente
left join Cliente_Informacao_Credito cliInfoCre
on cli.cd_cliente = cliInfoCre.cd_cliente





-------------------------------------------------------------------------------
--pr_migracao_bariloche_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Autor
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Clientes
--Data             : 23.06.2008
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_bariloche_cliente
as

--select * from migracao.dbo.clien where fantasia is null
--select cpgto from migracao.dbo.clien GROUP BY CPGTO ORDER BY CPGTO
--select CODIGO,COUNT(*) from migracao.dbo.clien group by CODIGO

--Delta os Registros da Tabela Destino

delete from cliente_contato
delete from cliente


--Montagem da Tabela Temporária

select
 CODIGO        as cd_cliente,
 case when isnull(FANTASIA,'')='' then
   cast(NOME as varchar(15) )
 else
   cast( FANTASIA as varchar(15) )
 end                            as nm_fantasia_cliente,
 cast(NOME as varchar(45))      as nm_razao_social_cliente,
 null as nm_razao_social_cliente_c,
 null as nm_dominio_cliente,
 null as nm_email_cliente,
 null as ic_destinacao_cliente,
 null as cd_suframa_cliente,
 null as cd_reparticao_origem,
 null as pc_desconto_cliente,
 CADASTRO as dt_cadastro_cliente,
 cast( RTRIM(LTRIM(OBS)) + ' ' +RTRIM(LTRIM(FORMACOBR))+ ' '+RTRIM(LTRIM(ALERTA)) as varchar) as  ds_cliente,
 null as cd_conceito_cliente,
 --Verifica o Tipo de Pessoa
 case when len(rtrim(ltrim(cast(replace(replace(replace(cgc,'.',''),'/',''),'-','') as varchar(18)))))<12 
 then
  2
 else
 1 
 end as cd_tipo_pessoa,
 1 as cd_fonte_informacao,
 null as cd_ramo_atividade,
 1    as cd_status_cliente,
 null as cd_transportadora,
 null  as cd_criterio_visita,
 null as cd_tipo_comunicacao,
 1 as cd_tipo_mercado,
 1 as cd_idioma,
 null as cd_cliente_filial,
 null as cd_identifica_cep,
--cd_cnpj_cliente,
  cast(replace(replace(replace(cgc,'.',''),'/',''),'-','') as varchar(18)) as cd_cnpj_cliente,
null as cd_inscMunicipal,
 cast(IE as varchar(18)) as cd_inscestadual,
 cast(replace( CEP,'-','') as varchar(8)) as cd_cep,
 cast(ENDERECO as varchar(60)) as nm_endereco_cliente,
null as cd_numero_endereco,
null as nm_complemento_endereco,
cast(BAIRRO as varchar(25)) as nm_bairro,
null as cd_cidade,
-- cd_cidade = ( select top 1 cid.cd_cidade from Cidade cid inner join Estado e on e.sg_estado = ESTADO and
--                                                                                 cid.cd_estado = e.cd_cidade 
--               where cid.nm_cidade = CIDADE ) ,
cd_estado = (select top 1 cd_estado from Estado where sg_estado = ESTADO ),
cd_pais = 1 ,
null as cd_ddd,
cast(TEL as varchar(15)) AS cd_telefone,
CAST(FAx as varchar(15)) AS cd_fax,
4 as cd_usuario,
getdate() as dt_usuario,
null as cd_cliente_sap,
'S' as ic_contrib_icms_cliente,
NULL AS cd_aplicacao_segmento,
NULL as cd_filial_empresa,
'S'  as ic_liberado_pesq_credito,
null as cd_tipo_tabela_preco,
REGIAO as cd_regiao,
null as cd_centro_custo,
1    as cd_cliente_grupo,
2    as  cd_destinacao_produto,
'N'  as ic_exportador_cliente,
null as nm_especificacao_ramo,
'N'  as ic_wapnet_cliente,
REPRES as cd_vendedor,
NULL cd_vendedor_interno,
--SELECT * from condicao_pagamento
cd_condicao_pagamento = (select top 1 cd_condicao_pagamento from condicao_pagamento where cast(sg_condicao_pagamento as int )= cast(CPGTO AS INT )),
null as cd_cliente_filial_sap,
null as cd_categoria_cliente,
null as ic_wapnet_wap,
null as nm_divisao_area,
'N'  as ic_permite_agrupar_pedido,
null as nm_ponto_ref_cliente,
null as pc_comissao_cliente,
null as ic_isento_insc_cliente,
null as cd_conta,
cast('' as varchar) as ds_cliente_endereco,
'N' as ic_mp66_cliente,
null as nm_cidade_mercado_externo,
null as sg_estado_mercado_externo,
null as nm_pais_mercado_externo,
null as qt_distancia_cliente,
null as ic_rateio_comissao_client,
null as cd_pag_guia_cliente,
null as ic_inscestadual_valida,
null as ic_habilitado_suframa,
null as ic_global_cliente,
null as ic_foco_cliente,
null as ic_oem_cliente,
null as ic_distribuidor_cliente,
null as cd_cliente_global,
null as dt_exportacao_registro,
null as cd_porto,
null as cd_abablz_cliente,
null as cd_swift_cliente,
1 as cd_moeda,
null as cd_barra_cliente,
null as ic_fmea_cliente,
null as cd_fornecedor_cliente,
null as ic_plano_controle_cliente,
null as ic_op_simples_cliente,
null as cd_dispositivo_legal,
null as ic_promocao_cliente,
null as ic_contrato_cliente,
null as cd_idioma_produto_exp,
null as cd_loja,
null as cd_tabela_preco,
null as pc_icms_reducao_cliente,
null as ic_epp_cliente,
null as ic_me_cliente,
null as cd_forma_pagamento,
null as ic_dif_aliq_icms,
null as cd_tratamento_pessoa,
null as cd_tipo_pagamento,
null as cd_cliente_prospeccao,
null as cd_tipo_documento,
null as ic_sub_tributaria_cliente,
'S'  as ic_analise_cliente,
null as cd_portador,
null as cd_ddd_celular_cliente,
null as cd_celular_cliente,
null as dt_aniversario_cliente,
null as ic_inss_cliente,
null as ic_polo_plastico_cliente,
null as ic_dispositivo_polo,
null as ic_valida_ie_cliente,
2    as cd_tipo_pagamento_frete,
null as ic_multi_form_cliente,
null as ic_fat_minimo_cliente,
null as ic_pis_cofins_cliente,
null as pc_pis_cliente,
null as pc_cofins_cliente,
1    as cd_tipo_local_entrega,
null as ic_cpv_cliente,
null as cd_plano_financeiro,
null     as ic_espelho_nota_cliente,
null     as ic_arquivo_nota_cliente,
CODIGO   as cd_interface
 
into
  #Cliente
from
  migracao.dbo.CLIEN  
WHERE
  NOME is not null and
  SEQ = 1

select * from #cliente order by nm_fantasia_cliente

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  cliente
select
  *
from
  #cliente

--Atualização do Cep

update
  cliente
set
  cd_identifica_cep = x.cd_identifica_cep,
  cd_cidade = x.cd_cidade,
  cd_estado = x.cd_estado
from
  cliente c
  inner join cep x on x.cd_cep = c.cd_cep
where
  isnull(c.cd_cidade,0) = 0

--Deleção da Tabela Temporária

drop table #cliente

--Mostra os registros migrados

select * from cliente


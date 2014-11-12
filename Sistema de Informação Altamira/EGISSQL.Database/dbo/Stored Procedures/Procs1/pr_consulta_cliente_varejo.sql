
-------------------------------------------------------------------------------
--pr_consulta_cliente_varejo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_cliente_varejo
   @ic_parametro integer, -- 1 - Fantasia , 2 - Razão Social, 3 - CPF, 4 - RG
   @nm_pesquisa varchar(50)
AS
Select 
   c.cd_cliente,
   c.nm_fantasia_cliente,
   c.nm_razao_social_cliente,
   c.nm_email_cliente,
   c.ic_destinacao_cliente,
   c.dt_cadastro_cliente,
   c.ds_cliente,
   c.cd_tipo_pessoa,
   c.cd_fonte_informacao,
   c.cd_ramo_atividade,   
   c.cd_status_cliente,
   c.cd_identifica_cep,
   c.cd_cnpj_cliente,
   c.cd_inscMunicipal,
   c.cd_cep,
   c.nm_endereco_cliente,
   c.cd_numero_endereco,
   c.nm_complemento_endereco,
   c.nm_bairro,
   c.cd_cidade,
   c.cd_estado,
   c.cd_pais,
   c.cd_ddd,
   c.cd_telefone,
   c.cd_fax,
   c.cd_usuario,
   c.dt_usuario,
   c.cd_vendedor,
   c.cd_vendedor_interno,
   c.cd_condicao_pagamento,
   c.cd_moeda,
   c.cd_tipo_pagamento,
   c.cd_ddd_celular_cliente,
   c.cd_celular_cliente,
   c.dt_aniversario_cliente,
   c.cd_inscEstadual,
   r.nm_ramo_atividade,
   ci.nm_cidade,
   e.sg_estado,
   m.sg_moeda,
   m.nm_moeda,
   tp.nm_tipo_pessoa,
   c.cd_destinacao_produto,
   c.ic_liberado_pesq_credito,
   cp.ds_perfil_cliente,
   c.cd_tipo_mercado,
	c.ic_liberado_pesq_credito,
	c.cd_suframa_cliente,
	isnull(c.ic_habilitado_suframa,'N') as ic_habilitado_suframa,
  (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor) as nm_fantasia_vendedor,
  (Select top 1 nm_fantasia_vendedor from Vendedor where cd_vendedor = c.cd_vendedor_interno) as nm_fantasia_vendedor_interno
From
   Cliente c Left Join 
   Ramo_Atividade r on c.cd_ramo_atividade = r.cd_ramo_atividade Left Join 
   Cidade ci on c.cd_cidade = ci.cd_cidade Left Join 
   Estado e on ci.cd_estado = e.cd_estado Left Join 
   Moeda m on c.cd_moeda = m.cd_moeda Left Join
   Tipo_Pessoa tp on c.cd_tipo_pessoa = tp.cd_tipo_pessoa left join
   Cliente_Perfil cp on c.cd_cliente = cp.cd_cliente
where
   isNull(c.nm_fantasia_cliente,'') like (Case @ic_parametro
                                            when 1 then
                                              @nm_pesquisa + '%'
                                            else
                                              isNull(c.nm_fantasia_cliente,'')
                                            end) and
  
   isNull(c.nm_razao_social_cliente,'') like (Case @ic_parametro
                                               when 2 then
                                                 '%' + @nm_pesquisa + '%'
                                               else
                                                 isNull(c.nm_razao_social_cliente,'')
                                               end) and
  
   isNull(c.cd_cnpj_cliente,'') Like (Case @ic_parametro
                                       when 3 then
                                          @nm_pesquisa + '%'
                                       else
                                          isNull(c.cd_cnpj_cliente,'')
                                       end)  and
   
   isNull(c.cd_inscEstadual,'') like (Case @ic_parametro
                                       when 4 then
                                          @nm_pesquisa + '%'
                                       else
                                          isNull(c.cd_inscEstadual,'')  
                                       end) 
order by 
   c.nm_fantasia_cliente

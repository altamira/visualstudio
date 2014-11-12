
create VIEW vw_destinatario_coordenada
--------------------------------------------------------------------------------
-- vw_destinatario_coordenada
--------------------------------------------------------------------------------
--GBS Global Business Solucion LTDA                                         2004
--------------------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
--                       : Carlos Cardoso Fernandes
--Autor(es)              : Johnny Mendes de Souza
--Banco de Dados         : EGISSQL
--Objetivo               : View para pesquisa de destinatários
--Data                   : 08/01/2003
--Atualizado             : 06/03/2003
--                       : 10/03/2003 - Acréscimo do campo de Insc. Estadual - ELIAS
--                       : 14/03/2003 - Acréscimo de campos de endereço de cobrança - FÁBIO
--                       : 01/05/2003 - Inclusão do DDD, Telefone, Fax - ELIAS
--                       : 16/05/2003 - Inclusão do Complemento da Razão Social - ELIAS
--                       : 29/05/2003 - Inclusão do Tipo de Mercado - ELIAS
--                       : 11/06/2003 - Correção de campos de CEP e BAIRRO do endereço de cobrança
--                       : 04.07.2003 - Inclusão do campo conta para o plano contabil.
--                       : 17/07/2003 - Mudanças na sintaxe visando melhoria na performance - Eduardo
--                       : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                       : 09/08/2005 - Acerto na Busca do Flag de Simples, quando Fornecedor - ELIAS
--                       : 04.09.2005 - Acerto na Busca de Destinatário Suspenso para o Processo - Carlos Fernandes
--                       : 02/03/2007 - Retirando traços do cep - Anderson
--                       : 29.03.2007 - rtrim/ltrim no Endereço porque estava cortando - Carlos Fernandes
--                       : 21.07.2007 - Mostrar automaticamente o Tipo de Destinatário - Carlos Fernandes
--                       : 25.08.2007 - Cidade/Estado/País - Carlos Fernandes
-- 02.08.2008 - Busca das Coordenadas dos Clientes - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------
AS 

select
  1                            as 'cd_tipo_destinatario',
  c.cd_cliente                 as 'cd_destinatario',
  c.nm_fantasia_cliente        as 'nm_fantasia',
  c.nm_razao_social_cliente    as 'nm_razao_social',
  c.nm_razao_social_cliente_c  as 'nm_razao_social_complemento',
  c.cd_tipo_pessoa,
  c.cd_cnpj_cliente            as 'cd_cnpj',
  c.cd_inscestadual 	       as 'cd_inscestadual',
  c.cd_inscmunicipal	       as 'cd_inscmunicipal',
  c.cd_tipo_mercado            as 'cd_tipo_mercado',
  ci.cd_tipo_cobranca          as 'cd_tipo_cobranca',
  ltrim(rtrim(c.nm_endereco_cliente))                    as 'nm_endereco',
  ltrim(rtrim(cast(c.cd_numero_endereco as varchar(6)))) as 'cd_numero_endereco',
  ltrim(rtrim(c.nm_complemento_endereco))                as 'nm_complemento_endereco', 
  ltrim(rtrim(c.nm_bairro))                              as 'nm_bairro',
  REPLACE(c.cd_cep,'-','')     as cd_cep,
  c.cd_cidade,
  c.cd_estado,
  c.cd_pais,
  c.cd_ddd,
  c.cd_telefone,
  c.cd_fax,
  IsNull(ltrim(rtrim(ce.nm_endereco_cliente)),
         ltrim(rtrim(c.nm_endereco_cliente))) as 'nm_endereco_cob',
  IsNull(ltrim(rtrim(cast(ce.cd_numero_endereco as varchar(6)))),
         ltrim(rtrim(cast(c.cd_numero_endereco as varchar(6))))) as 'cd_numero_endereco_cob',
  IsNull(ltrim(rtrim(ce.nm_complemento_endereco)),
         ltrim(rtrim(c.nm_complemento_endereco))) as 'nm_complemento_endereco_cob',
  IsNull(ltrim(rtrim(ce.nm_bairro_cliente)),
         ltrim(rtrim(c.nm_bairro))) as 'nm_bairro_cob',
  IsNull(REPLACE(ce.cd_cep_cliente,'-',''), REPLACE(c.cd_cep,'-','')) as 'cd_cep_cob',
  IsNull(ce.cd_cidade,
         c.cd_cidade) as 'cd_cidade_cob',
  IsNull(ce.cd_estado,
         c.cd_estado) as 'cd_estado_cob',
  IsNull(ce.cd_pais,
         c.cd_pais) as 'cd_pais_cob',

--  IsNull((Select top 1 nm_endereco_cliente     From Cliente_Endereco where cd_tipo_endereco = 3 and cd_cliente = Cliente.cd_cliente), nm_endereco_cliente)     as 'nm_endereco_cob',
--  IsNull((Select top 1 cast(cd_numero_endereco as varchar(6)) From Cliente_Endereco where cd_tipo_endereco = 3 and cd_cliente = Cliente.cd_cliente),cast(cd_numero_endereco as varchar(6))) as 'cd_numero_endereco_cob',
--  IsNull((Select top 1 nm_complemento_endereco From Cliente_Endereco where cd_tipo_endereco = 3 and cd_cliente = Cliente.cd_cliente), nm_complemento_endereco) as 'nm_complemento_endereco_cob',
--  IsNull((Select top 1 nm_bairro_cliente       From Cliente_Endereco where cd_tipo_endereco = 3 and cd_cliente = Cliente.cd_cliente), nm_bairro) as 'nm_bairro_cob',
--  IsNull((Select top 1 cd_cep_cliente          From Cliente_Endereco where cd_tipo_endereco = 3 and cd_cliente = Cliente.cd_cliente), cd_cep)    as 'cd_cep_cob',
--  IsNull((Select top 1 cd_cidade               From Cliente_Endereco where cd_tipo_endereco = 3 and cd_cliente = Cliente.cd_cliente), cd_cidade) as 'cd_cidade_cob',
--  IsNull((Select top 1 cd_estado               From Cliente_Endereco where cd_tipo_endereco = 3 and cd_cliente = Cliente.cd_cliente), cd_estado) as 'cd_estado_cob',
--  IsNull((Select top 1 cd_pais                 From Cliente_Endereco where cd_tipo_endereco = 3 and cd_cliente = Cliente.cd_cliente), cd_pais)   as 'cd_pais_cob',

  c.cd_conta,
  c.cd_condicao_pagamento,
  c.cd_destinacao_produto,
  isnull(c.ic_op_simples_cliente, 'N') as 'ic_op_simples',
  isnull(ci.ic_credito_suspenso,'N')   as 'Suspenso',
  td.nm_tipo_destinatario,
  p.nm_pais,
  e.nm_estado,
  e.sg_estado,
  cid.nm_cidade,
  isnull(c.qt_latitude_cliente,0)  as qt_latitude_cliente,
  isnull(c.qt_longitude_cliente,0) as qt_longitude_cliente

from
  Cliente c                                     with (nolock)
  left outer join Cliente_Endereco ce           with (nolock) on ( ce.cd_tipo_endereco = 3 ) and
                                                                 ( ce.cd_cliente = c.cd_cliente )
  left outer join Cliente_Informacao_Credito ci with (nolock) on c.cd_cliente    = ci.cd_cliente
  left outer join Tipo_Destinatario td          with (nolock) on td.cd_tipo_destinatario = 1
  left outer join Pais p                        with (nolock) on p.cd_pais     = c.cd_pais 
  Left outer Join Estado e                      with (nolock) on e.cd_estado   = c.cd_estado
  Left outer Join Cidade cid                    with (nolock) on cid.cd_cidade = c.cd_cidade and
                                                                 cid.cd_estado = c.cd_estado 



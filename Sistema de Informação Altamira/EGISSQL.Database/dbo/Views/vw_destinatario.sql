
create VIEW vw_destinatario
--------------------------------------------------------------------------------
-- vw_destinatario
--------------------------------------------------------------------------------
--GBS Global Business Solucion LTDA                                         2004
--------------------------------------------------------------------------------
--Stored Procedure       : Microsoft SQL Server 2000
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
--                       : 22.04.2007 - Mostra se a Inscrição Estadual é isenta - Douglas de Paula Lopes 
-- 08.08.2009 - Ajustes Mercado Externo - Carlos Fernades
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
  case when c.cd_tipo_mercado = 2 then
  'ISENTO'
  else
    c.cd_inscestadual 
  end           	       as 'cd_inscestadual',
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
  case when c.cd_tipo_mercado = 2 then
    'EX'
  else
     e.sg_estado
  end                                  as sg_estado,
  cid.nm_cidade,
  isnull(c.ic_isento_insc_cliente,'N') as 'IsentoInscEstadual',
  c.dt_cadastro_cliente                as 'Data_Cadastro',
  c.cd_interface

--select * from cliente

from
  Cliente c with (nolock)
    left outer join Cliente_Endereco ce           with (nolock) on ( ce.cd_tipo_endereco = 3 ) and
                                                                   ( ce.cd_cliente = c.cd_cliente )
    left outer join Cliente_Informacao_Credito ci with (nolock) on c.cd_cliente = ci.cd_cliente
    left outer join Tipo_Destinatario td          with (nolock) on td.cd_tipo_destinatario = 1
    left outer join Pais p                        with (nolock) on p.cd_pais     = c.cd_pais 
    Left outer Join Estado e                      with (nolock) on e.cd_estado   = c.cd_estado
    Left outer Join Cidade cid                    with (nolock) on cid.cd_cidade = c.cd_cidade and
                                                                   cid.cd_estado = c.cd_estado 
union all

select
  2                         as 'cd_tipo_destinatario',
  f.cd_fornecedor           as 'cd_destinatario',
  f.nm_fantasia_fornecedor  as 'nm_fantasia',
  f.nm_razao_social         as 'nm_razao_social',
  f.nm_razao_social_comple  as 'nm_razao_social_complemento',
  f.cd_tipo_pessoa,
  f.cd_cnpj_fornecedor      as 'cd_cnpj',
  case when f.cd_tipo_mercado = 2 then
    'ISENTO'
  else
     f.cd_inscestadual    
  end                       as 'cd_inscestadual',
  f.cd_inscmunicipal	    as 'cd_inscmunicipal',
  f.cd_tipo_mercado         as 'cd_tipo_mercado',
  cast(null as int)         as 'cd_tipo_cobranca',
  ltrim(rtrim(f.nm_endereco_fornecedor))                 as 'nm_endereco',
  ltrim(rtrim(cast(f.cd_numero_endereco as varchar(6)))) as 'cd_numero_endereco',
  ltrim(rtrim(f.nm_complemento_endereco))                as 'nm_complemento_endereco',
  ltrim(rtrim(f.nm_bairro))                              as 'nm_bairro',
  REPLACE(f.cd_cep,'-','')  as cd_cep,
  f.cd_cidade,
  f.cd_estado,
  f.cd_pais,
  f.cd_ddd,
  f.cd_telefone,
  f.cd_fax,

  IsNull(ltrim(rtrim(fe.nm_endereco_fornecedor)),
         ltrim(rtrim(f.nm_endereco_fornecedor))) as 'nm_endereco_cob',
  IsNull(ltrim(rtrim(cast(fe.cd_numero_endereco as varchar(6)))),
         ltrim(rtrim(cast(f.cd_numero_endereco as varchar(6))))) as 'cd_numero_endereco_cob',
  IsNull(ltrim(rtrim(fe.nm_complemento_endereco)),
         ltrim(rtrim(f.nm_complemento_endereco))) as 'nm_complemento_endereco_cob',
  IsNull(ltrim(rtrim(fe.nm_bairro_fornecedor)),
         ltrim(rtrim(f.nm_bairro))) as 'nm_bairro_cob',
  IsNull(REPLACE(fe.cd_cep_fornecedor,'-',''),
         REPLACE(f.cd_cep,'-','')) as 'cd_cep_cob',
  IsNull(fe.cd_cidade,
         f.cd_cidade) as 'cd_cidade_cob',
  IsNull(fe.cd_estado,
         f.cd_estado) as 'cd_estado_cob',
  IsNull(fe.cd_pais,
         f.cd_pais) as 'cd_pais_cob',

--  IsNull((Select top 1 nm_endereco_fornecedor  From Fornecedor_Endereco where cd_tipo_endereco = 3 and cd_fornecedor = Fornecedor.cd_Fornecedor), nm_endereco_fornecedor)  as 'nm_endereco_cob',
--  IsNull((Select top 1 cast(cd_numero_endereco From Fornecedor_Endereco where cd_tipo_endereco = 3 and cd_Fornecedor = Fornecedor.cd_Fornecedor),cast(cd_numero_endereco) as 'cd_numero_endereco_cob',
--  IsNull((Select top 1 nm_complemento_endereco From Fornecedor_Endereco where cd_tipo_endereco = 3 and cd_Fornecedor = Fornecedor.cd_Fornecedor), nm_complemento_endereco) as 'nm_complemento_endereco_cob',
--  IsNull((Select top 1 nm_bairro_fornecedor    From Fornecedor_Endereco where cd_tipo_endereco = 3 and cd_Fornecedor = Fornecedor.cd_Fornecedor), nm_bairro) as 'nm_bairro_cob',
--  IsNull((Select top 1 cd_cep_fornecedor       From Fornecedor_Endereco where cd_tipo_endereco = 3 and cd_Fornecedor = Fornecedor.cd_Fornecedor), cd_cep)    as 'cd_cep_cob',
--  IsNull((Select top 1 cd_cidade               From Fornecedor_Endereco where cd_tipo_endereco = 3 and cd_Fornecedor = Fornecedor.cd_Fornecedor), cd_cidade) as 'cd_cidade_cob',
--  IsNull((Select top 1 cd_estado               From Fornecedor_Endereco where cd_tipo_endereco = 3 and cd_Fornecedor = Fornecedor.cd_Fornecedor), cd_estado) as 'cd_estado_cob',
--  IsNull((Select top 1 cd_pais                 From Fornecedor_Endereco where cd_tipo_endereco = 3 and cd_Fornecedor = Fornecedor.cd_Fornecedor), cd_pais)   as 'cd_pais_cob',

  f.cd_conta,
  f.cd_condicao_pagamento,
  f.cd_destinacao_produto,
  isnull(f.ic_simples_fornecedor,'N') as 'ic_op_simples',
  isnull(fic.ic_suspenso_compra,'N')  as Suspenso,
  td.nm_tipo_destinatario,
  p.nm_pais,
  e.nm_estado,
  case when f.cd_tipo_mercado = 2 then
    'EX'
  else
    e.sg_estado
  end                                 as sg_estado,
  cid.nm_cidade,
  isnull(f.ic_isento_insc_fornecedor,'N') as 'IsentoInscEstadual',
  f.dt_cadastro_fornecedor                as 'Data_Cadastro',
  f.cd_interface


--select * from fornecedor

from
  Fornecedor f with (nolock) 
  left outer join Fornecedor_Endereco fe with (nolock) on ( fe.cd_tipo_endereco = 3 ) and
                                                         ( fe.cd_fornecedor = f.cd_fornecedor )
  left outer join Fornecedor_Informacao_Compra fic with (nolock) on  fic.cd_fornecedor       = f.cd_fornecedor
  left outer join Tipo_Destinatario td             with (nolock) on td.cd_tipo_destinatario = 2
  left outer join Pais p                           with (nolock) on p.cd_pais     = f.cd_pais 
  left outer Join Estado e                         with (nolock) on e.cd_estado   = f.cd_estado
  left outer Join Cidade cid                       with (nolock) on cid.cd_cidade = f.cd_cidade and
                                                                    cid.cd_estado = f.cd_estado
union all

select
  3                        as 'cd_tipo_destinatario',
  v.cd_vendedor              as 'cd_destinatario',
  v.nm_fantasia_vendedor     as 'nm_fantasia',
  v.nm_vendedor              as 'nm_razao_social',
  '' 			   as 'nm_razao_social_complemento',
  v.cd_tipo_pessoa,
  v.cd_cnpj_vendedor         as 'cd_cnpj',
  v.cd_inscestadual_vendedor as 'cd_inscestadual',
  v.cd_insmunicipal_vendedor as 'cd_inscmunicipal',
  null                     as 'cd_tipo_mercado',
  cast(null as int)        as 'cd_tipo_cobranca',
  ltrim(rtrim(v.nm_endereco_vendedor))     as 'nm_endereco',
  ltrim(rtrim(cast(v.cd_numero_endereco    as varchar(6)))) as 'cd_numero_endereco',
  ltrim(rtrim(v.nm_complemento_endereco))  as 'nm_complemento_endereco',
  ltrim(rtrim(v.nm_bairro_vendedor))       as 'nm_bairro_vendedor',
  REPLACE(v.cd_cep,'-','')   as cd_cep,
  v.cd_cidade,
  v.cd_estado,
  v.cd_pais,
  v.cd_ddd_vendedor          as 'cd_ddd',
  v.cd_telefone_vendedor     as 'cd_telefone',
  v.cd_fax_vendedor          as 'cd_fax',
  ltrim(rtrim(v.nm_endereco_vendedor))     as 'nm_endereco_cob',
  ltrim(rtrim(cast(v.cd_numero_endereco as varchar(6)))) as 'cd_numero_endereco_cob',
  ltrim(rtrim(v.nm_complemento_endereco))  as 'nm_complemento_endereco_cob',
  ltrim(rtrim(v.nm_bairro_vendedor))       as 'nm_bairro_cob',
  REPLACE(v.cd_cep,'-','')   as 'cd_cep_cob',
  v.cd_cidade                as 'cd_cidade_cob',
  v.cd_estado                as 'cd_estado_cob',
  v.cd_pais                  as 'cd_pais_cob',
  0                        as 'cd_conta',
  0			   as 'cd_condicao_pagamento',
  0			   as 'cd_destinacao_produto',
  cast('N' as char(1))     as 'ic_op_simples',
  cast('N' as char(1))     as 'Suspenso',
  td.nm_tipo_destinatario,
  p.nm_pais,
  e.nm_estado,
  e.sg_estado,
  cid.nm_cidade,
  'N' as 'IsentoInscEstadual', 
  v.dt_usuario             as 'Data_Cadastro',
  v.cd_interface


--select dt_usuario,* from vendedor

from
  Vendedor v                                    with (nolock) 
  left outer join Tipo_Destinatario td          with (nolock) on td.cd_tipo_destinatario = 3
  left outer join Pais p                        with (nolock) on p.cd_pais     = v.cd_pais 
  left outer Join Estado e                      with (nolock) on e.cd_estado   = v.cd_estado
  left outer Join Cidade cid                    with (nolock) on cid.cd_cidade = v.cd_cidade and
                                                                 cid.cd_estado = v.cd_estado

union all

select
  4                         as 'cd_tipo_destinatario',
  t.cd_transportadora       as 'cd_destinatario',
  t.nm_fantasia             as 'nm_fantasia',
  t.nm_transportadora       as 'nm_razao_social',
  ''			    as 'nm_razao_social_complemento',
  t.cd_tipo_pessoa,
  t.cd_cnpj_transportadora  as 'cd_cnpj',
  t.cd_insc_estadual        as 'cd_inscestadual',
  t.cd_insc_municipal       as 'cd_inscmunicipal',
  cast(null as int)         as 'cd_tipo_mercado',
  cast(null as int)         as 'cd_tipo_cobranca',
  ltrim(rtrim(t.nm_endereco))             as 'nm_endereco',
  ltrim(rtrim(cast(t.cd_numero_endereco as varchar(6))))
			    as 'cd_numero_endereco',
  ltrim(rtrim(t.nm_endereco_complemento)) as 'nm_endereco_complemento',
  ltrim(rtrim(t.nm_bairro)) as 'nm_bairro',
  REPLACE(t.cd_cep,'-','')  as cd_cep, 
  t.cd_cidade,
  t.cd_estado,
  t.cd_pais,
  t.cd_fax,
  t.cd_telefone,
  t.cd_ddd,

  IsNull(te.nm_endereco,
         t.nm_endereco) as 'nm_endereco_cob',
  IsNull(cast(te.cd_numero_endereco as varchar(6)),
         cast(t.cd_numero_endereco as varchar(6))) as 'cd_numero_endereco_cob',
  IsNull(te.nm_complemento_endereco,
         t.nm_endereco_complemento) as 'nm_complemento_endereco_cob',
  IsNull(te.nm_bairro,
         t.nm_bairro) as 'nm_bairro_cob',
  IsNull(REPLACE(te.cd_cep,'-',''),
         REPLACE(t.cd_cep,'-','')) as 'cd_cep_cob',
  IsNull(te.cd_cidade,
         t.cd_cidade) as 'cd_cidade_cob',
  IsNull(te.cd_estado,
         t.cd_estado) as 'cd_estado_cob',
  IsNull(te.cd_pais,
         t.cd_pais) as 'cd_pais_cob',

--  IsNull((Select top 1 nm_endereco             From Transportadora_Endereco where cd_tipo_endereco = 3 and cd_Transportadora = Transportadora.cd_Transportadora), nm_endereco)             as 'nm_endereco_cob',
--  IsNull((Select top 1 cast(cd_numero_endereco as varchar(6)) From Transportadora_Endereco where cd_tipo_endereco = 3 and cd_Transportadora = Transportadora.cd_Transportadora), cast(cd_numero_endereco as varchar(6))) as 'cd_numero_endereco_cob',
--  IsNull((Select top 1 nm_complemento_endereco From Transportadora_Endereco where cd_tipo_endereco = 3 and cd_Transportadora = Transportadora.cd_Transportadora), nm_endereco_complemento) as 'nm_complemento_endereco_cob',
--  IsNull((Select top 1 nm_bairro               From Transportadora_Endereco where cd_tipo_endereco = 3 and cd_Transportadora = Transportadora.cd_Transportadora), nm_bairro)    as 'nm_bairro_cob',
--  IsNull((Select top 1 cd_cep                  From Transportadora_Endereco where cd_tipo_endereco = 3 and cd_Transportadora = Transportadora.cd_Transportadora), cd_cep)       as 'cd_cep_cob',
--  IsNull((Select top 1 cd_cidade               From Transportadora_Endereco where cd_tipo_endereco = 3 and cd_Transportadora = Transportadora.cd_Transportadora), cd_cidade)    as 'cd_cidade_cob',
--  IsNull((Select top 1 cd_estado               From Transportadora_Endereco where cd_tipo_endereco = 3 and cd_Transportadora = Transportadora.cd_Transportadora), cd_estado)    as 'cd_estado_cob',
--  IsNull((Select top 1 cd_pais                 From Transportadora_Endereco where cd_tipo_endereco = 3 and cd_Transportadora = Transportadora.cd_Transportadora), cd_pais)      as 'cd_pais_cob',

  0 as 'cd_conta',
  0 as 'cd_condicao_pagamento',
  0 as 'cd_destinacao_produto',
  cast('N' as char(1)) as 'ic_op_simples',
  cast('N' as char(1)) as 'Suspenso',
  td.nm_tipo_destinatario,
  p.nm_pais,
  e.nm_estado,
  e.sg_estado,
  cid.nm_cidade,
  case when isnull(t.cd_tipo_pessoa,1) = 1 then
    'S'
  else
    'N'
  end  as 'IsentoInscEstadual',
  dt_cadastro                         as 'Data_Cadastro',
  t.cd_interface


--select * from transportadora  
   
from
  Transportadora t                              with (nolock)
  left outer join Transportadora_Endereco te    with (nolock) on ( te.cd_tipo_endereco = 3 ) and ( te.cd_transportadora = t.cd_transportadora )
  left outer join Tipo_Destinatario td          with (nolock) on td.cd_tipo_destinatario = 4
  left outer join Pais p                        with (nolock) on p.cd_pais     = t.cd_pais 
  left outer Join Estado e                      with (nolock) on e.cd_estado   = t.cd_estado
  left outer Join Cidade cid                    with (nolock) on cid.cd_cidade = t.cd_cidade and
                                                                 cid.cd_estado = t.cd_estado

union all

select
  6                    as 'cd_tipo_destinatario',
  f.cd_funcionario     as 'cd_destinatario',
  f.nm_funcionario     as 'nm_fantasia',
  f.nm_funcionario     as 'nm_razao_social',
  ''		     as 'nm_razao_social_complemento',
  2                  as 'cd_tipo_pessoa',  -- Pessoa Física
  f.cd_cpf_funcionario as 'cd_cnpj',
  f.cd_rg_funcionario  as 'cd_inscestadual',
  null		     as 'cd_inscmunicipal',
  cast(null as int)  as 'cd_tipo_mercado',
  cast(null as int)  as 'cd_tipo_cobranca',
  null               as 'nm_endereco',
  null               as 'cd_numero_endereco',
  null               as 'nm_complemento_endereco',
  null               as 'nm_bairro',
  null               as 'cd_cep',
  null               as 'cd_cidade',
  null               as 'cd_estado',
  cast(null as int)  as 'cd_pais',
  null               as 'cd_fax',
  null               as 'cd_telefone',
  null               as 'cd_ddd',
  null               as 'nm_endereco_cob',
  null                 as 'cd_numero_endereco_cob',
  null                 as 'nm_complemento_endereco_cob',
  null                 as 'nm_bairro_cob',
  null                 as 'cd_cep_cob',
  null                 as 'cd_cidade_cob',
  null                 as 'cd_estado_cob',
  null                 as 'cd_pais_cob', 
  0                    as 'cd_conta',
  0          	       as 'cd_condicao_pagamento',
  0		       as 'cd_destinacao_produto',
  cast('N' as char(1)) as 'ic_op_simples',
  cast('N' as char(1)) as 'Suspenso',
  td.nm_tipo_destinatario,
  null                 as nm_pais,
  null                 as nm_estado,
  null                 as sg_estado,
  null                 as nm_cidade,
  'N' as 'IsentoInscEstadual',
  f.dt_usuario         as 'Data_Cadastro',
  f.cd_interface


--select * from funcionario
 
--   p.nm_pais,
--   e.nm_estado,
--   e.sg_estado,
--   cid.nm_cidade

from
  Funcionario f                                 with (nolock)
  left outer join Tipo_Destinatario td          with (nolock) on td.cd_tipo_destinatario = 6
--   left outer join Pais p                        with (nolock) on p.cd_pais     = f.cd_pais 
--   left outer Join Estado e                      with (nolock) on e.cd_estado   = f.cd_estado
--   left outer Join Cidade cid                    with (nolock) on cid.cd_cidade = f.cd_cidade and
--                                                                  cid.cd_estado = f.cd_estado



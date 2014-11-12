
-------------------------------------------------------------------------------
--pr_cliente_endereco_nfe_contato
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Wilder Mendes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 17/03/2005
--Atualizado       : 27/03/2005
--                   Corrigido o Nome das Colunas - Carlos Fernandes.
--                   13/04/2005 - Paulo Souza
--                                Trazer o 1o. contato do cliente
--                   19.01.2006 - Colocar o Vendedor Externo / Segmento de Mercado
--                   24.03.2007 - Adicionado o e-mail do Contato - Carlos Fernandes
-- 14.07.2009 - Todos os Clientes - Carlos Fernandes
-- 24.08.2010 - Data de Nascimento do Contato - Carlos Fernandes
-- 03.12.2010 - Mostrar somente os Clientes para NFE - Carlos Fernandes
--------------------------------------------------------------------------------------------------
create procedure pr_cliente_endereco_nfe_contato
@dt_inicial datetime,
@dt_final   datetime
as

--select * from cliente

--select * from cliente_contato

select 
  a.nm_razao_social_cliente as Cliente,
  a.nm_fantasia_cliente     as Fantasia,
  a.nm_endereco_cliente     as Endereco,
  a.cd_numero_endereco      as Numero,
  a.nm_bairro               as Bairro,
  b.nm_cidade               as Cidade,
  c.sg_estado               as Estado,
  d.nm_pais                 as Pais,
  a.cd_cep                  as Cep,
  a.cd_ddd                  as ddd,
  a.cd_telefone             as Fone,

  case when isnull(cc.cd_email_contato_cliente,'')<>'' and cc.cd_email_contato_cliente <> a.nm_email_cliente
  then 
    cc.cd_email_contato_cliente 
  else
    a.nm_email_cliente
    --(Select Top 1 cd_email_contato_cliente from cliente_contato where cd_cliente = a.cd_cliente)
  end as Email,

  --(Select Top 1 nm_fantasia_contato from cliente_contato where cd_cliente = a.cd_cliente) as Contato,
  cc.nm_fantasia_contato as Contato,

  ra.nm_ramo_atividade                                                                    as Segmento,
  isnull(v.nm_fantasia_vendedor,ve.nm_fantasia_vendedor)                                  as Vendedor,
  vi.nm_fantasia_vendedor                                                                 as VendedorInterno,
  cc.dt_nascimento,
  isnull(cc.ic_nfe_contato,'N')                                                           as ic_nfe_contato

from 
  cliente a                            with (nolock) 
  left outer join cidade b             with (nolock) on a.cd_cidade          = b.cd_cidade
  left outer join estado c             with (nolock) on a.cd_estado          = c.cd_estado
  left outer join pais d               with (nolock) on a.cd_pais            = d.cd_pais
  left outer join ramo_atividade ra    with (nolock) on ra.cd_ramo_atividade = a.cd_ramo_atividade
  left outer join vendedor v           with (nolock) on v.cd_vendedor        = a.cd_vendedor
  left outer join Cliente_Vendedor cv  with (nolock) on cv.cd_cliente        = a.cd_cliente and
                                                        cv.cd_tipo_vendedor  = 2
  left outer join vendedor ve          with (nolock) on ve.cd_vendedor       = cv.cd_vendedor
  left outer join vendedor vi          with (nolock) on vi.cd_vendedor       = a.cd_vendedor_interno
  left outer join cliente_contato cc   with (nolock) on cc.cd_cliente        = a.cd_cliente 

--select * from cliente_contato

where
  a.nm_razao_social_cliente is not null
  and
  isnull(cc.ic_nfe_contato,'N') = 'S'

order by 
  a.nm_razao_social_cliente


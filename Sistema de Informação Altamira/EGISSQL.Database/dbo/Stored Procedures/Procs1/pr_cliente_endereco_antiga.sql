
-------------------------------------------------------------------------------
--pr_cliente_endereco
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
--------------------------------------------------------------------------------------------------
create procedure pr_cliente_endereco_antiga
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
  case when isnull(a.nm_email_cliente,'')<>''
  then a.nm_email_cliente
  else
    (Select Top 1 cd_email_contato_cliente from cliente_contato where cd_cliente = a.cd_cliente)
  end as Email,

  (Select Top 1 nm_fantasia_contato from cliente_contato where cd_cliente = a.cd_cliente) as Contato,

  ra.nm_ramo_atividade                                                                    as Segmento,
  isnull(v.nm_fantasia_vendedor,ve.nm_fantasia_vendedor)                                  as Vendedor,
  vi.nm_fantasia_vendedor                                                                 as VendedorInterno

from 
  cliente a 
  left outer join cidade b            on a.cd_cidade          = b.cd_cidade
  left outer join estado c            on a.cd_estado          = c.cd_estado
  left outer join pais d              on a.cd_pais            = d.cd_pais
  left outer join ramo_atividade ra   on ra.cd_ramo_atividade = a.cd_ramo_atividade
  left outer join vendedor v          on v.cd_vendedor        = a.cd_vendedor
  left outer join Cliente_Vendedor cv on cv.cd_cliente        = a.cd_cliente and
                                         cv.cd_tipo_vendedor  = 2
  left outer join vendedor ve          on ve.cd_vendedor       = cv.cd_vendedor
  left outer join vendedor vi          on vi.cd_vendedor       = a.cd_vendedor_interno

where
  a.nm_razao_social_cliente is not null

order by 
  a.nm_razao_social_cliente


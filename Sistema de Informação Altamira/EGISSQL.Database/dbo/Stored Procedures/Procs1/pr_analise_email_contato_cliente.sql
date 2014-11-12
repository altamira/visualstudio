
CREATE PROCEDURE pr_analise_email_contato_cliente
@dt_inicial datetime, --Implementado apenas para efeito de compatibilidade com a estrutura da stored procedure padrão
@dt_final datetime --Implementado apenas para efeito de compatibilidade com a estrutura da stored procedure padrão
as
SELECT
  c.cd_cliente,
  c.nm_fantasia_cliente,
  cc.nm_contato_cliente,
  cc.cd_email_contato_cliente,
  dbo.fn_formato_email(cc.cd_email_contato_cliente) as nm_problema,
  v.nm_fantasia_vendedor
from 
  Cliente c with (nolock)
  inner join Cliente_Contato cc with (nolock)
    on c.cd_cliente = cc.cd_cliente
  inner join Vendedor v with (nolock)
    on c.cd_vendedor_interno = v.cd_vendedor
where
  c.cd_status_cliente = 1
  and cc.cd_email_contato_cliente <> '' 
  and dbo.fn_formato_email(cc.cd_email_contato_cliente) <> ''

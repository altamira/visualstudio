
CREATE PROCEDURE pr_consulta_cliente_sem_vendedor

@nm_fantasia_cliente Varchar(15) = ''

AS

--Rotina para atualizar o Vendedor da Tabela Cliente_Vendedor p/ Tabela Cliente

--Tipo de Vendedor

update
  cliente_vendedor
set
  cd_tipo_vendedor = v.cd_tipo_vendedor
from
  cliente_vendedor cv
  inner join vendedor v on v.cd_vendedor = cv.cd_vendedor

--Cliente Vendedor

update
  cliente_vendedor
set
  cd_tipo_vendedor = v.cd_tipo_vendedor
from
  cliente_vendedor cv
  inner join vendedor v on v.cd_vendedor = cv.cd_vendedor
where
  isnull(cv.cd_tipo_vendedor,0)=0

--Externo

update
  cliente
set
  cd_vendedor = cv.cd_vendedor
from
  cliente c
  inner join cliente_vendedor cv on cv.cd_cliente       = c.cd_cliente and
                                    cv.cd_tipo_vendedor = 2
where
  isnull(c.cd_vendedor,0) <> isnull(cv.cd_vendedor,0) and
  isnull(cv.cd_vendedor,0)>0

--Interno

update
  cliente
set
  cd_vendedor_interno = cv.cd_vendedor
from
  cliente c
  inner join cliente_vendedor cv on cv.cd_cliente       = c.cd_cliente and
                                    cv.cd_tipo_vendedor = 1
where
  isnull(c.cd_vendedor_interno,0) <> isnull(cv.cd_vendedor,0) and
  isnull(cv.cd_vendedor,0)>0



select
  cli.nm_fantasia_cliente,
  cli.dt_cadastro_cliente,
  cli.cd_telefone, 			
  max(pv.dt_pedido_venda) as 'dt_ultima_compra',
  case when 
    isnull(cli.cd_vendedor,0) <> 0 then
    'S' else 'N' end as 'VE',
  case when 
    isnull(cli.cd_vendedor_interno,0) <> 0 then
    'S' else 'N' end as 'VI'
from
  Cliente cli                      with (nolock) 
  LEFT OUTER JOIN Pedido_Venda pv  with (nolock) ON cli.cd_cliente = pv.cd_cliente
where 
  ((cli.nm_fantasia_cliente like @nm_fantasia_cliente+ '%') or (@nm_fantasia_cliente='')) and
  (isnull(cli.cd_vendedor,0)=0 or isnull(cli.cd_vendedor_interno,0)=0 )

group by 
  cli.nm_fantasia_cliente,
  cli.dt_cadastro_cliente,
  cli.cd_telefone,
  cli.cd_vendedor,
  cli.cd_vendedor_interno

order by
  cli.nm_fantasia_cliente

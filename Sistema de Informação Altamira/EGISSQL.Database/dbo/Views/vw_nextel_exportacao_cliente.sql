
CREATE VIEW vw_nextel_exportacao_cliente
------------------------------------------------------------------------------------
--vw_nextel_exportacao_cliente
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Douglas de Paula Lopes
--Banco de Dados	: EGISSQL
--Objetivo	        : Remessa nextel cliente.
--Data                  : 22/07/2008  
--Atualização           : 19.11.2008 - Somente os Clientes Ativos - Carlos Fernandes
--23.04.2009 - Ajustes Diversos - Carlos Fernandes
-- 06.05.2009 - Verificação - Carlos Fernandes
------------------------------------------------------------------------------------
as

--select * from cliente
--select * from cliente_contato

select
  c.cd_cliente,
  dbo.fn_strzero(isnull(c.cd_cliente ,0),5)                 + '|' +
  case when isnull(cve.cd_vendedor,0)>0 then
     dbo.fn_strzero(isnull(cve.cd_vendedor,0),4)      
  else
     dbo.fn_strzero(isnull(c.cd_vendedor,0),4)      
  end                                                       + '|' +
  cast(isnull(c.nm_razao_social_cliente,'') as char(50))    + '|' +
  '00'                                                      + '|' +
  cast( isnull(( select top 1 cc.nm_contato_cliente
         from
           cliente_contato cc   with (nolock) 
         where 
           cc.cd_cliente = c.cd_cliente ),'') as char(16) ) + '|' +

  '000'                                                     + '|' +
  cast(isnull(cv.sg_area_criterio_visita,'00') as char(2))    + '|' +
  cast(isnull(fp.cd_forma_pagamento,0)       as char(1))                


  as Linha,  

--cast(c.cd_cliente as int(8))                     as COD,
dbo.fn_strzero(isnull(c.cd_cliente,0),5)           as COD,
--cast(c.cd_vendedor as int(8))                    as CODVEN,
dbo.fn_strzero(isnull(c.cd_vendedor,0),4)                as CODVEN,
--cast(v.nm_vendedor as varchar(255))           as NOME,
cast(c.nm_razao_social_cliente as varchar(255))       as NOME, 
cast(isnull(c.pc_desconto_cliente,0) as int(2))         as DMAX,
--cast(v.nm_contato_vendedor as varchar(16))    as CONT,
--cast('' as varchar(16))                       as CONT, 

--select * from cliente_contato
  --Contato
cast(isnull(( select top 1 nm_contato_cliente
    from
      cliente_contato cc with (nolock) 
    where
      cc.cd_cliente = c.cd_cliente ),'') as varchar(16)) as CONT, --Contato

'000'                                            as ORROT,--Ordem do Roteiro
cv.sg_area_criterio_visita                    as ARROT,
--cast(fp.sg_forma_pagamento as varchar(60))    as FORPAGTO --Forma de Pagamento
cast(fp.cd_forma_pagamento as varchar(60))    as FORPAGTO

from
  cliente                                  c   with(nolock)
  left outer join cliente_vendedor         cve with(nolock) on cve.cd_cliente            = c.cd_cliente  and
                                                               cve.cd_tipo_vendedor      = 2 --Externo
  
  left outer join vendedor                 v   with(nolock) on v.cd_vendedor            = cve.cd_vendedor
  left outer join regiao                   r   with(nolock) on r.cd_regiao              = c.cd_regiao
  left outer join status_cliente           sc  with(nolock) on sc.cd_status_cliente     = c.cd_status_cliente
  left outer join criterio_visita          cv  with(nolock) on cv.cd_criterio_visita    = c.cd_criterio_visita

  left outer join 
    cliente_informacao_credito             ci  with(nolock) on ci.cd_cliente            = c.cd_cliente

  left outer join forma_pagamento          fp  with(nolock) on fp.cd_forma_pagamento    = ci.cd_forma_pagamento

where
  isnull(sc.ic_operacao_status_cliente,'N')='S' and
  isnull(cve.cd_vendedor,0)>0                   and
  isnull(c.cd_cliente,0)>0                

--select cd_vendedor,cd_cliente,* from cliente where cd_cliente = 41981
--select * from status_cliente
--select * from criterio_visita
--select * from forma_pagamento
--select * from cliente_informacao_credito
--select cd_cliente,cd_vendedor, nm_fantasia_cliente, nm_razao_social_cliente from cliente where isnull(cd_vendedor,0)=0 and cd_status_cliente = 1 order by nm_fantasia_cliente

-- update
--   cliente
-- set
--   cd_vendedor = cv.cd_vendedor
-- from
--   cliente c
--   inner join cliente_vendedor cv on cv.cd_cliente = c.cd_cliente
-- where
--   isnull(c.cd_vendedor,0)=0  and
--   cv.cd_tipo_vendedor = 2
 

  

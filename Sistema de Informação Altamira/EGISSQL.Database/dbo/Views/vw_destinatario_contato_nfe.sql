
CREATE VIEW vw_destinatario_contato_nfe
------------------------------------------------------------------------------------
--sp_helptext vw_destinatario_contato_nfe
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--
--Banco de Dados	: EGISSQL
--
--Objetivo	        : Mostra os Contatos do Destinatario para Nota Fiscal Eletrônica
--
--
--Data                  : 03.12.2009
--Atualização           : 21.09.2010 - Transportadora - Carlos Fernandes
--
------------------------------------------------------------------------------------
as


--Cliente

select 
  1                             as cd_tipo_destinatario,
  cc.cd_cliente                 as cd_destinatario,
  cc.nm_contato_cliente         as Contato,
  cc.cd_email_contato_cliente   as email
from 
  cliente_contato cc
where
  isnull(cc.ic_nfe_contato,'N') = 'S'

union all

--Fornecedor
--select * from fornecedor_contato

select 
  2                                as cd_tipo_destinatario,
  cf.cd_fornecedor                 as cd_destinatario,
  cf.nm_contato_fornecedor         as Contato,
  cf.cd_email_contato_forneced     as email
from 
  fornecedor_contato cf
where
  isnull(cf.ic_nfe_contato,'N') = 'S'

union all

select 
  4                             as cd_tipo_destinatario,
  cc.cd_transportadora          as cd_destinatario,
  cc.nm_contato                 as Contato,
  cc.nm_email_contato           as email
from 
  transportadora_contato cc
where
  isnull(cc.ic_nfe_contato,'N') = 'S'

 

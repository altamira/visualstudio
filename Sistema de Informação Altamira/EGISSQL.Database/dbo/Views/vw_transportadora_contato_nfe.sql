
CREATE VIEW vw_transportadora_contato_nfe
------------------------------------------------------------------------------------
--sp_helptext vw_transportadora_contato_nfe
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                        2010
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--
--Banco de Dados	: EGISSQL
--
--Objetivo	        : Mostra os Contatos da Transportadora para 
--                        Nota Fiscal Eletrônica
--
--
--Data                  : 21.09.2010
--Atualização           : 
--
------------------------------------------------------------------------------------
as


--Transportadora
--select * from tipo_destinatario
--select * from transportadora_contato

select 
  4                             as cd_tipo_destinatario,
  cc.cd_transportadora          as cd_destinatario,
  cc.nm_contato                 as Contato,
  cc.nm_email_contato           as email
from 
  transportadora_contato cc
where
  isnull(cc.ic_nfe_contato,'N') = 'S'
 

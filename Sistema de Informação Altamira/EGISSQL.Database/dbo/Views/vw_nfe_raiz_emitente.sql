
CREATE VIEW vw_nfe_raiz_emitente
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_raiz_emitente
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Geração do Arquivo Texto para Importar o Cadastro da Empresa
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--Data                  : 04.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from egisadmin.dbo.empresa

select
  'EMITENTE' as 'EMITENTE',
  count(*)   as qtd_emitente
from
  egisadmin.dbo.empresa e    with (nolock) 
where
  e.cd_empresa = dbo.fn_empresa() 

--select * from cnae


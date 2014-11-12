
CREATE VIEW vw_nfe_raiz_transportadora
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_exporta_transportadora
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Geração do Arquivo Texto para Importar o Cadastro de Transportadora
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--Data                  : 04.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from egisadmin.dbo.empresa
--select * from tipo_pessoa

select
  'TRANSPORTADORA' as 'Transportadora',
  count(*)         as qtd_transportadora
from
  Transportadora t
where
  isnull(t.ic_ativo_transportadora,'S') = 'S'

--select * from transportadora


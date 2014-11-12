
CREATE VIEW vw_nfe_raiz_cliente
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_raiz_cliente
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Geração do Arquivo Texto para Importar o Cadastro de Clientes
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--Data                  : 04.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from egisadmin.dbo.empresa
--select * from cliente
--select * from tipo_pessoa

select
  'CLIENTE' as 'CLIENTE',
  count(*)  as qtd_cliente
from
  cliente c 
  inner join status_cliente sc with (nolock) on sc.cd_status_cliente = c.cd_status_cliente
where
  isnull(sc.ic_operacao_status_cliente,'N') = 'S'

--select * from status_cliente


--select * from cnae


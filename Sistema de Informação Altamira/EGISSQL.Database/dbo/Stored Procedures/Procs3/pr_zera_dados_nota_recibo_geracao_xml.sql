
-------------------------------------------------------------------------------
--sp_helptext pr_zera_dados_nota_recibo_geracao_xml
-------------------------------------------------------------------------------
--pr_zera_dados_nota_recibo_geracao_xml
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2010
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--
--Banco de Dados   : Egissql
--
--Objetivo         : Zerar os dados da Tabela de Nota Saida Recibo para 
--                   Geração do XML

--Data             : 28.04.2010
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_zera_dados_nota_recibo_geracao_xml
@cd_nota_saida int

as

update
  nota_saida_recibo
set
  nm_arquivo_envio_xml = '',
  nm_arquivo_recibo    = '' 

where
  cd_nota_saida = @cd_nota_saida


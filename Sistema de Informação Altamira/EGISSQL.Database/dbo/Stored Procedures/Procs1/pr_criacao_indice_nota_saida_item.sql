
-------------------------------------------------------------------------------
--pr_criacao_indice_nota_saida_item
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Criação de Índice do Pedido de Venda Origem
--Data             : 20.07.2006
--Alteração        : 01.08.2006
------------------------------------------------------------------------------
create procedure pr_criacao_indice_nota_saida_item
as

IF EXISTS (SELECT name FROM sysindexes 
      WHERE name = 'IX_NOTA_SAIDA_ITEM')
   DROP INDEX Nota_Saida_Item.IX_Nota_Saida_Item

BEGIN TRANSACTION
CREATE NONCLUSTERED INDEX IX_Nota_Saida_Item ON dbo.nota_saida
	(
        cd_nota_saida
	) ON [PRIMARY]

COMMIT


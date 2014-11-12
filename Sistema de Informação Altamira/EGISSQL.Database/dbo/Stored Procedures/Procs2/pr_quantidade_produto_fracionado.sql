
-------------------------------------------------------------------------------
--pr_quantidade_produto_fracionado
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Quantidade de Produtos Fracionados
--                   
--Data             : 28.01.2006
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_quantidade_produto_fracionado
@dt_inicial datetime,
@dt_final   datetime
as

--select * from produto_fracionamento

select
  count(*) as QtdProdFracionado
from
  Produto_Fracionamento



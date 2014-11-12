
CREATE VIEW vw_data_primeira_nota
------------------------------------------------------------------------------------
--vw_data_primeira_nota
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2007
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Data da 1a. Nota Fiscal
--Data                  : 20.06.2007
--Atualização           : 
------------------------------------------------------------------------------------
as

select 
  top 1
  RECEBTOSAIDA
from
  vw_livro_registro_geral_reg50


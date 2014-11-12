
CREATE VIEW vw_implantacao_consulta_tabela_cd_empresa
------------------------------------------------------------------------------------
--vw_implantacao_consulta_tabela_cd_empresa
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)          : Márcio Rodrigues
--Banco de Dados	   : EGISADMIN
--Objetivo	         : Descrição do que a View Realiza
--Data               : 30/06/2006
--Atualização        : 
------------------------------------------------------------------------------------
as
   select t.name
   as comandosql
   from syscolumns c, sysobjects t
   where t.id = c.id and c.name = 'cd_empresa' 

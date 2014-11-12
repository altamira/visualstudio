

/****** Object:  Stored Procedure dbo.pr_vw_servidor    Script Date: 13/12/2002 15:08:45 ******/
--pr_vw_servidor
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                             2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Listagem do cadastro de servidores (Projeto SVS2001)
--Data          : 16.04.2001
--Atualizado    : 
--------------------------------------------------------------------------------------
CREATE procedure pr_vw_servidor
as
select * from servidor 
order by sg_servidor



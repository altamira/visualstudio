

/****** Object:  Stored Procedure dbo.pr_vw_usuario    Script Date: 13/12/2002 15:08:45 ******/
--pr_vw_usuario
--------------------------------------------------------------------------------------
--Polimold Industrial S/A                                                             2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio Vanderlei
--Listagem do cadastro de usuários (Projeto SVS2001)
--Data          : 16.04.2001
--Atualizado    : 
--------------------------------------------------------------------------------------
CREATE procedure pr_vw_usuario
as
select cd_usuario, 
       nm_usuario,
       nm_email_usuario
--     nm_email_interno
from sapadmin.dbo.usuario
order by nm_usuario



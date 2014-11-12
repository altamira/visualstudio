

/****** Object:  Stored Procedure dbo.pr_email_usuario_gerencial    Script Date: 13/12/2002 15:08:28 ******/
--pr_email_usuario_gerencial
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio
--Retorno dos usuários que receberao e-mail gerencial
--Data         : 06.07.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_email_usuario_gerencial
@cd_info_gerencial int
as
select a.cd_usuario_info_gerencial,
       a.qt_dia_gera_email,
       b.nm_email_usuario
into #Usuarios
from 
   Usuario_Info_Gerencial a, SapAdmin.dbo.Usuario b
where a.cd_info_gerencial = @cd_info_gerencial and
      isnull(a.ic_gera_email,'N') = 'S' and
      a.cd_usuario_info_gerencial = b.cd_usuario 
order by b.nm_email_usuario
select a.*,
       b.nm_email_usuario as 'email_extra'
from #Usuarios a, 
     SapAdmin.dbo.Usuario_Email b
where a.cd_usuario_info_gerencial *= b.cd_usuario



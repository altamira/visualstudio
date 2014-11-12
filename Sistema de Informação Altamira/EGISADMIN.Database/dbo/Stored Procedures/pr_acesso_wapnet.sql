
--pr_acesso_wapnet
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                  2000                     
--Stored Procedure : SQL Server Microsoft 2000 
--Carlos Cardoso Fernandes         
--Acesso ao Wapnet
--Data          : 06.04.2002
--Atualizado    : 
-----------------------------------------------------------------------------------
CREATE  procedure pr_acesso_wapnet
@cd_senha_wapnet_usuario char(3)
as

declare @cd_usuario int

select @cd_usuario = cd_usuario
from Usuario
where ic_ativo                 = 'A' and 
      ic_wapnet_usuario        = 'S' and
      cd_senha_wapnet_usuario  = @cd_senha_wapnet_usuario

Select cd_usuario,
       nm_fantasia_usuario,
       case when datepart(dd,dt_nascimento_usuario) = datepart(dd,getdate()) and 
                 datepart(mm,dt_nascimento_usuario) = datepart(mm,getdate()) then
              'Parabens, Feliz Aniversario' end as 'Aniversario'
from
   Usuario

where ic_ativo                 = 'A' and 
      ic_wapnet_usuario        = 'S' and
      cd_senha_wapnet_usuario  = @cd_senha_wapnet_usuario


exec sp_RegistraLog @cd_usuario,0,80,0



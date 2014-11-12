




--pr_acesso_repnet
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Acesso ao RepNet
--Data          : 07.04.2002
--Atualizado    : 
--------------------------------------------------------------------------------------
CREATE    procedure pr_acesso_repnet
@nm_repnet_usuario       char(15),
@cd_senha_repnet_usuario varchar(10)  
as

select cd_usuario,
       nm_fantasia_usuario,
       qt_tentativa_acesso_usuario,
       ic_controle_aniversario,
       dt_nascimento_usuario,  
       dt_validade_senha_usuario, ic_tipo_usuario, nm_usuario, isnull(cd_vendedor,0) as cd_vendedor, isnull(cd_tipo_usuario,0) as cd_tipo_usuario
from
       Usuario
where
       nm_fantasia_usuario     = @nm_repnet_usuario  and
       cd_senha_repnet_usuario = @cd_senha_repnet_usuario and
       ic_ativo = 'A'                                    and
       ic_repnet_usuario = 'S'   







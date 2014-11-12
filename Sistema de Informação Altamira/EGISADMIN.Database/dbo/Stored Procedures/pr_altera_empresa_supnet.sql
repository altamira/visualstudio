
CREATE PROCEDURE pr_altera_empresa_supnet
@cd_cliente_sistema	int = 0,
@nm_cliente_sistema	varchar(15) = '' ,
@cd_ie_cliente_sistema	varchar(18)= '',
@cd_cnpj_cliente_sistema	varchar(18)= '',
@cd_fax_cliente_sistema	varchar(15) = '',
@cd_fone_cliente_sistema	varchar(15) = '',
@nm_site_cliente_sistema	varchar(100)= '',
@cd_usuario	int = 0,
@ic_parametro char(1)= 'L'
as  
IF @ic_parametro = 'A' 
BEGIN
UPDATE Cliente_Sistema
SET
nm_cliente_sistema = @nm_cliente_sistema,
cd_ie_cliente_sistema = @cd_ie_cliente_sistema,
cd_cnpj_cliente_sistema = @cd_cnpj_cliente_sistema,
cd_fax_cliente_sistema = @cd_fax_cliente_sistema,
cd_fone_cliente_sistema = @cd_fone_cliente_sistema,
nm_site_cliente_sistema = @nm_site_cliente_sistema,
cd_usuario = @cd_usuario,
dt_usuario = Getdate() 

WHERE
cd_cliente_sistema = @cd_cliente_sistema
END

IF @ic_parametro = 'L'
BEGIN
SELECT 
  * 
FROM 
  Cliente_Sistema
WHERE 
cd_cliente_sistema = @cd_cliente_sistema
END
/*
EXEC pr_altera_empresa_supnet 
@cd_cliente_sistema	= 1,
@nm_cliente_sistema	= '',
@cd_ie_cliente_sistema	= '',
@cd_cnpj_cliente_sistema	= '',
@cd_fax_cliente_sistema	= '',
@cd_fone_cliente_sistema	= '',
@nm_site_cliente_sistema	= '',
@cd_usuario	= 13,
@ic_parametro = 'L'
*/

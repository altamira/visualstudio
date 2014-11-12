
CREATE PROCEDURE pr_teste 
	@cd_cliente int output
AS
	Select top 10 @cd_cliente = cd_cliente from cliente
return


-------------------------------------------------------------------------------
--pr_hearder_arquivo_sispag
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues Adão
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 13.04.06
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_hearder_arquivo_sispag
	@ic_parametro int=0,
   @sg_banco char(15)='',
	@cd_banco int=0,
	@cd_lote int=0,
	@cd_cgc_empresa char(14)='',
	@cd_conta_banco int =0
as
  	-- header de Arquivo.
	if @ic_parametro = 1 
	begin
		if not exists(Select 'X' From Parametro_Pagamento_Eletronico_Sispag where sg_banco = @sg_banco )
      begin
			Insert into Parametro_Pagamento_Eletronico_Sispag (sg_banco, cd_cgc_empresa, cd_lote, cd_conta_banco, cd_banco) 
							values (@sg_banco,@cd_cgc_empresa, 0, 0, @cd_banco) 
		end
		else
      begin
			Update Parametro_Pagamento_Eletronico_Sispag set
				cd_banco = @cd_banco,
				cd_cgc_empresa = @cd_cgc_empresa,
				cd_lote = 0,
				cd_conta_banco = 0
	   	where
				sg_banco = @sg_banco 
      end
	end	
   else if @ic_parametro = 2
	begin
		Update Parametro_Pagamento_Eletronico_Sispag set
			cd_lote = cd_lote + 1,
			cd_conta_banco = @cd_conta_banco
	   where
			sg_banco = @sg_banco 		
	end

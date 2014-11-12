
-------------------------------------------------------------------------------------------------------------------
--sp_LiberaCodigo
-------------------------------------------------------------------------------------------------------------------
--GBS - Global Business Solution	       2005
-------------------------------------------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Fazer rotina de liberação de código
--Data             : ??????
--Atualizado       : 
-------------------------------------------------------------------------------------------------------------------


create procedure [sp_LiberaCodigo]
@nm_tabela varchar(50),
@cd_codigo int ,
@tipo_ope char(1)
as

  set nocount on

  if (PATINDEX('%MOVIMENTO_ESTOQUE',@nm_tabela) <> 0)
  begin

	  if @tipo_ope = 'D'
	    delete from Codigo_ME -- with (UPDLOCK)
	     where cd_atual  = @cd_codigo
	  else
	    if @tipo_ope = 'L'
	      update Codigo_ME -- with (UPDLOCK)
	      set sg_status = 'L'  
	      where cd_atual  = @cd_codigo

  end
  else
  if (PATINDEX('%PEDIDO_VENDA_HISTORICO',@nm_tabela) <> 0)
  begin

	  if @tipo_ope = 'D'
	    delete from Codigo_PVH -- with (UPDLOCK)
	     where cd_atual  = @cd_codigo
	  else
	    if @tipo_ope = 'L'
	      update Codigo_PVH -- with (UPDLOCK)
	      set sg_status = 'L'  
	      where cd_atual  = @cd_codigo

  end
  else
  if (PATINDEX('%PEDIDO_COMPRA_HISTORICO',@nm_tabela) <> 0)
  begin

	  if @tipo_ope = 'D'
	    delete from Codigo_PCH -- with (UPDLOCK)
	     where cd_atual  = @cd_codigo
                                     
	  else
	    if @tipo_ope = 'L'
	      update Codigo_PCH -- with (UPDLOCK)
	      set sg_status = 'L'  
	      where cd_atual  = @cd_codigo

  end
  else
  if (PATINDEX('%PEDIDO_VENDA',@nm_tabela) <> 0)
  begin

	  if @tipo_ope = 'D'
	    delete from Codigo_PV -- with (UPDLOCK)
	     where cd_atual  = @cd_codigo and
                   nm_tabela like @nm_tabela
	  else
	    if @tipo_ope = 'L'
	      update Codigo_PV -- with (UPDLOCK)
	      set sg_status = 'L'  
	      where cd_atual  = @cd_codigo and
                   nm_tabela like @nm_tabela

  end
  else
  if (PATINDEX('%PEDIDO_COMPRA',@nm_tabela) <> 0)
  begin

	  if @tipo_ope = 'D'
	    delete from Codigo_PC -- with (UPDLOCK)
	     where cd_atual  = @cd_codigo
	  else
	    if @tipo_ope = 'L'
	      update Codigo_PC -- with (UPDLOCK)
	      set sg_status = 'L'  
	      where cd_atual  = @cd_codigo

  end
  else
  if (PATINDEX('%CONSULTA',@nm_tabela) <> 0)
  begin

	  if @tipo_ope = 'D'
	    delete from Codigo_CS -- with (UPDLOCK)
	     where cd_atual  = @cd_codigo
	  else
	    if @tipo_ope = 'L'
	      update Codigo_CS -- with (UPDLOCK)
	      set sg_status = 'L'  
	      where cd_atual  = @cd_codigo

  end
  else
  if (PATINDEX('%COTACAO',@nm_tabela) <> 0)
  begin

	  if @tipo_ope = 'D'
	    delete from Codigo_CT -- with (UPDLOCK)
	     where cd_atual  = @cd_codigo
	  else
	    if @tipo_ope = 'L'
	      update Codigo_CT -- with (UPDLOCK)
	      set sg_status = 'L'  
	      where cd_atual  = @cd_codigo

  end
  else
  begin

	  if @tipo_ope = 'D'
	    delete from Codigo -- with (UPDLOCK)
	     where nm_tabela = @nm_tabela and
	           cd_atual  = @cd_codigo
	  else
	    if @tipo_ope = 'L'
	      update Codigo -- with (UPDLOCK)
	      set sg_status = 'L'  
	      where nm_tabela = @nm_tabela and
	            cd_atual  = @cd_codigo

  end


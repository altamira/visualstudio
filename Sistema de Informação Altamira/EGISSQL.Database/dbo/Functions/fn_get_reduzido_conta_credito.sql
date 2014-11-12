
CREATE FUNCTION fn_get_reduzido_conta_credito
  ( @cd_lancamento_padrao int,
    @cd_tipo_contabilizacao int ) RETURNS int
AS
BEGIN

  declare @nCodigoReduzido as int


	declare @cd_empresa as int
	set @cd_empresa = dbo.fn_empresa()
	

	select top 1
	@nCodigoReduzido = pc_cred.cd_conta_reduzido
	from
	lancamento_padrao lp
	
	inner join plano_conta pc_cred
	on pc_cred.cd_empresa = lp.cd_empresa and
	   pc_cred.cd_conta = lp.cd_conta_credito

	where
	lp.cd_empresa = @cd_empresa
	and
	lp.cd_conta_plano = (select top 1 lpAux.cd_conta_plano
	                     from lancamento_padrao lpAux
	                     where lpAux.cd_empresa = @cd_empresa and
	                           lpAux.cd_lancamento_padrao = @cd_lancamento_padrao)
	and
	lp.cd_tipo_contabilizacao = @cd_tipo_contabilizacao



  return Isnull(@nCodigoReduzido,'')

end

-----------------------------------------------------------------
-- Testando
-----------------------------------------------------------------
/*
select dbo.fn_get_reduzido_conta_credito( 1, 1 ) as 'NF',
       dbo.fn_get_reduzido_conta_credito( 1, 2 ) as 'ICMS',
       dbo.fn_get_reduzido_conta_credito( 1, 3 ) as 'IPI'
*/

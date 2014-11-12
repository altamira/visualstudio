
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EGISSQL
--Objetivo: Executa a rotina de recomposição de saldos, grupo a grupo
--Data: 01/02/2005
-----------------------------------------------------------------------------------------

create procedure pr_executar_recomposicao_saldo
@dt_inicial datetime,
@dt_final datetime,
@cd_usuario int
as

begin

  declare @CodGrupoProduto int
  declare @NomeGrupoProduto varchar(50)
  declare @CodFaseProduto int
  declare @NomeFaseProduto varchar(50)
  declare @DtFechamento datetime

  set @DtFechamento = cast((cast(@dt_inicial as integer) - 1) as datetime)

  declare cRecomposicaoProduto cursor for
	select 
	  gp.cd_grupo_produto,
	  gp.nm_grupo_produto,
	  fp.cd_fase_produto,
	  fp.nm_fase_produto
	from 
	  grupo_produto gp,
	  fase_produto fp,
	  grupo_produto_custo gpc
	where
	  gp.cd_grupo_produto = gpc.cd_grupo_produto and
	  isnull(ic_fechamento_mensal,'S')   = 'S'               and
	  isnull(ic_estoque_grupo_prod,'S' ) = 'S'	
	order by 
	  gp.cd_grupo_produto,
	  fp.cd_fase_produto


  print('Executando Fechamento Mensal de Estoque. Todos os Grupos')

  open cRecomposicaoProduto

  fetch next from cRecomposicaoProduto into @CodGrupoProduto, @NomeGrupoProduto, @CodFaseProduto, @NomeFaseProduto

  while @@fetch_status = 0
  begin

    print('Recompondo Estoque REAL: '+cast(@CodGrupoProduto as varchar)+' - '+@NomeGrupoProduto+' Fase: '+@NomeFaseProduto)

    -- REAL
    exec pr_recomposicao_saldo
      @ic_parametro     = 1, 
      @dt_fechamento    = @DtFechamento,
      @dt_inicial       = @dt_inicial,
      @dt_final         = @dt_final,        
      @cd_produto       = 0,
      @cd_grupo_produto = @CodGrupoProduto,
      @cd_serie_produto = 0,
      @cd_fase_produto  = @CodFaseProduto

    print('Recompondo Estoque RESERVA: '+cast(@CodGrupoProduto as varchar)+' - '+@NomeGrupoProduto+' Fase: '+@NomeFaseProduto)

    -- RESERVA
    exec pr_recomposicao_saldo
      @ic_parametro     = 2, 
      @dt_fechamento    = @DtFechamento,
      @dt_inicial       = @dt_inicial,
      @dt_final         = @dt_final,        
      @cd_produto       = 0,
      @cd_grupo_produto = @CodGrupoProduto,
      @cd_serie_produto = 0,
      @cd_fase_produto  = @CodFaseProduto

    fetch next from cRecomposicaoProduto into @CodGrupoProduto, @NomeGrupoProduto, @CodFaseProduto, @NomeFaseProduto

  end

  close cRecomposicaoProduto
  deallocate cRecomposicaoProduto

end

exec pr_executar_recomposicao_saldo '12/01/2004', '12/31/2004', 999

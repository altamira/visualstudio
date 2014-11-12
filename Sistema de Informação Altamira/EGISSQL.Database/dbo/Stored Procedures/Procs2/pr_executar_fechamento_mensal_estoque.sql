
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EGISSQL
--Objetivo: Executa a rotina de fechamento mensal de estoque, grupo a grupo
--Data: 31/01/2005
--      11/07/2005 - Modificado Filtro dos Grupos para Executar para qualquer grupo que tenha
--                   uma das seguintes condições: Controlar Estoque, Efetuar Fechamento ou
--                   Movimentar Composição - ELIAS
-----------------------------------------------------------------------------------------

create procedure pr_executar_fechamento_mensal_estoque
@dt_inicial datetime,
@dt_final datetime,
@cd_usuario int
as

begin

  declare @CodGrupoProduto int
  declare @NomeGrupoProduto varchar(50)

  declare cFechamentoMensal cursor for
  select 
    gp.cd_grupo_produto,
    gp.nm_grupo_produto
  from 
    grupo_produto gp,
    grupo_produto_custo gpc
  where
    gp.cd_grupo_produto = gpc.cd_grupo_produto and
    (isnull(gpc.ic_fechamento_mensal,'S')   = 'S' or
     isnull(gpc.ic_estoque_grupo_prod,'S' ) = 'S' or
     isnull(gp.ic_baixa_composicao_grupo,'S') = 'S')    
  order by 
    gp.cd_grupo_produto

  print('Executando Fechamento Mensal de Estoque.')

  open cFechamentoMensal

  fetch next from cFechamentoMensal into @CodGrupoProduto, @NomeGrupoProduto

  while @@fetch_status = 0
  begin

    print('Grupo de Produto: '+cast(@CodGrupoProduto as varchar)+' - '+@NomeGrupoProduto)

    exec dbo.pr_fechamento_mensal_estoque  
	@ic_parametro = 3, 
	@dt_inicial = @dt_inicial, 
	@dt_final = @dt_final, 
	@cd_produto = 0, 
	@cd_grupo_produto = @CodGrupoProduto, 
	@cd_serie_produto = null, 
	@cd_departamento = 1, 
	@cd_modulo = 21, 	
	@cd_usuario = @cd_usuario, 
	@ic_mes_fechado = null, 
	@ic_fecha_mes = 'N'

    fetch next from cFechamentoMensal into @CodGrupoProduto, @NomeGrupoProduto

  end

  close cFechamentoMensal
  deallocate cFechamentoMensal

end

--exec pr_executar_fechamento_mensal_estoque '06/01/2005', '06/30/2005', 106

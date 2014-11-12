
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Elias P. Silva
--Banco de Dados: EGISSQL
--Objetivo: Executa a rotina de fechamento real de estoque, grupo a grupo
--Data: 01/08/2005
-----------------------------------------------------------------------------------------

create procedure pr_executar_fechamento_saldo_real
@dt_inicial datetime,
@dt_final datetime,
@cd_usuario int
as

begin

  declare @CodGrupoProduto int
  declare @NomeGrupoProduto varchar(50)

  declare cFechamentoReal cursor for
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

  print('Executando Fechamento Real de Estoque.')

  open cFechamentoReal

  fetch next from cFechamentoReal into @CodGrupoProduto, @NomeGrupoProduto

  while @@fetch_status = 0
  begin

    print('Grupo de Produto: '+cast(@CodGrupoProduto as varchar)+' - '+@NomeGrupoProduto)

    exec pr_fechamento_saldo_real @ic_parametro = 3, 
         	                  @dt_inicial = @dt_inicial, 
                                  @dt_final = @dt_final, 
                                  @cd_produto = 0, 
                                  @cd_grupo_produto = @CodGrupoProduto, 
                                  @cd_serie_produto = null, 
                                  @cd_usuario       = 106
  
    fetch next from cFechamentoReal into @CodGrupoProduto, @NomeGrupoProduto

  end

  close cFechamentoReal
  deallocate cFechamentoReal

end

--exec pr_executar_fechamento_saldo_real '07/01/2005', '07/31/2005', 106

--pr_executar_fechamento_saldo_real







create procedure pr_calculo_custo_processo_padrao_arvore
--------------------------------------------------------------------
-- pr_calculo_custo_processo_padrao_arvore
-------------------------------------------------------------------- 
--GBS - Global Business Solution Ltda                           2004
--------------------------------------------------------------------
--Stored Procedure     : Microsoft SQL Server 2000 
--Autor(es)            : Igor Gama
--Banco de Dados       : EGISSQL 
--Objetivo             : Atualizar a fórmula que está contida em outra fórmula.
--Data                 : 17/09/2004
--Atualização          : 04/01/2005 - Acerto do Cabeçalho - Sérgio Cardoso
--
------------------------------------------------------------------------------ 
@ic_parametro       int,
@cd_processo_padrao int
as

  declare @codigo int

	--Verifica os componentes do processo para saber se possue alguma fórmula para ser atualizada.
  --Tabela temporária para atualizar as demais fórmulas
  Select distinct pppr.cd_processo_padrao
  into #Tabela
  From processo_padrao_produto pppr left outer join produto_producao ppr
       on pppr.cd_processo_padrao <> ppr.cd_processo_padrao and
          pppr.cd_produto = ppr.cd_produto
  Where ppr.cd_processo_padrao = @cd_processo_padrao

  while exists (select 'X' from #tabela)
  begin
    select top 1 @codigo = cd_processo_padrao
    from #tabela

		exec dbo.pr_calculo_custo_processo_padrao
      @ic_parametro = @ic_parametro,
      @cd_processo_padrao = @codigo

    delete #tabela where cd_processo_padrao = @codigo
  end


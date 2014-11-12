
CREATE PROCEDURE pr_consulta_faturamento_produto
---------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Igor Gama
--Banco de Dados: EgisSql
--Objetivo: Consulta para conferência de faturamento.
--Data: 06/01/2003
--Atualizado: 22.04.2004 - Alteração da procedure para pegar valores das views de faturamento. Igor Gama.
---------------------------------------------------
@cd_produto int,
@cd_mes_fiscal int,
@dt_inicial DateTime,
@dt_final   DateTime,
@cd_moeda   int = 1
as
  --Todas as querys com o retorno das notas de faturamento,
  -- estão em uma função de retorno de dados chamada fn_consulta_faturamento_produto_bi
  Declare
    @cd_dia int,
    @cd_mes int,
    @cd_ano int

  Select
    @cd_dia = day  (@dt_inicial), 
    @cd_mes = month(@dt_inicial),
    @cd_ano = year (@dt_inicial)

  Print('Periodo Normal : ' + Convert(varchar, @dt_inicial, 103) + ' até ' + Convert(varchar, @dt_final, 103))
  --Cálculo do faturamento no período desejado.

  Select 
    cd_produto,
    UltimaNota as 'UltimaVenda', 
    Notas as 'Pedidos',
    QtdItem as 'qt_item_nota_saida',
    Venda,
    TotalLiquido,
    vl_ipi,
    vl_icms, 
		Cast(0 as float) qt_acumulada_fat_fiscal,
    Cast(0 as numeric(25,2)) vl_acumulada_fat_fiscal,
    Cast(0 as numeric(25,2)) vl_ipi_acumulado,
    CAst(0 as numeric(25,2)) vl_icms_acumulado
  Into 
  	#FaturaResultado
  From 
    dbo.fn_consulta_faturamento_produto_bi(@dt_inicial, @dt_final, 1)
  Where
    (cd_produto = @cd_produto or @cd_produto = 0)

  If @cd_mes < @cd_mes_fiscal
    Set @cd_ano = (@cd_ano - 1)
  Else 
    Set @cd_ano = @cd_ano

  Set @dt_inicial = Str(@cd_ano) + '-' + str(@cd_mes_fiscal) + '-' + Str(@cd_dia)

  Print('Periodo Fiscal: ' + Convert(varchar, @dt_inicial, 103) + ' até ' + Convert(varchar, @dt_final, 103))

    Declare
      @cd_codigo int,
      @qt_item_nota_saida float,
      @vl_total_nota_saida numeric(25,2),
      @vl_icms_acumulado numeric(25,2),
      @vl_ipi_acumulado  numeric(25,2)

    select * 
    Into #FatAcumulado
    from dbo.fn_consulta_faturamento_produto_bi(@dt_inicial, @dt_final, 1)
    Where (cd_produto = @cd_produto or @cd_produto = 0)

    declare cCursor cursor for

    	Select
        cd_produto
      From
        #FatAcumulado

    open cCursor
    fetch next from cCursor into @cd_codigo

    while (@@FETCH_STATUS =0)
    begin

			Select
			  @qt_item_nota_saida  = QtdItem,
			  @vl_total_nota_saida = Venda,
        @vl_ipi_acumulado    = vl_ipi,
        @vl_icms_acumulado   = vl_icms
			From
			  #FatAcumulado
			Where
		    cd_produto = @cd_codigo
			  
      Update #FaturaResultado
      set 
        qt_acumulada_fat_fiscal = @qt_item_nota_saida,
	      vl_acumulada_fat_fiscal = @vl_total_nota_saida,
        vl_ipi_acumulado        = @vl_ipi_acumulado,
        vl_icms_acumulado       = @vl_icms_acumulado
      Where
        cd_produto = @cd_codigo

      fetch next from cCursor into @cd_codigo
    end
    close cCursor
    deallocate cCursor


  Select  
    p.nm_fantasia_produto,
    a.*
  from 
    #FaturaResultado a
      left outer join
    produto p
      on a.cd_produto = p.cd_produto

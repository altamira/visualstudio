
/****** Object:  Stored Procedure dbo.SPFF_EMPRESTIMO_SELECIONA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPFF_EMPRESTIMO_SELECIONA    Script Date: 25/08/1999 20:11:42 ******/
CREATE PROCEDURE SPFF_EMPRESTIMO_SELECIONA

@DataInicial      smalldatetime,
@DataFinal        smalldatetime,
@Socio            char(1)

AS

Declare @SaldoAteData    money,
        @Sequencia       int,
        @Valor           money


BEGIN


-- Faz a totalizacao do saldo ate a data pedida

Select @SaldoAteData = Isnull(Sum(fimo_Valor), 0)
   From FI_Movimentos
      Where fimo_Conta  = '2'
        AND fimo_Socio  = @Socio
        And fimo_Data < @DataInicial


-- Cria tabela para guardar totais

CREATE TABLE #LinhaTabela(Sequencia    int  Null,
                          Data         smalldatetime Null,
                          Descricao    varchar(30) Null,
                          Valor        money Null,
                          SaldoAtual   money Null)

Declare CurMovimento Insensitive Cursor
   For Select fimo_Sequencia,
              fimo_Valor
      From FI_Movimentos
         Where fimo_Data BETWEEN @DataInicial AND @DataFinal
               AND fimo_Conta  = '2'
               AND fimo_Socio  = @Socio
             Order by fimo_Data


Open CurMovimento

Fetch Next From CurMovimento Into
                                  @Sequencia,
                                  @Valor
   
   While @@FETCH_STATUS = 0

       Begin


       -- Acumula o valor ate o saldo
       Select @SaldoAteData = @SaldoAteData + @Valor


       Insert into #LinhaTabela(Sequencia,
                                Data,
                                Descricao,
                                Valor,
                                SaldoAtual)

                         Select fimo_Sequencia,
                                fimo_Data,
                                fimo_Descricao,
                                fimo_Valor,
                                @SaldoAteData
                           From FI_Movimentos
                            Where fimo_Sequencia = @Sequencia

               Fetch Next From CurMovimento Into
                                                 @Sequencia,
                                                 @Valor


       End

Close CurMovimento
Deallocate CurMovimento


     SELECT * FROM #LinhaTabela ORDER BY Data
            
   
End


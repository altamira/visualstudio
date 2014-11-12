
/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_LEITURA    Script Date: 23/10/2010 13:58:22 ******/

/****** Object:  Stored Procedure dbo.SPFN_POSICAOBANCARIA_LEITURA    Script Date: 11/11/1999 14:56:43 ******/
CREATE PROCEDURE SPFN_POSICAOBANCARIA_LEITURA

@DataPeriodo    smalldatetime,
@Banco          char(3)
AS

BEGIN

Declare @DataInicial   smalldatetime,
        @BancoVolta char(3),
        @Valor         money
 
-- define data inicial

Select @DataInicial = @DataPeriodo

SELECT fnpb_Data,fnpb_Banco, fnpb_Valor
          FROM FN_PosBancaria
         WHERE fnpb_Data = @DataInicial AND fnpb_Banco = @Banco 
         Order by fnpb_data
END

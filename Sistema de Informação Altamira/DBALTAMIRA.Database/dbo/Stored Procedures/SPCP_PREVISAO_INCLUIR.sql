
/****** Object:  Stored Procedure dbo.SPCP_PREVISAO_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPCP_PREVISAO_INCLUIR    Script Date: 25/08/1999 20:11:49 ******/
CREATE PROCEDURE SPCP_PREVISAO_INCLUIR

   @Sequencia  int,
   @Tipo       char(1),
   @Descricao  smallint,
   @Fornecedor char(14),
   @Parcela    char(7),
   @DataVencimento smalldatetime,
   @Valor      money,
   @Valida      smallint,
   @Observacao varchar(40)

AS

BEGIN

	INSERT INTO CP_Previsao (cppr_Sequencia,
			                 cppr_Tipo,
                             cppr_Descricao,
                             cppr_Fornecedor,
                             cppr_Parcela,
                             cppr_DataVencimento,
                             cppr_Valor,
                             cppr_Valida,
                             cppr_Observacao)
		      VALUES (@Sequencia,
			          @Tipo,
			          @Descricao,
			          @Fornecedor,
			          @Parcela,
			          @DataVencimento,
                      @Valor,
                      @Valida,
			          @Observacao)

END




/****** Object:  Stored Procedure dbo.SPCP_PREVISAO_ALTERAR    Script Date: 23/10/2010 15:32:29 ******/


/****** Object:  Stored Procedure dbo.SPCP_PREVISAO_ALTERAR    Script Date: 25/08/1999 20:11:49 ******/
CREATE PROCEDURE SPCP_PREVISAO_ALTERAR

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

   UPDATE CP_Previsao 
      SET cppr_Tipo           = @Tipo,
          cppr_Descricao      = @Descricao,
          cppr_Fornecedor     = @Fornecedor,
          cppr_Parcela        = @Parcela,
          cppr_DataVencimento = @DataVencimento,
          cppr_Valor          = @Valor,
          cppr_Valida          = @Valida,
          cppr_Observacao     = @Observacao  

    WHERE cppr_Sequencia = @Sequencia

END







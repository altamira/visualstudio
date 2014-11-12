
/****** Object:  Stored Procedure dbo.SPFN_PREVISAO_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_PREVISAO_INCLUIR    Script Date: 25/08/1999 20:11:36 ******/
CREATE PROCEDURE SPFN_PREVISAO_INCLUIR

   @Sequencia  int,
   @Tipo       char(1),
   @Data       smalldatetime,
   @Descricao  varchar(50),
   @Valor      money
   
AS

BEGIN

	INSERT INTO FN_Previsao (fnpr_Sequencia,
			                 fnpr_Tipo,
                             fnpr_Data,
                             fnpr_Descricao,
                             fnpr_Valor)
                             
		      VALUES (@Sequencia,
			          @Tipo,
                      @Data,
			          @Descricao,
			          @Valor)
			         
END



/****** Object:  Stored Procedure dbo.SPFF_PREVISAO_INCLUIR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_PREVISAO_INCLUIR    Script Date: 25/08/1999 20:11:34 ******/
/****** Object:  Stored Procedure dbo.SPFF_PREVISAO_INCLUIR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_PREVISAO_INCLUIR

   @Sequencia  int,
   @Tipo       char(1),
   @Data       smalldatetime,
   @Descricao  varchar(50),
   @Valor      money
   
AS

BEGIN

	INSERT INTO FF_Previsao (ffpr_Sequencia,
			                 ffpr_Tipo,
                             ffpr_Data,
                             ffpr_Descricao,
                             ffpr_Valor)
                             
		      VALUES (@Sequencia,
			          @Tipo,
                      @Data,
			          @Descricao,
			          @Valor)
			         
END




/****** Object:  Stored Procedure dbo.SPFN_PREVISAO_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_PREVISAO_ALTERAR    Script Date: 25/08/1999 20:11:35 ******/
CREATE PROCEDURE SPFN_PREVISAO_ALTERAR

   @Sequencia  int,
   @Tipo       char(1),
   @Data       smalldatetime,
   @Descricao  varchar(50),
   @Valor      money

AS

BEGIN

   UPDATE FN_Previsao 
      SET fnpr_Tipo       = @Tipo,
          fnpr_Data       = @Data,
          fnpr_Descricao  = @Descricao,
          fnpr_Valor      = @Valor
          
    WHERE fnpr_Sequencia = @Sequencia

END








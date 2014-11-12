﻿
/****** Object:  Stored Procedure dbo.SPFF_PREVISAO_ALTERAR    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFF_PREVISAO_ALTERAR    Script Date: 25/08/1999 20:11:34 ******/
/****** Object:  Stored Procedure dbo.SPFF_PREVISAO_ALTERAR    Script Date: 25/09/1998 10:07:32 ******/
CREATE PROCEDURE SPFF_PREVISAO_ALTERAR

   @Sequencia  int,
   @Tipo       char(1),
   @Data       smalldatetime,
   @Descricao  varchar(50),
   @Valor      money

AS

BEGIN

   UPDATE FF_Previsao 
      SET ffpr_Tipo       = @Tipo,
          ffpr_Data       = @Data,
          ffpr_Descricao  = @Descricao,
          ffpr_Valor      = @Valor
          
    WHERE ffpr_Sequencia = @Sequencia

END









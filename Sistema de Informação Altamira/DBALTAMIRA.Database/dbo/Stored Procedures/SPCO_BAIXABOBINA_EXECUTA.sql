
/****** Object:  Stored Procedure dbo.SPCO_BAIXABOBINA_EXECUTA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCO_BAIXABOBINA_EXECUTA    Script Date: 25/08/1999 20:11:46 ******/
CREATE PROCEDURE SPCO_BAIXABOBINA_EXECUTA

   @CodigoBobina    char(9),       -- Codigo do produto do item
   @Quantidade      numeric(18,3),         -- Quantidade que foi baixada
   @DataBaixa       smalldatetime  -- Data da entrada do produto
   
AS


	BEGIN

      
      SELECT @Quantidade
      
      INSERT INTO CO_HistoricoBobina(cohb_Codigo,
                                     cohb_Movimento,
                                     cohb_Data,
                                     cohb_Quantidade)

                        VALUES(@CodigoBobina,
                               'S',
                               @DataBaixa,
                               @Quantidade)


       UPDATE CO_Almoxarifado
          SET coal_Saldo  = coal_Saldo - @Quantidade
        WHERE coal_Codigo = @CodigoBobina
          
   END




/****** Object:  Stored Procedure dbo.SPCO_BAIXACHAPA_EXECUTA    Script Date: 23/10/2010 15:32:30 ******/

/****** Object:  Stored Procedure dbo.SPCO_BAIXACHAPA_EXECUTA    Script Date: 16/10/01 13:41:42 ******/
/****** Object:  Stored Procedure dbo.SPCO_BAIXACHAPA_EXECUTA    Script Date: 05/01/1999 11:03:42 ******/
CREATE PROCEDURE SPCO_BAIXACHAPA_EXECUTA

   @CodigoChapa     char(9),       -- Codigo do produto do item
   @Quantidade      numeric(18,3), -- Quantidade que foi baixada
   @DataBaixa       smalldatetime  -- Data da entrada do produto
   
AS


	BEGIN

      
      SELECT @Quantidade
      
      INSERT INTO CO_HistoricoChapa(cohc_Codigo,
                                    cohc_Movimento,
                                    cohc_Data,
                                    cohc_Quantidade)

                        VALUES(@CodigoChapa,
                               'S',
                               @DataBaixa,
                               @Quantidade)


       UPDATE CO_Almoxarifado
          SET coal_Saldo  = coal_Saldo - @Quantidade
        WHERE coal_Codigo = @CodigoChapa
          
   END



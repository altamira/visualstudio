
/****** Object:  Stored Procedure dbo.SPCP_SINALPEDIDO_EXCLUIR    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_SINALPEDIDO_EXCLUIR    Script Date: 25/08/1999 20:11:23 ******/
CREATE PROCEDURE SPCP_SINALPEDIDO_EXCLUIR

    @Sequencia                 int


AS


BEGIN

    DELETE FROM CP_SinalPedido
          WHERE cpsp_sequencia = @Sequencia



END


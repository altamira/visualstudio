
/****** Object:  Stored Procedure dbo.SPCP_OPSINALNAO_RELATORIO    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_OPSINALNAO_RELATORIO    Script Date: 25/08/1999 20:11:49 ******/
CREATE PROCEDURE SPCP_OPSINALNAO_RELATORIO

AS

Declare @Sequencia       int,
        @NumeroOP     int 
        
BEGIN

Create Table #TabNotaFiscal(cofc_Nome               char(40) Null,
                            cofc_DDDTelefone        char(4)  Null,
                            cofc_Telefone           char(10) Null,
                            cofc_DDDFax             char(4)  Null,
                            cofc_Fax                char(10) Null,
                            cofc_Codigo             char(14) Null,
                            cpsp_Pedido             int      Null,
                            cpsp_DataVencimento     smalldatetime Null,
                            cpsp_Observacao         varchar(50) Null,
                            cpsp_Valor              money Null, 
                            cpsp_NumeroOP           Int   null,
                            cpsp_DataOP             smalldatetime Null)

Declare CurSinalPedido Insensitive Cursor
For Select cpsp_Sequencia 
       From CP_SinalPedido
     Where cpsp_NumeroOP Is Null

Open CurSinalPedido 
   
   Fetch Next From CurSinalPedido 
     Into @Sequencia

     While @@Fetch_Status = 0
       
       Begin
          
          Select @NumeroOP = SI_Valor + 1
             From SI_Auxiliar
             Where si_Nome = 'cpop_NumeroOP'

          Update SI_Auxiliar 
              Set si_Valor = si_Valor + 1
             Where si_Nome = 'cpop_NumeroOP'

          Update CP_SinalPedido 
             Set cpsp_NumeroOP = @NumeroOP,
                 cpsp_DataOP = GetDate()
             Where cpsp_Sequencia = @Sequencia

          Insert into #TabNotaFiscal 

           Select cofc_Nome,
                  cofc_DDDTelefone,
                  cofc_Telefone,
                  cofc_DDDFax,
                  cofc_Fax,
                  cofc_Codigo,
                  cpsp_Pedido,
                  cpsp_DataVencimento,
                  cpsp_Observacao,
                  cpsp_Valor,
                  cpsp_NumeroOP,
                  cpsp_DataOP

               FROM  CO_Fornecedor, 
                     CO_Pedido,
                     CP_SinalPedido

               WHERE cpsp_Sequencia = @Sequencia
                 AND cope_Numero = cpsp_Pedido
                 AND cofc_Codigo = cope_Fornecedor

         Fetch Next From CurSinalPedido
                Into @Sequencia

       End


      CLOSE  CurSinalPedido
  DEALLOCATE CurSinalPedido


   SELECT * 
     FROM #TabNotaFiscal

END	


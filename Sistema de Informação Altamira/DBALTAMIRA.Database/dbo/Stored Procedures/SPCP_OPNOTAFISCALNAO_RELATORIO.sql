
/****** Object:  Stored Procedure dbo.SPCP_OPNOTAFISCALNAO_RELATORIO    Script Date: 23/10/2010 13:58:20 ******/


/****** Object:  Stored Procedure dbo.SPCP_OPNOTAFISCALNAO_RELATORIO    Script Date: 25/08/1999 20:11:55 ******/
CREATE PROCEDURE SPCP_OPNOTAFISCALNAO_RELATORIO
	@Atualiza Char(1)
AS

Declare @Codigo       	char(14),
        	@TipoNota     	char(1),
        	@NotaFiscal   	char(6),
        	@Parcela      	smallint,
        	@Pedido       	int,
        	@NumeroOP   	int 
        
BEGIN

Create Table #TabNotaFiscal(cofc_Nome char(40) Null,
                            cofc_DDDTelefone        char(4)  Null,
                            cofc_Telefone           	char(10) Null,
                            cofc_DDDFax             	char(4)  Null,
                            cofc_Fax                	char(10) Null,
                            cpnf_NotaFiscal         	char(6)  Null, 
                            cpnf_Fornecedor         	char(14) Null,
                            cpnf_DataEntrada        	smalldatetime Null,
                            cpnf_ValorTotal         	money    Null,
                            cpnf_Parcelas           	smallint Null,
                            cpnd_Parcela            	smallint Null,
                            cpnd_DataVencimento  smalldatetime Null,
                            cpnd_DataProrrogacao smalldatetime Null,
                            cpnd_Observacao         varchar(50) Null,
                            cpnd_Valor              	money Null, 
                            cpnd_ValorMulta         	money Null,
                            cpnd_ValorDesconto      money Null,
                            cpnd_ValorTotal         	money Null,
                            cpnd_Duplicata          	char(7) Null,
                            cpnd_NumeroOP           Int   null,
                            cpnd_DataOP             	smalldatetime Null,
                            AuxChave                	varchar(40) null)

Declare CurNotaFiscal Insensitive Cursor
For Select cpnd_Fornecedor, 
           cpnd_TipoNota,
           cpnd_NotaFiscal,
           cpnd_Parcela,
           cpnd_Pedido
     From CP_NotaFiscalDetalhe
     Where cpnd_NumeroOP Is Null

Open CurNotaFiscal 
   
   Fetch Next From CurNotaFiscal 
     Into @Codigo, @TipoNota, @NotaFiscal, @Parcela, @Pedido

     While @@Fetch_Status = 0
       
       Begin
          
          Select @NumeroOP = SI_Valor + 1
             From SI_Auxiliar
             Where si_Nome = 'cpop_NumeroOP'

	/*If @Atualiza = 'S'
	'Begin*/          		Update SI_Auxiliar 
              	Set si_Valor = si_Valor + 1
             		Where si_Nome = 'cpop_NumeroOP'

          		Update CP_NotaFiscalDetalhe 
             		Set 	cpnd_NumeroOP = @NumeroOP,
                 		cpnd_DataOP = GetDate()
             		Where 	cpnd_Fornecedor = @Codigo
               	And 	cpnd_TipoNota = @TipoNota
               	And 	cpnd_NotaFiscal = @NotaFiscal
               	And 	cpnd_Parcela = @Parcela
               	And 	cpnd_Pedido = @Pedido
	/*End*/
          Insert into #TabNotaFiscal 

           Select cofc_Nome,
                  cofc_DDDTelefone,
                  cofc_Telefone,
                  cofc_DDDFax,
                  cofc_Fax,
                  cpnf_NotaFiscal, 
                  cpnf_Fornecedor,
                  cpnf_DataEntrada,
                  cpnf_ValorTotal,
                  cpnf_Parcelas,
                  cpnd_Parcela,
                  cpnd_DataVencimento,
                  cpnd_DataProrrogacao,
                  cpnd_Observacao,
                  cpnd_Valor,
                  cpnd_ValorMulta,
                  cpnd_ValorDesconto,
                  cpnd_ValorTotal,
                  cpnd_Duplicata,
                  cpnd_NumeroOP,
                  cpnd_DataOP,
                  cofc_Codigo + cpnf_TipoNota + cpnf_NotaFiscal + convert(varchar, cpnd_Parcela) + convert(varchar, cpnd_Pedido)

               FROM  CO_Fornecedor, 
                     CP_NotaFiscal,
                     CP_NotaFiscalDetalhe

               WHERE cpnd_Fornecedor = @Codigo
                 AND cpnd_TipoNota   = @TipoNota
                 AND cpnd_NotaFiscal = @NotaFiscal
                 AND cpnd_Parcela    = @Parcela
                 AND cpnd_Pedido     = @Pedido
                 AND cpnf_Fornecedor = cpnd_Fornecedor
                 AND cpnf_NotaFiscal = cpnd_NotaFiscal
                 AND cpnf_TipoNota   = cpnd_TipoNota
                 AND cpnf_Pedido     = cpnd_Pedido
                 AND cofc_Codigo     = cpnf_Fornecedor

         Fetch Next From CurNotaFiscal
                Into @Codigo,
                     @TipoNota,
                     @NotaFiscal,
                     @Parcela,
                     @Pedido

       End


      CLOSE  curNotaFiscal
  DEALLOCATE curNotaFiscal


   SELECT * 
     FROM #TabNotaFiscal

END	





/****** Object:  Stored Procedure dbo.SPPR_ORCAMENTOS_RELATORIO    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPPR_ORCAMENTOS_RELATORIO    Script Date: 25/08/1999 20:11:44 ******/
CREATE PROCEDURE SPPR_ORCAMENTOS_RELATORIO

@DataInicial         smalldatetime,
@DataFinal           smalldatetime,  
@Representante       char(3)
      
AS
	

Begin

    
    SELECT pror_DataOrcamento,
           pror_NomeCliente,
           pror_Numero,
           pror_Projeto,
          /***' (pror_ValorEstante + pror_ValorPortaPalete + pror_ValorMezanino + pror_ValorPainel + pror_ValorDriveIn + pror_ValorOutrosProdutos + pror_valorPrestacaoServico) 'ValorTotal','*****/
           pror_Telefone1,
           pror_Contato,
           pror_numPedido           
      
      FROM PRE_Orcamentos

     WHERE pror_DataOrcamento BETWEEN @DataInicial AND @DataFinal
       AND pror_Representante  = @Representante
          ORDER BY pror_DataOrcamento

       
End





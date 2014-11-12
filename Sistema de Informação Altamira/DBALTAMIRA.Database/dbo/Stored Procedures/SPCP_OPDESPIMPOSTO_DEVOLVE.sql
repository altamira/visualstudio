
/****** Object:  Stored Procedure dbo.SPCP_OPDESPIMPOSTO_DEVOLVE    Script Date: 23/10/2010 13:58:20 ******/

/****** Object:  Stored Procedure dbo.SPCP_OPDESPIMPOSTO_DEVOLVE    Script Date: 25/10/2001  20:11:48 ******/
CREATE PROCEDURE SPCP_OPDESPIMPOSTO_DEVOLVE

       @NumeroOP     int

AS

BEGIN

             -- Atualiza o n uemro da OP
             UPDATE SI_Auxiliar
                SET si_Valor = @NumeroOp
              WHERE si_nome = 'cpop_NumeroOP'

             -- Atualiza o numero da OP na tabela de Despesa e imposto
             UPDATE CP_DespesaImpostoDetalhe
             SET 	  cpdd_NumeroOP = Null,
                    	  cpdd_DataOP   = Null
              WHERE cpdd_NumeroOp > @NumeroOp
        
        END





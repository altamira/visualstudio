
/****** Object:  Stored Procedure dbo.SPFN_CALCPREVBANCO_CONSULTA    Script Date: 23/10/2010 13:58:22 ******/


/****** Object:  Stored Procedure dbo.SPFN_CALCPREVBANCO_CONSULTA    Script Date: 25/08/1999 20:11:51 ******/
CREATE PROCEDURE SPFN_CALCPREVBANCO_CONSULTA

AS

BEGIN

  SELECT ffba_NomeBanco, 
       ffcc_Agencia, 
       ffcc_Conta,
       ISNULL(SUM(ffmv_Valor), 0) + ffcc_SaldoInicial Saldo

  FROM FF_MovimentoCC LEFT JOIN FF_CONTACORRENTE ON ffmv_Banco = ffcc_Banco
   AND ffmv_Agencia = ffcc_Agencia
   AND ffmv_Conta = ffcc_Conta,
 
       FF_Bancos

 WHERE ffcc_Previsao = '1'
     AND ffba_Codigo = ffcc_Banco

GROUP BY ffba_NomeBanco,
         ffcc_Agencia,
         ffcc_Conta,
         ffcc_SaldoInicial

ORDER BY ffba_NomeBanco

END






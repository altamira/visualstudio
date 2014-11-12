
/****** Object:  Stored Procedure dbo.SPVE_COMISSAOGRAFICO_CONSULTA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_COMISSAOGRAFICO_CONSULTA    Script Date: 25/08/1999 20:11:27 ******/
CREATE PROCEDURE SPVE_COMISSAOGRAFICO_CONSULTA

   @DataInicial      smalldatetime,
   @DataFinal        smalldatetime

AS
	
   DECLARE @Total001      money,    
           @Total002      money,    
           @Total003      money,     
           @Total004      money,
           @Total005      money,
           @Total006      money,
           @Total007      money,
           @Total008      money,
           @Total009      money,
           @Total010      money,
           @Total011      money,
           @Total012      money

BEGIN

   SELECT @Total001 = SUM(vepe_ValorVenda + vepe_ValorServico) 
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '001'

   SELECT @Total002 = SUM(vepe_ValorVenda + vepe_ValorServico) 
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '002'

   SELECT @Total003 = SUM(vepe_ValorVenda + vepe_ValorServico) 
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '003'

   SELECT @Total004 = SUM(vepe_ValorVenda + vepe_ValorServico) 
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '004'

   SELECT @Total005 = SUM(vepe_ValorVenda + vepe_ValorServico) 
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '005'
 
   SELECT @Total006 = SUM(vepe_ValorVenda + vepe_ValorServico)  
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '006'
   
   SELECT @Total007 = SUM(vepe_ValorVenda + vepe_ValorServico)  
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '007'

   SELECT @Total008 = SUM(vepe_ValorVenda + vepe_ValorServico) 
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '008'
   
   SELECT @Total009 = SUM(vepe_ValorVenda + vepe_ValorServico) 
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '009'
   
   SELECT @Total010 = SUM(vepe_ValorVenda + vepe_ValorServico) 
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '010'

   SELECT @Total011 = SUM(vepe_ValorVenda + vepe_ValorServico)  
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '011'

   SELECT @Total012 = SUM(vepe_ValorVenda + vepe_ValorServico) 
      FROM VE_Pedidos
         WHERE vepe_DataPedido BETWEEN @DataInicial AND @DataFinal
             AND vepe_Representante = '012'


   CREATE TABLE #TabComissao(Representante char(3),
                             Total         money)


   INSERT INTO #TabComissao Values ('001', ISNULL(@Total001, 0))
   INSERT INTO #TabComissao Values ('002', ISNULL(@Total002, 0))
   INSERT INTO #TabComissao Values ('003', ISNULL(@Total003, 0))
   INSERT INTO #TabComissao Values ('004', ISNULL(@Total004, 0))
   INSERT INTO #TabComissao Values ('005', ISNULL(@Total005, 0))
   INSERT INTO #TabComissao Values ('006', ISNULL(@Total006, 0))
   INSERT INTO #TabComissao Values ('007', ISNULL(@Total007, 0))
   INSERT INTO #TabComissao Values ('008', ISNULL(@Total008, 0))
   INSERT INTO #TabComissao Values ('009', ISNULL(@Total009, 0))
   INSERT INTO #TabComissao Values ('010', ISNULL(@Total010, 0))
   INSERT INTO #TabComissao Values ('011', ISNULL(@Total011, 0))
   INSERT INTO #TabComissao Values ('012', ISNULL(@Total012, 0))

   SELECT * FROM #TabComissao ORDER BY Representante

   
END



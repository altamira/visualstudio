
/****** Object:  Stored Procedure dbo.SPVE_COMISSAOGRAFANO_CONSULTA    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPVE_COMISSAOGRAFANO_CONSULTA    Script Date: 25/08/1999 20:11:27 ******/
CREATE PROCEDURE [dbo].[SPVE_COMISSAOGRAFANO_CONSULTA]

   @Representante       char(3),
   @Ano                 int

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
           @Total011      money,           @Total012      money,

           @TotalR001     money,           @TotalR002     money,           @TotalR003     money,           @TotalR004     money,           @TotalR005     money,           @TotalR006     money,           @TotalR007     money,           @TotalR008     money,           @TotalR009     money,           @TotalR010     money,           @TotalR011     money,           @TotalR012     money
BEGIN

   SELECT @Total001 = SUM(crnd_BaseCalculo * crnd_Comissao / 100) 
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 1
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR001 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 1
           AND  crre_Representante = @Representante

   SELECT @Total002 = SUM(crnd_BaseCalculo * crnd_Comissao / 100) 
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 2
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR002 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 2
           AND  crre_Representante = @Representante
   
   SELECT @Total003 = SUM(crnd_BaseCalculo * crnd_Comissao / 100) 
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 3
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
   		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR003 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 3
           AND  crre_Representante = @Representante
       
   SELECT @Total004 = SUM(crnd_BaseCalculo * crnd_Comissao / 100) 
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 4
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR004 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 4
           AND  crre_Representante = @Representante

   SELECT @Total005 = SUM(crnd_BaseCalculo * crnd_Comissao / 100)  
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 5
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR005 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 5
           AND  crre_Representante = @Representante
      
   SELECT @Total006 = SUM(crnd_BaseCalculo * crnd_Comissao / 100)  
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 6
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR006 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 6
           AND  crre_Representante = @Representante
   
   SELECT @Total007 = SUM(crnd_BaseCalculo * crnd_Comissao / 100) 
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 7
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR007 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 7
           AND  crre_Representante = @Representante
       
   SELECT @Total008 = SUM(crnd_BaseCalculo * crnd_Comissao / 100)  
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 8
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR008 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 8
           AND  crre_Representante = @Representante

   SELECT @Total009 = SUM(crnd_BaseCalculo * crnd_Comissao / 100) 
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 9
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR009 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 9
           AND  crre_Representante = @Representante
       
   SELECT @Total010 = SUM(crnd_BaseCalculo * crnd_Comissao / 100) 
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 10
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR010 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 10
           AND  crre_Representante = @Representante
   
   SELECT @Total011 = SUM(crnd_BaseCalculo * crnd_Comissao / 100) 
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 11
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR011 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 11
           AND  crre_Representante = @Representante
       
   SELECT @Total012 =SUM(crnd_BaseCalculo * crnd_Comissao / 100)  
      FROM CR_NotasFiscaisDetalhe
         WHERE crnd_Representante = @Representante
           AND DATEPART(Year, crnd_DataBaixaRepres) = @Ano
           AND DATEPART(Month, crnd_DataBaixaRepres) = 12
           AND ((crnd_TipoFaturamento = '4') OR (crnd_TipoFaturamento = '5'))
		   AND crnd_DataPagamento <> ''
		   AND crnd_TipoNota='S'
    SELECT @TotalR012 =  sum(crre_BaseCalculo * crre_Comissao / 100)
      FROM  CR_Recibos
         WHERE  DATEPART(Year, crre_DataBaixaRepr) = @Ano
		   AND  DATEPART(Month, crre_DataBaixaRepr) = 12
           AND  crre_Representante = @Representante



   CREATE TABLE #TabComissao(Mes          char(3),
                             Total        money)


   INSERT INTO #TabComissao Values ('JAN', ISNULL(@Total001, 0) + ISNULL(@TotalR001, 0))
   INSERT INTO #TabComissao Values ('FEV', ISNULL(@Total002, 0) + ISNULL(@TotalR002, 0))
   INSERT INTO #TabComissao Values ('MAR', ISNULL(@Total003, 0) + ISNULL(@TotalR003, 0))
   INSERT INTO #TabComissao Values ('ABR', ISNULL(@Total004, 0) + ISNULL(@TotalR004, 0))
   INSERT INTO #TabComissao Values ('MAI', ISNULL(@Total005, 0) + ISNULL(@TotalR005, 0))
   INSERT INTO #TabComissao Values ('JUN', ISNULL(@Total006, 0) + ISNULL(@TotalR006, 0))
   INSERT INTO #TabComissao Values ('JUL', ISNULL(@Total007, 0) + ISNULL(@TotalR007, 0))
   INSERT INTO #TabComissao Values ('AGO', ISNULL(@Total008, 0) + ISNULL(@TotalR008, 0))
   INSERT INTO #TabComissao Values ('SET', ISNULL(@Total009, 0) + ISNULL(@TotalR009, 0))
   INSERT INTO #TabComissao Values ('OUT', ISNULL(@Total010, 0) + ISNULL(@TotalR010, 0))
   INSERT INTO #TabComissao Values ('NOV', ISNULL(@Total011, 0) + ISNULL(@TotalR011, 0))
   INSERT INTO #TabComissao Values ('DEZ', ISNULL(@Total012, 0) + ISNULL(@TotalR012, 0))

   SELECT * FROM #TabComissao 

   
END



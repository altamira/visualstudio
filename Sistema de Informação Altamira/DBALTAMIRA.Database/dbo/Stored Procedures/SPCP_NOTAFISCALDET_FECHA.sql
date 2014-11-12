
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_FECHA    Script Date: 23/10/2010 13:58:21 ******/
/****** Object:  Stored Procedure dbo.SPCP_NOTAFISCALDET_FECHA    Script Date: 18/10/2001 13:53:00 ******/
CREATE PROCEDURE SPCP_NOTAFISCALDET_FECHA
    @NotaFiscal         char(6)

AS

BEGIN

  UPDATE cp_notafiscal Set cpnf_JaIncluso = 'F'  Where cpnf_NotaFiscal = @NotaFiscal

END












CREATE PROCEDURE CONTMATIC_EXPORT_PARTICIPANTES
AS
/*
C:\Users\Alessandro.Holanda\Documents\Altamira Industria Metalurgica\Contabilidade\Cadastros\Empresas.txt
*/

SET NOCOUNT ON

SELECT [REGISTRO] FROM [GPIMAC_Altamira].[dbo].[CONTMATIC_EMPRESA]

EXEC xp_cmdshell 'bcp "SET NOCOUNT ON; SELECT [REGISTRO] FROM [GPIMAC_Altamira].[dbo].[CONTMATIC_EMPRESA]" queryout "C:\Pastas Compartilhadas\Departamentos\Contabilidade\Cadastro\Empresas.txt" -T -SSERVIDOR -c -t,'


-- =============================================
-- Author:		Denis André
-- Create date: 27/09/2012
-- Description:	Retornar o Status Atual do Item
--              do Romaneio
-- =============================================
CREATE FUNCTION [dbo].[GPFN_RetornarStatusDoItemDoRomaneio]
(
	-- Parâmetros
	@RomaneioEmpresa					NVARCHAR(02),
	@RomaneioNumero						INT,
	@OPEmpresa							NVARCHAR(02),
	@OpNumero							INT,
	@MaterialCodigo						NVARCHAR(60)
)
RETURNS NVARCHAR(10)
AS
BEGIN
	-- Variável de Retorno
	DECLARE @StatusDoItemDoRomaneio		NVARCHAR(10)

	-- Outras Variáveis
	DECLARE
		@Baixado		NVARCHAR(01),
		@Iniciado		NVARCHAR(01)
		
	-- Add the T-SQL statements to compute the return value here
	SELECT TOP 01
		@Baixado  = LTRIM(RTRIM(UPPER(OPR1Bai ) ) ),
		@Iniciado = LTRIM(RTRIM(UPPER(OPR1Ini ) ) )
	FROM dbo.OPROMITEM
		WHERE	OPR0Emp		= @RomaneioEmpresa
		AND		OPR0Cod		= @RomaneioNumero
		AND		OPR1OPEmp	= @OPEmpresa
		AND		OPR1OPCod	= @OpNumero
		AND		OPR1CPbCod	= @MaterialCodigo


/*
    do case
        case OPR1Bai = 'S'
            &Status = &SimboloOk
        case OPR1Bai = 'P'
            &Status = &SimboloPause
        case OPR1Bai = 'N'
            if OPR1Ini = 'S'
                &Status = &SimboloPlay
            else
                &Status = &SimboloStop
            endif
    otherwise
        &Status = ''        
    endcase
*/		
	SET @Baixado	= ISNULL(@Baixado,  'N' )
	SET @Iniciado	= ISNULL(@Iniciado, 'N' )

	IF		@Baixado	= 'S'
				SET @StatusDoItemDoRomaneio	= 'CONCLUIDO'
		
	ELSE IF	@Baixado	= 'P'
				SET @StatusDoItemDoRomaneio = 'PAUSADO'
		
	ELSE --	@Baixado	= 'N'
		BEGIN
			IF		@Iniciado	= 'S'
				SET	@StatusDoItemDoRomaneio	= 'INICIADO'
				
			ELSE
				SET @StatusDoItemDoRomaneio	= 'PARADO'
				
	END


	SET @StatusDoItemDoRomaneio =LTRIM(RTRIM(UPPER(ISNULL(@StatusDoItemDoRomaneio, 'PARADO' ) ) ) )
	
	-- Return the result of the function
	RETURN @StatusDoItemDoRomaneio

END

GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPFN_RetornarStatusDoItemDoRomaneio] TO [interclick]
    AS [dbo];


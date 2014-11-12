
-- =====================================================
-- Author:		Denis André
-- Create date: 13/09/2012
-- Description:	Rotina Auximiar 02 da procedure
--				RetornarSituacaoParaOPedidoDeVenda
-- =====================================================
CREATE PROCEDURE [dbo].[GPSP_RetornarSituacaoParaOPedidoDeVendaAux02]
	-- Parâmetros da Procedure
	@Empresa				NVARCHAR(02),			-- LpEmp
	@PedidoDeVenda			INT,					-- LpPed
	@Sequencia				SMALLINT		OUTPUT,	-- LpEt2Seq
	@Situacao				NVARCHAR(50)	OUTPUT,	-- LPEt2Des
	@DataDaSituacao			DATETIME		OUTPUT, -- LPEt2IniDat 
	@UsuarioDaSituacao		NVARCHAR(20)	OUTPUT  -- LPEt2IniUsuCri
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @DataNulaGPIMAC	DATETIME

	SET @DataNulaGPIMAC			= CAST('1753-01-01' AS DATETIME )
	SET @Situacao				= ''
	SET @DataDaSituacao			= @DataNulaGPIMAC
	SET @UsuarioDaSituacao		= ''
	
	-- criar um cursor
	DECLARE CURSOR_SITUACAO_PEDIDO_DE_VENDA CURSOR STATIC FOR
	SELECT 
		LPEt2Seq, 
		CAST(LTRIM(RTRIM(LPEt2Des       ) ) AS NVARCHAR(50) ), 
		ISNULL(LPEt2IniDat, '1753-01-01' ), 
		CAST(LTRIM(RTRIM(LPEt2IniUsuCri	) ) AS NVARCHAR(50) )
	FROM	LPVSITETAPA
	WHERE	LPEMP		= @Empresa
	AND		LPPED		= @PedidoDeVenda
	AND		LPEt2Seq	< 70
	ORDER BY LPEMP ASC, LPPED ASC, LPEt2Seq ASC

	-- ler o cursor e verificar as consistências
	DECLARE @c_LPEt2Seq			SMALLINT, 
			@c_LPEt2Des			NVARCHAR(50), 
			@C_LPEt2IniDat		DATETIME, 
			@c_LPEt2IniUsuCri	NVARCHAR(20 ),
			@c_LpEt2PorConc     MONEY
			
	OPEN CURSOR_SITUACAO_PEDIDO_DE_VENDA 
	FETCH NEXT FROM CURSOR_SITUACAO_PEDIDO_DE_VENDA 
	INTO @c_LPEt2Seq, @c_LPEt2Des, @C_LPEt2IniDat, @c_LPEt2IniUsuCri
	
	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @C_LPEt2IniDat = @DataNulaGPIMAC
		BEGIN
			IF NOT (@c_LPEt2Seq = 20 OR @c_LPEt2Seq = 50 )
			BEGIN
			
				BREAK -- Igual ao Exit do GeneXus
				
			END -- IF NOT (@c_LPEt2Seq = 20 OR @c_LPEt2Seq = 50 )
		END
		ELSE
		BEGIN
			
			IF @c_LPEt2Seq > 20
			BEGIN
                SET @Sequencia			= @c_LPEt2Seq		-- &LpEtSitSeq = LPEt2Seq
                SET @Situacao			= @c_LPEt2Des		-- &LpEtSit    = LPEt2Des.Trim()
                SET @DataDaSituacao		= @C_LPEt2IniDat	-- &LpEtSitDat = LPEt2IniDat
                SET @UsuarioDaSituacao	= @c_LPEt2IniUsuCri	-- &LpEtSitUsu = LPEt2PrFUsuCri.Trim()
                
                SET @c_LpEt2PorConc     = dbo.GPFN_RetornarPorcentagemProduzidoDaSituacaoDoPedidoDeVenda(@Empresa, @PedidoDeVenda, @c_LPEt2Seq )
                IF	isnull(@c_LpEt2PorConc, 0 ) < 100
					BREAK -- Igual ao Exit do GeneXus
					
			END -- IF @c_LPEt2Seq > 20
			ELSE
			BEGIN
                SET @Sequencia			= @c_LPEt2Seq		-- &LpEtSitSeq = LPEt2Seq
                SET @Situacao			= @c_LPEt2Des		-- &LpEtSit    = LPEt2Des.Trim()
                SET @DataDaSituacao		= @C_LPEt2IniDat	-- &LpEtSitDat = LPEt2IniDat
                SET @UsuarioDaSituacao	= @c_LPEt2IniUsuCri	-- &LpEtSitUsu = LPEt2PrFUsuCri.Trim()
			
			END -- ELSE do IF @c_LPEt2Seq > 20
			
			--END -- ELSE do IF NOT (@c_LPEt2Seq = 20 OR @c_LPEt2Seq = 50 )
				
		END -- IF @C_LPEt2IniDat = @DataNulaGPIMAC
		
		FETCH NEXT FROM CURSOR_SITUACAO_PEDIDO_DE_VENDA 
		INTO @c_LPEt2Seq, @c_LPEt2Des, @C_LPEt2IniDat, @c_LPEt2IniUsuCri
		
	END -- WHILE @@FETCH_STATUS = 0
	
	CLOSE		CURSOR_SITUACAO_PEDIDO_DE_VENDA 
	DEALLOCATE	CURSOR_SITUACAO_PEDIDO_DE_VENDA 	
	-- fim da leitura do cursor
	
	IF ISNULL(@DataDaSituacao, '1753-01-01') = '1753-01-01'
	BEGIN
		SELECT TOP 01
			@DataDaSituacao = LPENT
		FROM LPV
			WHERE	LPV.LPEMP = @Empresa
			AND		LPV.LPPED = @PedidoDeVenda
			
		
	END
	 
END
/*
    for each  LPEMP LPPED LPEt2Seq
        where LPEMP    = &LpEmp
        where LPPED    = &LpPed
        where LPEt2Seq < 70 // Processa até o nível 60 (Expedição)
        defined by LPEMP LPPED LPEt2Seq
            if null(LPEt2IniDat )
                if not (LPEt2Seq = 20 or LPEt2Seq = 50 )
                    exit
                endif
            else
                if LPEt2Seq > 20 
                    &LpEtSitSeq = LPEt2Seq
                    &LpEtSit    = LPEt2Des.Trim()
                    &LpEtSitDat = LPEt2IniDat
                    &LpEtSitUsu = LPEt2PrFUsuCri.Trim()
                    if LpEt2PorConc < 100
                        exit
                    endif
                else
                    &LpEtSitSeq = LPEt2Seq
                    &LpEtSit    = LPEt2Des.Trim()
                    &LpEtSitDat = LPEt2IniDat
                    &LpEtSitUsu = LPEt2PrFUsuCri.Trim()
                endif
            endif
    endfor



//    for each LPEMP LPPED (LPEt2IniDat ) (LPEt2Seq)
//        where LPEMP = &LpEmp
//        where LPPED = &LpPed
//        where not LPEt2IniDat.IsEmpty()
//        defined by LPEMP LPPED LPEt2IniDat
//            &LpEtSitSeq = LPEt2Seq
//            &LpEtSit    = LPEt2Des.Trim()
//            &LpEtSitDat = LPEt2IniDat
//            &LpEtSitUsu = LPEt2PrFUsuCri.Trim()
//            exit
//    endfor
    if null(&LpEtSitDat)
        for each LPEMP LPPED 
            where LPEMP = &LpEmp
            where LPPED = &LpPed
            defined by LPEMP LPPED 
                &LpEtSitDat = LPENT
        endfor
    endif
*/


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_RetornarSituacaoParaOPedidoDeVendaAux02] TO [interclick]
    AS [dbo];


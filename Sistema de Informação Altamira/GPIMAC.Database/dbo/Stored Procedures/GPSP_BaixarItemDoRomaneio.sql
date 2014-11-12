

-- =============================================
-- Author:		Denis Andre
-- Create date: 27/09/2012
-- Description:	Realizar Baixa do Item do 
-- Romaneio de Producao
-- =============================================
CREATE PROCEDURE [dbo].[GPSP_BaixarItemDoRomaneio]
-- parm(in:&OPR0Emp,     in:&OPR0Cod,           in:&OPR1OPEmp,  in:&OPR1OPCod, in:&OPR1CPbCod, 
--      in:&QtdeBaixada, in:&OPR2BaiCSerCodPrx, inout:&OPR2OPR0CodPrx ); 
	-- Add the parameters for the stored procedure here
	@RomaneioEmpresa    NVARCHAR(02)	OUTPUT,    -- OPR0Emp					(INPUT)
	@RomaneioNumero     INT				OUTPUT,    -- OPR0Cod					(INPUT)
	@OPEmpresa          NVARCHAR(02)	OUTPUT,    -- OPR1OPEmp					(INPUT)
	@OPNumero           INT				OUTPUT,    -- OPR1OPCod					(INPUT)
	@MaterialCodigo     NVARCHAR(60)	OUTPUT,    -- OPR1CPbCod				(INPUT)
	@QtdeBaixada        MONEY			OUTPUT,    -- QtdeBaixada				(INPUT)
	@ProxOperacaoCodigo NVARCHAR(08)	OUTPUT,    -- OPR2BaiCSerCodPrx			(INPUT)
	@Usuario            NVARCHAR(20)	OUTPUT,	   -- AUTOR (IHM, por exemplo)	(INPUT)
	@ProximoCodRomaneio INT				OUTPUT,	   -- OPR2OPR0CodPrx			(INPUT/OUTPUT) *
    @Erro				INT				OUTPUT,	   --							(OUTPUT)
	@Msg				NVARCHAR(1000)	OUTPUT	   --							(OUTPUT)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	SET @ProximoCodRomaneio = ISNULL(@ProximoCodRomaneio, 0  )
    SET @Erro				= ISNULL(@Erro,               0  )
    SET @Msg				= ISNULL(@Msg,                '' )
	SET @ProximoCodRomaneio	= ISNULL(@ProximoCodRomaneio, 0  )

--	=================================================================================================================================
--	NÃO PERMITIR BAIXAR UM ITEM DE ROMANEIO SE NAO FOI INFORMADO A EMPRESA DO ROMANEIO ORIGEM
--	=================================================================================================================================
	IF LEN(LTRIM(RTRIM(ISNULL(@RomaneioEmpresa, '' ) ) ) ) = 0
		BEGIN
			SET @Erro = 6
			SET @Msg  = 'Erro: Favor informar corretamente a empresa do Romaneio.'
			RETURN
	END
--	=================================================================================================================================

--	=================================================================================================================================
--	NÃO PERMITIR BAIXAR UM ITEM DE ROMANEIO SE NAO FOI INFORMADO O NUMERO DO ROMANEIO DE ORIGEM
--	=================================================================================================================================
	IF ISNULL(@RomaneioNumero, 0 ) <= 0
		BEGIN
			SET @Erro = 7
			SET @Msg  = 'Erro: Favor informar corretamente o número do Romaneio Desejado'
			RETURN
	END
--	=================================================================================================================================

--	=================================================================================================================================
--	NÃO PERMITIR BAIXAR UM ITEM DE ROMANEIO SE NAO FOI INFORMADO A EMPRESA DA ORDEM DE PRODUCAO DE ORIGEM
--	=================================================================================================================================
	IF LEN(LTRIM(RTRIM(ISNULL(@OPEmpresa, '' ) ) ) ) = 0
		BEGIN
			SET @Erro = 8
			SET @Msg  = 'Erro: Favor informar corretamente a empresa da Ordem de Produção.'
			RETURN
	END
--	=================================================================================================================================

--	=================================================================================================================================
--	NÃO PERMITIR BAIXAR UM ITEM DE ROMANEIO SE NAO FOI INFORMADO O NUMERO DA ORDEM DE PRODUÇÃO
--	=================================================================================================================================
	IF ISNULL(@OPNumero, 0 ) <= 0
		BEGIN
			SET @Erro = 9
			SET @Msg  = 'Erro: Favor informar corretamente o número da Ordem de Produção'
			RETURN
	END
--	=================================================================================================================================

--	=================================================================================================================================
--	NÃO PERMITIR BAIXAR UM ITEM DE ROMANEIO SE NAO FOI INFORMADO O CODIGO DO MATERIAL A SER BAIXADO
--	=================================================================================================================================
	IF LEN(LTRIM(RTRIM(ISNULL(@MaterialCodigo, '' ) ) ) ) = 0
		BEGIN
			SET @Erro = 10
			SET @Msg  = 'Erro: Favor informar corretamente o Código do Material a ser baixado.'
			RETURN
	END
--	=================================================================================================================================

--	=================================================================================================================================
--	NÃO PERMITIR BAIXAR UM ITEM DE ROMANEIO QUE ESTEJA COM O STATUS DIFERENTE DE INICIADO
--	=================================================================================================================================
	DECLARE @StatusDoItemDoRomaneio	NVARCHAR(10 )
	SET		@StatusDoItemDoRomaneio = dbo.GPFN_RetornarStatusDoItemDoRomaneio(@RomaneioEmpresa, @RomaneioNumero, 
																			  @OPEmpresa,       @OPNumero,
																			  @MaterialCodigo )
	IF LTRIM(RTRIM(UPPER(@StatusDoItemDoRomaneio ) ) ) <> 'INICIADO'
		BEGIN
			SET @Erro = 1
			SET @Msg  = 'Não foi permitido baixar o item do Romaneio %0. ' +
			            'O seu status atual é "%1" e somente é permitido baixar quando o status for "INICIADO".'
			SET @Msg  = REPLACE(@Msg, '%0', LTRIM(RTRIM(CAST(@RomaneioNumero as nvarchar(10) ) ) ) )
			SET @Msg  = REPLACE(@Msg, '%1', @StatusDoItemDoRomaneio )
			
			RETURN
			
	END
--	=================================================================================================================================
	
--	=================================================================================================================================
--	NÃO PERMITIR BAIXAR UM ITEM DE ROMANEIO SE FOI INFORMADO UMA QUANTIDADE NEMOR OU IGUAL A ZERO 
--	=================================================================================================================================
	IF ISNULL(@QtdeBaixada, 0 ) <= 0
		BEGIN	
			SET @Erro = 5
			SET @Msg  = 'Não foi permitido baixar o item do Romaneio %0. ' +
			            'O valor a ser baixado ("%1") não poder ser inferior ou igual a zero.'
			SET @Msg  = REPLACE(@Msg, '%0', LTRIM(RTRIM(CAST(       @RomaneioNumero   as nvarchar(10) ) ) ) )
			SET @Msg  = REPLACE(@Msg, '%1', LTRIM(RTRIM(CAST(ISNULL(@QtdeBaixada, 0 ) as nvarchar(30) ) ) ) )
			
			RETURN
	END
--	=================================================================================================================================	
	
--	=================================================================================================================================
--	(*) INFORMACAO IMPORTANTE SOBRE O PARAMETRO @ProximoCodRomaneio (INPUT/OUTPUT):
--	=================================================================================================================================
--	Se for informado um número de um romaneio existente, este romaneio OBRIGATORIAMENTE
--	deve estar em aberto e NãO INICIADO (com o Status PARADO). 
--	=================================================================================================================================
	IF @ProximoCodRomaneio > 0
	BEGIN
		DECLARE @StatusDoItemDoProximoRomaneio	NVARCHAR(10 )
		SET		@StatusDoItemDoProximoRomaneio	= dbo.GPFN_RetornarStatusDoItemDoRomaneio(@RomaneioEmpresa, @ProximoCodRomaneio, 
																				          @OPEmpresa,       @OPNumero,
																				          @MaterialCodigo )
		IF LTRIM(RTRIM(UPPER(@StatusDoItemDoProximoRomaneio ) ) ) <> 'PARADO'
			BEGIN
				SET @Erro = 2
				SET @Msg  = 'Não foi permitido baixar o item do Romaneio %0.' +
				            'O seu status atual é "%1" e somente é permitido adicionar quando o status for "PARADO".'
				SET @Msg  = REPLACE(@Msg, '%0', LTRIM(RTRIM(CAST(@ProximoCodRomaneio as nvarchar(10) ) ) ) )
				SET @Msg  = REPLACE(@Msg, '%1', @StatusDoItemDoProximoRomaneio )
				
				RETURN
				
		END
	END
--	=================================================================================================================================

--	=================================================================================================================================
--	(*) INFORMACAO IMPORTANTE SOBRE O PARAMETRO @ProxOperacaoCodigo (INPUT):
--	=================================================================================================================================
--	Se for informado um número de um romaneio existente, este romaneio OBRIGATORIAMENTE
--	deve ser da mesma OPERAÇÃO que foi informada no parâmetro @ProxOperacaoCodigo
--	=================================================================================================================================
	IF @ProximoCodRomaneio > 0
	BEGIN
		DECLARE @OperacaoDoRomaneioInformado	NVARCHAR(08)
		
		SET @OperacaoDoRomaneioInformado = 
			ISNULL( (SELECT TOP 01 dbo.OPROM.OPR0CSerCod
					 FROM	dbo.OPROM
					 WHERE	dbo.OPROM.OPR0Emp = @RomaneioEmpresa
					 AND	dbo.OPROM.OPR0Cod = @ProximoCodRomaneio ), '' )
		
		IF @OperacaoDoRomaneioInformado <> @ProxOperacaoCodigo
			BEGIN
				SET @Erro = 3
				SET @Msg  = 'Não foi permitido realizar a baixa do item do Romaneio %0. ' +
				            'A operação do próximo romaneio %1 (%2) não é a mesma que a operação informada (%3).'
				SET @Msg  = REPLACE(@Msg, '%0', LTRIM(RTRIM(CAST(@RomaneioNumero     as nvarchar(10) ) ) ) )
				SET @Msg  = REPLACE(@Msg, '%1', LTRIM(RTRIM(CAST(@ProximoCodRomaneio as nvarchar(10) ) ) ) )
				SET @Msg  = REPLACE(@Msg, '%2', LTRIM(RTRIM(     @OperacaoDoRomaneioInformado          ) ) )
				SET @Msg  = REPLACE(@Msg, '%3', LTRIM(RTRIM(     @ProxOperacaoCodigo                   ) ) )
				RETURN
			
		END
	END
--	=================================================================================================================================


	-- declaracao de variaveis
	DECLARE @Agora						DATETIME 
	DECLARE @Hoje						DATETIME
	DECLARE @DataNula					DATETIME
	DECLARE @DataHoraNula				DATETIME
	DECLARE @DataCriado					DATETIME
	DECLARE @UsuarioCriacao				NVARCHAR(20)
	DECLARE @DataHoraCriado				DATETIME
	DECLARE @UsuarioResponsavel			NVARCHAR(20)
	DECLARE @Operacao					NVARCHAR(8)
	DECLARE @Observacao					NVARCHAR(1000)
	DECLARE @PrevisaoInicio				DATETIME
	DECLARE @Maquina					NVARCHAR(5)
	DECLARE @MateriaPrima				NVARCHAR(100)
	DECLARE @DescricaoServico			NVARCHAR(30)
	
    DECLARE @CodigoMaterial				NVARCHAR(60)	-- [OPR1CPbCod]
    DECLARE @QuantidadeProduzir			DECIMAL(10,0)	-- [OPR1Qtd]
    DECLARE @Empresa					NVARCHAR(2)		-- [OPR1LPEmp]
	DECLARE @NumeroPedido				INT				-- [OPR1LPPed]
	DECLARE @ItemPedido					SMALLINT		-- [OPR1LpSeq]
	DECLARE @Baixado					NVARCHAR(1)		-- [OPR1Bai]
	DECLARE @DataBaixa					DATETIME		-- [OPR1BaiDat]
	DECLARE @DataHoraBaixa				DATETIME		-- [OPR1BaiDtH]
	DECLARE @UsuarioBaixa				NVARCHAR(20)	-- [OPR1BaiUsu]
	DECLARE @ObservacaoBaixa			NVARCHAR(500)	-- [OPR1BaiObs]
	DECLARE @ObservacaoItem				NVARCHAR(500)	-- [OPR1Obs]
	DECLARE @TotalBaixada				DECIMAL(10,0)	-- [OPR1BaiQtd]
	DECLARE @UsuarioInicio				NVARCHAR(20)	-- [OPr1IniUsu]
	DECLARE @DataHoraInicio				DATETIME		-- [OPR1IniDtH]
	DECLARE @DataInicio					DATETIME		-- [OPR1IniDat]
	DECLARE @Iniciado					NVARCHAR(1)		-- [OPR1Ini]
	DECLARE @PrevisaoConclusao			SMALLINT		-- [OPR1PrCDias]
	DECLARE @DataPrevisaoConclusao		DATETIME		-- [OPR1PrCDat]
	DECLARE @Acao						NVARCHAR(10)	-- [OPr1Aca]
	DECLARE @DataHoraCriacaoItem		DATETIME		-- [OPR1DtHCri]
	DECLARE @UsuarioItem				NVARCHAR(20)	-- [OPR1UsuCri]
    DECLARE @DescricaoMaterial			NVARCHAR(120)	-- [CPRONom]
    DECLARE @UnidadeMaterial			NVARCHAR(2)		-- [CPROUni]
    DECLARE @SaldoItem					DECIMAL(10,0)
    DECLARE @ProximoItemBaixaRomaneio	SMALLINT		-- [OPr2BaiSeq]

    DECLARE @QuantidadeProduzirPRX		DECIMAL(10,0) -- &OPR1QtdPrx   = &OPR1QtdPrx + &QtdeBaixada
    DECLARE @EmpresaPRX					NVARCHAR(02)  -- &OPR1LpEmpPrx = &OPR1LpEmp
    DECLARE @NumeroPedidoPRX			INT           -- &OPR1LpPedPrx   = &OPR1LpPed
    DECLARE @ItemPedidoPRX				SMALLINT      -- &OPR1LpSeqPrx   = &OPR1LpSeq
    DECLARE @ObservacaoItemPRX			NVARCHAR(500) -- &OPR1ObsPrx     = &OPR1Obs
    DECLARE @QtdeBaixadoPRX				DECIMAL(10,0) -- &OPR1BaiQtd     
    DECLARE @BaixadoPRX					NVARCHAR(1)   -- &OPR1BaiPrx     = 'N'
    DECLARE @DataBaixaPRX				DATETIME      -- &OPR1BaiDatPrx  = &DataNula
    DECLARE @DataHoraBaixaPRX			DATETIME      -- &OPR1BaiDtHPrz  = &DataHoraNula
    DECLARE @UsuarioBaixaPRX			NVARCHAR(20)  -- &OPR1BaiUsuPrx  = ''
    DECLARE @ObservacaoBaixaPRX			NVARCHAR(500) -- &OPr1BaiObsPrx  = ''
    DECLARE @IniciadoPRX				NVARCHAR(1)	  -- &OPR1IniPrx     = 'N'
    DECLARE @DataInicioPRX				DATETIME	  -- &OPR1IniDatPrx  = &DataNula
    DECLARE @DataHoraInicioPRX			DATETIME	  -- &OPR1IniDtHPrx  = &DataHoraNula
    DECLARE @UsuarioInicioPRX			NVARCHAR(20)  -- &OPr1IniUsuPrx  = ''
	DECLARE @PrevisaoConclusaoPRX		SMALLINT      -- &OPR1PrCDiasPrx
	DECLARE	@DataPrevisaoConclusaoPRX	DATETIME      -- &OPR1PrCDat
	DECLARE @AcaoPRX					NVARCHAR(10)  -- &OPr1AcaPrx
	DECLARE @UsuarioItemPRX				NVARCHAR(20)  -- &OPR1UsuCriPrx
	DECLARE @DataHoraCriacaoItemPRX		DATETIME	  -- &OPR1DtHCriPrx	
	--
	SET @Agora				= GETDATE()
	SET @Hoje				= CAST(@Agora AS DATE )
	SET @DataHoraNula		= CAST('1753-01-01' AS DATETIME )
	SET @DataNula			= @DataHoraNula
	
	-- Pegar dados do cabeçalho do Romaneio
    -- POPRomAddUpdDltGet.Call(&OPR0Emp, 'GET', 0, &OPR0Cod, &OPR0Dat, &OPR0UsuCri, &OPR0DtHCri, &OPR0UsuCodRes, &OPR0CSerCod, &OPR0Obs, &OPR0DatPrI, &OPR0CMAQCOD, &OPR0MPr0Cod )
    -- &OPR0CSerNom = PCaSInRtCSerNom.Udp(&OPR0CSerCod )
    	
	SELECT TOP 1 
		@DataCriado			= OPROM.OPR0Dat,
		@UsuarioResponsavel = OPROM.OPR0UsuCodRes, 
		@Operacao			= OPROM.OPR0CSerCod, 
		@Observacao			= OPROM.OPR0Obs, 
		@PrevisaoInicio		= OPROM.OPR0DatPrI, 
		@Maquina			= OPROM.OPR0CMAQCOD, 
		@MateriaPrima		= OPROM.OPR0MPr0Cod,
		@DescricaoServico	= CASIN.CSerNom
	FROM OPROM INNER JOIN CASIN ON OPROM.OPR0CSerCod = CASIN.CSERCOD
	WHERE OPR0EMP = @RomaneioEmpresa
	AND   OPR0Cod = @RomaneioNumero
	 
    --// Pegar os dados do item do romaneio
    --POPRomItemAddUpdDltGet.Call(&OPR0Emp,    &OPR0Cod,     &OPR1OPEmp,  &OPR1OPCod,  &OPR1CPbCod, 'GET',       0, 
    --                            &OPR1LPEmp,  &OPR1LPPed,   &OPR1LpSeq,  0,           &OPR1Obs,    &OPR1Bai,
    --                            &OPR1BaiDat, &OPR1BaiDtH,  &OPR1BaiUsu, &OPR1BaiObs, &OPR1Ini,    &OPR1IniDat, &OPR1IniDtH,
    --                            &OPr1IniUsu, &OPr1PrCDias, &OPr1PrCDat, &OPr1Aca,    &OPR1UsuCri, &OPR1DtHCri )
    --&OPR1CPbNom  = PCaProRtCProNom.Udp(&OPR1CPbCod )
    --&OPR1CPbUni  = PCaProRtCProUni.Udp(&OPR1CPbCod )
    --&OPR1CPbUni1 = &OPR1CPbUni
    
	SET @QuantidadeProduzir = 0
	SET @QtdeBaixadoPRX     = 0
    
	SELECT TOP 1
		@CodigoMaterial			= OPROMITEM.[OPR1CPbCod], 
		@QuantidadeProduzir		= OPROMITEM.[OPR1Qtd],
		@Empresa				= OPROMITEM.[OPR1LPEmp],
		@NumeroPedido			= OPROMITEM.[OPR1LPPed],
		@ItemPedido				= OPROMITEM.[OPR1LpSeq],
		@Baixado				= OPROMITEM.[OPR1Bai],
		@TotalBaixada			= OPROMITEM.[OPR1BaiQtd],
		@DataBaixa				= OPROMITEM.[OPR1BaiDat],
		@DataHoraBaixa			= OPROMITEM.[OPR1BaiDtH],
		@UsuarioBaixa			= OPROMITEM.[OPR1BaiUsu],
		@ObservacaoBaixa		= OPROMITEM.[OPR1BaiObs],
		@ObservacaoItem			= OPROMITEM.[OPR1Obs],
		@UsuarioInicio			= OPROMITEM.[OPr1IniUsu],
		@DataHoraInicio			= OPROMITEM.[OPR1IniDtH],
		@DataInicio				= OPROMITEM.[OPR1IniDat],
		@Iniciado				= OPROMITEM.[OPR1Ini],
		@PrevisaoConclusao		= OPROMITEM.[OPR1PrCDias],
		@DataPrevisaoConclusao	= OPROMITEM.[OPR1PrCDat],
		@Acao					= OPROMITEM.[OPr1Aca],
		@DataHoraCriacaoItem	= OPROMITEM.[OPR1DtHCri],
		@UsuarioItem			= OPROMITEM.[OPR1UsuCri],
		@DescricaoMaterial		= CAPRO.[CPRONom],
	    @UnidadeMaterial		= CAPRO.[CPROUni],
	    @SaldoItem = (CASE  WHEN (OPROMITEM.[OPR1Qtd] - OPROMITEM.[OPR1BaiQtd]) > 0 
							THEN (OPROMITEM.[OPR1Qtd] - OPROMITEM.[OPR1BaiQtd])
							ELSE 0 END)
	FROM 
		[dbo].[OPROMITEM] INNER JOIN
		[dbo].CAPRO ON OPROMITEM.OPR1CPbCod = CAPRO.CPROCOD
	WHERE 
		OPR0Emp		= @RomaneioEmpresa AND
		OPR0Cod		= @RomaneioNumero AND
		OPR1OPEmp	= @OPEmpresa AND
		OPR1OPCod	= @OPNumero AND
		OPR1CPbCod	= @MaterialCodigo
  
	SET @QuantidadeProduzir = ISNULL(@QuantidadeProduzir, 0 )
	
	IF @QtdeBaixada > isnull(@SaldoItem, 0 )
	BEGIN
		SET @Erro = 4
		SET @Msg = 'Não há saldo suficiente que atenda a quantidade desejada.'
		RETURN
	END
	
	IF LTRIM(RTRIM(ISNULL(@ProxOperacaoCodigo, '' ))) <> ''
	BEGIN
		IF @ProximoCodRomaneio = 0
		BEGIN
		
			SET @ProximoCodRomaneio = ISNULL((SELECT TOP 1 CONTULTOPRom + 1 FROM dbo.CONTRN WHERE CONCOD = 1), 1 )
			UPDATE  dbo.CONTRN SET CONTULTOPRom = @ProximoCodRomaneio WHERE CONCOD = 1
			
			INSERT INTO [dbo].[OPROM]
				   ([OPR0Emp]
				   ,[OPR0Cod]
				   ,[OPR0Dat]
				   ,[OPR0UsuCri]
				   ,[OPR0DtHCri]
				   ,[OPR0UsuCodRes]
				   ,[OPR0CSerCod]
				   ,[OPR0Obs]
				   ,[OPR0DatPrI]
				   ,[OPR0CMAQCOD]
				   ,[OPR0MPr0Cod])
			 VALUES
				   (@RomaneioEmpresa
				   ,@ProximoCodRomaneio
				   ,@Hoje
				   ,@Usuario
				   ,@Agora
				   ,@UsuarioResponsavel
				   ,@ProxOperacaoCodigo
				   ,@Observacao
				   ,@Hoje
				   ,''
				   ,'')
		END -- IF @ProximoCodRomaneio = 0
	END

	--===============================================================================================================================================================
    -- Início Gravar a Baixa do Romaneio
	--===============================================================================================================================================================
    SET @ProximoItemBaixaRomaneio = ISNULL((SELECT TOP 1  [OPr2BaiSeq] + 1 
	  									    FROM     [dbo].[OPROMITEMBAIXA]
										    WHERE    [OPR0Emp]    = @RomaneioEmpresa AND
												     [OPR0Cod]    = @RomaneioNumero  AND
												     [OPR1OPEmp]  = @OPEmpresa       AND
												     [OPR1OPCod]  = @OPNumero        AND
												     [OPR1CPbCod] = @MaterialCodigo
										    ORDER BY [OPR0Emp]    ASC, [OPR0Cod]    ASC, 
											  	     [OPR1OPEmp]  ASC, [OPR1OPCod]  ASC, 
												     [OPR1CPbCod] ASC, [OPr2BaiSeq] DESC), 1 )
	 
    INSERT INTO [dbo].[OPROMITEMBAIXA]
		       ([OPR0Emp]
		       ,[OPR0Cod]
		       ,[OPR1OPEmp]
		       ,[OPR1OPCod]
		       ,[OPR1CPbCod]
		       ,[OPr2BaiSeq]
		       ,[OPR2BaiDat]
		       ,[OPR2BaiDtH]
		       ,[OPR2BaiUsu]
		       ,[OPR2BaiQtd]
		       ,[OPR2BaiCSerCodPrx]
		       ,[OPR2OPR0EmpPrx]
		       ,[OPR2OPR0CodPrx])
	VALUES
		      (@RomaneioEmpresa
		      ,@RomaneioNumero
		      ,@OPEmpresa
		      ,@OPNumero
		      ,@MaterialCodigo
		      ,@ProximoItemBaixaRomaneio
		      ,@Hoje
		      ,@Agora
		      ,@Usuario
		      ,@QtdeBaixada
		      ,@ProxOperacaoCodigo
		      ,@Empresa
		      ,@ProximoCodRomaneio) 
	   
		
	-- Atualizar a quantidade baixada no item do Romaneio Origem:
	DECLARE @TotalBaixado	MONEY
	SET		@TotalBaixado = ISNULL((	SELECT SUM(OPROMITEMBAIXA.OPR2BaiQtd)
										FROM	OPROMITEMBAIXA
										WHERE	OPROMITEMBAIXA.OPR0Emp		= @RomaneioEmpresa
										AND		OPROMITEMBAIXA.OPR0Cod		= @RomaneioNumero
										AND		OPROMITEMBAIXA.OPR1OPEmp	= @OPEmpresa
										AND		OPROMITEMBAIXA.OPR1OPCod	= @OPNumero
										AND		OPROMITEMBAIXA.OPR1CPbCod	= @MaterialCodigo), 0)
	UPDATE OPROMITEM SET
		OPROMITEM.OPR1BaiQtd = @TotalBaixado
		WHERE	OPROMITEM.OPR0Emp		= @RomaneioEmpresa
		AND		OPROMITEM.OPR0Cod		= @RomaneioNumero
		AND		OPROMITEM.OPR1OPEmp		= @OPEmpresa
		AND		OPROMITEM.OPR1OPCod		= @OPNumero
		AND		OPROMITEM.OPR1CPbCod	= @MaterialCodigo
			
	

	--===============================================================================================================================================================
	-- Término Gravar a Baixa do Romaneio	
	--===============================================================================================================================================================


    IF ISNULL(@ProximoCodRomaneio, 0 ) > 0 
    BEGIN
        -- Adicionar o item no romaneio de destino:
        -- POPRomItemAddUpdDltGet.Call(&OPR0Emp, &OPR2OPR0CodPrx, &OPR1OPEmp,  &OPR1OPCod,  &OPR1CPbCod, 'GET', 0, &OPR1LpEmpPrx, &OPR1LpPedPrx, &OPR1LpSeqPrx, &OPr1QtdPrx, &OPR1ObsPrx, &OPR1BaiPrx, &OPR1BaiDatPrx, &OPR1BaiDtHPrz, &OPR1BaiUsuPrx, &OPr1BaiObsPrx, &OPR1IniPrx, &OPR1IniDatPrx, &OPR1IniDtHPrx, &OPr1IniUsuPrx, &OPr1PrCDiasPrx, &OPr1PrCDatPrx, &OPr1AcaPrx, &OPR1UsuCriPrx, &OPR1DtHCriPrx )
        SELECT TOP 1
			@QuantidadeProduzirPRX		= [OPR1Qtd],		-- &OPR1QtdPrx   = &OPR1QtdPrx + &QtdeBaixada
			@EmpresaPRX					= [OPR1LPEMP],		-- &OPR1LpEmpPrx = &OPR1LpEmp
			@NumeroPedidoPRX			= [OPR1LPPED],		-- &OPR1LpPedPrx   = &OPR1LpPed
			@ItemPedidoPRX				= [OPR1LPSEQ],		-- &OPR1LpSeqPrx   = &OPR1LpSeq
			@ObservacaoItemPRX			= [OPR1OBS],		-- &OPR1ObsPrx     = &OPR1Obs
			@BaixadoPRX					= [OPR1BAI],		-- &OPR1BaiPrx     = 'N'
			@QtdeBaixadoPRX				= [OPR1BaiQtd],		-- &OPR1BaiQtd
			@DataBaixaPRX				= [OPR1BAIDAT],		-- &OPR1BaiDatPrx  = &DataNula
			@DataHoraBaixaPRX			= [OPR1BAIDTH],		-- &OPR1BaiDtHPrz  = &DataHoraNula
			@UsuarioBaixaPRX			= [OPR1BAIUSU],		-- &OPR1BaiUsuPrx  = ''
			@ObservacaoBaixaPRX			= [OPR1BAIOBS],		-- &OPr1BaiObsPrx  = ''
			@IniciadoPRX				= [OPR1INI],		-- &OPR1IniPrx     = 'N'
			@DataInicioPRX				= [OPR1INIDAT],		-- &OPR1IniDatPrx  = &DataNula
			@DataHoraInicioPRX			= [OPR1IniDtH],		-- &OPR1IniDtHPrx  = &DataHoraNula
			@UsuarioInicioPRX			= [OPr1IniUsu],		-- &OPr1IniUsuPrx  = ''
			@PrevisaoConclusaoPRX		= [OPR1PrCDias],	-- &OPR1PrCDiasPrx
			@DataPrevisaoConclusaoPRX	= [OPR1PrCDat],		-- &OPR1PrCDatPrx
			@AcaoPRX					= [OPr1Aca],		-- &OPr1AcaPrx
			@UsuarioItemPRX				= [OPR1UsuCri],     -- &OPR1UsuCriPrx
			@DataHoraCriacaoItemPRX		= [OPR1DtHCri]		-- &OPR1DtHCriPrx					
        FROM	dbo.OPROMITEM
        WHERE	OPR0Emp		= @RomaneioEmpresa		AND
				OPR0Cod		= @ProximoCodRomaneio	AND
				OPR1OPEmp	= @OPEmpresa			AND
				OPR1OPCod	= @OPNumero				AND
				OPR1CPbCod	= @MaterialCodigo
					
		SET @QtdeBaixadoPRX        = ISNULL(@QtdeBaixadoPRX,        0)
		SET @QuantidadeProduzirPRX = isnull(@QuantidadeProduzirPRX, 0) + @QtdeBaixada
        IF LEN(LTRIM(RTRIM(isnull(@BaixadoPRX, '') ) ) ) = 0
        BEGIN
			SET @EmpresaPRX					= @Empresa
			SET @NumeroPedidoPRX			= @NumeroPedido
            SET @ItemPedidoPRX				= @ItemPedido
            SET @ObservacaoItemPRX			= @ObservacaoItem
            SET @BaixadoPRX					= 'N'
            SET @DataBaixaPRX				= @DataNula
            SET @DataHoraBaixaPRX			= @DataHoraNula
            SET @UsuarioBaixaPRX			= ''
            SET @ObservacaoBaixaPRX			= ''
            SET @IniciadoPRX				= 'N'
            SET @DataInicioPRX				= @DataNula
            SET @DataHoraInicioPRX			= @DataHoraNula
            SET @UsuarioInicioPRX			= ''
			SET @PrevisaoConclusaoPRX		= 0			-- &OPR1PrCDiasPrx
			SET @DataPrevisaoConclusaoPRX	= @DataNula	-- &OPR1PrCDatPrx
			SET @AcaoPRX					= ''		-- &OPr1AcaPrx
			SET @UsuarioItemPRX				= @Usuario  -- &OPR1UsuCriPrx
			SET @DataHoraCriacaoItemPRX		= @Agora	-- &OPR1DtHCriPrx					
            
        END -- LEN(LTRIM(RTRIM(isnull(@BaixadoPRX, '') ) ) ) = 0
            
        -- Gravar o item no novo romaneio
        ---POPRomItemAddUpdDltGet.Call(&OPR0Emp, &OPR2OPR0CodPrx, &OPR1OPEmp,  &OPR1OPCod,  &OPR1CPbCod, 'UPD', 0, &OPR1LpEmpPrx, &OPR1LpPedPrx, &OPR1LpSeqPrx, &OPr1QtdPrx, &OPR1ObsPrx, &OPR1BaiPrx, &OPR1BaiDatPrx, &OPR1BaiDtHPrz, &OPR1BaiUsuPrx, &OPr1BaiObsPrx, &OPR1IniPrx, &OPR1IniDatPrx, &OPR1IniDtHPrx, &OPr1IniUsuPrx, &OPr1PrCDiasPrx, &OPr1PrCDatPrx, &OPr1AcaPrx, &OPR1UsuCriPrx, &OPR1DtHCriPrx  )
        UPDATE	[dbo].[OPROMITEM]
		SET		[OPR1Qtd]		= @QuantidadeProduzirPRX,		[OPR1LPEmp]		= @EmpresaPRX,
				[OPR1LPPed]		= @NumeroPedidoPRX,				[OPR1LpSeq]		= @ItemPedidoPRX,
				[OPR1Bai]		= @BaixadoPRX,					[OPR1BaiQtd]	= @QtdeBaixadoPRX,
				[OPR1BaiDat]	= @DataBaixaPRX,				[OPR1BaiDtH]	= @DataHoraBaixaPRX,
				[OPR1BaiUsu]	= @UsuarioBaixaPRX,				[OPR1BaiObs]	= @ObservacaoBaixaPRX,
				[OPR1Obs]		= @ObservacaoItemPRX,			[OPR1Ini]		= @IniciadoPRX,
				[OPr1IniUsu]	= @UsuarioInicioPRX,			[OPR1IniDtH]	= @DataHoraInicioPRX,
				[OPR1IniDat]	= @DataInicioPRX,				[OPR1PrCDias]	= @PrevisaoConclusaoPRX,
				[OPR1PrCDat]	= @DataPrevisaoConclusaoPRX,	[OPr1Aca]		= @AcaoPRX,
				[OPR1DtHCri]	= @DataHoraCriacaoItemPRX,		[OPR1UsuCri]	= @UsuarioItemPRX
				
		WHERE	[OPR0Emp]		= @RomaneioEmpresa		AND
				[OPR0Cod]		= @ProximoCodRomaneio	AND
				[OPR1OPEmp]		= @OPEmpresa			AND
				[OPR1OPCod]		= @OPNumero				AND
				[OPR1CPbCod]	= @MaterialCodigo
		IF @@ROWCOUNT <= 0
		BEGIN
			INSERT INTO [dbo].[OPROMITEM]
				([OPR0Emp]				,[OPR0Cod]					,[OPR1OPEmp]			,[OPR1OPCod]
				,[OPR1CPbCod]			,[OPR1Qtd]					,[OPR1LPEmp]			,[OPR1LPPed]
				,[OPR1LpSeq]			,[OPR1Bai]					,[OPR1BaiQtd]			,[OPR1BaiDat]
				,[OPR1BaiDtH]			,[OPR1BaiUsu]				,[OPR1BaiObs]			,[OPR1Obs]
				,[OPR1Ini]				,[OPr1IniUsu]				,[OPR1IniDtH]			,[OPR1IniDat]
				,[OPR1PrCDias]			,[OPR1PrCDat]				,[OPr1Aca]				,[OPR1DtHCri]
				,[OPR1UsuCri])
			VALUES
				(@RomaneioEmpresa		,@ProximoCodRomaneio		,@OPEmpresa				,@OPNumero
				,@MaterialCodigo		,@QuantidadeProduzirPRX		,@EmpresaPRX			,@NumeroPedidoPRX
				,@ItemPedidoPRX			,@BaixadoPRX				,@QtdeBaixadoPRX		,@DataBaixaPRX
				,@DataHoraBaixaPRX		,@UsuarioBaixaPRX			,@ObservacaoBaixaPRX	,@ObservacaoItemPRX
				,@IniciadoPRX			,@UsuarioInicioPRX			,@DataHoraInicioPRX		,@DataInicioPRX
				,@PrevisaoConclusaoPRX	,@DataPrevisaoConclusaoPRX	,@AcaoPRX				,@DataHoraCriacaoItemPRX
				,@UsuarioItemPRX)
		
		END -- IF @@ROWCOUNT <= 0
		
        ---PLPVSitGrvSIn.Call(&OPR1LpEmpPrx, &OPR1LpPedPrx, &OPR2BaiCSerCodPrx, &Hoje, '', 0 ) // Gravar a etapa no pedido de venda origem:
        DECLARE @ProximaOperacaoGravada NVARCHAR(01)
        EXEC dbo.GPSP_IniciarSituacaoDoPedidoDeVendaPorOperacao @EmpresaPRX, @NumeroPedidoPRX, @ProxOperacaoCodigo, @Hoje, '', @Usuario, @ProximaOperacaoGravada OUTPUT
        END
           
        -- Verificar se baixou todo o item:
        -- &OPR1Sal     = POPR1SalRt.Udp(&OPR0Emp,   &OPR0Cod,    &OPR1OPEmp,  &OPR1OPCod,  &OPR1CPbCod )
		SELECT TOP 1
			@QuantidadeProduzir		= OPROMITEM.[OPR1Qtd],		@Baixado				= OPROMITEM.[OPR1Bai],
			@TotalBaixada			= OPROMITEM.[OPR1BaiQtd],	@DataBaixa				= OPROMITEM.[OPR1BaiDat],
			@DataHoraBaixa			= OPROMITEM.[OPR1BaiDtH],	@UsuarioBaixa			= OPROMITEM.[OPR1BaiUsu],
		
			@SaldoItem				= (CASE  WHEN (OPROMITEM.[OPR1Qtd] - OPROMITEM.[OPR1BaiQtd]) > 0 
											 THEN (OPROMITEM.[OPR1Qtd] - OPROMITEM.[OPR1BaiQtd])
											 ELSE 0 
									   END)
		FROM 
			[dbo].[OPROMITEM] 
		WHERE 
			OPR0Emp		= @RomaneioEmpresa	AND	OPR0Cod		= @RomaneioNumero	AND
			OPR1OPEmp	= @OPEmpresa		AND	OPR1OPCod	= @OPNumero			AND
			OPR1CPbCod	= @MaterialCodigo

        IF ISNULL(@SaldoItem, 0 ) <= 0
        BEGIN
            --POPRomItemAddUpdDltGet.Call(&OPR0Emp, &OPR0Cod, &OPR1OPEmp,  &OPR1OPCod,  &OPR1CPbCod, 'GET', 0, &OPR1LPEmp, &OPR1LPPed, &OPR1LpSeq, &OPR1Qtd, &OPR1Obs, &OPR1Bai, &OPR1BaiDat, &OPR1BaiDtH, &OPR1BaiUsu, &OPR1BaiObs, &OPR1Ini, &OPR1IniDat, &OPR1IniDtH, &OPr1IniUsu, &OPr1PrCDias, &OPr1PrCDat, &OPr1Aca, &OPR1UsuCri, &OPR1DtHCri )
            SET @Baixado		= 'S'		-- &OPR1Bai    = 'S'
            SET @DataBaixa		= @Hoje		-- &OPR1BaiDat = &OPR2BaiDat
            SET @DataHoraBaixa	= @Agora	-- &OPR1BaiDtH = &OPR2BaiDtH
            SET @UsuarioBaixa	= @Usuario	-- &OPR1BaiUsu = &OPR2BaiUsu
            SET @TotalBaixada   = @QuantidadeProduzir
            
            --POPRomItemAddUpdDltGet.Call(&OPR0Emp, &OPR0Cod, &OPR1OPEmp,  &OPR1OPCod,  &OPR1CPbCod, 'UPD', 0, &OPR1LPEmp, &OPR1LPPed, &OPR1LpSeq, &OPR1Qtd, &OPR1Obs, &OPR1Bai, &OPR1BaiDat, &OPR1BaiDtH, &OPR1BaiUsu, &OPR1BaiObs, &OPR1Ini, &OPR1IniDat, &OPR1IniDtH, &OPr1IniUsu, &OPr1PrCDias, &OPr1PrCDat, &OPr1Aca, &OPR1UsuCri, &OPR1DtHCri  )
			UPDATE DBO.OPROMITEM SET
				[OPR1Bai]       = @Baixado,			[OPR1BaiQtd]	= @TotalBaixada,
				[OPR1BaiDat]	= @DataBaixa,		[OPR1BaiDtH]	= @DataHoraBaixa,
				[OPR1BaiUsu]	= @UsuarioBaixa
			WHERE 
				OPR0Emp			= @RomaneioEmpresa	AND	OPR0Cod			= @RomaneioNumero	AND
				OPR1OPEmp		= @OPEmpresa		AND	OPR1OPCod		= @OPNumero			AND
				OPR1CPbCod		= @MaterialCodigo
		END  
      
END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_BaixarItemDoRomaneio] TO [scada]
    AS [dbo];


GO
GRANT EXECUTE
    ON OBJECT::[dbo].[GPSP_BaixarItemDoRomaneio] TO [interclick]
    AS [dbo];


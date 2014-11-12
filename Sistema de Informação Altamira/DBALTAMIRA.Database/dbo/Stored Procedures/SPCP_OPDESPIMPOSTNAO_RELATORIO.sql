
/****** Object:  Stored Procedure dbo.SPCP_OPDESPIMPOSTNAO_RELATORIO    Script Date: 23/10/2010 13:58:21 ******/


/****** Object:  Stored Procedure dbo.SPCP_OPDESPIMPOSTNAO_RELATORIO    Script Date: 25/08/1999 20:11:48 ******/
CREATE PROCEDURE SPCP_OPDESPIMPOSTNAO_RELATORIO

@TipoConta     char(1)

AS

DECLARE @DataVencimento       smalldatetime,
        @DataProrrogacao      smalldatetime,
        @Sequencia            int,
        @OutraSequencia       int,
        @OutraData            smalldatetime,
        @Descricao            Char(40)
        	
BEGIN

    -- Cria tabela temporaria
    CREATE TABLE #TabDespesaImposto (sequencia int null,
                                     descricao char(70) null,
                                     Data      smalldatetime null)

    -- Monta o select do cursor
    DECLARE curDespesaImposto INSENSITIVE CURSOR
        FOR SELECT cpdd_Sequencia,
                   cpdd_DataVencimento,
                   cpdd_DataProrrogacao
              FROM CP_DespesaImpostoDetalhe, CP_DespesaImposto
             WHERE cpdd_NumeroOP is Null
               AND cpdd_Sequencia = cpdi_Sequencia
               AND cpdi_TipoConta = @TipoConta
	order by cpdd_sequencia


    --Abre o cursor
    OPEN curDespesaImposto
               
    -- Move para o primeiro registro do cursor
    FETCH NEXT FROM curDespesaImposto 
               INTO @Sequencia,
                    @DataVencimento,
                    @DataProrrogacao
    
    --Guarda os valores da conta atual
    SELECT @OutraSequencia       = @Sequencia


    -- Verifica se a data de prorrogacao é nula
    IF @DataProrrogacao is Null 

        BEGIN
        
            --Caso seja Guarda a data de vencimento
            SELECT  @OutraData = @DataVencimento

        END

    ELSE

        BEGIN

            -- Caaso não seja guarda a data de prorrogacao
            SELECT @OutraData = @DataProrrogacao

        END

    -- processa enquanto tiver registros no cursor
    WHILE @@FETCH_STATUS = 0 

        BEGIN

            -- Verifica se ainda é a mesma conta
            IF @OutraSequencia <> @Sequencia 
                
                BEGIN

                    SELECT @Descricao = cpde_Descricao FROM CP_Descricao, CP_DespesaImposto
                        WHERE cpde_Codigo = cpdi_CodigoConta
                          AND cpde_Tipo   = cpdi_TipoConta
                          AND cpdi_Sequencia = @OutraSequencia

                    INSERT INTO #TabDespesaImposto(Sequencia, Descricao, Data) Values(@OutraSequencia, ltrim(rtrim(@Descricao)) + ' - ' + LTrim(RTrim(Convert(Char(2), Datepart(day, @OutraData)))) + '/' + LTrim(RTrim(Convert(Char(2), datepart(month, @OutraData)))) + '/' + LTrim(RTRim(Convert(Char(4), Datepart(year, @OutraData)))), @OutraData)


                    --Guarda os valores da conta atual
                    SELECT @OutraSequencia       = @Sequencia


                    -- Verifica se a data de prorrogacao é nula
                    IF @DataProrrogacao is Null 

                        BEGIN
        
                            --Caso seja Guarda a data de vencimento
                            SELECT  @OutraData = @DataVencimento

                        END

                    ELSE

                        BEGIN

                            -- Caaso não seja guarda a data de prorrogacao
                            SELECT @OutraData = @DataProrrogacao


                        END

                END
              
             --Move o cursor para o proximo registro
             FETCH NEXT FROM CurDespesaImposto INTO @Sequencia, @DataVencimento, @DataProrrogacao

        END
      
      IF @Sequencia Is Not NUll 

        BEGIN

          -- executa inserindo o ultimo item do cursor
          SELECT @Descricao = cpde_Descricao FROM CP_Descricao, CP_DespesaImposto
                        WHERE cpde_Codigo = cpdi_CodigoConta
                          AND cpde_Tipo   = cpdi_TipoConta
                          AND cpdi_Sequencia = @OutraSequencia

          INSERT INTO #TabDespesaImposto(Sequencia, Descricao, Data) Values(@OutraSequencia, ltrim(rtrim(@Descricao)) + ' - ' + LTrim(RTrim(Convert(Char(2), Datepart(day, @OutraData)))) + '/' + LTrim(RTrim(Convert(Char(2), datepart(month, @OutraData)))) + '/' + LTrim(RTRim(Convert(Char(4), Datepart(year, @OutraData)))), @OutraData)

        END 

    --Fechou e tirou o cursor da memoria
    CLOSE CurDespesaImposto
    DEALLOCATE CurDespesaImposto

-- Retorna os dados para o VB
SELECT * FROM #TabDespesaImposto


END





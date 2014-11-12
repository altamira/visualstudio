
/****** Object:  Stored Procedure dbo.SPORC_Principal    Script Date: 23/10/2010 13:58:22 ******/

CREATE PROC SPORC_Principal
                                                            @Acoes varchar(10) = null,
                                                            @Orcamento varchar(50) = null,
                                                            @Para varchar(255) = null,
                                                            @ATT varchar(255) = null,
                                                            @Fone varchar(14) = null,
                                                            @FAX varchar(14) = null
AS
    IF @Acoes = 'SELECIONA'
        BEGIN
                    SELECT
                                    Orcamento,
                                    Para,
                                    ATT,
                                    Fone,
                                    FAX
                FROM
                                ORC_Principal
                        WHERE Orcamento = @Orcamento
                                    ORDER BY Orcamento
        END
    IF @Acoes = 'INSERE'
        BEGIN
                    INSERT ORC_Principal
                                    (
                                    Orcamento,
                                    Para,
                                    ATT,
                                    Fone,
                                    FAX
                                    )
                    VALUES
                                    (
                                    @Orcamento,
                                    @Para,
                                    @ATT,
                                    @Fone,
                                    @FAX
                                    )
        END
    IF @Acoes = 'ALTERA'
        BEGIN
                    UPDATE ORC_Principal
                                    SET
                                    Para = @Para,
                                    ATT = @ATT,
                                    Fone = @Fone,
                                    FAX = @FAX
                    WHERE
                                Orcamento = @Orcamento
        END
    IF @Acoes = 'DELETA'
        BEGIN
                    DELETE FROM ORC_Principal
                    WHERE 
                                Orcamento = @Orcamento

        END



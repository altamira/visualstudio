
/****** Object:  Stored Procedure dbo.SPORC_EstrutMetalica    Script Date: 23/10/2010 13:58:22 ******/

CREATE PROC SPORC_EstrutMetalica
                                                        @Acoes varchar(10) = null,
                                                        @em_Orcamento varchar(50) = null,
                                                        @em_Altura decimal = null,
                                                        @em_Profundidade decimal = null,
                                                        @em_Largura decimal = null,
                                                        @em_Modulos tinyint = null,
                                                        @em_Bandejas tinyint = null,
                                                        @em_Peso decimal = null,
                                                        @em_Cor varchar(50) = null,
                                                        @em_Acabamento varchar(100) = null,
                                                        @em_Retentor varchar(30) = null,
                                                        @em_DivGaveta tinyint = null,
                                                        @em_DivBandeja tinyint = null,
                                                        @em_PortaEtiqueta tinyint = null,
                                                        @em_Total decimal = null,
                                                        @em_IPI decimal = null,
                                                        @em_Sapatas bit = null,
                                                        @em_FechLateral tinyint = null,
                                                        @em_FechFundo tinyint = null,
                                                        @em_GavetaSimples tinyint = null,
                                                        @em_GavetaPlastica tinyint = null,
                                                        @em_GavetaDupla tinyint = null,
                                                        @em_GavetaTripla tinyint = null,
                                                        @em_Porta tinyint = null,
                                                        @em_Tipo tinyint = null,
                                                        @em_OBS varchar(255) = null
AS
    IF @Acoes = 'SELECIONA'
        BEGIN
                    SELECT
                                    em_Orcamento,
                                    em_Altura,
                                    em_Profundidade,
                                    em_Largura,
                                    em_Modulos,
                                    em_Bandejas,
                                    em_Peso,
                                    em_Cor,
                                    em_Acabamento,
                                    em_Retentor,
                                    em_DivGaveta,
                                    em_DivBandeja,
                                    em_PortaEtiqueta,
                                    em_Total,
                                    em_IPI,
                                    em_Sapatas,
                                    em_FechLateral,
                                    em_FechFundo,
                                    em_GavetaSimples,
                                    em_GavetaPlastica,
                                    em_GavetaDupla,
                                    em_GavetaTripla,
                                    em_Porta,
                                    em_Tipo,
                                    em_OBS
                FROM
                                ORC_EstrutMetalica
                        WHERE em_Orcamento = @em_Orcamento
                                    ORDER BY em_Orcamento
        END
    IF @Acoes = 'INSERE'
        BEGIN
                    INSERT ORC_EstrutMetalica
                                    (
                                    em_Orcamento,
                                    em_Altura,
                                    em_Profundidade,
                                    em_Largura,
                                    em_Modulos,
                                    em_Bandejas,
                                    em_Peso,
                                    em_Cor,
                                    em_Acabamento,
                                    em_Retentor,
                                    em_DivGaveta,
                                    em_DivBandeja,
                                    em_PortaEtiqueta,
                                    em_Total,
                                    em_IPI,
                                    em_Sapatas,
                                    em_FechLateral,
                                    em_FechFundo,
                                    em_GavetaSimples,
                                    em_GavetaPlastica,
                                    em_GavetaDupla,
                                    em_GavetaTripla,
                                    em_Porta,
                                    em_Tipo,
                                    em_OBS
                                    )
                    VALUES
                                    (
                                    @em_Orcamento,
                                    @em_Altura,
                                    @em_Profundidade,
                                    @em_Largura,
                                    @em_Modulos,
                                    @em_Bandejas,
                                    @em_Peso,
                                    @em_Cor,
                                    @em_Acabamento,
                                    @em_Retentor,
                                    @em_DivGaveta,
                                    @em_DivBandeja,
                                    @em_PortaEtiqueta,
                                    @em_Total,
                                    @em_IPI,
                                    @em_Sapatas,
                                    @em_FechLateral,
                                    @em_FechFundo,
                                    @em_GavetaSimples,
                                    @em_GavetaPlastica,
                                    @em_GavetaDupla,
                                    @em_GavetaTripla,
                                    @em_Porta,
                                    @em_Tipo,
                                    @em_OBS
                                    )
        END
    IF @Acoes = 'ALTERA'
        BEGIN
                    UPDATE ORC_EstrutMetalica
                                    SET
                                    em_Altura = @em_Altura,
                                    em_Profundidade = @em_Profundidade,
                                    em_Largura = @em_Largura,
                                    em_Modulos = @em_Modulos,
                                    em_Bandejas = @em_Bandejas,
                                    em_Peso = @em_Peso,
                                    em_Cor = @em_Cor,
                                    em_Acabamento = @em_Acabamento,
                                    em_Retentor = @em_Retentor,
                                    em_DivGaveta = @em_DivGaveta,
                                    em_DivBandeja = @em_DivBandeja,
                                    em_PortaEtiqueta = @em_PortaEtiqueta,
                                    em_Total = @em_Total,
                                    em_IPI = @em_IPI,
                                    em_Sapatas = @em_Sapatas,
                                    em_FechLateral = @em_FechLateral,
                                    em_FechFundo = @em_FechFundo,
                                    em_GavetaSimples = @em_GavetaSimples,
                                    em_GavetaPlastica = @em_GavetaPlastica,
                                    em_GavetaDupla = @em_GavetaDupla,
                                    em_GavetaTripla = @em_GavetaTripla,
                                    em_Porta = @em_Porta,
                                    em_Tipo = @em_Tipo,
                                    em_OBS = @em_OBS
                    WHERE
                                em_Orcamento = @em_Orcamento
        END
    IF @Acoes = 'DELETA'
        BEGIN
                    DELETE FROM ORC_EstrutMetalica
                    WHERE 
                                em_Orcamento = @em_Orcamento
        END




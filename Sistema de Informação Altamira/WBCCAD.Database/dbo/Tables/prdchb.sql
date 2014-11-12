CREATE TABLE [dbo].[prdchb] (
    [Produto]             NVARCHAR (20) NULL,
    [Chave_busca_montada] NVARCHAR (50) NULL,
    [Chave_busca]         NVARCHAR (50) NULL,
    [Dimensao_1]          NVARCHAR (10) NULL,
    [Dimensao_2]          NVARCHAR (10) NULL,
    [Dimensao_3]          NVARCHAR (10) NULL,
    [Dimensao_4]          NVARCHAR (10) NULL,
    [Esconder_orcamento]  BIT           NULL,
    [multiplo]            FLOAT (53)    NULL,
    [dividir_multiplo]    BIT           NULL,
    [multiploVizinho]     DECIMAL (18)  NULL,
    [idPrdChb]            INT           IDENTITY (1, 1) NOT NULL
);


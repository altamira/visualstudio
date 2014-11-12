CREATE TABLE [dbo].[CO_CotacaoFrete] (
    [cocf_Numero]      INT           NOT NULL,
    [cocf_Pedido]      INT           NULL,
    [cocf_DataCotacao] SMALLDATETIME NULL,
    [cocf_CNPJ]        CHAR (14)     NULL,
    [cocf_Destino]     VARCHAR (50)  NULL,
    [cocf_NotaFiscal]  CHAR (10)     NULL,
    [cocf_DataNF]      SMALLDATETIME NULL,
    [cocf_Peso]        REAL          NULL,
    [cocf_Objetivo]    REAL          NULL,
    [cocf_QtdVolume]   INT           NULL,
    [cocf_PorcCliente] REAL          NULL,
    [cocf_OBS]         VARCHAR (200) NULL,
    [cocf_PorcTrans]   REAL          NULL,
    [cocf_DataSaida]   SMALLDATETIME NULL,
    [cocf_Status]      VARCHAR (20)  NULL,
    CONSTRAINT [PK_CO_CotacaoFrete] PRIMARY KEY NONCLUSTERED ([cocf_Numero] ASC) WITH (FILLFACTOR = 90)
);


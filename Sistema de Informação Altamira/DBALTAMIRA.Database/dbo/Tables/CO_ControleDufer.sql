CREATE TABLE [dbo].[CO_ControleDufer] (
    [codControleDufer] INT             IDENTITY (1, 1) NOT NULL,
    [nroPedido]        INT             NOT NULL,
    [Material]         VARCHAR (50)    NULL,
    [PesoPedido]       DECIMAL (18, 3) NULL,
    [DEC]              VARCHAR (10)    NULL,
    [COV]              INT             NULL,
    [Lote]             INT             NULL,
    [Peso]             DECIMAL (18, 3) NULL,
    [dtEntDufer]       SMALLDATETIME   NULL,
    [NFCosipa]         INT             NULL,
    [dtEmisCosipa]     SMALLDATETIME   NULL,
    [PesoCosipa]       DECIMAL (18, 3) NULL,
    [nroNF]            INT             NULL,
    [dtEmissao]        SMALLDATETIME   NULL,
    [PedCorte]         INT             NULL,
    [NFDufer]          INT             NULL,
    [dtEmisDufer]      SMALLDATETIME   NULL,
    [PesoDufer]        DECIMAL (18, 3) NULL,
    [Residuo]          FLOAT (53)      NULL,
    [Certificado]      VARCHAR (30)    NULL
);


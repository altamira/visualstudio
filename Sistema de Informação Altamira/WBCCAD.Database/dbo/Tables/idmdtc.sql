CREATE TABLE [dbo].[idmdtc] (
    [idioma]          NVARCHAR (20)  NULL,
    [dtc_codigo]      NVARCHAR (20)  NULL,
    [dtc_bmp]         NVARCHAR (40)  NULL,
    [dtc_linha]       NVARCHAR (MAX) NULL,
    [dtc_inicial]     NVARCHAR (7)   NULL,
    [dtc_qtde_linhas] INT            NULL,
    [idIdmDtc]        INT            IDENTITY (1, 1) NOT NULL
);


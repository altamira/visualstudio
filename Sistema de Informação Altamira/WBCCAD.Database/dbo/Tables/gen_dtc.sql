CREATE TABLE [dbo].[gen_dtc] (
    [indice]          INT            IDENTITY (1, 1) NOT NULL,
    [dtc_codigo]      NVARCHAR (20)  NULL,
    [dtc_bmp]         NVARCHAR (40)  NULL,
    [dtc_linha]       NVARCHAR (MAX) NULL,
    [dtc_inicial]     NVARCHAR (7)   NULL,
    [dtc_qtde_linhas] INT            NULL,
    [dtcrtf]          NVARCHAR (50)  NULL,
    [GEN_DTC_ALT]     INT            NULL,
    [GEN_DTC_LRG]     INT            NULL
);


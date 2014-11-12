CREATE TABLE [dbo].[Pessup] (
    [pessup_codigo]           INT           NOT NULL,
    [pessup_comis_flag]       BIT           NOT NULL,
    [pessup_comis_tipo]       NVARCHAR (20) NULL,
    [pessup_comis_percentual] FLOAT (53)    NULL,
    [pessup_desabilitado]     BIT           NOT NULL,
    [PESSUP_CARGO]            NVARCHAR (50) NULL,
    [idPessup]                INT           IDENTITY (1, 1) NOT NULL
);


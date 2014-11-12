CREATE TABLE [dbo].[mez_tipo_piso] (
    [Nome]                NVARCHAR (255) NULL,
    [Tipo]                NVARCHAR (255) NULL,
    [gp_acab]             NVARCHAR (255) NULL,
    [larg]                NVARCHAR (255) NULL,
    [comp]                NVARCHAR (255) NULL,
    [cor_piso]            NVARCHAR (50)  NULL,
    [montar_chave]        NVARCHAR (50)  NULL,
    [dim_soma_ao_arremat] NVARCHAR (50)  NULL,
    [metal]               BIT            NOT NULL
);


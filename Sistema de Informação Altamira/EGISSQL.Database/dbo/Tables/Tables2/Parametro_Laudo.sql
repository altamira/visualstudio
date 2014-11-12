CREATE TABLE [dbo].[Parametro_Laudo] (
    [cd_empresa]                INT           NOT NULL,
    [ic_formato_laudo]          CHAR (1)      NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [cd_layout_laudo]           INT           NULL,
    [nm_titulo_laudo]           VARCHAR (100) NULL,
    [ic_composicao_laudo]       CHAR (1)      NULL,
    [ic_quimico_laudo]          CHAR (1)      NULL,
    [ic_altera_lote_fabricante] CHAR (1)      NULL,
    CONSTRAINT [PK_Parametro_Laudo] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[Etiqueta_Layout] (
    [cd_etiqueta_layout]      INT           NOT NULL,
    [cd_etiqueta_tipo_layout] INT           NULL,
    [nm_etiqueta_layout]      VARCHAR (30)  NULL,
    [sg_etiqueta_layout]      CHAR (10)     NULL,
    [qt_num_coluna]           INT           NULL,
    [qt_espaco_coluna]        FLOAT (53)    NULL,
    [qt_margem_esquerda]      FLOAT (53)    NULL,
    [qt_margem_direita]       FLOAT (53)    NULL,
    [qt_num_linha]            INT           NULL,
    [qt_espaco_linha]         FLOAT (53)    NULL,
    [qt_margem_superior]      FLOAT (53)    NULL,
    [qt_margem_inferior]      FLOAT (53)    NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [nm_origem_dado]          VARCHAR (100) NULL,
    CONSTRAINT [PK_Etiqueta_Layout] PRIMARY KEY CLUSTERED ([cd_etiqueta_layout] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Etiqueta_Layout_Etiqueta_Tipo_Layout] FOREIGN KEY ([cd_etiqueta_tipo_layout]) REFERENCES [dbo].[Etiqueta_Tipo_Layout] ([cd_etiqueta_tipo_layout])
);


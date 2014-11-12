CREATE TABLE [dbo].[Tipo_Risco_Comex_Idioma] (
    [cd_tipo_risco_comex] INT          NOT NULL,
    [cd_idioma]           INT          NOT NULL,
    [nm_tipo_risco_comex] VARCHAR (40) NULL,
    [sg_tipo_risco_comex] CHAR (10)    NULL,
    [ds_tipo_risco_comex] TEXT         NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Risco_Comex_Idioma] PRIMARY KEY CLUSTERED ([cd_tipo_risco_comex] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Risco_Comex_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);


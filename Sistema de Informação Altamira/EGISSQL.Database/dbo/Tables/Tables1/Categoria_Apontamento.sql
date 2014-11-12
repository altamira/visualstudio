CREATE TABLE [dbo].[Categoria_Apontamento] (
    [cd_categoria_apontamento] INT          NOT NULL,
    [nm_categoria_apontamento] VARCHAR (40) NULL,
    [nm_fantasia_categoria]    VARCHAR (15) NULL,
    [ic_tipo_categoria]        CHAR (1)     NULL,
    [cd_unidade_medida]        INT          NULL,
    [nm_obs_categoria]         VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_pad_categoria]         CHAR (1)     NULL,
    [qt_apontamento]           INT          NULL,
    [qt_ordem_apontamento]     INT          NULL,
    CONSTRAINT [PK_Categoria_Apontamento] PRIMARY KEY CLUSTERED ([cd_categoria_apontamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Categoria_Apontamento_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);


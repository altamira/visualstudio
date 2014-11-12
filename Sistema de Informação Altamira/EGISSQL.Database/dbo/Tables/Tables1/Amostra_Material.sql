CREATE TABLE [dbo].[Amostra_Material] (
    [cd_amostra]              INT           NOT NULL,
    [cd_amostra_Material]     INT           NOT NULL,
    [cd_amostra_produto]      INT           NOT NULL,
    [cd_produto]              INT           NULL,
    [cd_fase_produto]         INT           NULL,
    [qt_amostra_material]     FLOAT (53)    NULL,
    [nm_obs_amostra_material] VARCHAR (200) NULL,
    [cd_ordem]                INT           NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_tecnico]              INT           NULL,
    CONSTRAINT [PK_Amostra_Material] PRIMARY KEY CLUSTERED ([cd_amostra] ASC, [cd_amostra_Material] ASC, [cd_amostra_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Amostra_Material_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto])
);


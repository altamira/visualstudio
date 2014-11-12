CREATE TABLE [dbo].[Inventario_Bem_Composicao] (
    [cd_inventario]         INT          NOT NULL,
    [cd_item_inventario]    INT          NOT NULL,
    [cd_bem]                INT          NULL,
    [qt_bem_inventario]     FLOAT (53)   NULL,
    [nm_obs_bem_inventario] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Inventario_Bem_Composicao] PRIMARY KEY CLUSTERED ([cd_inventario] ASC, [cd_item_inventario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Inventario_Bem_Composicao_Bem] FOREIGN KEY ([cd_bem]) REFERENCES [dbo].[Bem] ([cd_bem])
);


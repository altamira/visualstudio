CREATE TABLE [dbo].[Registro_Movimento_Bem_Item] (
    [cd_registro_bem]          INT          NOT NULL,
    [cd_item_registro_bem]     INT          NOT NULL,
    [cd_bem]                   INT          NOT NULL,
    [nm_obs_item_registro_bem] VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Registro_Movimento_Bem_Item] PRIMARY KEY CLUSTERED ([cd_registro_bem] ASC, [cd_item_registro_bem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Movimento_Bem_Item_Bem] FOREIGN KEY ([cd_bem]) REFERENCES [dbo].[Bem] ([cd_bem])
);


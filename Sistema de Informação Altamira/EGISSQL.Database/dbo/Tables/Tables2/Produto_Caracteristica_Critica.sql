CREATE TABLE [dbo].[Produto_Caracteristica_Critica] (
    [cd_produto]                    INT          NOT NULL,
    [cd_caracteristica_critica]     INT          NOT NULL,
    [nm_obs_produto_critica]        VARCHAR (40) NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    [ds_produto_caracteristica]     TEXT         NULL,
    [cd_unidade_medida]             INT          NULL,
    [nm_obs_produto_caracteristica] VARCHAR (40) NULL,
    CONSTRAINT [PK_Produto_Caracteristica_Critica] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_caracteristica_critica] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Caracteristica_Critica_Caracteristica_Critica] FOREIGN KEY ([cd_caracteristica_critica]) REFERENCES [dbo].[Caracteristica_Critica] ([cd_caracteristica_critica]),
    CONSTRAINT [FK_Produto_Caracteristica_Critica_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);


CREATE TABLE [dbo].[Produto_Portaria_Norma] (
    [cd_produto_portaria_norma] INT          NOT NULL,
    [cd_produto]                INT          NOT NULL,
    [cd_portaria_norma]         INT          NOT NULL,
    [ds_produto_portaria_norma] TEXT         NULL,
    [nm_obs_produto_portaria]   VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Produto_Portaria_Norma] PRIMARY KEY CLUSTERED ([cd_produto_portaria_norma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Portaria_Norma_Portaria_Norma] FOREIGN KEY ([cd_portaria_norma]) REFERENCES [dbo].[Portaria_Norma] ([cd_portaria_norma])
);


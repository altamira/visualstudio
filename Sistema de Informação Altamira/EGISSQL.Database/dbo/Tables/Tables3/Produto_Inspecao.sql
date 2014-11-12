CREATE TABLE [dbo].[Produto_Inspecao] (
    [cd_produto_inspecao]     INT          NULL,
    [cd_produto]              INT          NULL,
    [dt_produto_inspecao]     DATETIME     NULL,
    [cd_motivo_inspecao]      INT          NULL,
    [cd_inspetor]             INT          NULL,
    [nm_obs_produto_inspecao] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [FK_Produto_Inspecao_Inspetor] FOREIGN KEY ([cd_inspetor]) REFERENCES [dbo].[Inspetor] ([cd_inspetor]),
    CONSTRAINT [FK_Produto_Inspecao_Motivo_Inspecao] FOREIGN KEY ([cd_motivo_inspecao]) REFERENCES [dbo].[Motivo_Inspecao] ([cd_motivo_inspecao]),
    CONSTRAINT [FK_Produto_Inspecao_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);


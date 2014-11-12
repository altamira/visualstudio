CREATE TABLE [dbo].[Operacao_Apontamento] (
    [cd_operacao]              INT          NOT NULL,
    [cd_categoria_apontamento] INT          NOT NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_obs_operacao]          VARCHAR (40) NULL,
    [qt_ordem_apontamento]     INT          NULL,
    CONSTRAINT [PK_Operacao_Apontamento] PRIMARY KEY CLUSTERED ([cd_operacao] ASC, [cd_categoria_apontamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operacao_Apontamento_Categoria_Apontamento] FOREIGN KEY ([cd_categoria_apontamento]) REFERENCES [dbo].[Categoria_Apontamento] ([cd_categoria_apontamento])
);


CREATE TABLE [dbo].[Materia_Prima_Serie_Lucro] (
    [cd_mat_prima]           INT          NULL,
    [cd_serie_produto]       INT          NULL,
    [cd_tipo_lucro]          INT          NULL,
    [nm_obs_mat_prima_serie] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [FK_Matéria_Prima_Serie_Lucro_Materia_Prima] FOREIGN KEY ([cd_mat_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima]),
    CONSTRAINT [FK_Matéria_Prima_Serie_Lucro_Serie_Produto] FOREIGN KEY ([cd_serie_produto]) REFERENCES [dbo].[Serie_Produto] ([cd_serie_produto]),
    CONSTRAINT [FK_Matéria_Prima_Serie_Lucro_Tipo_Lucro] FOREIGN KEY ([cd_tipo_lucro]) REFERENCES [dbo].[Tipo_Lucro] ([cd_tipo_lucro])
);


CREATE TABLE [dbo].[Materia_Prima_Composicao] (
    [cd_grupo_produto]    INT      NOT NULL,
    [cd_produto]          INT      NOT NULL,
    [cd_grupo_componente] INT      NOT NULL,
    [cd_componente]       INT      NOT NULL,
    [cd_mat_prima]        INT      NOT NULL,
    [dt_usuario]          DATETIME NOT NULL,
    [cd_usuario]          INT      NOT NULL,
    [cd_bitola]           INT      NOT NULL,
    CONSTRAINT [PK_Materia_Prima_Composicao] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_produto] ASC, [cd_grupo_componente] ASC, [cd_componente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Materia_Prima_Composicao_Materia_Prima] FOREIGN KEY ([cd_mat_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima])
);


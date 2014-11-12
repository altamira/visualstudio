CREATE TABLE [dbo].[Avaliacao_Ambiental_Requisito] (
    [cd_avaliacao]       INT      NOT NULL,
    [cd_requisito_legal] INT      NOT NULL,
    [cd_usuario]         INT      NULL,
    [dt_usuario]         DATETIME NULL,
    CONSTRAINT [PK_Avaliacao_Ambiental_Requisito] PRIMARY KEY CLUSTERED ([cd_avaliacao] ASC, [cd_requisito_legal] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Avaliacao_Ambiental_Requisito_Requisito_Legal] FOREIGN KEY ([cd_requisito_legal]) REFERENCES [dbo].[Requisito_Legal] ([cd_requisito_legal])
);


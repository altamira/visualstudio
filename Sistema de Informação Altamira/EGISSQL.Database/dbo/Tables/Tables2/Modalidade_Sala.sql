CREATE TABLE [dbo].[Modalidade_Sala] (
    [cd_modalidade] INT      NOT NULL,
    [cd_tipo_sala]  INT      NOT NULL,
    [cd_usuario]    INT      NULL,
    [dt_usuario]    DATETIME NULL,
    CONSTRAINT [PK_Modalidade_Sala] PRIMARY KEY CLUSTERED ([cd_modalidade] ASC, [cd_tipo_sala] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modalidade_Sala_Tipo_Sala] FOREIGN KEY ([cd_tipo_sala]) REFERENCES [dbo].[Tipo_Sala] ([cd_tipo_sala])
);


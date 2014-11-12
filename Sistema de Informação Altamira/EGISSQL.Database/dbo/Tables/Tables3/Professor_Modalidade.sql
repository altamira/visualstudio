CREATE TABLE [dbo].[Professor_Modalidade] (
    [cd_professor]  INT      NOT NULL,
    [cd_modalidade] INT      NOT NULL,
    [cd_usuario]    INT      NULL,
    [dt_usuario]    DATETIME NULL,
    CONSTRAINT [PK_Professor_Modalidade] PRIMARY KEY CLUSTERED ([cd_professor] ASC, [cd_modalidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Professor_Modalidade_Modalidade] FOREIGN KEY ([cd_modalidade]) REFERENCES [dbo].[Modalidade] ([cd_modalidade])
);


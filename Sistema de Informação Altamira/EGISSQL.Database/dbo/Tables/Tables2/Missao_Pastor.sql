CREATE TABLE [dbo].[Missao_Pastor] (
    [cd_missao]  INT      NOT NULL,
    [cd_pastor]  INT      NOT NULL,
    [cd_usuario] INT      NULL,
    [dt_usuario] DATETIME NULL,
    CONSTRAINT [PK_Missao_Pastor] PRIMARY KEY CLUSTERED ([cd_missao] ASC, [cd_pastor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Missao_Pastor_Pastor] FOREIGN KEY ([cd_pastor]) REFERENCES [dbo].[Pastor] ([cd_pastor])
);


CREATE TABLE [dbo].[Servico_Apresentacao] (
    [cd_servico]      INT      NOT NULL,
    [cd_apresentacao] INT      NOT NULL,
    [cd_usuario]      INT      NULL,
    [dt_usuario]      DATETIME NULL,
    CONSTRAINT [PK_Servico_Apresentacao] PRIMARY KEY CLUSTERED ([cd_servico] ASC, [cd_apresentacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Servico_Apresentacao_Apresentacao] FOREIGN KEY ([cd_apresentacao]) REFERENCES [dbo].[Apresentacao] ([cd_apresentacao])
);


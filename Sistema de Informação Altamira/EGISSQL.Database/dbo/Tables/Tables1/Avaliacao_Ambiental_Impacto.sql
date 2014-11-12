CREATE TABLE [dbo].[Avaliacao_Ambiental_Impacto] (
    [cd_avaliacao]         INT      NOT NULL,
    [cd_impacto_ambiental] INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Avaliacao_Ambiental_Impacto] PRIMARY KEY CLUSTERED ([cd_avaliacao] ASC, [cd_impacto_ambiental] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Avaliacao_Ambiental_Impacto_Impacto_Ambiental] FOREIGN KEY ([cd_impacto_ambiental]) REFERENCES [dbo].[Impacto_Ambiental] ([cd_impacto_ambiental])
);


CREATE TABLE [dbo].[Aspecto_Impacto_Ambiental] (
    [cd_aspecto_ambiental] INT      NOT NULL,
    [cd_impacto_ambiental] INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Aspecto_Impacto_Ambiental] PRIMARY KEY CLUSTERED ([cd_aspecto_ambiental] ASC, [cd_impacto_ambiental] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aspecto_Impacto_Ambiental_Impacto_Ambiental] FOREIGN KEY ([cd_impacto_ambiental]) REFERENCES [dbo].[Impacto_Ambiental] ([cd_impacto_ambiental])
);


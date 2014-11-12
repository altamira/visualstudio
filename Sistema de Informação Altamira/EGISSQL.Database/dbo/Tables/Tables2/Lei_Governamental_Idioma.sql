CREATE TABLE [dbo].[Lei_Governamental_Idioma] (
    [cd_lei_governamental_idioma] INT      NOT NULL,
    [cd_lei_governamental]        INT      NOT NULL,
    [ds_lei_governamental_idioma] TEXT     NULL,
    [cd_usuario]                  INT      NULL,
    [dt_usuario]                  DATETIME NULL,
    [ds_lei_governamental]        TEXT     NULL,
    CONSTRAINT [PK_Lei_Governamental_Idioma] PRIMARY KEY CLUSTERED ([cd_lei_governamental_idioma] ASC, [cd_lei_governamental] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Lei_Governamental_Idioma_Idioma] FOREIGN KEY ([cd_lei_governamental]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);


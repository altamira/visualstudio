CREATE TABLE [dbo].[Procedimento_Atributo_Idioma] (
    [cd_procedimento]          INT          NOT NULL,
    [cd_atributo_procedimento] INT          NOT NULL,
    [cd_idioma]                INT          NOT NULL,
    [nm_atributo_grid_idioma]  VARCHAR (25) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Procedimento_Atributo_Idioma] PRIMARY KEY CLUSTERED ([cd_procedimento] ASC, [cd_atributo_procedimento] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Procedimento_Atributo_Idioma_Idioma_Sistema] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma_Sistema] ([cd_idioma])
);


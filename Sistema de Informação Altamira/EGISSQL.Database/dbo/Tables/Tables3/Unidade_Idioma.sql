CREATE TABLE [dbo].[Unidade_Idioma] (
    [cd_unidade_medida]        INT          NOT NULL,
    [cd_idioma]                INT          NOT NULL,
    [nm_unidade_medida_idioma] VARCHAR (30) NOT NULL,
    [sg_unidade_medida_idioma] CHAR (3)     NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    CONSTRAINT [PK_Unidade_Idioma] PRIMARY KEY CLUSTERED ([cd_unidade_medida] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);


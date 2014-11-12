CREATE TABLE [dbo].[Norma_Origem_Idioma] (
    [cd_norma_origem]        INT          NOT NULL,
    [cd_idioma]              INT          NOT NULL,
    [nm_norma_origem_idioma] VARCHAR (40) NOT NULL,
    [sg_norma_origem_idioma] CHAR (10)    NOT NULL,
    [ds_norma_origem_idioma] TEXT         NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Norma_Origem_Idioma] PRIMARY KEY CLUSTERED ([cd_norma_origem] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);


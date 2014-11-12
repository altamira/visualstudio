CREATE TABLE [dbo].[Nivel_Conhecimento_Cargo] (
    [cd_nivel_conhecimento] INT          NOT NULL,
    [nm_nivel_conhecimento] VARCHAR (40) NULL,
    [sg_nivel_conhecimento] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Nivel_Conhecimento_Cargo] PRIMARY KEY CLUSTERED ([cd_nivel_conhecimento] ASC) WITH (FILLFACTOR = 90)
);


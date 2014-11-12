CREATE TABLE [dbo].[Qualidade_Injecao] (
    [cd_qualidade_injecao] INT          NOT NULL,
    [nm_qualidade_injecao] VARCHAR (30) NOT NULL,
    [sg_qualidade_injecao] CHAR (10)    NOT NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Qualidade_Injecao] PRIMARY KEY NONCLUSTERED ([cd_qualidade_injecao] ASC) WITH (FILLFACTOR = 90)
);


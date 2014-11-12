CREATE TABLE [dbo].[Classe_Residuo] (
    [cd_classe_residuo] INT          NOT NULL,
    [nm_classe_residuo] VARCHAR (40) NULL,
    [sg_classe_residuo] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Classe_Residuo] PRIMARY KEY CLUSTERED ([cd_classe_residuo] ASC) WITH (FILLFACTOR = 90)
);


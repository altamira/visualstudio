CREATE TABLE [dbo].[Classe_Consulta_Medica] (
    [cd_classe_consulta_medica] INT          NOT NULL,
    [nm_classe_consulta_medica] VARCHAR (40) NULL,
    [sg_classe_consulta_medica] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Classe_Consulta_Medica] PRIMARY KEY CLUSTERED ([cd_classe_consulta_medica] ASC) WITH (FILLFACTOR = 90)
);


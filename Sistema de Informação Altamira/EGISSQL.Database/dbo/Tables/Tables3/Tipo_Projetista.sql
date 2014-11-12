CREATE TABLE [dbo].[Tipo_Projetista] (
    [cd_tipo_projetista] INT          NOT NULL,
    [nm_tipo_projetista] VARCHAR (30) NOT NULL,
    [sg_tipo_projetista] CHAR (5)     NOT NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Projetista] PRIMARY KEY NONCLUSTERED ([cd_tipo_projetista] ASC) WITH (FILLFACTOR = 90)
);


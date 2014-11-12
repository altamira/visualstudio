CREATE TABLE [dbo].[Nivel_Hierarquico] (
    [cd_nivel_hierarquico] INT          NOT NULL,
    [nm_nivel_hierarquico] VARCHAR (40) NULL,
    [sg_nivel_hierarquico] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Nivel_Hierarquico] PRIMARY KEY CLUSTERED ([cd_nivel_hierarquico] ASC) WITH (FILLFACTOR = 90)
);


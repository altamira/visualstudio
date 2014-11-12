CREATE TABLE [dbo].[Tipo_Deficiencia] (
    [cd_tipo_deficiencia] INT          NOT NULL,
    [nm_tipo_deficiencia] VARCHAR (40) NULL,
    [sg_tipo_deficiencia] CHAR (5)     NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Deficiencia] PRIMARY KEY CLUSTERED ([cd_tipo_deficiencia] ASC) WITH (FILLFACTOR = 90)
);


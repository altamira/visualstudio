CREATE TABLE [dbo].[Tipo_Entrevista] (
    [cd_tipo_entrevista] INT          NOT NULL,
    [nm_tipo_entrevista] VARCHAR (40) NULL,
    [sg_tipo_entrevista] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Entrevista] PRIMARY KEY CLUSTERED ([cd_tipo_entrevista] ASC) WITH (FILLFACTOR = 90)
);


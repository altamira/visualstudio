CREATE TABLE [dbo].[Tipo_Programacao] (
    [cd_tipo_programacao] INT          NOT NULL,
    [nm_tipo_programacao] VARCHAR (40) NULL,
    [sg_tipo_programacao] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Programacao] PRIMARY KEY CLUSTERED ([cd_tipo_programacao] ASC) WITH (FILLFACTOR = 90)
);


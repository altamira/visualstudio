CREATE TABLE [dbo].[Tipo_Participacao] (
    [cd_tipo_participacao] INT          NOT NULL,
    [nm_tipo_participacao] VARCHAR (40) NULL,
    [sg_tipo_participacao] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Participacao] PRIMARY KEY CLUSTERED ([cd_tipo_participacao] ASC) WITH (FILLFACTOR = 90)
);


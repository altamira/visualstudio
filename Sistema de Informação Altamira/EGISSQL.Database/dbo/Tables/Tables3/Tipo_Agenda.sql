CREATE TABLE [dbo].[Tipo_Agenda] (
    [cd_tipo_agenda] INT          NOT NULL,
    [nm_tipo_agenda] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_agenda] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]     INT          NOT NULL,
    [dt_usuario]     DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Agenda] PRIMARY KEY CLUSTERED ([cd_tipo_agenda] ASC) WITH (FILLFACTOR = 90)
);


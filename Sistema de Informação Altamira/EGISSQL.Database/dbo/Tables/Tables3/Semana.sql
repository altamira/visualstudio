CREATE TABLE [dbo].[Semana] (
    [cd_semana]  INT          NOT NULL,
    [nm_semana]  VARCHAR (15) COLLATE Latin1_General_CI_AS NULL,
    [sg_semana]  CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Semana] PRIMARY KEY CLUSTERED ([cd_semana] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[Area] (
    [cd_area]          INT          NOT NULL,
    [nm_area]          VARCHAR (40) NULL,
    [sg_area]          CHAR (10)    NULL,
    [nm_fantasia_area] VARCHAR (15) NULL,
    [ic_ativa_area]    CHAR (1)     NULL,
    [nm_obs_area]      VARCHAR (40) NULL,
    [cd_interno_area]  INT          NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Area] PRIMARY KEY CLUSTERED ([cd_area] ASC) WITH (FILLFACTOR = 90)
);


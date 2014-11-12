CREATE TABLE [dbo].[Plano] (
    [cd_plano]   INT          NOT NULL,
    [nm_plano]   VARCHAR (40) NULL,
    [sg_plano]   CHAR (10)    NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Plano] PRIMARY KEY CLUSTERED ([cd_plano] ASC) WITH (FILLFACTOR = 90)
);


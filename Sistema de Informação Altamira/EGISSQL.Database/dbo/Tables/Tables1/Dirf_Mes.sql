CREATE TABLE [dbo].[Dirf_Mes] (
    [cd_dirf_mes] INT          NOT NULL,
    [nm_dirf_mes] VARCHAR (40) NULL,
    [sg_dirf_mes] CHAR (10)    NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Dirf_Mes] PRIMARY KEY CLUSTERED ([cd_dirf_mes] ASC) WITH (FILLFACTOR = 90)
);


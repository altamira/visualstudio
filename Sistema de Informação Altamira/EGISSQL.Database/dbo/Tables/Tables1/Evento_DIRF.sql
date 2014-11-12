CREATE TABLE [dbo].[Evento_DIRF] (
    [cd_evento_dirf] INT          NOT NULL,
    [nm_evento_dirf] VARCHAR (40) NOT NULL,
    [sg_evento_dirf] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Evento_DIRF] PRIMARY KEY CLUSTERED ([cd_evento_dirf] ASC) WITH (FILLFACTOR = 90)
);


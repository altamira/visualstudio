CREATE TABLE [dbo].[Planta] (
    [cd_planta]       INT          NOT NULL,
    [nm_planta]       VARCHAR (40) NOT NULL,
    [sg_planta]       CHAR (10)    NOT NULL,
    [cd_local_planta] CHAR (10)    NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Planta] PRIMARY KEY CLUSTERED ([cd_planta] ASC) WITH (FILLFACTOR = 90)
);


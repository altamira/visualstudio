CREATE TABLE [dbo].[Estado] (
    [cd_pais]        INT          NOT NULL,
    [cd_estado]      INT          NOT NULL,
    [nm_estado]      VARCHAR (30) NULL,
    [sg_estado]      CHAR (2)     NOT NULL,
    [ic_zona_franca] CHAR (1)     NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Estado] PRIMARY KEY CLUSTERED ([cd_pais] ASC, [cd_estado] ASC) WITH (FILLFACTOR = 90)
);


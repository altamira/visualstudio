CREATE TABLE [dbo].[Mes] (
    [cd_mes]     INT          NOT NULL,
    [nm_mes]     VARCHAR (15) NULL,
    [sg_mes]     CHAR (3)     NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    [qt_dia_mes] INT          NULL,
    CONSTRAINT [PK_Mes] PRIMARY KEY CLUSTERED ([cd_mes] ASC) WITH (FILLFACTOR = 90)
);


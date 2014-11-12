CREATE TABLE [dbo].[Almoxarifado] (
    [cd_almoxarifado] INT          NOT NULL,
    [nm_almoxarifado] VARCHAR (40) NOT NULL,
    [sg_almoxarifado] CHAR (10)    NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Almoxarifado] PRIMARY KEY CLUSTERED ([cd_almoxarifado] ASC) WITH (FILLFACTOR = 90)
);


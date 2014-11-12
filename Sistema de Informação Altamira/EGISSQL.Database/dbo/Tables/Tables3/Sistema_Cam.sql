CREATE TABLE [dbo].[Sistema_Cam] (
    [cd_sistema_cam]        INT          NOT NULL,
    [nm_sistema_cam]        VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_sistema_cam]        VARCHAR (15) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [nm_versao_sistema_cam] VARCHAR (20) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [dt_versao_sistema_cam] DATETIME     NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Sistema_Cam] PRIMARY KEY CLUSTERED ([cd_sistema_cam] ASC) WITH (FILLFACTOR = 90)
);


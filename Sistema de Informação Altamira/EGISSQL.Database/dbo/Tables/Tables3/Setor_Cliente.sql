CREATE TABLE [dbo].[Setor_Cliente] (
    [cd_setor_cliente] INT          NOT NULL,
    [nm_setor_cliente] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_setor_cliente] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]       INT          NOT NULL,
    [dt_usuario]       DATETIME     NOT NULL
);


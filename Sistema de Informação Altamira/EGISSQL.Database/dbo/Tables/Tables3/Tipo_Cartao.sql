CREATE TABLE [dbo].[Tipo_Cartao] (
    [cd_tipo_cartao]    INT          NOT NULL,
    [nm_tipo_cartao]    VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_cartao]    CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]        INT          NOT NULL,
    [dt_usuario]        DATETIME     NOT NULL,
    [cd_departamento]   INT          NOT NULL,
    [cd_ramo_atividade] INT          NULL,
    CONSTRAINT [PK_Tipo_Cartao] PRIMARY KEY CLUSTERED ([cd_tipo_cartao] ASC) WITH (FILLFACTOR = 90)
);


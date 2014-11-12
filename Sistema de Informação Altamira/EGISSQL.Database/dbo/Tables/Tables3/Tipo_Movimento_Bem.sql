CREATE TABLE [dbo].[Tipo_Movimento_Bem] (
    [cd_tipo_movimento_bem] INT          NOT NULL,
    [nm_tipo_movimento_bem] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_tipo_movimento_bem] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [pk_tipo_movimento_bem] PRIMARY KEY CLUSTERED ([cd_tipo_movimento_bem] ASC) WITH (FILLFACTOR = 90)
);


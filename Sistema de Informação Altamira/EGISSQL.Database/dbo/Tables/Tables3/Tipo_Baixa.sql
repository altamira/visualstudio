CREATE TABLE [dbo].[Tipo_Baixa] (
    [cd_tipo_baixa] INT          NOT NULL,
    [nm_tipo_baixa] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_baixa] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]    INT          NOT NULL,
    [dt_usuario]    DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Baixa] PRIMARY KEY CLUSTERED ([cd_tipo_baixa] ASC) WITH (FILLFACTOR = 90)
);


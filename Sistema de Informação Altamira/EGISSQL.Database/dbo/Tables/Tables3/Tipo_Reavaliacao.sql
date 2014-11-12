CREATE TABLE [dbo].[Tipo_Reavaliacao] (
    [cd_tipo_reavaliacao] INT          NOT NULL,
    [nm_tipo_reavaliacao] VARCHAR (40) NOT NULL,
    [sg_tipo_reavaliacao] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [pk_tipo_reavaliacao] PRIMARY KEY CLUSTERED ([cd_tipo_reavaliacao] ASC) WITH (FILLFACTOR = 90)
);


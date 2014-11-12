CREATE TABLE [dbo].[Localizacao_Bem] (
    [cd_localizacao_bem] INT          NOT NULL,
    [nm_localizacao_bem] VARCHAR (60) NULL,
    [sg_localizacao_bem] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [pk_localizacao_bem] PRIMARY KEY CLUSTERED ([cd_localizacao_bem] ASC) WITH (FILLFACTOR = 90)
);


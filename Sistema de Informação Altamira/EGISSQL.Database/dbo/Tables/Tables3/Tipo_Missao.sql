CREATE TABLE [dbo].[Tipo_Missao] (
    [cd_tipo_missao] INT          NOT NULL,
    [nm_tipo_missao] VARCHAR (40) NULL,
    [sg_tipo_missao] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Missao] PRIMARY KEY CLUSTERED ([cd_tipo_missao] ASC) WITH (FILLFACTOR = 90)
);


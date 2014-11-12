CREATE TABLE [dbo].[Tipo_Vaga] (
    [cd_tipo_vaga] INT          NOT NULL,
    [nm_tipo_vaga] VARCHAR (40) NULL,
    [sg_tipo_vaga] CHAR (10)    NULL,
    [cd_usuario]   INT          NULL,
    [dt_usuario]   DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Vaga] PRIMARY KEY CLUSTERED ([cd_tipo_vaga] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[Tipo_Membro] (
    [cd_tipo_membro] INT          NOT NULL,
    [nm_tipo_membro] VARCHAR (40) NULL,
    [sg_tipo_membro] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Membro] PRIMARY KEY CLUSTERED ([cd_tipo_membro] ASC) WITH (FILLFACTOR = 90)
);


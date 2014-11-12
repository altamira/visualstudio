CREATE TABLE [dbo].[Tipo_Pendencia] (
    [cd_tipo_pendencia] INT          NOT NULL,
    [nm_tipo_pendencia] VARCHAR (40) NULL,
    [sg_tipo_pendencia] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Pendencia] PRIMARY KEY CLUSTERED ([cd_tipo_pendencia] ASC) WITH (FILLFACTOR = 90)
);


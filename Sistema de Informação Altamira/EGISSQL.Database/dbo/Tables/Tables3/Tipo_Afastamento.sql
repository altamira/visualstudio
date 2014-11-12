CREATE TABLE [dbo].[Tipo_Afastamento] (
    [cd_tipo_afastamento] INT          NOT NULL,
    [nm_tipo_afastamento] VARCHAR (40) NULL,
    [sg_tipo_afastamento] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Afastamento] PRIMARY KEY CLUSTERED ([cd_tipo_afastamento] ASC) WITH (FILLFACTOR = 90)
);


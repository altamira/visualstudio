CREATE TABLE [dbo].[Tipo_Iso] (
    [cd_tipo_iso] INT          NOT NULL,
    [nm_tipo_iso] VARCHAR (40) NULL,
    [sg_tipo_iso] CHAR (10)    NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Iso] PRIMARY KEY CLUSTERED ([cd_tipo_iso] ASC) WITH (FILLFACTOR = 90)
);


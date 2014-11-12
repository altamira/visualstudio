CREATE TABLE [dbo].[Tipo_Ausencia] (
    [cd_tipo_ausencia] INT          NOT NULL,
    [nm_tipo_ausencia] VARCHAR (40) NULL,
    [sg_tipo_ausencia] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Ausencia] PRIMARY KEY CLUSTERED ([cd_tipo_ausencia] ASC) WITH (FILLFACTOR = 90)
);


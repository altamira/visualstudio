CREATE TABLE [dbo].[Tipo_Igreja] (
    [cd_tipo_igreja] INT          NOT NULL,
    [nm_tipo_igreja] VARCHAR (40) NULL,
    [sg_tipo_igreja] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Igreja] PRIMARY KEY CLUSTERED ([cd_tipo_igreja] ASC) WITH (FILLFACTOR = 90)
);


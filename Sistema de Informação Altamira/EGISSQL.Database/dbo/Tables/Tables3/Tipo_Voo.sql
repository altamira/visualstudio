CREATE TABLE [dbo].[Tipo_Voo] (
    [cd_tipo_voo] INT          NOT NULL,
    [nm_tipo_voo] VARCHAR (30) NULL,
    [sg_tipo_voo] CHAR (10)    NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Voo] PRIMARY KEY CLUSTERED ([cd_tipo_voo] ASC) WITH (FILLFACTOR = 90)
);


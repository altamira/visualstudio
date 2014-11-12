CREATE TABLE [dbo].[Tipo_Referencia_Comercial] (
    [cd_tipo_ref_comercial] INT          NOT NULL,
    [nm_tipo_ref_comercial] VARCHAR (40) NULL,
    [sg_tipo_ref_comercial] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Referencia_Comercial] PRIMARY KEY CLUSTERED ([cd_tipo_ref_comercial] ASC) WITH (FILLFACTOR = 90)
);


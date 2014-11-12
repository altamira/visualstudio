CREATE TABLE [dbo].[Tipo_Estampo] (
    [cd_tipo_estampo] INT          NOT NULL,
    [nm_tipo_estampo] VARCHAR (40) NULL,
    [sg_tipo_estampo] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    [vl_tipo_estampo] FLOAT (53)   NULL,
    [ds_tipo_estampo] TEXT         NULL,
    CONSTRAINT [PK_Tipo_Estampo] PRIMARY KEY CLUSTERED ([cd_tipo_estampo] ASC) WITH (FILLFACTOR = 90)
);


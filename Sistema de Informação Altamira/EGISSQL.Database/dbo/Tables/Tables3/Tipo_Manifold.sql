CREATE TABLE [dbo].[Tipo_Manifold] (
    [cd_tipo_manifold]     INT          NOT NULL,
    [nm_tipo_manifold]     VARCHAR (30) NOT NULL,
    [sg_tipo_manifold]     CHAR (10)    NOT NULL,
    [qt_via_tipo_manifold] INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Manifold] PRIMARY KEY NONCLUSTERED ([cd_tipo_manifold] ASC) WITH (FILLFACTOR = 90)
);


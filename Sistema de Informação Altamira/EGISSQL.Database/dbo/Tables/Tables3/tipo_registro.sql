CREATE TABLE [dbo].[tipo_registro] (
    [cd_documento_magnetico] INT          NOT NULL,
    [cd_tipo_registro]       INT          NOT NULL,
    [nm_tipo_registro]       VARCHAR (40) NOT NULL,
    [sg_tipo_registro]       VARCHAR (5)  NOT NULL,
    [ds_tipo_registro]       TEXT         NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Registro] PRIMARY KEY CLUSTERED ([cd_documento_magnetico] ASC, [cd_tipo_registro] ASC) WITH (FILLFACTOR = 90)
);


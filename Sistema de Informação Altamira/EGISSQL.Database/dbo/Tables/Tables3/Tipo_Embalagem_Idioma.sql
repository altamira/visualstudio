CREATE TABLE [dbo].[Tipo_Embalagem_Idioma] (
    [cd_tipo_embalagem]        INT          NOT NULL,
    [cd_idioma]                INT          NOT NULL,
    [nm_tipo_embalagem_idioma] VARCHAR (30) NOT NULL,
    [sg_tipo_embalagem_idioma] CHAR (10)    NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [ds_tipo_embalagem_idioma] TEXT         NULL,
    CONSTRAINT [PK_Tipo_Embalagem_Idioma] PRIMARY KEY CLUSTERED ([cd_tipo_embalagem] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90)
);


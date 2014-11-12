CREATE TABLE [dbo].[Tipo_Grupo_Produto] (
    [cd_tipo_grupo_produto] INT          NOT NULL,
    [nm_tipo_grupo_produto] VARCHAR (30) NOT NULL,
    [sg_tipo_grupo_produto] CHAR (10)    NOT NULL,
    [cd_imagem]             INT          NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Grupo_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_grupo_produto] ASC) WITH (FILLFACTOR = 90)
);


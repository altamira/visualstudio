CREATE TABLE [dbo].[Tipo_Valoracao_Produto] (
    [cd_tipo_valoracao_produto] INT          NOT NULL,
    [nm_tipo_valoracao_produto] VARCHAR (30) NOT NULL,
    [sg_tipo_valoracao_produto] CHAR (10)    NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_valoracao_produto] PRIMARY KEY CLUSTERED ([cd_tipo_valoracao_produto] ASC) WITH (FILLFACTOR = 90)
);


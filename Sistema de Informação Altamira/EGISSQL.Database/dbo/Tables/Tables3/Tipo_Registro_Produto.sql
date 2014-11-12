CREATE TABLE [dbo].[Tipo_Registro_Produto] (
    [cd_tipo_registro_produto] INT          NOT NULL,
    [nm_tipo_registro_produto] VARCHAR (40) NULL,
    [sg_tipo_registro_produto] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Registro_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_registro_produto] ASC) WITH (FILLFACTOR = 90)
);


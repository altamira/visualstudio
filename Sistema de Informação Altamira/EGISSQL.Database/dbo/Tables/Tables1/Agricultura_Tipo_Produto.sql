CREATE TABLE [dbo].[Agricultura_Tipo_Produto] (
    [cd_tipo_produto]          INT          NOT NULL,
    [nm_tipo_produto]          VARCHAR (60) NULL,
    [nm_fantasia_tipo_produto] VARCHAR (15) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Agricultura_Tipo_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_produto] ASC)
);


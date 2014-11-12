CREATE TABLE [dbo].[Produto_Registro] (
    [cd_produto]               INT          NOT NULL,
    [cd_tipo_registro_produto] INT          NOT NULL,
    [cd_produto_registro]      VARCHAR (40) NOT NULL,
    [cd_pais]                  INT          NULL,
    [nm_obs_produto_registro]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Produto_Registro] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_tipo_registro_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Registro_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);


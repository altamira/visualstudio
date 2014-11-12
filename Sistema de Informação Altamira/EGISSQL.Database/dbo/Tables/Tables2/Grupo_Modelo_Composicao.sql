CREATE TABLE [dbo].[Grupo_Modelo_Composicao] (
    [cd_grupo_modelo_produto]    INT          NOT NULL,
    [cd_item_composicao]         INT          NOT NULL,
    [nm_item_composicao]         VARCHAR (60) NULL,
    [cd_mascara_composicao]      VARCHAR (30) NULL,
    [sg_item_composicao]         CHAR (10)    NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_grupo_modelo_pai]        INT          NULL,
    [ds_grupo_modelo_composicao] TEXT         NULL,
    CONSTRAINT [PK_Grupo_Modelo_Composicao] PRIMARY KEY CLUSTERED ([cd_grupo_modelo_produto] ASC, [cd_item_composicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Modelo_Composicao_Grupo_Modelo_Produto] FOREIGN KEY ([cd_grupo_modelo_produto]) REFERENCES [dbo].[Grupo_Modelo_Produto] ([cd_grupo_modelo_produto])
);


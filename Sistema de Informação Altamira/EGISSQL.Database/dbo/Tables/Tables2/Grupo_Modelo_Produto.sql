CREATE TABLE [dbo].[Grupo_Modelo_Produto] (
    [cd_grupo_modelo_produto] INT          NOT NULL,
    [nm_grupo_modelo_produto] VARCHAR (60) NULL,
    [sg_grupo_modelo_produto] CHAR (10)    NULL,
    [ds_grupo_modelo_produto] TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_ref_grupo_modelo]     VARCHAR (30) NULL,
    [cd_mascara_grupo_modelo] VARCHAR (30) NULL,
    [cd_ordem_grupo_modelo]   INT          NULL,
    CONSTRAINT [PK_Grupo_Modelo_Produto] PRIMARY KEY CLUSTERED ([cd_grupo_modelo_produto] ASC) WITH (FILLFACTOR = 90)
);


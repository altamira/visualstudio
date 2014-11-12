CREATE TABLE [dbo].[Grupo_Inventario] (
    [cd_grupo_inventario]       INT           NOT NULL,
    [nm_grupo_inventario]       VARCHAR (40)  NULL,
    [sg_grupo_inventario]       CHAR (10)     NULL,
    [nm_registro_inventario]    VARCHAR (100) NULL,
    [ic_ativo_grupo_inventario] CHAR (1)      NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [cd_tipo_grupo_inventario]  INT           NULL,
    [cd_lancamento_padrao]      INT           NULL,
    [cd_sped_fiscal]            VARCHAR (15)  NULL,
    CONSTRAINT [PK_Grupo_Inventario] PRIMARY KEY CLUSTERED ([cd_grupo_inventario] ASC) WITH (FILLFACTOR = 90)
);


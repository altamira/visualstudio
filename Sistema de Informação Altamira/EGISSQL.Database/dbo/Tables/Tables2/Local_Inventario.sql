CREATE TABLE [dbo].[Local_Inventario] (
    [cd_local_inventario]       INT          NOT NULL,
    [nm_local_inventario]       VARCHAR (30) NULL,
    [sg_local_inventario]       CHAR (10)    NULL,
    [ic_ativo_local_inventario] CHAR (1)     NULL,
    [cd_usu_local_inventario]   INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_fase_produto]           INT          NULL,
    CONSTRAINT [PK_Local_Inventario] PRIMARY KEY CLUSTERED ([cd_local_inventario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Local_Inventario_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto])
);


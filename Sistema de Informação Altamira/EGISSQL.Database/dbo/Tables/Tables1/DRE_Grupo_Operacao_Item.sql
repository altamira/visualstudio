CREATE TABLE [dbo].[DRE_Grupo_Operacao_Item] (
    [cd_operacao]           INT      NOT NULL,
    [cd_item_operacao]      INT      NULL,
    [cd_dre_grupo]          INT      NULL,
    [cd_item_dre_grupo]     INT      NULL,
    [ic_tipo_operacao]      CHAR (1) NULL,
    [cd_usuario]            INT      NULL,
    [dt_usuario]            DATETIME NULL,
    [cd_dre_grupo_operacao] INT      NULL,
    CONSTRAINT [PK_DRE_Grupo_Operacao_Item] PRIMARY KEY CLUSTERED ([cd_operacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_DRE_Grupo_Operacao_Item_DRE_Grupo_Operacao] FOREIGN KEY ([cd_dre_grupo_operacao]) REFERENCES [dbo].[DRE_Grupo_Operacao] ([cd_operacao])
);


CREATE TABLE [dbo].[Norma_Qualidade_Composicao] (
    [cd_norma_qualidade]          INT           NOT NULL,
    [cd_item_norma_qualidade]     INT           NOT NULL,
    [nm_item_norma_qualidade]     VARCHAR (60)  NULL,
    [cd_item_mascara_norma]       VARCHAR (20)  NULL,
    [cd_ref_item_norma_qualidade] VARCHAR (15)  NULL,
    [ds_item_norma_qualidade]     TEXT          NULL,
    [nm_caminho_item_norma]       VARCHAR (100) NULL,
    [cd_usuario]                  INT           NULL,
    [dt_usuario]                  DATETIME      NULL,
    CONSTRAINT [PK_Norma_Qualidade_Composicao] PRIMARY KEY CLUSTERED ([cd_norma_qualidade] ASC, [cd_item_norma_qualidade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Norma_Qualidade_Composicao_Norma_Qualidade] FOREIGN KEY ([cd_norma_qualidade]) REFERENCES [dbo].[Norma_Qualidade] ([cd_norma_qualidade])
);


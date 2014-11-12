CREATE TABLE [dbo].[Nota_Saida_Item_Ocorrencia] (
    [cd_nota_saida]          INT          NOT NULL,
    [cd_item_nota_saida]     INT          NULL,
    [cd_ocorrencia_entrega]  INT          NULL,
    [cd_motivo_ocorrencia]   INT          NULL,
    [qt_ocorrencia]          FLOAT (53)   NULL,
    [nm_obs_item_ocorrencia] VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Nota_Saida_Item_Ocorrencia] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC) WITH (FILLFACTOR = 90)
);


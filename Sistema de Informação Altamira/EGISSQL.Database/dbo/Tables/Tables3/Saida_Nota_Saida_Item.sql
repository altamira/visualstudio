CREATE TABLE [dbo].[Saida_Nota_Saida_Item] (
    [cd_sedex_nota_saida]       INT          NOT NULL,
    [cd_item_sedex_nota_saida]  INT          NOT NULL,
    [cd_nota_saida]             INT          NOT NULL,
    [qt_pes_item_sede_not_said] FLOAT (53)   NOT NULL,
    [vl_custo_sedex_nota_saida] MONEY        NOT NULL,
    [nm_obs_item_sede_not_said] VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Saida_Nota_Saida_Item] PRIMARY KEY CLUSTERED ([cd_sedex_nota_saida] ASC, [cd_item_sedex_nota_saida] ASC) WITH (FILLFACTOR = 90)
);


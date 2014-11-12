CREATE TABLE [dbo].[Ordem_Servico_Grafica_Composicao] (
    [cd_ordem_servico]       INT          NOT NULL,
    [cd_item_servico]        INT          NOT NULL,
    [cd_item_composicao]     INT          NOT NULL,
    [cd_tipo_caderno]        INT          NULL,
    [cd_cor]                 INT          NULL,
    [cd_pantone]             INT          NULL,
    [nm_obs_item_composicao] VARCHAR (60) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_item_ordem_servico]  INT          NOT NULL,
    [cd_caderno]             INT          NULL,
    CONSTRAINT [PK_Ordem_Servico_Grafica_Composicao] PRIMARY KEY CLUSTERED ([cd_ordem_servico] ASC, [cd_item_servico] ASC, [cd_item_composicao] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[consulta_item_servico_externo] (
    [cd_consulta]              INT          NOT NULL,
    [cd_item_consulta]         INT          NOT NULL,
    [cd_item_servico_externo]  INT          NOT NULL,
    [cd_servico_especial]      INT          NULL,
    [nm_sevico_externo]        VARCHAR (50) NULL,
    [qt_item_servico_externo]  FLOAT (53)   NULL,
    [cd_unidade_medida]        INT          NULL,
    [vl_unit_servico_externo]  FLOAT (53)   NULL,
    [vl_total_servico_externo] FLOAT (53)   NULL,
    [nm_obs_servico_externo]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [nm_servico_externo]       VARCHAR (50) NULL,
    [cd_aplicacao_markup]      INT          NULL,
    CONSTRAINT [PK_consulta_item_servico_externo] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_item_servico_externo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_consulta_item_servico_externo_Servico_Especial] FOREIGN KEY ([cd_servico_especial]) REFERENCES [dbo].[Servico_Especial] ([cd_servico_especial]),
    CONSTRAINT [FK_consulta_item_servico_externo_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);


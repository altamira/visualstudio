CREATE TABLE [dbo].[Contrato_Servico_Reajuste] (
    [cd_contrato_servico]       INT        NOT NULL,
    [dt_reajuste_contrato]      DATETIME   NOT NULL,
    [cd_indice_reajuste]        INT        NULL,
    [cd_motivo_reajuste]        INT        NULL,
    [vl_reajuste_contrato]      FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [cd_item_contrato_reajuste] INT        NOT NULL,
    CONSTRAINT [PK_Contrato_Servico_Reajuste] PRIMARY KEY CLUSTERED ([cd_contrato_servico] ASC, [dt_reajuste_contrato] ASC, [cd_item_contrato_reajuste] ASC) WITH (FILLFACTOR = 90)
);


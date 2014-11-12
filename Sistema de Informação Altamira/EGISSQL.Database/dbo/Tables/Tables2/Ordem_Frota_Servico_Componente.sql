CREATE TABLE [dbo].[Ordem_Frota_Servico_Componente] (
    [cd_ordem]            INT          NOT NULL,
    [cd_componente_ordem] INT          NULL,
    [cd_produto]          INT          NULL,
    [vl_custo_produto]    FLOAT (53)   NULL,
    [qt_componente_ordem] FLOAT (53)   NULL,
    [vl_componente_ordem] FLOAT (53)   NULL,
    [nm_obs_componente]   VARCHAR (40) NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [vl_total_ordem]      FLOAT (53)   NULL,
    CONSTRAINT [PK_Ordem_Frota_Servico_Componente] PRIMARY KEY CLUSTERED ([cd_ordem] ASC) WITH (FILLFACTOR = 90)
);


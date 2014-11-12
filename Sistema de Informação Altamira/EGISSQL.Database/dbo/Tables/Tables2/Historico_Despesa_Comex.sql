CREATE TABLE [dbo].[Historico_Despesa_Comex] (
    [cd_tipo_despesa_comex]   INT          NOT NULL,
    [dt_historico_desp_comex] DATETIME     NOT NULL,
    [vl_historico_desp_comex] FLOAT (53)   NULL,
    [nm_obs_desp_comex]       VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Historico_Despesa_Comex] PRIMARY KEY CLUSTERED ([cd_tipo_despesa_comex] ASC, [dt_historico_desp_comex] ASC) WITH (FILLFACTOR = 90)
);


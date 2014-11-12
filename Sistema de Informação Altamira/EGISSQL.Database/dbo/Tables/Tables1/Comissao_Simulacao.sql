CREATE TABLE [dbo].[Comissao_Simulacao] (
    [cd_controle]                 INT          NOT NULL,
    [dt_controle]                 DATETIME     NULL,
    [cd_vendedor]                 INT          NOT NULL,
    [cd_cliente]                  INT          NOT NULL,
    [ds_comissao_simulacao]       TEXT         NULL,
    [nm_obs_comissao_simulacao]   VARCHAR (40) NULL,
    [vl_total_comissao_simulacao] FLOAT (53)   NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [cd_contato]                  INT          NULL,
    [cd_moeda]                    INT          NULL,
    [dt_cambio_comissao]          DATETIME     NULL,
    [vl_moeda]                    FLOAT (53)   NULL,
    CONSTRAINT [PK_Comissao_Simulacao] PRIMARY KEY CLUSTERED ([cd_controle] ASC)
);


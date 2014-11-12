CREATE TABLE [dbo].[Despesa_Producao_Valor] (
    [cd_despesa_producao]     INT          NOT NULL,
    [dt_inicio_despesa_prod]  DATETIME     NOT NULL,
    [dt_final_despesa_prod]   DATETIME     NOT NULL,
    [vl_despesa_producao]     FLOAT (53)   NULL,
    [nm_obs_despesa_producao] VARCHAR (40) NULL,
    [cd_plano_conta]          INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Despesa_Producao_Valor] PRIMARY KEY CLUSTERED ([cd_despesa_producao] ASC, [dt_inicio_despesa_prod] ASC, [dt_final_despesa_prod] ASC) WITH (FILLFACTOR = 90)
);


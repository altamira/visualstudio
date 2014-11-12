CREATE TABLE [dbo].[Despesa_Producao] (
    [cd_despesa_producao]     INT          NOT NULL,
    [nm_despesa_producao]     VARCHAR (40) NULL,
    [sg_despesa_producao]     CHAR (10)    NULL,
    [ic_rateio_despesa]       CHAR (1)     NULL,
    [ic_tipo_rateio_despesa]  CHAR (1)     NULL,
    [nm_obs_despesa_producao] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_plano_conta]          INT          NULL,
    [cd_plano_financeiro]     INT          NULL,
    CONSTRAINT [PK_Despesa_Producao] PRIMARY KEY CLUSTERED ([cd_despesa_producao] ASC) WITH (FILLFACTOR = 90)
);


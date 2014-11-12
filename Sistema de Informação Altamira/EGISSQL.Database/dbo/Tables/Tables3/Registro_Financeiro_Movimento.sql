CREATE TABLE [dbo].[Registro_Financeiro_Movimento] (
    [cd_registro_financeiro]      INT          NOT NULL,
    [cd_item_registro_financeiro] INT          NOT NULL,
    [cd_plano_financeiro]         INT          NULL,
    [ic_tipo_movimento]           CHAR (1)     NULL,
    [vl_item_registro_financeiro] FLOAT (53)   NULL,
    [nm_obs_item_registro]        VARCHAR (40) NULL,
    CONSTRAINT [PK_Registro_Financeiro_Movimento] PRIMARY KEY CLUSTERED ([cd_registro_financeiro] ASC, [cd_item_registro_financeiro] ASC) WITH (FILLFACTOR = 90)
);


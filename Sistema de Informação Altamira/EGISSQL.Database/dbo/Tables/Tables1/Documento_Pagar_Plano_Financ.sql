CREATE TABLE [dbo].[Documento_Pagar_Plano_Financ] (
    [cd_documento_pagar]     INT          NOT NULL,
    [cd_plano_financeiro]    INT          NOT NULL,
    [pc_plano_financeiro]    FLOAT (53)   NULL,
    [vl_plano_financeiro]    FLOAT (53)   NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_obs_documento_plano] VARCHAR (40) NULL,
    CONSTRAINT [PK_Documento_Pagar_Plano_Financ] PRIMARY KEY CLUSTERED ([cd_documento_pagar] ASC, [cd_plano_financeiro] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[CIAP_Saldo] (
    [cd_ciap_saldo]      INT          NOT NULL,
    [cd_ciap]            INT          NULL,
    [dt_base_saldo_ciap] DATETIME     NULL,
    [vl_saldo_ciap]      FLOAT (53)   NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [dt_inicial]         DATETIME     NULL,
    [dt_final]           DATETIME     NULL,
    [nm_obs_ciap_saldo]  VARCHAR (40) NULL,
    [vl_fixo_saldo_ciap] FLOAT (53)   NULL,
    CONSTRAINT [PK_CIAP_Saldo] PRIMARY KEY CLUSTERED ([cd_ciap_saldo] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[Regime_Tributario] (
    [cd_regime_tributario] INT          NOT NULL,
    [nm_regime_tributario] VARCHAR (60) NULL,
    [sg_regime_tributario] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_nfe_regime]        CHAR (10)    NULL,
    CONSTRAINT [PK_Regime_Tributario] PRIMARY KEY CLUSTERED ([cd_regime_tributario] ASC)
);


CREATE TABLE [dbo].[Fundamento_Legal_Regime] (
    [cd_fundamento_legal]       INT          NOT NULL,
    [cd_regime_legal]           INT          NOT NULL,
    [cd_item_fund_legal_regime] INT          NOT NULL,
    [nm_obs_fun_legal_regime]   VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Fundamento_Legal_Regime] PRIMARY KEY CLUSTERED ([cd_fundamento_legal] ASC, [cd_regime_legal] ASC, [cd_item_fund_legal_regime] ASC) WITH (FILLFACTOR = 90)
);


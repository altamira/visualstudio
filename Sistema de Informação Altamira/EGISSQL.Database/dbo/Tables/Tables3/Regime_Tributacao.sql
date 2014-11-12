CREATE TABLE [dbo].[Regime_Tributacao] (
    [cd_regime_tributacao] INT          NOT NULL,
    [nm_regime_tributacao] VARCHAR (40) NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [cd_siscomex]          INT          NOT NULL,
    [sg_regime_tributacao] CHAR (10)    NOT NULL,
    CONSTRAINT [PK_Regime_Tributacao] PRIMARY KEY CLUSTERED ([cd_regime_tributacao] ASC) WITH (FILLFACTOR = 90)
);


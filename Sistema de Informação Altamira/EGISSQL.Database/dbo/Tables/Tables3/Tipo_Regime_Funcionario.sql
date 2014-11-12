CREATE TABLE [dbo].[Tipo_Regime_Funcionario] (
    [cd_tipo_regime]     INT          NOT NULL,
    [nm_tipo_regime]     VARCHAR (40) NULL,
    [sg_tipo_regime]     CHAR (10)    NULL,
    [ic_pad_tipo_regime] CHAR (1)     NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Regime_Funcionario] PRIMARY KEY CLUSTERED ([cd_tipo_regime] ASC) WITH (FILLFACTOR = 90)
);


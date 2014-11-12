CREATE TABLE [dbo].[Transportadora_Diversos] (
    [cd_transportadora]         INT          NOT NULL,
    [cd_licenca_policia_fed]    VARCHAR (20) NULL,
    [dt_vcto_licenca]           DATETIME     NULL,
    [nm_obs_licenca]            VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_transportadora_diverso] INT          NOT NULL,
    [dt_licencas]               DATETIME     NULL,
    [ic_ativo_licenca]          CHAR (1)     NULL,
    [cd_licenca_exercito]       VARCHAR (20) NULL,
    [dt_licenca_exercito]       DATETIME     NULL,
    [dt_vencto_exercito]        DATETIME     NULL,
    [cd_licenca_civil]          VARCHAR (20) NULL,
    [dt_licenca_civil]          DATETIME     NULL,
    [dt_vencto_civil]           DATETIME     NULL,
    [cd_empresa_diversa]        INT          NULL,
    [cd_tipo_conta_pagar]       INT          NULL,
    CONSTRAINT [PK_Transportadora_Diversos] PRIMARY KEY CLUSTERED ([cd_transportadora] ASC, [cd_transportadora_diverso] ASC) WITH (FILLFACTOR = 90)
);


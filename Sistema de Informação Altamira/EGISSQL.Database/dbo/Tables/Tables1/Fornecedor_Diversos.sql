CREATE TABLE [dbo].[Fornecedor_Diversos] (
    [cd_fornecedor]          INT          NOT NULL,
    [cd_licenca_policia_fed] VARCHAR (20) NULL,
    [dt_vcto_licenca]        DATETIME     NULL,
    [nm_obs_licenca]         VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_fornecedor_diversos] INT          NOT NULL,
    [dt_licenca]             DATETIME     NULL,
    [ic_ativo_licenca]       CHAR (1)     NULL,
    [cd_licenca_exercito]    VARCHAR (20) NULL,
    [dt_licenca_exercito]    DATETIME     NULL,
    [dt_vencto_exercito]     DATETIME     NULL,
    [cd_licenca_civil]       VARCHAR (20) NULL,
    [dt_licenca_civil]       DATETIME     NULL,
    [dt_vencto_civil]        DATETIME     NULL,
    CONSTRAINT [PK_Fornecedor_Diversos] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_fornecedor_diversos] ASC) WITH (FILLFACTOR = 90)
);


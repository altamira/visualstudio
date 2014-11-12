CREATE TABLE [dbo].[Frete_Importacao] (
    [cd_frete]              INT          NOT NULL,
    [nm_frete]              VARCHAR (60) NULL,
    [nm_fantasia_frete]     VARCHAR (15) NULL,
    [sg_frete]              CHAR (10)    NULL,
    [vl_frete]              FLOAT (53)   NULL,
    [cd_tipo_despesa_comex] INT          NULL,
    [nm_obs_frete]          VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_pais_origem]        INT          NULL,
    [cd_pais_destino]       INT          NULL,
    [cd_moeda]              INT          NULL,
    CONSTRAINT [PK_Frete_Importacao] PRIMARY KEY CLUSTERED ([cd_frete] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Frete_Importacao_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda]),
    CONSTRAINT [FK_Frete_Importacao_Pais] FOREIGN KEY ([cd_pais_destino]) REFERENCES [dbo].[Pais] ([cd_pais])
);


CREATE TABLE [dbo].[Documento_Cobranca] (
    [cd_documento_cobranca]     INT          NOT NULL,
    [cd_identificacao]          VARCHAR (25) NULL,
    [dt_documento_cobranca]     DATETIME     NULL,
    [cd_tipo_documento]         INT          NULL,
    [cd_contrato_cobranca]      INT          NULL,
    [cd_forma_cobranca]         INT          NULL,
    [cd_motivo_cobranca]        INT          NULL,
    [cd_status_cobranca]        INT          NULL,
    [cd_banco]                  INT          NULL,
    [cd_aliena]                 INT          NULL,
    [cd_cobrador]               INT          NULL,
    [dt_vencimento_documento]   DATETIME     NULL,
    [vl_documento_cobranca]     FLOAT (53)   NULL,
    [nm_obs_documento_cobranca] VARCHAR (40) NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    CONSTRAINT [PK_Documento_Cobranca] PRIMARY KEY CLUSTERED ([cd_documento_cobranca] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Cobranca_Cobrador] FOREIGN KEY ([cd_cobrador]) REFERENCES [dbo].[Cobrador] ([cd_cobrador])
);


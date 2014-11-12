CREATE TABLE [dbo].[Pendencia_Financeira] (
    [cd_pendencia_financeira] INT          NOT NULL,
    [dt_pendencia_financeira] DATETIME     NULL,
    [cd_tipo_pendencia]       INT          NULL,
    [vl_pendencia_financeira] FLOAT (53)   NULL,
    [cd_igreja]               INT          NULL,
    [cd_obreiro]              INT          NULL,
    [cd_pastor]               INT          NULL,
    [cd_funcionario]          INT          NULL,
    [cd_motivo_pendencia]     INT          NULL,
    [nm_obs_pendencia]        VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [dt_liquidacao_pendencia] DATETIME     NULL,
    [cd_documento_pagar]      INT          NULL,
    CONSTRAINT [PK_Pendencia_Financeira] PRIMARY KEY CLUSTERED ([cd_pendencia_financeira] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pendencia_Financeira_Documento_Pagar] FOREIGN KEY ([cd_documento_pagar]) REFERENCES [dbo].[Documento_Pagar] ([cd_documento_pagar])
);


CREATE TABLE [dbo].[Devedor] (
    [cd_devedor]           INT          NOT NULL,
    [cd_contrato_cobranca] INT          NULL,
    [nm_devedor]           VARCHAR (40) NULL,
    [cd_tipo_pessoa]       INT          NULL,
    [cd_cpf_devedor]       VARCHAR (14) NULL,
    [cd_cnpj_devedor]      VARCHAR (18) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Devedor] PRIMARY KEY CLUSTERED ([cd_devedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Devedor_Tipo_Pessoa] FOREIGN KEY ([cd_tipo_pessoa]) REFERENCES [dbo].[Tipo_Pessoa] ([cd_tipo_pessoa])
);


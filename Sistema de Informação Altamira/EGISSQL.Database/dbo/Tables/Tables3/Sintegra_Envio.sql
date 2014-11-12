CREATE TABLE [dbo].[Sintegra_Envio] (
    [cd_envio]              INT          NOT NULL,
    [dt_envio]              DATETIME     NULL,
    [cd_tipo_pessoa]        INT          NULL,
    [cd_cnpj_envio]         VARCHAR (18) NULL,
    [cd_ie_envio]           VARCHAR (40) NULL,
    [nm_razao_social_envio] VARCHAR (50) NULL,
    [cd_status_envio]       INT          NULL,
    [cd_estado]             INT          NULL,
    [cd_cliente]            INT          NULL,
    [cd_fornecedor]         INT          NULL,
    [nm_obs_sintegra_envio] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_cpf_envio]          VARCHAR (18) NULL,
    CONSTRAINT [PK_Sintegra_Envio] PRIMARY KEY CLUSTERED ([cd_envio] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Sintegra_Envio_Estado] FOREIGN KEY ([cd_estado]) REFERENCES [dbo].[Estado] ([cd_estado])
);


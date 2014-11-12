CREATE TABLE [dbo].[Usuario_Contato_Endereco] (
    [cd_usuario]             INT          NOT NULL,
    [cd_usuario_contato]     INT          NOT NULL,
    [cd_tipo_endereco]       INT          NOT NULL,
    [cd_identifica_cep]      INT          NULL,
    [dt_cadastro_endereco]   DATETIME     NULL,
    [cd_cep_usuario_contato] CHAR (9)     NULL,
    [nm_endereco_usuario]    VARCHAR (60) NULL,
    [nm_bairro_usuario]      VARCHAR (25) NULL,
    [cd_ddd_usuario]         CHAR (4)     NULL,
    [cd_fax_usuario]         VARCHAR (15) NULL,
    [cd_celular_usuario]     VARCHAR (15) NULL,
    [cd_pais]                INT          NULL,
    [cd_estado]              INT          NULL,
    [cd_cidade]              INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_fone_usuario]        VARCHAR (15) NULL,
    CONSTRAINT [PK_Usuario_Contato_Endereco] PRIMARY KEY CLUSTERED ([cd_usuario] ASC, [cd_usuario_contato] ASC, [cd_tipo_endereco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Usuario_Contato_Endereco_Cep] FOREIGN KEY ([cd_identifica_cep]) REFERENCES [dbo].[Cep] ([cd_identifica_cep])
);


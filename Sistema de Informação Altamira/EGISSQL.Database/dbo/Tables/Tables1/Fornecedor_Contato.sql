CREATE TABLE [dbo].[Fornecedor_Contato] (
    [cd_fornecedor]             INT           NOT NULL,
    [cd_contato_fornecedor]     INT           NOT NULL,
    [nm_contato_fornecedor]     VARCHAR (40)  NULL,
    [nm_fantasia_contato_forne] VARCHAR (15)  NULL,
    [cd_ddd_contato_fornecedor] CHAR (4)      NULL,
    [cd_telefone_contato_forne] VARCHAR (15)  NULL,
    [cd_fax_contato_fornecedor] VARCHAR (15)  NULL,
    [cd_ramal_contato_forneced] VARCHAR (10)  NULL,
    [cd_email_contato_forneced] VARCHAR (100) NULL,
    [ds_observacao_contato_for] TEXT          NULL,
    [cd_senha_intranet_contato] VARCHAR (10)  NULL,
    [cd_cargo]                  INT           NULL,
    [cd_departamento]           INT           NULL,
    [cd_tipo_endereco]          INT           NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [nm_fantasia_fornecedor]    CHAR (15)     NULL,
    [cd_celular_contato_fornec] VARCHAR (15)  NULL,
    [ic_acesso_comnet_contato]  CHAR (1)      NULL,
    [cd_senha_comnet_contato]   VARCHAR (15)  NULL,
    [dt_nascimento_contato]     DATETIME      NULL,
    [cd_tratamento]             INT           NULL,
    [cd_nivel_decisao]          INT           NULL,
    [ic_status_contato]         CHAR (1)      CONSTRAINT [DF_Fornecedor_Contato_ic_status_contato] DEFAULT ('A') NULL,
    [dt_status_contato]         DATETIME      NULL,
    [cd_ddd_celular]            VARCHAR (4)   NULL,
    [cd_ddi_contato_fornecedor] CHAR (4)      NULL,
    [cd_ddi_celular]            VARCHAR (4)   NULL,
    [ic_mala_direta_contato]    CHAR (1)      NULL,
    [ic_nfe_contato]            CHAR (1)      NULL,
    CONSTRAINT [PK_Fornecedor_Contato] PRIMARY KEY CLUSTERED ([cd_fornecedor] ASC, [cd_contato_fornecedor] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Fornecedor_Contato_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor]) ON DELETE CASCADE,
    CONSTRAINT [FK_Fornecedor_Contato_Nivel_Decisao] FOREIGN KEY ([cd_nivel_decisao]) REFERENCES [dbo].[Nivel_Decisao] ([cd_nivel_decisao]),
    CONSTRAINT [FK_Fornecedor_Contato_Tratamento_Pessoa] FOREIGN KEY ([cd_tratamento]) REFERENCES [dbo].[Tratamento_Pessoa] ([cd_tratamento])
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Fornecedor_Contato', @level2type = N'COLUMN', @level2name = N'ic_status_contato';


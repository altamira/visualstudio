CREATE TABLE [dbo].[Funcionario_Dependente_Endereco] (
    [cd_funcionario]          INT           NOT NULL,
    [cd_dependente]           INT           NOT NULL,
    [nm_endereco]             VARCHAR (40)  NULL,
    [cd_numero_endereco]      VARCHAR (10)  NULL,
    [nm_complemento_endereco] VARCHAR (40)  NULL,
    [nm_bairro]               VARCHAR (25)  NULL,
    [cd_identifica_cep]       INT           NULL,
    [cd_cep]                  VARCHAR (8)   NULL,
    [cd_pais]                 INT           NULL,
    [cd_estado]               INT           NULL,
    [cd_cidade]               INT           NULL,
    [cd_ddd]                  VARCHAR (4)   NULL,
    [cd_telefone]             VARCHAR (15)  NULL,
    [nm_email]                VARCHAR (100) NULL,
    [cd_ddd_celular]          VARCHAR (4)   NULL,
    [cd_celular]              VARCHAR (15)  NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    CONSTRAINT [PK_Funcionario_Dependente_Endereco] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_dependente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Dependente_Endereco_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);


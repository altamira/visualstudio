CREATE TABLE [dbo].[Funcionario_Endereco] (
    [cd_funcionario]          INT          NOT NULL,
    [cd_tipo_endereco]        INT          NOT NULL,
    [nm_endereco]             VARCHAR (40) NULL,
    [cd_numero_endereco]      VARCHAR (10) NULL,
    [nm_complemento_endereco] VARCHAR (40) NULL,
    [nm_bairro]               VARCHAR (25) NULL,
    [cd_identifica_cep]       INT          NULL,
    [cd_cep]                  VARCHAR (8)  NULL,
    [cd_pais]                 INT          NULL,
    [cd_estado]               INT          NULL,
    [cd_cidade]               INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_item_endereco]        INT          NOT NULL,
    CONSTRAINT [PK_Funcionario_Endereco] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_item_endereco] ASC) WITH (FILLFACTOR = 90)
);


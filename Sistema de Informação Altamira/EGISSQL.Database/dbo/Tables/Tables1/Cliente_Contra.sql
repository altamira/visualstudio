CREATE TABLE [dbo].[Cliente_Contra] (
    [cd_cliente_contra]       INT          NOT NULL,
    [nm_cliente_contra]       VARCHAR (45) NULL,
    [cd_tipo_pesso]           INT          NULL,
    [cd_pais]                 INT          NULL,
    [cd_estado]               INT          NULL,
    [cd_cidade]               INT          NULL,
    [cd_identifica_cep]       INT          NULL,
    [nm_endereco]             VARCHAR (60) NULL,
    [cd_numero_endereco]      VARCHAR (10) NULL,
    [nm_complemento_endereco] VARCHAR (30) NULL,
    [nm_bairro]               VARCHAR (25) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_advogado]             INT          NULL,
    CONSTRAINT [PK_Cliente_Contra] PRIMARY KEY CLUSTERED ([cd_cliente_contra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Contra_Advogado] FOREIGN KEY ([cd_advogado]) REFERENCES [dbo].[Advogado] ([cd_advogado])
);


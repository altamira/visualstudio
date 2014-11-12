CREATE TABLE [dbo].[Processo_Juridico_Contra] (
    [cd_processo_contra]      INT          NOT NULL,
    [cd_processo_juridico]    INT          NULL,
    [cd_cliente_contra]       INT          NULL,
    [nm_contra]               VARCHAR (50) NULL,
    [cd_pais]                 INT          NULL,
    [cd_estado]               INT          NULL,
    [cd_cidade]               INT          NULL,
    [cd_identifica_cep]       INT          NULL,
    [nm_endereco]             VARCHAR (60) NULL,
    [cd_numero_endereco]      INT          NULL,
    [nm_complemento_endereco] VARCHAR (30) NULL,
    [nm_bairro]               VARCHAR (25) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Processo_Juridico_Contra] PRIMARY KEY CLUSTERED ([cd_processo_contra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Juridico_Contra_Estado] FOREIGN KEY ([cd_estado]) REFERENCES [dbo].[Estado] ([cd_estado])
);


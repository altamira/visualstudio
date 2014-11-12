CREATE TABLE [dbo].[Transportadora_Endereco] (
    [cd_transportadora]         INT          NOT NULL,
    [cd_tipo_endereco]          INT          NOT NULL,
    [cd_identifica_cep]         INT          NULL,
    [cd_cnpj]                   VARCHAR (18) NULL,
    [cd_insc_estadual]          VARCHAR (18) NULL,
    [cd_insc_municipal]         VARCHAR (18) NULL,
    [cd_cep]                    CHAR (9)     NULL,
    [nm_endereco]               VARCHAR (60) NULL,
    [cd_numero_endereco]        INT          NULL,
    [nm_complemento_endereco]   VARCHAR (30) NULL,
    [nm_bairro]                 VARCHAR (25) NULL,
    [cd_ddd]                    CHAR (4)     NULL,
    [cd_telefone]               VARCHAR (15) NULL,
    [cd_fax]                    VARCHAR (15) NULL,
    [cd_pais]                   INT          NULL,
    [cd_estado]                 INT          NULL,
    [cd_cidade]                 INT          NULL,
    [ic_tipo]                   CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [nm_complemento_logradouro] VARCHAR (30) NULL,
    CONSTRAINT [PK_Transportadora_Endereco] PRIMARY KEY NONCLUSTERED ([cd_transportadora] ASC, [cd_tipo_endereco] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE CLUSTERED INDEX [idx_transportadora_endereco]
    ON [dbo].[Transportadora_Endereco]([cd_transportadora] ASC, [cd_tipo_endereco] ASC) WITH (FILLFACTOR = 90);


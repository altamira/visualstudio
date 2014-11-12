CREATE TABLE [dbo].[Advogado] (
    [cd_advogado]              INT          NOT NULL,
    [nm_advogado]              VARCHAR (50) NULL,
    [nm_fantasia_advogado]     VARCHAR (15) NULL,
    [cd_cpf_advogado]          INT          NULL,
    [cd_oab_advogado]          VARCHAR (30) NULL,
    [ds_advogado]              TEXT         NULL,
    [cd_pais]                  INT          NULL,
    [cd_estado]                INT          NULL,
    [cd_cidade]                INT          NULL,
    [cd_identifica_cep]        INT          NULL,
    [nm_endereco]              VARCHAR (60) NULL,
    [cd_numero_endereco]       VARCHAR (10) NULL,
    [nm_complemento_endereco]  VARCHAR (30) NULL,
    [nm_bairro]                VARCHAR (25) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_advogacia]             INT          NULL,
    [cd_tipo_proceso_juridico] INT          NULL,
    CONSTRAINT [PK_Advogado] PRIMARY KEY CLUSTERED ([cd_advogado] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Advogado_Tipo_Processo_Juridico] FOREIGN KEY ([cd_tipo_proceso_juridico]) REFERENCES [dbo].[Tipo_Processo_Juridico] ([cd_tipo_processo_juridico])
);


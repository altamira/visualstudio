CREATE TABLE [dbo].[PESENT] (
    [PESENT_CONTATO]     NVARCHAR (40)  NULL,
    [PESENT_FONE]        NVARCHAR (100) NULL,
    [PESENT_FAX]         NVARCHAR (100) NULL,
    [PESENT_EMAIL]       NVARCHAR (100) NULL,
    [pesent_cep]         INT            NULL,
    [pesent_especie]     NVARCHAR (4)   NULL,
    [pesent_endereco]    NVARCHAR (40)  NULL,
    [pesent_numero]      NVARCHAR (6)   NULL,
    [pesent_complemento] NVARCHAR (30)  NULL,
    [pesent_bairro]      NVARCHAR (30)  NULL,
    [pesent_municipio]   NVARCHAR (30)  NULL,
    [pesent_uf]          NVARCHAR (2)   NULL,
    [PESENT_PESSOA]      INT            NULL,
    [PESENT_SEQ]         INT            NULL,
    [PESENT_ENTTIP]      NVARCHAR (50)  NULL
);


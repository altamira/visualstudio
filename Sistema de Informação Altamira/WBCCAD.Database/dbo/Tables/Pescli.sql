CREATE TABLE [dbo].[Pescli] (
    [pescli_codigo]         INT           NOT NULL,
    [pescli_et_especie]     NVARCHAR (4)  NULL,
    [pescli_et_endereco]    NVARCHAR (40) NULL,
    [pescli_et_numero]      NVARCHAR (6)  NULL,
    [pescli_et_complemento] NVARCHAR (30) NULL,
    [pescli_et_bairro]      NVARCHAR (30) NULL,
    [pescli_et_municipio]   NVARCHAR (30) NULL,
    [pescli_et_uf]          NVARCHAR (2)  NULL,
    [pescli_et_cep]         INT           NULL,
    [pescli_cb_especie]     NVARCHAR (4)  NULL,
    [pescli_cb_endereco]    NVARCHAR (40) NULL,
    [pescli_cb_numero]      NVARCHAR (6)  NULL,
    [pescli_cb_complemento] NVARCHAR (30) NULL,
    [pescli_cb_bairro]      NVARCHAR (30) NULL,
    [pescli_cb_municipio]   NVARCHAR (30) NULL,
    [pescli_cb_uf]          NVARCHAR (2)  NULL,
    [pescli_cb_cep]         INT           NULL,
    [pescli_comissao]       FLOAT (53)    NULL,
    [pescli_categoria]      NVARCHAR (20) NULL,
    [pescli_status]         NVARCHAR (30) NULL,
    [idPescli]              INT           IDENTITY (1, 1) NOT NULL
);


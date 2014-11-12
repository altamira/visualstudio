CREATE TABLE [dbo].[tabuf] (
    [tabuf_codigo]     NVARCHAR (2)  NULL,
    [tabuf_descricao]  NVARCHAR (40) NULL,
    [GrupoImpostos]    NVARCHAR (50) NULL,
    [tabuf_icms]       FLOAT (53)    NULL,
    [tabuf_icms_local] FLOAT (53)    NULL,
    [Incluir_fator]    FLOAT (53)    NULL,
    [Retirar_fator]    FLOAT (53)    NULL,
    [tabuf_chave_cep]  INT           NULL,
    [tabuf_regiao]     NVARCHAR (2)  NULL,
    [PAISCODIGO]       NVARCHAR (5)  NULL,
    [idTabuf]          INT           IDENTITY (1, 1) NOT NULL
);


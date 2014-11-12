CREATE TABLE [dbo].[Cep] (
    [cd_identifica_cep]  INT          NOT NULL,
    [cd_cep]             CHAR (9)     NULL,
    [cd_pais]            INT          NULL,
    [cd_estado]          INT          NULL,
    [cd_cidade]          INT          NULL,
    [cd_regiao]          INT          NULL,
    [cd_zona]            INT          NULL,
    [cd_distrito]        INT          NULL,
    [cd_tipo_logradouro] INT          NULL,
    [cd_divisao_regiao]  INT          NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [nm_pagguia_cep]     VARCHAR (10) NULL,
    [nm_endereco_cep]    VARCHAR (50) NULL,
    CONSTRAINT [PK_Cep] PRIMARY KEY CLUSTERED ([cd_identifica_cep] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ix_cd_cep]
    ON [dbo].[Cep]([cd_cep] ASC) WITH (FILLFACTOR = 90);


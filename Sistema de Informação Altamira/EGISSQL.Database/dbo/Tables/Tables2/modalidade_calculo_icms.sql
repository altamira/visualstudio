CREATE TABLE [dbo].[modalidade_calculo_icms] (
    [cd_modalidade_icms]   INT          NOT NULL,
    [nm_modalidade_icms]   VARCHAR (60) NULL,
    [ic_padrao_modalidade] CHAR (1)     NULL,
    [cd_digito_modalidade] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL
);


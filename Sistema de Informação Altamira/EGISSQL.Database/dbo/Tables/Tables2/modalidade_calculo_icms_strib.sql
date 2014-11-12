CREATE TABLE [dbo].[modalidade_calculo_icms_strib] (
    [cd_modalidade_icms_st]   INT          NOT NULL,
    [nm_modalidade_icms_st]   VARCHAR (60) NULL,
    [ic_padrao_modalidade_st] CHAR (1)     NULL,
    [cd_digito_modalidade_st] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_modalidade]           INT          NULL
);


CREATE TABLE [dbo].[tributacao_ipi] (
    [cd_tributacao_ipi]        INT          NOT NULL,
    [nm_tributacao_ipi]        VARCHAR (60) NOT NULL,
    [cd_digito_tributacao_ipi] CHAR (2)     NOT NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [sg_tab_nfe_tributacao]    VARCHAR (5)  NULL,
    [ic_indicador_tributacao]  CHAR (1)     NULL
);


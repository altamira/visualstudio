CREATE TABLE [dbo].[tributacao_pis] (
    [cd_tributacao_pis]        INT          NOT NULL,
    [nm_tributacao_pis]        VARCHAR (60) NOT NULL,
    [cd_digito_tributacao_pis] CHAR (2)     NOT NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [sg_tab_nfe_tributacao]    VARCHAR (5)  NULL,
    [ic_calculo_pis]           CHAR (1)     NULL
);


CREATE TABLE [dbo].[tributacao_cofins] (
    [cd_tributacao_cofins]        INT          NOT NULL,
    [nm_tributacao_cofins]        VARCHAR (60) NOT NULL,
    [cd_digito_tributacao_cofins] CHAR (2)     NOT NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [sg_tab_nfe_tributacao]       VARCHAR (5)  NULL,
    [ic_calculo_cofins]           CHAR (1)     NULL
);


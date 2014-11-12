CREATE TABLE [dbo].[Tributacao_ICMS] (
    [cd_tributacao_icms]        INT          NOT NULL,
    [nm_tributacao_icms]        VARCHAR (60) NOT NULL,
    [cd_digito_tributacao_icms] CHAR (2)     NOT NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [sg_tab_nfe_tributacao]     VARCHAR (5)  NULL,
    [ic_indicador_tributacao]   CHAR (1)     NULL,
    CONSTRAINT [PK_Tributacao_ICMS] PRIMARY KEY CLUSTERED ([cd_tributacao_icms] ASC) WITH (FILLFACTOR = 90)
);


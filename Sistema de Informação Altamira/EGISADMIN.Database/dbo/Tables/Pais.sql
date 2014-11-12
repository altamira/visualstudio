CREATE TABLE [dbo].[Pais] (
    [cd_pais]                   INT          NOT NULL,
    [nm_pais]                   VARCHAR (40) NOT NULL,
    [sg_pais]                   CHAR (5)     NULL,
    [cd_ddi_pais]               CHAR (4)     NULL,
    [cd_siscomex_pais]          INT          NULL,
    [sg_extensao_internet_pais] CHAR (2)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_aladi_pais]             CHAR (1)     NULL,
    [ic_mercosul_pais]          CHAR (1)     NULL,
    [vl_limite_credito_pais]    FLOAT (53)   NULL,
    [cd_siscomex]               INT          NULL
);


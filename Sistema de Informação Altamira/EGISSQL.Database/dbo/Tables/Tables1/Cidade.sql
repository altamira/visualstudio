CREATE TABLE [dbo].[Cidade] (
    [cd_pais]               INT          NOT NULL,
    [cd_estado]             INT          NOT NULL,
    [cd_cidade]             INT          NOT NULL,
    [nm_cidade]             VARCHAR (60) NOT NULL,
    [sg_cidade]             CHAR (10)    NULL,
    [cd_ddd_cidade]         CHAR (4)     NULL,
    [cd_cep_cidade]         CHAR (9)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_iss_retido_cidade]  CHAR (1)     NULL,
    [pc_iss_retido_cidade]  FLOAT (53)   NULL,
    [ic_capital_cidade]     CHAR (1)     NULL,
    [ic_zona_franca]        CHAR (1)     NULL,
    [ic_zona_franca_icms]   CHAR (1)     NULL,
    [ic_gia_valido_cidade]  CHAR (1)     NULL,
    [dt_aniversario_cidade] DATETIME     NULL,
    [cd_cidade_ibge]        INT          NULL,
    CONSTRAINT [PK_Cidade] PRIMARY KEY CLUSTERED ([cd_pais] ASC, [cd_estado] ASC, [cd_cidade] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[Estado_Parametro] (
    [cd_pais]                       INT         NOT NULL,
    [cd_estado]                     INT         NOT NULL,
    [ic_zona_franca]                CHAR (1)    NULL,
    [ic_resumo_entrada]             CHAR (1)    NULL,
    [ic_resumo_saida]               CHAR (1)    NULL,
    [cd_digito_fiscal_saida]        INT         NULL,
    [cd_digito_fiscal_entrada]      INT         NULL,
    [pc_aliquota_icms_estado]       FLOAT (53)  NULL,
    [pc_aliquota_icms_interna]      FLOAT (53)  NULL,
    [qt_base_calculo_icms]          FLOAT (53)  NULL,
    [cd_usuario]                    INT         NULL,
    [dt_usuario]                    DATETIME    NULL,
    [ds_zona_franca]                TEXT        NULL,
    [ic_mostra_icms_corpo_nota]     CHAR (1)    NULL,
    [pc_icms_substrib_estado]       FLOAT (53)  NULL,
    [cd_dispositivo_legal]          INT         NULL,
    [cd_fiscal_tipo_produto]        VARCHAR (5) NULL,
    [cd_fiscal_produto_uso_proprio] VARCHAR (5) NULL,
    CONSTRAINT [PK_Estado_Parametro] PRIMARY KEY CLUSTERED ([cd_pais] ASC, [cd_estado] ASC) WITH (FILLFACTOR = 90)
);


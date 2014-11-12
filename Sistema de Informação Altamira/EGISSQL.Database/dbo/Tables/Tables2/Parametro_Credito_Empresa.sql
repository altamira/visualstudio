CREATE TABLE [dbo].[Parametro_Credito_Empresa] (
    [qt_titulo_aberto_total]    INT        NOT NULL,
    [vl_compra_aberto]          FLOAT (53) NOT NULL,
    [ic_cadastro]               CHAR (1)   NOT NULL,
    [ic_cliente_ativo]          CHAR (1)   NOT NULL,
    [qt_dia_cadastro]           INT        NOT NULL,
    [ic_primeira_compra]        CHAR (1)   NOT NULL,
    [cd_conceito_cliente]       INT        NOT NULL,
    [ic_protesto]               CHAR (1)   NOT NULL,
    [vl_limite_credito_empresa] FLOAT (53) NOT NULL,
    [qt_dia_atraso]             INT        NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL
);


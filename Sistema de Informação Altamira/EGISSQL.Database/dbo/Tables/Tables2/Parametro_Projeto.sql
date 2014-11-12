CREATE TABLE [dbo].[Parametro_Projeto] (
    [cd_empresa]                INT      NOT NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    [ic_liberacao_composicao]   CHAR (1) NULL,
    [ic_complemento_projeto]    CHAR (1) NULL,
    [ic_numeracao_automatica]   CHAR (1) NULL,
    [ic_sigla_projeto]          CHAR (1) NULL,
    [ic_filtro_periodo_projeto] CHAR (1) NULL,
    [ic_email_liberacao]        CHAR (1) NULL,
    [ic_email_lib_projeto]      CHAR (1) NULL,
    [ic_projeto_inicial_compra] CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Projeto] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);


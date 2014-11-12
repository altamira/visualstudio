CREATE TABLE [dbo].[Parametro_Formacao_Preco] (
    [cd_empresa]                 INT        NOT NULL,
    [cd_aplicacao_markup]        INT        NULL,
    [cd_tipo_lucro]              INT        NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    [ic_gera_temp_calculo_preco] CHAR (1)   NULL,
    [ic_tipo_preco_custo]        CHAR (1)   NULL,
    [qt_arrendodamento_preco]    FLOAT (53) NULL,
    CONSTRAINT [PK_Parametro_Formacao_Preco] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Formacao_Preco_Tipo_Lucro] FOREIGN KEY ([cd_tipo_lucro]) REFERENCES [dbo].[Tipo_Lucro] ([cd_tipo_lucro])
);


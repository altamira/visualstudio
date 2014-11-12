CREATE TABLE [dbo].[Parametro_Orcamento_Estampo] (
    [cd_empresa]                 INT        NOT NULL,
    [cd_aplicacao_markup]        INT        NULL,
    [cd_tipo_lucro]              INT        NULL,
    [cd_usuario]                 INT        NULL,
    [dt_usuario]                 DATETIME   NULL,
    [qt_aproveitamento_material] FLOAT (53) NULL,
    [qt_producao_hora]           FLOAT (53) NULL,
    [qt_hora_montagem]           FLOAT (53) NULL,
    [qt_maquina_producao]        FLOAT (53) NULL,
    CONSTRAINT [PK_Parametro_Orcamento_Estampo] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Orcamento_Estampo_Tipo_Lucro] FOREIGN KEY ([cd_tipo_lucro]) REFERENCES [dbo].[Tipo_Lucro] ([cd_tipo_lucro])
);


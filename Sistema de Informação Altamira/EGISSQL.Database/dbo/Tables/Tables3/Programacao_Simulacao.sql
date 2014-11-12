CREATE TABLE [dbo].[Programacao_Simulacao] (
    [cd_simulacao_prog]      INT          NOT NULL,
    [dt_simulacao_prog]      DATETIME     NULL,
    [cd_tipo_simulacao_prog] INT          NULL,
    [cd_processo]            INT          NULL,
    [cd_consulta]            INT          NULL,
    [cd_item_consulta]       INT          NULL,
    [cd_pedido_venda]        INT          NULL,
    [cd_item_pedido_venda]   INT          NULL,
    [nm_obs_simulacao_prog]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_item_projeto]        INT          NULL,
    [cd_projeto]             INT          NULL,
    [cd_projeto_material]    INT          NULL,
    CONSTRAINT [PK_Programacao_Simulacao] PRIMARY KEY CLUSTERED ([cd_simulacao_prog] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programacao_Simulacao_Consulta] FOREIGN KEY ([cd_consulta]) REFERENCES [dbo].[Consulta] ([cd_consulta]),
    CONSTRAINT [FK_Programacao_Simulacao_Projeto] FOREIGN KEY ([cd_projeto]) REFERENCES [dbo].[Projeto] ([cd_projeto]),
    CONSTRAINT [FK_Programacao_Simulacao_Tipo_Simulacao_Programacao] FOREIGN KEY ([cd_tipo_simulacao_prog]) REFERENCES [dbo].[Tipo_Simulacao_Programacao] ([cd_tipo_simulacao_prog])
);


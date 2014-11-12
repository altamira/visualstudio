CREATE TABLE [dbo].[Programacao_Simulacao_Item] (
    [cd_simulacao_prog]      INT          NULL,
    [cd_item_simulacao]      INT          NOT NULL,
    [cd_operacao]            INT          NULL,
    [cd_numero_operacao]     INT          NULL,
    [qt_hora_simulacao_prog] FLOAT (53)   NULL,
    [cd_maquina]             INT          NULL,
    [nm_obs_simulacao_prog]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Programacao_Simulacao_Item] PRIMARY KEY CLUSTERED ([cd_item_simulacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programacao_Simulacao_Item_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina]),
    CONSTRAINT [FK_Programacao_Simulacao_Item_Operacao] FOREIGN KEY ([cd_operacao]) REFERENCES [dbo].[Operacao] ([cd_operacao]),
    CONSTRAINT [FK_Programacao_Simulacao_Item_Programacao_Simulacao] FOREIGN KEY ([cd_simulacao_prog]) REFERENCES [dbo].[Programacao_Simulacao] ([cd_simulacao_prog])
);


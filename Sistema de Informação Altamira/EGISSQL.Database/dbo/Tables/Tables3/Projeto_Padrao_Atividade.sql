CREATE TABLE [dbo].[Projeto_Padrao_Atividade] (
    [cd_projeto_padrao]        INT        NOT NULL,
    [cd_atividade_implantacao] INT        NOT NULL,
    [qt_atividade_projeto]     FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [qt_ordem_atividade]       INT        NULL,
    CONSTRAINT [PK_Projeto_Padrao_Atividade] PRIMARY KEY CLUSTERED ([cd_projeto_padrao] ASC, [cd_atividade_implantacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Padrao_Atividade_Atividade_Implantacao] FOREIGN KEY ([cd_atividade_implantacao]) REFERENCES [dbo].[Atividade_Implantacao] ([cd_atividade])
);


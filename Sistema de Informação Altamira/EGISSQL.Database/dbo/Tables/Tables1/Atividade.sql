CREATE TABLE [dbo].[Atividade] (
    [cd_atividade]           INT           NOT NULL,
    [nm_atividade]           VARCHAR (40)  NOT NULL,
    [ic_ativo_atividade]     CHAR (1)      NULL,
    [ds_atividade]           TEXT          NULL,
    [cd_usuario_responsavel] INT           NULL,
    [cd_cargo_empresa]       INT           NULL,
    [cd_processo_iso]        INT           NULL,
    [cd_instrucao]           INT           NULL,
    [nm_obs_atividade]       VARCHAR (40)  NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [nm_doc_atividade]       VARCHAR (100) NULL,
    [nm_fluxo_atividade]     VARCHAR (100) NULL,
    [cd_area]                INT           NULL,
    CONSTRAINT [PK_Atividade] PRIMARY KEY CLUSTERED ([cd_atividade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Atividade_Area] FOREIGN KEY ([cd_area]) REFERENCES [dbo].[Area] ([cd_area]),
    CONSTRAINT [FK_Atividade_Instrucao_Interna] FOREIGN KEY ([cd_instrucao]) REFERENCES [dbo].[Instrucao_Interna] ([cd_instrucao])
);


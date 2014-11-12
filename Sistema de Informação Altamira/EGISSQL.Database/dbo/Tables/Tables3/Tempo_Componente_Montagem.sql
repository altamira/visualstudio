CREATE TABLE [dbo].[Tempo_Componente_Montagem] (
    [cd_grupo_produto]          INT        NOT NULL,
    [cd_produto]                INT        NOT NULL,
    [cd_tipo_montagem]          INT        NOT NULL,
    [cd_tipo_servico_usinagem]  INT        NOT NULL,
    [qt_tempo_servico_usinagem] FLOAT (53) NOT NULL,
    [qt_tempo_usinagem_montage] FLOAT (53) NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    CONSTRAINT [PK_Tempo_Componente_Montagem] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_produto] ASC, [cd_tipo_montagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tempo_Componente_Montagem_Tipo_Servico_Usinagem] FOREIGN KEY ([cd_tipo_servico_usinagem]) REFERENCES [dbo].[Tipo_Servico_Usinagem] ([cd_tipo_servico_usinagem])
);


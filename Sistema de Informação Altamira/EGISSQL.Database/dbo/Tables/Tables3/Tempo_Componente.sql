CREATE TABLE [dbo].[Tempo_Componente] (
    [cd_grupo_produto]         INT        NOT NULL,
    [cd_produto]               INT        NOT NULL,
    [cd_tipo_servico_usinagem] INT        NOT NULL,
    [qt_tempo_preparacao]      FLOAT (53) NOT NULL,
    [qt_tempo_usinagem]        FLOAT (53) NOT NULL,
    [cd_usuario]               INT        NOT NULL,
    [dt_usuario]               DATETIME   NOT NULL,
    CONSTRAINT [PK_Tempo_Componente] PRIMARY KEY CLUSTERED ([cd_grupo_produto] ASC, [cd_produto] ASC, [cd_tipo_servico_usinagem] ASC) WITH (FILLFACTOR = 90)
);


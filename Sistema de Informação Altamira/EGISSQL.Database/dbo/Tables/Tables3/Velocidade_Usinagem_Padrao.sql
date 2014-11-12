CREATE TABLE [dbo].[Velocidade_Usinagem_Padrao] (
    [cd_ferramenta]       INT        NOT NULL,
    [cd_mat_prima]        INT        NOT NULL,
    [qt_rotacao]          FLOAT (53) NULL,
    [qt_velocidade_corte] FLOAT (53) NULL,
    [qt_avanco_faca]      FLOAT (53) NULL,
    [qt_avanco_trabalho]  FLOAT (53) NULL,
    [qt_avanco_reduzido]  FLOAT (53) NULL,
    [qt_avanco_mergulho]  FLOAT (53) NULL,
    [qt_vida_util]        FLOAT (53) NULL,
    [cd_usuario]          INT        NULL,
    [dt_usuario]          DATETIME   NULL,
    CONSTRAINT [PK_Velocidade_Usinagem_Padrao] PRIMARY KEY CLUSTERED ([cd_ferramenta] ASC, [cd_mat_prima] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Velocidade_Usinagem_Padrao_Materia_Prima] FOREIGN KEY ([cd_mat_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima])
);


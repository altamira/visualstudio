CREATE TABLE [dbo].[Velocidade_Usinagem] (
    [cd_maquina]         INT        NULL,
    [cd_ferramenta]      INT        NULL,
    [cd_mat_prima]       INT        NULL,
    [qt_rotacao]         FLOAT (53) NULL,
    [qt_avanco]          FLOAT (53) NULL,
    [qt_avanco_reduzido] FLOAT (53) NULL,
    [cd_usuario]         INT        NULL,
    [dt_usuario]         DATETIME   NULL,
    [qt_vida_util]       FLOAT (53) NULL,
    [qt_avanco_mergulho] FLOAT (53) NULL,
    [qt_avanco_trabalho] FLOAT (53) NULL,
    [qt_prof_corte]      FLOAT (53) NULL,
    [qt_largura_corte]   FLOAT (53) NULL,
    CONSTRAINT [FK_Velocidade_Usinagem_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina]),
    CONSTRAINT [FK_Velocidade_Usinagem_Materia_Prima] FOREIGN KEY ([cd_mat_prima]) REFERENCES [dbo].[Materia_Prima] ([cd_mat_prima])
);


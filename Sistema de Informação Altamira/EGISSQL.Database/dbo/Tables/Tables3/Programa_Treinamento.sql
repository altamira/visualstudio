CREATE TABLE [dbo].[Programa_Treinamento] (
    [cd_programa]             INT          NOT NULL,
    [cd_aluno]                INT          NOT NULL,
    [cd_versao_programa]      INT          NULL,
    [cd_modelo_treinamento]   INT          NULL,
    [nm_objetivo_programa]    VARCHAR (40) NULL,
    [dt_inicio_programa]      DATETIME     NULL,
    [dt_fim_programa]         DATETIME     NULL,
    [cd_professor]            INT          NULL,
    [ds_programa_treinamento] TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Programa_Treinamento] PRIMARY KEY CLUSTERED ([cd_programa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programa_Treinamento_Modelo_Treinamento] FOREIGN KEY ([cd_modelo_treinamento]) REFERENCES [dbo].[Modelo_Treinamento] ([cd_modelo_treinamento])
);


CREATE TABLE [dbo].[Instrucao_Manutencao] (
    [cd_instrucao]               INT          NOT NULL,
    [nm_instrucao]               VARCHAR (60) NULL,
    [nm_identificacao_instrucao] VARCHAR (15) NULL,
    [ds_instrucao]               TEXT         NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [qt_tempo_padrao]            FLOAT (53)   NULL,
    CONSTRAINT [PK_Instrucao_Manutencao] PRIMARY KEY CLUSTERED ([cd_instrucao] ASC) WITH (FILLFACTOR = 90)
);


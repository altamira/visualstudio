CREATE TABLE [dbo].[Atividade_Implantacao_Ocorrencia] (
    [cd_atividade]            INT          NOT NULL,
    [cd_atividade_ocorrencia] INT          NOT NULL,
    [nm_atividade_ocorrencia] VARCHAR (60) NULL,
    [ds_atividade_ocorrencia] TEXT         NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Atividade_Implantacao_Ocorrencia] PRIMARY KEY CLUSTERED ([cd_atividade] ASC, [cd_atividade_ocorrencia] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Atividade_Implantacao_Ocorrencia_Atividade_Implantacao] FOREIGN KEY ([cd_atividade]) REFERENCES [dbo].[Atividade_Implantacao] ([cd_atividade])
);


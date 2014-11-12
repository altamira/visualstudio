CREATE TABLE [dbo].[Ocorrencia_Falha] (
    [cd_ocorrencia_falha] INT          NOT NULL,
    [nm_ocorrencia_falha] VARCHAR (40) NULL,
    [ds_ocorrencia_falha] TEXT         NULL,
    [qt_ocorrencia_falha] INT          NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Ocorrencia_Falha] PRIMARY KEY CLUSTERED ([cd_ocorrencia_falha] ASC) WITH (FILLFACTOR = 90)
);


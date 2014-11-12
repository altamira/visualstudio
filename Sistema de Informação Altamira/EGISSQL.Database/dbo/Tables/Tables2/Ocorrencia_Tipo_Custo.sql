CREATE TABLE [dbo].[Ocorrencia_Tipo_Custo] (
    [cd_custo_ocorrencia] INT          NOT NULL,
    [nm_custo_ocorrencia] VARCHAR (40) NOT NULL,
    [sg_custo_ocorrencia] CHAR (10)    NOT NULL,
    [ic_custo_ocorrencia] CHAR (1)     NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Ocorrencia_Tipo_Custo] PRIMARY KEY CLUSTERED ([cd_custo_ocorrencia] ASC) WITH (FILLFACTOR = 90)
);


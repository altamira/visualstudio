CREATE TABLE [dbo].[Tipo_Ocorrencia_Recebimento] (
    [cd_tipo_ocorrencia_receb] INT          NOT NULL,
    [nm_tipo_ocorrencia_receb] VARCHAR (30) NULL,
    [sg_tipo_ocorrencia_recev] CHAR (10)    NULL,
    [ic_tipo_ocorrencia_receb] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Ocorrencia_Recebimento] PRIMARY KEY CLUSTERED ([cd_tipo_ocorrencia_receb] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[Ocorrencia_Debito] (
    [cd_ocorrencia_debito] INT          NOT NULL,
    [nm_ocorrencia_debito] VARCHAR (60) NULL,
    [sg_ocorrencia_debito] CHAR (3)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Ocorrencia_Debito] PRIMARY KEY CLUSTERED ([cd_ocorrencia_debito] ASC) WITH (FILLFACTOR = 90)
);


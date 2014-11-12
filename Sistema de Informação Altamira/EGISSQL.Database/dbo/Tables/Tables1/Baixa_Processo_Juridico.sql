CREATE TABLE [dbo].[Baixa_Processo_Juridico] (
    [cd_baixa_processo] INT          NOT NULL,
    [nm_baixa_processo] VARCHAR (40) NULL,
    [sg_baixa_processo] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Baixa_Processo_Juridico] PRIMARY KEY CLUSTERED ([cd_baixa_processo] ASC) WITH (FILLFACTOR = 90)
);


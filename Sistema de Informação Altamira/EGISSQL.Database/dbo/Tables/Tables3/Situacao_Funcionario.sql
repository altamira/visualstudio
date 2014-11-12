CREATE TABLE [dbo].[Situacao_Funcionario] (
    [cd_situacao_funcionario] INT          NOT NULL,
    [nm_situacao_funcionario] VARCHAR (30) NULL,
    [sg_situacao_funcionario] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_bloqueio_situacao]    CHAR (1)     NULL,
    [ic_processo_calculo]     CHAR (1)     NULL,
    CONSTRAINT [PK_Situacao_Funcionario] PRIMARY KEY CLUSTERED ([cd_situacao_funcionario] ASC) WITH (FILLFACTOR = 90)
);


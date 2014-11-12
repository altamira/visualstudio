CREATE TABLE [dbo].[APC_Prioridade_Atividade] (
    [cd_prioridade_atividade] INT          NOT NULL,
    [nm_prioridade_atividade] VARCHAR (40) NULL,
    [sg_prioridade_atividade] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuário]              DATETIME     NULL,
    CONSTRAINT [PK_APC_Prioridade_Atividade] PRIMARY KEY CLUSTERED ([cd_prioridade_atividade] ASC)
);


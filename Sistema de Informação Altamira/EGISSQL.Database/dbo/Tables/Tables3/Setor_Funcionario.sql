CREATE TABLE [dbo].[Setor_Funcionario] (
    [cd_setor_funcionario] INT          NOT NULL,
    [nm_setor_funcionario] VARCHAR (40) NULL,
    [sg_setor_funcionario] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Setor_Funcionario] PRIMARY KEY CLUSTERED ([cd_setor_funcionario] ASC) WITH (FILLFACTOR = 90)
);


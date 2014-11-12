CREATE TABLE [dbo].[Funcionario_Imagem_Documento] (
    [cd_funcionario]           INT           NOT NULL,
    [cd_documento_admissao]    INT           NULL,
    [dt_documento]             DATETIME      NULL,
    [nm_documento_funcionario] VARCHAR (100) NULL,
    [nm_obs_documento]         VARCHAR (40)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    CONSTRAINT [PK_Funcionario_Imagem_Documento] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Imagem_Documento_Admissao_Documento] FOREIGN KEY ([cd_documento_admissao]) REFERENCES [dbo].[Admissao_Documento] ([cd_documento_admissao])
);


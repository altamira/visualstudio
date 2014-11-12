CREATE TABLE [dbo].[Parametro_Aprovacao] (
    [cd_empresa]               INT      NOT NULL,
    [qt_tempo_aprovacao]       INT      NULL,
    [cd_funcionario]           INT      NULL,
    [cd_usuario]               INT      NULL,
    [dt_usuario]               DATETIME NULL,
    [ic_copia_email_aprovacao] CHAR (1) NULL,
    CONSTRAINT [PK_Parametro_Aprovacao] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_Aprovacao_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);


CREATE TABLE [dbo].[Usuario_Email] (
    [cd_item_email_usuario]  INT           NOT NULL,
    [cd_usuario_email]       INT           NOT NULL,
    [nm_email_usuario]       VARCHAR (100) NULL,
    [cd_usuario_atualiza]    INT           NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [ic_tipo_usuario_email]  CHAR (1)      NULL,
    [cd_senha_email_usuario] VARCHAR (15)  NULL,
    [nm_servidor_email]      VARCHAR (100) NULL,
    [ic_autenticacao]        CHAR (1)      NULL,
    CONSTRAINT [PK_Usuario_Email] PRIMARY KEY CLUSTERED ([cd_item_email_usuario] ASC),
    CONSTRAINT [FK_Usuario_Email_Usuario] FOREIGN KEY ([cd_usuario_email]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);


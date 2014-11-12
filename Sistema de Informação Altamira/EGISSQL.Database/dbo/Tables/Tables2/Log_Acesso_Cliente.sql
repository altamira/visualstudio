CREATE TABLE [dbo].[Log_Acesso_Cliente] (
    [cd_log_acesso]        INT          NOT NULL,
    [cd_cliente]           INT          NOT NULL,
    [dt_acesso_cliente]    DATETIME     NULL,
    [cd_contato]           INT          NULL,
    [cd_modulo]            INT          NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_ip_acesso_cliente] VARCHAR (16) NULL,
    CONSTRAINT [PK_Log_Acesso_Cliente] PRIMARY KEY CLUSTERED ([cd_log_acesso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Log_Acesso_Cliente_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);


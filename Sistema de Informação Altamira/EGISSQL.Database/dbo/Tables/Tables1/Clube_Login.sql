CREATE TABLE [dbo].[Clube_Login] (
    [cd_login]       INT          NOT NULL,
    [cd_cadastro]    INT          NOT NULL,
    [dt_login]       DATETIME     NOT NULL,
    [cd_servidor]    INT          NULL,
    [cd_ip_login]    INT          NULL,
    [qt_tempo_login] FLOAT (53)   NULL,
    [nm_obs_login]   VARCHAR (40) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Clube_Login] PRIMARY KEY CLUSTERED ([cd_login] ASC),
    CONSTRAINT [FK_Clube_Login_Clube_Cadastro] FOREIGN KEY ([cd_cadastro]) REFERENCES [dbo].[Clube_Cadastro] ([cd_cadastro])
);


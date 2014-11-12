CREATE TABLE [dbo].[Clube_Cadastro] (
    [cd_cadastro]           INT           NOT NULL,
    [nm_cadastro]           VARCHAR (40)  NULL,
    [dt_cadastro]           DATETIME      NULL,
    [cd_senha_cadastro]     VARCHAR (10)  NULL,
    [cd_cor]                INT           NULL,
    [cd_raca]               INT           NULL,
    [nm_email_cadastro]     VARCHAR (150) NULL,
    [nm_email_responsavel]  VARCHAR (150) NULL,
    [dt_liberacao_cadastro] DATETIME      NULL,
    [cd_status_cadastro]    INT           NULL,
    [nm_obs_cadastro]       VARCHAR (40)  NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    [dt_nascimento]         DATETIME      NULL,
    CONSTRAINT [PK_Clube_Cadastro] PRIMARY KEY CLUSTERED ([cd_cadastro] ASC),
    CONSTRAINT [FK_Clube_Cadastro_Status_Cadastro] FOREIGN KEY ([cd_status_cadastro]) REFERENCES [dbo].[Status_Cadastro] ([cd_status_cadastro])
);


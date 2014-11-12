CREATE TABLE [dbo].[Assinante] (
    [cd_assinante]       INT          NOT NULL,
    [nm_assinante]       VARCHAR (60) NULL,
    [nm_fantasia]        VARCHAR (20) NULL,
    [cd_cor]             INT          NULL,
    [cd_senha_assinante] VARCHAR (10) NULL,
    [cd_raca]            INT          NULL,
    [dt_nascimento]      DATETIME     NULL,
    [dt_ativacao]        DATETIME     NULL,
    [dt_cancelamento]    DATETIME     NULL,
    [cd_tipo_plano]      INT          NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Assinante] PRIMARY KEY CLUSTERED ([cd_assinante] ASC),
    CONSTRAINT [FK_Assinante_Tipo_Plano_Clube] FOREIGN KEY ([cd_tipo_plano]) REFERENCES [dbo].[Tipo_Plano_Clube] ([cd_tipo_plano])
);


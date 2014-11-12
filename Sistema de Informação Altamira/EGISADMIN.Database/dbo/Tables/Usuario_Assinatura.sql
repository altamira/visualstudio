CREATE TABLE [dbo].[Usuario_Assinatura] (
    [cd_usuario_assinatura] INT       NOT NULL,
    [cd_tipo_assinatura]    INT       NOT NULL,
    [cd_senha_usuario]      CHAR (15) NULL,
    [dt_usuario]            DATETIME  NULL,
    [cd_tipo_aprovacao]     INT       NULL,
    [cd_usuario]            INT       NULL,
    CONSTRAINT [PK_Usuario_Assinatura] PRIMARY KEY CLUSTERED ([cd_usuario_assinatura] ASC, [cd_tipo_assinatura] ASC) WITH (FILLFACTOR = 90)
);


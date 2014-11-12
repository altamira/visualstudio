CREATE TABLE [dbo].[Usuario_Assinatura_Eletrtonica] (
    [nmm_form_assinatura] VARCHAR (40) NULL,
    [cd_usuario]          INT          NOT NULL,
    [cd_tipo_assinatura]  INT          NOT NULL,
    [cd_senha_usuario]    CHAR (15)    NULL,
    CONSTRAINT [PK_Usuario_Assinatura_Eletrtonica] PRIMARY KEY CLUSTERED ([cd_usuario] ASC, [cd_tipo_assinatura] ASC) WITH (FILLFACTOR = 90)
);


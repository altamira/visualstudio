CREATE TABLE [dbo].[Tipo_Assinatura_Eletronica] (
    [cd_tipo_assinatura] INT          NOT NULL,
    [nm_tipo_assinatura] VARCHAR (40) NULL,
    [sg_tipo_assinatura] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    [nm_form_assinatura] VARCHAR (40) NULL,
    [cd_classe]          INT          NULL,
    CONSTRAINT [PK_Tipo_Assinatura_Eletronica] PRIMARY KEY CLUSTERED ([cd_tipo_assinatura] ASC) WITH (FILLFACTOR = 90)
);


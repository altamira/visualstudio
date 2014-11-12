CREATE TABLE [dbo].[Empresa_Assinatura] (
    [cd_empresa_assinatura]     INT          NOT NULL,
    [nm_empresa_assinatura]     VARCHAR (40) NOT NULL,
    [sg_empresa_assinatura]     CHAR (15)    NOT NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_pad_empresa_assinatura] CHAR (1)     NULL,
    CONSTRAINT [PK_Empresa_Assinatura] PRIMARY KEY CLUSTERED ([cd_empresa_assinatura] ASC) WITH (FILLFACTOR = 90)
);


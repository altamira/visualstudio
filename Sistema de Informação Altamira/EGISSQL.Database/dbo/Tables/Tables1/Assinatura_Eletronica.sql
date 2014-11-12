CREATE TABLE [dbo].[Assinatura_Eletronica] (
    [cd_tipo_assinatura] INT          NOT NULL,
    [cd_item_assinautra] INT          NOT NULL,
    [cd_tipo_aprovacao]  INT          NULL,
    [cd_ordem_aprovacao] INT          NULL,
    [nm_obs_aprovacao]   VARCHAR (40) NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Assinatura_Eletronica] PRIMARY KEY CLUSTERED ([cd_tipo_assinatura] ASC, [cd_item_assinautra] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Assinatura_Eletronica_Tipo_Aprovacao] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Aprovacao] ([cd_tipo_aprovacao])
);


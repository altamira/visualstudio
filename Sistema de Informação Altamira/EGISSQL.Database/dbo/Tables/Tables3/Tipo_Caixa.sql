CREATE TABLE [dbo].[Tipo_Caixa] (
    [cd_tipo_caixa]       INT          NOT NULL,
    [cd_plano_financeiro] INT          NULL,
    [nm_tipo_caixa]       VARCHAR (30) NULL,
    [sg_tipo_caixa]       CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    [ic_ativo_tipo_caixa] CHAR (1)     NULL,
    [cd_conta]            INT          NULL,
    [cd_moeda]            INT          NULL,
    CONSTRAINT [PK_Tipo_Caixa] PRIMARY KEY CLUSTERED ([cd_tipo_caixa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Caixa_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);


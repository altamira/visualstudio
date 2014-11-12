CREATE TABLE [dbo].[Mensagem_Nota] (
    [cd_mensagem_nota]        INT          NOT NULL,
    [nm_mensagem_nota]        VARCHAR (40) NOT NULL,
    [ds_mensagem_nota]        TEXT         NULL,
    [ic_ativa_mensagem_nota]  CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_comercial_mensagem]   CHAR (1)     NULL,
    [cd_tipo_operacao_fiscal] INT          NULL,
    CONSTRAINT [PK_Mensagem_Nota] PRIMARY KEY CLUSTERED ([cd_mensagem_nota] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Mensagem_Nota_Tipo_Operacao_Fiscal] FOREIGN KEY ([cd_tipo_operacao_fiscal]) REFERENCES [dbo].[Tipo_Operacao_Fiscal] ([cd_tipo_operacao_fiscal])
);


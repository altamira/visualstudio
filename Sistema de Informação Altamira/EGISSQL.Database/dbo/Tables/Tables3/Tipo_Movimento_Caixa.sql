CREATE TABLE [dbo].[Tipo_Movimento_Caixa] (
    [cd_tipo_movimento_caixa] INT          NOT NULL,
    [nm_tipo_movimento_caixa] VARCHAR (40) NULL,
    [ic_entrada_saida]        CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_motivo_retirada]      CHAR (1)     NULL,
    CONSTRAINT [PK_Tipo_Movimento_Caixa] PRIMARY KEY CLUSTERED ([cd_tipo_movimento_caixa] ASC) WITH (FILLFACTOR = 90)
);


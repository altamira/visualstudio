CREATE TABLE [dbo].[Motivo_Retirada_Caixa] (
    [cd_motivo_retirada_caixa] INT          NOT NULL,
    [nm_motivo_retirada_caixa] VARCHAR (40) NULL,
    [sg_motivo_retirada_caixa] CHAR (10)    NULL,
    [ic_padrao_retirada_caixa] CHAR (1)     NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Retirada_Caixa] PRIMARY KEY CLUSTERED ([cd_motivo_retirada_caixa] ASC) WITH (FILLFACTOR = 90)
);


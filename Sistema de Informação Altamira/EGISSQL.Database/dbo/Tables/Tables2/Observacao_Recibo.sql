CREATE TABLE [dbo].[Observacao_Recibo] (
    [cd_observacao_recibo]     INT          NOT NULL,
    [nm_observacao_recibo]     VARCHAR (30) NULL,
    [sg_observacao_recibo]     CHAR (10)    NULL,
    [ds_observacao_recibo]     TEXT         NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_pad_observacao_recibo] CHAR (1)     NULL,
    CONSTRAINT [PK_Observacao_Recibo] PRIMARY KEY CLUSTERED ([cd_observacao_recibo] ASC) WITH (FILLFACTOR = 90)
);


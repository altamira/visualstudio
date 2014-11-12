CREATE TABLE [dbo].[cheque_receber_composicao] (
    [dt_usuario]                DATETIME     NULL,
    [cd_usuario]                INT          NULL,
    [nm_item_obs_chq_receber]   VARCHAR (40) NULL,
    [cd_documento_receber]      INT          NULL,
    [cd_item_cheque_receber]    INT          NOT NULL,
    [cd_cheque_receber]         INT          NOT NULL,
    [nm_item_obs_cheque_recebe] VARCHAR (40) NULL,
    [cd_item_documento_receber] INT          NULL,
    CONSTRAINT [PK_cheque_receber_composicao] PRIMARY KEY CLUSTERED ([cd_item_cheque_receber] ASC, [cd_cheque_receber] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_cheque_receber_composicao_Cheque_receber] FOREIGN KEY ([cd_cheque_receber]) REFERENCES [dbo].[Cheque_receber] ([cd_cheque_receber]) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE [dbo].[Historico_Transferencia] (
    [cd_hist_transferencia] INT          NOT NULL,
    [nm_hist_transferencia] VARCHAR (30) NULL,
    [sg_hist_transferencia] CHAR (10)    NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    CONSTRAINT [PK_Historico_Transferencia] PRIMARY KEY CLUSTERED ([cd_hist_transferencia] ASC) WITH (FILLFACTOR = 90)
);


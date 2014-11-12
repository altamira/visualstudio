CREATE TABLE [dbo].[Motivo_Cancelamento_Visita] (
    [cd_cancelamento_visita]     INT          NOT NULL,
    [nm_cancelamento_visita]     VARCHAR (40) NULL,
    [ic_pad_cancelamento_visita] CHAR (1)     NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Cancelamento_Visita] PRIMARY KEY CLUSTERED ([cd_cancelamento_visita] ASC) WITH (FILLFACTOR = 90)
);


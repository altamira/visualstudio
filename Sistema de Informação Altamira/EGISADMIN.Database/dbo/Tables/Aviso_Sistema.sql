CREATE TABLE [dbo].[Aviso_Sistema] (
    [cd_aviso_sistema]     INT           NOT NULL,
    [nm_aviso_sistema]     VARCHAR (100) NULL,
    [ds_aviso_sistema]     TEXT          NULL,
    [cd_procedure]         INT           NULL,
    [cd_modulo]            INT           NULL,
    [nm_obs_aviso_sistema] VARCHAR (40)  NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    CONSTRAINT [PK_Aviso_Sistema] PRIMARY KEY CLUSTERED ([cd_aviso_sistema] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aviso_Sistema_Modulo] FOREIGN KEY ([cd_modulo]) REFERENCES [dbo].[Modulo] ([cd_modulo])
);


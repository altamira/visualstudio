CREATE TABLE [dbo].[Maquina_Complemento] (
    [cd_maquina]           INT           NOT NULL,
    [nm_foto_maquina]      VARCHAR (100) NULL,
    [nm_manual_maquina]    VARCHAR (100) NULL,
    [nm_documento_maquina] VARCHAR (100) NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    [ds_maquina]           TEXT          NULL,
    CONSTRAINT [PK_Maquina_Complemento] PRIMARY KEY CLUSTERED ([cd_maquina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Maquina_Complemento_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);


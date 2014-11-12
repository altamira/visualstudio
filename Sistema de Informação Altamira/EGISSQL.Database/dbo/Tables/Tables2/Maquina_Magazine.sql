CREATE TABLE [dbo].[Maquina_Magazine] (
    [cd_maquina]          INT      NULL,
    [cd_magazine]         INT      NULL,
    [cd_maquina_magazine] INT      NOT NULL,
    [cd_usuario]          INT      NULL,
    [dt_usuario]          DATETIME NULL,
    CONSTRAINT [PK_Maquina_Magazine] PRIMARY KEY CLUSTERED ([cd_maquina_magazine] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Maquina_Magazine_Magazine] FOREIGN KEY ([cd_magazine]) REFERENCES [dbo].[Magazine] ([cd_magazine]),
    CONSTRAINT [FK_Maquina_Magazine_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);


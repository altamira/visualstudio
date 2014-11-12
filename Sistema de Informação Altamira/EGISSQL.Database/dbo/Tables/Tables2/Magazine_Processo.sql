CREATE TABLE [dbo].[Magazine_Processo] (
    [cd_magazine]          INT      NULL,
    [cd_processo_usinagem] INT      NULL,
    [cd_magazine_processo] INT      NOT NULL,
    [cd_usuario]           INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK_Magazine_Processo] PRIMARY KEY CLUSTERED ([cd_magazine_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Magazine_Processo_Magazine] FOREIGN KEY ([cd_magazine]) REFERENCES [dbo].[Magazine] ([cd_magazine]),
    CONSTRAINT [FK_Magazine_Processo_Processo_Usinagem] FOREIGN KEY ([cd_processo_usinagem]) REFERENCES [dbo].[Processo_Usinagem] ([cd_processo_usinagem])
);


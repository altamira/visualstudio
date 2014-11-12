CREATE TABLE [dbo].[Programacao_CNC] (
    [cd_comando]  INT          NULL,
    [cd_prog_cnc] INT          NOT NULL,
    [nm_prog_cnc] VARCHAR (50) NULL,
    [ds_prog_cnc] TEXT         NULL,
    [cd_usuario]  INT          NULL,
    [dt_usuario]  DATETIME     NULL,
    CONSTRAINT [PK_Programacao_CNC] PRIMARY KEY CLUSTERED ([cd_prog_cnc] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programacao_CNC_Comando] FOREIGN KEY ([cd_comando]) REFERENCES [dbo].[Comando] ([cd_comando])
);


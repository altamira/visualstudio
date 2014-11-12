CREATE TABLE [dbo].[Log_Prog_CNC] (
    [cd_prog_cnc]     INT       NOT NULL,
    [dt_prog_cnc]     DATETIME  NULL,
    [cd_num_prog_cnc] CHAR (10) NULL,
    [cd_maquina]      INT       NULL,
    [cd_magazine]     INT       NULL,
    [nm_prog_cnc]     CHAR (15) NULL,
    [ds_prog_cnc]     TEXT      NULL,
    [nm_usuario]      CHAR (15) NULL,
    [cd_usuario]      INT       NULL,
    [dt_usuario]      DATETIME  NULL,
    CONSTRAINT [PK_Log_Prog_CNC] PRIMARY KEY CLUSTERED ([cd_prog_cnc] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Log_Prog_CNC_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);


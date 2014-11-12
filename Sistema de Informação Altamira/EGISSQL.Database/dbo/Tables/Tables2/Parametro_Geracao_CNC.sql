CREATE TABLE [dbo].[Parametro_Geracao_CNC] (
    [cd_maquina]            INT          NULL,
    [nm_diretorio]          VARCHAR (50) NULL,
    [dt_prog_cnc]           DATETIME     NULL,
    [nm_prog_cnc]           VARCHAR (50) NULL,
    [cd_programador_cnc]    INT          NULL,
    [cd_ext_prog_cnc]       INT          NULL,
    [nm_dir_servidor_cnc]   VARCHAR (50) NULL,
    [ic_transferencia_auto] CHAR (1)     NULL,
    [cd_magazine]           INT          NULL,
    [nm_drive_servidor]     CHAR (5)     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [nm_ext_prog_cnc]       VARCHAR (4)  NULL,
    CONSTRAINT [FK_Parametro_Geracao_CNC_Magazine] FOREIGN KEY ([cd_magazine]) REFERENCES [dbo].[Magazine] ([cd_magazine]),
    CONSTRAINT [FK_Parametro_Geracao_CNC_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina]),
    CONSTRAINT [FK_Parametro_Geracao_CNC_Programador_CNC] FOREIGN KEY ([cd_programador_cnc]) REFERENCES [dbo].[Programador_CNC] ([cd_programador_cnc])
);


CREATE TABLE [dbo].[Parametro_Geracao_Cnc_Usuario] (
    [cd_usurio_padrao]      INT          NOT NULL,
    [cd_maquina]            INT          NOT NULL,
    [nm_diretorio]          VARCHAR (50) NULL,
    [dt_prog_cnc]           DATETIME     NULL,
    [nm_prog_cnc]           VARCHAR (50) NULL,
    [cd_programador_cnc]    INT          NULL,
    [nm_ext_prog_cnc]       VARCHAR (4)  NULL,
    [nm_dir_servidor_cnc]   VARCHAR (50) NULL,
    [ic_transferencia_auto] CHAR (1)     NULL,
    [cd_magazine]           INT          NULL,
    [nm_drive_servidor]     VARCHAR (5)  NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Parametro_Geracao_Cnc_Usuario] PRIMARY KEY CLUSTERED ([cd_usurio_padrao] ASC, [cd_maquina] ASC) WITH (FILLFACTOR = 90)
);


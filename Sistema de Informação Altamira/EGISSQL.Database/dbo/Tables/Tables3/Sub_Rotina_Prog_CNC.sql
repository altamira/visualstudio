CREATE TABLE [dbo].[Sub_Rotina_Prog_CNC] (
    [cd_maquina]    INT          NULL,
    [cd_sub_rotina] INT          NOT NULL,
    [nm_sub_rotina] VARCHAR (40) NULL,
    [sg_sub_rotina] CHAR (15)    NULL,
    [ds_sub_rotina] TEXT         NULL,
    [cd_usuario]    INT          NULL,
    [dt_usuario]    DATETIME     NULL,
    CONSTRAINT [PK_Sub_Rotina_Prog_CNC] PRIMARY KEY CLUSTERED ([cd_sub_rotina] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Sub_Rotina_Prog_CNC_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);


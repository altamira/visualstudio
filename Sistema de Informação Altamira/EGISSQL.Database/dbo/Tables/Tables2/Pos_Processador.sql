CREATE TABLE [dbo].[Pos_Processador] (
    [cd_maquina]             INT          NULL,
    [cd_pos_processador]     INT          NOT NULL,
    [nm_pos_processador]     VARCHAR (40) NULL,
    [nm_arq_pos_processador] VARCHAR (10) NULL,
    [ds_cmd_pos_processador] TEXT         NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Pos_Processador] PRIMARY KEY CLUSTERED ([cd_pos_processador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pos_Processador_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);


CREATE TABLE [dbo].[Numeracao_Programa_CNC] (
    [cd_bloco_prog_cnc]      INT      NULL,
    [cd_numero_programa_cnc] INT      NOT NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Numeracao_Programa_CNC] PRIMARY KEY CLUSTERED ([cd_numero_programa_cnc] ASC) WITH (FILLFACTOR = 90)
);


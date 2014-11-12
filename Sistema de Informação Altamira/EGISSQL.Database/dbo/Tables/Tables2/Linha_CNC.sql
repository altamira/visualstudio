CREATE TABLE [dbo].[Linha_CNC] (
    [cd_linha_prog_cnc] INT      NOT NULL,
    [cd_usuário]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    CONSTRAINT [PK_Linha_CNC] PRIMARY KEY CLUSTERED ([cd_linha_prog_cnc] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[CO_Grupo] (
    [prgp_Codigo]    INT        NOT NULL,
    [prgp_SubGrupo]  INT        NOT NULL,
    [prgp_Descricao] CHAR (50)  NULL,
    [prgp_Ligacao]   CHAR (11)  NULL,
    [prgp_Explode]   CHAR (1)   NULL,
    [prgp_Lock]      BINARY (8) NULL
);


CREATE TABLE [dbo].[PRE_GrupoEsp] (
    [prgp_Codigo]    INT           NOT NULL,
    [prgp_Sub1]      INT           NOT NULL,
    [prgp_Sub2]      INT           NOT NULL,
    [prgp_Sub3]      INT           NOT NULL,
    [prgp_Descricao] NVARCHAR (50) NULL,
    [prgp_Ligacao]   NVARCHAR (11) NULL,
    [prgp_Explode]   NVARCHAR (1)  NULL,
    [prgp_IPI]       INT           NULL,
    [prgp_Lock]      VARBINARY (8) NULL
);


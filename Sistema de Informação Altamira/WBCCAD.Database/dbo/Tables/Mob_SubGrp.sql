CREATE TABLE [dbo].[Mob_SubGrp] (
    [Nome_Eqpto]                 NVARCHAR (50) NULL,
    [SubGrupo]                   NVARCHAR (50) NULL,
    [Tipo_cad]                   NVARCHAR (4)  NULL,
    [esconder_projeto]           BIT           NULL,
    [tratar_como_caracteristica] BIT           NULL,
    [idMobSubGrp]                INT           IDENTITY (1, 1) NOT NULL
);


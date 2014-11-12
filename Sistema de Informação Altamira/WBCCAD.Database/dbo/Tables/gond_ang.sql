CREATE TABLE [dbo].[gond_ang] (
    [angulo]           NVARCHAR (50) NULL,
    [valor]            INT           NULL,
    [dep_comprimento]  BIT           NULL,
    [idGondAng]        INT           IDENTITY (1, 1) NOT NULL,
    [angulo_oposto]    NVARCHAR (50) NULL,
    [comprimento_lado] FLOAT (53)    NULL,
    [valor_angulo]     FLOAT (53)    NULL
);


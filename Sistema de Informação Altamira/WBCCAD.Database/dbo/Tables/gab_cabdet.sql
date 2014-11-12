CREATE TABLE [dbo].[gab_cabdet] (
    [descricao]       NVARCHAR (30) NULL,
    [flag_e_d]        NVARCHAR (1)  NULL,
    [ligacao]         NVARCHAR (20) NULL,
    [e_intermediaria] BIT           NULL,
    [idGabCabdet]     INT           IDENTITY (1, 1) NOT NULL
);


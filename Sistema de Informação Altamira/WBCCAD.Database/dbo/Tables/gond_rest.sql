CREATE TABLE [dbo].[gond_rest] (
    [id_restricao]   INT           IDENTITY (1, 1) NOT NULL,
    [quem_corte]     INT           NULL,
    [oque]           NVARCHAR (50) NULL,
    [tipo_rest]      NVARCHAR (50) NULL,
    [obj_rest]       NVARCHAR (50) NULL,
    [quem_cjto]      NVARCHAR (50) NULL,
    [quem_aces]      NVARCHAR (50) NULL,
    [todos_quem]     BIT           NULL,
    [todos_com_quem] BIT           NULL,
    [e_ou]           BIT           NULL
);


CREATE TABLE [dbo].[gond_corte_est_sup] (
    [idcorte]               INT           NULL,
    [est_superior]          NVARCHAR (50) NULL,
    [id_corte_est_superior] INT           NULL,
    [desenho_planta]        NVARCHAR (50) NULL,
    [pos_insercao]          NVARCHAR (50) NULL,
    [idGondCorteEstSup]     INT           IDENTITY (1, 1) NOT NULL
);


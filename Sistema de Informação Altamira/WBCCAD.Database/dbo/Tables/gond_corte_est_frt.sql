CREATE TABLE [dbo].[gond_corte_est_frt] (
    [idcorte]              INT           NULL,
    [est_frontal]          NVARCHAR (50) NULL,
    [id_corte_est_frontal] INT           NULL,
    [desenho_planta]       NVARCHAR (50) NULL,
    [pos_insercao]         INT           NULL,
    [idGondCorteEstFrt]    INT           IDENTITY (1, 1) NOT NULL
);


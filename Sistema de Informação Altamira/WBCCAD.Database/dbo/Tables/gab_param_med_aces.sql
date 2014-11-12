CREATE TABLE [dbo].[gab_param_med_aces] (
    [identificacao]       INT           IDENTITY (1, 1) NOT NULL,
    [acessorio]           NVARCHAR (50) NULL,
    [medida]              INT           NULL,
    [codigo]              NVARCHAR (50) NULL,
    [qtde_por_nivel_min]  INT           NULL,
    [qtde_por_nivel_max]  INT           NULL,
    [qtde_por_nivel_pad]  INT           NULL,
    [potencia]            INT           NULL,
    [sequencia_edicao]    INT           NULL,
    [tipo_med]            NVARCHAR (50) NULL,
    [v_tensao]            NVARCHAR (10) NULL,
    [v_frequencia]        NVARCHAR (10) NULL,
    [v_condensacao]       NVARCHAR (10) NULL,
    [v_par4]              NVARCHAR (10) NULL,
    [v_par5]              NVARCHAR (10) NULL,
    [potencia_orvalho]    INT           NULL,
    [potencia_iluminacao] INT           NULL
);


CREATE TABLE [dbo].[gab_param_med_crt] (
    [identificacao]                 INT           IDENTITY (1, 1) NOT NULL,
    [medida]                        INT           NULL,
    [codigo]                        NVARCHAR (50) NULL,
    [potencia]                      INT           NULL,
    [Corte]                         NVARCHAR (50) NULL,
    [sequencia_edicao]              INT           NULL,
    [tipo_med]                      NVARCHAR (50) NULL,
    [medida_reta_corte]             FLOAT (53)    NULL,
    [medida_p_reta_corte]           FLOAT (53)    NULL,
    [v_tensao]                      NVARCHAR (10) NULL,
    [v_frequencia]                  NVARCHAR (10) NULL,
    [v_condensacao]                 NVARCHAR (10) NULL,
    [v_par4]                        NVARCHAR (10) NULL,
    [v_par5]                        NVARCHAR (10) NULL,
    [potencia_orvalho]              INT           NULL,
    [potencia_iluminacao]           INT           NULL,
    [travar_representante]          BIT           NULL,
    [potencia_2]                    FLOAT (53)    NULL,
    [potencia_resistencia_degelo_2] FLOAT (53)    NULL,
    [potencia_orvalho_2]            FLOAT (53)    NULL,
    [potencia_iluminacao_2]         FLOAT (53)    NULL
);


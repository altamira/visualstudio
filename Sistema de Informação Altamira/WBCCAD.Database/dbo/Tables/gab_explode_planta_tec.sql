CREATE TABLE [dbo].[gab_explode_planta_tec] (
    [corte]                       NVARCHAR (20) NULL,
    [comprimento]                 NVARCHAR (10) NULL,
    [bloco_colocar]               NVARCHAR (10) NULL,
    [desl_x]                      FLOAT (53)    NULL,
    [desl_y]                      FLOAT (53)    NULL,
    [rotacao]                     FLOAT (53)    NULL,
    [Kcal]                        FLOAT (53)    NULL,
    [comprimento_deste]           NVARCHAR (10) NULL,
    [potencia]                    FLOAT (53)    NULL,
    [potencia_resistencia_degelo] FLOAT (53)    NULL,
    [potencia_orvalho]            FLOAT (53)    NULL,
    [potencia_iluminacao]         FLOAT (53)    NULL,
    [fechamento_duplo]            BIT           NULL
);


CREATE TABLE [dbo].[cam_aces_mod] (
    [sigla]              NVARCHAR (20)  NULL,
    [sigla_aces]         NVARCHAR (20)  NULL,
    [acabamento]         NVARCHAR (10)  NULL,
    [formula_quantidade] NVARCHAR (100) NULL,
    [temperatura]        FLOAT (53)     NULL,
    [temperatura_minima] FLOAT (53)     NULL,
    [temperatura_maxima] FLOAT (53)     NULL,
    [e_por_perimetro]    BIT            NOT NULL,
    [tipo_cad]           NVARCHAR (5)   NULL
);


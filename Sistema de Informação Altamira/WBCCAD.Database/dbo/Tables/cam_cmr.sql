CREATE TABLE [dbo].[cam_cmr] (
    [cmr_descricao]           NVARCHAR (40) NULL,
    [cmr_regime]              NVARCHAR (20) NULL,
    [cmr_vlr_multiplicador]   FLOAT (53)    NULL,
    [cmr_vlr_acrescimo]       FLOAT (53)    NULL,
    [cmr_vlr_fixo]            FLOAT (53)    NULL,
    [cmr_temperatura]         INT           NULL,
    [cmr_cor_cad]             INT           NULL,
    [cmr_descricao_abreviada] NVARCHAR (40) NULL,
    [cmr_flag_kcal]           INT           NULL,
    [cmr_lstkcl]              NVARCHAR (40) NULL,
    [RTF_PADRAO]              NVARCHAR (50) NULL,
    [delta]                   INT           NULL,
    [tipo]                    NVARCHAR (2)  NULL,
    [ftk]                     FLOAT (53)    NULL
);


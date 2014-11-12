CREATE TABLE [dbo].[gond_corte_cjtos] (
    [nome_conjunto]    NVARCHAR (100) NULL,
    [qtde_niveis]      INT            NULL,
    [tipo_ins]         INT            NULL,
    [pos_ins]          NVARCHAR (50)  NULL,
    [pos_ins_valor]    INT            NULL,
    [dist_niveis]      INT            NULL,
    [qtde_niveis_min]  INT            NULL,
    [qtde_niveis_max]  INT            NULL,
    [idcorte]          INT            NULL,
    [Var_alt]          NVARCHAR (20)  NULL,
    [Var_Compr]        NVARCHAR (20)  NULL,
    [Var_Prof]         NVARCHAR (20)  NULL,
    [qpn_desc]         NVARCHAR (20)  NULL,
    [qpn_valor]        INT            NULL,
    [tipo_corte]       NVARCHAR (50)  NULL,
    [idGondCorteCjtos] INT            IDENTITY (1, 1) NOT NULL
);


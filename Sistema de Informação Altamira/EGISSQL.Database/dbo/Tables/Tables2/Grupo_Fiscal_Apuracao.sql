CREATE TABLE [dbo].[Grupo_Fiscal_Apuracao] (
    [dt_inicial_opfiscal_apura] DATETIME   NOT NULL,
    [dt_usuario]                DATETIME   NOT NULL,
    [cd_usuario]                INT        NOT NULL,
    [vl_obs_opf_apuracao]       FLOAT (53) NOT NULL,
    [vl_outras_opf_apuracao]    FLOAT (53) NOT NULL,
    [vl_isenta_opf_apuracao]    FLOAT (53) NOT NULL,
    [vl_imposto_opf_apuracao]   FLOAT (53) NOT NULL,
    [vl_basecalc_opf_apuracao]  FLOAT (53) NOT NULL,
    [vl_contabil_opf_apuracao]  FLOAT (53) NOT NULL,
    [cd_grupo_operacao_fiscal]  INT        NOT NULL,
    [cd_imposto]                INT        NOT NULL,
    [dt_final_opfiscal_apuraca] DATETIME   NOT NULL,
    CONSTRAINT [PK_Grupo_Fiscal_Apuracao] PRIMARY KEY CLUSTERED ([dt_inicial_opfiscal_apura] ASC, [cd_grupo_operacao_fiscal] ASC, [cd_imposto] ASC, [dt_final_opfiscal_apuraca] ASC) WITH (FILLFACTOR = 90)
);


CREATE TABLE [dbo].[Parametro_Calculo_Orcamento] (
    [cd_empresa]                INT        NOT NULL,
    [qt_maximo_sobremetal]      FLOAT (53) NOT NULL,
    [qt_sobremetal_padrao_plac] FLOAT (53) NOT NULL,
    [qt_calculo_pi]             FLOAT (53) NOT NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    [qt_comp_min_calc_prep_bas] FLOAT (53) NULL,
    [qt_larg_min_calc_prep_bas] FLOAT (53) NULL,
    [qt_avanco_padrao_acab_bc]  FLOAT (53) NULL,
    [qt_avanco_padrao_desb_bc]  FLOAT (53) NULL,
    [qt_avanco_refrig_mandril]  FLOAT (53) NULL,
    [ic_tipo_calculo_markup]    CHAR (1)   NULL,
    [qt_sobremetal_espes_fresa] FLOAT (53) NULL,
    CONSTRAINT [PK_Parametro_Calculo_Orcamento] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90)
);


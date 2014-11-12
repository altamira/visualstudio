CREATE TABLE [dbo].[Formulario_Layout] (
    [cd_formulario]            INT           NOT NULL,
    [cd_campo_formulario]      INT           NOT NULL,
    [cd_formulario_layout]     INT           NOT NULL,
    [ic_condensado_formulario] CHAR (1)      NULL,
    [ic_negrito_formulario]    CHAR (1)      NULL,
    [ic_enfatizado_formulario] CHAR (1)      NULL,
    [cd_linha_formulario]      INT           NULL,
    [cd_coluna_formulario]     INT           NULL,
    [qt_tamanho_coluna_form]   INT           NULL,
    [qt_tamanho_linha_form]    INT           NULL,
    [ic_alinhamento_form]      CHAR (1)      NULL,
    [nm_proc_form]             VARCHAR (100) NULL,
    [nm_atributo_proc_form]    VARCHAR (60)  NULL,
    [ic_imprime_formulario]    CHAR (1)      NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    CONSTRAINT [PK_Formulario_Layout] PRIMARY KEY CLUSTERED ([cd_formulario] ASC, [cd_campo_formulario] ASC, [cd_formulario_layout] ASC) WITH (FILLFACTOR = 90)
);


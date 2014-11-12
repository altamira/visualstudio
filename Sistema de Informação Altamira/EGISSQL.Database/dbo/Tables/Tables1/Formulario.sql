CREATE TABLE [dbo].[Formulario] (
    [cd_formulario]            INT           NOT NULL,
    [nm_formulario]            VARCHAR (30)  NULL,
    [sg_formulario]            CHAR (10)     NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [ic_condensado]            CHAR (1)      NULL,
    [qt_tamanho_linha]         INT           NULL,
    [qt_tamanho_coluna]        INT           NULL,
    [nm_impressao_formulario]  VARCHAR (150) NULL,
    [nm_impressora_formulario] VARCHAR (150) NULL,
    CONSTRAINT [PK_Formulario] PRIMARY KEY CLUSTERED ([cd_formulario] ASC) WITH (FILLFACTOR = 90)
);


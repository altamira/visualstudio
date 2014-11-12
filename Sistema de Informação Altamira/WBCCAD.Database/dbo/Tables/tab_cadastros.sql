CREATE TABLE [dbo].[tab_cadastros] (
    [indice]          INT           IDENTITY (1, 1) NOT NULL,
    [descr_usu]       NVARCHAR (50) NULL,
    [tabela]          NVARCHAR (50) NULL,
    [uso_interno]     BIT           NULL,
    [tipo_cad]        NVARCHAR (50) NULL,
    [tipo_usar]       NVARCHAR (50) NULL,
    [tab_seg]         NVARCHAR (50) NULL,
    [tab_tab1_tabseg] NVARCHAR (50) NULL,
    [tabela_chave]    NVARCHAR (50) NULL,
    [tab_seg_chave]   NVARCHAR (50) NULL,
    [Campo_ref_tab]   NVARCHAR (50) NULL,
    [Campo_ref_seg]   NVARCHAR (50) NULL,
    [formulario]      NVARCHAR (50) NULL
);


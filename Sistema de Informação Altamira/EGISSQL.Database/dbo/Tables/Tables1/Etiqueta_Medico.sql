CREATE TABLE [dbo].[Etiqueta_Medico] (
    [cd_etiqueta_medico]     INT           NOT NULL,
    [nm_etiqueta_medico]     VARCHAR (60)  NOT NULL,
    [ic_condensado]          CHAR (1)      NULL,
    [cd_linha]               INT           NULL,
    [cd_coluna]              INT           NULL,
    [nm_procedure]           VARCHAR (150) NULL,
    [nm_impressora_etiqueta] VARCHAR (300) NULL,
    [cd_linha_etiqueta]      INT           NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    CONSTRAINT [PK_Etiqueta_Medico] PRIMARY KEY CLUSTERED ([cd_etiqueta_medico] ASC) WITH (FILLFACTOR = 90)
);


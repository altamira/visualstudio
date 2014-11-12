CREATE TABLE [dbo].[Etiqueta_Medico_Campo] (
    [cd_etiqueta_medico]       INT           NOT NULL,
    [cd_etiqueta_medico_campo] INT           NOT NULL,
    [nm_etiqueta_campo]        VARCHAR (40)  NULL,
    [ic_condensa]              CHAR (1)      NULL,
    [ic_enfatizado]            CHAR (1)      NULL,
    [ic_negrito]               CHAR (1)      NULL,
    [cd_linha_campo]           INT           NULL,
    [cd_coluna_campo]          INT           NULL,
    [cd_tamanho_linha]         INT           NULL,
    [cd_tamanho_coluna]        INT           NULL,
    [ic_alinhamento]           CHAR (1)      NULL,
    [nm_atributo]              VARCHAR (40)  NULL,
    [nm_valor_fixo]            VARCHAR (100) NULL,
    [ic_imprime]               CHAR (1)      NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    CONSTRAINT [PK_Etiqueta_Medico_Campo] PRIMARY KEY CLUSTERED ([cd_etiqueta_medico] ASC, [cd_etiqueta_medico_campo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Etiqueta_Medico_Campo_Etiqueta_Medico] FOREIGN KEY ([cd_etiqueta_medico]) REFERENCES [dbo].[Etiqueta_Medico] ([cd_etiqueta_medico])
);


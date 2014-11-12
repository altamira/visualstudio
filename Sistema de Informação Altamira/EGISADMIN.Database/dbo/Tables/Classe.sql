CREATE TABLE [dbo].[Classe] (
    [cd_classe]       INT           NOT NULL,
    [nm_classe]       VARCHAR (50)  NOT NULL,
    [cd_usuario]      INT           NULL,
    [dt_usuario]      DATETIME      NULL,
    [ic_alteracao]    CHAR (1)      NULL,
    [NM_FORM]         VARCHAR (40)  NULL,
    [NM_UNIT]         VARCHAR (40)  NULL,
    [nm_id_classe]    VARCHAR (20)  NULL,
    [nm_form_classe]  VARCHAR (40)  NULL,
    [nm_unit_classe]  VARCHAR (40)  NULL,
    [ds_classe]       TEXT          NULL,
    [nm_fluxo_classe] VARCHAR (100) NULL,
    CONSTRAINT [PK_Classe] PRIMARY KEY CLUSTERED ([cd_classe] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IX_Classe]
    ON [dbo].[Classe]([cd_classe] ASC) WITH (FILLFACTOR = 90);

